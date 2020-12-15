create_clock -name clk_50MHz -period 20.00 [get_ports clock]

set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports clock]

set_property -dict { PACKAGE_PIN B11 IOSTANDARD LVCMOS33 } [get_ports { hsync }]; # VGA hsync

set_property -dict { PACKAGE_PIN B12 IOSTANDARD LVCMOS33 } [get_ports { vsync }]; # VGA vsync

set_property -dict { PACKAGE_PIN B7 IOSTANDARD LVCMOS33 } [get_ports { blue[0] }]; # VGA blue
set_property -dict { PACKAGE_PIN C7 IOSTANDARD LVCMOS33 } [get_ports { blue[1] }]; 
set_property -dict { PACKAGE_PIN D7 IOSTANDARD LVCMOS33 } [get_ports { blue[2] }];
set_property -dict { PACKAGE_PIN D8 IOSTANDARD LVCMOS33 } [get_ports { blue[3] }];

set_property -dict { PACKAGE_PIN A3 IOSTANDARD LVCMOS33 } [get_ports { red[0] }]; # VGA red
set_property -dict { PACKAGE_PIN B4 IOSTANDARD LVCMOS33 } [get_ports { red[1] }]; 
set_property -dict { PACKAGE_PIN C5 IOSTANDARD LVCMOS33 } [get_ports { red[2] }]; 
set_property -dict { PACKAGE_PIN A4 IOSTANDARD LVCMOS33 } [get_ports { red[3] }];

set_property -dict { PACKAGE_PIN C6 IOSTANDARD LVCMOS33 } [get_ports { green[0] }]; # VGA green
set_property -dict { PACKAGE_PIN A5 IOSTANDARD LVCMOS33 } [get_ports { green[1] }]; 
set_property -dict { PACKAGE_PIN B6 IOSTANDARD LVCMOS33 } [get_ports { green[2] }]; 
set_property -dict { PACKAGE_PIN A6 IOSTANDARD LVCMOS33 } [get_ports { green[3] }];

set_property -dict { PACKAGE_PIN M18 IOSTANDARD LVCMOS33 } [get_ports { clear }]; # Up Button
set_property -dict { PACKAGE_PIN N17 IOSTANDARD LVCMOS33 } [get_ports { key_enter1 }]; # Middle Button
set_property -dict { PACKAGE_PIN P17 IOSTANDARD LVCMOS33 } [get_ports { key_left1 }]; # Left Button
set_property -dict { PACKAGE_PIN M17 IOSTANDARD LVCMOS33 } [get_ports { key_right1 }]; # Right Button
set_property -dict { PACKAGE_PIN P18 IOSTANDARD LVCMOS33 } [get_ports { key_down1 }]; # Down Button

set_property -dict { PACKAGE_PIN A11 IOSTANDARD LVCMOS33 } [get_ports { audio }]; # audio output

set_property -dict { PACKAGE_PIN F4    IOSTANDARD LVCMOS33 } [get_ports { ps2_clk }]; #IO_L13P_T2_MRCC_35 Sch=ps2_clk
set_property -dict { PACKAGE_PIN B2    IOSTANDARD LVCMOS33 } [get_ports { ps2_data }]; #IO_L10N_T1_AD15N_35 Sch=ps2_data

set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { sw[0] }]; #SW0
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { sw[1] }]; #SW1
set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { sw[2] }]; #SW2