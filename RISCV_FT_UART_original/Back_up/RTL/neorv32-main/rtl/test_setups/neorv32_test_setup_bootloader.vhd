-- #################################################################################################
-- # << NEORV32 - Test Setup using the default UART-Bootloader to upload and run executables >>    #
-- # ********************************************************************************************* #
-- # BSD 3-Clause License                                                                          #
-- #                                                                                               #
-- # Copyright (c) 2023, Stephan Nolting. All rights reserved.                                     #
-- #                                                                                               #
-- # Redistribution and use in source and binary forms, with or without modification, are          #
-- # permitted provided that the following conditions are met:                                     #
-- #                                                                                               #
-- # 1. Redistributions of source code must retain the above copyright notice, this list of        #
-- #    conditions and the following disclaimer.                                                   #
-- #                                                                                               #
-- # 2. Redistributions in binary form must reproduce the above copyright notice, this list of     #
-- #    conditions and the following disclaimer in the documentation and/or other materials        #
-- #    provided with the distribution.                                                            #
-- #                                                                                               #
-- # 3. Neither the name of the copyright holder nor the names of its contributors may be used to  #
-- #    endorse or promote products derived from this software without specific prior written      #
-- #    permission.                                                                                #
-- #                                                                                               #
-- # THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS   #
-- # OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF               #
-- # MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE    #
-- # COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,     #
-- # EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE #
-- # GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED    #
-- # AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING     #
-- # NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED  #
-- # OF THE POSSIBILITY OF SUCH DAMAGE.                                                            #
-- # ********************************************************************************************* #
-- # The NEORV32 RISC-V Processor - https://github.com/stnolting/neorv32                           #
-- #################################################################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library fault_inj_lib;
use fault_inj_lib.fault_injection_package.all;


library neorv32;
use neorv32.neorv32_package.all;

entity neorv32_test_setup_bootloader is
  generic (
    FAULT_INJ_SYNC_0  : boolean:= true; --Location 1
    FAULT_INJ_SYNC_1  : boolean:= true;
    FAULT_INJ_SYNC_2  : boolean:= true;
    FAULT_INJ_SYNC_3  : boolean:= true;
    FAULT_INJ_SYNC_4  : boolean:= true;
    FAULT_INJ_SYNC_5  : boolean:= true; 
    FAULT_INJ_SYNC_6  : boolean:= true;
    FAULT_INJ_SYNC_7  : boolean:= true;
    FAULT_INJ_COMB_0  : boolean:= true;
    FAULT_INJ_COMB_1  : boolean:= true;
    FAULT_INJ_COMB_2  : boolean:= true;
    FAULT_INJ_COMB_3  : boolean:= true;
    FAULT_INJ_COMB_4  : boolean:= true;
    FAULT_INJ_COMB_5  : boolean:= true; 
    FAULT_INJ_COMB_6  : boolean:= true;
    FAULT_INJ_COMB_7  : boolean:= true;
    FAULT_INJ_SYNC_8  : boolean:= true; --Location 2
    FAULT_INJ_SYNC_9  : boolean:= true;
    FAULT_INJ_SYNC_10 : boolean:= true;
    FAULT_INJ_SYNC_11 : boolean:= true;
    FAULT_INJ_SYNC_12 : boolean:= true;
    FAULT_INJ_SYNC_13 : boolean:= true; 
    FAULT_INJ_SYNC_14 : boolean:= true;
    FAULT_INJ_SYNC_15 : boolean:= true;
    FAULT_INJ_COMB_8  : boolean:= true; 
    FAULT_INJ_COMB_9  : boolean:= true;
    FAULT_INJ_COMB_10 : boolean:= true;
    FAULT_INJ_COMB_11 : boolean:= true;
    FAULT_INJ_COMB_12 : boolean:= true;
    FAULT_INJ_COMB_13 : boolean:= true; 
    FAULT_INJ_COMB_14 : boolean:= true;
    FAULT_INJ_COMB_15 : boolean:= true;
    FAULT_INJ_SYNC_16 : boolean:= true; --Location 3
    FAULT_INJ_SYNC_17 : boolean:= true;
    FAULT_INJ_SYNC_18 : boolean:= true;
    FAULT_INJ_SYNC_19 : boolean:= true;
    FAULT_INJ_SYNC_20 : boolean:= true;
    FAULT_INJ_SYNC_21 : boolean:= true; 
    FAULT_INJ_SYNC_22 : boolean:= true;
    FAULT_INJ_SYNC_23 : boolean:= true;
    FAULT_INJ_COMB_16 : boolean:= true;
    FAULT_INJ_COMB_17 : boolean:= true;
    FAULT_INJ_COMB_18 : boolean:= true;
    FAULT_INJ_COMB_19 : boolean:= true;
    FAULT_INJ_COMB_20 : boolean:= true;
    FAULT_INJ_COMB_21 : boolean:= true; 
    FAULT_INJ_COMB_22 : boolean:= true;
    FAULT_INJ_COMB_23 : boolean:= true;
    -- adapt these for your setup --
    CLOCK_FREQUENCY   : natural := 100000000; -- clock frequency of clk_i in Hz
    MEM_INT_IMEM_SIZE : natural := 16*1024;   -- size of processor-internal instruction memory in bytes
    MEM_INT_DMEM_SIZE : natural := 8*1024     -- size of processor-internal data memory in bytes
  );
  port (
    -- Global control --
    clk_i       : in  std_ulogic; -- global clock, rising edge
    rstn_i      : in  std_ulogic; -- global reset, low-active, async
    -- GPIO --
    gpio_o      : out std_ulogic_vector(7 downto 0); -- parallel output
	----------------fault injection control signals-----------------
    in_comb_fault_inj_en  : in comb_fault_enable_t;
    in_sync_fault_inj_en  : in sync_fault_enable_t;
    out_comb_fault_status : out std_logic_vector (23 downto 0);--fault_status_comb_t;
    out_sync_fault_status : out std_logic_vector (23 downto 0); --fault_status_sync_t
    out_spike_comb  : out std_logic_vector (5 downto 0);
    out_spike_sync  : out std_logic_vector (5 downto 0);
    -- UART0 --
    uart0_txd_o : out std_ulogic; -- UART0 send data
    uart0_rxd_i : in  std_ulogic  -- UART0 receive data
  );
