// ================================================================================
// RISC-V I Instruction Timing Benchmark
// Adapted for NEORV32 v1.8.2 on Xilinx VC709 FPGA
// 
// Measures the execution cycles of RISC-V base integer (I) instructions
// ================================================================================

#include <neorv32.h>

#define BAUD_RATE 19200

// ================================================================================
// Configuration
// ================================================================================

// Number of instruction repetitions (adjust for memory constraints)
#ifndef INST_CALLS
  #define INST_CALLS 256
#endif

// Number of outer loops
#ifndef INST_LOOPS
  #define INST_LOOPS 100
#endif

// Instruction groups to test (set to 1 to enable)
#ifndef TEST_ARITH
  #define TEST_ARITH 1
#endif
#ifndef TEST_SHIFT
  #define TEST_SHIFT 1
#endif
#ifndef TEST_LOGIC
  #define TEST_LOGIC 1
#endif

// ================================================================================
// Macros for instruction repetition
// ================================================================================

#define REPEAT_4(instr)   instr; instr; instr; instr;
#define REPEAT_16(instr)  REPEAT_4(instr); REPEAT_4(instr); REPEAT_4(instr); REPEAT_4(instr);
#define REPEAT_64(instr)  REPEAT_16(instr); REPEAT_16(instr); REPEAT_16(instr); REPEAT_16(instr);
#define REPEAT_256(instr) REPEAT_64(instr); REPEAT_64(instr); REPEAT_64(instr); REPEAT_64(instr);

// Select repetition count based on INST_CALLS
#if INST_CALLS == 16
  #define REPEAT_INST(instr) REPEAT_16(instr)
#elif INST_CALLS == 64
  #define REPEAT_INST(instr) REPEAT_64(instr)
#elif INST_CALLS == 256
  #define REPEAT_INST(instr) REPEAT_256(instr)
#else
  #error "INST_CALLS must be 16, 64, or 256"
#endif

/*******************************************************************************
 * Inline assembly instruction definitions
 * "r":   input register (read)
 * "=r":  output register (write)
 * "i":   immediate value (known at compile time)
 * shamt: shift amount (0 to 31)
 ******************************************************************************/

#define NOP_INST                     __asm__ volatile ("nop\n\t")

// Arithmetic Instructions
#define ADD_INST(dest, src1, src2)   __asm__ volatile ("add %0, %1, %2\n\t"   : "=r" (dest) : "r" (src1), "r" (src2))
#define ADDI_INST(dest, src1, imm)   __asm__ volatile ("addi %0, %1, %2\n\t"  : "=r" (dest) : "r" (src1), "i" (imm))
#define SUB_INST(dest, src1, src2)   __asm__ volatile ("sub %0, %1, %2\n\t"   : "=r" (dest) : "r" (src1), "r" (src2))
#define LUI_INST(dest, imm)          __asm__ volatile ("lui %0, %1\n\t"       : "=r" (dest) : "i" (imm))
#define AUIPC_INST(dest, imm)        __asm__ volatile ("auipc %0, %1\n\t"     : "=r" (dest) : "i" (imm))

