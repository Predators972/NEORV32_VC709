----------------------------------------------------------------------------------
-- Company: Ulster University
-- Engineer: Nidhin Thandassery Sumithran
-- 
-- Create Date: 02.06.2023 16:19:00
-- Design Name: 
-- Module Name: jtag_interface - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
library neorv32_ft_lib;
use neorv32_ft_lib.neorv32_ft_package.all;

entity jtag_interface is
Port ( 
    in_clk                  : in std_logic;
    in_rst_n                : in std_logic;
    in_rst_int_n            : in std_logic;
    ------fault status-----
    in_comb_fault_status    : in std_logic_vector (23 downto 0);--fault_status_comb_t;
    in_sync_fault_status    : in std_logic_vector (23 downto 0);--fault_status_sync_t
    in_clock_count          : in std_logic_vector (7 downto 0);
    -----configuration regusters--
    out_reset_control_reg   : out std_logic_vector (31 downto 0);
    out_fault_inj_ctrl_reg  : out std_logic_vector (31 downto 0);
    out_fault_inj_ctrl_reg_fp_sel : out std_logic_vector (31 downto 0);
    -------microcircuit status out----
    in_comb_microcircuit_status : in std_logic_vector (23 downto 0);
    in_sync_microcircuit_status : in std_logic_vector (23 downto 0);
    in_spike_comb           : out std_logic_vector (5 downto 0);
    in_spike_sync           : out std_logic_vector (5 downto 0)
);
end jtag_interface;

architecture Behavioral of jtag_interface is

type access_ctrl_state_t is (START_ST, SYNC_MEM_ACCESS,  COMB_MEM_ACCESS, COMB_MC_MEM_ACCESS, SYNC_MC_MEM_ACCESS, CTRL_REG_ACCESS);
signal access_ctrl_state : access_ctrl_state_t;

type fault_status_t is array (0 to 127) of std_logic_vector(31 downto 0);

signal mem_comb_fault_status  : fault_status_t;
signal mem_sync_fault_status  : fault_status_t; 
signal mem_comb_mc_spike_out  : fault_status_t;
signal mem_sync_mc_spike_out  : fault_status_t;

signal mem_comb_mc_fault_status  : fault_status_t;
signal mem_sync_mc_fault_status  : fault_status_t;
signal sync_status_write_en   : std_logic;  
signal comb_status_write_en   : std_logic;
signal comb_mc_status_write_en : std_logic;
signal sync_mc_status_write_en : std_logic;
signal reg_sync_update_count  : integer range 0 to 127; --std_logic_vector (7 downto 0);
signal reg_comb_update_count  : integer range 0 to 127; --std_logic_vector (7 downto 0);
signal reg_comb_mc_update_count : integer range 0 to 127;
signal reg_sync_mc_update_count : integer range 0 to 127;
signal sync_mem_access_flag   : std_logic;  
signal comb_mem_access_flag   : std_logic;
signal reg_sync_fault_status  : std_logic_vector (23 downto 0);
signal reg_comb_fault_status  : std_logic_vector (23 downto 0);
signal reg_spike_comb         : std_logic_vector (5 downto 0);
signal reg_spike_sync         : std_logic_vector (5 downto 0);
signal comb_mem_address       : integer range 0 to 127;
signal sync_mem_address       : integer range 0 to 127;

signal control_reg_address_wr : integer range 0 to 127;
signal control_reg_address_rd : integer range 0 to 127;
signal reg_sync_mem_address   : integer range 0 to 127;
signal reg_comb_mem_address   : integer range 0 to 127;
signal reg_sync_mc_mem_address   : integer range 0 to 127;
signal reg_comb_mc_mem_address   : integer range 0 to 127;
signal comb_mc_mem_address    : integer range 0 to 127;
signal sync_mc_mem_address    : integer range 0 to 127;
signal reg_clock_count        : std_logic_vector (7 downto 0);
signal reg_clock_count_d1     : std_logic_vector (7 downto 0);
signal reset_control_reg      : std_logic_vector (31 downto 0);
signal fault_inj_ctrl_reg     : std_logic_vector (31 downto 0);
signal fault_inj_ctrl_reg_fp_sel : std_logic_vector (31 downto 0);
-----jtag ip signals-------
signal m_axi_awaddr           : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal m_axi_awprot           : STD_LOGIC_VECTOR(2 DOWNTO 0);
signal m_axi_awvalid          : STD_LOGIC;
signal m_axi_awready          : STD_LOGIC;
signal m_axi_wdata            : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal m_axi_wstrb            : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal m_axi_wvalid           : STD_LOGIC;
signal m_axi_wready           : STD_LOGIC;
signal m_axi_bresp            : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal m_axi_bvalid           : STD_LOGIC;
signal m_axi_bready           : STD_LOGIC;
signal m_axi_araddr           : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal m_axi_arprot           : STD_LOGIC_VECTOR(2 DOWNTO 0);
signal m_axi_arvalid          : STD_LOGIC;
signal m_axi_arready          : STD_LOGIC;
signal m_axi_rdata            : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal m_axi_rresp            : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal m_axi_rvalid           : STD_LOGIC;
signal m_axi_rready           : STD_LOGIC;

