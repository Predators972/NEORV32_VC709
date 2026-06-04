-- Soma Model by J.Richardson: Summer 2022 V.2.0
-- Based on original code by Shimeng Wu and Impliments the Membrane Potential Model by Iakymchuk et al;
-- as seen in the paper : 
-- "Simplified spiking neural network architecture and STDP learning algorithm applied to image classification"

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.all;
library micro_ckt_pkg_lib;
use micro_ckt_pkg_lib.DigEng.all;


entity Soma is
    --The Membrane Potential the Neuron will start at, reset to, charge up to, and leak down to. 
    Generic (Resting_potential : NATURAL := 0; 
    -- The Membrane Potential the neuron drops to after firing, entering a refractory state where
    -- incoming spikes do not effect the potential. It will recharge from here to Refract_potential_end
    -- at the Recharge_rate; this creates a psedo-counter that determines the length of the refractory 
    -- period in clock cycles. 
    Refract_potential_start : NATURAL := 0;
    -- The Mamebrane potential the neuron must charge to in it's refractory period in order to exit it's
    -- refractory state.
    Refract_potential_end : NATURAL := 0;
    -- The Membrane Potential the neuron must reach in order to fire a spike
    thredhold_potential : NATURAL := 1;
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
end Soma;

architecture Behavioral of Soma is

signal EPSP_int : SFIXED ((log2(NATURAL(2**weight_size_max * dendrite_NO))) downto weight_size_min);
signal MP : SFIXED (log2(Thredhold_potential) + 1 downto weight_size_min); -- Membrane Potential
signal Refract : boolean;
signal fire : boolean;
signal Spike_out_int : STD_LOGIC;

attribute keep: boolean;
attribute keep of MP : signal is true;
attribute keep of Spike_out_int : signal is true;
attribute keep of EPSP_int : signal is true;
attribute keep of Refract : signal is true;

attribute mark_debug : string;
attribute MARK_DEBUG of MP : signal is "TRUE";
attribute MARK_DEBUG of Spike_out_int : signal is "TRUE";
attribute MARK_DEBUG of EPSP_int : signal is "TRUE";
attribute MARK_DEBUG of Refract : signal is "TRUE";

begin   
    EPSP_int <= EPSP;
    Soma : process (clk)
    begin
        -- Sync to Clock Edge
        if rising_edge(clk) then
            -- Perform Reset if rst is enabled
            if (rst = '1') then
                -- Resets to resting Potential By default
                MP <= to_SFIXED(Resting_potential, log2(Thredhold_potential) + 1, weight_size_min);
                Refract <= False;
                fire <= False;
                Spike_out_int <= '0';
            elsif (en = '1') then
 
                -- When MP is below thredhold potential and above resting potential, and not in refract state, 
                -- incoming spikes have effect and MP leaks to resting.
                if ((MP < thredhold_potential) and (MP > Resting_potential) and (Refract = false)) then
                -- NEW CODE START--  
                -- New code prevents MP leak from overshooting Resting_potential
                   -- Check for overshoot only operates if no spikes are coming in
                   if (EPSP_int = (EPSP_int'range => '0')) then 
                      -- Checks if difference between MP and Resting_potential is less than Leaky_rate
                      if((MP-Resting_potential)< Leaky_rate) then
                         -- If less than Leaky_rate, MP only leaks by difference
                         MP <= to_SFIXED(Resting_potential, log2(Thredhold_potential) + 1, weight_size_min);
                      elsif ((MP-Resting_potential)>= Leaky_rate) then
                         MP <= resize(arg => MP - Leaky_rate, size_res => MP);
                      end if;
                   else  
                      MP <= resize(arg => MP + EPSP_int - Leaky_rate, size_res => MP);
                   end if;
                -- NEW CODE END--   
                     
                -- When MP is below thredhold potential and below resting potential, and not in refract state, 
                -- incoming spikes have effect and MP recharges to resting.
                elsif ((MP < thredhold_potential) and (MP < Resting_potential) and (Refract = false)) then               
                -- NEW CODE START--
                -- New code prevents MP charge from overshooting Resting_potential
                   -- Check for overshoot only operates if no spikes are coming in
                   if (EPSP_int = (EPSP_int'range => '0')) then 
                      -- Checks if difference between MP and Resting_potential is less than Recharge_rate
                      if((Resting_potential-MP)< Recharge_rate) then
                         -- If less than Recharge_rate, MP only charges by difference
                         MP <= to_SFIXED(Resting_potential, log2(Thredhold_potential) + 1, weight_size_min);
                      elsif ((Resting_potential-MP)>= Recharge_rate) then
                         -- If more, recharge by Recharge_rate
                         MP <= resize(arg => MP + Recharge_rate, size_res => MP);
                      end if;
                   else  
                      -- If spikes are incoming, normal recharge behaviour
                      MP <= resize(arg => MP + EPSP_int + Recharge_rate, size_res => MP);
                   end if;
                -- NEW CODE END--              
                
                -- When MP is below thredhold potential and equal to resting potential, and not in refract state, 
                -- incoming spikes have effect and MP sits at resting.    
                elsif ((MP < thredhold_potential) and (MP = Resting_potential) and (Refract = false)) then
                        MP <= resize(arg => MP + EPSP_int, size_res => MP);     
                           
                -- When MP exceed thredhold potential, fire a spike and get into refract state.
                -- Also set the MP to the refract potential
                elsif (MP >= thredhold_potential) and Refract = false then
                    MP <= to_SFIXED(Refract_potential_start, log2(Thredhold_potential) + 1, weight_size_min);
                    -- Refract <= true;
                    fire <= true;

                -- When in refractory state, two MP levels are used to make a pseudo-counter;
                -- Refract_potential_start and Refract_potential_end.
                -- The difference between the Refract_potential_start & Refract_potential_end, over 
                -- the Recharge_rate determines the refactory time in clock cycles.                    
                elsif ((MP < Refract_potential_end) and (Refract = true)) then
                    MP <= resize(arg => MP + 1, size_res => MP);
                    -- Recharging completed, refract period finished, exit refract state. 
                    if resize(arg => MP + 1, size_res => MP) = Refract_potential_end then              
                        Refract <= false;                                                 
                    end if;                                                               
                end if; 
                
                -- fire a spike if signal fire is true.
                if (fire = true) then
                    Spike_out_int <= '1';
                    fire <= false;
                else 
                    Spike_out_int <= '0';
                end if;
            end if;
        end if;
    end process;
                    
    Spike_out <= Spike_out_int;
    
end Behavioral;