end entity;

architecture neorv32_test_setup_bootloader_rtl of neorv32_test_setup_bootloader is

  signal con_gpio_o : std_ulogic_vector(63 downto 0);
  attribute keep : boolean; 
  attribute  keep of con_gpio_o : signal is true;

begin

  -- The Core Of The Problem ----------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  neorv32_top_inst: neorv32_top
  generic map (
    FAULT_INJ_SYNC_0    => FAULT_INJ_SYNC_0,
    FAULT_INJ_SYNC_1    => FAULT_INJ_SYNC_1,
    FAULT_INJ_SYNC_2    => FAULT_INJ_SYNC_2,
    FAULT_INJ_SYNC_3    => FAULT_INJ_SYNC_3,
    FAULT_INJ_SYNC_4    => FAULT_INJ_SYNC_4, 
    FAULT_INJ_SYNC_5    => FAULT_INJ_SYNC_5, 
    FAULT_INJ_SYNC_6    => FAULT_INJ_SYNC_6, 
    FAULT_INJ_SYNC_7    => FAULT_INJ_SYNC_7,
    FAULT_INJ_SYNC_8    => FAULT_INJ_SYNC_8,
    FAULT_INJ_SYNC_9    => FAULT_INJ_SYNC_9,
    FAULT_INJ_SYNC_10   => FAULT_INJ_SYNC_10,
    FAULT_INJ_SYNC_11   => FAULT_INJ_SYNC_11,
    FAULT_INJ_SYNC_12   => FAULT_INJ_SYNC_12, 
    FAULT_INJ_SYNC_13   => FAULT_INJ_SYNC_13, 
    FAULT_INJ_SYNC_14   => FAULT_INJ_SYNC_14, 
    FAULT_INJ_SYNC_15   => FAULT_INJ_SYNC_15,
    FAULT_INJ_SYNC_16   => FAULT_INJ_SYNC_16,
    FAULT_INJ_SYNC_17   => FAULT_INJ_SYNC_17,
    FAULT_INJ_SYNC_18   => FAULT_INJ_SYNC_18,
    FAULT_INJ_SYNC_19   => FAULT_INJ_SYNC_19,
    FAULT_INJ_SYNC_20   => FAULT_INJ_SYNC_20,
    FAULT_INJ_SYNC_21   => FAULT_INJ_SYNC_21, 
    FAULT_INJ_SYNC_22   => FAULT_INJ_SYNC_22,
    FAULT_INJ_SYNC_23   => FAULT_INJ_SYNC_23,
    
    FAULT_INJ_COMB_0    => FAULT_INJ_COMB_0, 
    FAULT_INJ_COMB_1    => FAULT_INJ_COMB_1,
    FAULT_INJ_COMB_2    => FAULT_INJ_COMB_2,
    FAULT_INJ_COMB_3    => FAULT_INJ_COMB_3,
    FAULT_INJ_COMB_4    => FAULT_INJ_COMB_4,
    FAULT_INJ_COMB_5    => FAULT_INJ_COMB_5, 
    FAULT_INJ_COMB_6    => FAULT_INJ_COMB_6,
    FAULT_INJ_COMB_7    => FAULT_INJ_COMB_7,
    FAULT_INJ_COMB_8    => FAULT_INJ_COMB_8, 
    FAULT_INJ_COMB_9    => FAULT_INJ_COMB_9,
    FAULT_INJ_COMB_10   => FAULT_INJ_COMB_10,
    FAULT_INJ_COMB_11   => FAULT_INJ_COMB_11,
    FAULT_INJ_COMB_12   => FAULT_INJ_COMB_12,
    FAULT_INJ_COMB_13   => FAULT_INJ_COMB_13, 
    FAULT_INJ_COMB_14   => FAULT_INJ_COMB_14,
    FAULT_INJ_COMB_15   => FAULT_INJ_COMB_15,
    FAULT_INJ_COMB_16   => FAULT_INJ_COMB_16,
    FAULT_INJ_COMB_17   => FAULT_INJ_COMB_17,
    FAULT_INJ_COMB_18   => FAULT_INJ_COMB_18,
    FAULT_INJ_COMB_19   => FAULT_INJ_COMB_19,
    FAULT_INJ_COMB_20   => FAULT_INJ_COMB_20,
    FAULT_INJ_COMB_21   => FAULT_INJ_COMB_21,
    FAULT_INJ_COMB_22   => FAULT_INJ_COMB_22,
    FAULT_INJ_COMB_23   => FAULT_INJ_COMB_23,
    -- General --
    CLOCK_FREQUENCY              => CLOCK_FREQUENCY,   -- clock frequency of clk_i in Hz
    INT_BOOTLOADER_EN            => true,              -- boot configuration: true = boot explicit bootloader; false = boot from int/ext (I)MEM
    -- RISC-V CPU Extensions --
    CPU_EXTENSION_RISCV_C        => true,              -- implement compressed extension?
    CPU_EXTENSION_RISCV_M        => true,              -- implement mul/div extension?
    CPU_EXTENSION_RISCV_Zicsr    => true,              -- implement CSR system?
    CPU_EXTENSION_RISCV_Zicntr   => true,              -- implement base counters?
    -- Internal Instruction memory --
    MEM_INT_IMEM_EN              => true,              -- implement processor-internal instruction memory
    MEM_INT_IMEM_SIZE            => MEM_INT_IMEM_SIZE, -- size of processor-internal instruction memory in bytes
    -- Internal Data memory --
    MEM_INT_DMEM_EN              => true,              -- implement processor-internal data memory
    MEM_INT_DMEM_SIZE            => MEM_INT_DMEM_SIZE, -- size of processor-internal data memory in bytes
    -- Processor peripherals --
    IO_GPIO_NUM                  => 8,                 -- number of GPIO input/output pairs (0..64)
    IO_MTIME_EN                  => true,              -- implement machine system timer (MTIME)?
    IO_UART0_EN                  => true               -- implement primary universal asynchronous receiver/transmitter (UART0)?
  )
  port map (
    -- Global control --
    clk_i       => clk_i,       -- global clock, rising edge
    rstn_i      => rstn_i,      -- global reset, low-active, async
    -- GPIO (available if IO_GPIO_EN = true) --
    gpio_o      => con_gpio_o,  -- parallel output
	  in_comb_fault_inj_en  => in_comb_fault_inj_en, --sig_comb_fault_inj_en,
    in_sync_fault_inj_en  => in_sync_fault_inj_en, --sig_sync_fault_inj_en
    out_comb_fault_status => out_comb_fault_status,
    out_sync_fault_status => out_sync_fault_status,
    out_spike_comb  => out_spike_comb,--: out std_logic_vector (5 downto 0);
    out_spike_sync  => out_spike_sync, --: out std_logic_vector (5 downto 0)
    -- primary UART0 (available if IO_GPIO_NUM > 0) --
    uart0_txd_o => uart0_txd_o, -- UART0 send data
    uart0_rxd_i => uart0_rxd_i  -- UART0 receive data
  );

  -- GPIO output --
  gpio_o <= con_gpio_o(7 downto 0);


end architecture;