signal sig_m_axi_awready      : std_logic;
signal sig_m_axi_wready       : std_logic;
signal sig_sync_xor_out       : std_logic;
signal sig_sync_or_out        : std_logic;
signal sig_comb_xor_out       : std_logic;
signal sig_comb_or_out        : std_logic;

---keep attribute used for hardware debugging purpose
attribute keep : boolean;
attribute keep of mem_comb_fault_status : signal is true;
attribute keep of mem_sync_fault_status : signal is true;
attribute keep of mem_comb_mc_spike_out : signal is true;
attribute keep of mem_sync_mc_spike_out : signal is true;

attribute keep of sync_status_write_en  : signal is true;
attribute keep of comb_status_write_en  : signal is true;
attribute keep of m_axi_arvalid         : signal is true;
attribute keep of m_axi_arready         : signal is true;
attribute keep of m_axi_rdata           : signal is true;
attribute keep of m_axi_rvalid          : signal is true;
attribute keep of m_axi_araddr          : signal is true;
attribute keep of m_axi_rready          : signal is true;
attribute keep of reg_clock_count       : signal is true;

attribute keep of m_axi_awready         : signal is true;
attribute keep of m_axi_wdata           : signal is true;
attribute keep of m_axi_wvalid          : signal is true;
attribute keep of m_axi_awaddr          : signal is true;
attribute keep of m_axi_wready          : signal is true;
attribute keep of reset_control_reg     : signal is true;
attribute keep of control_reg_address_wr   : signal is true;
attribute keep of control_reg_address_rd   : signal is true;
attribute keep of access_ctrl_state     : signal is true;
attribute keep of m_axi_awvalid         : signal is true;
attribute keep of fault_inj_ctrl_reg    : signal is true;
attribute keep of fault_inj_ctrl_reg_fp_sel : signal is true;
attribute keep of comb_mem_address      : signal is true;
attribute keep of sync_mem_address      : signal is true;
attribute keep of reg_sync_update_count : signal is true;
attribute keep of reg_comb_update_count : signal is true;
attribute keep of comb_mc_status_write_en : signal is true;
attribute keep of sync_mc_status_write_en : signal is true;


begin
out_reset_control_reg   <= reset_control_reg;    --: out std_logic_vector (31 downto 0);
out_fault_inj_ctrl_reg  <= fault_inj_ctrl_reg;   --: out std_logic_vector (31 downto 0)
out_fault_inj_ctrl_reg_fp_sel <= fault_inj_ctrl_reg_fp_sel;
    
