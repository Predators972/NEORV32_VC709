----------------------------------------------------------------------------------
-- Company: Ulster University
-- Engineer: Nidhin Thandassery Sumithran
-- 
-- Create Date: 28.08.2023 12:10:24
-- Design Name: 
-- Module Name: fault_inj_det_status_glue_logic - Behavioral
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

library neorv32_ft_lib;
use neorv32_ft_lib.neorv32_ft_package.all;

library fault_inj_lib;
use fault_inj_lib.fault_injection_package.all;

entity fault_inj_det_status_glue_logic is
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
end fault_inj_det_status_glue_logic;

architecture Behavioral of fault_inj_det_status_glue_logic is

signal sig_comb_fault_status: std_logic_vector (23 downto 0);
signal sig_sync_fault_status: std_logic_vector (23 downto 0);

begin

location_1_comb: process  ----location 1. combinational
    begin
        for i in 0 to 7 loop
            sig_comb_fault_status (i) <= fault_status_comb_0_7_o (i);
        end loop;
end process location_1_comb;

location_2_comb: process  ----location 2. combinational
    begin
        for i in 8 to 15 loop
            sig_comb_fault_status (i) <= fault_status_comb_8_15_o (i - 8);
        end loop;
end process location_2_comb;

location_3_comb: process  ----location 3. combinational
    begin
        for i in 16 to 23 loop
            sig_comb_fault_status (i) <= fault_status_comb_16_23_o (i - 16);
        end loop;
end process location_3_comb;


location_1_sync: process  ----location 1. Synchronous
    begin
        for i in 0 to 7 loop
            sig_sync_fault_status (i) <= fault_status_sync_0_7_o (i);
        end loop;
end process location_1_sync;

location_2_sync: process  ----location 2. Synchronous
    begin
        for i in 8 to 15 loop
            sig_sync_fault_status (i) <= fault_status_sync_8_15_o (i - 8);
        end loop;
end process location_2_sync;

location_3_sync: process  ----location 3. Synchronous
    begin
        for i in 16 to 23 loop
            sig_sync_fault_status (i) <= fault_status_sync_16_23_o (i - 16);
        end loop;
end process location_3_sync;


fault_status_process : process(clk_i, rstn_i)
begin
 if (rstn_i = '0') then
    out_comb_fault_status <= (others => '0');
    out_sync_fault_status <= (others => '0');
 elsif rising_edge(clk_i) then
    out_comb_fault_status <= sig_comb_fault_status;
    out_sync_fault_status <= sig_sync_fault_status;
 end if;
end process;


---------Fault injection trigger signals synchronous-----------------

process   
  begin
    for i in 0 to 7 loop
      fault_inj_trig_sync_0_7_i (i)   <= in_sync_fault_inj_en (i).fault_inj_trigger;
      fault_inj_type_sync_0_7_i (i)   <= in_sync_fault_inj_en (i).fault_type_sel;
      fault_inj_trig_sync_8_15_i(i)   <= in_sync_fault_inj_en (i+8).fault_inj_trigger;
      fault_inj_type_sync_8_15_i (i)  <= in_sync_fault_inj_en (i+8).fault_type_sel;
      fault_inj_trig_sync_16_23_i (i) <= in_sync_fault_inj_en (i+16).fault_inj_trigger;
      fault_inj_type_sync_16_23_i (i) <= in_sync_fault_inj_en (i+16).fault_type_sel;
    end loop;
end process;

---------Fault injection trigger signals Combinational-----------------
process 
  begin
    for i in 0 to 7 loop
      fault_inj_trig_comb_0_7_i (i)   <= in_comb_fault_inj_en (i).fault_inj_trigger;
      fault_inj_type_comb_0_7_i (i)   <= in_comb_fault_inj_en (i).fault_type_sel;
      fault_inj_trig_comb_8_15_i (i)  <= in_comb_fault_inj_en (i+ 8).fault_inj_trigger;
      fault_inj_type_comb_8_15_i (i)  <= in_comb_fault_inj_en (i+ 8).fault_type_sel;
      fault_inj_trig_comb_16_23_i(i)  <= in_comb_fault_inj_en (i+ 16).fault_inj_trigger;
      fault_inj_type_comb_16_23_i (i) <= in_comb_fault_inj_en (i+ 16).fault_type_sel;
      
    end loop;
end process;


end Behavioral;
