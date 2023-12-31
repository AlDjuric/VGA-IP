# TCL File Generated by Component Editor 18.1
# Thu Nov 23 19:56:44 CET 2023
# DO NOT MODIFY


# 
# VGA_IP "VGA_IP" v1.0
# Aleksandar Djuric 2023.11.23.19:56:44
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module VGA_IP
# 
set_module_property DESCRIPTION ""
set_module_property NAME VGA_IP
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Aleksandar Djuric"
set_module_property DISPLAY_NAME VGA_IP
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL VGA_IP
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file VGA_IP.vhd VHDL PATH HDL/VGA_IP.vhd TOP_LEVEL_FILE
add_fileset_file DP_RAM.vhd VHDL PATH HDL/DP_RAM.vhd
add_fileset_file VGA_sync.vhd VHDL PATH HDL/VGA_sync.vhd


# 
# parameters
# 


# 
# display items
# 


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock_sink_25
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset RESET_N reset_n Input 1


# 
# connection point avalon_slave_0
# 
add_interface avalon_slave_0 avalon end
set_interface_property avalon_slave_0 addressUnits WORDS
set_interface_property avalon_slave_0 associatedClock clock_sink_25
set_interface_property avalon_slave_0 associatedReset reset
set_interface_property avalon_slave_0 bitsPerSymbol 8
set_interface_property avalon_slave_0 burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_0 burstcountUnits WORDS
set_interface_property avalon_slave_0 explicitAddressSpan 0
set_interface_property avalon_slave_0 holdTime 0
set_interface_property avalon_slave_0 linewrapBursts false
set_interface_property avalon_slave_0 maximumPendingReadTransactions 0
set_interface_property avalon_slave_0 maximumPendingWriteTransactions 0
set_interface_property avalon_slave_0 readLatency 0
set_interface_property avalon_slave_0 readWaitTime 1
set_interface_property avalon_slave_0 setupTime 0
set_interface_property avalon_slave_0 timingUnits Cycles
set_interface_property avalon_slave_0 writeWaitTime 0
set_interface_property avalon_slave_0 ENABLED true
set_interface_property avalon_slave_0 EXPORT_OF ""
set_interface_property avalon_slave_0 PORT_NAME_MAP ""
set_interface_property avalon_slave_0 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave_0 SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave_0 AVALON_CS_N chipselect_n Input 1
add_interface_port avalon_slave_0 AVALON_DIN writedata Input 32
add_interface_port avalon_slave_0 AVALON_DOUT readdata Output 32
add_interface_port avalon_slave_0 AVALON_ADDRESS address Input 17
add_interface_port avalon_slave_0 AVALON_READ_N read_n Input 1
add_interface_port avalon_slave_0 AVALON_WRITE_N write_n Input 1
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point clock_sink_50
# 
add_interface clock_sink_50 clock end
set_interface_property clock_sink_50 clockRate 0
set_interface_property clock_sink_50 ENABLED true
set_interface_property clock_sink_50 EXPORT_OF ""
set_interface_property clock_sink_50 PORT_NAME_MAP ""
set_interface_property clock_sink_50 CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink_50 SVD_ADDRESS_GROUP ""

add_interface_port clock_sink_50 CLOCK_50 clk Input 1


# 
# connection point clock_sink_25
# 
add_interface clock_sink_25 clock end
set_interface_property clock_sink_25 clockRate 0
set_interface_property clock_sink_25 ENABLED true
set_interface_property clock_sink_25 EXPORT_OF ""
set_interface_property clock_sink_25 PORT_NAME_MAP ""
set_interface_property clock_sink_25 CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink_25 SVD_ADDRESS_GROUP ""

add_interface_port clock_sink_25 CLOCK_25 clk Input 1


# 
# connection point conduit_end
# 
add_interface conduit_end conduit end
set_interface_property conduit_end associatedClock clock_sink_25
set_interface_property conduit_end associatedReset ""
set_interface_property conduit_end ENABLED true
set_interface_property conduit_end EXPORT_OF ""
set_interface_property conduit_end PORT_NAME_MAP ""
set_interface_property conduit_end CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end SVD_ADDRESS_GROUP ""

add_interface_port conduit_end VGA_B vga_b Output 4
add_interface_port conduit_end VGA_G vga_g Output 4
add_interface_port conduit_end VGA_HS vga_hs Output 1
add_interface_port conduit_end VGA_R vga_r Output 4
add_interface_port conduit_end VGA_VS vga_vs Output 1

