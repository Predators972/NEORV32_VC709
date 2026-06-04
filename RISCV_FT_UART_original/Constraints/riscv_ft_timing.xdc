#-- Set the clock port as an input with a 100 MHz frequency

#####----VC709 FPGA boardConstraints------------####
set_property PACKAGE_PIN AV30 [get_ports rstn_i]
set_property IOSTANDARD LVCMOS18 [get_ports rstn_i]

# create_clock -name clk_ref_200mhz -period 5 [get_ports clk_in1_p]

set_property PACKAGE_PIN H19 [get_ports clk_in1_p]
set_property PACKAGE_PIN G18 [get_ports clk_in1_n]

set_property IOSTANDARD DIFF_SSTL15 [get_ports clk_in1_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports clk_in1_n]


# create_generated_clock -name clk_100mhz -source [get_pins clock_gen_100mhz/clk_in1_p] -divide_by 2 [get_pins clock_gen_100mhz/clk_out1]

#########################################################################################################################

set_property -dict {PACKAGE_PIN AU33 IOSTANDARD LVCMOS18} [get_ports uart0_rxd_i]

set_property -dict {PACKAGE_PIN AU36 IOSTANDARD LVCMOS18} [get_ports uart0_txd_o]


##GPIO

set_property -dict {PACKAGE_PIN AM39 IOSTANDARD LVCMOS18} [get_ports {gpio_o[7]}]

set_property -dict {PACKAGE_PIN AN39 IOSTANDARD LVCMOS18} [get_ports {gpio_o[6]}]

set_property -dict {PACKAGE_PIN AR37 IOSTANDARD LVCMOS18} [get_ports {gpio_o[5]}]

set_property -dict {PACKAGE_PIN AT37 IOSTANDARD LVCMOS18} [get_ports {gpio_o[4]}]

set_property -dict {PACKAGE_PIN AR35 IOSTANDARD LVCMOS18} [get_ports {gpio_o[3]}]

set_property -dict {PACKAGE_PIN AP41 IOSTANDARD LVCMOS18} [get_ports {gpio_o[2]}]

set_property -dict {PACKAGE_PIN AP42 IOSTANDARD LVCMOS18} [get_ports {gpio_o[1]}]

set_property -dict {PACKAGE_PIN AU39 IOSTANDARD LVCMOS18} [get_ports {gpio_o[0]}]

##BASYS 3 board constraints

#set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports clk_i]
#create_clock -period 10.000 -name sys_clk -add [get_ports clk_i]


#set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports rstn_i]
#set_property -dict { PULLDOWN true } [get_ports { rstn_i }]



#set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports {gpio_o[7]}]

#set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports {gpio_o[6]}]

#set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports {gpio_o[5]}]

#set_property -dict {PACKAGE_PIN V19 IOSTANDARD LVCMOS33} [get_ports {gpio_o[4]}]

#set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports {gpio_o[3]}]

#set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports {gpio_o[2]}]

#set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports {gpio_o[1]}]

#set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33} [get_ports {gpio_o[0]}]

##UART
#set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVCMOS33} [get_ports uart0_rxd_i]

#set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33} [get_ports uart0_txd_o]



#set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets neorv32_top_inst/neorv32_cpu_inst/neorv32_cpu_control_inst/tap_cb_rd_req_buf[0]]
#set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets neorv32_top_inst/neorv32_cpu_inst/neorv32_cpu_control_inst/tap_cb_rd_req_buf[1]]
#set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets neorv32_top_inst/neorv32_cpu_inst/neorv32_cpu_control_inst/tap_cb_rd_req_buf[2]]
#set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets neorv32_top_inst/neorv32_cpu_inst/neorv32_cpu_control_inst/tap_cb_rd_req_buf[3]]
#set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets neorv32_top_inst/neorv32_cpu_inst/neorv32_cpu_control_inst/tap_cb_rd_req_buf[4]]
#set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets neorv32_top_inst/neorv32_cpu_inst/neorv32_cpu_control_inst/tap_cb_rd_req_buf[5]]
#set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets neorv32_top_inst/neorv32_cpu_inst/neorv32_cpu_control_inst/tap_cb_rd_req_buf[6]]
#set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets neorv32_top_inst/neorv32_cpu_inst/neorv32_cpu_control_inst/tap_cb_rd_req_buf[7]]

#set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets jtag_interface_inst/sig_comb_or_out]
#set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets jtag_interface_inst/sig_sync_or_out]
#set_property CFGBVS 3.3V [current_design]
#set_property CONFIG_VOLTAGE 1V [current_design]


# XADC Analog Inputs (VP/VN)
# These are internal dedicated pins - NO PACKAGE_PIN needed
# Vivado handles them automatically via the XADC IP

# False path on analog inputs (no timing constraint needed)
set_false_path -from [get_ports vp_in]
set_false_path -from [get_ports vn_in]