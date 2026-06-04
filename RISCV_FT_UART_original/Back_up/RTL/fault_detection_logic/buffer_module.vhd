----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.02.2023 
-- Design Name: 
-- Module Name: buffer_inference - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity buffer_module is
generic (
    ENABLE_SYNTHESIS: BOOLEAN := TRUE;
    DELAY : time:= 0ns
  );
port (
    in_buf : in std_logic;
    out_buf : out std_logic
  );
end buffer_module;

architecture Behavioral of buffer_module is

signal sig_in_buf : std_logic:= '0';
signal sig_out_buf : std_logic;
attribute keep : boolean;
attribute keep of sig_in_buf : signal is true;
attribute keep of sig_out_buf : signal is true;


begin

buffer_synthesis :if ENABLE_SYNTHESIS=TRUE generate    
begin

  sig_in_buf <= in_buf;
  process (sig_in_buf)
  begin
     sig_out_buf <= sig_in_buf;
  end process;
  
  out_buf <= sig_out_buf;
--    /*BUFG_inst : BUFG
--    port map (
--        O => sig_out_buf,
--        I => sig_in_buf  
--    );*/
    
end generate;

buffer_simulation: if ENABLE_SYNTHESIS=FALSE generate
--    /*BUFG_inst : BUFG
--    port map (
--        O => out_buf,
--        I => in_buf  
--    );*/
    --wait for delay_time;
    out_buf <= in_buf after DELAY;
end generate;

end Behavioral;

