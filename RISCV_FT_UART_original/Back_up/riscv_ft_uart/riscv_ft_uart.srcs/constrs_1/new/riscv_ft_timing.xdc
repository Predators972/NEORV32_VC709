#-- Set the clock port as an input with a 100 MHz frequency
set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports clk_i]
create_clock -period 10.000 -name sys_clk -add [get_ports clk_i]


set_property -dict {PACKAGE_PIN R2 IOSTANDARD LVCMOS33} [get_ports rstn_i]
set_property -dict { PULLDOWN true } [get_ports { rstn_i }]



set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports {gpio_o[7]}]

set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports {gpio_o[6]}]

set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports {gpio_o[5]}]

set_property -dict {PACKAGE_PIN V19 IOSTANDARD LVCMOS33} [get_ports {gpio_o[4]}]

set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports {gpio_o[3]}]

set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports {gpio_o[2]}]

set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports {gpio_o[1]}]

set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33} [get_ports {gpio_o[0]}]

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
