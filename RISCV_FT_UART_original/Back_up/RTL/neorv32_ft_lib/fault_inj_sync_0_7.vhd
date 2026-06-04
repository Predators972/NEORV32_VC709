----------------------------------------------------------------------------------
-- Company: Ulster University
-- Engineer: Nidhin Thandassery Sumithran
-- 
-- Create Date: 14.08.2023 15:12:24
-- Design Name: 
-- Module Name: fault_inj_sync_0_7 - Behavioral
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

entity fault_inj_sync_0_7 is
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
    acc_en                      : in std_logic;
    fault_inj_trig_sync_0_7_i   : in std_logic_vector (7 downto 0);
    fault_inj_type_sync_0_7_i   : in sync_fault_type_t;
    fault_status_sync_0_7_o     : out std_logic_vector (7 downto 0);
    fiu_out_data_o              : out std_logic_vector (7 downto 0);
    flip_flop_o                 : in std_logic_vector (7 downto 0);
    flip_flop_i                 : in std_logic_vector (7 downto 0);
    clk_i                       : in std_logic;
    rstn_i                      : in std_logic
);
end fault_inj_sync_0_7;

architecture Behavioral of fault_inj_sync_0_7 is

signal data_o_bit0, data_o_bit1, data_o_bit2, data_o_bit3, data_o_bit4, data_o_bit5, data_o_bit6, data_o_bit7: std_logic;
signal sig_out_from_ff : std_logic_vector (7 downto 0);
signal tap_bus_o_buf : std_logic_vector (7 downto 0);
signal temp_cntrl_ff_out : std_logic_vector (7 downto 0);
signal temp_cntrl_ff_out_d1 : std_logic_vector (7 downto 0);

attribute keep : boolean;
attribute keep of tap_bus_o_buf : signal is true;
attribute keep of sig_out_from_ff : signal is true;

begin

fiu_out_data_o <= ( data_o_bit7 & data_o_bit6 & data_o_bit5 & data_o_bit4 & data_o_bit3 & data_o_bit2 & data_o_bit1 & data_o_bit0 );
 
-----------Fault injection begin--------------------------------------
----------------Fault injection selection false-----------------------
fault_injection_0_sync_false : if (FAULT_INJ_SYNC_0 = false) generate --LSB bit
no_fault_0: process (acc_en)
begin
    if (acc_en = '1') then
        data_o_bit0 <= flip_flop_i(0);
    end if;	
end process no_fault_0;  

end generate; 

fault_injection_1_sync_false : if (FAULT_INJ_SYNC_1 = false) generate
no_fault_1: process (acc_en)
begin
    if (acc_en = '1') then
        data_o_bit1 <= flip_flop_i(1);
    end if;		
end process no_fault_1;  

end generate; 

fault_injection_2_sync_false : if (FAULT_INJ_SYNC_2 = false) generate
no_fault_2: process (acc_en)
begin
    if (acc_en = '1') then
        data_o_bit2 <= flip_flop_i(2);
    end if;
end process no_fault_2;  

end generate; 


fault_injection_3_sync_false : if (FAULT_INJ_SYNC_3 = false) generate
no_fault_3: process (acc_en)
begin
   if (acc_en = '1') then
        data_o_bit3 <= flip_flop_i(3);
    end if;
end process no_fault_3;  

end generate; 


fault_injection_4_sync_false : if (FAULT_INJ_SYNC_4 = false) generate
no_fault_4: process (acc_en)
begin
   if (acc_en = '1') then
        data_o_bit4 <= flip_flop_i(4);
    end if;
end process no_fault_4;  

end generate; 

fault_injection_5_sync_false : if (FAULT_INJ_SYNC_5 = false) generate
no_fault_5: process (acc_en)
begin
    if (acc_en = '1') then
        data_o_bit5 <= flip_flop_i(5);
    end if;	
end process no_fault_5;  

end generate; 

fault_injection_6_sync_false : if (FAULT_INJ_SYNC_5 = false) generate
no_fault_6: process (acc_en)
begin
    if (acc_en = '1') then
        data_o_bit6 <= flip_flop_i(6);
    end if;
end process no_fault_6;  

end generate; 

fault_injection_7_sync_false : if (FAULT_INJ_SYNC_5 = false) generate
no_fault_7: process (acc_en)
begin
    if (acc_en = '1') then
        data_o_bit7 <= flip_flop_i(7);
    end if;	
end process no_fault_7;  

