----------------------------------------------------------------------------------
-- Company: Ulster University
-- Engineer: Nidhin Thandassery Sumithran
-- 
-- Create Date: 14.05.2023 12:27:46
-- Design Name: 
-- Module Name: neorv32_ft_package - Behavioral
-- Project Name: Nervous Systems 
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
library fault_inj_lib;
use fault_inj_lib.fault_injection_package.all;

package neorv32_ft_package is

type sync_fault_type_t is array (integer range 7 downto 0) of std_logic_vector (1 downto 0);
type comb_fault_type_t is array (integer range 7 downto 0) of std_logic_vector (1 downto 0);

/*component neorv32_test_setup_approm is
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
    in_comb_fault_inj_en : in comb_fault_enable_t;
    in_sync_fault_inj_en : in sync_fault_enable_t;
    out_comb_fault_status : out std_logic_vector (23 downto 0);
    out_sync_fault_status : out std_logic_vector (23 downto 0)
  );
end component neorv32_test_setup_approm;*/


component neorv32_test_setup_bootloader is
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
end component;

component fault_injection_control is
generic (
   -- fault_inj_ctrl_reg : std_logic_vector(31 downto 0) := x"02b80000";
    ENABLE_SYNTHESIS: BOOLEAN := TRUE
 );
Port (
    in_clk : in std_logic;
    in_rst_n :in std_logic; 
   -- in_comb_fault_status : in std_logic_vector (23 downto 0);
    --in_sync_fault_status : in std_logic_vector (23 downto 0);
    out_comb_fault_inj_en : out comb_fault_enable_t;
    out_sync_fault_inj_en : out sync_fault_enable_t;
    out_clock_count : out std_logic_vector (7 downto 0);
    fault_inj_ctrl_reg : in std_logic_vector(31 downto 0);
    fault_inj_ctrl_reg_fp_sel	: in std_logic_vector(31 downto 0)
    
 );
end component fault_injection_control;

component fault_injection_logic is
Port ( 
    in_data : in std_logic; 
    in_fault_type_sel : in std_logic_vector (1 downto 0);
    in_fault_inject : in std_logic;
    out_data : out std_logic
 );
end component fault_injection_logic;

component fault_detection_logic_ff_top is
generic (
    BUFFER_STAGES : natural := 5;
    ENABLE_SYNTHESIS: BOOLEAN := TRUE;
    DELAY : time:= 2 ns
  );
port ( in_source : in std_logic;
       in_destination: in std_logic;
       out_fault_status: out std_logic;
       clk : in std_logic;
       reset : in std_logic
       );
end component fault_detection_logic_ff_top;

component fdl_for_channel_top is  
generic (
    BUFFER_STAGES : natural := 5;
    ENABLE_SYNTHESIS: BOOLEAN := TRUE;
    DELAY : time:= 2ns
  );
port (
    in_source : in std_logic;
    in_destination: in std_logic;
    out_fault_status: out std_logic
  );
end component fdl_for_channel_top;

component and_gate is
generic (
    ENABLE_SYNTHESIS: BOOLEAN := TRUE
  );
port (
    in_1, in_2 : in std_logic;
    out_and : out std_logic
	);
end component and_gate;
  
component or_gate is
generic (
    ENABLE_SYNTHESIS: BOOLEAN := TRUE
  );
port (
    in_1, in_2 : in std_logic;
    out_or : out std_logic
	);
end component or_gate;
  
component buffer_module is
generic (
    ENABLE_SYNTHESIS: BOOLEAN := TRUE;
    DELAY: time := 0ns
  );
port (
    in_buf : in std_logic;
    out_buf : out std_logic
  );
end component buffer_module;
  
component not_gate is
generic (
    ENABLE_SYNTHESIS: BOOLEAN := TRUE;
    DELAY: time := 0ns
  );
port (
	in_not : in std_logic;
    out_not : out std_logic
	);
end component not_gate;

component d_flip_flop is  
    port (
        clk   : in  std_logic;
        reset : in  std_logic;
        in_d  : in  std_logic;
        out_q : out std_logic
    );
 end component d_flip_flop;
 
