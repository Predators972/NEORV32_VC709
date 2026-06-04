----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.04.2023 14:08:17
-- Design Name: 
-- Module Name: fault_injection_control- Behavioral
-- Project Name: 
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

entity fault_injection_control is
generic (
    fault_inj_ctrl_reg : std_logic_vector(31 downto 0) := x"02b80000";
    ENABLE_SYNTHESIS: BOOLEAN := TRUE
 );
Port (
    in_clk : std_logic;
    in_rst_n : std_logic; 
    in_comb_fault_status : in fault_status_comb_t;
    in_sync_fault_status : in fault_status_sync_t;
    out_comb_fault_inj_en : out fault_inj_enable_t;
    out_sync_fault_inj_en : in fault_inj_enable_t
    
 );
end fault_injection_control;

architecture Behavioral of fault_injection_control is

--type fault_inj_ctrl_state is (IDLE, INJECT,  WAIT_STATE);

signal fault_inj_ctrl : fault_inj_ctrl_t;---control state machine states
signal fault_pulse_gen_st : fault_pulse_state_t;
--signal fdl_enable_flag : fdl_enable_flag_t;
signal sig_clock_count  : std_logic_vector (31 downto 0);
signal sig_ref_count: integer range 0 to 255;
signal sig_clock_count_int : integer range 0 to 2147483647;
signal sig_fault_trig_width : integer range 0 to 7;
signal sig_gap_bw_faults : integer range 0 to 15;

signal pulse_gen_state : state_type := idle;
signal pulse_cnt : unsigned(log2ceil(sig_fault_trig_width)+1 downto 0) := (others => '0');
signal gap_cnt : unsigned(log2ceil(sig_gap_bw_faults)+1 downto 0) := (others => '0');

begin
----fault location select: 000->cpu bus switch , 001->cpu pc update, 010-> cpu alu, 
----fault injection type: 00-> single fault, 01->temporary fault, 10-> permanent fault--
fault_inj_ctrl.fault_location_sel <= fault_inj_ctrl_reg (31 downto 29);
fault_inj_ctrl.fault_inj_type     <= fault_inj_ctrl_reg (28 downto 27);
fault_inj_ctrl.fault_type_sel <= fault_inj_ctrl_reg (26 downto 25);
fault_inj_ctrl.fault_ref_count <= fault_inj_ctrl_reg (24 downto 17);
fault_inj_ctrl.fault_trig_width <= fault_inj_ctrl_reg (16 downto 15);
fault_inj_ctrl.gap_bw_faults <= fault_inj_ctrl_reg (14 downto 11);

sig_ref_count <= to_integer (unsigned(fault_inj_ctrl.fault_ref_count));
sig_clock_count_int <= to_integer (unsigned(sig_clock_count));
sig_fault_trig_width <= to_integer (unsigned (fault_inj_ctrl.fault_trig_width));
sig_gap_bw_faults <= to_integer (unsigned (fault_inj_ctrl.gap_bw_faults));

control_fsm: process(in_clk, in_rst_n)
begin
if (in_rst_n = '0') then
fault_inj_ctrl.state <= IDLE;
elsif rising_edge(in_clk) then

