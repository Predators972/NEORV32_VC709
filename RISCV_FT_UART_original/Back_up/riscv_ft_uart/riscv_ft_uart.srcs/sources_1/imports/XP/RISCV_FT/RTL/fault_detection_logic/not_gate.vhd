----------------------------------------------------------------------------------
-- Company: Ulster University
-- Engineer: Nidhin Thandassery Sumithran
-- 
-- Create Date: 02.03.2023 10:48:22
-- Design Name: 
-- Module Name: not_gate - Behavioral
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity not_gate is
generic (
    ENABLE_SYNTHESIS: BOOLEAN := TRUE;
    DELAY: time := 0 ns
  );
port (
	in_not : in std_logic;
    out_not : out std_logic
	);
end not_gate;

architecture Behavioral of not_gate is
signal sig_in_not : std_logic;
attribute keep : boolean;
attribute keep of sig_in_not : signal is true;


begin

not_synthesis: if ENABLE_SYNTHESIS=TRUE generate
begin
    sig_in_not <= in_not;
    out_not <= NOT sig_in_not;
end generate;

not_simulation: if ENABLE_SYNTHESIS=FALSE generate
    
    out_not <= NOT in_not after DELAY;
    
end generate;


end Behavioral;