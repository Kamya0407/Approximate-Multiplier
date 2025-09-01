## ------------------------------------------------------------------
## Virtual clock for analysis only (e.g., 25 MHz → 40 ns period)
## ------------------------------------------------------------------
create_clock -name virt_clk -period 20 

## Assume inputs arrive exactly on the clock edge
set_input_delay 0 -clock virt_clk [get_ports A[*]] 
set_input_delay 0 -clock virt_clk [get_ports B[*]]   

## Assume outputs are captured exactly on the next edge
set_output_delay 0 -clock virt_clk [get_ports P[*]] 

## Switches for A[7:0]
set_property PACKAGE_PIN V17 [get_ports {A[0]}]
set_property PACKAGE_PIN V16 [get_ports {A[1]}]
set_property PACKAGE_PIN W16 [get_ports {A[2]}]
set_property PACKAGE_PIN W17 [get_ports {A[3]}]
set_property PACKAGE_PIN W15 [get_ports {A[4]}]
set_property PACKAGE_PIN V15 [get_ports {A[5]}]
set_property PACKAGE_PIN W14 [get_ports {A[6]}]
set_property PACKAGE_PIN W13 [get_ports {A[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports A[*]]

## Switches for B[7:0]
set_property PACKAGE_PIN V2  [get_ports {B[0]}]
set_property PACKAGE_PIN T3  [get_ports {B[1]}]
set_property PACKAGE_PIN T2  [get_ports {B[2]}]
set_property PACKAGE_PIN R3  [get_ports {B[3]}]
set_property PACKAGE_PIN W2  [get_ports {B[4]}]
set_property PACKAGE_PIN U1  [get_ports {B[5]}]
set_property PACKAGE_PIN T1  [get_ports {B[6]}]
set_property PACKAGE_PIN R2  [get_ports {B[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports B[*]]

## LEDs for P[15:0]
set_property PACKAGE_PIN U16 [get_ports {P[0]}]
set_property PACKAGE_PIN E19 [get_ports {P[1]}]
set_property PACKAGE_PIN U19 [get_ports {P[2]}]
set_property PACKAGE_PIN V19 [get_ports {P[3]}]
set_property PACKAGE_PIN W18 [get_ports {P[4]}]
set_property PACKAGE_PIN U15 [get_ports {P[5]}]
set_property PACKAGE_PIN U14 [get_ports {P[6]}]
set_property PACKAGE_PIN V14 [get_ports {P[7]}]
set_property PACKAGE_PIN V13 [get_ports {P[8]}]
set_property PACKAGE_PIN V3 [get_ports {P[9]}]
set_property PACKAGE_PIN W3 [get_ports {P[10]}]
set_property PACKAGE_PIN U3 [get_ports {P[11]}]
set_property PACKAGE_PIN P3 [get_ports {P[12]}]
set_property PACKAGE_PIN N3 [get_ports {P[13]}]
set_property PACKAGE_PIN P1 [get_ports {P[14]}]
set_property PACKAGE_PIN L1 [get_ports {P[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports P[*]]
