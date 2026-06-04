----------------------------------------------------------------------------------
-- Company: Ulster University
-- Engineer: Nidhin Thandassery Sumithran
-- 
-- Create Date: 14.08.2023 15:12:24
-- Design Name: 
-- Module Name: fault_inj_comb_16_23 - Behavioral
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

library neorv32;
use neorv32.neorv32_package.all;

library neorv32_ft_lib;
use neorv32_ft_lib.neorv32_ft_package.all;

entity fault_inj_comb_16_23 is
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
end fault_inj_comb_16_23;

architecture Behavioral of fault_inj_comb_16_23 is

signal wdata_bit0, wdata_bit1, wdata_bit2, wdata_bit3, wdata_bit4, wdata_bit5, wdata_bit6, wdata_bit7: std_logic;
signal tap_bus_wdata_buf : std_logic_vector (7 downto 0);
signal sig_out_from_comb : std_logic_vector (7 downto 0);
attribute keep : boolean;
attribute keep of wdata_bit0, wdata_bit1, wdata_bit2, wdata_bit3, wdata_bit4, wdata_bit5, wdata_bit6, wdata_bit7: signal is true;

begin

fiu_out_bus_rdata <= ( wdata_bit7 & wdata_bit6 & wdata_bit5 & wdata_bit4 & wdata_bit3 & wdata_bit2 & wdata_bit1 & wdata_bit0 );

---------------Fault injection------------------------

fault_injection_16_comb_false: if (FAULT_INJ_COMB_16 = false) generate ---LSB

no_fault_16 : process (rf_mux, reg_alu_i, mem_i, csr_i, pc2_i)
begin
    case rf_mux is
      when rf_mux_alu_c => wdata_bit0 <= reg_alu_i (0);
      when rf_mux_mem_c => wdata_bit0 <= mem_i (0);
      when rf_mux_csr_c => wdata_bit0 <= csr_i (0);
      when rf_mux_npc_c => wdata_bit0 <= pc2_i (0);
      when others       => wdata_bit0 <= alu_i (0);
    end case;
end process no_fault_16; 
 
end generate; 
     
fault_injection_17_comb_false: if (FAULT_INJ_COMB_17 = false) generate 

no_fault_17 : process (rf_mux, reg_alu_i, mem_i, csr_i, pc2_i)
begin
    case rf_mux is
      when rf_mux_alu_c => wdata_bit1 <= reg_alu_i (1);
      when rf_mux_mem_c => wdata_bit1 <= mem_i (1);
      when rf_mux_csr_c => wdata_bit1 <= csr_i (1);
      when rf_mux_npc_c => wdata_bit1 <= pc2_i (1);
      when others       => wdata_bit1 <= alu_i (1);
    end case;
end process no_fault_17;  
       
end generate; 

fault_injection_18_comb_false: if (FAULT_INJ_COMB_18 = false) generate 

no_fault_18 : process (rf_mux, reg_alu_i, mem_i, csr_i, pc2_i)
begin
    case rf_mux is
      when rf_mux_alu_c => wdata_bit2 <= reg_alu_i (2);
      when rf_mux_mem_c => wdata_bit2 <= mem_i (2);
      when rf_mux_csr_c => wdata_bit2 <= csr_i (2);
      when rf_mux_npc_c => wdata_bit2 <= pc2_i (2);
      when others       => wdata_bit2 <= alu_i (2);
    end case;
end process no_fault_18;  
       
end generate;

fault_injection_19_comb_false: if (FAULT_INJ_COMB_19 = false) generate 

no_fault_19 : process (rf_mux, reg_alu_i, mem_i, csr_i, pc2_i)
begin
    case rf_mux is
      when rf_mux_alu_c => wdata_bit3 <= reg_alu_i (3);
      when rf_mux_mem_c => wdata_bit3 <= mem_i (3);
      when rf_mux_csr_c => wdata_bit3 <= csr_i (3);
      when rf_mux_npc_c => wdata_bit3 <= pc2_i (3);
      when others       => wdata_bit3 <= alu_i (3);
    end case;
end process no_fault_19;  
       
end generate; 

fault_injection_20_comb_false: if (FAULT_INJ_COMB_20 = false) generate 

