
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library micro_ckt_pkg_lib;
use micro_ckt_pkg_lib.DigEng.all;

entity paraCounter is
    generic (limit : NATURAL;
        rollover : boolean);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;  -- active-high reset
           en : in STD_LOGIC;   -- active-hight enable signal
           CNT : out STD_LOGIC_VECTOR (log2(limit)-1 downto 0));
           --output for the current state of the counter
           --log2(limit) is the bits of the limits in binary
end paraCounter;

architecture Behavioral of paraCounter is
    signal CNTint : UNSIGNED(log2(limit)-1 downto 0);
    --set a internal signal for the CNT
    --as the output cannot be directly change
    
    attribute keep : boolean;
    attribute keep of CNTint : signal is true;
begin
    counter: process (clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                CNTint <= (others => '0');
            else
                if (en = '1') then
                   if ((CNTint < limit)) then
                    CNTint <= CNTint + 1;
                   elsif ((CNTint = limit) and (rollover = false)) then
                    -- Stay at the maximum
                    CNTint <= CNTint; 
                   else
                    -- Rollover
                    CNTint <= (others => '0');
                   end if;
               end if;
            end if; 
        end if;
    end process counter;
    CNT <= STD_LOGIC_VECTOR(CNTint);
end Behavioral;
