----------------------------------------------------------------------------------
-- Company: Ulster University
-- Engineer: Nidhin Thandassery Sumithran
-- 
-- Create Date: 14.08.2023 15:12:24
-- Design Name: 
-- Module Name: fault_inj_comb_0_7 - Behavioral
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

entity fault_inj_comb_0_7 is
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
end fault_inj_comb_0_7;

architecture Behavioral of fault_inj_comb_0_7 is

signal bus_addr_bit0, bus_addr_bit1, bus_addr_bit2, bus_addr_bit3, bus_addr_bit4, bus_addr_bit5, bus_addr_bit6, bus_addr_bit7: std_logic;
signal tap_bus_addr_buf : std_logic_vector (7 downto 0);
signal sig_out_from_comb : std_logic_vector (7 downto 0);
attribute keep : boolean;
attribute keep of bus_addr_bit0, bus_addr_bit1, bus_addr_bit2, bus_addr_bit3, bus_addr_bit4, bus_addr_bit5, bus_addr_bit6, bus_addr_bit7 : signal is true;
attribute keep of tap_bus_addr_buf : signal is true;

begin

fiu_out_bus_addr <= ( bus_addr_bit7 & bus_addr_bit6 & bus_addr_bit5 & bus_addr_bit4 & bus_addr_bit3 & bus_addr_bit2 & bus_addr_bit1 & bus_addr_bit0 );
 
-----------Fault injection begin--------------------------------------
----------------Fault injection selection false-----------------------
fault_injection_0_comb_false : if (FAULT_INJ_COMB_0 = false) generate --LSB bit
no_fault_0: process (bus_sel)
begin
    if (bus_sel = '0') then
        bus_addr_bit0 <= ca_bus_addr_i(0);
    else 
	   bus_addr_bit0 <= cb_bus_addr_i(0);
    end if;	
end process no_fault_0;  

end generate; 

fault_injection_1_comb_false : if (FAULT_INJ_COMB_1 = false) generate
no_fault_1: process (bus_sel)
begin
    if (bus_sel = '0') then
        bus_addr_bit1 <= ca_bus_addr_i(1);
    else 
	   bus_addr_bit1 <= cb_bus_addr_i(1);
    end if;	
end process no_fault_1;  

end generate; 

fault_injection_2_comb_false : if (FAULT_INJ_COMB_2 = false) generate
no_fault_2: process (bus_sel)
begin
    if (bus_sel = '0') then
        bus_addr_bit2 <= ca_bus_addr_i(2);
    else 
	   bus_addr_bit2 <= cb_bus_addr_i(2);
    end if;	
end process no_fault_2;  

end generate; 


fault_injection_3_comb_false : if (FAULT_INJ_COMB_3 = false) generate
no_fault_3: process (bus_sel)
begin
    if (bus_sel = '0') then
        bus_addr_bit3 <= ca_bus_addr_i(3);
    else 
	   bus_addr_bit3 <= cb_bus_addr_i(3);
    end if;	
end process no_fault_3;  

end generate; 


fault_injection_4_comb_false : if (FAULT_INJ_COMB_4 = false) generate
no_fault_4: process (bus_sel)
begin
    if (bus_sel = '0') then
        bus_addr_bit4 <= ca_bus_addr_i(4);
    else 
	   bus_addr_bit4 <= cb_bus_addr_i(4);
    end if;	
end process no_fault_4;  

end generate; 

fault_injection_5_comb_false : if (FAULT_INJ_COMB_5 = false) generate
no_fault_5: process (bus_sel)
begin
    if (bus_sel = '0') then
        bus_addr_bit5 <= ca_bus_addr_i(5);
    else 
	   bus_addr_bit5 <= cb_bus_addr_i(5);
    end if;	
end process no_fault_5;  

end generate; 

fault_injection_6_comb_false : if (FAULT_INJ_COMB_5 = false) generate
no_fault_6: process (bus_sel)
begin
    if (bus_sel = '0') then
        bus_addr_bit6 <= ca_bus_addr_i(6);
    else 
	   bus_addr_bit6 <= cb_bus_addr_i(6);
    end if;	
end process no_fault_6;  