// Shift Instructions
#define SLL_INST(dest, src1, src2)   __asm__ volatile ("sll %0, %1, %2\n\t"   : "=r" (dest) : "r" (src1), "r" (src2))
#define SLLI_INST(dest, src1, shamt) __asm__ volatile ("slli %0, %1, %2\n\t"  : "=r" (dest) : "r" (src1), "i" (shamt))
#define SRL_INST(dest, src1, src2)   __asm__ volatile ("srl %0, %1, %2\n\t"   : "=r" (dest) : "r" (src1), "r" (src2))
#define SRLI_INST(dest, src1, shamt) __asm__ volatile ("srli %0, %1, %2\n\t"  : "=r" (dest) : "r" (src1), "i" (shamt))
#define SRA_INST(dest, src1, src2)   __asm__ volatile ("sra %0, %1, %2\n\t"   : "=r" (dest) : "r" (src1), "r" (src2))
#define SRAI_INST(dest, src1, shamt) __asm__ volatile ("srai %0, %1, %2\n\t"  : "=r" (dest) : "r" (src1), "i" (shamt))
// Logic Instructions
#define XOR_INST(dest, src1, src2)   __asm__ volatile ("xor %0, %1, %2\n\t"   : "=r" (dest) : "r" (src1), "r" (src2))
#define XORI_INST(dest, src1, imm)   __asm__ volatile ("xori %0, %1, %2\n\t"  : "=r" (dest) : "r" (src1), "i" (imm))
#define OR_INST(dest, src1, src2)    __asm__ volatile ("or %0, %1, %2\n\t"    : "=r" (dest) : "r" (src1), "r" (src2))
#define ORI_INST(dest, src1, imm)    __asm__ volatile ("ori %0, %1, %2\n\t"   : "=r" (dest) : "r" (src1), "i" (imm))
#define AND_INST(dest, src1, src2)   __asm__ volatile ("and %0, %1, %2\n\t"   : "=r" (dest) : "r" (src1), "r" (src2))
#define ANDI_INST(dest, src1, imm)   __asm__ volatile ("andi %0, %1, %2\n\t"  : "=r" (dest) : "r" (src1), "i" (imm))

typedef struct
{
  const char * name;
  uint32_t total_cycles;
  uint32_t avg_cycles_per_inst;  
} inst_benchmark_result_t;

// Store calibrated overhead
uint32_t loop_overhead_cycles = 0;


// ===============================================================================
// Benchmark Macro
// ===============================================================================
/**
 * @brief Measure instruction execution time
 * 
 * @param[in,out] bench_res_ptr Pointer to a inst_benchmark_result_t struct that stores test results
 * @param[in] inst Inline macro of the instruction to test
 */
#define BENCHMARK_INST(bench_res_ptr, inst) ({                                 \
  /* Timing variables (use uint32_t for printf compatibility) */                                                       \
  uint32_t start_time, stop_time, elapsed;                                     \
                                                                               \
  /* Test */                                                                   \
  start_time = neorv32_cpu_csr_read(CSR_MCYCLE);                               \
  for (volatile int i = 0; i < INST_LOOPS; i++) {                              \
    REPEAT_INST(inst);                                                         \
  }                                                                            \
  stop_time = neorv32_cpu_csr_read(CSR_MCYCLE);                                \
  elapsed = stop_time - start_time;                                            \
  if (elapsed > loop_overhead_cycles) {                                        \
    elapsed -= loop_overhead_cycles;                                           \
  } else if (loop_overhead_cycles != 0) {                                      \
    elapsed = 0;                                                               \
  }                                                                            \
                                                                               \
  /* Update struct containing results */                                       \
  (bench_res_ptr)->total_cycles = elapsed;                                     \
  (bench_res_ptr)->avg_cycles_per_inst = (int)(elapsed / (INST_CALLS * INST_LOOPS)); \
})

// ================================================================================
// Benchmark results display function
// ================================================================================
void print_benchmark_result(const inst_benchmark_result_t* res)
{
  neorv32_uart0_printf("%s\n", res->name);
  neorv32_uart0_printf("  Total cycles: %u\n", res->total_cycles);
  neorv32_uart0_printf("  Avg cycles/inst: %d\n\n", res->avg_cycles_per_inst);
}

// ================================================================================
// Main benchmark function
// ================================================================================

