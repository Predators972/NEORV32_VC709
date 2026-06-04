use work.DigEng.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity paraComparator is
    generic (limit : NATURAL); --This is this the number
                                -- that the input signal will 
                                --be compared with
    Port ( compIn : in STD_LOGIC_VECTOR (log2(limit)-1 downto 0); 
           -- parallel data in of comparator
           compOut : out STD_LOGIC); 
           -- serial data out of comparator
end paraComparator;

architecture Behavioral of paraComparator is
    signal compOutInt :STD_LOGIC; --the internal signal of the output
begin
    -- convert the natural value to binary value for limit
    --limitBinary <= TO_UNSIGNED(limit, log2(limit));
    -- when input value euqal limit-1, the comparator will send '1'
    compOutInt <= '1' when unsigned(compIn) = limit else '0';
    
    compOut <= compOutInt;
    
end Behavioral;
