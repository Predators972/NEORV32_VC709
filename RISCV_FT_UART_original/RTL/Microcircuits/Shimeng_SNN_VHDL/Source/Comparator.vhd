--declear libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Comparator is
    --This is a parameterizable synchronize comparator.
    --It will compare the number of Comp_in and Comp_NO, 
    --if Comp_in is larger than Random_NO, output becomes 1, else 0.
    generic (Data_size : NATURAL := 8);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           Comp_in : in STD_LOGIC_VECTOR (Data_size - 1 downto 0); --The input signal needed to be encoded.
           Comp_NO : in STD_LOGIC_VECTOR (Data_size - 1 downto 0); --The number to be compared with
           Comp_out : out STD_LOGIC); --Result of comparison
end Comparator;

architecture Behavioral of Comparator is

signal Comp_out_int : STD_LOGIC; --the internal signal for Comp_out

begin
    
    comp : process(clk)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                Comp_out_int <= '0';
            elsif (Comp_in >= Comp_NO) then
                --If the input number is larger than the compare number, output 1
                Comp_out_int <= '1';
            else
                Comp_out_int <= '0';
            end if;
        end if;
    end process;
    Comp_out <= Comp_out_int; --Connect the internal signal to the port
end Behavioral;