end generate; 

fault_injection_7_comb_false : if (FAULT_INJ_COMB_5 = false) generate
no_fault_7: process (bus_sel)
begin
    if (bus_sel = '0') then
        bus_addr_bit7 <= ca_bus_addr_i(7);
    else 
	   bus_addr_bit7 <= cb_bus_addr_i(7);
    end if;	
end process no_fault_7;  

end generate; 

----------------Fault injection selection false end -----------------------

----------------Fault injection selection True start -----------------------
  
sig_out_from_comb <= reg_p_bus_addr_o;

fault_injection_0_comb_true : if (FAULT_INJ_COMB_0 = true) generate  --bit 0

tap_signal_0: process (bus_sel)
begin
    if (bus_sel = '0') then
        tap_bus_addr_buf(0) <= ca_bus_addr_i(0);
    else 
        tap_bus_addr_buf(0) <= cb_bus_addr_i(0);
    end if;	
end process tap_signal_0;

fault_inj_unit_inst_comb_0 : fault_injection_logic

port map ( 
    in_data => tap_bus_addr_buf (0),
    in_fault_type_sel => fault_inj_type_comb_0_7_i (0),
    in_fault_inject => fault_inj_trig_comb_0_7_i (0),
    out_data => bus_addr_bit0
 );

fdl_channel_inst_0 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_addr_buf (0),
    in_destination => sig_out_from_comb (0),
    out_fault_status => fault_status_comb_0_7_o(0)
 );  
 
end generate fault_injection_0_comb_true; 

fault_injection_1_comb_true : if (FAULT_INJ_COMB_1 = true) generate  --bit 1

tap_signal_1: process (bus_sel)
begin
    if (bus_sel = '0') then
        tap_bus_addr_buf(1) <= ca_bus_addr_i(1);
    else 
        tap_bus_addr_buf(1) <= cb_bus_addr_i(1);
    end if;	
end process tap_signal_1;

fault_inj_unit_inst_comb_1 : fault_injection_logic

port map ( 
    in_data => tap_bus_addr_buf (1),
    in_fault_type_sel => fault_inj_type_comb_0_7_i (1),
    in_fault_inject => fault_inj_trig_comb_0_7_i (1),
    out_data => bus_addr_bit1
 );

fdl_channel_inst_1 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_addr_buf (1),
    in_destination => sig_out_from_comb (1),
    out_fault_status => fault_status_comb_0_7_o(1)
 );  
 

end generate fault_injection_1_comb_true; 


fault_injection_2_comb_true : if (FAULT_INJ_COMB_2 = true) generate  --bit 2

tap_signal_2: process (bus_sel)
begin
    if (bus_sel = '0') then
        tap_bus_addr_buf(2) <= ca_bus_addr_i(2);
    else 
        tap_bus_addr_buf(2) <= cb_bus_addr_i(2);
    end if;	
end process tap_signal_2;

fault_inj_unit_inst_comb_2 : fault_injection_logic

port map ( 
    in_data => tap_bus_addr_buf (2),
    in_fault_type_sel => fault_inj_type_comb_0_7_i (2),
    in_fault_inject => fault_inj_trig_comb_0_7_i (2),
    out_data => bus_addr_bit2
 );

fdl_channel_inst_2 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_addr_buf (2),
    in_destination => sig_out_from_comb (2),
    out_fault_status => fault_status_comb_0_7_o(2)
 );  
 

end generate fault_injection_2_comb_true; 


fault_injection_3_comb_true : if (FAULT_INJ_COMB_3 = true) generate  --bit 3

tap_signal_3: process (bus_sel)
begin
    if (bus_sel = '0') then
        tap_bus_addr_buf(3) <= ca_bus_addr_i(3);
    else 
        tap_bus_addr_buf(3) <= cb_bus_addr_i(3);
    end if;	
end process tap_signal_3;

fault_inj_unit_inst_comb_3 : fault_injection_logic

port map ( 
    in_data => tap_bus_addr_buf (3),
    in_fault_type_sel => fault_inj_type_comb_0_7_i (3),
    in_fault_inject => fault_inj_trig_comb_0_7_i (3),
    out_data => bus_addr_bit3
 );

