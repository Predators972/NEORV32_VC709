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
    --fault_inj_ctrl_reg : std_logic_vector(31 downto 0) :=  x"02b80000";
    ENABLE_SYNTHESIS: BOOLEAN := TRUE
 );
Port (
    in_clk : std_logic;
    in_rst_n : std_logic; 
    --in_comb_fault_status : in std_logic_vector (23 downto 0);--fault_status_comb_t;
    --in_sync_fault_status : in std_logic_vector (23 downto 0);--fault_status_sync_t;
    out_comb_fault_inj_en : out comb_fault_enable_t;
    out_sync_fault_inj_en : out sync_fault_enable_t;
    out_clock_count : out std_logic_vector (7 downto 0);
    fault_inj_ctrl_reg : out std_logic_vector(31 downto 0)
    
 );
end fault_injection_control;

architecture Behavioral of fault_injection_control is

signal sig_comb_fault_inj_en : comb_fault_enable_t;
signal sig_sync_fault_inj_en : sync_fault_enable_t;

--type fault_inj_ctrl_state is (IDLE, INJECT,  WAIT_STATE);
signal fault_inj_ctrl : fault_inj_ctrl_t;---control state machine states
signal fault_pulse_gen_st : fault_pulse_state_t;
--signal fdl_enable_flag : fdl_enable_flag_t;
signal sig_clock_count  : std_logic_vector (31 downto 0);
signal sig_ref_count: integer range 0 to 255;
signal sig_clock_count_int : integer range 0 to 2147483647;
signal sig_fault_trig_width : integer range 0 to 7;
signal sig_gap_bw_faults : integer range 0 to 15;