no_fault_20 : process (rf_mux, reg_alu_i, mem_i, csr_i, pc2_i)
begin
    case rf_mux is
      when rf_mux_alu_c => wdata_bit4 <= reg_alu_i (4);
      when rf_mux_mem_c => wdata_bit4 <= mem_i (4);
      when rf_mux_csr_c => wdata_bit4 <= csr_i (4);
      when rf_mux_npc_c => wdata_bit4 <= pc2_i (4);
      when others       => wdata_bit4 <= alu_i (4);
    end case;
end process no_fault_20;  
       
end generate; 

fault_injection_21_comb_false: if (FAULT_INJ_COMB_21 = false) generate 

no_fault_21 : process (rf_mux, reg_alu_i, mem_i, csr_i, pc2_i)
begin
    case rf_mux is
      when rf_mux_alu_c => wdata_bit5 <= reg_alu_i (5);
      when rf_mux_mem_c => wdata_bit5 <= mem_i (5);
      when rf_mux_csr_c => wdata_bit5 <= csr_i (5);
      when rf_mux_npc_c => wdata_bit5 <= pc2_i (5);
      when others       => wdata_bit5 <= alu_i (5);
    end case;
end process no_fault_21;  
       
end generate; 

fault_injection_22_comb_false: if (FAULT_INJ_COMB_22 = false) generate 

no_fault_22 : process (rf_mux, reg_alu_i, mem_i, csr_i, pc2_i)
begin
    case rf_mux is
      when rf_mux_alu_c => wdata_bit6 <= reg_alu_i (6);
      when rf_mux_mem_c => wdata_bit6 <= mem_i (6);
      when rf_mux_csr_c => wdata_bit6 <= csr_i (6);
      when rf_mux_npc_c => wdata_bit6 <= pc2_i (6);
      when others       => wdata_bit6 <= alu_i (6);
    end case;
end process no_fault_22;  
       
end generate; 

fault_injection_23_comb_false: if (FAULT_INJ_COMB_23 = false) generate 

no_fault_23 : process (rf_mux, reg_alu_i, mem_i, csr_i, pc2_i)
begin
    case rf_mux is
      when rf_mux_alu_c => wdata_bit7 <= reg_alu_i (7);
      when rf_mux_mem_c => wdata_bit7 <= mem_i (7);
      when rf_mux_csr_c => wdata_bit7 <= csr_i (7);
      when rf_mux_npc_c => wdata_bit7 <= pc2_i (7);
      when others       => wdata_bit7 <= alu_i (7);
    end case;
end process no_fault_23;  
       
end generate; 

----------------Fault injection selection True start -----------------------


sig_out_from_comb <= bus_rdata_i_after_comb;

fault_injection_16_comb_true : if (FAULT_INJ_COMB_16 = true) generate

tap_signal_16 : process (rf_mux)
begin
  case rf_mux is
      when rf_mux_alu_c => tap_bus_wdata_buf (0) <= reg_alu_i (0);
      when rf_mux_mem_c => tap_bus_wdata_buf (0) <= mem_i (0);
      when rf_mux_csr_c => tap_bus_wdata_buf (0) <= csr_i (0);
      when rf_mux_npc_c => tap_bus_wdata_buf (0) <= pc2_i (0);
      when others       => tap_bus_wdata_buf (0) <= alu_i (0);
  end case;  
end process tap_signal_16;   
         

fault_inj_unit_inst_comb_16 : fault_injection_logic

port map ( 
    in_data => tap_bus_wdata_buf (0),
    in_fault_type_sel => fault_inj_type_comb_16_23_i (0),
    in_fault_inject => fault_inj_trig_comb_16_23_i (0),
    out_data => wdata_bit0
 );

fdl_channel_inst_16 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_wdata_buf (0),
    in_destination => sig_out_from_comb (0),
    out_fault_status => fault_status_comb_16_23_o (0)
 );  
 
end generate fault_injection_16_comb_true;


fault_injection_17_comb_true : if (FAULT_INJ_COMB_17 = true) generate

tap_signal_17 : process (rf_mux)
begin
  case rf_mux is
      when rf_mux_alu_c => tap_bus_wdata_buf (1) <= reg_alu_i (1);
      when rf_mux_mem_c => tap_bus_wdata_buf (1) <= mem_i (1);
      when rf_mux_csr_c => tap_bus_wdata_buf (1) <= csr_i (1);
      when rf_mux_npc_c => tap_bus_wdata_buf (1) <= pc2_i (1);
      when others       => tap_bus_wdata_buf (1) <= alu_i (1);
  end case;  