COMPONENT jtag_axi_0
  PORT (
    aclk            : IN STD_LOGIC;
    aresetn         : IN STD_LOGIC;
    m_axi_awaddr    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axi_awprot    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_axi_awvalid   : OUT STD_LOGIC;
    m_axi_awready   : IN STD_LOGIC;
    m_axi_wdata     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axi_wstrb     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_axi_wvalid    : OUT STD_LOGIC;
    m_axi_wready    : IN STD_LOGIC;
    m_axi_bresp     : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axi_bvalid    : IN STD_LOGIC;
    m_axi_bready    : OUT STD_LOGIC;
    m_axi_araddr    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axi_arprot    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_axi_arvalid   : OUT STD_LOGIC;
    m_axi_arready   : IN STD_LOGIC;
    m_axi_rdata     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axi_rresp     : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axi_rvalid    : IN STD_LOGIC;
    m_axi_rready    : OUT STD_LOGIC 
  );
END COMPONENT;



component jtag_interface is
Port ( 
    in_clk : in std_logic;
    in_rst_n : in std_logic;
    in_rst_int_n  : in std_logic;
    in_comb_fault_status : IN std_logic_vector (23 downto 0);--fault_status_comb_t;
    in_sync_fault_status : IN std_logic_vector (23 downto 0);--fault_status_sync_t
    in_clock_count : in std_logic_vector (7 downto 0);
    out_reset_control_reg   : out std_logic_vector (31 downto 0);
    out_fault_inj_ctrl_reg  : out std_logic_vector (31 downto 0);
    out_fault_inj_ctrl_reg_fp_sel : out std_logic_vector (31 downto 0);
    in_spike_comb           : out std_logic_vector (5 downto 0);
    in_spike_sync           : out std_logic_vector (5 downto 0)
);
end component jtag_interface;


component fault_inj_comb_0_7 is
generic (
    FAULT_INJ_COMB_0 : boolean:= true;
    FAULT_INJ_COMB_1 : boolean:= true;
    FAULT_INJ_COMB_2 : boolean:= true;
    FAULT_INJ_COMB_3 : boolean:= true;
    FAULT_INJ_COMB_4 : boolean:= true;
    FAULT_INJ_COMB_5 : boolean:= true; 
    FAULT_INJ_COMB_6 : boolean:= true;
    FAULT_INJ_COMB_7 : boolean:= true
  );
Port ( 
    bus_sel: in std_logic;
    fault_inj_trig_comb_0_7_i : in std_logic_vector (7 downto 0);
    fault_inj_type_comb_0_7_i : in comb_fault_type_t;
    fault_status_comb_0_7_o : out std_logic_vector (7 downto 0);
    fiu_out_bus_addr : out std_logic_vector (7 downto 0);
    ca_bus_addr_i   : in  std_ulogic_vector(31 downto 0); -- bus access address
    cb_bus_addr_i   : in  std_ulogic_vector(31 downto 0); -- bus access address
    reg_p_bus_addr_o : in std_logic_vector(7 downto 0) 
);
end component fault_inj_comb_0_7;

component fault_inj_sync_0_7 is
generic (
    FAULT_INJ_SYNC_0 : boolean:= true;
    FAULT_INJ_SYNC_1 : boolean:= true;
    FAULT_INJ_SYNC_2 : boolean:= true;
    FAULT_INJ_SYNC_3 : boolean:= true;
    FAULT_INJ_SYNC_4 : boolean:= true;
    FAULT_INJ_SYNC_5 : boolean:= true; 
    FAULT_INJ_SYNC_6 : boolean:= true;
    FAULT_INJ_SYNC_7 : boolean:= true
  );
Port ( 
    acc_en : in std_logic;
    fault_inj_trig_sync_0_7_i : in std_logic_vector (7 downto 0);
    fault_inj_type_sync_0_7_i : in sync_fault_type_t;
    fault_status_sync_0_7_o : out std_logic_vector (7 downto 0);
    fiu_out_data_o : out std_logic_vector (7 downto 0);
    flip_flop_o : in std_logic_vector (7 downto 0);
    flip_flop_i : in std_logic_vector (7 downto 0);
    clk_i : in std_logic;
    rstn_i : in std_logic
);
end component fault_inj_sync_0_7;


