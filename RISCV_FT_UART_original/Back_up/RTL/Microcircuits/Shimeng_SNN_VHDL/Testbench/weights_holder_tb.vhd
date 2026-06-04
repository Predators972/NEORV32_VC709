library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.all;
use work.array_type.all;

entity weights_holder_tb is

end weights_holder_tb;

architecture Behavioral of weights_holder_tb is

constant clk_period : time := 10ns;
signal clk : STD_LOGIC;
signal rst : STD_LOGIC;
signal en : STD_LOGIC;
signal train_en : STD_LOGIC;
signal weight_rst : STD_LOGIC;
signal Pre_spike : STD_LOGIC_VECTOR(0 to 9);
signal Post_spike : STD_LOGIC;
signal Weights : array_2d_SFIXED (0 to 9)(1 downto -6);
--signal Weight_4 : SFIXED(3 downto -6);
--signal Weight_5 : SFIXED(3 downto -6);
--signal Weight_6 : SFIXED(3 downto -6);
--signal Weight_7 : SFIXED(3 downto -6);

begin

    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    UUT : entity work.Weight_holder
        Generic map (weights_NO => 10,
            Pre_spike_time_window => 10,
            Post_spike_time_window => 10,
            Positive_amp => 1.0,
            Negative_amp => 1.0)
        Port map (clk => clk,
            rst => rst,
            en => en,
            STDP_en =>train_en,
            weight_rst => weight_rst,
            Pre_spikes => Pre_spike,
            Post_spike => Post_spike,
            weights_in => '0',
            weights_load => '0',
            weights_out => Weights);

    
    test_process : process
    begin
        --global reset and initial reset
        wait for 100ns;
        rst <= '1';
        wait for clk_period;
        rst <= '0';
        wait for clk_period;
        
        -- test the weight initialize
        wait for clk_period*60;
        en <= '1';
            for i in 0 to 100 loop
                weight_rst <= '1';
                wait for clk_period;
                weight_rst <= '0';
                wait for clk_period;
            end loop;
        
        -- Start training
        train_en <= '1';
        wait for clk_period*2;
        -- Test weight increase
            --for i in 0 to 0 loop
                -- Give pre spike
                Pre_spike(0) <= '1';
                wait for clk_period;
                Pre_spike(0) <= '0';
                wait for clk_period*5;
                -- Give post spike
                Post_spike <= '1';
                wait for clk_period;
                Post_spike <= '0';
                wait for clk_period*30;
            --end loop;
            
        -- Test weight decrease
            -- Give pre spike then post spike
            --Pre_spike(0) <= '1';
            --wait for clk_period;
            --Pre_spike(0) <= '0';
            --wait for clk_period;
            Post_spike <= '1';
            wait for clk_period;
            Post_spike <= '0';
            wait for clk_period * 6;
            -- Give post spike then pre spike
            Pre_spike(0) <= '1';      
            wait for clk_period;    
            Pre_spike(0) <= '0';  
            wait for clk_period*100;    
        
        -- Test CNT rollover
            -- Give pre spike
            Pre_spike(0) <= '1';      
            wait for clk_period;    
            Pre_spike(0) <= '0'; 
            wait for clk_period*30;
            -- Give Post spike
            Post_spike <= '1';
            wait for clk_period;
            Post_spike <= '0';
            wait for clk_period*30;
            
        -- test give Pre/Post spikes at the same time
        Pre_spike(0) <= '1';
        Post_spike <= '1';
        wait for clk_period;
        Pre_spike(0) <= '0';
        Post_spike <= '0';
        
        wait for clk_period*30;
        Pre_spike(0) <= '1';
        wait for clk_period*10;
        Post_spike <= '1';
        wait for clk_period;
        Post_spike <= '0';
        
        
        wait; --wait forever
    
    end process;
    
end Behavioral;
