----------------------------------------------------------------------------------
-- Company: Ulster University
-- Engineer: Nidhin Thandassery Sumithran
-- 
-- Create Date: 18.08.2023 10:38:17
-- Design Name: 
-- Module Name: fault_inj_sync_8_15 - Behavioral
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
use ieee.numeric_std.all;

library neorv32_ft_lib;
use neorv32_ft_lib.neorv32_ft_package.all;

entity fault_inj_sync_8_15 is
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
end fault_inj_sync_8_15;

architecture Behavioral of fault_inj_sync_8_15 is

signal pc_bit0, pc_bit1, pc_bit2, pc_bit3, pc_bit4, pc_bit5, pc_bit6, pc_bit7: std_logic;
signal sig_out_from_ff : std_logic_vector (7 downto 0);
signal tap_execute_pc : std_logic_vector (7 downto 0);
signal temp_cntrl_ff_out, temp_cntrl_ff_out_d1 : std_logic_vector  (7 downto 0);
signal temp_cntrl_ff_out_1,temp_cntrl_ff_out_1_d1 : std_logic_vector (7 downto 0);

attribute keep : boolean;
attribute keep of sig_out_from_ff : signal is true; 
attribute keep of tap_execute_pc : signal is true; 
attribute keep of pc_bit0, pc_bit1, pc_bit2, pc_bit3, pc_bit4, pc_bit5, pc_bit6, pc_bit7 : signal is true;

begin

fiu_out_data_o <= ( pc_bit7 & pc_bit6 & pc_bit5 & pc_bit4 & pc_bit3 & pc_bit2 & pc_bit1 & pc_bit0 );
--sig_out_from_ff <= flip_flop_o;
  ------------------------------Fault injection--------------------------------------------
fault_injection_8_sync_false: if (FAULT_INJ_SYNC_8 = false) generate ---LSB

no_fault_8: process (pc_we)
begin
    if (pc_we = '1') then
        if (pc_mux_sel='0') then
			pc_bit0 <= next_pc(0);
		else 
		    pc_bit0 <= alu_add(0);
		end if;	
    end if;
end process no_fault_8;  
       
end generate; 

fault_injection_9_sync_false: if (FAULT_INJ_SYNC_9 = false) generate

no_fault_9: process (pc_we)
begin
    if (pc_we = '1') then
        if (pc_mux_sel='0') then
			pc_bit1 <= next_pc(1);
		else 
		    pc_bit1 <= alu_add(1);
		end if;	
    end if;
end process no_fault_9;  
       
end generate; 


fault_injection_10_sync_false: if (FAULT_INJ_SYNC_10 = false) generate

no_fault_10: process (pc_we)
begin
    if (pc_we = '1') then
        if (pc_mux_sel='0') then
			pc_bit2 <= next_pc(2);
		else 
		    pc_bit2 <= alu_add(2);
		end if;	
    end if;
end process no_fault_10;  
       
end generate; 


fault_injection_11_sync_false: if (FAULT_INJ_SYNC_11 = false) generate

no_fault_11: process (pc_we)
begin
    if (pc_we = '1') then
        if (pc_mux_sel='0') then
			pc_bit3 <= next_pc(3);
		else 
		    pc_bit3 <= alu_add(3);
		end if;	
    end if;
end process no_fault_11;  
       
end generate; 

fault_injection_12_sync_false: if (FAULT_INJ_SYNC_12 = false) generate

no_fault_12: process (pc_we)
begin
    if (pc_we = '1') then
        if (pc_mux_sel='0') then
			pc_bit4 <= next_pc(4);
		else 
		    pc_bit4 <= alu_add(4);
		end if;	
    end if;
end process no_fault_12;  
       
end generate; 

fault_injection_13_sync_false: if (FAULT_INJ_SYNC_13 = false) generate

no_fault_13: process (pc_we)
begin
    if (pc_we = '1') then
        if (pc_mux_sel='0') then
			pc_bit5 <= next_pc(5);
		else 
		    pc_bit5 <= alu_add(5);
		end if;	
    end if;
