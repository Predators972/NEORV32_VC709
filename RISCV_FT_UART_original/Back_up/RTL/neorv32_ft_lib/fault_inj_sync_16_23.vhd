----------------------------------------------------------------------------------
-- Company: Ulster University
-- Engineer: Nidhin Thandassery Sumithran
-- 
-- Create Date: 25.08.2023 14:19:33
-- Design Name: 
-- Module Name: fault_inj_sync_16_23 - Behavioral
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

entity fault_inj_sync_16_23 is
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
end fault_inj_sync_16_23;

architecture Behavioral of fault_inj_sync_16_23 is

signal add_bit0, add_bit1, add_bit2, add_bit3, add_bit4,add_bit5, add_bit6, add_bit7: std_logic;
signal sig_out_from_ff : std_logic_vector (7 downto 0);
signal tap_addr : std_logic_vector (7 downto 0);
signal temp_cntrl_ff_out : std_logic_vector (7 downto 0);
signal temp_cntrl_ff_out_d1 : std_logic_vector (7 downto 0);
signal temp_cntrl_ff_out_1,temp_cntrl_ff_out_1_d1 : std_logic_vector (7 downto 0);

begin

fiu_out_data_o <= ( add_bit7 & add_bit6 & add_bit5 & add_bit4 & add_bit3 & add_bit2 & add_bit1 & add_bit0 );

 ------------------------------Fault injection--------------------------------------------
fault_injection_16_sync_false: if (FAULT_INJ_SYNC_16 = false) generate ---LSB

no_fault_16: process (mul_start)

begin
  if (mul_start = '1') then
	   add_bit0 <= rs1_i (0);
	elsif (ctrl_state = '1') then
	   add_bit0 <= add_i(0);
	end if;
end process no_fault_16;  
       
end generate fault_injection_16_sync_false; 

fault_injection_17_sync_false: if (FAULT_INJ_SYNC_17 = false) generate 

no_fault_17: process (mul_start)

begin
  if (mul_start = '1') then
	   add_bit1 <= rs1_i (1);
	elsif (ctrl_state = '1') then
	   add_bit1 <= add_i(1);
	end if;
end process no_fault_17;  
       
end generate fault_injection_17_sync_false; 


fault_injection_18_sync_false: if (FAULT_INJ_SYNC_18 = false) generate 

no_fault_18: process (mul_start)

begin
  if (mul_start = '1') then
	   add_bit2 <= rs1_i (2);
	elsif (ctrl_state = '1') then
	   add_bit2 <= add_i(2);
	end if;
end process no_fault_18;  
       
end generate fault_injection_18_sync_false; 

fault_injection_19_sync_false: if (FAULT_INJ_SYNC_19 = false) generate 

no_fault_19: process (mul_start)

begin
  if (mul_start = '1') then
	   add_bit3 <= rs1_i (3);
	elsif (ctrl_state = '1') then
	   add_bit3 <= add_i(3);
	end if;
end process no_fault_19;  
       
end generate fault_injection_19_sync_false; 


fault_injection_20_sync_false: if (FAULT_INJ_SYNC_20 = false) generate 

no_fault_20: process (mul_start)

begin
   if (mul_start = '1') then
	   add_bit4 <= rs1_i (4);
	elsif (ctrl_state = '1') then
	   add_bit4 <= add_i(4);
	end if;
end process no_fault_20;  
       
end generate fault_injection_20_sync_false; 


fault_injection_21_sync_false: if (FAULT_INJ_SYNC_21 = false) generate 

no_fault_21: process (mul_start)

begin
  if (mul_start = '1') then
	   add_bit5 <= rs1_i (5);
	elsif (ctrl_state = '1') then
	   add_bit5 <= add_i(5);
	end if;
end process no_fault_21;  
       
end generate fault_injection_21_sync_false;

fault_injection_22_sync_false: if (FAULT_INJ_SYNC_22 = false) generate 

no_fault_22: process (mul_start)

begin
  if (mul_start = '1') then
	   add_bit6 <= rs1_i (6);
	elsif (ctrl_state = '1') then
	   add_bit6 <= add_i(6);
	end if;
end process no_fault_22;  

end generate fault_injection_22_sync_false;