signal pulse_cnt : unsigned(fault_inj_ctrl.fault_trig_width'range); --unsigned(log2ceil(sig_fault_trig_width)+1 downto 0) := (others => '0');
signal gap_cnt : unsigned(fault_inj_ctrl.gap_bw_faults'range);-- := (others => '0');
signal pulse_trig_flag : std_logic;
/*signal i : std_logic_vector (NO_OF_COMB_EACH_LOC - 1 downto 0);
signal j : std_logic_vector (NO_OF_SYNC_EACH_LOC - 1 downto 0);*/
signal pulse : std_logic;
signal randomised_pulse : std_logic_vector (7 downto 0);
signal randomised_pulse_24 : std_logic_vector (23 downto 0);
signal sig_random_sel : std_logic;

attribute keep : boolean;
attribute keep of fault_inj_ctrl : signal is true;
attribute keep of fault_pulse_gen_st : signal is true;
attribute keep of sig_clock_count : signal is true;
attribute keep of sig_fault_trig_width : signal is true;
attribute keep of sig_sync_fault_inj_en : signal is true;
attribute keep of sig_comb_fault_inj_en : signal is true;
attribute keep of pulse : signal is true;
attribute keep of pulse_cnt : signal is true;
attribute keep of gap_cnt : signal is true;

begin
out_clock_count <= sig_clock_count (7 downto 0);
----fault location select: 000->cpu bus switch , 001->cpu pc update, 010-> cpu alu, 
----fault injection type: 00-> single fault, 01->temporary fault, 10-> permanent fault--
fault_inj_ctrl.fault_location_sel <= fault_inj_ctrl_reg (31 downto 29);
fault_inj_ctrl.fault_inj_type     <= fault_inj_ctrl_reg (28 downto 27);
fault_inj_ctrl.fault_type_sel <= fault_inj_ctrl_reg (26 downto 25);
fault_inj_ctrl.fault_ref_count <= fault_inj_ctrl_reg (24 downto 17);
fault_inj_ctrl.fault_trig_width <= fault_inj_ctrl_reg (16 downto 15);
fault_inj_ctrl.gap_bw_faults <= fault_inj_ctrl_reg (14 downto 11);
fault_inj_ctrl.random_sel <= fault_inj_ctrl_reg (10);
sig_ref_count <= to_integer (unsigned(fault_inj_ctrl.fault_ref_count));
sig_clock_count_int <= to_integer (unsigned(sig_clock_count));
sig_fault_trig_width <= to_integer (unsigned (fault_inj_ctrl.fault_trig_width));
sig_gap_bw_faults <= to_integer (unsigned (fault_inj_ctrl.gap_bw_faults));
sig_random_sel <= fault_inj_ctrl.random_sel;

control_fsm: process(in_clk, in_rst_n)
begin
if (in_rst_n = '0') then
fault_inj_ctrl.state <= IDLE;
elsif rising_edge(in_clk) then

-------------finite state machine---------------------
  case  fault_inj_ctrl.state is

    when IDLE => 
        for i in 0 to NO_OF_COMB_LOC -1 loop
            sig_comb_fault_inj_en(i).fault_inj_trigger <= '0';
            sig_comb_fault_inj_en(i).fault_type_sel <= (others => '0');
        end loop;
                
        for j in 0 to NO_OF_SYNC_LOC -1 loop
            sig_sync_fault_inj_en(j).fault_inj_trigger <= '0';
            sig_sync_fault_inj_en(j).fault_type_sel <= (others => '0');
        end loop;
         
        if (sig_clock_count_int = sig_ref_count) then 
            fault_inj_ctrl.state <= INJECT;
            pulse_trig_flag <= '1'; --enable the pulse gen state machine
        else
            fault_inj_ctrl.state <= IDLE;
        end if;
    when INJECT => 
        case  fault_inj_ctrl.fault_location_sel is 
          when "000" => ---- location 1
            case fault_inj_ctrl.fault_inj_type is  
              
              when "00" => ---single fault
                
                for i in 0 to NO_OF_COMB_LOC_1 -1 loop
                    sig_comb_fault_inj_en (i).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse (i);
                    sig_comb_fault_inj_en (i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                for j in 0 to NO_OF_SYNC_LOC_1 -1 loop
                    sig_sync_fault_inj_en (j).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse (j);
                    sig_sync_fault_inj_en (j).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                if (sig_clock_count_int = (sig_ref_count + sig_fault_trig_width + 3 )) then              
                fault_inj_ctrl.state <= WAIT_STATE;
                pulse_trig_flag <= '0';
                else
                    fault_inj_ctrl.state <= INJECT;
                end if;
              
              when "01" =>  ---Temporory Fault
                       
                for i in 0 to NO_OF_COMB_LOC_1 -1 loop
                    sig_comb_fault_inj_en (i).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse (i);
                    sig_comb_fault_inj_en (i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                for j in 0 to NO_OF_SYNC_LOC_1 -1 loop
                    sig_sync_fault_inj_en (j).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse (j);
                    sig_sync_fault_inj_en (j).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                   
                if (sig_clock_count_int = sig_ref_count + 50) then 
                    fault_inj_ctrl.state <= WAIT_STATE;
                    pulse_trig_flag <= '0';
                else
                    fault_inj_ctrl.state <= INJECT;
                end if;
              
              when "10" =>   ---Permanent fault
                           
                for i in 0 to NO_OF_COMB_LOC_1 -1 loop
                    sig_comb_fault_inj_en(i).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse (i);
                    sig_comb_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                for j in 0 to NO_OF_SYNC_LOC_1 -1 loop
                    sig_sync_fault_inj_en(j).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse (j);
                    sig_sync_fault_inj_en(j).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                if (sig_clock_count_int = sig_ref_count + 50) then 
                    fault_inj_ctrl.state <= WAIT_STATE;
                    pulse_trig_flag <= '0';
                else
                    fault_inj_ctrl.state <= INJECT;
                end if;
              
              when others =>  
                for i in 0 to NO_OF_COMB_LOC_1 -1 loop
                    sig_comb_fault_inj_en(i).fault_inj_trigger <= '0';
                    sig_comb_fault_inj_en(i).fault_type_sel <= (others => '0');
                end loop;
                
                for j in 0 to NO_OF_SYNC_LOC_1 -1 loop
                    sig_sync_fault_inj_en(j).fault_inj_trigger <= '0';
                    sig_sync_fault_inj_en(j).fault_type_sel <= (others => '0');
                end loop;  
                 pulse_trig_flag <= '0';
                fault_inj_ctrl.state <= WAIT_STATE;
           end case;
                
          when "001" =>
            case fault_inj_ctrl.fault_inj_type is  
              
              when "00" =>
                                
                for i in 8 to (8 + NO_OF_COMB_LOC_2)-1 loop
                    sig_comb_fault_inj_en(i).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse (i-8);
                    sig_comb_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                for j in 8 to (8 + NO_OF_SYNC_LOC_2) -1 loop
                    sig_sync_fault_inj_en(j).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse (j-8);
                    sig_sync_fault_inj_en(j).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                if (sig_clock_count_int = sig_ref_count + sig_fault_trig_width) then              
                fault_inj_ctrl.state <= WAIT_STATE;
                fault_inj_ctrl.state <= INJECT;
                pulse_trig_flag <= '0';
                end if;
              
              when "01" =>
                       
                for i in 8 to (8 + NO_OF_COMB_LOC_2)-1 loop
                    sig_comb_fault_inj_en(i).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse (i-8);
                    sig_comb_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                for j in 8 to (8 + NO_OF_SYNC_LOC_2) -1 loop
                    sig_sync_fault_inj_en(j).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse (j-8);
                    sig_sync_fault_inj_en(j).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                   
                if (sig_clock_count_int = sig_ref_count + 50) then 
                    fault_inj_ctrl.state <= WAIT_STATE;
                    pulse_trig_flag <= '0';
                else
                    fault_inj_ctrl.state <= INJECT;
                end if;
              
              when "10" =>
                         
                for i in 8 to (8 + NO_OF_COMB_LOC_2)-1 loop
                    sig_comb_fault_inj_en(i).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse (i-8);
                    sig_comb_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                for j in 8 to (8 + NO_OF_SYNC_LOC_2) -1 loop
                    sig_sync_fault_inj_en(j).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse (j-8);
                    sig_sync_fault_inj_en(j).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                if (sig_clock_count_int = sig_ref_count + 50) then 
                    fault_inj_ctrl.state <= WAIT_STATE;
                    pulse_trig_flag <= '0';
                else
                    fault_inj_ctrl.state <= INJECT;
                end if;
              
              when others =>  
                for i in 8 to (8 + NO_OF_COMB_LOC_2)-1 loop
                    sig_comb_fault_inj_en(i).fault_inj_trigger <= '0';
                    sig_comb_fault_inj_en(i).fault_type_sel <= (others => '0');
                end loop;
                
                for j in 8 to (8 + NO_OF_SYNC_LOC_2) -1 loop
                    sig_sync_fault_inj_en(j).fault_inj_trigger <= '0';
                    sig_sync_fault_inj_en(j).fault_type_sel <= (others => '0');
                end loop;  
                 pulse_trig_flag <= '0';
                fault_inj_ctrl.state <= WAIT_STATE;
           end case;
           
          when "010" =>
             case fault_inj_ctrl.fault_inj_type is  
              
              when "00" =>
                            
                for i in 16 to (16 + NO_OF_COMB_LOC_3) -1 loop
                    sig_comb_fault_inj_en(i).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse (i-16);
                    sig_comb_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                for j in 16 to (16 + NO_OF_SYNC_LOC_3) -1 loop
                    sig_sync_fault_inj_en(j).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse (j-16);
                    sig_sync_fault_inj_en(j).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                if (sig_clock_count_int = sig_ref_count + sig_fault_trig_width) then              
                fault_inj_ctrl.state <= WAIT_STATE;
                fault_inj_ctrl.state <= INJECT;
                pulse_trig_flag <= '0';
                end if;
              
              when "01" =>
                         
                for i in 16 to (16 + NO_OF_COMB_LOC_3) -1 loop
                    sig_comb_fault_inj_en(i).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse (i-16);
                    sig_comb_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                for j in 16 to (16 + NO_OF_SYNC_LOC_3) -1 loop
                    sig_sync_fault_inj_en(j).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse (j-16);
                    sig_sync_fault_inj_en(j).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                   
                if (sig_clock_count_int = sig_ref_count + 50) then 
                    fault_inj_ctrl.state <= WAIT_STATE;
                    pulse_trig_flag <= '0';
                else
                    fault_inj_ctrl.state <= INJECT;
                end if;
              
              when "10" =>
                            
                for i in 16 to (16 + NO_OF_COMB_LOC_3) -1 loop
                    sig_comb_fault_inj_en(i).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse (i-16);
                    sig_comb_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                for j in 16 to (16 + NO_OF_SYNC_LOC_3) -1 loop
                    sig_sync_fault_inj_en(j).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse (j-16);
                    sig_sync_fault_inj_en(j).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                if (sig_clock_count_int = sig_ref_count + 50) then 
                    fault_inj_ctrl.state <= WAIT_STATE;
                    pulse_trig_flag <= '0';
                else
                    fault_inj_ctrl.state <= INJECT;
                end if;
              
              when others =>  
                for i in 16 to (16 + NO_OF_COMB_LOC_3) -1 loop
                    sig_comb_fault_inj_en(i).fault_inj_trigger <= '0';
                    sig_comb_fault_inj_en(i).fault_type_sel <= (others => '0');
                end loop;
                
                for j in 16 to (16 + NO_OF_SYNC_LOC_3) -1 loop
                    sig_sync_fault_inj_en(j).fault_inj_trigger <= '0';
                    sig_sync_fault_inj_en(j).fault_type_sel <= (others => '0');
                end loop;  
                pulse_trig_flag <= '0';
                fault_inj_ctrl.state <= WAIT_STATE;
           end case;
         when "011" => ---- All 3 locations together
            case fault_inj_ctrl.fault_inj_type is  
              
              when "00" => ---single fault
                
                for i in 0 to NO_OF_COMB_LOC -1 loop
                    sig_comb_fault_inj_en (i).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse_24 (i);
                    sig_comb_fault_inj_en (i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                for j in 0 to NO_OF_SYNC_LOC -1 loop
                    sig_sync_fault_inj_en (j).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse_24 (j);
                    sig_sync_fault_inj_en (j).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                if (sig_clock_count_int = (sig_ref_count + sig_fault_trig_width + 3 )) then              
                fault_inj_ctrl.state <= WAIT_STATE;
                pulse_trig_flag <= '0';
                else
                    fault_inj_ctrl.state <= INJECT;
                end if;
              
              when "01" =>  ---Temporory Fault
                       
                for i in 0 to NO_OF_COMB_LOC -1 loop
                    sig_comb_fault_inj_en (i).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse_24 (i);
                    sig_comb_fault_inj_en (i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                for j in 0 to NO_OF_SYNC_LOC -1 loop
                    sig_sync_fault_inj_en (j).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse_24 (j);
                    sig_sync_fault_inj_en (j).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                   
                if (sig_clock_count_int = sig_ref_count + 50) then 
                    fault_inj_ctrl.state <= WAIT_STATE;
                    pulse_trig_flag <= '0';
                else
                    fault_inj_ctrl.state <= INJECT;
                end if;
              
              when "10" =>   ---Permanent fault
                           
                for i in 0 to NO_OF_COMB_LOC -1 loop
                    sig_comb_fault_inj_en(i).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse_24 (i);
                    sig_comb_fault_inj_en(i).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                for j in 0 to NO_OF_SYNC_LOC -1 loop
                    sig_sync_fault_inj_en(j).fault_inj_trigger <= pulse when sig_random_sel = '0' else randomised_pulse_24 (j);
                    sig_sync_fault_inj_en(j).fault_type_sel <= fault_inj_ctrl.fault_type_sel;
                end loop;
                
                if (sig_clock_count_int = sig_ref_count + 50) then 
                    fault_inj_ctrl.state <= WAIT_STATE;
                    pulse_trig_flag <= '0';
                else
                    fault_inj_ctrl.state <= INJECT;
                end if;
              
              when others =>  
                for i in 0 to NO_OF_COMB_LOC -1 loop
                    sig_comb_fault_inj_en(i).fault_inj_trigger <= '0';
                    sig_comb_fault_inj_en(i).fault_type_sel <= (others => '0');
                end loop;
                
                for j in 0 to NO_OF_SYNC_LOC -1 loop
                    sig_sync_fault_inj_en(j).fault_inj_trigger <= '0';
                    sig_sync_fault_inj_en(j).fault_type_sel <= (others => '0');
                end loop;  
                 pulse_trig_flag <= '0';
                fault_inj_ctrl.state <= WAIT_STATE;
          end case;
                
          when others =>    
                for i in 0 to NO_OF_COMB_LOC -1 loop
                    sig_comb_fault_inj_en(i).fault_inj_trigger <= '0';
                    sig_comb_fault_inj_en(i).fault_type_sel <= (others => '0');
                end loop;
                
                for j in 0 to NO_OF_SYNC_LOC -1 loop
                    sig_sync_fault_inj_en(j).fault_inj_trigger <= '0';
                    sig_sync_fault_inj_en(j).fault_type_sel <= (others => '0');
                end loop;  
                pulse_trig_flag <= '0';
                fault_inj_ctrl.state <= WAIT_STATE;
      end case;
      
    when WAIT_STATE => 
       for i in 0 to NO_OF_COMB_LOC -1 loop
            sig_comb_fault_inj_en(i).fault_inj_trigger <= '0';
            sig_comb_fault_inj_en(i).fault_type_sel <= (others => '0');
        end loop;
                
        for j in 0 to NO_OF_SYNC_LOC -1 loop
            sig_sync_fault_inj_en(j).fault_inj_trigger <= '0';
            sig_sync_fault_inj_en(j).fault_type_sel <= (others => '0');
        end loop; 
                
        fault_inj_ctrl.state <= IDLE;
    
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
 
    case fault_pulse_gen_st is
    when INIT =>
        pulse <= '0';
        pulse_cnt <= (others => '0');
        gap_cnt <= (others => '0');
        if (pulse_trig_flag = '1') then
            fault_pulse_gen_st <= PULSE_TRIG;
            pulse <= '1';
        else
            fault_pulse_gen_st <= INIT;
        end if; 
               
    when PULSE_TRIG => 
        pulse_cnt <= pulse_cnt + 1;
        if pulse_cnt = unsigned(fault_inj_ctrl.fault_trig_width) - 1 then
            pulse_cnt <= (others => '0');
            if fault_inj_ctrl.gap_bw_faults /= "0000" then 
                fault_pulse_gen_st <= GAP_TRIG;
                pulse <= '0';
            else 
                fault_pulse_gen_st <= PULSE_TRIG;
            end if;
        end if;
        if (pulse_trig_flag = '0') then
            fault_pulse_gen_st <= INIT;
        end if;
    when GAP_TRIG =>
        gap_cnt <= gap_cnt + 1;
        if gap_cnt =  unsigned(fault_inj_ctrl.gap_bw_faults) - 1 then
            gap_cnt <= (others => '0');
            pulse_cnt <= (others => '0');
            fault_pulse_gen_st <= PULSE_TRIG;
            pulse <= '1';
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


-------Random pulse generator---------------------------------------------

pulse_randomiser_inst: pulse_randomiser
port map (
    in_pulse => pulse,
    in_clk   => in_clk,
    in_reset => in_rst_n,
    out_pulse_8 => randomised_pulse,
    out_pulse_24 => randomised_pulse_24
 );
------------------------------------------------------------------------------------
-----------Register the fault enable signals for better timing----------------------
process(in_clk, in_rst_n)
begin
 if (in_rst_n = '0') then
    for i in 0 to NO_OF_COMB_LOC -1 loop
        out_comb_fault_inj_en(i).fault_inj_trigger <= '0';
        out_comb_fault_inj_en(i).fault_type_sel <= (others => '0');
    end loop;
    
    for j in 0 to NO_OF_SYNC_LOC -1 loop
        out_sync_fault_inj_en(j).fault_inj_trigger <= '0';
        out_sync_fault_inj_en(j).fault_type_sel <= (others => '0');
    end loop;
    
 elsif rising_edge(in_clk) then
    out_comb_fault_inj_en <= sig_comb_fault_inj_en;
    out_sync_fault_inj_en <= sig_sync_fault_inj_en;
 end if;

end process;
---------------Free running counter-------------------------------
free_running_counter_inst: free_running_counter
    port map
	( clk_i => in_clk,
      rstn_int => in_rst_n,
      count => sig_clock_count
	);
 
 
end Behavioral;