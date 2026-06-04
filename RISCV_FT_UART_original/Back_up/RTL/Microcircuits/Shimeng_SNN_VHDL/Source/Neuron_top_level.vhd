library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.all;
library micro_ckt_pkg_lib;
use micro_ckt_pkg_lib.array_type.all;
use micro_ckt_pkg_lib.DigEng.all;
library micro_ckt_lib;
use micro_ckt_lib. micro_circuit_pkg.all;

entity Neuron_top_level is
    Generic (Dendrite_NO : NATURAL := 4;  -- Number of input of the neuron
        weights_generic : array_2d_SFIXED;
    
        weight_size_max : NATURAL := 1;   -- DO NOT CHANGE the weight size.   
        weight_size_min : integer := -6;  --They are not really selectable in the current design due to the limitatin of RNG.
        
        -- property of soma
        Resting_potential : NATURAL := 50;
        Refract_potential_start : NATURAL := 20;
        Refract_potential_end : NATURAL := 30;
        thredhold_potential : NATURAL := 100;
        Leaky_rate : SFIXED := to_SFIXED(0.125, 3, -6);
        Recharge_rate : SFIXED := to_SFIXED(0.125, 3, -6);
        
        -- STDP related generics
        Pre_spike_time_window : NATURAL := 10; 
        Post_spike_time_window : NATURAL := 10;
        Positive_amp : SFIXED := to_SFIXED(0.125, 1, -6);
        Negative_amp : SFIXED := to_SFIXED(0.125, 1, -6));
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           Spike_in : in STD_LOGIC_VECTOR(0 to Dendrite_NO - 1);
           Spike_out : out STD_LOGIC;
           
           -- control signals of weight holder
           STDP_en : in STD_LOGIC;
           weight_rst : in STD_LOGIC);
           -- weight load funciton is not ready yet, following three pins not do anything
           --weights_in : in STD_LOGIC;
           --weights_load : in STD_LOGIC;
           --weight_out : out STD_LOGIC);
           
end Neuron_top_level;

architecture Behavioral of Neuron_top_level is

signal weights : array_2d_SFIXED (0 to dendrite_NO - 1)(weight_size_max downto weight_size_min);
signal EPSP : SFIXED ((log2(NATURAL(2**weight_size_max * dendrite_NO))) downto weight_size_min);
signal Spike_out_int : STD_LOGIC;

begin
    
    weights_holder : weight_holder
        Generic map (weights_NO => Dendrite_NO,
            weight_size_max => weight_size_max,
            weights_resolution => weight_size_min,
            Pre_spike_time_window => Pre_spike_time_window,
            Post_spike_time_window => Post_spike_time_window,
            Positive_amp  => Positive_amp,
            Negative_amp => Negative_amp)
        Port map (clk => clk,
            rst => rst,
            en => en,
            STDP_en => STDP_en,
            weight_rst => weight_rst,
            Pre_spikes => Spike_in,
            Post_spike => Spike_out_int,
            --weights_in => weights_in,
            --weights_load => weights_load,
            --weight_out => weight_out,
            weights_out => weights);
                  
    Dendrites_gourp : Dendrites_group
        Generic map (Dendrite_NO => Dendrite_NO,
            weight_size_max => weight_size_max,
            weight_size_min => weight_size_min)
        Port map (clk => clk,
            en => en,
            rst => rst,
            Spikes_in => Spike_in,
            weights => weights,
            EPSP => EPSP);
    
    Soma_inst : Soma
        Generic map (Resting_potential => Resting_potential,
            Refract_potential_start => Refract_potential_start,
            Refract_potential_end => Refract_potential_end,
            thredhold_potential => thredhold_potential,
            Leaky_rate => Leaky_rate,
            Recharge_rate => Recharge_rate,
            Dendrite_NO => Dendrite_NO,
            weight_size_max => weight_size_max,
            weight_size_min => weight_size_min)
        Port map (clk => clk,
            en => en,
            rst => rst,
            EPSP => EPSP,
            Spike_out => Spike_out_int);
        
    Spike_out <= Spike_out_int;

end Behavioral;



















