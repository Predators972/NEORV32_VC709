# NEORV32 VC709 - Environment Setup Guide

## Overview

This guide will allow you to:
1. Configure the Windows/Ubuntu development environment
2. Install the RISC-V toolchain to compile C code
3. Compile C applications using the project's integrated NEORV32 submodule
4. Upload and execute code via the UART bootloader

**Hardware Requirements:**
- VC709 Xilinx board (xc7vx690tffg1761-2)
- USB-to-UART CP210x cable (Silicon Labs)
- Serial terminal (Tera Term, putty, etc.)
- NEORV32 bitstream already programmed on VC709

---

## 1️⃣ Install USB Drivers

### A. Silicon Labs CP210x Driver (Windows)

1. Download the **Silicon Labs CP210x USB to UART Bridge driver**
   - Link: https://www.silabs.com/developers/usb-to-uart-bridge-vcp-drivers
   
2. Install the driver by following the installer wizard

3. Verify in **Device Manager**:
   - Connect the VC709 via USB
   - You should see a COM port (ex: **COM5**)
   - Note the port number for Tera Term

---

## 2️⃣ Configure Ubuntu (Windows Subsystem for Linux)

### A. Install WSL + Ubuntu

1. Install **Ubuntu** from the Microsoft Store
2. Launch Ubuntu and wait for the first installation
3. Create a username and password

### B. Update the system

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential gcc g++ make git wget
```

**Why:** These tools are necessary to compile the NEORV32 project and the toolchain.

---

## 3️⃣ Install the RISC-V Toolchain

The RISC-V toolchain is the compiler that transforms your C code into executable RISC-V binaries that run on the NEORV32 processor.

### Installation

```bash
# 1. Create the installation folder
sudo mkdir /opt/riscv
cd /tmp

# 2. Download the toolchain (version 12.1.0)
wget https://github.com/stnolting/riscv-gcc-prebuilt/releases/download/rv32i-4.0.0/riscv32-unknown-elf.gcc-12.1.0.tar.gz

# 3. Extract into /opt/riscv
sudo tar -xzf riscv32-unknown-elf.gcc-12.1.0.tar.gz -C /opt/riscv/

# 4. Add to PATH permanently
echo 'export PATH="/opt/riscv/bin:$PATH"' >> ~/.bashrc
echo 'export RISCV_PREFIX=riscv32-unknown-elf-' >> ~/.bashrc

# 5. Reload the configuration
source ~/.bashrc

# 6. Verify the installation
riscv32-unknown-elf-gcc --version
```

You should see: **gcc version 12.1.0**

---

## 4️⃣ Clone the Project Repository

```bash
# 1. Clone the main repository (includes NEORV32 v1.8.2 as submodule)
cd ~
git clone --recurse-submodules https://github.com/Predators972/NEORV32_VC709.git
cd NEORV32_VC709
```

If you already cloned it and forgot the `--recurse-submodules`, initialize the submodule with:

```bash
git submodule update --init --recursive
```

**Note:** The `Application-images/neorv32/` folder contains NEORV32 v1.8.2 as a submodule. You don't need to clone it separately.

---

## 5️⃣ Compile a C Program

### Method 1: Using Project Applications (Requires Submodule)

Compile your own applications and examples directly from the `Application-images/` folder. This method requires the NEORV32 submodule to be initialized.

**Project Structure:**

```
NEORV32_VC709/
│
├── Application-images/
│   ├── 0_blink_led_terminal_access/
│   ├── 0_Fibonacci/
│   ├── 0_quick_sort/
│   ├── Bootloader_Upload_Tool/      # Submodule: UART bootloader upload utility
│   ├── benchmarking/
│   ├── neorv32/                     # Submodule: NEORV32 v1.8.2
│   └── xadc_uart_leds/
```

**Compile an example:**

```bash
# Navigate to an application folder
cd ~/NEORV32_VC709/Application-images/0_blink_led_terminal_access/

# Compile
make clean_all exe

# Verify that the binary is generated
ls -la *.bin
```

You should see: **neorv32_exe.bin** (a few KB)

**Compile your own code:**

```bash
# 1. Create a folder for your project in Application-images/
mkdir ~/NEORV32_VC709/Application-images/my_example
cd ~/NEORV32_VC709/Application-images/my_example

# 2. Copy your main.c file
cp /path/to/your_code.c main.c

# 3. Compile
make clean_all exe

