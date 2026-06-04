----------------------------------------------------------------------------------
-- Company: Ulster University
-- Engineer: Nidhin Thandassery Sumithran
-- 
-- Create Date: 27.04.2023 15:05:05
-- Design Name: 
-- Module Name: fault_injection_package - Behavioral
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

package fault_injection_package is

constant fault_inj_ctrl_reg  : std_logic_vector(31 downto 0) := x"00000000";

constant NO_OF_COMB_LOC_1 : natural := 8;
constant NO_OF_SYNC_LOC_1 : natural := 8;
constant NO_OF_COMB_LOC_2 : natural := 8;
constant NO_OF_SYNC_LOC_2 : natural := 8;
constant NO_OF_COMB_LOC_3 : natural := 8;
constant NO_OF_SYNC_LOC_3 : natural := 8;
constant NO_OF_COMB_LOC : natural := 24;
constant NO_OF_SYNC_LOC : natural := 24;


type fault_inj_ctrl_state_t is (IDLE, INJECT,  WAIT_STATE);
type fault_pulse_state_t is (INIT, PULSE_TRIG, GAP_TRIG);

type fault_status_comb_t is array (0 to NO_OF_COMB_LOC-1) of std_logic;
type fault_status_sync_t is array (0 to NO_OF_SYNC_LOC-1) of std_logic;


type fault_inj_enable_t is record
 fault_inj_trigger : std_logic;
 fault_type_sel : std_logic_vector (1 downto 0);
end record;

type comb_fault_enable_t is array (0 to NO_OF_COMB_LOC -1) of fault_inj_enable_t;
type sync_fault_enable_t is array (0 to NO_OF_SYNC_LOC -1) of fault_inj_enable_t;

    
type fault_inj_ctrl_t is record
 state : fault_inj_ctrl_state_t;
 fault_location_sel : std_logic_vector (2 downto 0);
 fault_inj_type : std_logic_vector (1 downto 0);
 fault_type_sel : std_logic_vector (1 downto 0);
 fault_ref_count : std_logic_vector (7 downto 0);
 fault_trig_width : std_logic_vector (1 downto 0);
 gap_bw_faults : std_logic_vector (3 downto 0);
 random_sel    : std_logic;
end record;


component free_running_counter is
    Port ( clk_i     : in  std_logic;
           rstn_int   : in  std_logic;
           count   : out std_logic_vector(31 downto 0));
end component free_running_counter;

component pulse_randomiser is
Port (
    in_pulse : in std_logic;
    in_clk : in std_logic; 
    in_reset : in std_logic;
    out_pulse_8 : out std_logic_vector (7 downto 0);
    out_pulse_24 : out std_logic_vector (23 downto 0)
 );
end component pulse_randomiser;

 
end fault_injection_package;