component fault_inj_sync_8_15 is
generic (
    FAULT_INJ_SYNC_8 : boolean:= true;
    FAULT_INJ_SYNC_9 : boolean:= true;
    FAULT_INJ_SYNC_10 : boolean:= true;
    FAULT_INJ_SYNC_11 : boolean:= true;
    FAULT_INJ_SYNC_12 : boolean:= true;
    FAULT_INJ_SYNC_13 : boolean:= true; 
    FAULT_INJ_SYNC_14 : boolean:= true;
    FAULT_INJ_SYNC_15 : boolean:= true
  );
Port (
    clk_i                       : in std_logic;
    rstn_i                      : in std_logic; 
    pc_we                       : in std_logic; 
    pc_mux_sel                  : in std_logic;
    flip_flop_o                 : in std_logic_vector (7 downto 0);
    fault_inj_trig_sync_8_15_i  : in std_logic_vector (7 downto 0);
    fault_inj_type_sync_8_15_i  : in sync_fault_type_t;
    fault_status_sync_8_15_o    : out std_logic_vector (7 downto 0);
    fiu_out_data_o              : out std_logic_vector (7 downto 0);
    next_pc                     : in std_logic_vector (7 downto 0);
    alu_add                     : in std_logic_vector ( 7 downto 0)
  
 );
end component fault_inj_sync_8_15;


component fault_inj_comb_8_15 is
generic (
    FAULT_INJ_COMB_8  : boolean:= true;
    FAULT_INJ_COMB_9  : boolean:= true;
    FAULT_INJ_COMB_10 : boolean:= true;
    FAULT_INJ_COMB_11 : boolean:= true;
    FAULT_INJ_COMB_12 : boolean:= true;
    FAULT_INJ_COMB_13 : boolean:= true; 
    FAULT_INJ_COMB_14 : boolean:= true;
    FAULT_INJ_COMB_15 : boolean:= true
  );
Port ( 
    fault_inj_trig_comb_8_15_i : in std_logic_vector (7 downto 0);
    fault_inj_type_comb_8_15_i : in comb_fault_type_t;
    fault_status_comb_8_15_o : out std_logic_vector (7 downto 0);
    fiu_out_bus_rdata : out std_logic_vector (7 downto 0);
    bus_rdata_i : in std_logic_vector(7 downto 0) ;
    bus_rdata_i_after_comb : in std_logic_vector (7 downto 0)
);
end component fault_inj_comb_8_15;


component fault_inj_comb_16_23 is
generic (
    FAULT_INJ_COMB_16   : boolean:= true;
    FAULT_INJ_COMB_17   : boolean:= true;
    FAULT_INJ_COMB_18   : boolean:= true;
    FAULT_INJ_COMB_19   : boolean:= true;
    FAULT_INJ_COMB_20   : boolean:= true;
    FAULT_INJ_COMB_21   : boolean:= true; 
    FAULT_INJ_COMB_22   : boolean:= true;
    FAULT_INJ_COMB_23   : boolean:= true
  );
Port ( 
    fault_inj_trig_comb_16_23_i : in std_logic_vector (7 downto 0);
    fault_inj_type_comb_16_23_i : in comb_fault_type_t;
    fault_status_comb_16_23_o   : out std_logic_vector (7 downto 0);
    fiu_out_bus_rdata           : out std_logic_vector (7 downto 0);
    bus_rdata_i_after_comb      : in std_logic_vector (7 downto 0);
    reg_alu_i                   : in std_logic_vector (7 downto 0);
    mem_i                       : in std_logic_vector (7 downto 0);
    csr_i                       : in std_logic_vector (7 downto 0);
    pc2_i                       : in std_logic_vector (7 downto 0);
    alu_i                       : in std_logic_vector (7 downto 0);
    rf_mux                      : in std_ulogic_vector(01 downto 0)
);
end component fault_inj_comb_16_23;

