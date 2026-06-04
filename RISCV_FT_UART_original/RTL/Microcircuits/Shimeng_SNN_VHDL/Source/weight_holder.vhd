library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use IEEE.math_real.ALL;
library micro_ckt_pkg_lib;
use micro_ckt_pkg_lib.array_type.all;
use micro_ckt_pkg_lib.DigEng.all;
library micro_ckt_lib;
use micro_ckt_lib. micro_circuit_pkg.all;

entity weight_holder is
    Generic (weights_NO : NATURAL := 1;  -- the number of weights the weights holder need to hold
        weight_size_max : NATURAL := 1;         -- DO NOT CHANGE the weight size.                                                    
        weights_resolution : INTEGER := -6;     --They are not really selectable in the current design due to the limitatin of RNG.       
        Pre_spike_time_window : NATURAL := 10; 
        Post_spike_time_window : NATURAL := 10;
        Positive_amp : SFIXED := to_SFIXED(0.125, 1, -6);
        Negative_amp : SFIXED := to_SFIXED(0.125, 1, -6));
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           STDP_en : in STD_LOGIC;
           weight_rst : in STD_LOGIC;
           Pre_spikes : in STD_LOGIC_VECTOR (0 to weights_NO - 1);
           Post_spike : in STD_LOGIC;
           --weights_in : in STD_LOGIC;
           --weights_load : in STD_LOGIC;
           weights_out : out array_2d_SFIXED (0 to weights_NO - 1)(1 downto weights_resolution));
           --weight_out : out STD_LOGIC);
end weight_holder;

architecture Behavioral of weight_holder is

signal Pre_spikes_last : STD_LOGIC_VECTOR(0 to weights_NO - 1);  -- signal for store the previous spike pattern for the behaviour of STDP

--internal signals for weights
signal weights_int : array_2d_SFIXED(0 to weights_NO - 1)(1 downto weights_resolution);

--RNG control signal and output
signal RNG_en : STD_LOGIC_VECTOR (0 to ((weights_NO - 1) / 8));
signal RNG_en_CNT : UNSIGNED (log2(((weights_NO - 1) / 8)) downto 0);
signal RNG_out : array_2d_STD(0 to (((weights_NO/8)+1)*8)-1)(7 downto 0);

-- STDP related signals
signal Pre_spike_CNT_en : STD_LOGIC_VECTOR (0 to weights_NO - 1);
signal Pre_spike_CNT_rst : STD_LOGIC_VECTOR (0 to weights_NO - 1);
signal Pre_spike_CNT_rst_port : STD_LOGIC_VECTOR (0 to weights_NO - 1); -- the reset signal actually get into CNTs need to be triggered by either the Pre_spike_CNT_rst or the reset input of the toplevel
signal Pre_spike_CNT_out : array_2d_UNSIGNED (0 to weights_NO - 1)(log2(Pre_spike_time_window) - 1 downto 0);
    
signal Post_spike_CNT_en : STD_LOGIC_VECTOR (0 to weights_NO - 1);
signal Post_spike_CNT_rst : STD_LOGIC_VECTOR (0 to weights_NO - 1);
signal Post_spike_CNT_rst_port : STD_LOGIC_VECTOR (0 to weights_NO - 1);
signal Post_spike_CNT_out : array_2d_UNSIGNED (0 to weights_NO - 1)(log2(Post_spike_time_window) - 1 downto 0); 

signal delta_weight : array_2d_SFIXED (0 to weights_NO - 1)(1 downto weights_resolution);

-- functions 
function find_delta_weight(Positive_amp : SFIXED; Negative_amp : SFIXED; Pre_spike_time_window : NATURAL; Post_spike_time_window : NATURAL; delta_time : SIGNED; Neg_pos : STD_LOGIC) return SFIXED is
    variable delta_weight : SFIXED (1 downto weights_resolution);
    begin
        if (Neg_pos = '1') then
            delta_weight := resize(arg => (Positive_amp/(to_SFIXED(delta_time, log2(Post_spike_time_window) - 1, weights_resolution) + 1)),size_res => delta_weight);
        elsif (Neg_pos = '0') then
            delta_weight := resize(arg => (Negative_amp/(to_SFIXED(-delta_time, log2(Pre_spike_time_window) - 1, weights_resolution) - 1)),size_res => delta_weight);
        end if;
    return delta_weight;
end function;

attribute keep: boolean;
attribute keep of weights_int : signal is true;