end process no_fault_13;  
       
end generate;

fault_injection_14_sync_false: if (FAULT_INJ_SYNC_14 = false) generate

no_fault_14: process (pc_we)
begin
    if (pc_we = '1') then
        if (pc_mux_sel='0') then
			pc_bit6 <= next_pc(6);
		else 
		    pc_bit6 <= alu_add(6);
		end if;	
    end if;
end process no_fault_14;  
       
end generate;

fault_injection_15_sync_false: if (FAULT_INJ_SYNC_15 = false) generate

no_fault_15: process (pc_we)
begin
    if (pc_we = '1') then
        if (pc_mux_sel='0') then
			pc_bit7 <= next_pc(7);
		else 
		    pc_bit7 <= alu_add(7);
		end if;	
    end if;
end process no_fault_15;  
       
end generate;

---------------------------fault inj and det at sync 8 start--------------------------------
fault_injection_8_sync_true : if (FAULT_INJ_SYNC_8 = true) generate

tap_signal_8: process (pc_we)
begin
    if (pc_we = '1') then
        if (pc_mux_sel='0') then        
			tap_execute_pc (0) <= next_pc(0);
		else 
		    tap_execute_pc (0) <= alu_add(0);
		end if;	
	else
	   tap_execute_pc (0) <= '0';
    end if;
end process tap_signal_8;  

temp_cntrl_ff_out (0) <= '1' when (pc_we = '1' AND pc_mux_sel='0') else '0';
temp_cntrl_ff_out_1 (0) <= '1' when (pc_we = '1' AND pc_mux_sel='1') else '0';

delay_temp_cntrl_ff_8: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		temp_cntrl_ff_out_d1 (0) <= '0';
		temp_cntrl_ff_out_1_d1 (0) <= '0';
    elsif rising_edge(clk_i) then
		temp_cntrl_ff_out_d1 (0) <= temp_cntrl_ff_out (0);
		temp_cntrl_ff_out_1_d1 (0) <= temp_cntrl_ff_out_1 (0);
	end if;
  end process delay_temp_cntrl_ff_8;
  
process (temp_cntrl_ff_out_d1 (0), temp_cntrl_ff_out_1_d1 (0))
begin
 if ((temp_cntrl_ff_out_d1 (0) or temp_cntrl_ff_out_1_d1 (0)) = '1') then 
    sig_out_from_ff (0) <= flip_flop_o (0);
 else
    sig_out_from_ff (0) <= '0';
 end if;
end process;
    
----------------------fault injection unit-----------------------------------------------
fault_inj_unit_inst_sync_8 : fault_injection_logic

port map ( 
    in_data => tap_execute_pc (0),
    in_fault_type_sel => fault_inj_type_sync_8_15_i (0),
    in_fault_inject => fault_inj_trig_sync_8_15_i (0),
    out_data => pc_bit0
 );

--------------------fault detection logic------------------------------------------------
fdl_inst_sync_8 : fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_execute_pc (0),
    in_destination => sig_out_from_ff (0),
    out_fault_status => fault_status_sync_8_15_o (0),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_8_sync_true;  
---------------------------fault inj and det at sync 8 end--------------------------------

---------------------------fault inj and det at sync 9 start--------------------------------
fault_injection_9_sync_true : if (FAULT_INJ_SYNC_9 = true) generate

tap_signal_9 : process (pc_we)
begin
    if (pc_we = '1') then
        if (pc_mux_sel='0') then        
			tap_execute_pc (1) <= next_pc(1);
		else 
		    tap_execute_pc (1) <= alu_add(1);
		end if;	
	else
	   tap_execute_pc (1) <= '0';
    end if;
end process tap_signal_9;  

temp_cntrl_ff_out (1) <= '1' when (pc_we = '1' AND pc_mux_sel='0') else '0';
temp_cntrl_ff_out_1 (1) <= '1' when (pc_we = '1' AND pc_mux_sel='1') else '0';