------------- Begin INSTANTIATION  ----- 
jtag_axi_inst : jtag_axi_0
  PORT MAP (
    aclk          => in_clk,
    aresetn       => in_rst_n,
    m_axi_awaddr  => m_axi_awaddr,
    m_axi_awprot  => m_axi_awprot,
    m_axi_awvalid => m_axi_awvalid,
    m_axi_awready => m_axi_awready,
    m_axi_wdata   => m_axi_wdata,
    m_axi_wstrb   => m_axi_wstrb,
    m_axi_wvalid  => m_axi_wvalid,
    m_axi_wready  => m_axi_wready,
    m_axi_bresp   => m_axi_bresp,
    m_axi_bvalid  => m_axi_bvalid,
    m_axi_bready  => m_axi_bready,
    m_axi_araddr  => m_axi_araddr,
    m_axi_arprot  => m_axi_arprot,
    m_axi_arvalid => m_axi_arvalid,
    m_axi_arready => m_axi_arready,
    m_axi_rdata   => m_axi_rdata,
    m_axi_rresp   => m_axi_rresp,
    m_axi_rvalid  => m_axi_rvalid,
    m_axi_rready  => m_axi_rready
  );

  
 fault_status_check: process (in_clk, in_rst_int_n)
 begin
    if (in_rst_int_n = '0') then
        sync_status_write_en <= '0';
        comb_status_write_en <= '0';
        comb_mc_status_write_en <= '0';
        sync_mc_status_write_en <= '0';
        reg_sync_fault_status <= (others=> '0');
        reg_comb_fault_status <= (others=> '0');
        reg_spike_comb  <= (others=>'0');
        reg_spike_sync  <= (others=>'0');
        reg_clock_count <= (others=>'0');
        reg_clock_count_d1 <= (others=>'0');
    elsif rising_edge(in_clk) then  
        sync_status_write_en <= or in_sync_fault_status; ----set if any of the bit positions are '1'
        
        comb_status_write_en <= or in_comb_fault_status; ----set if any of the bit positions are '1'
        
        comb_mc_status_write_en <= or in_comb_microcircuit_status;
        sync_mc_status_write_en <= or in_sync_microcircuit_status;
        reg_sync_fault_status <= in_sync_fault_status;
        reg_comb_fault_status <= in_comb_fault_status;
        reg_spike_comb      <= in_spike_comb;
        reg_spike_sync      <= in_spike_sync;
        reg_clock_count <= in_clock_count;
        reg_clock_count_d1 <= reg_clock_count;
    end if;
end process;

---------memory address generation-----------------------
status_reg_update_count: process (in_clk, in_rst_int_n)
 begin
    if (in_rst_int_n = '0') then
        reg_sync_update_count <= 0;
        reg_comb_update_count <= 0;
     elsif rising_edge (in_clk) then 
        if sync_status_write_en = '1' then
            reg_sync_update_count <= reg_sync_update_count + 1;
        end if;
        if comb_status_write_en = '1' then
            reg_comb_update_count <= reg_comb_update_count + 1;
        end if;
        if comb_mc_status_write_en = '1' then
            reg_comb_mc_update_count <= reg_comb_mc_update_count + 1;
        end if;
        if sync_mc_status_write_en = '1' then
            reg_sync_mc_update_count <= reg_sync_mc_update_count + 1;
        end if;
     end if;
 end process;
 
----------write to memory sync as well as comb-------------
process (in_clk, in_rst_int_n)
begin
 if (in_rst_int_n = '0') then
    mem_sync_fault_status <= (others => (others => '0'));
    mem_comb_fault_status <= (others => (others => '0'));
    mem_comb_mc_spike_out <= (others => (others => '0'));
    mem_sync_mc_spike_out <= (others => (others => '0'));
    
 elsif rising_edge (in_clk) then
    if sync_status_write_en then 
        mem_sync_fault_status (reg_sync_update_count ) <= reg_clock_count_d1 & reg_sync_fault_status;
    else 
        mem_sync_fault_status <= mem_sync_fault_status;
    end if;
    if comb_status_write_en then 
        mem_comb_fault_status (reg_comb_update_count) <= reg_clock_count_d1 & reg_comb_fault_status;
     else
        mem_comb_fault_status <= mem_comb_fault_status;
    end if;
    
    if comb_mc_status_write_en then
      mem_comb_mc_spike_out (reg_comb_mc_update_count) <= reg_clock_count_d1 & "000000000000000000" & reg_spike_comb;
    else 
      mem_comb_mc_spike_out <= mem_comb_mc_spike_out;
    end if;
    
    if sync_mc_status_write_en then
      mem_sync_mc_spike_out (reg_sync_mc_update_count) <= reg_clock_count_d1 & "000000000000000000" & reg_spike_sync;
    else 
      mem_sync_mc_spike_out <= mem_sync_mc_spike_out;
    end if; 
      
 end if;
end process;

---------------------jtag axi read control-----------------------------------------------

m_axi_arready <= m_axi_arvalid;