end process tap_signal_17;   
         

fault_inj_unit_inst_comb_17 : fault_injection_logic

port map ( 
    in_data => tap_bus_wdata_buf (1),
    in_fault_type_sel => fault_inj_type_comb_16_23_i (1),
    in_fault_inject => fault_inj_trig_comb_16_23_i (1),
    out_data => wdata_bit1
 );

fdl_channel_inst_17 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_wdata_buf (1),
    in_destination => sig_out_from_comb (1),
    out_fault_status => fault_status_comb_16_23_o (1)
 );  
 
end generate fault_injection_17_comb_true;


fault_injection_18_comb_true : if (FAULT_INJ_COMB_18 = true) generate

tap_signal_18 : process (rf_mux)
begin
  case rf_mux is
      when rf_mux_alu_c => tap_bus_wdata_buf (2) <= reg_alu_i (2);
      when rf_mux_mem_c => tap_bus_wdata_buf (2) <= mem_i (2);
      when rf_mux_csr_c => tap_bus_wdata_buf (2) <= csr_i (2);
      when rf_mux_npc_c => tap_bus_wdata_buf (2) <= pc2_i (2);
      when others       => tap_bus_wdata_buf (2) <= alu_i (2);
  end case;  
end process tap_signal_18;   
         

fault_inj_unit_inst_comb_18 : fault_injection_logic

port map ( 
    in_data => tap_bus_wdata_buf (2),
    in_fault_type_sel => fault_inj_type_comb_16_23_i (2),
    in_fault_inject => fault_inj_trig_comb_16_23_i (2),
    out_data => wdata_bit2
 );

fdl_channel_inst_18 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_wdata_buf (2),
    in_destination => sig_out_from_comb (2),
    out_fault_status => fault_status_comb_16_23_o (2)
 );  
 
end generate fault_injection_18_comb_true;


fault_injection_19_comb_true : if (FAULT_INJ_COMB_19 = true) generate

tap_signal_19 : process (rf_mux)
begin
  case rf_mux is
      when rf_mux_alu_c => tap_bus_wdata_buf (3) <= reg_alu_i (3);
      when rf_mux_mem_c => tap_bus_wdata_buf (3) <= mem_i (3);
      when rf_mux_csr_c => tap_bus_wdata_buf (3) <= csr_i (3);
      when rf_mux_npc_c => tap_bus_wdata_buf (3) <= pc2_i (3);
      when others       => tap_bus_wdata_buf (3) <= alu_i (3);
  end case;  
end process tap_signal_19;   
         

fault_inj_unit_inst_comb_19 : fault_injection_logic

port map ( 
    in_data => tap_bus_wdata_buf (3),
    in_fault_type_sel => fault_inj_type_comb_16_23_i (3),
    in_fault_inject => fault_inj_trig_comb_16_23_i (3),
    out_data => wdata_bit3
 );

fdl_channel_inst_19 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_wdata_buf (3),
    in_destination => sig_out_from_comb (3),
    out_fault_status => fault_status_comb_16_23_o (3)
 );  
 
end generate fault_injection_19_comb_true;


fault_injection_20_comb_true : if (FAULT_INJ_COMB_20 = true) generate

tap_signal_20 : process (rf_mux)
begin
  case rf_mux is
      when rf_mux_alu_c => tap_bus_wdata_buf (4) <= reg_alu_i (4);
      when rf_mux_mem_c => tap_bus_wdata_buf (4) <= mem_i (4);
      when rf_mux_csr_c => tap_bus_wdata_buf (4) <= csr_i (4);
      when rf_mux_npc_c => tap_bus_wdata_buf (4) <= pc2_i (4);
      when others       => tap_bus_wdata_buf (4) <= alu_i (4);
  end case;  
end process tap_signal_20;   
         

fault_inj_unit_inst_comb_20 : fault_injection_logic

port map ( 
    in_data => tap_bus_wdata_buf (4),
    in_fault_type_sel => fault_inj_type_comb_16_23_i (4),
    in_fault_inject => fault_inj_trig_comb_16_23_i (4),
    out_data => wdata_bit4
 );

