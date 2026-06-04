----------------------------------------------------------------------------------
-- Company: Ulster University
-- Engineer: Nidhin Thandassery Sumithran
-- 
-- Create Date: 25.04.2023 15:20:10
-- Design Name: 
-- Module Name: fault_injection_logic - Behavioral
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

entity fault_injection_logic is
Port ( 
    in_data : in std_logic; 
    in_fault_type_sel : in std_logic_vector (1 downto 0);
    in_fault_inject : in std_logic;
    out_data : out std_logic
 );
end fault_injection_logic;

architecture Behavioral of fault_injection_logic is

signal sig_4x1_mux_out : std_logic;
begin

--------------------fault_type_select Mux--------------------------
---00-no fault, 01-bit flip, 10-stuck at '0', 11-stuck at '1'--
process (in_fault_type_sel)
begin
case in_fault_type_sel is   
    
    when "00" =>  
        sig_4x1_mux_out <= in_data;
    when "01" =>
        sig_4x1_mux_out <= NOT in_data;
    when "10" =>   
        sig_4x1_mux_out <= '0';
    when "11" =>
        sig_4x1_mux_out <= '1';
    when others =>
       sig_4x1_mux_out <= in_data;    
end case;
end process;

--------------------fault injection select Mux------------------
 out_data <= sig_4x1_mux_out when in_fault_inject = '1' else in_data;  
          
end Behavioral;