# 4. Verify that the binary is generated
ls *.bin
```

Wait for compilation to finish. You should see:
Compiling ... Executable ...

---

### Method 2: Using Original NEORV32 Examples (Optional)

You can also compile the official NEORV32 v1.8.2 examples from the submodule:

```bash
# Navigate to an original NEORV32 example
cd ~/NEORV32_VC709/Application-images/neorv32/sw/example/demo_blink_led/

# Compile
make clean_all exe

# Verify that the binary is generated
ls -la *.bin
```

**Both methods work!** Use whichever is more convenient for your testing.

**Alternative (if submodule not available):**

If you don't have the submodule or prefer to work independently, clone NEORV32 v1.8.2 separately:

```bash
# Clone version v1.8.2 (the current version on the VC709 board)
cd ~
git clone --branch v1.8.2 https://github.com/stnolting/neorv32.git
cd ~/neorv32/sw/example/demo_blink_led
make clean_all exe
```

---

## 6️⃣ Upload via UART Bootloader

**Note:** There is an optional automated bootloader upload tool available in the project. For a simplified upload process, see [Bootloader_Upload_Tool/README.md](../Application-images/Bootloader_Upload_Tool/README.md). The following steps show the manual UART bootloader method.  
The UART bootloader allows you to program code into the VC709's internal memory without reprogramming the FPGA.

### A. Connect the VC709

1. Connect the USB cable to the VC709
2. Verify the COM port in **Device Manager**

### B. Open a serial terminal (Tera Term)

1. **File** → **New Connection**
2. Select the COM port (ex: COM5)
3. Click **OK**

### C. Configure the serial port

1. **Setup** → **Serial Port**
   - **Baud rate**: 19200
   - **Data bits**: 8
   - **Stop bits**: 1
   - **Parity**: None
2. Click **OK**

### D. Launch the bootloader

1. Press the **RESET** button on the VC709 using switch 1 on SW2
2. You should see in Tera Term:
```
<< NEORV32 Bootloader >>

BLDV: Mar 16 2023
HWV:  0x01080206
CID:  0x00000000
CLK:  0x02faf080
MISA: 0x40801104
XISA: 0x00000081
SOC:  0x0007000d
IMEM: 0x00040000 bytes @0x00000000
DMEM: 0x00004000 bytes @0x80000000

Autoboot in 8s. Press any key to abort.
```

### E. Stop autoboot and enter upload mode

1. Press **any key** before 8 seconds to stop autoboot
```
Aborted.

Available CMDs:
 h: Help
 r: Restart
 u: Upload
 s: Store to flash
 l: Load from flash
 x: Boot from flash (XIP)
 e: Execute
```

2. Type **`u`** to enter upload mode
```
CMD:> u
Awaiting neorv32_exe.bin...
```

### F. Send the binary file

1. In Tera Term: **File** → **Send File**
2. Select your `neorv32_exe.bin` file
3. Verify that **Binary** is checked
4. Click **Open** and wait
```
[xxxxxxxx] OK
```

Or drag and drop the file and check **Binary**

### G. Execute the program

1. Once upload is complete, type **`e`** (execute)
```
CMD:> e
Booting from 0x00000000...
```

2. Your program is now running! 🚀

---

## 7️⃣ Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| COM port not found | Check Device Manager, reconnect USB |
| `riscv32-unknown-elf-gcc: command not found` | Run `source ~/.bashrc` or restart the terminal |
| `make: command not found` | Install: `sudo apt install -y make` |
| Bootloader doesn't appear on reset | Verify baudrate (19200), check VC709 power |
| `neorv32_exe.bin` not generated | Search for "error" in `make` output, check submodules initialized |
| Program doesn't execute after upload | Verify upload was "OK", try relaunching bootloader |

---

## 📝 Important Notes

- **Bootloader baudrate**: Always **19200 baud**, not 115200
- **Binary format**: Check **Binary** when sending file
- **Timeout**: If upload times out, restart from RESET
- **Submodules**: Make sure you initialized submodules with `git submodule update --init --recursive`
- **Persistent PATH**: If you close Ubuntu, run `source ~/.bashrc` on restart

---

## 📚 Appendix: Additional Resources

For more detailed information about the RISC-V toolchain and bootloader operation, see the reference documentation: [RISCV_Processor_Overview_and_UART.pdf](./RISCV_Processor_Overview_and_UART.pdf)