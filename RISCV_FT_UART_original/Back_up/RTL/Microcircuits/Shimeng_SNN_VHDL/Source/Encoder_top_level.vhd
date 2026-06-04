--Declare libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Encoder_top_level is
    Generic (mask : STD_LOGIC_VECTOR := "11111111");
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           Sig : in STD_LOGIC_VECTOR (7 downto 0); -- Signal to be encoded
           Encoded_sig : out STD_LOGIC); -- encoded signal (spikes)
end Encoder_top_level;

architecture Behavioral of Encoder_top_level is

signal random_NO : STD_LOGIC_VECTOR (7 downto 0);

begin
    firer : entity work.comparator
    -- This firer is a comparator, it will fire a spike if the signal to be encoded
    -- is larger than a random number.
    -- Since the Sig is fixed at 8 bits, same as the default data size of the comparator,
    -- so no generic map needed here.
        port map(clk => clk,
            rst => rst,
            Comp_in => Sig,
            Comp_NO => random_NO xor mask,
            Comp_out => Encoded_sig);
            
    RNG : entity work.RandomNumberGenerator_generic
    -- This random number generator will generate a 8 bits random number every 
    -- clock cycle.
        Generic map (output_NO => 1)
        Port map (clk => clk,
            enable => en,
            rst => rst,
            dOut(0) => random_NO);

end Behavioral;
