delay_temp_cntrl_ff_9: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		temp_cntrl_ff_out_d1 (1) <= '0';
		temp_cntrl_ff_out_1_d1 (1) <= '0';
    elsif rising_edge(clk_i) then
		temp_cntrl_ff_out_d1 (1) <= temp_cntrl_ff_out (1);
		temp_cntrl_ff_out_1_d1 (1) <= temp_cntrl_ff_out_1 (1);
	end if;
  end process delay_temp_cntrl_ff_9;
  
process (temp_cntrl_ff_out_d1 (1), temp_cntrl_ff_out_1_d1 (1))
begin
 if ((temp_cntrl_ff_out_d1 (1) or temp_cntrl_ff_out_1_d1 (1))='1') then 
    sig_out_from_ff (1) <= flip_flop_o (1);
 else
    sig_out_from_ff (1) <= '0';
 end if;
end process;
    
----------------------fault injection unit-----------------------------------------------
fault_inj_unit_inst_sync_9 : fault_injection_logic

port map ( 
    in_data => tap_execute_pc (1),
    in_fault_type_sel => fault_inj_type_sync_8_15_i (1),
    in_fault_inject => fault_inj_trig_sync_8_15_i (1),
    out_data => pc_bit1
 );

--------------------fault detection logic------------------------------------------------
fdl_inst_sync_9 : fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_execute_pc (1),
    in_destination => sig_out_from_ff (1),
    out_fault_status => fault_status_sync_8_15_o (1),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_9_sync_true;  
---------------------------fault inj and det at sync 9 end--------------------------------


---------------------------fault inj and det at sync 10 start--------------------------------
fault_injection_10_sync_true : if (FAULT_INJ_SYNC_10 = true) generate

tap_signal_10 : process (pc_we)
begin
    if (pc_we = '1') then
        if (pc_mux_sel='0') then        
			tap_execute_pc (2) <= next_pc(2);
		else 
		    tap_execute_pc (2) <= alu_add(2);
		end if;	
	else
	   tap_execute_pc (2) <= '0';
    end if;
end process tap_signal_10;  

temp_cntrl_ff_out (2) <= '1' when (pc_we = '1' AND pc_mux_sel='0') else '0';
temp_cntrl_ff_out_1 (2) <= '1' when (pc_we = '1' AND pc_mux_sel='1') else '0';

delay_temp_cntrl_ff_10: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		temp_cntrl_ff_out_d1 (2) <= '0';
		temp_cntrl_ff_out_1_d1 (2) <= '0';
    elsif rising_edge(clk_i) then
		temp_cntrl_ff_out_d1 (2) <= temp_cntrl_ff_out (2);
		temp_cntrl_ff_out_1_d1 (2) <= temp_cntrl_ff_out_1 (2);
	end if;
  end process delay_temp_cntrl_ff_10;
  
process (temp_cntrl_ff_out_d1 (2), temp_cntrl_ff_out_1_d1 (2))
begin
 if ((temp_cntrl_ff_out_d1 (2) or temp_cntrl_ff_out_1_d1 (2))='1') then 
    sig_out_from_ff (2) <= flip_flop_o (2);
 else
    sig_out_from_ff (2) <= '0';
 end if;
end process;
    
----------------------fault injection unit-----------------------------------------------
fault_inj_unit_inst_sync_10 : fault_injection_logic

port map ( 
    in_data => tap_execute_pc (2),
    in_fault_type_sel => fault_inj_type_sync_8_15_i (2),
    in_fault_inject => fault_inj_trig_sync_8_15_i (2),
    out_data => pc_bit2
 );

--------------------fault detection logic------------------------------------------------
fdl_inst_sync_10 : fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_execute_pc (2),
    in_destination => sig_out_from_ff (2),
    out_fault_status => fault_status_sync_8_15_o (2),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_10_sync_true;  
