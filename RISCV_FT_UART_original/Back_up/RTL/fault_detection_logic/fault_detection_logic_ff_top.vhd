----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2023 10:41:07
-- Design Name: 
-- Module Name: fault_detection_logic_top - Behavioral
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
--library pkg_fault_det_lib;
--use pkg_fault_det_lib.pkg_fault_det_comp_lib.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library neorv32_ft_lib;
use neorv32_ft_lib.neorv32_ft_package.all;

entity fault_detection_logic_ff_top is
 generic (
    BUFFER_STAGES : natural := 48;
    ENABLE_SYNTHESIS: BOOLEAN := TRUE;
    DELAY : time:= 2ns
  );
Port ( in_source : in std_logic;
       in_destination: in std_logic;
       out_fault_status: out std_logic;
       clk : in std_logic;
       reset : in std_logic
       );
end fault_detection_logic_ff_top;

architecture Behavioral of fault_detection_logic_ff_top is
--signal sig_xor_1_out, sig_xor_2_out, sig_xor_3_out, sig_xor_4_out : std_logic;
/*signal sig_out_buffer_1_0, sig_out_buffer_0_1 : std_logic_vector( BUFFER_STAGES downto 0);*/
signal sig_and_out_1_0,  sig_and_out_0_1 : std_logic;
signal sig_or_out : std_logic;
signal sig_in_source, sig_in_destination : std_logic;
/*signal sig_temp_1, sig_temp_0 : std_logic;
signal sig_const_1 : std_logic := '1';
signal sig_const_0 : std_logic := '0';*/
signal sig_out_buffer_1, sig_out_buffer_2, sig_out_inverter_1, sig_out_inverter_2 : std_logic;

signal sig_dff_1_0_out, sig_dff_0_1_out : std_logic;
attribute keep : boolean;
attribute preserve : boolean;
/*attribute keep of sig_out_buffer_1_0 : signal is true;
attribute keep of sig_out_buffer_0_1 : signal is true;*/
attribute keep of sig_in_source : signal is true;
attribute keep of sig_in_destination : signal is true;

attribute preserve of sig_dff_1_0_out : signal is true;
attribute preserve of sig_dff_0_1_out : signal is true;

attribute keep of sig_out_buffer_1 : signal is true;
attribute keep of sig_out_buffer_2 : signal is true;
attribute keep of sig_out_inverter_1 : signal is true;
attribute keep of sig_out_inverter_2 : signal is true;

attribute keep of sig_and_out_1_0 : signal is true;
attribute keep of sig_and_out_0_1 : signal is true;


begin

sig_in_source <= in_source;
sig_in_destination <= in_destination;

buffer_inst_1: buffer_module -- replaced xor gate with one of the input always tied to '0'
generic map (
ENABLE_SYNTHESIS => ENABLE_SYNTHESIS,
DELAY => DELAY
)
port map (
    in_buf => sig_in_source,
    out_buf => sig_out_buffer_1 
 );

inverter_inst_1: not_gate -- replaced xor gate with one of the input always tied to '1'
generic map (
    ENABLE_SYNTHESIS => ENABLE_SYNTHESIS
  )
port map(
	in_not => sig_in_destination,
    out_not => sig_out_inverter_1
);


buffer_inst_2: buffer_module
generic map (
ENABLE_SYNTHESIS => ENABLE_SYNTHESIS,
DELAY => DELAY
)
port map (
    in_buf => sig_in_destination,
    out_buf => sig_out_buffer_2 
 );

inverter_inst_2: not_gate
generic map(
    ENABLE_SYNTHESIS => ENABLE_SYNTHESIS,
    DELAY => DELAY
  )
port map(
	in_not => sig_in_source,
    out_not => sig_out_inverter_2
);

/*gen_buffer_for_1_0 : for i in 0 to BUFFER_STAGES-1 generate
buffer_inst_1_0: buffer_module
generic map (
ENABLE_SYNTHESIS => ENABLE_SYNTHESIS,
DELAY => DELAY
)
port map (
    in_buf => sig_out_buffer_1_0 (i),
    out_buf => sig_out_buffer_1_0 (i+1)
 );
end generate gen_buffer_for_1_0;

sig_out_buffer_1_0 (0) <= sig_out_buffer_1;*/

----DFF Instantiation---

d_ff_1_0_inst: d_flip_flop
 port map(
    clk => clk,
    reset=> reset,
    in_d => sig_out_buffer_1,
    out_q=> sig_dff_1_0_out
   );

and_gate_inst_1_0 : and_gate
generic map (
ENABLE_SYNTHESIS => ENABLE_SYNTHESIS
)
port map (
    in_1 => sig_dff_1_0_out, --sig_out_buffer_1_0 (BUFFER_STAGES),
    in_2 => sig_out_inverter_1,
    out_and => sig_and_out_1_0
);

/*gen_buffer_for_0_1 : for i in 0 to BUFFER_STAGES-1 generate
buffer_inst_0_1: buffer_module
generic map (
ENABLE_SYNTHESIS => ENABLE_SYNTHESIS,
DELAY => DELAY
)
port map (
    in_buf => sig_out_buffer_0_1 (i),
    out_buf => sig_out_buffer_0_1 (i+1)
 );
end generate gen_buffer_for_0_1;

sig_out_buffer_0_1 (0) <= sig_out_inverter_2;*/

d_ff_0_1_inst: d_flip_flop
 port map(
    clk => clk,
    reset=> reset,
    in_d => sig_out_inverter_2,
    out_q=> sig_dff_0_1_out
   );

and_gate_inst_0_1 : and_gate
generic map (
ENABLE_SYNTHESIS => ENABLE_SYNTHESIS
)
port map (
    in_1 => sig_dff_0_1_out, --sig_out_buffer_0_1 (BUFFER_STAGES),
    in_2 => sig_out_buffer_2,
    out_and => sig_and_out_0_1
);

or_gate_inst : or_gate
generic map (
ENABLE_SYNTHESIS => ENABLE_SYNTHESIS
)
port map (
    in_1 => sig_and_out_1_0,
    in_2 => sig_and_out_0_1,
    out_or => sig_or_out
);

out_fault_status <= '1' WHEN sig_or_out ELSE '0';

end Behavioral;