component fault_inj_sync_16_23 is
generic (
    FAULT_INJ_SYNC_16 : boolean:= true;
    FAULT_INJ_SYNC_17 : boolean:= true;
    FAULT_INJ_SYNC_18 : boolean:= true;
    FAULT_INJ_SYNC_19 : boolean:= true;
    FAULT_INJ_SYNC_20 : boolean:= true;
    FAULT_INJ_SYNC_21 : boolean:= true; 
    FAULT_INJ_SYNC_22 : boolean:= true;
    FAULT_INJ_SYNC_23 : boolean:= true
  );
Port ( 
    clk_i                       : in std_logic;
    rstn_i                      : in std_logic; 
    mul_start                   : in std_logic;
    flip_flop_o                 : in std_logic_vector (7 downto 0);
    fault_inj_trig_sync_16_23_i : in std_logic_vector (7 downto 0);
    fault_inj_type_sync_16_23_i : in sync_fault_type_t;
    fault_status_sync_16_23_o   : out std_logic_vector (7 downto 0);
    fiu_out_data_o              : out std_logic_vector (7 downto 0);
    add_i                       : in std_logic_vector (7 downto 0);
    rs1_i                       : in std_logic_vector (7 downto 0);
    ctrl_state                  : in std_logic
);
end component fault_inj_sync_16_23;

component fault_inj_det_status_glue_logic is
Port ( 
  clk_i                       : in std_logic;
  rstn_i                      : in std_logic;
  fault_status_sync_0_7_o     : in std_logic_vector (7 downto 0);
  fault_inj_trig_sync_0_7_i   : out std_logic_vector (7 downto 0);
  fault_inj_type_sync_0_7_i   : out sync_fault_type_t;
  
  fault_status_comb_0_7_o     : in std_logic_vector (7 downto 0);
  fault_inj_trig_comb_0_7_i   : out std_logic_vector (7 downto 0);
  fault_inj_type_comb_0_7_i   : out comb_fault_type_t;
  
  fault_status_sync_8_15_o    : in std_logic_vector (7 downto 0);
  fault_inj_trig_sync_8_15_i  : out std_logic_vector (7 downto 0);
  fault_inj_type_sync_8_15_i  : out sync_fault_type_t;
  
  fault_status_comb_8_15_o    : in std_logic_vector (7 downto 0);
  fault_inj_trig_comb_8_15_i  : out std_logic_vector (7 downto 0);
  fault_inj_type_comb_8_15_i  : out comb_fault_type_t;
  
  fault_status_sync_16_23_o   : in std_logic_vector (7 downto 0);
  fault_inj_trig_sync_16_23_i : out std_logic_vector (7 downto 0);
  fault_inj_type_sync_16_23_i : out sync_fault_type_t;
  
  fault_status_comb_16_23_o   : in std_logic_vector (7 downto 0);
  fault_inj_trig_comb_16_23_i : out std_logic_vector (7 downto 0);
  fault_inj_type_comb_16_23_i : out comb_fault_type_t;
  
  in_comb_fault_inj_en        : in comb_fault_enable_t;
  in_sync_fault_inj_en        : in sync_fault_enable_t;
  out_comb_fault_status       : out std_logic_vector (23 downto 0);
  out_sync_fault_status       : out std_logic_vector (23 downto 0)

);
end component fault_inj_det_status_glue_logic;


component microcircuit_wrapper is
Port (
  in_comb_fault_status  : in std_logic_vector (23 downto 0);
  in_sync_fault_status  : in std_logic_vector (23 downto 0);
  out_spike_comb        : out std_logic_vector (5 downto 0);
  out_spike_sync        : out std_logic_vector (5 downto 0);
  clk_in                : in std_logic;
  reset_in              : in std_logic 
   );
end component microcircuit_wrapper;


component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  clk_out1          : out    std_logic;
  -- Status and control signals
  resetn             : in     std_logic;
  locked            : out    std_logic;
  clk_in1_p         : in     std_logic;
  clk_in1_n         : in     std_logic
 );
end component;
  
end neorv32_ft_package;