---------------------------fault inj and det at sync 10 end--------------------------------

---------------------------fault inj and det at sync 11 start--------------------------------
fault_injection_11_sync_true : if (FAULT_INJ_SYNC_11 = true) generate

tap_signal_11 : process (pc_we)
begin
    if (pc_we = '1') then
        if (pc_mux_sel='0') then        
			tap_execute_pc (3) <= next_pc(3);
		else 
		    tap_execute_pc (3) <= alu_add(3);
		end if;	
	else
	   tap_execute_pc (3) <= '0';
    end if;
end process tap_signal_11;  

temp_cntrl_ff_out (3) <= '1' when (pc_we = '1' AND pc_mux_sel='0') else '0';
temp_cntrl_ff_out_1 (3) <= '1' when (pc_we = '1' AND pc_mux_sel='1') else '0';

delay_temp_cntrl_ff_11: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		temp_cntrl_ff_out_d1 (3) <= '0';
		temp_cntrl_ff_out_1_d1 (3) <= '0';
    elsif rising_edge(clk_i) then
		temp_cntrl_ff_out_d1 (3) <= temp_cntrl_ff_out (3);
		temp_cntrl_ff_out_1_d1 (3) <= temp_cntrl_ff_out_1 (3);
	end if;
  end process delay_temp_cntrl_ff_11;
  
process (temp_cntrl_ff_out_d1 (3), temp_cntrl_ff_out_1_d1 (3))
begin
 if ((temp_cntrl_ff_out_d1 (3) or temp_cntrl_ff_out_1_d1 (3))='1') then 
    sig_out_from_ff (3) <= flip_flop_o (3);
 else
    sig_out_from_ff (3) <= '0';
 end if;
end process;
    
----------------------fault injection unit-----------------------------------------------
fault_inj_unit_inst_sync_11 : fault_injection_logic

port map ( 
    in_data => tap_execute_pc (3),
    in_fault_type_sel => fault_inj_type_sync_8_15_i (3),
    in_fault_inject => fault_inj_trig_sync_8_15_i (3),
    out_data => pc_bit3
 );

--------------------fault detection logic------------------------------------------------
fdl_inst_sync_11 : fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_execute_pc (3),
    in_destination => sig_out_from_ff (3),
    out_fault_status => fault_status_sync_8_15_o (3),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_11_sync_true;  
---------------------------fault inj and det at sync 11 end--------------------------------


---------------------------fault inj and det at sync 12 start--------------------------------
fault_injection_12_sync_true : if (FAULT_INJ_SYNC_12 = true) generate

tap_signal_12 : process (pc_we)
begin
    if (pc_we = '1') then
        if (pc_mux_sel='0') then        
			tap_execute_pc (4) <= next_pc(4);
		else 
		    tap_execute_pc (4) <= alu_add(4);
		end if;	
	else
	   tap_execute_pc (4) <= '0';
    end if;
end process tap_signal_12;  

temp_cntrl_ff_out (4) <= '1' when (pc_we = '1' AND pc_mux_sel='0') else '0';
temp_cntrl_ff_out_1 (4) <= '1' when (pc_we = '1' AND pc_mux_sel='1') else '0';

delay_temp_cntrl_ff_12: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		temp_cntrl_ff_out_d1 (4) <= '0';
		temp_cntrl_ff_out_1_d1 (4) <= '0';
    elsif rising_edge(clk_i) then
		temp_cntrl_ff_out_d1 (4) <= temp_cntrl_ff_out (4);
		temp_cntrl_ff_out_1_d1 (4) <= temp_cntrl_ff_out_1 (4);
	end if;
  end process delay_temp_cntrl_ff_12;
  
process (temp_cntrl_ff_out_d1 (4), temp_cntrl_ff_out_1_d1 (4))
begin
 if ((temp_cntrl_ff_out_d1 (4) or temp_cntrl_ff_out_1_d1 (4))='1') then 
    sig_out_from_ff (4) <= flip_flop_o (4);
 else
    sig_out_from_ff (4) <= '0';
 end if;
