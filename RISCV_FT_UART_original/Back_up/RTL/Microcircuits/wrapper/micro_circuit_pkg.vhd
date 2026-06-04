----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.11.2023 20:58:38
-- Design Name: 
-- Module Name: micro_circuit_pkg - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.all;
library micro_ckt_pkg_lib;
use micro_ckt_pkg_lib.array_type.all;
use micro_ckt_pkg_lib.DigEng.all;

package micro_circuit_pkg is


component f_Loc_1_Comb_SA_Diff_top is
    generic(dendrite_NO : integer := 11;
            neuron_NO : integer := 14;
            weights_array : array_3d_SFIXED(0 to neuron_NO-1)(0 to dendrite_NO-1)(1 downto -6) :=
            (
            (to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(0.43528983, 1, -6), to_SFIXED(-4.72688100, 1, -6), to_SFIXED(-0.43408621, 1, -6), to_SFIXED(0.58161537, 1, -6), to_SFIXED(0.11846055, 1, -6), to_SFIXED(-5.85423208, 1, -6), to_SFIXED(0.99634725, 1, -6)),
            (to_SFIXED(-5.41759901, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(-3.91156189, 1, -6), to_SFIXED(0.81870513, 1, -6), to_SFIXED(-3.38965642, 1, -6), to_SFIXED(-4.64689989, 1, -6), to_SFIXED(-4.01846715, 1, -6), to_SFIXED(-6.72101514, 1, -6), to_SFIXED(-1.41464199, 1, -6)),
            (to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6)),
            (to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6)),
            (to_SFIXED(1.09502853, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(-0.89067404, 1, -6), to_SFIXED(-5.07399142, 1, -6), to_SFIXED(0.74035186, 1, -6), to_SFIXED(-0.33272554, 1, -6), to_SFIXED(0.39348798, 1, -6), to_SFIXED(0.46501243, 1, -6), to_SFIXED(0.52616561, 1, -6), to_SFIXED(0.90778084, 1, -6)),
            (to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6)),
            (to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(0.69840177, 1, -6), to_SFIXED(0.78663258, 1, -6), to_SFIXED(0.72737885, 1, -6), to_SFIXED(-0.97750879, 1, -6), to_SFIXED(-0.04010293, 1, -6)),
            (to_SFIXED(0.72496092, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(0.68534698, 1, -6), to_SFIXED(0.61580474, 1, -6), to_SFIXED(-3.43988451, 1, -6), to_SFIXED(0.69813318, 1, -6), to_SFIXED(-2.54899903, 1, -6), to_SFIXED(0.81931506, 1, -6), to_SFIXED(0.29203706, 1, -6)),
            (to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6)),
            (to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6)),
            (to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(0.64978890, 1, -6), to_SFIXED(0.39279362, 1, -6), to_SFIXED(-2.85518365, 1, -6), to_SFIXED(-6.17209136, 1, -6), to_SFIXED(1.03486590, 1, -6), to_SFIXED(-3.94897582, 1, -6)),
            (to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6)),
            (to_SFIXED(1.10000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(-1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6)),
            (to_SFIXED(1.10000000, 1, -6), to_SFIXED(-1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6), to_SFIXED(1.00000000, 1, -6)))
            );

            -- weight connections 
            -- N:X is signal from neuron X
            -- I:X is signal from input X
            -- n/c is no connection
            --
            -- 		 neuron 0 | n/c | n/c | n/c | n/c | I:7 | I:6 | I:5 | I:3 | I:2 | I:1 | I:0 | 		 --
            -- 		 neuron 1 | N:5 | n/c | n/c | n/c | I:7 | I:6 | I:5 | I:4 | I:3 | I:1 | I:0 | 		 --
            -- 		 neuron 2 | N:0 | N:1 | n/c | n/c | n/c | n/c | n/c | n/c | n/c | n/c | n/c | 		 --
            -- 		 neuron 3 | N:0 | N:1 | n/c | n/c | n/c | n/c | n/c | n/c | n/c | n/c | n/c | 		 --
            -- 		 neuron 4 | N:3 | N:5 | n/c | I:7 | I:6 | I:5 | I:4 | I:3 | I:2 | I:1 | I:0 | 		 --
            -- 		 neuron 5 | N:4 | n/c | n/c | n/c | n/c | n/c | n/c | n/c | n/c | n/c | n/c | 		 --
            -- 		 neuron 6 | n/c | n/c | n/c | n/c | n/c | n/c | I:7 | I:6 | I:5 | I:1 | I:0 | 		 --
            -- 		 neuron 7 | N:11 | n/c | n/c | n/c | I:7 | I:6 | I:4 | I:3 | I:2 | I:1 | I:0 | 		 --
            -- 		 neuron 8 | N:6 | N:7 | n/c | n/c | n/c | n/c | n/c | n/c | n/c | n/c | n/c | 		 --
            -- 		 neuron 9 | N:6 | N:7 | n/c | n/c | n/c | n/c | n/c | n/c | n/c | n/c | n/c | 		 --
            -- 		 neuron 10 | N:11 | n/c | n/c | n/c | n/c | I:7 | I:6 | I:5 | I:2 | I:1 | I:0 | 		 --
            -- 		 neuron 11 | N:10 | n/c | n/c | n/c | n/c | n/c | n/c | n/c | n/c | n/c | n/c | 		 --
            -- 		 neuron 12 | N:5 | N:12 | N:13 | n/c | n/c | n/c | n/c | n/c | n/c | n/c | n/c | 		 --
            -- 		 neuron 13 | N:9 | N:12 | N:13 | n/c | n/c | n/c | n/c | n/c | n/c | n/c | n/c | 		 --

    port (clk, rst, en : in std_logic;
          Spike_in : in std_logic_vector(0 to 7);
          Spikes_out : out std_logic_vector(0 to 1);
          STDP_en : in std_logic;
          weight_rst : in std_logic);

