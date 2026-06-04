
----------------------------------------------------------------------------------
-- Company: Ulster University
-- Engineer: Nidhin Thandassery Sumithran
-- 
-- Create Date: 15.05.2023 
-- Design Name: 
-- Module Name: neorv32 fault tolerant- Behavioral
-- Project Name: Nervous System
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library neorv32_ft_lib;
use neorv32_ft_lib.neorv32_ft_package.all;

library neorv32;
use neorv32.neorv32_package.all;

library fault_inj_lib;
use fault_inj_lib.fault_injection_package.all;

entity neorv32_ft_uart_top is
generic ( 
    FAULT_INJ_SYNC_0  : boolean:= true; --Location 1 fault injection enable for synthesis
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
    
    ENABLE_SYNTHESIS: BOOLEAN := TRUE;
     -- adapt these for your setup --
    CLOCK_FREQUENCY   : natural := 50000000; -- clock frequency of clk_i in Hz
    MEM_INT_IMEM_SIZE : natural := 256*1024;   -- size of processor-internal instruction memory in bytes
    MEM_INT_DMEM_SIZE : natural := 16*1024     -- size of processor-internal data memory in bytes
 );
Port (
    -- Global control --
    --clk_i       : in  std_ulogic; -- global clock, rising edge
    clk_in1_p   : in std_logic;
    clk_in1_n   : in std_logic;
    --clk_100Mhz  : in std_logic;
    rstn_i      : in  std_ulogic; -- global reset, low-active, async
    -- GPIO --
    gpio_o      : out std_ulogic_vector(7 downto 0); -- parallel output 
    -- UART0 --
    uart0_txd_o : out std_ulogic; -- UART0 send data
    uart0_rxd_i : in  std_ulogic;  -- UART0 receive data
        -- XADC analog inputs (NEW)--
    vp_in       : in  std_logic;    -- VP dedicated analog input
    vn_in       : in  std_logic    -- VN dedicated analog input
--    vauxp0      : in  std_logic;    -- VAUX0 positive
--    vauxn0      : in  std_logic;    -- VAUX0 negative
--    vauxp1      : in  std_logic;    -- VAUX1 positive
--    vauxn1      : in  std_logic     -- VAUX1 negative
 );
end neorv32_ft_uart_top;

 architecture Behavioral of neorv32_ft_uart_top is

signal sig_comb_fault_inj_en  : comb_fault_enable_t;
signal sig_sync_fault_inj_en  : sync_fault_enable_t;
signal sig_comb_fault_status  : std_logic_vector (23 downto 0);--fault_status_comb_t;
signal sig_sync_fault_status  : std_logic_vector (23 downto 0);--fault_status_sync_t;
signal sig_clock_count_lsb8   : std_logic_vector (7 downto 0);
signal rstn_i_int             : std_logic;
signal reset_control_reg      : std_logic_vector (31 downto 0);
signal reset_enable           : std_logic;
signal fault_inj_ctrl_reg     : std_logic_vector(31 downto 0); 
signal fault_inj_ctrl_reg_fp_sel : std_logic_vector (31 downto 0);
signal out_spike_comb  : std_logic_vector (5 downto 0);
signal out_spike_sync  : std_logic_vector (5 downto 0);
signal clk_i : std_logic;
signal clk_100mhz, clk_200mhz : std_logic;
signal locked : std_logic;

--XADC result signals--
signal xadc_data_vp_vn  : std_logic_vector(15 downto 0);
--signal xadc_data_vaux0  : std_logic_vector(15 downto 0);
--signal xadc_data_vaux1  : std_logic_vector(15 downto 0);
signal xadc_eoc         : std_logic;
signal xadc_eos         : std_logic;
signal xadc_busy        : std_logic;
signal xadc_channel     : std_logic_vector(4 downto 0);
signal xadc_alarm       : std_logic;

--GPIO signals: output (from CPU) + input (to CPU from XADC)--
signal con_gpio_o        : std_ulogic_vector(63 downto 0);
signal con_gpio_i        : std_ulogic_vector(63 downto 0);