comb_mem_address <= to_integer(unsigned (m_axi_araddr (7 downto 0))) when  ((to_integer(unsigned (m_axi_araddr (9 downto 0))) >= 128) and  (to_integer(unsigned(m_axi_araddr (9 downto 0))) <= 255)) else 0;
sync_mem_address <= to_integer(unsigned (m_axi_araddr (7 downto 0))) when  (to_integer(unsigned (m_axi_araddr (9 downto 0))) < 128) else 0 ;
----comb micro circuit spike memory uses 264 to 383 address space in the memory; 120 address locations; 256 to 263 is reserved for control registers
comb_mc_mem_address <= to_integer(unsigned (m_axi_araddr (7 downto 0))) when  ((to_integer(unsigned (m_axi_araddr (9 downto 0))) >= 264) and  (to_integer(unsigned(m_axi_araddr (9 downto 0))) <= 383)) else 0;
sync_mc_mem_address <= to_integer(unsigned (m_axi_araddr (7 downto 0))) when  ((to_integer(unsigned (m_axi_araddr (9 downto 0))) >= 384) and  (to_integer(unsigned(m_axi_araddr (9 downto 0))) <= 511)) else 0;
control_reg_address_wr <= to_integer(unsigned (m_axi_awaddr (7 downto 0))) when ((to_integer(unsigned(m_axi_awaddr (9 downto 0))) >= 256) and (m_axi_awvalid = '1')) else 0;
control_reg_address_rd <= to_integer(unsigned (m_axi_araddr (7 downto 0))) when (to_integer(unsigned(m_axi_araddr (9 downto 0))) >= 256) else 0;

jtag_axi_access_read_ctrl_fsm: process(in_clk, in_rst_n)
begin
if (in_rst_n = '0') then
    access_ctrl_state <= START_ST;
    m_axi_rvalid    <= '0';
elsif rising_edge(in_clk) then
    case access_ctrl_state is 
    when START_ST => 
        
        if ((m_axi_araddr >= x"100" and m_axi_araddr <= x"107") and m_axi_arvalid = '1' ) then --256 to 263
        
            access_ctrl_state <= CTRL_REG_ACCESS;
            
        elsif ((m_axi_araddr >= x"108" and  m_axi_araddr <= x"17F") and m_axi_arvalid = '1' ) then --264 to 383
         
            reg_comb_mc_mem_address <= comb_mc_mem_address;
            access_ctrl_state <= COMB_MC_MEM_ACCESS;   
        
        elsif ((m_axi_araddr >= x"180" and  m_axi_araddr <= x"1FF") and m_axi_arvalid = '1' ) then --384 to 511
         
            reg_sync_mc_mem_address <= sync_mc_mem_address;
            access_ctrl_state <= SYNC_MC_MEM_ACCESS;   
        
        
        elsif ((m_axi_araddr >= x"80" and  m_axi_araddr <= x"FF") and m_axi_arvalid = '1' ) then --128 to 255
         
            reg_comb_mem_address <= comb_mem_address;
            access_ctrl_state <= COMB_MEM_ACCESS;
            
        elsif ((m_axi_araddr >= x"00" and  m_axi_araddr <= x"7F") and m_axi_arvalid ='1' ) then --0 to 127
        
            reg_sync_mem_address <= sync_mem_address;
            access_ctrl_state <= SYNC_MEM_ACCESS;
 
        else
        
            access_ctrl_state <= START_ST;
        end if;
         m_axi_rvalid    <= '0';
         
    when SYNC_MEM_ACCESS =>
        if (m_axi_rready) then
            m_axi_rdata <= mem_sync_fault_status (reg_sync_mem_address);
            m_axi_rvalid <= '1';
            m_axi_rresp <= "00";
            access_ctrl_state <= START_ST;
        else
            m_axi_rvalid    <= '0';
            access_ctrl_state <= SYNC_MEM_ACCESS;
        end if;
    
    when COMB_MEM_ACCESS =>
        if (m_axi_rready) then
            m_axi_rdata <= mem_comb_fault_status (reg_comb_mem_address);
            m_axi_rvalid <= '1';
            m_axi_rresp <= "00";
            access_ctrl_state <= START_ST;
        else
            access_ctrl_state <= COMB_MEM_ACCESS;
            m_axi_rvalid    <= '0';
        end if;
    when COMB_MC_MEM_ACCESS =>
        if (m_axi_rready) then
            m_axi_rdata <= mem_comb_mc_spike_out (reg_comb_mc_mem_address);
            m_axi_rvalid <= '1';
            m_axi_rresp <= "00";
            access_ctrl_state <= START_ST;
        else
            access_ctrl_state <= COMB_MC_MEM_ACCESS;
            m_axi_rvalid    <= '0';
        end if;
        
     when SYNC_MC_MEM_ACCESS =>
        if (m_axi_rready) then
            m_axi_rdata <= mem_sync_mc_spike_out (reg_sync_mc_mem_address);
            m_axi_rvalid <= '1';
            m_axi_rresp <= "00";
            access_ctrl_state <= START_ST;
        else
            access_ctrl_state <= SYNC_MC_MEM_ACCESS;
            m_axi_rvalid    <= '0';
        end if;
    when CTRL_REG_ACCESS =>
      
      case control_reg_address_rd is 
      
      when 256 =>
         if (m_axi_rready) then
            m_axi_rdata <= fault_inj_ctrl_reg;
            m_axi_rvalid <= '1';
            m_axi_rresp <= "00";
            access_ctrl_state <= START_ST;
        else
            access_ctrl_state <= CTRL_REG_ACCESS;
            m_axi_rvalid    <= '0';
      end if;
      
      when 257 => 
         if (m_axi_rready) then
            m_axi_rdata <= fault_inj_ctrl_reg_fp_sel;
            m_axi_rvalid <= '1';
            m_axi_rresp <= "00";
            access_ctrl_state <= START_ST;
        else
            access_ctrl_state <= CTRL_REG_ACCESS;
            m_axi_rvalid    <= '0';
      end if;
        
      when 258 => 
         if (m_axi_rready) then
            m_axi_rdata <= reset_control_reg;
            m_axi_rvalid <= '1';
            m_axi_rresp <= "00";
            access_ctrl_state <= START_ST;
        else
            access_ctrl_state <= CTRL_REG_ACCESS;
            m_axi_rvalid    <= '0';
      end if;
       
      when others =>
        m_axi_rvalid <= '0';
        access_ctrl_state <= START_ST;
       
      end case; 
        
    when others =>
        m_axi_rdata   <= (others => '0');
        m_axi_rvalid    <= '0';
        access_ctrl_state <= START_ST;
    end case; 