end process;
    
----------------------fault injection unit-----------------------------------------------
fault_inj_unit_inst_sync_12 : fault_injection_logic

port map ( 
    in_data => tap_execute_pc (4),
    in_fault_type_sel => fault_inj_type_sync_8_15_i (4),
    in_fault_inject => fault_inj_trig_sync_8_15_i (4),
    out_data => pc_bit4
 );

--------------------fault detection logic------------------------------------------------
fdl_inst_sync_12 : fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_execute_pc (4),
    in_destination => sig_out_from_ff (4),
    out_fault_status => fault_status_sync_8_15_o (4),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_12_sync_true;  
---------------------------fault inj and det at sync 12 end--------------------------------

---------------------------fault inj and det at sync 13 start--------------------------------
fault_injection_13_sync_true : if (FAULT_INJ_SYNC_13 = true) generate

tap_signal_13 : process (pc_we)
begin
    if (pc_we = '1') then
        if (pc_mux_sel='0') then        
			tap_execute_pc (5) <= next_pc(5);
		else 
		    tap_execute_pc (5) <= alu_add(5);
		end if;	
	else
	   tap_execute_pc (5) <= '0';
    end if;
end process tap_signal_13;  

temp_cntrl_ff_out (5) <= '1' when (pc_we = '1' AND pc_mux_sel='0') else '0';
temp_cntrl_ff_out_1 (5) <= '1' when (pc_we = '1' AND pc_mux_sel='1') else '0';

delay_temp_cntrl_ff_13: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		temp_cntrl_ff_out_d1 (5) <= '0';
		temp_cntrl_ff_out_1_d1 (5) <= '0';
    elsif rising_edge(clk_i) then
		temp_cntrl_ff_out_d1 (5) <= temp_cntrl_ff_out (5);
		temp_cntrl_ff_out_1_d1 (5) <= temp_cntrl_ff_out_1 (5);
	end if;
  end process delay_temp_cntrl_ff_13;
  
process (temp_cntrl_ff_out_d1 (5), temp_cntrl_ff_out_1_d1 (5))
begin
 if ((temp_cntrl_ff_out_d1 (5) or temp_cntrl_ff_out_1_d1 (5))='1') then 
    sig_out_from_ff (5) <= flip_flop_o (5);
 else
    sig_out_from_ff (5) <= '0';
 end if;
end process;
    
----------------------fault injection unit-----------------------------------------------
fault_inj_unit_inst_sync_13 : fault_injection_logic

port map ( 
    in_data => tap_execute_pc (5),
    in_fault_type_sel => fault_inj_type_sync_8_15_i (5),
    in_fault_inject => fault_inj_trig_sync_8_15_i (5),
    out_data => pc_bit5
 );

--------------------fault detection logic------------------------------------------------
fdl_inst_sync_13 : fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_execute_pc (5),
    in_destination => sig_out_from_ff (5),
    out_fault_status => fault_status_sync_8_15_o (5),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_13_sync_true;  
---------------------------fault inj and det at sync 13 end--------------------------------

---------------------------fault inj and det at sync 14 start--------------------------------
fault_injection_14_sync_true : if (FAULT_INJ_SYNC_14 = true) generate

tap_signal_14 : process (pc_we)
begin
    if (pc_we = '1') then
        if (pc_mux_sel='0') then        
			tap_execute_pc (6) <= next_pc(6);
		else 
		    tap_execute_pc (6) <= alu_add(6);
		end if;	
	else
	   tap_execute_pc (6) <= '0';
    end if;
end process tap_signal_14;  

temp_cntrl_ff_out (6) <= '1' when (pc_we = '1' AND pc_mux_sel='0') else '0';
temp_cntrl_ff_out_1 (6) <= '1' when (pc_we = '1' AND pc_mux_sel='1') else '0';

