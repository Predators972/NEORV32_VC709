# RISC-V Processor Benchmarking on FPGA

## Project Overview

This repository contains a **Summer Internship Project** focused on **developing and evaluating signal processing applications on a RISC-V processor** implemented on an FPGA platform.

### Project Objectives

1. **Understand RISC-V Architecture & Tools**
   - Gain familiarity with RISC-V ISA (Instruction Set Architecture)
   - Learn FPGA-based system integration
   - Master software development workflow on embedded systems

2. **ADC Integration & Analog Signal Acquisition**
   - Simulate XADC behavior in testbench
   - Integrate XADC with RISC-V processor via GPIO interface
   - Test ADC functionality with analog inputs
   - Verify data acquisition and conversion accuracy

3. **Benchmarking & Performance Evaluation**
   - Select suitable signal processing algorithms for testing
   - Implement and test algorithms on RISC-V processor
   - Measure execution speed and real-time performance capabilities
   - Compare different implementation strategies and optimize code
   - Profile CPU utilization and efficiency

### Current Status
- ✅ RISC-V setup and basic examples working
- ✅ UART bootloader integration complete
- ✅ ADC (XADC) simulation, integration and testing completed
- ⏳ Signal processing algorithm implementation (in progress)
- ⏳ Benchmarking framework and metrics (upcoming)

---

## Project Context

This internship builds upon an **existing VC709 FPGA project** that originally focused on **Fault Injection Testing (FIT)** for RISC-V processors. The current work extends this platform to:

- Add analog signal acquisition capabilities
- Develop signal processing benchmarks
- Evaluate real-time performance
- Create a reusable evaluation platform

**Host Platform**: Xilinx VC709 (Virtex-7 FPGA)  
**Processor**: NEORV32 RISC-V v1.8.2  

## Contributors

### Current Team (Summer 2026)
 

- **[Johan](https://github.com/Predators972)** (May - July 2026)
- **[Damien](https://github.com/Damien-Bureau)** (June - August 2026)

### Supervisors/Mentors
- Jim Harkin - Project Supervisor
- Ulster University  - Host Institution

### Previous Work
This project builds on the **RISCV_FT_UART** platform developed in prior work, with ADC integration as a new feature.

---

## Directory Structure

```
NEORV32_VC709/
│
├── Application-images/              # C applications for RISC-V benchmarking
│   ├── 0_blink_led_terminal_access/ # Example: Basic I/O control
│   ├── 0_Fibonacci/                 # Example: Integer computation
│   ├── 0_quick_sort/                # Example: Algorithm benchmark
│   ├── xadc_uart_leds/              # ADC → UART + LED
│
├── RISCV_FT_UART_original/          # FPGA design (Vivado project)
│   ├── Constraints/                 # Pin assignments & timing
│   ├── riscv_ft_uart/               # Vivado project files
│   └── RTL/                         # VHDL source files
│
├── Documentation/                   # Project documentation
│
└── README.md                        # This file
```

---

## Quick Start

### Prerequisites
- Xilinx Vivado 2023.2
- RISC-V GCC Toolchain
- VC709 Board + USB-UART cable
- Serial terminal (Tera Term)

### Setup (10 minutes)
See detailed guides in the [Documentation](Documentation) folder  
Follow instruction in the first documentation [ENVIRONMENT_Toolchain_Bootloader.md](Documentation\ENVIRONMENT_Toolchain_Bootloader.md)

---

## Hardware Configuration

### VC709 Platform
- **FPGA**: Xilinx Virtex-7 (xc7vx690tffg1761-2)
- **CPU**: NEORV32 RISC-V (100 MHz)
- **Memory**: 16 KB instruction + 8 KB data
- **Peripherals**: UART, GPIO (64-bit), ADC
- **Clock**: 100 MHz (from Si5338 oscillator)

### ADC Specifications
- **Type**: Xilinx XADC (internal to Virtex-7)
- **Resolution**: 12-bit
- **Input Range**: 0 to 1.0V (VP/VN dedicated pins)
- **Sampling**: Up to 1 MSPS (continuous)
- **Interface**: DRP (Dynamic Reconfiguration Port)

---

## Software Stack

### Development Languages
- **C**: Application development (RISC-V programs)
- **VHDL**: Hardware integration (FPGA design)

### Key Libraries & APIs
- **NEORV32 Library**: CPU peripheral access (GPIO, UART, timers)
- **Standard C Library**: Math functions, string operations

### Development Tools
- **Vivado 2024.2**: FPGA design and implementation
- **RISC-V GCC 12.1.0**: C compiler and linker
- **Make**: Build automation

---

## References

### RISC-V & NEORV32
- **NEORV32 Repository**: https://github.com/stnolting/neorv32
- **NEORV32 Datasheet**: https://stnolting.github.io/neorv32/
- **NEORV32 User Guide**: https://stnolting.github.io/neorv32/ug/

### FPGA & Xilinx
- **Xilinx Vivado**: https://www.xilinx.com/products/design-tools/vivado.html
- **VC709 Board Manual**: https://docs.amd.com/v/u/en-US/ug887-vc709-eval-board-v7-fpga
- **XADC Guide**: https://docs.amd.com/api/khub/documents/fiHyFFFNQOuYbS0gDdL34A/content?Ft-Calling-App=ft%2Fturnkey-portal&Ft-Calling-App-Version=5.3.8#page=36&zoom=100,122,509

### Tools
- **RISC-V GCC Toolchain**: https://github.com/stnolting/riscv-gcc-prebuilt
- **Bootloader Upload Tool**: https://github.com/Damien-Bureau/neorv32-serial-runner

---

**Project Status**: Active  
**Last Updated**: 06/2026  
**Version**: 1.0