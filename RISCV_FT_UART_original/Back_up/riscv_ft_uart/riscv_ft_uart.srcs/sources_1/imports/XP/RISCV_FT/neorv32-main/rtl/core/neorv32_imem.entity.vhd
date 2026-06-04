-- #################################################################################################
-- # << NEORV32 - Processor-Internal Instruction Memory (IMEM) - Entity-Only >>                    #
-- # ********************************************************************************************* #
-- # BSD 3-Clause License                                                                          #
-- #                                                                                               #
-- # Copyright (c) 2023, Stephan Nolting. All rights reserved.                                     #
-- #                                                                                               #
-- # Redistribution and use in source and binary forms, with or without modification, are          #
-- # permitted provided that the following conditions are met:                                     #
-- #                                                                                               #
-- # 1. Redistributions of source code must retain the above copyright notice, this list of        #
-- #    conditions and the following disclaimer.                                                   #
-- #                                                                                               #
-- # 2. Redistributions in binary form must reproduce the above copyright notice, this list of     #
-- #    conditions and the following disclaimer in the documentation and/or other materials        #
-- #    provided with the distribution.                                                            #
-- #                                                                                               #
-- # 3. Neither the name of the copyright holder nor the names of its contributors may be used to  #
-- #    endorse or promote products derived from this software without specific prior written      #
-- #    permission.                                                                                #
-- #                                                                                               #
-- # THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS   #
-- # OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF               #
-- # MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE    #
-- # COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,     #
-- # EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE #
-- # GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED    #
-- # AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING     #
-- # NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED  #
-- # OF THE POSSIBILITY OF SUCH DAMAGE.                                                            #
-- # ********************************************************************************************* #
-- # The NEORV32 Processor - https://github.com/stnolting/neorv32              (c) Stephan Nolting #
-- #################################################################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library neorv32_ft_lib;
use neorv32_ft_lib.neorv32_ft_package.all;

entity neorv32_imem is
  generic (
    IMEM_BASE    : std_ulogic_vector(31 downto 0); -- memory base address
    IMEM_SIZE    : natural; -- processor-internal instruction memory size in bytes
    IMEM_AS_IROM : boolean;  -- implement IMEM as pre-initialized read-only memory?
    FAULT_INJ_SYNC_0 : boolean:= true;
    FAULT_INJ_SYNC_1 : boolean:= true;
    FAULT_INJ_SYNC_2 : boolean:= true;
    FAULT_INJ_SYNC_3 : boolean:= true;
    FAULT_INJ_SYNC_4 : boolean:= true;
    FAULT_INJ_SYNC_5 : boolean:= true; 
    FAULT_INJ_SYNC_6 : boolean:= true;
    FAULT_INJ_SYNC_7 : boolean:= true
  );
  port (
    clk_i  : in  std_ulogic; -- global clock line
    rstn_i : in std_logic;
    rden_i : in  std_ulogic; -- read enable
    wren_i : in  std_ulogic; -- write enable
    ben_i  : in  std_ulogic_vector(03 downto 0); -- byte write enable
    addr_i : in  std_ulogic_vector(31 downto 0); -- address
    data_i : in  std_ulogic_vector(31 downto 0); -- data in
    data_o : out std_ulogic_vector(31 downto 0); -- data out
    ack_o  : out std_ulogic; -- transfer acknowledge
    err_o  : out std_ulogic;  -- transfer error
    fault_inj_trig_sync_0_7_i : in std_logic_vector (7 downto 0); -- fault injection trigget
    fault_inj_type_sync_0_7_i : in sync_fault_type_t; -- fault injection type selection
    fault_status_sync_0_7_o : out std_logic_vector (7 downto 0)--fault detected status
  );
end neorv32_imem;