end generate; 

----------------Fault injection selection false end -----------------------

----------------Fault injection selection True start -----------------------
  
--sig_out_from_ff <= flip_flop_o;

fault_injection_0_sync_true : if (FAULT_INJ_SYNC_0 = true) generate  --bit 0

temp_cntrl_ff_out (0) <= '1' when (acc_en = '1') else '0';


delay_temp_cntrl_ff_0: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		  temp_cntrl_ff_out_d1 (0) <= '0';
	  elsif rising_edge(clk_i) then
		  temp_cntrl_ff_out_d1 (0) <= temp_cntrl_ff_out (0);
	end if;
  end process delay_temp_cntrl_ff_0;
  
process (temp_cntrl_ff_out_d1 (0))
begin
 if (temp_cntrl_ff_out_d1 (0)  = '1') then 
    sig_out_from_ff (0) <= flip_flop_o (0);
 else
    sig_out_from_ff (0) <= '0';
 end if;
end process;

tap_signal_0: process (acc_en)
begin
    if (acc_en = '1') then
        tap_bus_o_buf(0) <= flip_flop_i (0);
    else
        tap_bus_o_buf(0) <= '0';
    end if;	
end process tap_signal_0;

fault_inj_unit_inst_sync_0 : fault_injection_logic

port map ( 
    in_data => tap_bus_o_buf (0),
    in_fault_type_sel => fault_inj_type_sync_0_7_i (0),
    in_fault_inject => fault_inj_trig_sync_0_7_i (0),
    out_data => data_o_bit0
 );
 
fdl_inst_sync_0 : fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_bus_o_buf (0),
    in_destination => sig_out_from_ff (0),
    out_fault_status => fault_status_sync_0_7_o (0),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_0_sync_true; 

fault_injection_1_sync_true : if (FAULT_INJ_SYNC_1 = true) generate  --bit 1

temp_cntrl_ff_out (1) <= '1' when (acc_en = '1') else '0';


delay_temp_cntrl_ff_1: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		  temp_cntrl_ff_out_d1 (1) <= '0';
	  elsif rising_edge(clk_i) then
		  temp_cntrl_ff_out_d1 (1) <= temp_cntrl_ff_out (1);
	end if;
  end process delay_temp_cntrl_ff_1;
  
process (temp_cntrl_ff_out_d1 (1))
begin
 if (temp_cntrl_ff_out_d1 (1)  = '1') then 
    sig_out_from_ff (1) <= flip_flop_o (1);
 else
    sig_out_from_ff (1) <= '0';
 end if;
end process;

tap_signal_1: process (acc_en)
begin
    if (acc_en = '1') then
        tap_bus_o_buf(1) <= flip_flop_i(1);
    else
        tap_bus_o_buf(1) <= '0';
    end if;	
end process tap_signal_1;

fault_inj_unit_inst_sync_1 : fault_injection_logic

port map ( 
    in_data => tap_bus_o_buf (1),
    in_fault_type_sel => fault_inj_type_sync_0_7_i (1),
    in_fault_inject => fault_inj_trig_sync_0_7_i (1),
    out_data => data_o_bit1
 );
 
fdl_inst_sync_1 : fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_bus_o_buf (1),
    in_destination => sig_out_from_ff (1),
    out_fault_status => fault_status_sync_0_7_o (1),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_1_sync_true; 


fault_injection_2_sync_true : if (FAULT_INJ_SYNC_2 = true) generate  --bit 2

temp_cntrl_ff_out (2) <= '1' when (acc_en = '1') else '0';


delay_temp_cntrl_ff_2: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		  temp_cntrl_ff_out_d1 (2) <= '0';
	  elsif rising_edge(clk_i) then
		  temp_cntrl_ff_out_d1 (2) <= temp_cntrl_ff_out (2);
	end if;
  end process delay_temp_cntrl_ff_2;
  
process (temp_cntrl_ff_out_d1 (2))
begin
 if (temp_cntrl_ff_out_d1 (2)  = '1') then 
    sig_out_from_ff (2) <= flip_flop_o (2);
 else
    sig_out_from_ff (2) <= '0';
 end if;
end process;

tap_signal_2: process (acc_en)
begin
    if (acc_en = '1') then
        tap_bus_o_buf(2) <= flip_flop_i(2);
    else
        tap_bus_o_buf(2) <= '0';
    end if;	
end process tap_signal_2;