delay_temp_cntrl_ff_14: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		temp_cntrl_ff_out_d1 (6) <= '0';
		temp_cntrl_ff_out_1_d1 (6) <= '0';
    elsif rising_edge(clk_i) then
		temp_cntrl_ff_out_d1 (6) <= temp_cntrl_ff_out (6);
		temp_cntrl_ff_out_1_d1 (6) <= temp_cntrl_ff_out_1 (6);
	end if;
  end process delay_temp_cntrl_ff_14;
  
process (temp_cntrl_ff_out_d1 (6), temp_cntrl_ff_out_1_d1 (6))
begin
 if ((temp_cntrl_ff_out_d1 (6) or temp_cntrl_ff_out_1_d1 (6))='1') then 
    sig_out_from_ff (6) <= flip_flop_o (6);
 else
    sig_out_from_ff (6) <= '0';
 end if;
end process;
    
----------------------fault injection unit-----------------------------------------------
fault_inj_unit_inst_sync_14 : fault_injection_logic

port map ( 
    in_data => tap_execute_pc (6),
    in_fault_type_sel => fault_inj_type_sync_8_15_i (6),
    in_fault_inject => fault_inj_trig_sync_8_15_i (6),
    out_data => pc_bit6
 );

--------------------fault detection logic------------------------------------------------
fdl_inst_sync_14 : fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_execute_pc (6),
    in_destination => sig_out_from_ff (6),
    out_fault_status => fault_status_sync_8_15_o (6),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_14_sync_true;  
---------------------------fault inj and det at sync 14 end--------------------------------


---------------------------fault inj and det at sync 15 start--------------------------------
fault_injection_15_sync_true : if (FAULT_INJ_SYNC_15 = true) generate

tap_signal_15 : process (pc_we)
begin
    if (pc_we = '1') then
        if (pc_mux_sel='0') then        
			tap_execute_pc (7) <= next_pc(7);
		else 
		    tap_execute_pc (7) <= alu_add(7);
		end if;	
	else
	   tap_execute_pc (7) <= '0';
    end if;
end process tap_signal_15;  

temp_cntrl_ff_out (7) <= '1' when (pc_we = '1' AND pc_mux_sel='0') else '0';
temp_cntrl_ff_out_1 (7) <= '1' when (pc_we = '1' AND pc_mux_sel='1') else '0';

delay_temp_cntrl_ff_15: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		temp_cntrl_ff_out_d1 (7) <= '0';
		temp_cntrl_ff_out_1_d1 (7) <= '0';
    elsif rising_edge(clk_i) then
		temp_cntrl_ff_out_d1 (7) <= temp_cntrl_ff_out (7);
		temp_cntrl_ff_out_1_d1 (7) <= temp_cntrl_ff_out_1 (7);
	end if;
  end process delay_temp_cntrl_ff_15;
  
process (temp_cntrl_ff_out_d1 (7), temp_cntrl_ff_out_1_d1 (7))
begin
 if ((temp_cntrl_ff_out_d1 (7) or temp_cntrl_ff_out_1_d1 (7))='1') then 
    sig_out_from_ff (7) <= flip_flop_o (7);
 else
    sig_out_from_ff (7) <= '0';
 end if;
end process;
    
----------------------fault injection unit-----------------------------------------------
fault_inj_unit_inst_sync_15 : fault_injection_logic

port map ( 
    in_data => tap_execute_pc (7),
    in_fault_type_sel => fault_inj_type_sync_8_15_i (7),
    in_fault_inject => fault_inj_trig_sync_8_15_i (7),
    out_data => pc_bit7
 );

--------------------fault detection logic------------------------------------------------
fdl_inst_sync_15 : fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_execute_pc (7),
    in_destination => sig_out_from_ff (7),
    out_fault_status => fault_status_sync_8_15_o (7),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_15_sync_true;  
---------------------------fault inj and det at sync 15 end--------------------------------

end Behavioral;