fault_injection_23_sync_false: if (FAULT_INJ_SYNC_23 = false) generate 

no_fault_23: process (mul_start)

begin
  if (mul_start = '1') then
	   add_bit7 <= rs1_i (7);
	elsif (ctrl_state = '1') then
	   add_bit7 <= add_i(7);
	end if;
end process no_fault_23;  
       
end generate fault_injection_23_sync_false;

--sig_out_from_ff <= flip_flop_o;

---------------------------fault inj and det at sync 16 start--------------------------------
fault_injection_16_sync_true : if (FAULT_INJ_SYNC_16 = true) generate

temp_cntrl_ff_out (0) <= '1' when (mul_start = '1') else '0';
temp_cntrl_ff_out_1 (0) <= '1' when (ctrl_state = '1');

delay_temp_cntrl_ff_0: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		  temp_cntrl_ff_out_d1 (0) <= '0';
		  temp_cntrl_ff_out_1_d1 (0) <= '0';
	  elsif rising_edge(clk_i) then
		  temp_cntrl_ff_out_d1 (0) <= temp_cntrl_ff_out (0);
		  temp_cntrl_ff_out_1_d1 (0) <= temp_cntrl_ff_out_1 (0);
	end if;
  end process delay_temp_cntrl_ff_0;
  
process (temp_cntrl_ff_out_d1 (0), temp_cntrl_ff_out_1_d1 (0))
begin
 if ((temp_cntrl_ff_out_d1 (0) or temp_cntrl_ff_out_1_d1 (0)) = '1') then 
    sig_out_from_ff (0) <= flip_flop_o (0);
 else
    sig_out_from_ff (0) <= '0';
 end if;
end process;

tap_signal_16: process (mul_start)
begin
  if (mul_start = '1') then
    tap_addr (0) <= rs1_i(0);
  elsif (ctrl_state = '1') then 
    tap_addr (0) <= add_i(0);
  end if;	
end process tap_signal_16;  

fault_inj_unit_inst_sync_16 : fault_injection_logic

port map ( 
    in_data => tap_addr (0),
    in_fault_type_sel => fault_inj_type_sync_16_23_i (0),
    in_fault_inject => fault_inj_trig_sync_16_23_i (0),
    out_data => add_bit0
 );
 
fdl_inst_sync_0 : fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_addr (0),
    in_destination => sig_out_from_ff (0),
    out_fault_status => fault_status_sync_16_23_o (0),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_16_sync_true;   
---------------------------fault inj and det at sync 16 end--------------------------------

---------fault inj and det at sync 17 start--------------------------------
fault_injection_17_sync_true : if (FAULT_INJ_SYNC_17 = true) generate

temp_cntrl_ff_out (1) <= '1' when (mul_start = '1') else '0';
temp_cntrl_ff_out_1 (1) <= '1' when (ctrl_state = '1');

delay_temp_cntrl_ff_1: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		  temp_cntrl_ff_out_d1 (1) <= '0';
		  temp_cntrl_ff_out_1_d1 (1) <= '0';
	  elsif rising_edge(clk_i) then
		  temp_cntrl_ff_out_d1 (1) <= temp_cntrl_ff_out (1);
		  temp_cntrl_ff_out_1_d1 (1) <= temp_cntrl_ff_out_1 (1);
	end if;
  end process delay_temp_cntrl_ff_1;
  
process (temp_cntrl_ff_out_d1 (1), temp_cntrl_ff_out_1_d1 (1))
begin
 if ((temp_cntrl_ff_out_d1 (1) or temp_cntrl_ff_out_1_d1 (1)) = '1') then 
    sig_out_from_ff (1) <= flip_flop_o (1);
 else
    sig_out_from_ff (1) <= '0';
 end if;
end process;

tap_signal_17: process (mul_start)
begin
  if (mul_start = '1') then
    tap_addr (1) <= rs1_i(1);
  elsif (ctrl_state = '1') then 
    tap_addr (1) <= add_i(1);
  end if;	
end process tap_signal_17;  
  
fault_inj_unit_inst_sync_17 : fault_injection_logic

port map ( 
    in_data => tap_addr (1),
    in_fault_type_sel => fault_inj_type_sync_16_23_i (1),
    in_fault_inject => fault_inj_trig_sync_16_23_i (1),
    out_data => add_bit1
 );
 
