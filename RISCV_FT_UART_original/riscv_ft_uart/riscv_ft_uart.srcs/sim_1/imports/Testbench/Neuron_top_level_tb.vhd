library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.all;
library micro_ckt_pkg_lib;
use micro_ckt_pkg_lib.array_type.all;
use micro_ckt_pkg_lib.DigEng.all;
library micro_ckt_lib;
use micro_ckt_lib. micro_circuit_pkg.all;

entity Neuron_top_level_tb is

end Neuron_top_level_tb;

architecture Behavioral of Neuron_top_level_tb is

constant clk_period : time := 10ns;
signal clk : STD_LOGIC;
signal rst : STD_LOGIC;
signal en : STD_LOGIC;
signal Spike_in : STD_LOGIC_VECTOR(0 to 3);
signal Spike_out : STD_LOGIC;
signal weights_rst : STD_LOGIC;
signal weights_in : STD_LOGIC;
signal weights_load : STD_LOGIC;
signal weights_out : STD_LOGIC;
signal STDP_en : STD_LOGIC;

begin

    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    UUT : entity work.Neuron_top_level
        Port map (clk => clk, 
            rst => rst, 
            en => en, 
            Spike_in => Spike_in,
            Spike_out => Spike_out,
            STDP_en => STDP_en,
            weight_rst => weights_rst);
            --weights_in => weights_in,
            --weights_load => weights_in,
            --weights_out => weights_out);
            
    test_process : process
    begin
        
        wait for 100ns;
        wait until falling_edge(clk);
        wait for clk_period;
        Spike_in <= "0000"; 
        rst <= '1';
        wait for clk_period;
        rst <= '0';
        en <= '1';
        STDP_en <= '0';
        wait for clk_period * 80;
        weights_rst <= '1';
        wait for clk_period;
        weights_rst <= '0';
        wait for clk_period;
        
        
        wait for clk_period * 20;
        
        --positive leak
        --Spike_in <= "01";
        --wait for clk_period * 5;
        --Spike_in <= "00";
        --negative leak
        --wait for clk_period * 30;
        --Spike_in <= "10";
        --wait for clk_period * 5;
        --Spike_in <= "00";
        --wait for clk_period * 20;
        --fire 
        Spike_in <= "1111";
        
        
        
        wait;
    
   end process;
            
end Behavioral;