-------------finite state machine---------------------
  case  fault_inj_ctrl.state is

    when IDLE => 
        if (sig_clock_count_int <= sig_ref_count) then 
            fault_inj_ctrl.state <= IDLE;
        else
            fault_inj_ctrl.state <= INJECT;
        end if;
    when INJECT => 
        case  fault_inj_ctrl.fault_location_sel is 
          when "000" =>
            case fault_inj_ctrl.fault_inj_type is  
              
              when "00" =>
                
                pulse_trig_flag <= '1'; --enable the pulse gen state machine
                
                for i in 0 to NO_OF_COMB_EACH_LOC -1 loop
                    out_comb_fault_inj_en(i).fault_inj_trigger <= pulse; --'1';
                    out_comb_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                for i in 0 to NO_OF_SYNC_EACH_LOC -1 loop
                    out_sync_fault_inj_en(i).fault_inj_trigger <= pulse; --'1';
                    out_sync_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                if (sig_clock_count_int = sig_ref_count + sig_fault_trig_width) then              
                fault_inj_ctrl.state <= WAIT_STATE;
                fault_inj_ctrl.state <= INJECT;
                pulse_trig_flag <= '0';
                end if;
              
              when "01" =>
              
                pulse_trig_flag <= '1';
               
                for i in 0 to NO_OF_COMB_EACH_LOC -1 loop
                    out_comb_fault_inj_en(i).fault_inj_trigger <= pulse;--'1';
                    out_comb_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                for i in 0 to NO_OF_SYNC_EACH_LOC -1 loop
                    out_sync_fault_inj_en(i).fault_inj_trigger <= '1';
                    out_sync_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                   
                if (sig_clock_count_int = sig_ref_count + 20) then 
                    fault_inj_ctrl.state <= WAIT_STATE;
                    pulse_trig_flag <= '0';
                else
                    fault_inj_ctrl.state <= INJECT;
                end if;
              
              when "10" =>
                   
                pulse_trig_flag <= '1';
              
                for i in 0 to NO_OF_COMB_EACH_LOC -1 loop
                    out_comb_fault_inj_en(i).fault_inj_trigger <= pulse;
                    out_comb_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                for i in 0 to NO_OF_SYNC_EACH_LOC -1 loop
                    out_sync_fault_inj_en(i).fault_inj_trigger <= pulse;
                    out_sync_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                if (sig_clock_count_int = sig_ref_count + 30) then 
                    fault_inj_ctrl.state <= WAIT_STATE;
                    pulse_trig_flag <= '0';
                else
                    fault_inj_ctrl.state <= INJECT;
                end if;
              
              when others =>  
                for i in 0 to NO_OF_COMB_EACH_LOC -1 loop
                    out_comb_fault_inj_en(i).fault_inj_trigger <= '0';
                    out_comb_fault_inj_en(i).fault_type_sel <= (others => '0');
                end loop;
                
                for i in 0 to NO_OF_SYNC_EACH_LOC -1 loop
                    out_sync_fault_inj_en(i).fault_inj_trigger <= '0';
                    out_sync_fault_inj_en(i).fault_type_sel <= (others => '0');
                end loop;  
                
                fault_inj_ctrl.state <= WAIT_STATE;
           end case;
                
          when "001" =>
            case fault_inj_ctrl.fault_inj_type is  
              
              when "00" =>
                
                pulse_trig_flag <= '1'; --enable the pulse gen state machine
                
                for i in 0 to NO_OF_COMB_EACH_LOC -1 loop
                    out_comb_fault_inj_en(i).fault_inj_trigger <= pulse; --'1';
                    out_comb_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                for i in 0 to NO_OF_SYNC_EACH_LOC -1 loop
                    out_sync_fault_inj_en(i).fault_inj_trigger <= pulse; --'1';
                    out_sync_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                if (sig_clock_count_int = sig_ref_count + sig_fault_trig_width) then              
                fault_inj_ctrl.state <= WAIT_STATE;
                fault_inj_ctrl.state <= INJECT;
                pulse_trig_flag <= '0';
                end if;
              
              when "01" =>
              
                pulse_trig_flag <= '1';
               
                for i in 0 to NO_OF_COMB_EACH_LOC -1 loop
                    out_comb_fault_inj_en(i).fault_inj_trigger <= pulse;--'1';
                    out_comb_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                for i in 0 to NO_OF_SYNC_EACH_LOC -1 loop
                    out_sync_fault_inj_en(i).fault_inj_trigger <= '1';
                    out_sync_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                   
                if (sig_clock_count_int = sig_ref_count + 20) then 
                    fault_inj_ctrl.state <= WAIT_STATE;
                    pulse_trig_flag <= '0';
                else
                    fault_inj_ctrl.state <= INJECT;
                end if;
              
              when "10" =>
                   
                pulse_trig_flag <= '1';
              
                for i in 0 to NO_OF_COMB_EACH_LOC -1 loop
                    out_comb_fault_inj_en(i).fault_inj_trigger <= pulse;
                    out_comb_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                for i in 0 to NO_OF_SYNC_EACH_LOC -1 loop
                    out_sync_fault_inj_en(i).fault_inj_trigger <= pulse;
                    out_sync_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                if (sig_clock_count_int = sig_ref_count + 30) then 
                    fault_inj_ctrl.state <= WAIT_STATE;
                    pulse_trig_flag <= '0';
                else
                    fault_inj_ctrl.state <= INJECT;
                end if;
              
              when others =>  
                for i in 0 to NO_OF_COMB_EACH_LOC -1 loop
                    out_comb_fault_inj_en(i).fault_inj_trigger <= '0';
                    out_comb_fault_inj_en(i).fault_type_sel <= (others => '0');
                end loop;
                
                for i in 0 to NO_OF_SYNC_EACH_LOC -1 loop
                    out_sync_fault_inj_en(i).fault_inj_trigger <= '0';
                    out_sync_fault_inj_en(i).fault_type_sel <= (others => '0');
                end loop;  
                
                fault_inj_ctrl.state <= WAIT_STATE;
           end case;
           
          when "010" =>
             case fault_inj_ctrl.fault_inj_type is  
              
              when "00" =>
                
                pulse_trig_flag <= '1'; --enable the pulse gen state machine
                
                for i in 0 to NO_OF_COMB_EACH_LOC -1 loop
                    out_comb_fault_inj_en(i).fault_inj_trigger <= pulse; --'1';
                    out_comb_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                for i in 0 to NO_OF_SYNC_EACH_LOC -1 loop
                    out_sync_fault_inj_en(i).fault_inj_trigger <= pulse; --'1';
                    out_sync_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                if (sig_clock_count_int = sig_ref_count + sig_fault_trig_width) then              
                fault_inj_ctrl.state <= WAIT_STATE;
                fault_inj_ctrl.state <= INJECT;
                pulse_trig_flag <= '0';
                end if;
              
              when "01" =>
              
                pulse_trig_flag <= '1';
               
                for i in 0 to NO_OF_COMB_EACH_LOC -1 loop
                    out_comb_fault_inj_en(i).fault_inj_trigger <= pulse;--'1';
                    out_comb_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                for i in 0 to NO_OF_SYNC_EACH_LOC -1 loop
                    out_sync_fault_inj_en(i).fault_inj_trigger <= '1';
                    out_sync_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                   
                if (sig_clock_count_int = sig_ref_count + 20) then 
                    fault_inj_ctrl.state <= WAIT_STATE;
                    pulse_trig_flag <= '0';
                else
                    fault_inj_ctrl.state <= INJECT;
                end if;
              
              when "10" =>
                   
                pulse_trig_flag <= '1';
              
                for i in 0 to NO_OF_COMB_EACH_LOC -1 loop
                    out_comb_fault_inj_en(i).fault_inj_trigger <= pulse;
                    out_comb_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                for i in 0 to NO_OF_SYNC_EACH_LOC -1 loop
                    out_sync_fault_inj_en(i).fault_inj_trigger <= pulse;
                    out_sync_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                if (sig_clock_count_int = sig_ref_count + 30) then 
                    fault_inj_ctrl.state <= WAIT_STATE;
                    pulse_trig_flag <= '0';
                else
                    fault_inj_ctrl.state <= INJECT;
                end if;
              
              when others =>  
                for i in 0 to NO_OF_COMB_EACH_LOC -1 loop
                    out_comb_fault_inj_en(i).fault_inj_trigger <= '0';
                    out_comb_fault_inj_en(i).fault_type_sel <= (others => '0');
                end loop;
                
                for i in 0 to NO_OF_SYNC_EACH_LOC -1 loop
                    out_sync_fault_inj_en(i).fault_inj_trigger <= '0';
                    out_sync_fault_inj_en(i).fault_type_sel <= (others => '0');
                end loop;  
                
                fault_inj_ctrl.state <= WAIT_STATE;
           end case;
                
          when others =>    
                for i in 0 to NO_OF_COMB_EACH_LOC -1 loop
                    out_comb_fault_inj_en(i).fault_inj_trigger <= '0';
                    out_comb_fault_inj_en(i).fault_type_sel <= (others => '0');
                end loop;
                
                for i in 0 to NO_OF_SYNC_EACH_LOC -1 loop
                    out_sync_fault_inj_en(i).fault_inj_trigger <= '0';
                    out_sync_fault_inj_en(i).fault_type_sel <= (others => '0');
                end loop;  
                
                fault_inj_ctrl.state <= WAIT_STATE;
      end case;
      
    when WAIT_STATE => 
        for i in 0 to NO_OF_COMB_EACH_LOC -1 loop
            out_comb_fault_inj_en(i).fault_inj_trigger <= '0';
            out_comb_fault_inj_en(i).fault_type_sel <= (others => '0');
        end loop;
                
        for i in 0 to NO_OF_SYNC_EACH_LOC -1 loop
            out_sync_fault_inj_en(i).fault_inj_trigger <= '0';
            out_sync_fault_inj_en(i).fault_type_sel <= (others => '0');
        end loop;  
                
        fault_inj_ctrl.state <= WAIT_STATE;
    
  end case;
