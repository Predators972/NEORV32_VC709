----------------------------------------------------------------------------------
-- Company: Ulster University
-- Engineer: Nidhin Thandassery Sumithran
-- 
-- Create Date: 24.02.2023 17:20:47
-- Design Name: 
-- Module Name: or_gate - Behavioral
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

entity or_gate is
generic (
    ENABLE_SYNTHESIS: BOOLEAN := TRUE
  );
port (
	in_1, in_2 : in std_logic;
    out_or : out std_logic
	);
end or_gate;

architecture Behavioral of or_gate is
signal sig_in_1, sig_in_2 : std_logic;
attribute keep : boolean;
attribute keep of sig_in_1 : signal is true;
attribute keep of sig_in_2 : signal is true;

begin

or_synthesis :if ENABLE_SYNTHESIS =TRUE generate
begin
    sig_in_1 <= in_1;
    sig_in_2 <= in_2;
    out_or <= sig_in_1 OR sig_in_2;
end generate;

or_simulate :if ENABLE_SYNTHESIS=FALSE generate
    out_or <= in_1 OR in_2;
end generate;

end Behavioral;
