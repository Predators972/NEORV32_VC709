----------------------------------------------------------------------------------
-- Company: Ulster University
-- Engineer: Nidhin
-- 
-- Create Date: 24.02.2023
-- Design Name: 
-- Module Name: and_gate - Behavioral
-- Project Name: nervous Project
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

entity and_gate is
generic (
    ENABLE_SYNTHESIS: BOOLEAN := TRUE
  );
port (
	in_1, in_2 : in std_logic;
    out_and : out std_logic
	);
end and_gate;

architecture Behavioral of and_gate is
signal sig_in_1, sig_in_2 : std_logic;
attribute keep : boolean;
attribute keep of sig_in_1 : signal is true;
attribute keep of sig_in_2 : signal is true;

begin

and_synthesis: if ENABLE_SYNTHESIS=TRUE generate
begin
    sig_in_1 <= in_1;
    sig_in_2 <= in_2;
    out_and <= sig_in_1 AND sig_in_2;
end generate;

and_simulation: if ENABLE_SYNTHESIS=FALSE generate

    out_and <= in_1 AND in_2;
    
end generate;


end Behavioral;
