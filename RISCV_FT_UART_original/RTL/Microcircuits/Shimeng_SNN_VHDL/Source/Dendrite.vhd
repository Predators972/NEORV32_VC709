library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.all;
library micro_ckt_pkg_lib;
use micro_ckt_pkg_lib.DigEng.all;

entity Dendrite is
    Generic ( weight_size_max : NATURAL := 1;
              weight_size_min : integer := -6);
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           rst : in STD_LOGIC;
           Spike_in : in STD_LOGIC;
           weight : in SFIXED (weight_size_max downto weight_size_min); -- This gives a maximum 8 weight with a decimal resolution 0.015625
           potential_out : out SFIXED (weight_size_max downto weight_size_min));
end Dendrite;

architecture Behavioral of Dendrite is

signal potential_out_int : SFIXED (weight_size_max downto weight_size_min);

begin

    potential_generator : process (clk)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                potential_out_int <= (others => '0');
            elsif (en = '1') then
                if (Spike_in = '1') then
                    -- When dendrite enabled and there is a spike comes in, 
                    -- output the weight of this synapse
                    potential_out_int <= weight;
                else
                    potential_out_int <= (others => '0');
                end if;
            else
                potential_out_int <= (others => '0');
            end if;
        end if;
    end process;
    
    potential_out <= potential_out_int;

end Behavioral;