---keep attribute for the test and debug purpose of the signals  
attribute keep : boolean;
attribute keep of reset_enable : signal is true; 
attribute keep of sig_sync_fault_inj_en : signal is true;
attribute keep of sig_comb_fault_inj_en : signal is true;
attribute keep of sig_sync_fault_status : signal is true;
attribute keep of sig_comb_fault_status : signal is true;
attribute keep of clk_100mhz : signal is true;

begin


-----clock buffer-----differntial to single clock------

/*---------200 MHz clock------
IBUFDS_inst : IBUFDS
port map (
   O => clk_200mhz,      --O,-- 1-bit output: Buffer output
   I => clk_ref_p, --I,   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
   IB => clk_ref_n --IB  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
);*/

------100 MHz clock-------
clock_gen_100mhz : clk_wiz_0
   port map ( 
  -- Clock out ports  
   clk_out1 => clk_100mhz,
  -- Status and control signals                
   reset => '0',--rstn_i,
   locked => locked,
   -- Clock in ports
   clk_in1_p => clk_in1_p,
   clk_in1_n => clk_in1_n
 );
 
 --XADC Controller instantiation--
xadc_ctrl_inst : entity work.xadc_controller
port map (
  clk_i           => clk_100mhz,
  rstn_i          => rstn_i,
  vp_in           => vp_in,
  vn_in           => vn_in,
--  vauxp0          => vauxp0,
--  vauxn0          => vauxn0,
--  vauxp1          => vauxp1,
--  vauxn1          => vauxn1,
  xadc_data_vp_vn => xadc_data_vp_vn,
--  xadc_data_vaux0 => xadc_data_vaux0,
--  xadc_data_vaux1 => xadc_data_vaux1,
  xadc_eoc        => xadc_eoc,
  xadc_eos        => xadc_eos,
  xadc_busy       => xadc_busy,
  xadc_channel    => xadc_channel,
  xadc_alarm      => xadc_alarm
);

--Map XADC results into GPIO inputs read by CPU--
-- The C program reads these via neorv32_gpio_pin_get()
--   gpio_i[0..7]   = VP/VN  high byte (bits 15:8)
--   gpio_i[8..15]  = VP/VN  low byte  (bits  7:0)
--   gpio_i[16..23] = VAUX0  high byte
--   gpio_i[24..31] = VAUX0  low byte
--   gpio_i[32..39] = VAUX1  high byte
--   gpio_i[40..47] = VAUX1  low byte
--   gpio_i[48]     = xadc_busy
--   gpio_i[49]     = xadc_eoc
--   gpio_i[50]     = xadc_eos
con_gpio_i(7  downto 0)  <= std_ulogic_vector(xadc_data_vp_vn(15 downto 8));
con_gpio_i(15 downto 8)  <= std_ulogic_vector(xadc_data_vp_vn(7  downto 0));
con_gpio_i(16)           <= std_ulogic(xadc_busy);
con_gpio_i(17)           <= std_ulogic(xadc_eoc);
con_gpio_i(18)           <= std_ulogic(xadc_eos);
con_gpio_i(19)           <= std_ulogic(xadc_alarm);
con_gpio_i(63 downto 20) <= (others => '0');
--con_gpio_i(23 downto 16) <= std_ulogic_vector(xadc_data_vaux0(15 downto 8));
--con_gpio_i(31 downto 24) <= std_ulogic_vector(xadc_data_vaux0(7  downto 0));
--con_gpio_i(39 downto 32) <= std_ulogic_vector(xadc_data_vaux1(15 downto 8));
--con_gpio_i(47 downto 40) <= std_ulogic_vector(xadc_data_vaux1(7  downto 0));
--con_gpio_i(48)            <= std_ulogic(xadc_busy);
--con_gpio_i(49)            <= std_ulogic(xadc_eoc);
--con_gpio_i(50)            <= std_ulogic(xadc_eos);
--con_gpio_i(63 downto 51) <= (others => '0');

