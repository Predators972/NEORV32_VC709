----------------------------------------------------------------------------------
-- Company: Ulster University
-- Engineer: Nidhin Thandassery Sumithran
-- 
-- Create Date: 26.05.2023 14:49:32
-- Design Name: 
-- Module Name: free_running_counter - Behavioral
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

----free running counter----

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity free_running_counter is
    Port ( clk_i     : in  std_logic;
           rstn_int   : in  std_logic;
           count   : out std_logic_vector(31 downto 0));
end free_running_counter;

architecture Behavioral of free_running_counter is
    signal counter : unsigned(31 downto 0);
begin
process (clk_i, rstn_int)
    begin
        if rstn_int = '0' then
            counter <= (others => '0');
        elsif rising_edge(clk_i) then
            counter <= counter + 1;
        end if;
end process;

  count <= std_logic_vector(counter);
  
end Behavioral;