library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use work.array_type.ALL;

entity Encoder_vector_tb is

end Encoder_vector_tb;

architecture Behavioral of Encoder_vector_tb is

    signal clk : STD_LOGIC;
    signal rst : STD_LOGIC;
    signal en : STD_LOGIC;
    signal Sig : array_2d_STD (0 to 11)(7 downto 0);
    signal Encoded_sig : STD_LOGIC_VECTOR (0 to 11);
    type spike_NO_type is array (0 to 11) of real;
    signal spike_NO : spike_NO_type;
    signal spike_NO_ave : real;
    constant clk_period : time := 10ns;
    
begin
 clk_process : process
        begin
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end process;
        
    UUT : entity work.Encoder_vector
        port map (clk => clk,
            rst => rst,
            en => en,
            Sig => Sig,
            Encoded_sig => Encoded_sig);
    
    test_process : process
    begin
        --global reset and initial reset
        wait for 100ns;
        rst <= '1';
        wait for clk_period;
        rst <= '0';
        
        --start encoding
        en <= '1';
        spike_NO <= (others => 0.0);
        wait for clk_period*200;
        --give input number to encode 
        
                    

        
        for i in 0 to 255 loop
            spike_NO <= (others => 0.0);
            
            
            wait for clk_period*1;
            for j in 0 to 2559 loop
                for k in 0 to 11 loop
                    Sig(k) <= STD_LOGIC_VECTOR(to_UNSIGNED(i, 8));
                    if (Encoded_sig(k) = '1') then
                        spike_NO(k) <= spike_NO(k) + 1.0;
                    end if;
                end loop;

                wait for clk_period;
            end loop;
            Spike_NO_ave <= 0.0;
            wait for clk_period;
            for i in 0 to 11 loop
                Spike_NO_ave <= Spike_NO(i) + Spike_NO_ave;
                wait for clk_period;
            end loop;
            Spike_NO_ave <= ceil(Spike_NO_ave/120);
            wait for clk_period;
        end loop;
       
        wait; --wait forever
    end process;
    

       

end Behavioral;
