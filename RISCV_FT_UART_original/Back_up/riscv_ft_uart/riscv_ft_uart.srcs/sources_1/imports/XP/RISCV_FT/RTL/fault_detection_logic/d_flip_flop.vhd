----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.02.2023 17:31:28
-- Design Name: 
-- Module Name: d_flip_flop - Behavioral
-- Project Name: 
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


entity d_flip_flop is
  port (
    clk   : in  std_logic;
    reset : in  std_logic;
    in_d  : in  std_logic;
    out_q : out std_logic
   );
end d_flip_flop;

architecture Behavioral of d_flip_flop is

begin
process (clk, reset)
  begin
    if (reset = '1') then
      out_q <= '0';  
    elsif rising_edge(clk) then
      out_q <= in_d;    
    end if;
  end process;

end Behavioral;
