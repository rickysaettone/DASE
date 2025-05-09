## Clock
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports {clk}];

## Reset - boton 0 pynq
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports {rst}];
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports {start}]

## LEDs
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports {leds[0]}];
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports {leds[1]}];
set_property -dict {PACKAGE_PIN N16 IOSTANDARD LVCMOS33} [get_ports {leds[2]}];
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports {leds[3]}];

#LEDs
set_property -dict { PACKAGE_PIN W18 IOSTANDARD LVCMOS33}  [get_ports {leds[4]}];
set_property -dict { PACKAGE_PIN W19 IOSTANDARD LVCMOS33}  [get_ports {leds[5]}];
set_property -dict { PACKAGE_PIN Y18 IOSTANDARD LVCMOS33}  [get_ports {leds[6]}]; 
set_property -dict { PACKAGE_PIN U7  IOSTANDARD LVCMOS33}  [get_ports {leds[7]}]; 
set_property -dict { PACKAGE_PIN V7  IOSTANDARD LVCMOS33}  [get_ports {leds[8]}];
set_property -dict { PACKAGE_PIN U8  IOSTANDARD LVCMOS33}  [get_ports {leds[9]}];
set_property -dict { PACKAGE_PIN V8  IOSTANDARD LVCMOS33}  [get_ports {leds[10]}]; 
set_property -dict { PACKAGE_PIN V10 IOSTANDARD LVCMOS33}  [get_ports {leds[11]}];

# Entrada analogica
set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS33} [get_ports Vaux1_v_p];
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports Vaux1_v_n];