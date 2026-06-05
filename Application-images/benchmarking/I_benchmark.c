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
  #define INST_LOOPS 1
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

// ================================================================================
// Inline assembly instruction definitions
// ================================================================================

// Arithmetic Instructions
#define ADD_INST   __asm__ volatile ("add a0, a1, a0\n\t")
#define ADDI_INST  __asm__ volatile ("addi a0, a1, 16\n\t")
#define SUB_INST   __asm__ volatile ("sub a0, a1, a0\n\t")
#define LUI_INST   __asm__ volatile ("lui a0, 16\n\t")
#define AUIPC_INST __asm__ volatile ("auipc a0, 16\n\t")

// Shift Instructions
#define SLL_INST  __asm__ volatile ("sll a0, a1, a2\n\t")
#define SLLI_INST __asm__ volatile ("slli a0, a1, 31\n\t")
#define SRL_INST  __asm__ volatile ("srl a0, a1, a2\n\t")
#define SRLI_INST __asm__ volatile ("srli a0, a1, 31\n\t")
#define SRA_INST  __asm__ volatile ("sra a0, a1, a2\n\t")
#define SRAI_INST __asm__ volatile ("srai a0, a1, 31\n\t")

// Logic Instructions
#define XOR_INST  __asm__ volatile ("xor a0, a1, a0\n\t")
#define XORI_INST __asm__ volatile ("xori a0, a1, 63\n\t")
#define OR_INST   __asm__ volatile ("or a0, a1, a0\n\t")
#define ORI_INST  __asm__ volatile ("ori a0, a1, 63\n\t")
#define AND_INST  __asm__ volatile ("and a0, a1, a0\n\t")
#define ANDI_INST __asm__ volatile ("andi a0, a1, 63\n\t")

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
  
  neorv32_uart0_printf("Configuration:\n");
  neorv32_uart0_printf("  Instruction calls per loop: %d\n", INST_CALLS);
  neorv32_uart0_printf("  Number of loops: %d\n", INST_LOOPS);
  neorv32_uart0_printf("  Total instructions per test: %d\n\n", INST_CALLS * INST_LOOPS);
  
  // Timing variables (use uint32_t for printf compatibility)
  uint32_t startTime, stopTime, elapsed;
  uint32_t totalCycles = 0;
  int instructionsCount = 0;
  
  // Loop counter
  volatile int i;
  
  // Initialize test registers
  __asm__ volatile ("li a0, 0xAAAAAAAA\n\t");
  __asm__ volatile ("li a1, 0x55555555\n\t");
  __asm__ volatile ("li a2, 0x0F0F0F0F\n\t");
  
  // ============================================================================
  // Arithmetic Instructions
  // ============================================================================
  #if TEST_ARITH == 1
  
  neorv32_uart0_printf("================================================\n");
  neorv32_uart0_printf("Arithmetic Instructions\n");
  neorv32_uart0_printf("================================================\n\n");
  
  // ADD
  neorv32_uart0_printf("ADD (add rd, rs1, rs2)\n");
  startTime = neorv32_cpu_csr_read(CSR_MCYCLE);
  for (i = 0; i < INST_LOOPS; i++) {
    REPEAT_INST(ADD_INST);
  }
  stopTime = neorv32_cpu_csr_read(CSR_MCYCLE);
  elapsed = stopTime - startTime;
  totalCycles += elapsed;
  instructionsCount += INST_CALLS * INST_LOOPS;
  neorv32_uart0_printf("  Total cycles: %d\n", (int)elapsed);
  neorv32_uart0_printf("  Avg cycles/inst: %d\n\n", (int)(elapsed / (INST_CALLS * INST_LOOPS)));
  
  // ADDI
  neorv32_uart0_printf("ADDI (addi rd, rs1, imm)\n");
  startTime = neorv32_cpu_csr_read(CSR_MCYCLE);
  for (i = 0; i < INST_LOOPS; i++) {
    REPEAT_INST(ADDI_INST);
  }
  stopTime = neorv32_cpu_csr_read(CSR_MCYCLE);
  elapsed = stopTime - startTime;
  totalCycles += elapsed;
  instructionsCount += INST_CALLS * INST_LOOPS;
  neorv32_uart0_printf("  Total cycles: %d\n", (int)elapsed);
  neorv32_uart0_printf("  Avg cycles/inst: %d\n\n", (int)(elapsed / (INST_CALLS * INST_LOOPS)));
  
  // SUB
  neorv32_uart0_printf("SUB (sub rd, rs1, rs2)\n");
  startTime = neorv32_cpu_csr_read(CSR_MCYCLE);
  for (i = 0; i < INST_LOOPS; i++) {
    REPEAT_INST(SUB_INST);
  }
  stopTime = neorv32_cpu_csr_read(CSR_MCYCLE);
  elapsed = stopTime - startTime;
  totalCycles += elapsed;
  instructionsCount += INST_CALLS * INST_LOOPS;
  neorv32_uart0_printf("  Total cycles: %d\n", (int)elapsed);
  neorv32_uart0_printf("  Avg cycles/inst: %d\n\n", (int)(elapsed / (INST_CALLS * INST_LOOPS)));
  
  // LUI
  neorv32_uart0_printf("LUI (lui rd, imm)\n");
  startTime = neorv32_cpu_csr_read(CSR_MCYCLE);
  for (i = 0; i < INST_LOOPS; i++) {
    REPEAT_INST(LUI_INST);
  }
  stopTime = neorv32_cpu_csr_read(CSR_MCYCLE);
  elapsed = stopTime - startTime;
  totalCycles += elapsed;
  instructionsCount += INST_CALLS * INST_LOOPS;
  neorv32_uart0_printf("  Total cycles: %d\n", (int)elapsed);
  neorv32_uart0_printf("  Avg cycles/inst: %d\n\n", (int)(elapsed / (INST_CALLS * INST_LOOPS)));
  
  // AUIPC
  neorv32_uart0_printf("AUIPC (auipc rd, imm)\n");
  startTime = neorv32_cpu_csr_read(CSR_MCYCLE);
  for (i = 0; i < INST_LOOPS; i++) {
    REPEAT_INST(AUIPC_INST);
  }
  stopTime = neorv32_cpu_csr_read(CSR_MCYCLE);
  elapsed = stopTime - startTime;
  totalCycles += elapsed;
  instructionsCount += INST_CALLS * INST_LOOPS;
  neorv32_uart0_printf("  Total cycles: %d\n", (int)elapsed);
  neorv32_uart0_printf("  Avg cycles/inst: %d\n\n", (int)(elapsed / (INST_CALLS * INST_LOOPS)));
  
  #endif // TEST_ARITH
  
  // ============================================================================
  // Shift Instructions
  // ============================================================================
  #if TEST_SHIFT == 1
  
  neorv32_uart0_printf("================================================\n");
  neorv32_uart0_printf("Shift Instructions\n");
  neorv32_uart0_printf("================================================\n\n");
  
  // SLL
  neorv32_uart0_printf("SLL (sll rd, rs1, rs2)\n");
  startTime = neorv32_cpu_csr_read(CSR_MCYCLE);
  for (i = 0; i < INST_LOOPS; i++) {
    REPEAT_INST(SLL_INST);
  }
  stopTime = neorv32_cpu_csr_read(CSR_MCYCLE);
  elapsed = stopTime - startTime;
  totalCycles += elapsed;
  instructionsCount += INST_CALLS * INST_LOOPS;
  neorv32_uart0_printf("  Total cycles: %d\n", (int)elapsed);
  neorv32_uart0_printf("  Avg cycles/inst: %d\n\n", (int)(elapsed / (INST_CALLS * INST_LOOPS)));
  
  // SLLI
  neorv32_uart0_printf("SLLI (slli rd, rs1, imm)\n");
  startTime = neorv32_cpu_csr_read(CSR_MCYCLE);
  for (i = 0; i < INST_LOOPS; i++) {
    REPEAT_INST(SLLI_INST);
  }
  stopTime = neorv32_cpu_csr_read(CSR_MCYCLE);
  elapsed = stopTime - startTime;
  totalCycles += elapsed;
  instructionsCount += INST_CALLS * INST_LOOPS;
  neorv32_uart0_printf("  Total cycles: %d\n", (int)elapsed);
  neorv32_uart0_printf("  Avg cycles/inst: %d\n\n", (int)(elapsed / (INST_CALLS * INST_LOOPS)));
  
  #endif // TEST_SHIFT
  
  // ============================================================================
  // Logic Instructions
  // ============================================================================
  #if TEST_LOGIC == 1
  
  neorv32_uart0_printf("================================================\n");
  neorv32_uart0_printf("Logic Instructions\n");
  neorv32_uart0_printf("================================================\n\n");
  
  // XOR
  neorv32_uart0_printf("XOR (xor rd, rs1, rs2)\n");
  startTime = neorv32_cpu_csr_read(CSR_MCYCLE);
  for (i = 0; i < INST_LOOPS; i++) {
    REPEAT_INST(XOR_INST);
  }
  stopTime = neorv32_cpu_csr_read(CSR_MCYCLE);
  elapsed = stopTime - startTime;
  totalCycles += elapsed;
  instructionsCount += INST_CALLS * INST_LOOPS;
  neorv32_uart0_printf("  Total cycles: %d\n", (int)elapsed);
  neorv32_uart0_printf("  Avg cycles/inst: %d\n\n", (int)(elapsed / (INST_CALLS * INST_LOOPS)));
  
  #endif // TEST_LOGIC
  
  // ============================================================================
  // Summary
  // ============================================================================
  neorv32_uart0_printf("================================================\n");
  neorv32_uart0_printf("Summary\n");
  neorv32_uart0_printf("================================================\n\n");
  neorv32_uart0_printf("Total instructions tested: %d\n", instructionsCount);
  neorv32_uart0_printf("Total cycles: %d\n", (int)totalCycles);
  
  if (instructionsCount > 0) {
    int avgCycles = totalCycles / instructionsCount;
    int remainder = totalCycles % instructionsCount;
    int fraction = (remainder * 1000) / instructionsCount;
    neorv32_uart0_printf("Average cycles per instruction: %d.%d\n", avgCycles, fraction);
  }
  
  neorv32_uart0_printf("\n================================================\n");
  neorv32_uart0_printf("Benchmark completed!\n");
  neorv32_uart0_printf("================================================\n");
  
  return 0;
}