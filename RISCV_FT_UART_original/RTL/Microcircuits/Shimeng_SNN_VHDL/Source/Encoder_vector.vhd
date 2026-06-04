library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.array_type.ALL;

entity Encoder_vector is
    Generic (Encoder_NO : NATURAL := 8);
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           rst : in STD_LOGIC;
           Sig : in array_2d_STD (0 to (Encoder_NO - 1))(7 downto 0);
           Encoded_sig : out STD_LOGIC_VECTOR (0 to (Encoder_NO - 1)));
end Encoder_vector;

architecture Behavioral of Encoder_vector is

Constant mask_array : array_2d_STD (0 to 7)(7 downto 0) := ("11101001","01101011","10001001","10011011",
                                                            "11010010","10011111","00101101","10010110");
                                                            --"01111100","10001011","10110010","00111110");


begin


    Encoder_vector : for i in 0 to Encoder_NO - 1 generate
        Encoder : entity work.Encoder_top_level 
            Generic map (mask => mask_array(i))
            Port map (clk => clk,
                      en => en,
                      rst => rst,
                      Sig => Sig(i),
                      Encoded_sig => Encoded_sig(i));
    end generate Encoder_vector;
    
end Behavioral;