fdl_channel_inst_3 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_addr_buf (3),
    in_destination => sig_out_from_comb (3),
    out_fault_status => fault_status_comb_0_7_o(3)
 );  
 
end generate fault_injection_3_comb_true; 


fault_injection_4_comb_true : if (FAULT_INJ_COMB_4 = true) generate  --bit 4

tap_signal_4: process (bus_sel)
begin
    if (bus_sel = '0') then
        tap_bus_addr_buf(4) <= ca_bus_addr_i(4);
    else 
        tap_bus_addr_buf(4) <= cb_bus_addr_i(4);
    end if;	
end process tap_signal_4;

fault_inj_unit_inst_comb_4 : fault_injection_logic

port map ( 
    in_data => tap_bus_addr_buf (4),
    in_fault_type_sel => fault_inj_type_comb_0_7_i (4),
    in_fault_inject => fault_inj_trig_comb_0_7_i (4),
    out_data => bus_addr_bit4
 );

fdl_channel_inst_4 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_addr_buf (4),
    in_destination => sig_out_from_comb (4),
    out_fault_status => fault_status_comb_0_7_o(4)
 );  

end generate fault_injection_4_comb_true; 

fault_injection_5_comb_true : if (FAULT_INJ_COMB_5 = true) generate  --bit 5

tap_signal_5: process (bus_sel)
begin
    if (bus_sel = '0') then
        tap_bus_addr_buf(5) <= ca_bus_addr_i(5);
    else 
        tap_bus_addr_buf(5) <= cb_bus_addr_i(5);
    end if;	
end process tap_signal_5;

fault_inj_unit_inst_comb_5 : fault_injection_logic

port map ( 
    in_data => tap_bus_addr_buf (5),
    in_fault_type_sel => fault_inj_type_comb_0_7_i (5),
    in_fault_inject => fault_inj_trig_comb_0_7_i (5),
    out_data => bus_addr_bit5
 );

fdl_channel_inst_5 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_addr_buf (5),
    in_destination => sig_out_from_comb (5),
    out_fault_status => fault_status_comb_0_7_o(5)
 );  
 
end generate fault_injection_5_comb_true; 

fault_injection_6_comb_true : if (FAULT_INJ_COMB_6 = true) generate  --bit 6

tap_signal_6: process (bus_sel)
begin
    if (bus_sel = '0') then
        tap_bus_addr_buf(6) <= ca_bus_addr_i(6);
    else 
        tap_bus_addr_buf(6) <= cb_bus_addr_i(6);
    end if;	
end process tap_signal_6;

fault_inj_unit_inst_comb_6 : fault_injection_logic

port map ( 
    in_data => tap_bus_addr_buf (6),
    in_fault_type_sel => fault_inj_type_comb_0_7_i (6),
    in_fault_inject => fault_inj_trig_comb_0_7_i (6),
    out_data => bus_addr_bit6
 );

fdl_channel_inst_6 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_addr_buf (6),
    in_destination => sig_out_from_comb (6),
    out_fault_status => fault_status_comb_0_7_o(6)
 );  
 
end generate fault_injection_6_comb_true; 



fault_injection_7_comb_true : if (FAULT_INJ_COMB_7 = true) generate  --bit 7

tap_signal_7: process (bus_sel)
begin
    if (bus_sel = '0') then
        tap_bus_addr_buf(7) <= ca_bus_addr_i(7);
    else 
        tap_bus_addr_buf(7) <= cb_bus_addr_i(7);
    end if;	
end process tap_signal_7;

fault_inj_unit_inst_comb_7 : fault_injection_logic

port map ( 
    in_data => tap_bus_addr_buf (7),
    in_fault_type_sel => fault_inj_type_comb_0_7_i (7),
    in_fault_inject => fault_inj_trig_comb_0_7_i (7),
    out_data => bus_addr_bit7
 );

fdl_channel_inst_7 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_addr_buf (7),
    in_destination => sig_out_from_comb (7),
    out_fault_status => fault_status_comb_0_7_o(7)
 );  
 
end generate fault_injection_7_comb_true;

----------------Fault injection selection True start -----------------------


end Behavioral;