fdl_inst_sync_17 : fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_addr (1),
    in_destination => sig_out_from_ff (1),
    out_fault_status => fault_status_sync_16_23_o (1),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_17_sync_true;   
---------------------------fault inj and det at sync 17 end--------------------------------


---------------------------fault inj and det at sync 18 start--------------------------------
fault_injection_18_sync_true : if (FAULT_INJ_SYNC_18 = true) generate

temp_cntrl_ff_out (2) <= '1' when (mul_start = '1') else '0';
temp_cntrl_ff_out_1 (2) <= '1' when (ctrl_state = '1');

delay_temp_cntrl_ff_2: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		  temp_cntrl_ff_out_d1 (2) <= '0';
		  temp_cntrl_ff_out_1_d1 (2) <= '0';
	  elsif rising_edge(clk_i) then
		  temp_cntrl_ff_out_d1 (2) <= temp_cntrl_ff_out (2);
		  temp_cntrl_ff_out_1_d1 (2) <= temp_cntrl_ff_out_1 (2);
	end if;
  end process delay_temp_cntrl_ff_2;
  
process (temp_cntrl_ff_out_d1 (2), temp_cntrl_ff_out_1_d1 (2))
begin
 if ((temp_cntrl_ff_out_d1 (2) or temp_cntrl_ff_out_1_d1 (2)) = '1') then 
    sig_out_from_ff (2) <= flip_flop_o (2);
 else
    sig_out_from_ff (2) <= '0';
 end if;
end process;

tap_signal_18: process (mul_start)
begin
  if (mul_start = '1') then
    tap_addr (2) <= rs1_i(2);
  elsif (ctrl_state = '1') then 
    tap_addr (2) <= add_i(2);
  end if;	
end process tap_signal_18;  

fault_inj_unit_inst_sync_18 : fault_injection_logic

port map ( 
    in_data => tap_addr (2),
    in_fault_type_sel => fault_inj_type_sync_16_23_i (2),
    in_fault_inject => fault_inj_trig_sync_16_23_i (2),
    out_data => add_bit2
 );
 
fdl_inst_sync_18 : fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_addr (2),
    in_destination => sig_out_from_ff (2),
    out_fault_status => fault_status_sync_16_23_o (2),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_18_sync_true;   
---------------------------fault inj and det at sync 18 end--------------------------------

---------------------------fault inj and det at sync 19 start--------------------------------
fault_injection_19_sync_true : if (FAULT_INJ_SYNC_19 = true) generate
temp_cntrl_ff_out (3) <= '1' when (mul_start = '1') else '0';
temp_cntrl_ff_out_1 (3) <= '1' when (ctrl_state = '1');

delay_temp_cntrl_ff_3: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		  temp_cntrl_ff_out_d1 (3) <= '0';
		  temp_cntrl_ff_out_1_d1 (3) <= '0';
	  elsif rising_edge(clk_i) then
		  temp_cntrl_ff_out_d1 (3) <= temp_cntrl_ff_out (3);
		  temp_cntrl_ff_out_1_d1 (3) <= temp_cntrl_ff_out_1 (3);
	end if;
  end process delay_temp_cntrl_ff_3;
  
process (temp_cntrl_ff_out_d1 (3), temp_cntrl_ff_out_1_d1 (3))
begin
 if ((temp_cntrl_ff_out_d1 (3) or temp_cntrl_ff_out_1_d1 (3)) = '1') then 
    sig_out_from_ff (3) <= flip_flop_o (3);
 else
    sig_out_from_ff (3) <= '0';
 end if;
end process;

tap_signal_19: process (mul_start)
begin
  if (mul_start = '1') then
    tap_addr (3) <= rs1_i(3);
  elsif (ctrl_state = '1') then 
    tap_addr (3) <= add_i(3);
  end if;	
end process tap_signal_19;  
  

fault_inj_unit_inst_sync_19 : fault_injection_logic

port map ( 
    in_data => tap_addr (3),
    in_fault_type_sel => fault_inj_type_sync_16_23_i (3),
    in_fault_inject => fault_inj_trig_sync_16_23_i (3),
    out_data => add_bit3
 );
 