end component f_Loc_1_Comb_SA_Diff_top;

component Neuron_top_level is
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
           
end component Neuron_top_level;


component weight_holder is
    Generic (weights_NO : NATURAL := 1;  -- the number of weights the weights holder need to hold
        weight_size_max : NATURAL := 1;         -- DO NOT CHANGE the weight size.                                                    
        weights_resolution : INTEGER := -6;     --They are not really selectable in the current design due to the limitatin of RNG.       
        Pre_spike_time_window : NATURAL := 10; 
        Post_spike_time_window : NATURAL := 10;
        Positive_amp : SFIXED := to_SFIXED(0.125, 1, -6);
        Negative_amp : SFIXED := to_SFIXED(0.125, 1, -6));
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           STDP_en : in STD_LOGIC;
           weight_rst : in STD_LOGIC;
           Pre_spikes : in STD_LOGIC_VECTOR (0 to weights_NO - 1);
           Post_spike : in STD_LOGIC;
           --weights_in : in STD_LOGIC;
           --weights_load : in STD_LOGIC;
           weights_out : out array_2d_SFIXED (0 to weights_NO - 1)(1 downto weights_resolution));
           --weight_out : out STD_LOGIC);
end component weight_holder;


component Dendrites_group is
    -- This entity contains 4 dendrites, and it will asign spikes and weights to each dendrite.
    -- It will then collect teh output potential from dendrites and add them together as the output.
    Generic ( dendrite_NO : NATURAL := 50;
              weight_size_max : NATURAL := 1;
              weight_size_min : integer := -6);
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           rst : in STD_LOGIC;
           Spikes_in : in STD_LOGIC_VECTOR (0 to dendrite_NO - 1);
           weights : in array_2d_SFIXED (0 to dendrite_NO - 1)(weight_size_max downto weight_size_min);
           EPSP : out SFIXED ((log2(NATURAL(2**weight_size_max * dendrite_NO))) downto weight_size_min));
end component Dendrites_group;

component Dendrite is
    Generic ( weight_size_max : NATURAL := 1;
              weight_size_min : integer := -6);
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           rst : in STD_LOGIC;
           Spike_in : in STD_LOGIC;
           weight : in SFIXED (weight_size_max downto weight_size_min); -- This gives a maximum 8 weight with a decimal resolution 0.015625
           potential_out : out SFIXED (weight_size_max downto weight_size_min));
end component Dendrite;

component Soma is
    --The Membrane Potential the Neuron will start at, reset to, charge up to, and leak down to. 
    Generic (Resting_potential : NATURAL := 5; 
    -- The Membrane Potential the neuron drops to after firing, entering a refractory state where
    -- incoming spikes do not effect the potential. It will recharge from here to Refract_potential_end
    -- at the Recharge_rate; this creates a psedo-counter that determines the length of the refractory 
    -- period in clock cycles. 
    Refract_potential_start : NATURAL := 0;
    -- The Mamebrane potential the neuron must charge to in it's refractory period in order to exit it's
    -- refractory state.
    Refract_potential_end : NATURAL := 5;
    -- The Membrane Potential the neuron must reach in order to fire a spike
    thredhold_potential : NATURAL := 30;
    -- The quantity the membrane potentaial loses eith each clock cycle that the Membrane Potential
    -- is above the resting potential 
    Leaky_rate : SFIXED := to_SFIXED(0.2, 3, -6);
    Recharge_rate : SFIXED := to_SFIXED(0.2, 3, -6);
    -- The quantity the membrane potentaial gains eith each clock cycle that the Membrane Potential
    -- is below the resting potential 
    dendrite_NO : NATURAL := 12;     
    weight_size_max : NATURAL := 3;  
    weight_size_min : integer := -6);
    
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           rst : in STD_LOGIC;
           EPSP : in SFIXED ((log2(NATURAL(2**weight_size_max * dendrite_NO))) downto weight_size_min);
           Spike_out : out STD_LOGIC);
end component Soma;

component  RandomNumberGenerator_generic is
    generic (output_NO : NATURAL := 7);
	port (	clk		: in	std_logic;
				enable	: in	std_logic;
				rst	: in	std_logic;
				dout : out array_2d_STD(0 to output_NO - 1)(7 downto 0));

end component RandomNumberGenerator_generic;

component paraCounter is
    generic (limit : NATURAL;
        rollover : boolean);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;  -- active-high reset
           en : in STD_LOGIC;   -- active-hight enable signal
           CNT : out STD_LOGIC_VECTOR (log2(limit)-1 downto 0));
           --output for the current state of the counter
           --log2(limit) is the bits of the limits in binary
end component paraCounter;

end micro_circuit_pkg;