fdl_channel_inst_20 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_wdata_buf (4),
    in_destination => sig_out_from_comb (4),
    out_fault_status => fault_status_comb_16_23_o (4)
 );  
 
end generate fault_injection_20_comb_true;


fault_injection_21_comb_true : if (FAULT_INJ_COMB_21 = true) generate

tap_signal_21 : process (rf_mux)
begin
  case rf_mux is
      when rf_mux_alu_c => tap_bus_wdata_buf (5) <= reg_alu_i (5);
      when rf_mux_mem_c => tap_bus_wdata_buf (5) <= mem_i (5);
      when rf_mux_csr_c => tap_bus_wdata_buf (5) <= csr_i (5);
      when rf_mux_npc_c => tap_bus_wdata_buf (5) <= pc2_i (5);
      when others       => tap_bus_wdata_buf (5) <= alu_i (5);
  end case;  
end process tap_signal_21;   
         

fault_inj_unit_inst_comb_21 : fault_injection_logic

port map ( 
    in_data => tap_bus_wdata_buf (5),
    in_fault_type_sel => fault_inj_type_comb_16_23_i (5),
    in_fault_inject => fault_inj_trig_comb_16_23_i (5),
    out_data => wdata_bit5
 );

fdl_channel_inst_21 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_wdata_buf (5),
    in_destination => sig_out_from_comb (5),
    out_fault_status => fault_status_comb_16_23_o (5)
 );  
 
end generate fault_injection_21_comb_true;



fault_injection_22_comb_true : if (FAULT_INJ_COMB_22 = true) generate

tap_signal_22 : process (rf_mux)
begin
  case rf_mux is
      when rf_mux_alu_c => tap_bus_wdata_buf (6) <= reg_alu_i (6);
      when rf_mux_mem_c => tap_bus_wdata_buf (6) <= mem_i (6);
      when rf_mux_csr_c => tap_bus_wdata_buf (6) <= csr_i (6);
      when rf_mux_npc_c => tap_bus_wdata_buf (6) <= pc2_i (6);
      when others       => tap_bus_wdata_buf (6) <= alu_i (6);
  end case;  
end process tap_signal_22;   
         

fault_inj_unit_inst_comb_22 : fault_injection_logic

port map ( 
    in_data => tap_bus_wdata_buf (6),
    in_fault_type_sel => fault_inj_type_comb_16_23_i (6),
    in_fault_inject => fault_inj_trig_comb_16_23_i (6),
    out_data => wdata_bit6
 );

fdl_channel_inst_22 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_wdata_buf (6),
    in_destination => sig_out_from_comb (6),
    out_fault_status => fault_status_comb_16_23_o (6)
 );  
 
end generate fault_injection_22_comb_true;



fault_injection_23_comb_true : if (FAULT_INJ_COMB_23 = true) generate

tap_signal_23 : process (rf_mux)
begin
  case rf_mux is
      when rf_mux_alu_c => tap_bus_wdata_buf (7) <= reg_alu_i (7);
      when rf_mux_mem_c => tap_bus_wdata_buf (7) <= mem_i (7);
      when rf_mux_csr_c => tap_bus_wdata_buf (7) <= csr_i (7);
      when rf_mux_npc_c => tap_bus_wdata_buf (7) <= pc2_i (7);
      when others       => tap_bus_wdata_buf (7) <= alu_i (7);
  end case;  
end process tap_signal_23;   
         

fault_inj_unit_inst_comb_23 : fault_injection_logic

port map ( 
    in_data => tap_bus_wdata_buf (7),
    in_fault_type_sel => fault_inj_type_comb_16_23_i (7),
    in_fault_inject => fault_inj_trig_comb_16_23_i (7),
    out_data => wdata_bit7
 );

fdl_channel_inst_23 : fdl_for_channel_top
generic map(
    BUFFER_STAGES => 1,
    ENABLE_SYNTHESIS => true,
    DELAY => 0ns
  )
port map( 
    in_source => tap_bus_wdata_buf (7),
    in_destination => sig_out_from_comb (7),
    out_fault_status => fault_status_comb_16_23_o (7)
 );  
 
end generate fault_injection_23_comb_true;

-------Fault injection statement ends---------


end Behavioral;