----------------------------------------------------------------------------------
-- Company: Ulster University
-- Engineer: Nidhin Thandassery Sumithran
-- 
-- Create Date: 14.08.2023 15:12:24
-- Design Name: 
-- Module Name: fault_inj_comb_8_15 - Behavioral
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

entity fault_inj_comb_8_15 is
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
end fault_inj_comb_8_15;

architecture Behavioral of fault_inj_comb_8_15 is

signal bus_rdata_bit0, bus_rdata_bit1, bus_rdata_bit2, bus_rdata_bit3, bus_rdata_bit4, bus_rdata_bit5, bus_rdata_bit6, bus_rdata_bit7: std_logic;
signal tap_bus_rdata_buf : std_logic_vector (7 downto 0);
signal sig_out_from_comb : std_logic_vector (7 downto 0);
signal reg_bus_rdata : std_logic_vector (7 downto 0);
attribute keep: boolean;
attribute keep of tap_bus_rdata_buf : signal is true;
attribute keep of sig_out_from_comb : signal is true;
attribute keep of reg_bus_rdata     : signal is true;
attribute keep of bus_rdata_bit0, bus_rdata_bit1, bus_rdata_bit2, bus_rdata_bit3, bus_rdata_bit4, bus_rdata_bit5, bus_rdata_bit6, bus_rdata_bit7: signal is true;

begin

fiu_out_bus_rdata <= ( bus_rdata_bit7 & bus_rdata_bit6 & bus_rdata_bit5 & bus_rdata_bit4 & bus_rdata_bit3 & bus_rdata_bit2 & bus_rdata_bit1 & bus_rdata_bit0 );

------------Fault injection at i_bus_rdata_i----------------------
reg_bus_rdata <= bus_rdata_i;
  
---------------Fault injection at i_bus_rdata_i------------------------

fault_injection_8_comb_false : if (FAULT_INJ_COMB_8 = false) generate --LSB bit

    bus_rdata_bit0 <= reg_bus_rdata (0);

end generate; 

fault_injection_9_comb_false : if (FAULT_INJ_COMB_9 = false) generate 

    bus_rdata_bit1 <= reg_bus_rdata (1);

end generate; 

fault_injection_10_comb_false : if (FAULT_INJ_COMB_10 = false) generate 

    bus_rdata_bit2 <= reg_bus_rdata (2);

end generate; 
fault_injection_11_comb_false : if (FAULT_INJ_COMB_11 = false) generate 

    bus_rdata_bit3 <= reg_bus_rdata (3);

end generate; 
fault_injection_12_comb_false : if (FAULT_INJ_COMB_12 = false) generate 

    bus_rdata_bit4 <= reg_bus_rdata (4);

end generate; 
fault_injection_13_comb_false : if (FAULT_INJ_COMB_13 = false) generate 

    bus_rdata_bit5 <= reg_bus_rdata (5);

end generate; 
fault_injection_14_comb_false : if (FAULT_INJ_COMB_14 = false) generate 

    bus_rdata_bit6 <= reg_bus_rdata (6);

end generate; 
fault_injection_15_comb_false : if (FAULT_INJ_COMB_15 = false) generate 

    bus_rdata_bit7 <= reg_bus_rdata (7);

end generate; 

sig_out_from_comb <= bus_rdata_i_after_comb;
    
----------------Fault injection selection True start -----------------------
fault_injection_8_comb_true : if (FAULT_INJ_COMB_8 = true) generate

tap_bus_rdata_buf (0) <= reg_bus_rdata(0); 
 
fault_inj_unit_inst_comb_8 : fault_injection_logic

port map ( 
    in_data => tap_bus_rdata_buf (0),
    in_fault_type_sel => fault_inj_type_comb_8_15_i (0),
    in_fault_inject => fault_inj_trig_comb_8_15_i (0),
    out_data => bus_rdata_bit0
 );

fdl_channel_inst_8_15 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_rdata_buf (0),
    in_destination => sig_out_from_comb (0),
    out_fault_status => fault_status_comb_8_15_o (0)
 );  
 
end generate fault_injection_8_comb_true; 

fault_injection_9_comb_true : if (FAULT_INJ_COMB_9 = true) generate

tap_bus_rdata_buf (1) <= reg_bus_rdata(1); 
 
fault_inj_unit_inst_comb_9 : fault_injection_logic

port map ( 
    in_data => tap_bus_rdata_buf (1),
    in_fault_type_sel => fault_inj_type_comb_8_15_i (1),
    in_fault_inject => fault_inj_trig_comb_8_15_i (1),
    out_data => bus_rdata_bit1
 );

