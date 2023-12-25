# VGA_IP_sw.tcl 
# create a new driver 
create_driver VGA_IP


set_sw_property hw_class_name VGA_IP

# The version of this driver
set_sw_property version 1

set_sw_property min_compatible_hw_version 1.0

# Location in generated BSP that above sources will be copied 
set_sw_property bsp_subdirectory drivers


#include headers
add_sw_property include_source HAL/inc/char_map.h
add_sw_property include_source HAL/inc/draw_vga.h
add_sw_property include_source HAL/inc/DE10_Lite_VGA_Driver.h

#include sources
add_sw_property c_source HAL/src/char_map.c
add_sw_property c_source HAL/src/draw_vga.c


#This driver supports HAL type
add_sw_property supported_bsp_type HAL
    
#End of file