fault_inj_unit_inst_sync_2 : fault_injection_logic

port map ( 
    in_data => tap_bus_o_buf (2),
    in_fault_type_sel => fault_inj_type_sync_0_7_i (2),
    in_fault_inject => fault_inj_trig_sync_0_7_i (2),
    out_data => data_o_bit2
 );
 
fdl_inst_sync_2 : fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_bus_o_buf (2),
    in_destination => sig_out_from_ff (2),
    out_fault_status => fault_status_sync_0_7_o (2),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_2_sync_true; 


fault_injection_3_sync_true : if (FAULT_INJ_SYNC_3 = true) generate  --bit 3

temp_cntrl_ff_out (3) <= '1' when (acc_en = '1') else '0';


delay_temp_cntrl_ff_3: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		  temp_cntrl_ff_out_d1 (3) <= '0';
	  elsif rising_edge(clk_i) then
		  temp_cntrl_ff_out_d1 (3) <= temp_cntrl_ff_out (3);
	end if;
  end process delay_temp_cntrl_ff_3;
  
process (temp_cntrl_ff_out_d1 (3))
begin
 if (temp_cntrl_ff_out_d1 (3)  = '1') then 
    sig_out_from_ff (3) <= flip_flop_o (3);
 else
    sig_out_from_ff (3) <= '0';
 end if;
end process;


tap_signal_3: process (acc_en)
begin
    if (acc_en = '1') then
        tap_bus_o_buf(3) <= flip_flop_i(3);
    else
        tap_bus_o_buf(3) <= '0';
    end if;	
end process tap_signal_3;

fault_inj_unit_inst_sync_3 : fault_injection_logic

port map ( 
    in_data => tap_bus_o_buf (3),
    in_fault_type_sel => fault_inj_type_sync_0_7_i (3),
    in_fault_inject => fault_inj_trig_sync_0_7_i (3),
    out_data => data_o_bit3
 );
 
fdl_inst_sync_3 : fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_bus_o_buf (3),
    in_destination => sig_out_from_ff (3),
    out_fault_status => fault_status_sync_0_7_o (3),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_3_sync_true; 


fault_injection_4_sync_true : if (FAULT_INJ_SYNC_4 = true) generate  --bit 4

temp_cntrl_ff_out (4) <= '1' when (acc_en = '1') else '0';


delay_temp_cntrl_ff_4: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		  temp_cntrl_ff_out_d1 (4) <= '0';
	  elsif rising_edge(clk_i) then
		  temp_cntrl_ff_out_d1 (4) <= temp_cntrl_ff_out (4);
	end if;
  end process delay_temp_cntrl_ff_4;
  
process (temp_cntrl_ff_out_d1 (4))
begin
 if (temp_cntrl_ff_out_d1 (4)  = '1') then 
    sig_out_from_ff (4) <= flip_flop_o (4);
 else
    sig_out_from_ff (4) <= '0';
 end if;
end process;


tap_signal_4: process (acc_en)
begin
    if (acc_en = '1') then
        tap_bus_o_buf(4) <= flip_flop_i(4);
    else
        tap_bus_o_buf(4) <= '0';
    end if;	
end process tap_signal_4;

fault_inj_unit_inst_sync_4 : fault_injection_logic

port map ( 
    in_data => tap_bus_o_buf (4),
    in_fault_type_sel => fault_inj_type_sync_0_7_i (4),
    in_fault_inject => fault_inj_trig_sync_0_7_i (4),
    out_data => data_o_bit4
 );
 
fdl_inst_sync_4 : fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_bus_o_buf (4),
    in_destination => sig_out_from_ff (4),
    out_fault_status => fault_status_sync_0_7_o (4),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_4_sync_true;

fault_injection_5_sync_true : if (FAULT_INJ_SYNC_5 = true) generate  --bit 5

temp_cntrl_ff_out (5) <= '1' when (acc_en = '1') else '0';


delay_temp_cntrl_ff_5: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		  temp_cntrl_ff_out_d1 (5) <= '0';
	  elsif rising_edge(clk_i) then
		  temp_cntrl_ff_out_d1 (5) <= temp_cntrl_ff_out (5);
	end if;
  end process delay_temp_cntrl_ff_5;
  
process (temp_cntrl_ff_out_d1 (5))
begin
 if (temp_cntrl_ff_out_d1 (5)  = '1') then 
    sig_out_from_ff (5) <= flip_flop_o (5);
 else
    sig_out_from_ff (5) <= '0';
 end if;