begin     

    RNG_generate : for i in 0 to (((weights_NO - 1) / 8)) generate   
    
        RNG : RandomNumberGenerator_generic
        -- This RNG is used for randomly initialize weights
        generic map (output_NO => 8)
        port map (clk => clk,
            enable => RNG_en(i), --always on
            rst => rst,
            dOut => RNG_out((i*8) to (((i+1)*8) - 1)));
            
    end generate;
    
    RNG_initiate : process(clk)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                RNG_en <= (others => '0');
                RNG_en_CNT <= to_UNSIGNED(0, RNG_en_CNT);
            elsif ((RNG_en_CNT <= ((weights_NO - 1) / 8)) and (en = '1')) then
                RNG_en(to_INTEGER(RNG_en_CNT)) <= '1';
                if (RNG_en_CNT < (((weights_NO - 1) / 8))) then
                    RNG_en_CNT <= RNG_en_CNT + 1;
                end if;
            end if;
        end if;
    
    end process;
   

    Pre_spike_CNTs : for i in 0 to (weights_NO - 1) generate
        Pre_spike_CNT_rst_port(i) <= Pre_spike_CNT_rst(i) or rst;
        Pre_spike_CNT : paraCounter
        Generic map(limit => Pre_spike_time_window + 3,
            rollover => false)
        Port map (clk => clk, 
            rst => Pre_spike_CNT_rst_port(i),
            en => Pre_spike_CNT_en(i),
            UNSIGNED(CNT) => Pre_spike_CNT_out(i));
        
        Post_spike_CNT_rst_port (i) <= Post_spike_CNT_rst (i) or rst;
        Post_spike_CNT : entity work.paraCounter
        Generic map (limit => Post_spike_time_window,
            rollover => false)
        Port map (clk => clk,
            rst => Post_spike_CNT_rst_port(i),
            en => Post_spike_CNT_en(i),
            UNSIGNED(CNT) => Post_spike_CNT_out(i));
    end generate;
    
    STDP : process (clk)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                weights_int <= (others => (others => '0'));
                Pre_spike_CNT_en <= (others => '0');
                Pre_spike_CNT_rst <= (others => '0');
                Post_spike_CNT_en <= (others => '0');
                Post_spike_CNT_rst <= (others => '0');
                Pre_spikes_last <= (others => '0');
                delta_weight <= (others => (others=> '0'));
                
            elsif (weight_rst = '1') then
            
                -- initialize all weight with a random value between -1 and 1
                for i in 0 to (weights_NO - 1) loop
                    if RNG_out(i)(5 downto 0) = "000000" then
                        -- 1 or -1 or 0
                        if RNG_out(i)(6) = '0' then
                            weights_int(i) <= (others => '0');
                        else 
                            weights_int(i) <= SFIXED(RNG_out(i));
                        end if;
                     elsif RNG_out(i)(7) = '1' then  
                        --minus fraction
                        weights_int(i)(1) <= RNG_out(i)(7);
                        weights_int(i)(0) <= '1';
                        weights_int(i)(-1 downto -6) <= SFIXED(RNG_out(i)(5 downto 0));
                     else 
                        -- positive fraction
                        weights_int(i)(1) <= RNG_out(i)(7);
                        weights_int(i)(0) <= '0';
                        weights_int(i)(-1 downto -6) <= SFIXED(RNG_out(i)(5 downto 0));    
                     end if;
                end loop;    
                
                -- initialize all weight with a random value between 0 and 1, uncomment the following for loop and comment the previous for loop to active
                --for i in 0 to (weights_NO - 1) loop
                    --if RNG_out(i)(5 downto 0) = "000000" then
                        -- 1 or -1 or 0
                        --if RNG_out(i)(6) = '0' then
                            --weights_int(i) <= (others => '0');
                        --else 
                            --weights_int(i) <= "01000000"; --SFIXED(RNG_out(i));
                        --end if;
                     --elsif RNG_out(i)(7) = '1' then  
                        -- minus fraction
                        --weights_int(i)(1) <= RNG_out(i)(7);
                        --weights_int(i)(0) <= '1';
                        --weights_int(i)(-1 downto -6) <= SFIXED(RNG_out(i)(5 downto 0));
                    -- else 
                        -- positive fraction
                        --weights_int(i)(1) <= '0'; --RNG_out(i)(7);
                        --weights_int(i)(0) <= '0';
                       -- weights_int(i)(-1 downto -6) <= SFIXED(RNG_out(i)(5 downto 0));    
                     --end if;
                --end loop; 
                 
            end if;
            
            for i in 0 to (weights_NO - 1) loop
                weights_out(i) <= weights_int(i);
            end loop;
            
        end if;
    end process;

end Behavioral;
