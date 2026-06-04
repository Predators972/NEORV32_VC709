library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.array_type.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RandomNumberGenerator_tb is

end RandomNumberGenerator_tb;

architecture Behavioral of RandomNumberGenerator_tb is

constant clk_period : time := 5ns;

signal clk : STD_LOGIC;
signal enable : STD_LOGIC;
signal rst : STD_LOGIC;
signal dOut : array_2d_STD (0 to 7)(7 downto 0);

begin

    UUT : entity work.RandomNumberGenerator_generic
        port map (clk => clk,
            enable => enable,
            rst => rst,
            dOut => dOut);
    
    clk_process : process
        begin
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end process;
    
    test_process : process
    begin
        wait for 1000ns;
        rst <= '1';
        wait for clk_period*2;
        rst <= '0';
        enable <= '1';
        wait for clk_period*1000;
        enable <= '0';
      
        wait;

    end process;

end Behavioral;
