fdl_inst_sync_19 : fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_addr (3),
    in_destination => sig_out_from_ff (3),
    out_fault_status => fault_status_sync_16_23_o (3),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_19_sync_true;   
---------------------------fault inj and det at sync 19 end--------------------------------

---------------------------fault inj and det at sync 20 start--------------------------------
fault_injection_20_sync_true : if (FAULT_INJ_SYNC_20 = true) generate
temp_cntrl_ff_out (4) <= '1' when (mul_start = '1') else '0';
temp_cntrl_ff_out_1 (4) <= '1' when (ctrl_state = '1');

delay_temp_cntrl_ff_4: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		  temp_cntrl_ff_out_d1 (4) <= '0';
		  temp_cntrl_ff_out_1_d1 (4) <= '0';
	  elsif rising_edge(clk_i) then
		  temp_cntrl_ff_out_d1 (4) <= temp_cntrl_ff_out (4);
		  temp_cntrl_ff_out_1_d1 (4) <= temp_cntrl_ff_out_1 (4);
	end if;
  end process delay_temp_cntrl_ff_4;
  
process (temp_cntrl_ff_out_d1 (4), temp_cntrl_ff_out_1_d1 (4))
begin
 if ((temp_cntrl_ff_out_d1 (4) or temp_cntrl_ff_out_1_d1 (4)) = '1') then 
    sig_out_from_ff (4) <= flip_flop_o (4);
 else
    sig_out_from_ff (4) <= '0';
 end if;
end process;

tap_signal_20 : process (mul_start)
begin
  if (mul_start = '1') then
    tap_addr (4) <= rs1_i(4);
  elsif (ctrl_state = '1') then 
    tap_addr (4) <= add_i(4);
  end if;	
end process tap_signal_20;  

fault_inj_unit_inst_sync_20 : fault_injection_logic

port map ( 
    in_data => tap_addr (4),
    in_fault_type_sel => fault_inj_type_sync_16_23_i (4),
    in_fault_inject => fault_inj_trig_sync_16_23_i (4),
    out_data => add_bit4
 );
 
fdl_inst_sync_20 : fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_addr (4),
    in_destination => sig_out_from_ff (4),
    out_fault_status => fault_status_sync_16_23_o (4),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_20_sync_true;   
---------------------------fault inj and det at sync 20 end--------------------------------


---------------------------fault inj and det at sync 21 start--------------------------------
fault_injection_21_sync_true : if (FAULT_INJ_SYNC_21 = true) generate

temp_cntrl_ff_out (5) <= '1' when (mul_start = '1') else '0';
temp_cntrl_ff_out_1 (5) <= '1' when (ctrl_state = '1');

delay_temp_cntrl_ff_5: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		  temp_cntrl_ff_out_d1 (5) <= '0';
		  temp_cntrl_ff_out_1_d1 (5) <= '0';
	  elsif rising_edge(clk_i) then
		  temp_cntrl_ff_out_d1 (5) <= temp_cntrl_ff_out (5);
		  temp_cntrl_ff_out_1_d1 (5) <= temp_cntrl_ff_out_1 (5);
	end if;
  end process delay_temp_cntrl_ff_5;
  
process (temp_cntrl_ff_out_d1 (5), temp_cntrl_ff_out_1_d1 (5))
begin
 if ((temp_cntrl_ff_out_d1 (5) or temp_cntrl_ff_out_1_d1 (5)) = '1') then 
    sig_out_from_ff (5) <= flip_flop_o (5);
 else
    sig_out_from_ff (5) <= '0';
 end if;
end process;

tap_signal_21 : process (mul_start)
begin
  if (mul_start = '1') then
    tap_addr (5) <= rs1_i(5);
  elsif (ctrl_state = '1') then 
    tap_addr (5) <= add_i(5);
  end if;	
end process tap_signal_21;   

fault_inj_unit_inst_sync_21 : fault_injection_logic

port map ( 
    in_data => tap_addr (5),
    in_fault_type_sel => fault_inj_type_sync_16_23_i (5),
    in_fault_inject => fault_inj_trig_sync_16_23_i (5),
    out_data => add_bit5
 );
 
fdl_inst_sync_21 : fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_addr (5),
    in_destination => sig_out_from_ff (5),
    out_fault_status => fault_status_sync_16_23_o (5),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_21_sync_true;   