end process;

tap_signal_5: process (acc_en)
begin
    if (acc_en = '1') then
        tap_bus_o_buf(5) <= flip_flop_i(5);
    else
        tap_bus_o_buf(5) <= '0';
    end if;	
end process tap_signal_5;

fault_inj_unit_inst_sync_5 : fault_injection_logic

port map ( 
    in_data => tap_bus_o_buf (5),
    in_fault_type_sel => fault_inj_type_sync_0_7_i (5),
    in_fault_inject => fault_inj_trig_sync_0_7_i (5),
    out_data => data_o_bit5
 );
 
fdl_inst_sync_5 : fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_bus_o_buf (5),
    in_destination => sig_out_from_ff (5),
    out_fault_status => fault_status_sync_0_7_o (5),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_5_sync_true;


fault_injection_6_sync_true : if (FAULT_INJ_SYNC_6 = true) generate  --bit 6

temp_cntrl_ff_out (6) <= '1' when (acc_en = '1') else '0';


delay_temp_cntrl_ff_6: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		  temp_cntrl_ff_out_d1 (6) <= '0';
	  elsif rising_edge(clk_i) then
		  temp_cntrl_ff_out_d1 (6) <= temp_cntrl_ff_out (6);
	end if;
  end process delay_temp_cntrl_ff_6;
  
process (temp_cntrl_ff_out_d1 (6))
begin
 if (temp_cntrl_ff_out_d1 (6)  = '1') then 
    sig_out_from_ff (6) <= flip_flop_o (6);
 else
    sig_out_from_ff (6) <= '0';
 end if;
end process;

tap_signal_6: process (acc_en)
begin
    if (acc_en = '1') then
        tap_bus_o_buf(6) <= flip_flop_i(6);
    else
        tap_bus_o_buf(6) <= '0';
    end if;	
end process tap_signal_6;

fault_inj_unit_inst_sync_6 : fault_injection_logic

port map ( 
    in_data => tap_bus_o_buf (6),
    in_fault_type_sel => fault_inj_type_sync_0_7_i (6),
    in_fault_inject => fault_inj_trig_sync_0_7_i (6),
    out_data => data_o_bit6
 );
 
fdl_inst_sync_6 : fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_bus_o_buf (6),
    in_destination => sig_out_from_ff (6),
    out_fault_status => fault_status_sync_0_7_o (6),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_6_sync_true;

fault_injection_7_sync_true : if (FAULT_INJ_SYNC_7 = true) generate  --bit 7

temp_cntrl_ff_out (7) <= '1' when (acc_en = '1') else '0';


delay_temp_cntrl_ff_7: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
		  temp_cntrl_ff_out_d1 (7) <= '0';
	  elsif rising_edge(clk_i) then
		  temp_cntrl_ff_out_d1 (7) <= temp_cntrl_ff_out (7);
	end if;
  end process delay_temp_cntrl_ff_7;
  
process (temp_cntrl_ff_out_d1 (7))
begin
 if (temp_cntrl_ff_out_d1 (7)  = '1') then 
    sig_out_from_ff (7) <= flip_flop_o (7);
 else
    sig_out_from_ff (7) <= '0';
 end if;
end process;

tap_signal_7: process (acc_en)
begin
    if (acc_en = '1') then
        tap_bus_o_buf(7) <= flip_flop_i(7);
    else
        tap_bus_o_buf(7) <= '0';
    end if;	
end process tap_signal_7;

fault_inj_unit_inst_sync_7 : fault_injection_logic

port map ( 
    in_data => tap_bus_o_buf (7),
    in_fault_type_sel => fault_inj_type_sync_0_7_i (7),
    in_fault_inject => fault_inj_trig_sync_0_7_i (7),
    out_data => data_o_bit7
 );
 
fdl_inst_sync_7: fault_detection_logic_ff_top
generic map(
    BUFFER_STAGES => 0,--BUFFER_STAGES,
    ENABLE_SYNTHESIS => true, --ENABLE_SYNTHESIS,
    DELAY => 0ns --DELAY
  )
port map( 
    in_source => tap_bus_o_buf (7),
    in_destination => sig_out_from_ff (7),
    out_fault_status => fault_status_sync_0_7_o (7),
    clk => clk_i,
    reset => not rstn_i
 );
 
end generate fault_injection_7_sync_true;

----------------Fault injection selection True start -----------------------


end Behavioral;