end if;

end process;

---------------------jtag axi write control-----------------------------------------------
m_axi_awready <= m_axi_awvalid  and sig_m_axi_awready;
m_axi_wready  <= m_axi_wvalid   and sig_m_axi_wready;



process (in_clk, in_rst_n)
begin
if (in_rst_n = '0') then

  m_axi_bvalid <= '0';
  sig_m_axi_awready <= '0';
  sig_m_axi_wready  <= '0';
  fault_inj_ctrl_reg <= (others=> '0');
  fault_inj_ctrl_reg_fp_sel <= (others=>'0');
  reset_control_reg <= (others=>'0');
  
elsif rising_edge(in_clk) then

  sig_m_axi_awready <= m_axi_awvalid;
  sig_m_axi_wready  <= m_axi_wvalid;

case control_reg_address_wr is 
   
    when 256 =>
         if (m_axi_wvalid and sig_m_axi_wready) then
          fault_inj_ctrl_reg <= m_axi_wdata;
          m_axi_bresp  <= "00";
          m_axi_bvalid <= '1';
         end if;
         
    when 257 =>
         if (m_axi_wvalid and sig_m_axi_wready) then
          fault_inj_ctrl_reg_fp_sel <= m_axi_wdata;
          m_axi_bresp  <= "00";
          m_axi_bvalid <= '1';
         end if;     
         
    when 258 => 
        if (m_axi_wvalid and sig_m_axi_wready) then
          reset_control_reg <= m_axi_wdata;
          m_axi_bresp  <= "00";
          m_axi_bvalid <= '1';
        end if;
       
    when others =>
        m_axi_bresp  <= "00";
        m_axi_bvalid <= '0';
        fault_inj_ctrl_reg <= fault_inj_ctrl_reg;
        fault_inj_ctrl_reg_fp_sel <= fault_inj_ctrl_reg_fp_sel;
        reset_control_reg <= reset_control_reg;
end case; 

end if;
end process;
  
  
end Behavioral;
