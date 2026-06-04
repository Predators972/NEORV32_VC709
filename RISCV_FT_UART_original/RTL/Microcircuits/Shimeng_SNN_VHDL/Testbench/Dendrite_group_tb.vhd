library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.fixed_pkg.all;
use work.DigEng.all;
use work.array_type.all;

entity Dendrite_group_tb is
    Generic ( dendrite_NO : NATURAL := 10;
              weight_size_max : NATURAL := 3;
              weight_size_min : integer := -6);
end Dendrite_group_tb;

architecture Behavioral of Dendrite_group_tb is

constant clk_period : time := 10ns;
signal clk : STD_LOGIC;
signal en : STD_LOGIC;
signal rst : STD_LOGIC;
signal Spikes_in : STD_LOGIC_VECTOR (0 to dendrite_NO - 1);
signal weights : array_2d (0 to dendrite_NO - 1)(weight_size_max downto weight_size_min):= (others => (others => '0'));
signal EPSP : SFIXED (log2(NATURAL(2**weight_size_max * dendrite_NO)) downto weight_size_min);

begin

    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    UTT : entity work.Dendrites_group
         --Generic map (dendrite_NO => dendrite_NO, 
            --weight_size_max => weight_size_max,
            --weight_size_min => weight_size_min)
        Port map (clk => clk,
            en => en,
            rst => rst,
            Spikes_in => Spikes_in,
            weights => weights,
            EPSP => EPSP);    
            
        
    test_process : process
    begin
        wait for 100ns;
        rst <= '0';
        en <= '0';
        
        wait until falling_edge (clk);
        rst <= '0';
        en <= '0';
        Spikes_in <= (others => '0');
        weights <= (others => (others => '0'));
        wait for clk_period;
        
        rst <= '1';
        wait for clk_period;
        rst <= '1';
        wait for clk_period;
        rst <= '0';
        wait for clk_period;
        en <= '1';
        wait for clk_period*1;
        
        Spikes_in <= (others => '1');
        weights <= (others => "0111000000");
        
        wait; -- wait forever
        
    
    end process;
        

end Behavioral;
