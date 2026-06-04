library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.fixed_pkg.all;
library micro_ckt_pkg_lib;
use micro_ckt_pkg_lib.array_type.all;
use micro_ckt_pkg_lib.DigEng.all;

library micro_ckt_lib;
use micro_ckt_lib. micro_circuit_pkg.all;


entity Dendrites_group is
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
end Dendrites_group;

architecture Behavioral of Dendrites_group is

-- signals for convenience of generating dendrites.
signal Dendrites_output : array_2d_SFIXED (0 to dendrite_NO - 1)(weight_size_max downto weight_size_min);
signal EPSP_sum_intermediate : array_2d_SFIXED (0 to dendrite_NO - 2)((log2(NATURAL(2**weight_size_max * dendrite_NO))) downto weight_size_min); -- intermediate signal for multiple input sum operation




begin
    
    Dendrites : for i in 0 to (dendrite_NO - 1) generate
        Dendrite_inst : Dendrite
            Port map (clk => clk,
                en => en,
                rst => rst,
                Spike_in => Spikes_in(i),
                weight => weights(i),
                potential_out => Dendrites_output(i));
    end generate;
    
    group_check : process(EPSP_sum_intermediate, Dendrites_output)
    begin
        if dendrite_NO = 1 then
            EPSP <= Dendrites_output(0);
            
        else
            EPSP_sum_intermediate(0) <= resize(arg => Dendrites_output(0) + Dendrites_Output(1), size_res => EPSP_sum_intermediate(0));
                                        
            EPSP_summor : for i in 1 to (dendrite_NO - 2) loop
                EPSP_sum_intermediate(i) <= resize(arg => EPSP_sum_intermediate(i-1) + Dendrites_output(i+1), size_res => EPSP_sum_intermediate(i));
            end loop; 
            
            EPSP <= EPSP_sum_intermediate(dendrite_NO - 2);
        end if;
    end process;
     
end Behavioral;