fdl_channel_inst_9 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_rdata_buf (1),
    in_destination => sig_out_from_comb (1),
    out_fault_status => fault_status_comb_8_15_o (1)
 );  
 
end generate fault_injection_9_comb_true; 


fault_injection_10_comb_true : if (FAULT_INJ_COMB_10 = true) generate

tap_bus_rdata_buf (2) <= reg_bus_rdata(2); 
 
fault_inj_unit_inst_comb_10 : fault_injection_logic

port map ( 
    in_data => tap_bus_rdata_buf (2),
    in_fault_type_sel => fault_inj_type_comb_8_15_i (2),
    in_fault_inject => fault_inj_trig_comb_8_15_i (2),
    out_data => bus_rdata_bit2
 );

fdl_channel_inst_10 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_rdata_buf (2),
    in_destination => sig_out_from_comb (2),
    out_fault_status => fault_status_comb_8_15_o (2)
 );  
 
end generate fault_injection_10_comb_true; 


fault_injection_11_comb_true : if (FAULT_INJ_COMB_11 = true) generate

tap_bus_rdata_buf (3) <= reg_bus_rdata(3); 
 
fault_inj_unit_inst_comb_11 : fault_injection_logic

port map ( 
    in_data => tap_bus_rdata_buf (3),
    in_fault_type_sel => fault_inj_type_comb_8_15_i (3),
    in_fault_inject => fault_inj_trig_comb_8_15_i (3),
    out_data => bus_rdata_bit3
 );

fdl_channel_inst_11 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_rdata_buf (3),
    in_destination => sig_out_from_comb (3),
    out_fault_status => fault_status_comb_8_15_o (3)
 );  
 
end generate fault_injection_11_comb_true; 


fault_injection_12_comb_true : if (FAULT_INJ_COMB_12 = true) generate

tap_bus_rdata_buf (4) <= reg_bus_rdata(4); 
 
fault_inj_unit_inst_comb_12 : fault_injection_logic

port map ( 
    in_data => tap_bus_rdata_buf (4),
    in_fault_type_sel => fault_inj_type_comb_8_15_i (4),
    in_fault_inject => fault_inj_trig_comb_8_15_i (4),
    out_data => bus_rdata_bit4
 );

fdl_channel_inst_12 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_rdata_buf (4),
    in_destination => sig_out_from_comb (4),
    out_fault_status => fault_status_comb_8_15_o (4)
 );  
 
end generate fault_injection_12_comb_true;



fault_injection_13_comb_true : if (FAULT_INJ_COMB_13 = true) generate

tap_bus_rdata_buf (5) <= reg_bus_rdata(5); 
 
fault_inj_unit_inst_comb_13 : fault_injection_logic

port map ( 
    in_data => tap_bus_rdata_buf (5),
    in_fault_type_sel => fault_inj_type_comb_8_15_i (5),
    in_fault_inject => fault_inj_trig_comb_8_15_i (5),
    out_data => bus_rdata_bit5
 );

fdl_channel_inst_13 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_rdata_buf (5),
    in_destination => sig_out_from_comb (5),
    out_fault_status => fault_status_comb_8_15_o (5)
 );  
 
end generate fault_injection_13_comb_true;


fault_injection_14_comb_true : if (FAULT_INJ_COMB_14 = true) generate

tap_bus_rdata_buf (6) <= reg_bus_rdata(6); 
 
fault_inj_unit_inst_comb_14 : fault_injection_logic

port map ( 
    in_data => tap_bus_rdata_buf (6),
    in_fault_type_sel => fault_inj_type_comb_8_15_i (6),
    in_fault_inject => fault_inj_trig_comb_8_15_i (6),
    out_data => bus_rdata_bit6
 );

fdl_channel_inst_14 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_rdata_buf (6),
    in_destination => sig_out_from_comb (6),
    out_fault_status => fault_status_comb_8_15_o (6)
 );  
 
end generate fault_injection_14_comb_true;

fault_injection_15_comb_true : if (FAULT_INJ_COMB_15 = true) generate

tap_bus_rdata_buf (7) <= reg_bus_rdata(7); 
 
fault_inj_unit_inst_comb_15 : fault_injection_logic

port map ( 
    in_data => tap_bus_rdata_buf (7),
    in_fault_type_sel => fault_inj_type_comb_8_15_i (7),
    in_fault_inject => fault_inj_trig_comb_8_15_i (7),
    out_data => bus_rdata_bit7
 );

fdl_channel_inst_15 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_rdata_buf (7),
    in_destination => sig_out_from_comb (7),
    out_fault_status => fault_status_comb_8_15_o (7)
 );  
 
end generate fault_injection_15_comb_true;



end Behavioral;