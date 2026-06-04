----------------------------------------------------------------------------------
-- Company: Ulster University
-- Engineer: Nidhin Thandassery Sumithran
-- 
-- Create Date: 27.11.2023 20:36:47
-- Design Name: Microcircuit Wrapper Module
-- Module Name: microcircuit_wrapper - Behavioral
-- Project Name: Nervous Systems
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
library micro_ckt_lib;
use micro_ckt_lib. micro_circuit_pkg.all;


entity microcircuit_wrapper is
Port (
  in_comb_fault_status  : in std_logic_vector (23 downto 0);
  in_sync_fault_status  : in std_logic_vector (23 downto 0);
  out_spike_comb        : out std_logic_vector (5 downto 0);
  out_spike_sync        : out std_logic_vector (5 downto 0);
  clk_in                : in std_logic;
  reset_in              : in std_logic 
   );
end microcircuit_wrapper;

architecture Behavioral of microcircuit_wrapper is
signal en : std_logic :='0';
signal sig_spike_in : std_logic_vector(0 to 7);
signal Sig_spikes_out : std_logic_vector(5 downto 0);
signal STDP_en : std_logic;
signal weight_rst : std_logic;

attribute keep : boolean;
attribute keep of Sig_spikes_out : signal is true;
attribute keep of sig_spike_in : signal is true;
begin

en <= '1';

out_spike_comb <= Sig_spikes_out;
sig_spike_in <= in_comb_fault_status (0) & in_comb_fault_status (1) & in_comb_fault_status (2) & in_comb_fault_status (3)
 & in_comb_fault_status (4) & in_comb_fault_status (5) & in_comb_fault_status (6) & in_comb_fault_status (7);

 loc1_comb: f_Loc_1_Comb_SA_Diff_top
 
 generic map (
 dendrite_NO  => 11,
 neuron_NO    => 14
 )
 port map (
    clk         => clk_in, 
    rst         => reset_in, 
    en          => en,
    Spike_in    => sig_spike_in,
    Spikes_out  => Sig_spikes_out (1 downto 0),
    STDP_en     => '0',
    weight_rst  => '0'
    
    );
    
 loc2_comb: f_Loc_1_Comb_SA_Diff_top
 
 generic map (
 dendrite_NO  => 11,
 neuron_NO    => 14
 )
 port map (
    clk         => clk_in, 
    rst         => reset_in, 
    en          => en,
    Spike_in    => sig_spike_in,
    Spikes_out  => Sig_spikes_out (3 downto 2),
    STDP_en     => '0',
    weight_rst  => '0'
    
    );

loc3_comb: f_Loc_1_Comb_SA_Diff_top
 
 generic map (
 dendrite_NO  => 11,
 neuron_NO    => 14
 )
 port map (
    clk         => clk_in, 
    rst         => reset_in, 
    en          => en,
    Spike_in    => sig_spike_in,
    Spikes_out  => Sig_spikes_out (5 downto 4),
    STDP_en     => '0',
    weight_rst  => '0'
    
    );

end Behavioral;