end if;
end process control_fsm;

------------------------------------------------------------------
--------------------trigger pulse generator-----------------------
 
process(in_clk, in_rst_n)
begin
 if (in_rst_n = '0') then
    fault_pulse_gen_st <= INIT;
 elsif rising_edge(in_clk) then
 else
    case fault_pulse_gen_st is
    when INIT =>
        pulse <= '0';
        pulse_cnt <= (others => '0');
        gap_cnt <= (others => '0');
        fault_pulse_gen_st <= pulse_on;
        if (pulse_trig_flag = '1') then
            fault_pulse_gen_st <= PULSE_TRIG;
        else
            fault_pulse_gen_st <= INIT;
        end if; 
               
    when PULSE_TRIG =>
        pulse <= '1';
        pulse_cnt <= pulse_cnt + 1;
        if pulse_cnt = to_unsigned(fault_inj_ctrl.fault_trig_width-1, pulse_cnt'length) then
            pulse_cnt <= (others => '0');
            fault_pulse_gen_st <= GAP_TRIG;
        end if;
        if (pulse_trig_flag = '0') then
            fault_pulse_gen_st <= INIT;
        end if;
    when GAP_TRIG =>
        pulse <= '0';
        gap_cnt <= gap_cnt + 1;
        if gap_cnt = to_unsigned(fault_inj_ctrl.gap_bw_faults-1, gap_cnt'length) then
            gap_cnt <= (others => '0');
            pulse_cnt <= (others => '0');
            fault_pulse_gen_st <= PULSE_TRIG;
        end if;
        if (pulse_trig_flag = '0') then
            fault_pulse_gen_st <= INIT;
        end if;
    when OTHERS => 
        fault_pulse_gen_st <= INIT;
        gap_cnt <= (others => '0');
        pulse_cnt <= (others => '0');
        pulse <= '0';
    end case;
  
  end if;
  
end process;
---------------Free running counter-------------------------------
free_running_counter_inst: free_running_counter
    port map
	( clk_i => in_clk,
      rstn_int => not in_rst_n,
      count => sig_clock_count
	);

 
end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.04.2023 15:05:05
-- Design Name: 
-- Module Name: fault_injection_package - Behavioral
-- Project Name: 
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
constant NO_OF_COMB_LOC : natural := 24;
constant NO_OF_SYNC_LOC : natural := 24;
constant NO_OF_COMB_EACH_LOC : natural := 8;
constant NO_OF_SYNC_EACH_LOC : natural := 8;


type fault_inj_ctrl_state_t is (IDLE, INJECT,  WAIT_STATE);
type fault_pulse_state_t is (INIT, PULSE_TRIG, GAP_TRIG);

type fault_status_comb_t is array (0 to NO_OF_COMB_LOC) of std_logic;
type fault_status_sync_t is array (0 to NO_OF_SYNC_LOC) of std_logic;


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
 gap_bw_faults : std_logic_vector (1 downto 0);
end record;
 
end fault_injection_package;

