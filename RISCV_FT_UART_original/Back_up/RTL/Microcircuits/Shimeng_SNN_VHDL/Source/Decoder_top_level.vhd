library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.DigEng.all;

entity Decoder_top_level is
    Generic (decode_period : NATURAL := 1); -- This determine how many 256 clk cycles the decoder
                                             -- will collect spikes before output the decoded signal 
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           spike : in STD_LOGIC; -- input spikes to be decoded
           sig_decoded : out STD_LOGIC_VECTOR (7 downto 0));
end Decoder_top_level;

architecture Behavioral of Decoder_top_level is

signal spike_NO : UNSIGNED(log2(256*decode_period)-1 downto 0); -- This signal records the number of spikes in this decode period
signal clk_NO : UNSIGNED(log2(decode_period*256)-1 downto 0); -- This signal records the number of clk cycles passed in this decode period
                                                                -- and will be used for check if the current decode period is finished
signal sig_decoded_int : UNSIGNED(log2(256*decode_period)-1 downto 0); --internal siganl for output port sig_decoded
signal spike_CNT_rst : STD_LOGIC; -- The reset signal for the spike counter
signal decode_period_end : STD_LOGIC; -- If the current decode period finished, go to 1, else 0

begin
    spike_CNT_rst <= rst or decode_period_end; -- The spike counter need to be reset both by the reset signal and when 
                                               -- when the current decode period finished.
    sig_decoded <= STD_LOGIC_VECTOR(sig_decoded_int(7 downto 0));
    spike_CNT : entity work.paraCounter
        -- This counter will record the number of spikes comming in.
        -- And it will be reset after a decode period is finished to recording spikes for next output signal 
        -- Rollover function is disabled here to avoid decoded signal get back to 0 when spikes overflowed (though it's 
        -- impossible as long as the clk counter is working proporly...)
        Generic map(limit => 256*decode_period,
            rollover => false)
        Port map (clk => clk,
            rst => spike_CNT_rst,
            en => spike,
            UNSIGNED(CNT) => spike_NO);
    
    clk_CNT : entity work.paraCounter
        -- This counter will count how many clk cycle passed. combined with the followed comparator, they work like a 
        -- delay, when the counter reaches the maximum, a decode period finished
        -- rollover function is enabled so it could automaticly count for next decode period.
        Generic map(limit => 256*decode_period-1,
            rollover => true)
        Port map (clk => clk,
            rst => rst,
            en => en,
            UNSIGNED(CNT) => clk_NO);
            
    decode_period_comp : entity work.paraComparator
        Generic map (limit => 256*decode_period-1)
        Port map (compIn => STD_LOGIC_VECTOR(clk_NO),
            compOut => decode_period_end);
    
    decode : process (clk)
    begin   
        if rising_edge(clk) then
            if (rst = '1') then
                sig_decoded_int <= (others => '0');
            elsif (en = '1') then
                if (decode_period_end = '1') then
                    -- When a decode period finished, output the decoded value. 
                    sig_decoded_int <= (spike_NO / decode_period);
                end if;
            end if;
        end if;
    end process;
    
end Behavioral;
