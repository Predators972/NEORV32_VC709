---------------------------------------------------------------------------------------------------------------
-- RISA Project
-- Author: A.Greensted
-- Module:
-- Description:
-- History:
---------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library micro_ckt_pkg_lib;
use micro_ckt_pkg_lib.array_type.all;


-- Based upon the follow paper:
-- FPGA Implementation of Neighborhood-of-Four Cellular Automata Random Number Generators
-- Barry Shackleford, Motoo Tanaka, Richard Carter, Greg Snider
-- 10th International Symposium on Field Programmable Gate Arrays, Monterey, California, USA, 2002

entity RandomNumberGenerator_generic is
    generic (output_NO : NATURAL := 7);
	port (	clk		: in	std_logic;
				enable	: in	std_logic;
				rst	: in	std_logic;
				dout : out array_2d_STD(0 to output_NO - 1)(7 downto 0));

end RandomNumberGenerator_generic;

architecture General of RandomNumberGenerator_generic is

	-- Declare types
	subtype CELL_ROW is std_logic_vector(0 to 7);
	type CELL_SQUARE is array (0 to 7) of CELL_ROW;

	-- Declare cell array
	signal cells : CELL_SQUARE;

	-- Intenal Enable for controlling random number generation (1 number / 2 clk)
	signal updateEn : std_logic;

	-- Declare function to calculate cell next state
	function getCellOutput( cell3 : std_logic; cell2 : std_logic;
									cell1 : std_logic; cell0 : std_logic) return std_logic is

		variable output	: std_logic;
		variable input		: std_logic_vector(3 downto 0);

	begin
	
		input := cell3 & cell2 & cell1 & cell0;

		-- CA 27225
		-- h6A59
		-- b0110 1010 0101 1001

		case input is
			when b"0000"	=> output := '1';
			when b"0001"	=> output := '0';
			when b"0010"	=> output := '0';
			when b"0011"	=> output := '1';

			when b"0100"	=> output := '1';
			when b"0101"	=> output := '0';
			when b"0110"	=> output := '1';
			when b"0111"	=> output := '0';

			when b"1000"	=> output := '0';
			when b"1001"	=> output := '1';
			when b"1010"	=> output := '0';
			when b"1011"	=> output := '1';

			when b"1100"	=> output := '0';
			when b"1101"	=> output := '1';
			when b"1110"	=> output := '1';
			when b"1111"	=> output := '0';

			when others		=> output := '0';

		end case;

		return output;

	end function;

begin

-- Provides a update control signal to slow down number generation
UpdateControl : process(clk)
begin
	if (clk'event and clk='1') then

		if (rst='1') then
			updateEn <= '0';

		elsif (enable='1') then
			updateEn <= '1';
	
		end if;

	end if;

end process;

-- Connect the cell array
Connect_row : for row in 0 to 7 generate
   constant cell0row : integer := (row+6) mod 8;   -- 2n
   constant cell1row : integer := row;             -- c
   constant cell2row : integer := (row+7) mod 8;   -- n
   constant cell3row : integer := (row+2) mod 8;   -- 2s

begin

   Connect_col : for col in 0 to 7 generate
      constant cell0col : integer := (col+6) mod 8;   -- 2w
      constant cell1col : integer := col;             -- c
      constant cell2col : integer := (col+2) mod 8;   -- 2e
      constant cell3col : integer := (col+1) mod 8;   -- e

		signal resetVal	: std_logic;

	begin

		ResetGen0 : if (row=7 and col=7) generate
			resetVal <= '1'; -- Reset cell 7,7 to 1
		end generate;

		ResetGen1 : if (row<7 or col<7) generate
			resetVal <= '0'; -- Reset all other cells to '0'
		end generate;

		CellUpdate : process(clk)
		begin

			if (clk'event and clk='1') then

				if (rst='1') then
					cells(row)(col) <= resetVal;

				elsif (enable='1' and updateEn = '1') then
					cells(row)(col) <= getCellOutput(cells(cell3row)(cell3col), cells(cell2row)(cell2col),
																cells(cell1row)(cell1col), cells(cell0row)(cell0col));

				end if;

			end if;

		end process;

	end generate;

end generate;

-- Convert the cell array into a linear outputs
output_connect_row : for row in 0 to (output_NO - 1) generate
begin
    output_connect_col : for col in 0 to 7 generate
    begin
        dout(row)(col) <= cells(row)(col);
    end generate;
end generate;

end General;