---------------------------fault inj and det at sync 21 end--------------------------------

---------------------------fault inj and det at sync 22 start--------------------------------
fault_injection_22_sync_true : if (FAULT_INJ_SYNC_22 = true) generate

temp_cntrl_ff_out (6) <= '1' when (mul_start = '1') else '0';
temp_cntrl_ff_out_1 (6) <= '1' when (ctrl_state = '1');

delay_temp_cntrl_ff_6: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		  temp_cntrl_ff_out_d1 (6) <= '0';
		  temp_cntrl_ff_out_1_d1 (6) <= '0';
	  elsif rising_edge(clk_i) then
		  temp_cntrl_ff_out_d1 (6) <= temp_cntrl_ff_out (6);
		  temp_cntrl_ff_out_1_d1 (6) <= temp_cntrl_ff_out_1 (6);
	end if;
  end process delay_temp_cntrl_ff_6;
  
process (temp_cntrl_ff_out_d1 (6), temp_cntrl_ff_out_1_d1 (6))
begin
 if ((temp_cntrl_ff_out_d1 (6) or temp_cntrl_ff_out_1_d1 (6)) = '1') then 
    sig_out_from_ff (6) <= flip_flop_o (6);
 else
    sig_out_from_ff (6) <= '0';
 end if;
end process;

tap_signal_22 : process (mul_start)
begin
  if (mul_start = '1') then
    tap_addr (6) <= rs1_i(6);
  elsif (ctrl_state = '1') then 
    tap_addr (6) <= add_i(6);
  end if;	
end process tap_signal_22;   

fault_inj_unit_inst_sync_22 : fault_injection_logic

port map ( 
    in_data => tap_addr (6),
    in_fault_type_sel => fault_inj_type_sync_16_23_i (6),
    in_fault_inject => fault_inj_trig_sync_16_23_i (6),
    out_data => add_bit6
 );
 
fdl_inst_sync_26 : fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_addr (6),
    in_destination => sig_out_from_ff (6),
    out_fault_status => fault_status_sync_16_23_o (6),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_22_sync_true;   
---------------------------fault inj and det at sync 22 end--------------------------------

---------------------------fault inj and det at sync 23 start--------------------------------
fault_injection_23_sync_true : if (FAULT_INJ_SYNC_23 = true) generate

temp_cntrl_ff_out (7) <= '1' when (mul_start = '1') else '0';
temp_cntrl_ff_out_1 (7) <= '1' when (ctrl_state = '1');

delay_temp_cntrl_ff_7: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		  temp_cntrl_ff_out_d1 (7) <= '0';
		  temp_cntrl_ff_out_1_d1 (7) <= '0';
	  elsif rising_edge(clk_i) then
		  temp_cntrl_ff_out_d1 (7) <= temp_cntrl_ff_out (7);
		  temp_cntrl_ff_out_1_d1 (7) <= temp_cntrl_ff_out_1 (7);
	end if;
  end process delay_temp_cntrl_ff_7;
  
process (temp_cntrl_ff_out_d1 (7), temp_cntrl_ff_out_1_d1 (7))
begin
 if ((temp_cntrl_ff_out_d1 (7) or temp_cntrl_ff_out_1_d1 (7)) = '1') then 
    sig_out_from_ff (7) <= flip_flop_o (7);
 else
    sig_out_from_ff (7) <= '0';
 end if;
end process;

tap_signal_23 : process (mul_start)
begin
  if (mul_start = '1') then
    tap_addr (7) <= rs1_i(7);
  elsif (ctrl_state = '1') then 
    tap_addr (7) <= add_i(7);
  end if;	
end process tap_signal_23;  

fault_inj_unit_inst_sync_23 : fault_injection_logic

port map ( 
    in_data => tap_addr (7),
    in_fault_type_sel => fault_inj_type_sync_16_23_i (7),
    in_fault_inject => fault_inj_trig_sync_16_23_i (7),
    out_data => add_bit7
 );
 
fdl_inst_sync_23 : fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_addr (7),
    in_destination => sig_out_from_ff (7),
    out_fault_status => fault_status_sync_16_23_o (7),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_23_sync_true;   
---------------------------fault inj and det at sync 23 end--------------------------------

end Behavioral;