----------------------NEORV32 instantiation----------------------
-----------------------------------------------------------------
/*neorv32_test_setup_approm_inst: neorv32_test_setup_approm
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
    -- adapt these for your setup --
    CLOCK_FREQUENCY  => CLOCK_FREQUENCY,-- : natural := 100000000; -- clock frequency of clk_i in Hz
    MEM_INT_IMEM_SIZE => MEM_INT_IMEM_SIZE, --: natural := 16*1024;   -- size of processor-internal instruction memory in bytes
    MEM_INT_DMEM_SIZE => MEM_INT_DMEM_SIZE --: natural := 8*1024     -- size of processor-internal data memory in bytes
  )
  port map(
    -- Global control --
    clk_i    => clk_i,--   : in  std_ulogic; -- global clock, rising edge
    rstn_i   => rstn_i_int,--   : in  std_ulogic; -- global reset, low-active, async
    -- GPIO --
    gpio_o   => gpio_o,--   : out std_ulogic_vector(7 downto 0) -- parallel output
    in_comb_fault_inj_en => sig_comb_fault_inj_en,
    in_sync_fault_inj_en => sig_sync_fault_inj_en,
    out_comb_fault_status => sig_comb_fault_status,
    out_sync_fault_status => sig_sync_fault_status
  );*/

neorv32_test_setup_bootloader_inst: neorv32_test_setup_bootloader
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
    -- adapt these for your setup --
    CLOCK_FREQUENCY  => CLOCK_FREQUENCY,-- : natural := 100000000; -- clock frequency of clk_i in Hz
    MEM_INT_IMEM_SIZE => MEM_INT_IMEM_SIZE, --: natural := 16*1024;   -- size of processor-internal instruction memory in bytes
    MEM_INT_DMEM_SIZE => MEM_INT_DMEM_SIZE --: natural := 8*1024     -- size of processor-internal data memory in bytes
  )
  port map(
    -- Global control --
    clk_i    => clk_100mhz,--clk_i,--   : in  std_ulogic; -- global clock, rising edge
    rstn_i   => rstn_i,--   : in  std_ulogic; -- global reset, low-active, async
    -- GPIO --
    gpio_o   => gpio_o,--   : out std_ulogic_vector(7 downto 0) -- parallel output
    gpio_i   => con_gpio_i,
    in_comb_fault_inj_en => sig_comb_fault_inj_en,
    in_sync_fault_inj_en => sig_sync_fault_inj_en,
    out_comb_fault_status => sig_comb_fault_status,
    out_sync_fault_status => sig_sync_fault_status,
    out_spike_comb  => out_spike_comb,--: out std_logic_vector (5 downto 0);
    out_spike_sync  => out_spike_sync,--: out std_logic_vector (5 downto 0);
     -- UART0 --
    uart0_txd_o => uart0_txd_o,-- UART0 send data
    uart0_rxd_i => uart0_rxd_i -- UART0 receive data
  );

-----------------------fault injection control inst---------------

fault_injection_control_inst: fault_injection_control
generic map(
    ENABLE_SYNTHESIS => ENABLE_SYNTHESIS
 )
Port map(
    in_clk => clk_100mhz,--clk_i,
    in_rst_n => rstn_i_int, 
    out_comb_fault_inj_en => sig_comb_fault_inj_en,
    out_sync_fault_inj_en => sig_sync_fault_inj_en,
    out_clock_count => sig_clock_count_lsb8,
    fault_inj_ctrl_reg => fault_inj_ctrl_reg,
    fault_inj_ctrl_reg_fp_sel=> fault_inj_ctrl_reg_fp_sel
 );
 
--------------------JTAG interface-------------------------------------
jtag_interface_inst: jtag_interface
Port map ( 
    in_clk => clk_100mhz,--clk_i,
    in_rst_n => rstn_i,
    in_rst_int_n => rstn_i_int,
    in_comb_fault_status => sig_comb_fault_status,
    in_sync_fault_status => sig_sync_fault_status,
    in_spike_comb => out_spike_comb, 
    in_spike_sync => out_spike_sync,
    --in_comb_microcircuit_status : in std_logic_vector (23 downto 0);
    --in_sync_microcircuit_status : in std_logic_vector (23 downto 0);
    in_clock_count => sig_clock_count_lsb8,
    out_reset_control_reg => reset_control_reg,  
    out_fault_inj_ctrl_reg => fault_inj_ctrl_reg,
    out_fault_inj_ctrl_reg_fp_sel=> fault_inj_ctrl_reg_fp_sel
);
 


reset_enable <= reset_control_reg (0); 

reset_enable_process : process (reset_enable, rstn_i)
begin
  rstn_i_int <= reset_enable and rstn_i;
  
end process reset_enable_process;


end Behavioral;