int main(void) {
  
  // Setup UART
  neorv32_uart0_setup(BAUD_RATE, 0);
  
  neorv32_uart0_printf("\n================================================\n");
  neorv32_uart0_printf("RISC-V I Instruction Timing Benchmark\n");
  neorv32_uart0_printf("NEORV32 v1.8.2 on VC709\n");
  neorv32_uart0_printf("================================================\n\n");
  
  // ============================================================================
  // Loop Overhead Calibration
  // ============================================================================
  inst_benchmark_result_t calibration_bench = { .name = "Calibration (Loop + NOPs)" };
  BENCHMARK_INST(&calibration_bench, NOP_INST); // nop instruction is 1 cycle
  uint32_t total_nops = INST_CALLS * INST_LOOPS;
  if (calibration_bench.total_cycles > total_nops) {
    loop_overhead_cycles = calibration_bench.total_cycles - total_nops;
  } else {
    loop_overhead_cycles = 0;
  }

  neorv32_uart0_printf("Configuration:\n");
  neorv32_uart0_printf("  Instruction calls per loop: %d\n", INST_CALLS);
  neorv32_uart0_printf("  Number of loops: %d\n", INST_LOOPS);
  neorv32_uart0_printf("  Total instructions per test: %d\n", INST_CALLS * INST_LOOPS);
  neorv32_uart0_printf("  Measured loop overhead: %d cycles\n\n", loop_overhead_cycles);
  
  // Initialize test values
  uint32_t val1 = 0xAAAAAAAA;
  uint32_t val2 = 0x55555555;
  uint32_t result = 0;

  // Counters for final report summary
  uint32_t instructions_count = 0;
  uint32_t total_cycles = 0;
  
  // ============================================================================
  // Arithmetic Instructions
  // ============================================================================
  #if TEST_ARITH == 1
  neorv32_uart0_printf("================================================\n");
  neorv32_uart0_printf("Arithmetic Instructions\n");
  neorv32_uart0_printf("================================================\n\n");
  
  inst_benchmark_result_t bench_add = { .name = "ADD (add rd, rs1, rs2)" };
  BENCHMARK_INST(&bench_add, ADD_INST(result, val1, val2));
  print_benchmark_result(&bench_add);
  
  inst_benchmark_result_t bench_addi = { .name = "ADDI (addi rd, rs1, imm)" };
  BENCHMARK_INST(&bench_addi, ADDI_INST(result, val1, 16));
  print_benchmark_result(&bench_addi);
  
  inst_benchmark_result_t bench_sub = { .name = "SUB (sub rd, rs1, rs2)" };
  BENCHMARK_INST(&bench_sub, SUB_INST(result, val1, val2));
  print_benchmark_result(&bench_sub);
  
  inst_benchmark_result_t bench_lui = { .name = "LUI (lui rd, imm)" };
  BENCHMARK_INST(&bench_lui, LUI_INST(result, 16));
  print_benchmark_result(&bench_lui);
  
  inst_benchmark_result_t bench_auipc = { .name = "AUIPC (auipc rd, imm)" };
  BENCHMARK_INST(&bench_auipc, AUIPC_INST(result, 16));
  print_benchmark_result(&bench_auipc);

  total_cycles += bench_add.total_cycles + bench_addi.total_cycles + bench_sub.total_cycles + bench_lui.total_cycles + bench_auipc.total_cycles;
  instructions_count += (5 * INST_CALLS * INST_LOOPS);
  #endif // TEST_ARITH
  
  // ============================================================================
  // Shift Instructions
  // ============================================================================
  #if TEST_SHIFT == 1
  neorv32_uart0_printf("================================================\n");
  neorv32_uart0_printf("Shift Instructions\n");
  neorv32_uart0_printf("================================================\n\n");
  
  inst_benchmark_result_t bench_sll = { .name = "SLL (sll rd, rs1, rs2)" };
  BENCHMARK_INST(&bench_sll, SLL_INST(result, val1, val2));
  print_benchmark_result(&bench_sll);
  
  inst_benchmark_result_t bench_slli = { .name = "SLLI (slli rd, rs1, shamt)" };
  BENCHMARK_INST(&bench_slli, SLLI_INST(result, val1, 15));
  print_benchmark_result(&bench_slli);
  
  inst_benchmark_result_t bench_srl = { .name = "SRL (srl rd, rs1, rs2)" };
  BENCHMARK_INST(&bench_srl, SRL_INST(result, val1, val2));
  print_benchmark_result(&bench_srl);
  
  inst_benchmark_result_t bench_srli = { .name = "SRLI (srli rd, rs1, shamt)" };
  BENCHMARK_INST(&bench_srli, SRLI_INST(result, val1, 15));
  print_benchmark_result(&bench_srli);
  
  inst_benchmark_result_t bench_sra = { .name = "SRA (sra rd, rs1, rs2)" };
  BENCHMARK_INST(&bench_sra, SRA_INST(result, val1, val2));
  print_benchmark_result(&bench_sra);
  
  inst_benchmark_result_t bench_srai = { .name = "SRAI (srai rd, rs1, shamt)" };
  BENCHMARK_INST(&bench_srai, SRAI_INST(result, val1, 15));
  print_benchmark_result(&bench_srai);

  total_cycles += bench_sll.total_cycles + bench_slli.total_cycles + bench_srl.total_cycles + bench_srli.total_cycles + bench_sra.total_cycles + bench_srai.total_cycles;
  instructions_count += (6 * INST_CALLS * INST_LOOPS);
  #endif // TEST_SHIFT
  
  // ============================================================================
  // Logic Instructions
  // ============================================================================
  #if TEST_LOGIC == 1
  neorv32_uart0_printf("================================================\n");
  neorv32_uart0_printf("Logic Instructions\n");
  neorv32_uart0_printf("================================================\n\n");
  
  inst_benchmark_result_t bench_xor = { .name = "XOR (xor rd, rs1, rs2)" };
  BENCHMARK_INST(&bench_xor, XOR_INST(result, val1, val2));
  print_benchmark_result(&bench_xor);
  
  inst_benchmark_result_t bench_xori = { .name = "XORI (xori rd, rs1, imm)" };
  BENCHMARK_INST(&bench_xori, XORI_INST(result, val1, 63));
  print_benchmark_result(&bench_xori);
  
  inst_benchmark_result_t bench_or = { .name = "OR (or rd, rs1, rs2)" };
  BENCHMARK_INST(&bench_or, OR_INST(result, val1, val2));
  print_benchmark_result(&bench_or);
  
  inst_benchmark_result_t bench_ori = { .name = "ORI (ori rd, rs1, imm)" };
  BENCHMARK_INST(&bench_ori, ORI_INST(result, val1, 63));
  print_benchmark_result(&bench_ori);
  
  inst_benchmark_result_t bench_and = { .name = "AND (and rd, rs1, rs2)" };
  BENCHMARK_INST(&bench_and, AND_INST(result, val1, val2));
  print_benchmark_result(&bench_and);
  
  inst_benchmark_result_t bench_andi = { .name = "ANDI (andi rd, rs1, imm)" };
  BENCHMARK_INST(&bench_andi, ANDI_INST(result, val1, 63));
  print_benchmark_result(&bench_andi);

  total_cycles += bench_xor.total_cycles + bench_xori.total_cycles + bench_or.total_cycles + bench_ori.total_cycles + bench_and.total_cycles + bench_andi.total_cycles;
  instructions_count += (6 * INST_CALLS * INST_LOOPS);
  #endif // TEST_LOGIC
  
  // ============================================================================
  // Summary
  // ============================================================================
  neorv32_uart0_printf("================================================\n");
  neorv32_uart0_printf("Summary\n");
  neorv32_uart0_printf("================================================\n\n");
  neorv32_uart0_printf("Total instructions tested: %u\n", instructions_count);
  neorv32_uart0_printf("Total cycles: %u\n", total_cycles);
  
  if (instructions_count > 0) {
    int avg_cycles = total_cycles / instructions_count;
    int remainder = total_cycles % instructions_count;
    int fraction = (remainder * 1000) / instructions_count;
    neorv32_uart0_printf("Average cycles per instruction: %d.%d\n", avg_cycles, fraction);
  }
  
  neorv32_uart0_printf("\n================================================\n");
  neorv32_uart0_printf("Benchmark completed!\n");
  neorv32_uart0_printf("================================================\n");
  
  return 0;
}