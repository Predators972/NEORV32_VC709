----------------------------------------------------------------------------------
-- Company: Ulster University
-- Engineer: Nidhin Thandassery Sumithran
-- 
-- Create Date: 26.05.2023 14:49:32
-- Design Name: 
-- Module Name: pulse_randomiser - Behavioral
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

entity pulse_randomiser is
Port (
    in_pulse      : in std_logic;
    in_clk        : in std_logic; 
    in_reset      : in std_logic;
    out_pulse_8   : out std_logic_vector (7 downto 0);
    out_pulse_24  : out std_logic_vector (23 downto 0)
 );
end pulse_randomiser;

architecture Behavioral of pulse_randomiser is

signal sig_path_0, sig_path_0_d1, sig_path_0_d2, sig_path_0_d3, sig_path_0_d4, sig_path_0_d5, sig_path_0_d6, sig_path_0_d7 : std_logic;
signal sig_path_1, sig_path_1_d1, sig_path_1_d2, sig_path_1_d3, sig_path_1_d4, sig_path_1_d5, sig_path_1_d6, sig_path_1_d7 : std_logic;
signal sig_path_2, sig_path_2_d1, sig_path_2_d2, sig_path_2_d3, sig_path_2_d4, sig_path_2_d5, sig_path_2_d6, sig_path_2_d7 : std_logic;
signal sig_path_3, sig_path_3_d1, sig_path_3_d2, sig_path_3_d3, sig_path_3_d4, sig_path_3_d5, sig_path_3_d6, sig_path_3_d7 : std_logic;
signal sig_path_4, sig_path_4_d1, sig_path_4_d2, sig_path_4_d3, sig_path_4_d4, sig_path_4_d5, sig_path_4_d6, sig_path_4_d7 : std_logic;
signal sig_path_5, sig_path_5_d1, sig_path_5_d2, sig_path_5_d3, sig_path_5_d4, sig_path_5_d5, sig_path_5_d6, sig_path_5_d7 : std_logic;
signal sig_path_6, sig_path_6_d1, sig_path_6_d2, sig_path_6_d3, sig_path_6_d4, sig_path_6_d5, sig_path_6_d6, sig_path_6_d7 : std_logic;
signal sig_path_7, sig_path_7_d1, sig_path_7_d2, sig_path_7_d3, sig_path_7_d4, sig_path_7_d5, sig_path_7_d6, sig_path_7_d7 : std_logic;
signal reg_out_pulse_8 : std_logic_vector (7 downto 0);
signal reg_out_pulse_24 : std_logic_vector (23 downto 0);

begin

process(in_clk, in_reset)
begin
 if (in_reset = '0') then
    sig_path_1 <= '0';
    sig_path_1_d1 <= '0';
    sig_path_1_d2 <= '0';
 ---path2-- 5 stages
    sig_path_2 <= '0';
    sig_path_2_d1 <= '0';
    sig_path_2_d2 <= '0';
    sig_path_2_d3 <= '0';
    sig_path_2_d4 <= '0';
 ---path3-- 7 stages
    sig_path_3 <= '0';
    sig_path_3_d1 <= '0';
    sig_path_3_d2 <= '0';
    sig_path_3_d3 <= '0';
    sig_path_3_d4 <= '0';
    sig_path_3_d5 <= '0';
    sig_path_3_d6 <= '0';
 ---path4-- 2 stages
    sig_path_4 <= '0';
    sig_path_4_d1 <= '0';
 ---path5-- 4 stages
    sig_path_5 <= '0';
    sig_path_5_d1 <= '0';
    sig_path_5_d2 <= '0';
    sig_path_5_d3 <= '0';
 ---path6--1 stage
    sig_path_6 <= '0';
    
 ---path7-- 6 stages
    sig_path_7 <= '0';
    sig_path_7_d1 <= '0';
    sig_path_7_d2 <= '0';
    sig_path_7_d3 <= '0';
    sig_path_7_d4 <= '0';
    sig_path_7_d5 <= '0';
  ----------------------
    reg_out_pulse_8 <= (others => '0');
    reg_out_pulse_24 <= (others => '0');
    
 elsif rising_edge(in_clk) then
 ---path7--
    ---0 stages
 ---path1-- 3 stages
    sig_path_1 <= in_pulse;
    sig_path_1_d1 <= sig_path_1;
    sig_path_1_d2 <= sig_path_1_d1;
 ---path2-- 5 stages
    sig_path_2 <= in_pulse;
    sig_path_2_d1 <= sig_path_2;
    sig_path_2_d2 <= sig_path_2_d1;
    sig_path_2_d3 <= sig_path_2_d2;
    sig_path_2_d4 <= sig_path_2_d3;
 ---path3-- 7 stages
    sig_path_3 <= in_pulse;
    sig_path_3_d1 <= sig_path_3;
    sig_path_3_d2 <= sig_path_3_d1;
    sig_path_3_d3 <= sig_path_3_d2;
    sig_path_3_d4 <= sig_path_3_d3;
    sig_path_3_d5 <= sig_path_3_d4;
    sig_path_3_d6 <= sig_path_3_d5;
 ---path4-- 2 stages
    sig_path_4 <= in_pulse;
    sig_path_4_d1 <= sig_path_4;
 ---path5-- 4 stages
    sig_path_5 <= in_pulse;
    sig_path_5_d1 <= sig_path_5;
    sig_path_5_d2 <= sig_path_5_d1;
    sig_path_5_d3 <= sig_path_5_d2;
 ---path6--1 stage
    sig_path_6 <= in_pulse;
    
 ---path7-- 6 stages
    sig_path_7 <= in_pulse;
    sig_path_7_d1 <= sig_path_7;
    sig_path_7_d2 <= sig_path_7_d1;
    sig_path_7_d3 <= sig_path_7_d2;
    sig_path_7_d4 <= sig_path_7_d3;
    sig_path_7_d5 <= sig_path_7_d4;
  -----------------------------------------
    reg_out_pulse_8 <= in_pulse & sig_path_1_d2 & sig_path_2_d4 & sig_path_3_d6 & sig_path_4_d1 & sig_path_5_d3 & sig_path_6 & sig_path_7_d5;
    reg_out_pulse_24 <= reg_out_pulse_8 & reg_out_pulse_8 & reg_out_pulse_8;
 end if;

out_pulse_8 <= reg_out_pulse_8;
out_pulse_24 <= reg_out_pulse_24;

end process;


end Behavioral;
