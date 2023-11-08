
################################################################
# This is a generated script based on design: system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2023.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   common::send_gid_msg -ssname BD::TCL -id 2040 -severity "WARNING" "This script was generated using Vivado <$scripts_vivado_version> without IP versions in the create_bd_cell commands, but is now being run in <$current_vivado_version> of Vivado. There may have been major IP version changes between Vivado <$scripts_vivado_version> and <$current_vivado_version>, which could impact the parameter settings of the IPs."

}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source system_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# aud_pat_gen, hdmi_acr_ctrl

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu5ev-sfvc784-1-e
   set_property BOARD_PART digilentinc.com:gzu_5ev:part0:1.1 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name system

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

  # Add USER_COMMENTS on $design_name
  set_property USER_COMMENTS.comment_0 "gpio_emio mapping:
[0] => FPGA_MUX_RST
[1] => MIPI_A_PWUP
[2] => MIPI_B_PWUP" [get_bd_designs $design_name]

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:proc_sys_reset:*\
xilinx.com:ip:axi_gpio:*\
xilinx.com:ip:util_vector_logic:*\
xilinx.com:ip:axi_iic:*\
xilinx.com:ip:smartconnect:*\
xilinx.com:ip:axis_register_slice:*\
xilinx.com:ip:v_hdmi_rx_ss:*\
xilinx.com:ip:v_hdmi_tx_ss:*\
xilinx.com:ip:vid_phy_controller:*\
xilinx.com:ip:xlconcat:*\
xilinx.com:ip:xlconstant:*\
xilinx.com:ip:zynq_ultra_ps_e:*\
xilinx.com:ip:clk_wiz:*\
xilinx.com:user:edge_detect:*\
xilinx.com:ip:axi_dma:*\
digilentinc.com:user:digilent_axi_i2s:*\
xilinx.com:ip:xfft:*\
digilentinc.com:user:pwm_rgb:*\
xilinx.com:ip:v_tpg:*\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
aud_pat_gen\
hdmi_acr_ctrl\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: v_tpg_ss_0
proc create_hier_cell_v_tpg_ss_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_v_tpg_ss_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_GPIO

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_TPG

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_video

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_video


  # Create pins
  create_bd_pin -dir I -type clk ap_clk
  create_bd_pin -dir I -type rst s_axi_aresetn_0

  # Create instance: axi_gpio, and set properties
  set axi_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio axi_gpio ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
  ] $axi_gpio


  # Create instance: v_tpg, and set properties
  set v_tpg [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tpg v_tpg ]
  set_property -dict [list \
    CONFIG.COLOR_SWEEP {0} \
    CONFIG.DISPLAY_PORT {0} \
    CONFIG.FOREGROUND {0} \
    CONFIG.HAS_AXI4S_SLAVE {1} \
    CONFIG.RAMP {0} \
    CONFIG.SAMPLES_PER_CLOCK {4} \
    CONFIG.SOLID_COLOR {0} \
    CONFIG.ZONE_PLATE {0} \
  ] $v_tpg


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_GPIO] [get_bd_intf_pins axi_gpio/S_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_TPG] [get_bd_intf_pins v_tpg/s_axi_CTRL]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins s_axis_video] [get_bd_intf_pins v_tpg/s_axis_video]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins m_axis_video] [get_bd_intf_pins v_tpg/m_axis_video]

  # Create port connections
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins axi_gpio/gpio_io_o] [get_bd_pins v_tpg/ap_rst_n]
  connect_bd_net -net s_axi_aclk_0_1 [get_bd_pins ap_clk] [get_bd_pins axi_gpio/s_axi_aclk] [get_bd_pins v_tpg/ap_clk]
  connect_bd_net -net s_axi_aresetn_0_1 [get_bd_pins s_axi_aresetn_0] [get_bd_pins axi_gpio/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: uio
proc create_hier_cell_uio { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_uio() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 pl_buttons

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 pl_leds

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 pl_switches


  # Create pins
  create_bd_pin -dir O -type intr ip2intc_irpt
  create_bd_pin -dir O -type intr ip2intc_irpt1
  create_bd_pin -dir O -from 2 -to 0 pl_rgb_led
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: pwm_rgb_led, and set properties
  set pwm_rgb_led [ create_bd_cell -type ip -vlnv digilentinc.com:user:pwm_rgb pwm_rgb_led ]

  # Create instance: axi_gpio_btn, and set properties
  set axi_gpio_btn [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio axi_gpio_btn ]
  set_property -dict [list \
    CONFIG.C_ALL_INPUTS {1} \
    CONFIG.C_GPIO_WIDTH {5} \
    CONFIG.C_INTERRUPT_PRESENT {1} \
  ] $axi_gpio_btn


  # Create instance: axi_gpio_led, and set properties
  set axi_gpio_led [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio axi_gpio_led ]
  set_property -dict [list \
    CONFIG.C_ALL_INPUTS {0} \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {4} \
    CONFIG.C_INTERRUPT_PRESENT {0} \
  ] $axi_gpio_led


  # Create instance: axi_gpio_sw, and set properties
  set axi_gpio_sw [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio axi_gpio_sw ]
  set_property -dict [list \
    CONFIG.C_ALL_INPUTS {1} \
    CONFIG.C_GPIO_WIDTH {4} \
    CONFIG.C_INTERRUPT_PRESENT {1} \
    CONFIG.C_IS_DUAL {0} \
  ] $axi_gpio_sw


  # Create interface connections
  connect_bd_intf_net -intf_net axi_gpio_btn_GPIO [get_bd_intf_pins pl_buttons] [get_bd_intf_pins axi_gpio_btn/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_led_GPIO [get_bd_intf_pins pl_leds] [get_bd_intf_pins axi_gpio_led/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_sw_GPIO [get_bd_intf_pins pl_switches] [get_bd_intf_pins axi_gpio_sw/GPIO]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M00_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_gpio_btn/S_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M01_AXI [get_bd_intf_pins S_AXI2] [get_bd_intf_pins axi_gpio_led/S_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M02_AXI [get_bd_intf_pins S_AXI3] [get_bd_intf_pins axi_gpio_sw/S_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M03_AXI [get_bd_intf_pins S_AXI1] [get_bd_intf_pins pwm_rgb_led/S_AXI]

  # Create port connections
  connect_bd_net -net axi_gpio_0_ip2intc_irpt [get_bd_pins axi_gpio_sw/ip2intc_irpt] [get_bd_pins ip2intc_irpt1]
  connect_bd_net -net axi_gpio_1_ip2intc_irpt [get_bd_pins axi_gpio_btn/ip2intc_irpt] [get_bd_pins ip2intc_irpt]
  connect_bd_net -net pwm_rgb_0_RGB [get_bd_pins pwm_rgb_led/RGB] [get_bd_pins pl_rgb_led]
  connect_bd_net -net rst_ps8_0_50M_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins pwm_rgb_led/s_axi_aresetn] [get_bd_pins axi_gpio_btn/s_axi_aresetn] [get_bd_pins axi_gpio_led/s_axi_aresetn] [get_bd_pins axi_gpio_sw/s_axi_aresetn]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins s_axi_aclk] [get_bd_pins pwm_rgb_led/s_axi_aclk] [get_bd_pins axi_gpio_btn/s_axi_aclk] [get_bd_pins axi_gpio_led/s_axi_aclk] [get_bd_pins axi_gpio_sw/s_axi_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: short_loopback_tests
proc create_hier_cell_short_loopback_tests { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_short_loopback_tests() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 PG_VADJ_R

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI4

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI5

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI6

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI7

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI8

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 ffc_a

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 ffc_a1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 ffc_b

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 ffc_b1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 fmc_la_00_n

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 fmc_la_00_p

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 fmc_la_01_n

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 fmc_la_01_p

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 fmc_prsnt

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 pmod

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 pmod2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 syszygy_1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 syzygy_2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 syzygy_detectedn


  # Create pins
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: PG_VADJ_R, and set properties
  set PG_VADJ_R [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio PG_VADJ_R ]
  set_property -dict [list \
    CONFIG.C_ALL_INPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
  ] $PG_VADJ_R


  # Create instance: fmc_prsnt, and set properties
  set fmc_prsnt [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio fmc_prsnt ]
  set_property -dict [list \
    CONFIG.C_ALL_INPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
  ] $fmc_prsnt


  # Create instance: la_00, and set properties
  set la_00 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio la_00 ]
  set_property -dict [list \
    CONFIG.C_GPIO2_WIDTH {17} \
    CONFIG.C_GPIO_WIDTH {17} \
    CONFIG.C_IS_DUAL {1} \
  ] $la_00


  # Create instance: la_01, and set properties
  set la_01 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio la_01 ]
  set_property -dict [list \
    CONFIG.C_GPIO2_WIDTH {17} \
    CONFIG.C_GPIO_WIDTH {17} \
    CONFIG.C_IS_DUAL {1} \
  ] $la_01


  # Create instance: mipi_ffc_a, and set properties
  set mipi_ffc_a [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio mipi_ffc_a ]
  set_property -dict [list \
    CONFIG.C_GPIO2_WIDTH {3} \
    CONFIG.C_GPIO_WIDTH {3} \
    CONFIG.C_IS_DUAL {1} \
  ] $mipi_ffc_a


  # Create instance: mipi_ffc_b, and set properties
  set mipi_ffc_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio mipi_ffc_b ]
  set_property -dict [list \
    CONFIG.C_GPIO2_WIDTH {3} \
    CONFIG.C_GPIO_WIDTH {3} \
    CONFIG.C_IS_DUAL {1} \
  ] $mipi_ffc_b


  # Create instance: pmods, and set properties
  set pmods [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio pmods ]
  set_property -dict [list \
    CONFIG.C_GPIO2_WIDTH {15} \
    CONFIG.C_GPIO_WIDTH {15} \
    CONFIG.C_IS_DUAL {1} \
  ] $pmods


  # Create instance: syszygy, and set properties
  set syszygy [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio syszygy ]
  set_property -dict [list \
    CONFIG.C_GPIO2_WIDTH {12} \
    CONFIG.C_GPIO_WIDTH {12} \
    CONFIG.C_IS_DUAL {1} \
  ] $syszygy


  # Create instance: syzygy_detectedn, and set properties
  set syzygy_detectedn [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio syzygy_detectedn ]
  set_property -dict [list \
    CONFIG.C_ALL_INPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
    CONFIG.GPIO_BOARD_INTERFACE {Custom} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $syzygy_detectedn


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins pmods/S_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins pmod] [get_bd_intf_pins pmods/GPIO]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins pmod2] [get_bd_intf_pins pmods/GPIO2]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins fmc_prsnt] [get_bd_intf_pins fmc_prsnt/GPIO]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins S_AXI1] [get_bd_intf_pins fmc_prsnt/S_AXI]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins fmc_la_00_n] [get_bd_intf_pins la_00/GPIO2]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins fmc_la_01_p] [get_bd_intf_pins la_01/GPIO]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins fmc_la_00_p] [get_bd_intf_pins la_00/GPIO]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins fmc_la_01_n] [get_bd_intf_pins la_01/GPIO2]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins S_AXI2] [get_bd_intf_pins la_00/S_AXI]
  connect_bd_intf_net -intf_net Conn11 [get_bd_intf_pins S_AXI3] [get_bd_intf_pins la_01/S_AXI]
  connect_bd_intf_net -intf_net Conn12 [get_bd_intf_pins syszygy_1] [get_bd_intf_pins syszygy/GPIO]
  connect_bd_intf_net -intf_net Conn13 [get_bd_intf_pins syzygy_2] [get_bd_intf_pins syszygy/GPIO2]
  connect_bd_intf_net -intf_net Conn14 [get_bd_intf_pins S_AXI4] [get_bd_intf_pins syszygy/S_AXI]
  connect_bd_intf_net -intf_net Conn15 [get_bd_intf_pins ffc_a] [get_bd_intf_pins mipi_ffc_a/GPIO]
  connect_bd_intf_net -intf_net Conn16 [get_bd_intf_pins ffc_a1] [get_bd_intf_pins mipi_ffc_a/GPIO2]
  connect_bd_intf_net -intf_net Conn17 [get_bd_intf_pins S_AXI5] [get_bd_intf_pins mipi_ffc_a/S_AXI]
  connect_bd_intf_net -intf_net Conn18 [get_bd_intf_pins ffc_b] [get_bd_intf_pins mipi_ffc_b/GPIO]
  connect_bd_intf_net -intf_net Conn19 [get_bd_intf_pins ffc_b1] [get_bd_intf_pins mipi_ffc_b/GPIO2]
  connect_bd_intf_net -intf_net Conn20 [get_bd_intf_pins S_AXI6] [get_bd_intf_pins mipi_ffc_b/S_AXI]
  connect_bd_intf_net -intf_net Conn21 [get_bd_intf_pins PG_VADJ_R] [get_bd_intf_pins PG_VADJ_R/GPIO]
  connect_bd_intf_net -intf_net Conn22 [get_bd_intf_pins S_AXI7] [get_bd_intf_pins PG_VADJ_R/S_AXI]
  connect_bd_intf_net -intf_net Conn23 [get_bd_intf_pins syzygy_detectedn] [get_bd_intf_pins syzygy_detectedn/GPIO]
  connect_bd_intf_net -intf_net Conn24 [get_bd_intf_pins S_AXI8] [get_bd_intf_pins syzygy_detectedn/S_AXI]

  # Create port connections
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins PG_VADJ_R/s_axi_aclk] [get_bd_pins fmc_prsnt/s_axi_aclk] [get_bd_pins la_00/s_axi_aclk] [get_bd_pins la_01/s_axi_aclk] [get_bd_pins mipi_ffc_a/s_axi_aclk] [get_bd_pins mipi_ffc_b/s_axi_aclk] [get_bd_pins pmods/s_axi_aclk] [get_bd_pins syszygy/s_axi_aclk] [get_bd_pins syzygy_detectedn/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins PG_VADJ_R/s_axi_aresetn] [get_bd_pins fmc_prsnt/s_axi_aresetn] [get_bd_pins la_00/s_axi_aresetn] [get_bd_pins la_01/s_axi_aresetn] [get_bd_pins mipi_ffc_a/s_axi_aresetn] [get_bd_pins mipi_ffc_b/s_axi_aresetn] [get_bd_pins pmods/s_axi_aresetn] [get_bd_pins syszygy/s_axi_aresetn] [get_bd_pins syzygy_detectedn/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: set_vadj_level
proc create_hier_cell_set_vadj_level { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_set_vadj_level() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 vadj_set


  # Create pins
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio axi_gpio_0 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {0} \
    CONFIG.C_GPIO_WIDTH {3} \
  ] $axi_gpio_0


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins vadj_set] [get_bd_intf_pins axi_gpio_0/GPIO]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_gpio_0/S_AXI]

  # Create port connections
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: audio_test
proc create_hier_cell_audio_test { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_audio_test() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 AXI_L

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE1


  # Create pins
  create_bd_pin -dir O BCLK_O_0
  create_bd_pin -dir O LRCLK1_O_0
  create_bd_pin -dir O MCLK_O_0
  create_bd_pin -dir I SDATA_I_0
  create_bd_pin -dir O SDATA_O_0
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir O -type intr iic2intc_irpt
  create_bd_pin -dir I -type clk m_axi_mm2s_aclk
  create_bd_pin -dir O -type intr mm2s_introut_0
  create_bd_pin -dir O -type intr mm2s_introut_1
  create_bd_pin -dir O -type intr s2mm_introut_0
  create_bd_pin -dir O -type intr s2mm_introut_1

  # Create instance: edge_detect_0, and set properties
  set edge_detect_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:edge_detect edge_detect_0 ]
  set_property CONFIG.N {24} $edge_detect_0


  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma axi_dma_0 ]
  set_property -dict [list \
    CONFIG.c_include_sg {0} \
    CONFIG.c_sg_length_width {23} \
  ] $axi_dma_0


  # Create instance: axi_dma_1, and set properties
  set axi_dma_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma axi_dma_1 ]
  set_property -dict [list \
    CONFIG.c_include_sg {0} \
    CONFIG.c_sg_length_width {23} \
  ] $axi_dma_1


  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio axi_gpio_0 ]
  set_property CONFIG.C_GPIO_WIDTH {24} $axi_gpio_0


  # Create instance: digilent_axi_i2s_0, and set properties
  set digilent_axi_i2s_0 [ create_bd_cell -type ip -vlnv digilentinc.com:user:digilent_axi_i2s digilent_axi_i2s_0 ]
  set_property -dict [list \
    CONFIG.ENABLE_STREAM {true} \
    CONFIG.OUTPUT_ONLY_CLK {true} \
  ] $digilent_axi_i2s_0


  # Create instance: xfft_0, and set properties
  set xfft_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xfft xfft_0 ]
  set_property -dict [list \
    CONFIG.implementation_options {pipelined_streaming_io} \
    CONFIG.number_of_stages_using_block_ram_for_data_and_phase_factors {7} \
    CONFIG.output_ordering {natural_order} \
    CONFIG.run_time_configurable_transform_length {true} \
    CONFIG.scaling_options {scaled} \
    CONFIG.target_clock_frequency {100} \
    CONFIG.transform_length {16384} \
  ] $xfft_0


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins axi_dma_0/M_AXI_S2MM]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins axi_dma_0/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_dma_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_gpio_0/S_AXI]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins S_AXI_LITE1] [get_bd_intf_pins axi_dma_1/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins M_AXI_MM2S1] [get_bd_intf_pins axi_dma_1/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins M_AXI_S2MM1] [get_bd_intf_pins axi_dma_1/M_AXI_S2MM]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins AXI_L] [get_bd_intf_pins digilent_axi_i2s_0/AXI_L]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S] [get_bd_intf_pins xfft_0/S_AXIS_DATA]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXIS_MM2S [get_bd_intf_pins axi_dma_1/M_AXIS_MM2S] [get_bd_intf_pins digilent_axi_i2s_0/AXI_MM2S]
  connect_bd_intf_net -intf_net digilent_axi_i2s_0_AXI_S2MM [get_bd_intf_pins axi_dma_1/S_AXIS_S2MM] [get_bd_intf_pins digilent_axi_i2s_0/AXI_S2MM]
  connect_bd_intf_net -intf_net xfft_0_M_AXIS_DATA [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM] [get_bd_intf_pins xfft_0/M_AXIS_DATA]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins edge_detect_0/din] [get_bd_pins axi_gpio_0/gpio_io_i] [get_bd_pins xfft_0/s_axis_config_tdata]
  connect_bd_net -net SDATA_I_0_1 [get_bd_pins SDATA_I_0] [get_bd_pins digilent_axi_i2s_0/SDATA_I]
  connect_bd_net -net axi_dma_0_mm2s_introut [get_bd_pins axi_dma_0/mm2s_introut] [get_bd_pins mm2s_introut_0]
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins axi_dma_0/s2mm_introut] [get_bd_pins s2mm_introut_0]
  connect_bd_net -net axi_dma_1_mm2s_introut [get_bd_pins axi_dma_1/mm2s_introut] [get_bd_pins mm2s_introut_1]
  connect_bd_net -net axi_dma_1_s2mm_introut [get_bd_pins axi_dma_1/s2mm_introut] [get_bd_pins s2mm_introut_1]
  connect_bd_net -net axi_resetn_1 [get_bd_pins axi_resetn] [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins axi_dma_1/axi_resetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins digilent_axi_i2s_0/S_AXIS_MM2S_ARESETN] [get_bd_pins digilent_axi_i2s_0/M_AXIS_S2MM_ARESETN] [get_bd_pins digilent_axi_i2s_0/AXI_L_aresetn]
  connect_bd_net -net digilent_axi_i2s_0_BCLK_O [get_bd_pins digilent_axi_i2s_0/BCLK_O] [get_bd_pins BCLK_O_0]
  connect_bd_net -net digilent_axi_i2s_0_LRCLK1_O [get_bd_pins digilent_axi_i2s_0/LRCLK1_O] [get_bd_pins LRCLK1_O_0]
  connect_bd_net -net digilent_axi_i2s_0_MCLK_O [get_bd_pins digilent_axi_i2s_0/MCLK_O] [get_bd_pins MCLK_O_0]
  connect_bd_net -net digilent_axi_i2s_0_SDATA_O [get_bd_pins digilent_axi_i2s_0/SDATA_O] [get_bd_pins SDATA_O_0]
  connect_bd_net -net edge_detect_0_edge_detected [get_bd_pins edge_detect_0/edge_detected] [get_bd_pins xfft_0/s_axis_config_tvalid]
  connect_bd_net -net m_axi_mm2s_aclk_1 [get_bd_pins m_axi_mm2s_aclk] [get_bd_pins edge_detect_0/clk] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axi_dma_0/m_axi_mm2s_aclk] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] [get_bd_pins axi_dma_1/s_axi_lite_aclk] [get_bd_pins axi_dma_1/m_axi_mm2s_aclk] [get_bd_pins axi_dma_1/m_axi_s2mm_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins digilent_axi_i2s_0/CLK_100MHZ_I] [get_bd_pins digilent_axi_i2s_0/S_AXIS_MM2S_ACLK] [get_bd_pins digilent_axi_i2s_0/M_AXIS_S2MM_ACLK] [get_bd_pins digilent_axi_i2s_0/AXI_L_aclk] [get_bd_pins xfft_0/aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: audio_ss_0
proc create_hier_cell_audio_ss_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_audio_ss_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 axis_audio_in

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 axis_audio_out


  # Create pins
  create_bd_pin -dir I -type clk ACLK
  create_bd_pin -dir I -type rst ARESETN
  create_bd_pin -dir I -from 19 -to 0 aud_acr_cts_in
  create_bd_pin -dir O -from 19 -to 0 aud_acr_cts_out
  create_bd_pin -dir I -from 19 -to 0 aud_acr_n_in
  create_bd_pin -dir O -from 19 -to 0 aud_acr_n_out
  create_bd_pin -dir I aud_acr_valid_in
  create_bd_pin -dir O aud_acr_valid_out
  create_bd_pin -dir O aud_rstn
  create_bd_pin -dir O -type clk audio_clk
  create_bd_pin -dir I -type clk hdmi_clk

  # Create instance: aud_pat_gen, and set properties
  set block_name aud_pat_gen
  set block_cell_name aud_pat_gen
  if { [catch {set aud_pat_gen [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $aud_pat_gen eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: hdmi_acr_ctrl, and set properties
  set block_name hdmi_acr_ctrl
  set block_cell_name hdmi_acr_ctrl
  if { [catch {set hdmi_acr_ctrl [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $hdmi_acr_ctrl eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axi_interconnect, and set properties
  set axi_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect axi_interconnect ]
  set_property CONFIG.NUM_MI {3} $axi_interconnect


  # Create instance: clk_wiz, and set properties
  set clk_wiz [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz clk_wiz ]
  set_property -dict [list \
    CONFIG.CLKIN1_JITTER_PS {100.0} \
    CONFIG.CLKOUT1_JITTER {115.831} \
    CONFIG.CLKOUT1_PHASE_ERROR {87.180} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {12.000} \
    CONFIG.MMCM_CLKIN1_PERIOD {10.000} \
    CONFIG.MMCM_CLKIN2_PERIOD {10.000} \
    CONFIG.PRIM_SOURCE {No_buffer} \
    CONFIG.USE_DYN_RECONFIG {true} \
  ] $clk_wiz


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins axis_audio_in] [get_bd_intf_pins aud_pat_gen/axis_audio_in]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins axis_audio_out] [get_bd_intf_pins aud_pat_gen/axis_audio_out]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S00_AXI] [get_bd_intf_pins axi_interconnect/S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins aud_pat_gen/axi] [get_bd_intf_pins axi_interconnect/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect/M01_AXI] [get_bd_intf_pins hdmi_acr_ctrl/axi]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_interconnect/M02_AXI] [get_bd_intf_pins clk_wiz/s_axi_lite]

  # Create port connections
  connect_bd_net -net ACLK_1 [get_bd_pins ACLK] [get_bd_pins aud_pat_gen/axi_aclk] [get_bd_pins hdmi_acr_ctrl/axi_aclk] [get_bd_pins axi_interconnect/ACLK] [get_bd_pins axi_interconnect/S00_ACLK] [get_bd_pins axi_interconnect/M00_ACLK] [get_bd_pins axi_interconnect/M01_ACLK] [get_bd_pins axi_interconnect/M02_ACLK] [get_bd_pins clk_wiz/s_axi_aclk] [get_bd_pins clk_wiz/clk_in1]
  connect_bd_net -net ARESETN_1 [get_bd_pins ARESETN] [get_bd_pins aud_pat_gen/axi_aresetn] [get_bd_pins hdmi_acr_ctrl/axi_aresetn] [get_bd_pins axi_interconnect/ARESETN] [get_bd_pins axi_interconnect/S00_ARESETN] [get_bd_pins axi_interconnect/M00_ARESETN] [get_bd_pins axi_interconnect/M01_ARESETN] [get_bd_pins axi_interconnect/M02_ARESETN] [get_bd_pins clk_wiz/s_axi_aresetn]
  connect_bd_net -net aud_acr_cts_in_0_1 [get_bd_pins aud_acr_cts_in] [get_bd_pins hdmi_acr_ctrl/aud_acr_cts_in]
  connect_bd_net -net aud_acr_n_in_0_1 [get_bd_pins aud_acr_n_in] [get_bd_pins hdmi_acr_ctrl/aud_acr_n_in]
  connect_bd_net -net aud_acr_valid_in_0_1 [get_bd_pins aud_acr_valid_in] [get_bd_pins hdmi_acr_ctrl/aud_acr_valid_in]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz/clk_out1] [get_bd_pins audio_clk] [get_bd_pins aud_pat_gen/aud_clk] [get_bd_pins aud_pat_gen/axis_clk] [get_bd_pins hdmi_acr_ctrl/aud_clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz/locked] [get_bd_pins hdmi_acr_ctrl/pll_lock_in]
  connect_bd_net -net hdmi_acr_ctrl_0_aud_acr_cts_out [get_bd_pins hdmi_acr_ctrl/aud_acr_cts_out] [get_bd_pins aud_acr_cts_out]
  connect_bd_net -net hdmi_acr_ctrl_0_aud_acr_n_out [get_bd_pins hdmi_acr_ctrl/aud_acr_n_out] [get_bd_pins aud_acr_n_out]
  connect_bd_net -net hdmi_acr_ctrl_0_aud_acr_valid_out [get_bd_pins hdmi_acr_ctrl/aud_acr_valid_out] [get_bd_pins aud_acr_valid_out]
  connect_bd_net -net hdmi_acr_ctrl_0_aud_resetn_out [get_bd_pins hdmi_acr_ctrl/aud_resetn_out] [get_bd_pins aud_rstn] [get_bd_pins aud_pat_gen/axis_resetn]
  connect_bd_net -net hdmi_clk_0_1 [get_bd_pins hdmi_clk] [get_bd_pins hdmi_acr_ctrl/hdmi_clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set PG_VADJ_R [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 PG_VADJ_R ]

  set UART_CTL [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART_CTL ]

  set aud [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 aud ]

  set ffc_a [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 ffc_a ]

  set ffc_a1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 ffc_a1 ]

  set ffc_b [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 ffc_b ]

  set ffc_b1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 ffc_b1 ]

  set fmc_la_00_n [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 fmc_la_00_n ]

  set fmc_la_00_p [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 fmc_la_00_p ]

  set fmc_la_01_n [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 fmc_la_01_n ]

  set fmc_la_01_p [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 fmc_la_01_p ]

  set fmc_prsnt [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 fmc_prsnt ]

  set gpio_emio [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_emio ]

  set gpio_sfp [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_sfp ]

  set hdmi_rx_ddc [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 hdmi_rx_ddc ]

  set hdmi_tx_i2c [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 hdmi_tx_i2c ]

  set mux [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 mux ]

  set pl_buttons [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 pl_buttons ]

  set pl_leds [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 pl_leds ]

  set pl_switches [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 pl_switches ]

  set pmod [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 pmod ]

  set pmod2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 pmod2 ]

  set syzygy_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 syzygy_1 ]

  set syzygy_2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 syzygy_2 ]

  set syzygy_detectedn [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 syzygy_detectedn ]

  set vadj_set [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 vadj_set ]


  # Create ports
  set aud_adc_sdata [ create_bd_port -dir I aud_adc_sdata ]
  set aud_bclk [ create_bd_port -dir O aud_bclk ]
  set aud_dac_sdata [ create_bd_port -dir O aud_dac_sdata ]
  set aud_lrclk [ create_bd_port -dir O aud_lrclk ]
  set aud_mclk [ create_bd_port -dir O aud_mclk ]
  set clkgth_loln_ls [ create_bd_port -dir I clkgth_loln_ls ]
  set dp_aux_din [ create_bd_port -dir I dp_aux_din ]
  set dp_aux_doe [ create_bd_port -dir O -from 0 -to 0 dp_aux_doe ]
  set dp_aux_dout [ create_bd_port -dir O dp_aux_dout ]
  set dp_aux_hotplug_detect [ create_bd_port -dir I dp_aux_hotplug_detect ]
  set hdmi_rec_clk_n [ create_bd_port -dir O -type clk hdmi_rec_clk_n ]
  set hdmi_rec_clk_p [ create_bd_port -dir O -type clk hdmi_rec_clk_p ]
  set hdmi_rx_5v_detn [ create_bd_port -dir I hdmi_rx_5v_detn ]
  set hdmi_rx_hpd [ create_bd_port -dir O hdmi_rx_hpd ]
  set hdmi_tx_clk_c_n [ create_bd_port -dir O -type clk hdmi_tx_clk_c_n ]
  set hdmi_tx_clk_c_p [ create_bd_port -dir O -type clk hdmi_tx_clk_c_p ]
  set hdmi_tx_hpd [ create_bd_port -dir I hdmi_tx_hpd ]
  set hdmi_tx_oe [ create_bd_port -dir O -from 0 -to 0 hdmi_tx_oe ]
  set mgtrefclk0_pad_n_in_0 [ create_bd_port -dir I -type clk mgtrefclk0_pad_n_in_0 ]
  set mgtrefclk0_pad_p_in_0 [ create_bd_port -dir I -type clk mgtrefclk0_pad_p_in_0 ]
  set mgtrefclk1_pad_n_in_0 [ create_bd_port -dir I -type clk mgtrefclk1_pad_n_in_0 ]
  set mgtrefclk1_pad_p_in_0 [ create_bd_port -dir I -type clk mgtrefclk1_pad_p_in_0 ]
  set phy_rxn_in_0 [ create_bd_port -dir I -from 2 -to 0 phy_rxn_in_0 ]
  set phy_rxp_in_0 [ create_bd_port -dir I -from 2 -to 0 phy_rxp_in_0 ]
  set phy_txn_out_0 [ create_bd_port -dir O -from 2 -to 0 phy_txn_out_0 ]
  set phy_txp_out_0 [ create_bd_port -dir O -from 2 -to 0 phy_txp_out_0 ]
  set pl_rgb_led [ create_bd_port -dir O -from 2 -to 0 pl_rgb_led ]

  # Create instance: audio_ss_0
  create_hier_cell_audio_ss_0 [current_bd_instance .] audio_ss_0

  # Create instance: audio_test
  create_hier_cell_audio_test [current_bd_instance .] audio_test

  # Create instance: set_vadj_level
  create_hier_cell_set_vadj_level [current_bd_instance .] set_vadj_level

  # Create instance: short_loopback_tests
  create_hier_cell_short_loopback_tests [current_bd_instance .] short_loopback_tests

  # Create instance: uio
  create_hier_cell_uio [current_bd_instance .] uio

  # Create instance: v_tpg_ss_0
  create_hier_cell_v_tpg_ss_0 [current_bd_instance .] v_tpg_ss_0

  # Create instance: rst_ps8_0_100M, and set properties
  set rst_ps8_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset rst_ps8_0_100M ]

  # Create instance: rst_ps8_0_50M, and set properties
  set rst_ps8_0_50M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset rst_ps8_0_50M ]

  # Create instance: Control_SI5342_LOLN, and set properties
  set Control_SI5342_LOLN [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio Control_SI5342_LOLN ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
  ] $Control_SI5342_LOLN


  # Create instance: OR_LOGIC, and set properties
  set OR_LOGIC [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic OR_LOGIC ]
  set_property -dict [list \
    CONFIG.C_OPERATION {or} \
    CONFIG.C_SIZE {1} \
  ] $OR_LOGIC


  # Create instance: axi_iic_0, and set properties
  set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic axi_iic_0 ]

  # Create instance: axi_iic_1, and set properties
  set axi_iic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic axi_iic_1 ]

  # Create instance: axi_smc, and set properties
  set axi_smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect axi_smc ]
  set_property CONFIG.NUM_SI {4} $axi_smc


  # Create instance: gpio_sfp_ip, and set properties
  set gpio_sfp_ip [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio gpio_sfp_ip ]
  set_property CONFIG.C_GPIO_WIDTH {6} $gpio_sfp_ip


  # Create instance: ps8_0_axi_periph, and set properties
  set ps8_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect ps8_0_axi_periph ]
  set_property CONFIG.NUM_MI {29} $ps8_0_axi_periph


  # Create instance: rx_video_axis_reg_slice, and set properties
  set rx_video_axis_reg_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice rx_video_axis_reg_slice ]

  # Create instance: tx_video_axis_reg_slice, and set properties
  set tx_video_axis_reg_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice tx_video_axis_reg_slice ]

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic util_vector_logic_0 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_0


  # Create instance: v_hdmi_rx_ss_0, and set properties
  set v_hdmi_rx_ss_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_hdmi_rx_ss v_hdmi_rx_ss_0 ]
  set_property -dict [list \
    CONFIG.C_ADD_MARK_DBG {0} \
    CONFIG.C_CD_INVERT {true} \
    CONFIG.C_EXDES_AXILITE_FREQ {50} \
    CONFIG.C_EXDES_TOPOLOGY {0} \
    CONFIG.C_EXDES_TX_PLL_SELECTION {6} \
    CONFIG.C_INCLUDE_LOW_RESO_VID {false} \
    CONFIG.C_INCLUDE_YUV420_SUP {false} \
    CONFIG.C_INPUT_PIXELS_PER_CLOCK {4} \
    CONFIG.C_VID_INTERFACE {0} \
  ] $v_hdmi_rx_ss_0


  # Create instance: v_hdmi_tx_ss_0, and set properties
  set v_hdmi_tx_ss_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_hdmi_tx_ss v_hdmi_tx_ss_0 ]
  set_property -dict [list \
    CONFIG.C_ADD_MARK_DBG {0} \
    CONFIG.C_EXDES_AXILITE_FREQ {50} \
    CONFIG.C_EXDES_NIDRU {true} \
    CONFIG.C_EXDES_TOPOLOGY {0} \
    CONFIG.C_EXDES_TX_PLL_SELECTION {6} \
    CONFIG.C_INCLUDE_LOW_RESO_VID {false} \
    CONFIG.C_INCLUDE_YUV420_SUP {false} \
    CONFIG.C_INPUT_PIXELS_PER_CLOCK {4} \
    CONFIG.C_VID_INTERFACE {0} \
  ] $v_hdmi_tx_ss_0


  # Create instance: vid_phy_controller_0, and set properties
  set vid_phy_controller_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:vid_phy_controller vid_phy_controller_0 ]
  set_property -dict [list \
    CONFIG.CHANNEL_ENABLE {X0Y4 X0Y5 X0Y6} \
    CONFIG.C_INPUT_PIXELS_PER_CLOCK {4} \
    CONFIG.C_NIDRU {false} \
    CONFIG.C_RX_PLL_SELECTION {0} \
    CONFIG.C_RX_REFCLK_SEL {1} \
    CONFIG.C_Rx_Protocol {HDMI} \
    CONFIG.C_TX_PLL_SELECTION {6} \
    CONFIG.C_TX_REFCLK_SEL {0} \
    CONFIG.C_Tx_Protocol {HDMI} \
    CONFIG.C_Txrefclk_Rdy_Invert {false} \
    CONFIG.C_Use_Oddr_for_Tmds_Clkout {true} \
    CONFIG.C_vid_phy_rx_axi4s_ch_INT_TDATA_WIDTH {40} \
    CONFIG.C_vid_phy_rx_axi4s_ch_TDATA_WIDTH {40} \
    CONFIG.C_vid_phy_rx_axi4s_ch_TUSER_WIDTH {1} \
    CONFIG.C_vid_phy_tx_axi4s_ch_INT_TDATA_WIDTH {40} \
    CONFIG.C_vid_phy_tx_axi4s_ch_TDATA_WIDTH {40} \
    CONFIG.C_vid_phy_tx_axi4s_ch_TUSER_WIDTH {1} \
    CONFIG.Rx_GT_Line_Rate {5.94} \
    CONFIG.Rx_GT_Ref_Clock_Freq {297} \
    CONFIG.Tx_GT_Line_Rate {5.94} \
    CONFIG.Tx_GT_Ref_Clock_Freq {297} \
    CONFIG.check_pll_selection {0} \
  ] $vid_phy_controller_0


  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_0 ]
  set_property CONFIG.NUM_PORTS {8} $xlconcat_0


  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_1 ]
  set_property CONFIG.NUM_PORTS {3} $xlconcat_1


  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant xlconstant_0 ]

  # Create instance: zynq_ultra_ps_e_0, and set properties
  set zynq_ultra_ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e zynq_ultra_ps_e_0 ]
  set_property -dict [list \
    CONFIG.CAN0_BOARD_INTERFACE {custom} \
    CONFIG.CAN1_BOARD_INTERFACE {custom} \
    CONFIG.CSU_BOARD_INTERFACE {custom} \
    CONFIG.DP_BOARD_INTERFACE {custom} \
    CONFIG.GEM0_BOARD_INTERFACE {custom} \
    CONFIG.GEM1_BOARD_INTERFACE {custom} \
    CONFIG.GEM2_BOARD_INTERFACE {custom} \
    CONFIG.GEM3_BOARD_INTERFACE {custom} \
    CONFIG.GPIO_BOARD_INTERFACE {custom} \
    CONFIG.IIC0_BOARD_INTERFACE {custom} \
    CONFIG.IIC1_BOARD_INTERFACE {custom} \
    CONFIG.NAND_BOARD_INTERFACE {custom} \
    CONFIG.PCIE_BOARD_INTERFACE {custom} \
    CONFIG.PJTAG_BOARD_INTERFACE {custom} \
    CONFIG.PMU_BOARD_INTERFACE {custom} \
    CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS33} \
    CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS18} \
    CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS18} \
    CONFIG.PSU_BANK_3_IO_STANDARD {LVCMOS33} \
    CONFIG.PSU_DDR_RAM_HIGHADDR {0xFFFFFFFF} \
    CONFIG.PSU_DDR_RAM_HIGHADDR_OFFSET {0x800000000} \
    CONFIG.PSU_DDR_RAM_LOWADDR_OFFSET {0x80000000} \
    CONFIG.PSU_DYNAMIC_DDR_CONFIG_EN {1} \
    CONFIG.PSU_IMPORT_BOARD_PRESET {} \
    CONFIG.PSU_MIO_0_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_0_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_0_SLEW {slow} \
    CONFIG.PSU_MIO_10_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_10_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_10_POLARITY {Default} \
    CONFIG.PSU_MIO_10_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_10_SLEW {slow} \
    CONFIG.PSU_MIO_11_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_11_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_11_POLARITY {Default} \
    CONFIG.PSU_MIO_11_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_11_SLEW {slow} \
    CONFIG.PSU_MIO_12_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_12_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_12_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_12_SLEW {slow} \
    CONFIG.PSU_MIO_13_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_13_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_13_POLARITY {Default} \
    CONFIG.PSU_MIO_13_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_13_SLEW {slow} \
    CONFIG.PSU_MIO_14_DRIVE_STRENGTH {4} \
    CONFIG.PSU_MIO_14_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_14_SLEW {slow} \
    CONFIG.PSU_MIO_15_DRIVE_STRENGTH {4} \
    CONFIG.PSU_MIO_15_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_15_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_15_SLEW {slow} \
    CONFIG.PSU_MIO_16_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_16_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_16_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_16_SLEW {slow} \
    CONFIG.PSU_MIO_17_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_17_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_17_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_17_SLEW {slow} \
    CONFIG.PSU_MIO_18_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_18_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_19_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_19_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_19_SLEW {slow} \
    CONFIG.PSU_MIO_1_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_1_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_1_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_1_SLEW {fast} \
    CONFIG.PSU_MIO_20_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_20_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_20_POLARITY {Default} \
    CONFIG.PSU_MIO_20_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_20_SLEW {slow} \
    CONFIG.PSU_MIO_21_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_21_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_21_POLARITY {Default} \
    CONFIG.PSU_MIO_21_PULLUPDOWN {pulldown} \
    CONFIG.PSU_MIO_21_SLEW {fast} \
    CONFIG.PSU_MIO_22_DRIVE_STRENGTH {4} \
    CONFIG.PSU_MIO_22_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_22_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_22_SLEW {slow} \
    CONFIG.PSU_MIO_23_DRIVE_STRENGTH {4} \
    CONFIG.PSU_MIO_23_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_23_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_23_SLEW {slow} \
    CONFIG.PSU_MIO_24_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_24_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_24_POLARITY {Default} \
    CONFIG.PSU_MIO_24_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_24_SLEW {slow} \
    CONFIG.PSU_MIO_25_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_25_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_25_POLARITY {Default} \
    CONFIG.PSU_MIO_25_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_25_SLEW {slow} \
    CONFIG.PSU_MIO_26_DRIVE_STRENGTH {8} \
    CONFIG.PSU_MIO_26_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_26_SLEW {slow} \
    CONFIG.PSU_MIO_27_DRIVE_STRENGTH {8} \
    CONFIG.PSU_MIO_27_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_27_SLEW {slow} \
    CONFIG.PSU_MIO_28_DRIVE_STRENGTH {8} \
    CONFIG.PSU_MIO_28_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_28_SLEW {slow} \
    CONFIG.PSU_MIO_29_DRIVE_STRENGTH {8} \
    CONFIG.PSU_MIO_29_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_29_SLEW {slow} \
    CONFIG.PSU_MIO_2_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_2_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_2_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_2_SLEW {fast} \
    CONFIG.PSU_MIO_30_DRIVE_STRENGTH {8} \
    CONFIG.PSU_MIO_30_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_30_SLEW {slow} \
    CONFIG.PSU_MIO_31_DRIVE_STRENGTH {8} \
    CONFIG.PSU_MIO_31_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_31_SLEW {slow} \
    CONFIG.PSU_MIO_32_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_32_PULLUPDOWN {pulldown} \
    CONFIG.PSU_MIO_33_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_33_PULLUPDOWN {pulldown} \
    CONFIG.PSU_MIO_34_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_34_PULLUPDOWN {pulldown} \
    CONFIG.PSU_MIO_35_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_35_PULLUPDOWN {pulldown} \
    CONFIG.PSU_MIO_36_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_36_PULLUPDOWN {pulldown} \
    CONFIG.PSU_MIO_37_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_37_PULLUPDOWN {pulldown} \
    CONFIG.PSU_MIO_38_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_38_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_38_POLARITY {Default} \
    CONFIG.PSU_MIO_38_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_38_SLEW {slow} \
    CONFIG.PSU_MIO_39_DRIVE_STRENGTH {4} \
    CONFIG.PSU_MIO_39_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_39_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_39_SLEW {slow} \
    CONFIG.PSU_MIO_3_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_3_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_3_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_3_SLEW {fast} \
    CONFIG.PSU_MIO_40_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_40_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_40_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_40_SLEW {fast} \
    CONFIG.PSU_MIO_41_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_41_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_41_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_41_SLEW {fast} \
    CONFIG.PSU_MIO_42_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_42_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_42_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_42_SLEW {fast} \
    CONFIG.PSU_MIO_43_DRIVE_STRENGTH {4} \
    CONFIG.PSU_MIO_43_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_43_SLEW {slow} \
    CONFIG.PSU_MIO_44_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_44_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_44_POLARITY {Default} \
    CONFIG.PSU_MIO_44_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_44_SLEW {slow} \
    CONFIG.PSU_MIO_45_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_45_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_46_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_46_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_46_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_46_SLEW {fast} \
    CONFIG.PSU_MIO_47_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_47_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_47_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_47_SLEW {fast} \
    CONFIG.PSU_MIO_48_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_48_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_48_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_48_SLEW {fast} \
    CONFIG.PSU_MIO_49_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_49_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_49_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_49_SLEW {fast} \
    CONFIG.PSU_MIO_4_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_4_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_4_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_4_SLEW {fast} \
    CONFIG.PSU_MIO_50_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_50_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_50_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_50_SLEW {fast} \
    CONFIG.PSU_MIO_51_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_51_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_51_SLEW {fast} \
    CONFIG.PSU_MIO_52_INPUT_TYPE {schmitt} \
    CONFIG.PSU_MIO_52_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_53_INPUT_TYPE {schmitt} \
    CONFIG.PSU_MIO_53_PULLUPDOWN {pulldown} \
    CONFIG.PSU_MIO_54_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_54_INPUT_TYPE {schmitt} \
    CONFIG.PSU_MIO_54_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_54_SLEW {fast} \
    CONFIG.PSU_MIO_55_INPUT_TYPE {schmitt} \
    CONFIG.PSU_MIO_55_PULLUPDOWN {pulldown} \
    CONFIG.PSU_MIO_56_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_56_INPUT_TYPE {schmitt} \
    CONFIG.PSU_MIO_56_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_56_SLEW {fast} \
    CONFIG.PSU_MIO_57_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_57_INPUT_TYPE {schmitt} \
    CONFIG.PSU_MIO_57_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_57_SLEW {fast} \
    CONFIG.PSU_MIO_58_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_58_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_58_SLEW {fast} \
    CONFIG.PSU_MIO_59_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_59_INPUT_TYPE {schmitt} \
    CONFIG.PSU_MIO_59_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_59_SLEW {fast} \
    CONFIG.PSU_MIO_5_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_5_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_5_SLEW {fast} \
    CONFIG.PSU_MIO_60_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_60_INPUT_TYPE {schmitt} \
    CONFIG.PSU_MIO_60_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_60_SLEW {fast} \
    CONFIG.PSU_MIO_61_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_61_INPUT_TYPE {schmitt} \
    CONFIG.PSU_MIO_61_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_61_SLEW {fast} \
    CONFIG.PSU_MIO_62_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_62_INPUT_TYPE {schmitt} \
    CONFIG.PSU_MIO_62_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_62_SLEW {fast} \
    CONFIG.PSU_MIO_63_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_63_INPUT_TYPE {schmitt} \
    CONFIG.PSU_MIO_63_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_63_SLEW {fast} \
    CONFIG.PSU_MIO_64_INPUT_TYPE {schmitt} \
    CONFIG.PSU_MIO_64_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_65_INPUT_TYPE {schmitt} \
    CONFIG.PSU_MIO_65_PULLUPDOWN {pulldown} \
    CONFIG.PSU_MIO_66_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_66_INPUT_TYPE {schmitt} \
    CONFIG.PSU_MIO_66_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_66_SLEW {fast} \
    CONFIG.PSU_MIO_67_INPUT_TYPE {schmitt} \
    CONFIG.PSU_MIO_67_PULLUPDOWN {pulldown} \
    CONFIG.PSU_MIO_68_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_68_INPUT_TYPE {schmitt} \
    CONFIG.PSU_MIO_68_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_68_SLEW {fast} \
    CONFIG.PSU_MIO_69_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_69_INPUT_TYPE {schmitt} \
    CONFIG.PSU_MIO_69_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_69_SLEW {fast} \
    CONFIG.PSU_MIO_6_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_6_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_6_SLEW {fast} \
    CONFIG.PSU_MIO_70_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_70_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_70_SLEW {fast} \
    CONFIG.PSU_MIO_71_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_71_INPUT_TYPE {schmitt} \
    CONFIG.PSU_MIO_71_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_71_SLEW {fast} \
    CONFIG.PSU_MIO_72_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_72_INPUT_TYPE {schmitt} \
    CONFIG.PSU_MIO_72_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_72_SLEW {fast} \
    CONFIG.PSU_MIO_73_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_73_INPUT_TYPE {schmitt} \
    CONFIG.PSU_MIO_73_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_73_SLEW {fast} \
    CONFIG.PSU_MIO_74_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_74_INPUT_TYPE {schmitt} \
    CONFIG.PSU_MIO_74_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_74_SLEW {fast} \
    CONFIG.PSU_MIO_75_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_75_INPUT_TYPE {schmitt} \
    CONFIG.PSU_MIO_75_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_75_SLEW {fast} \
    CONFIG.PSU_MIO_76_DRIVE_STRENGTH {4} \
    CONFIG.PSU_MIO_76_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_76_SLEW {slow} \
    CONFIG.PSU_MIO_77_DRIVE_STRENGTH {4} \
    CONFIG.PSU_MIO_77_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_77_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_77_SLEW {slow} \
    CONFIG.PSU_MIO_7_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_7_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_7_SLEW {slow} \
    CONFIG.PSU_MIO_8_DRIVE_STRENGTH {4} \
    CONFIG.PSU_MIO_8_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_8_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_8_SLEW {slow} \
    CONFIG.PSU_MIO_9_DRIVE_STRENGTH {4} \
    CONFIG.PSU_MIO_9_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_9_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_9_SLEW {slow} \
    CONFIG.PSU_MIO_TREE_PERIPHERALS {Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Feedback Clk#PCIE#I2C 1#I2C 1#GPIO0 MIO#GPIO0 MIO#SPI 0#GPIO0 MIO#SPI 0#SPI\
0#SPI 0#SPI 0#UART 0#UART 0#GPIO0 MIO#GPIO0 MIO#I2C 0#I2C 0#GPIO0 MIO#GPIO0 MIO#Gem 0#Gem 0#Gem 0#Gem 0#Gem 0#Gem 0#Gem 0#Gem 0#Gem 0#Gem 0#Gem 0#Gem 0#GPIO1 MIO#SD 1#SD 1#SD 1#SD 1#SD 1#GPIO1 MIO#SD 1#SD\
1#SD 1#SD 1#SD 1#SD 1#SD 1#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#MDIO 0#MDIO 0} \
    CONFIG.PSU_MIO_TREE_SIGNALS {sclk_out#miso_mo1#mo2#mo3#mosi_mi0#n_ss_out#clk_for_lpbk#reset_n#scl_out#sda_out#gpio0[10]#gpio0[11]#sclk_out#gpio0[13]#n_ss_out[1]#n_ss_out[0]#miso#mosi#rxd#txd#gpio0[20]#gpio0[21]#scl_out#sda_out#gpio0[24]#gpio0[25]#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#gpio1[38]#sdio1_data_out[4]#sdio1_data_out[5]#sdio1_data_out[6]#sdio1_data_out[7]#sdio1_bus_pow#gpio1[44]#sdio1_cd_n#sdio1_data_out[0]#sdio1_data_out[1]#sdio1_data_out[2]#sdio1_data_out[3]#sdio1_cmd_out#sdio1_clk_out#ulpi_clk_in#ulpi_dir#ulpi_tx_data[2]#ulpi_nxt#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_stp#ulpi_tx_data[3]#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#ulpi_clk_in#ulpi_dir#ulpi_tx_data[2]#ulpi_nxt#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_stp#ulpi_tx_data[3]#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#gem0_mdc#gem0_mdio_out}\
\
    CONFIG.PSU_PERIPHERAL_BOARD_PRESET {} \
    CONFIG.PSU_SD0_INTERNAL_BUS_WIDTH {8} \
    CONFIG.PSU_SD1_INTERNAL_BUS_WIDTH {8} \
    CONFIG.PSU_SMC_CYCLE_T0 {NA} \
    CONFIG.PSU_SMC_CYCLE_T1 {NA} \
    CONFIG.PSU_SMC_CYCLE_T2 {NA} \
    CONFIG.PSU_SMC_CYCLE_T3 {NA} \
    CONFIG.PSU_SMC_CYCLE_T4 {NA} \
    CONFIG.PSU_SMC_CYCLE_T5 {NA} \
    CONFIG.PSU_SMC_CYCLE_T6 {NA} \
    CONFIG.PSU_USB3__DUAL_CLOCK_ENABLE {1} \
    CONFIG.PSU_VALUE_SILVERSION {3} \
    CONFIG.PSU__ACPU0__POWER__ON {1} \
    CONFIG.PSU__ACPU1__POWER__ON {1} \
    CONFIG.PSU__ACPU2__POWER__ON {1} \
    CONFIG.PSU__ACPU3__POWER__ON {1} \
    CONFIG.PSU__ACTUAL__IP {1} \
    CONFIG.PSU__ACT_DDR_FREQ_MHZ {1065.000000} \
    CONFIG.PSU__AUX_REF_CLK__FREQMHZ {33.333} \
    CONFIG.PSU__CAN0_LOOP_CAN1__ENABLE {0} \
    CONFIG.PSU__CAN0__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__CAN1__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__CRF_APB__ACPU_CTRL__ACT_FREQMHZ {1200.000000} \
    CONFIG.PSU__CRF_APB__ACPU_CTRL__FREQMHZ {1200} \
    CONFIG.PSU__CRF_APB__ACPU_CTRL__SRCSEL {APLL} \
    CONFIG.PSU__CRF_APB__ACPU__FRAC_ENABLED {0} \
    CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__ACT_FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__DIVISOR0 {2} \
    CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__AFI0_REF__ENABLE {0} \
    CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__ACT_FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__DIVISOR0 {2} \
    CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__AFI1_REF__ENABLE {0} \
    CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__ACT_FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__DIVISOR0 {2} \
    CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__AFI2_REF__ENABLE {0} \
    CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__ACT_FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__DIVISOR0 {2} \
    CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__AFI3_REF__ENABLE {0} \
    CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__ACT_FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__DIVISOR0 {2} \
    CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__AFI4_REF__ENABLE {0} \
    CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__ACT_FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__DIVISOR0 {2} \
    CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__AFI5_REF__ENABLE {0} \
    CONFIG.PSU__CRF_APB__APLL_CTRL__FRACFREQ {1200} \
    CONFIG.PSU__CRF_APB__APLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRF_APB__APM_CTRL__ACT_FREQMHZ {1} \
    CONFIG.PSU__CRF_APB__APM_CTRL__DIVISOR0 {1} \
    CONFIG.PSU__CRF_APB__APM_CTRL__FREQMHZ {1} \
    CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__ACT_FREQMHZ {250.000000} \
    CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__ACT_FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__ACT_FREQMHZ {250.000000} \
    CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__DDR_CTRL__ACT_FREQMHZ {532.500000} \
    CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {1066} \
    CONFIG.PSU__CRF_APB__DDR_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__ACT_FREQMHZ {600.000000} \
    CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__FREQMHZ {600} \
    CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__SRCSEL {APLL} \
    CONFIG.PSU__CRF_APB__DPLL_CTRL__FRACFREQ {27.138} \
    CONFIG.PSU__CRF_APB__DPLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__ACT_FREQMHZ {24.843750} \
    CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__FREQMHZ {25} \
    CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRF_APB__DP_AUDIO__FRAC_ENABLED {0} \
    CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__ACT_FREQMHZ {26.500000} \
    CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__FREQMHZ {27} \
    CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__ACT_FREQMHZ {300.000000} \
    CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__FREQMHZ {300} \
    CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {VPLL} \
    CONFIG.PSU__CRF_APB__DP_VIDEO__FRAC_ENABLED {0} \
    CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__ACT_FREQMHZ {600.000000} \
    CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__FREQMHZ {600} \
    CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__SRCSEL {APLL} \
    CONFIG.PSU__CRF_APB__GPU_REF_CTRL__ACT_FREQMHZ {500.000000} \
    CONFIG.PSU__CRF_APB__GPU_REF_CTRL__FREQMHZ {600} \
    CONFIG.PSU__CRF_APB__GPU_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__ACT_FREQMHZ {-1} \
    CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__DIVISOR0 {-1} \
    CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__FREQMHZ {-1} \
    CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__SRCSEL {NA} \
    CONFIG.PSU__CRF_APB__GTGREF0__ENABLE {NA} \
    CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__ACT_FREQMHZ {250.000000} \
    CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__SATA_REF_CTRL__ACT_FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__ACT_FREQMHZ {532.500000} \
    CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__FREQMHZ {533.33} \
    CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__VPLL_CTRL__FRACFREQ {27.138} \
    CONFIG.PSU__CRF_APB__VPLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__ACT_FREQMHZ {500.000000} \
    CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__ACT_FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__AFI6__ENABLE {0} \
    CONFIG.PSU__CRL_APB__AMS_REF_CTRL__ACT_FREQMHZ {50.000000} \
    CONFIG.PSU__CRL_APB__AMS_REF_CTRL__FREQMHZ {50} \
    CONFIG.PSU__CRL_APB__AMS_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__ACT_FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__ACT_FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__CPU_R5_CTRL__ACT_FREQMHZ {500.000000} \
    CONFIG.PSU__CRL_APB__CPU_R5_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__CPU_R5_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__ACT_FREQMHZ {180} \
    CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__DIVISOR0 {3} \
    CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__SRCSEL {SysOsc} \
    CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__ACT_FREQMHZ {250.000000} \
    CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__ACT_FREQMHZ {1000} \
    CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__DIVISOR0 {6} \
    CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__FREQMHZ {1000} \
    CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRL_APB__DLL_REF_CTRL__ACT_FREQMHZ {1500.000000} \
    CONFIG.PSU__CRL_APB__DLL_REF_CTRL__FREQMHZ {1500} \
    CONFIG.PSU__CRL_APB__DLL_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__ACT_FREQMHZ {125.000000} \
    CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__ACT_FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__ACT_FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__ACT_FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__ACT_FREQMHZ {250.000000} \
    CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__IOPLL_CTRL__FRACFREQ {27.138} \
    CONFIG.PSU__CRL_APB__IOPLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__ACT_FREQMHZ {265.000000} \
    CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__FREQMHZ {267} \
    CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__ACT_FREQMHZ {500.000000} \
    CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__NAND_REF_CTRL__ACT_FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__NAND_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__NAND_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__ACT_FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__DIVISOR0 {3} \
    CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__PCAP_CTRL__ACT_FREQMHZ {187.500000} \
    CONFIG.PSU__CRL_APB__PCAP_CTRL__FREQMHZ {200} \
    CONFIG.PSU__CRL_APB__PCAP_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__ACT_FREQMHZ {250.000000} \
    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__PL2_REF_CTRL__ACT_FREQMHZ {150.000000} \
    CONFIG.PSU__CRL_APB__PL2_REF_CTRL__FREQMHZ {150} \
    CONFIG.PSU__CRL_APB__PL2_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__PL3_REF_CTRL__ACT_FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__ACT_FREQMHZ {250.000000} \
    CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__RPLL_CTRL__FRACFREQ {25} \
    CONFIG.PSU__CRL_APB__RPLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__ACT_FREQMHZ {200} \
    CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__FREQMHZ {200} \
    CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__ACT_FREQMHZ {187.500000} \
    CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__FREQMHZ {200} \
    CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__ACT_FREQMHZ {198.750000} \
    CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__FREQMHZ {200} \
    CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__ACT_FREQMHZ {214} \
    CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__FREQMHZ {200} \
    CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__ACT_FREQMHZ {30.000000} \
    CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRL_APB__UART0_REF_CTRL__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__CRL_APB__UART0_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__UART0_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__UART1_REF_CTRL__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__CRL_APB__UART1_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__UART1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__ACT_FREQMHZ {250.000000} \
    CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__ACT_FREQMHZ {250.000000} \
    CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__ACT_FREQMHZ {20.000000} \
    CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__FREQMHZ {20} \
    CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__USB3__ENABLE {1} \
    CONFIG.PSU__CSUPMU__PERIPHERAL__VALID {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_0__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_10__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_11__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_12__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_1__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_2__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_3__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_4__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_5__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_6__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_7__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_8__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_9__ENABLE {0} \
    CONFIG.PSU__CSU__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__DDRC__AL {0} \
    CONFIG.PSU__DDRC__BG_ADDR_COUNT {2} \
    CONFIG.PSU__DDRC__BRC_MAPPING {ROW_BANK_COL} \
    CONFIG.PSU__DDRC__BUS_WIDTH {64 Bit} \
    CONFIG.PSU__DDRC__CL {15} \
    CONFIG.PSU__DDRC__CLOCK_STOP_EN {0} \
    CONFIG.PSU__DDRC__COMPONENTS {UDIMM} \
    CONFIG.PSU__DDRC__CWL {14} \
    CONFIG.PSU__DDRC__DDR4_ADDR_MAPPING {0} \
    CONFIG.PSU__DDRC__DDR4_CAL_MODE_ENABLE {0} \
    CONFIG.PSU__DDRC__DDR4_CRC_CONTROL {0} \
    CONFIG.PSU__DDRC__DDR4_MAXPWR_SAVING_EN {0} \
    CONFIG.PSU__DDRC__DDR4_T_REF_MODE {1} \
    CONFIG.PSU__DDRC__DDR4_T_REF_RANGE {Normal (0-85)} \
    CONFIG.PSU__DDRC__DEVICE_CAPACITY {4096 MBits} \
    CONFIG.PSU__DDRC__DM_DBI {DM_NO_DBI} \
    CONFIG.PSU__DDRC__DRAM_WIDTH {8 Bits} \
    CONFIG.PSU__DDRC__ECC {Disabled} \
    CONFIG.PSU__DDRC__ECC_SCRUB {0} \
    CONFIG.PSU__DDRC__ENABLE {1} \
    CONFIG.PSU__DDRC__ENABLE_2T_TIMING {0} \
    CONFIG.PSU__DDRC__ENABLE_DP_SWITCH {0} \
    CONFIG.PSU__DDRC__EN_2ND_CLK {0} \
    CONFIG.PSU__DDRC__FREQ_MHZ {1} \
    CONFIG.PSU__DDRC__LPDDR3_DUALRANK_SDP {0} \
    CONFIG.PSU__DDRC__LP_ASR {manual normal} \
    CONFIG.PSU__DDRC__MEMORY_TYPE {DDR 4} \
    CONFIG.PSU__DDRC__PARITY_ENABLE {0} \
    CONFIG.PSU__DDRC__PER_BANK_REFRESH {0} \
    CONFIG.PSU__DDRC__PHY_DBI_MODE {0} \
    CONFIG.PSU__DDRC__PLL_BYPASS {0} \
    CONFIG.PSU__DDRC__PWR_DOWN_EN {0} \
    CONFIG.PSU__DDRC__RANK_ADDR_COUNT {0} \
    CONFIG.PSU__DDRC__RD_DQS_CENTER {0} \
    CONFIG.PSU__DDRC__ROW_ADDR_COUNT {15} \
    CONFIG.PSU__DDRC__SELF_REF_ABORT {0} \
    CONFIG.PSU__DDRC__SPEED_BIN {DDR4_2133P} \
    CONFIG.PSU__DDRC__STATIC_RD_MODE {0} \
    CONFIG.PSU__DDRC__TRAIN_DATA_EYE {1} \
    CONFIG.PSU__DDRC__TRAIN_READ_GATE {1} \
    CONFIG.PSU__DDRC__TRAIN_WRITE_LEVEL {1} \
    CONFIG.PSU__DDRC__T_FAW {30.0} \
    CONFIG.PSU__DDRC__T_RAS_MIN {33} \
    CONFIG.PSU__DDRC__T_RC {47.06} \
    CONFIG.PSU__DDRC__T_RCD {15} \
    CONFIG.PSU__DDRC__T_RP {15} \
    CONFIG.PSU__DDRC__VIDEO_BUFFER_SIZE {0} \
    CONFIG.PSU__DDRC__VREF {1} \
    CONFIG.PSU__DDR_HIGH_ADDRESS_GUI_ENABLE {1} \
    CONFIG.PSU__DDR_QOS_ENABLE {0} \
    CONFIG.PSU__DDR_QOS_HP0_RDQOS {} \
    CONFIG.PSU__DDR_QOS_HP0_WRQOS {} \
    CONFIG.PSU__DDR_QOS_HP1_RDQOS {} \
    CONFIG.PSU__DDR_QOS_HP1_WRQOS {} \
    CONFIG.PSU__DDR_QOS_HP2_RDQOS {} \
    CONFIG.PSU__DDR_QOS_HP2_WRQOS {} \
    CONFIG.PSU__DDR_QOS_HP3_RDQOS {} \
    CONFIG.PSU__DDR_QOS_HP3_WRQOS {} \
    CONFIG.PSU__DDR_SW_REFRESH_ENABLED {1} \
    CONFIG.PSU__DDR__INTERFACE__FREQMHZ {533.000} \
    CONFIG.PSU__DEVICE_TYPE {EV} \
    CONFIG.PSU__DISPLAYPORT__LANE0__ENABLE {1} \
    CONFIG.PSU__DISPLAYPORT__LANE0__IO {GT Lane3} \
    CONFIG.PSU__DISPLAYPORT__LANE1__ENABLE {1} \
    CONFIG.PSU__DISPLAYPORT__LANE1__IO {GT Lane2} \
    CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__DLL__ISUSED {1} \
    CONFIG.PSU__DPAUX__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__DPAUX__PERIPHERAL__IO {EMIO} \
    CONFIG.PSU__DP__LANE_SEL {Dual Higher} \
    CONFIG.PSU__DP__REF_CLK_FREQ {108} \
    CONFIG.PSU__DP__REF_CLK_SEL {Ref Clk2} \
    CONFIG.PSU__ENABLE__DDR__REFRESH__SIGNALS {0} \
    CONFIG.PSU__ENET0__FIFO__ENABLE {0} \
    CONFIG.PSU__ENET0__GRP_MDIO__ENABLE {1} \
    CONFIG.PSU__ENET0__GRP_MDIO__IO {MIO 76 .. 77} \
    CONFIG.PSU__ENET0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__ENET0__PERIPHERAL__IO {MIO 26 .. 37} \
    CONFIG.PSU__ENET0__PTP__ENABLE {0} \
    CONFIG.PSU__ENET0__TSU__ENABLE {0} \
    CONFIG.PSU__ENET1__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__ENET2__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__EN_AXI_STATUS_PORTS {0} \
    CONFIG.PSU__EN_EMIO_TRACE {0} \
    CONFIG.PSU__EP__IP {0} \
    CONFIG.PSU__EXPAND__CORESIGHT {0} \
    CONFIG.PSU__EXPAND__FPD_SLAVES {0} \
    CONFIG.PSU__EXPAND__GIC {0} \
    CONFIG.PSU__EXPAND__LOWER_LPS_SLAVES {0} \
    CONFIG.PSU__EXPAND__UPPER_LPS_SLAVES {0} \
    CONFIG.PSU__FPDMASTERS_COHERENCY {0} \
    CONFIG.PSU__FPD_SLCR__WDT1__ACT_FREQMHZ {100} \
    CONFIG.PSU__FPD_SLCR__WDT1__FREQMHZ {100} \
    CONFIG.PSU__FPGA_PL0_ENABLE {1} \
    CONFIG.PSU__FPGA_PL1_ENABLE {1} \
    CONFIG.PSU__FPGA_PL2_ENABLE {1} \
    CONFIG.PSU__FPGA_PL3_ENABLE {0} \
    CONFIG.PSU__FP__POWER__ON {1} \
    CONFIG.PSU__FTM__CTI_IN_0 {0} \
    CONFIG.PSU__FTM__CTI_IN_1 {0} \
    CONFIG.PSU__FTM__CTI_IN_2 {0} \
    CONFIG.PSU__FTM__CTI_IN_3 {0} \
    CONFIG.PSU__FTM__CTI_OUT_0 {0} \
    CONFIG.PSU__FTM__CTI_OUT_1 {0} \
    CONFIG.PSU__FTM__CTI_OUT_2 {0} \
    CONFIG.PSU__FTM__CTI_OUT_3 {0} \
    CONFIG.PSU__FTM__GPI {0} \
    CONFIG.PSU__FTM__GPO {0} \
    CONFIG.PSU__GEM0_COHERENCY {0} \
    CONFIG.PSU__GEM0_ROUTE_THROUGH_FPD {0} \
    CONFIG.PSU__GEM__TSU__ENABLE {0} \
    CONFIG.PSU__GEN_IPI_0__MASTER {APU} \
    CONFIG.PSU__GEN_IPI_10__MASTER {NONE} \
    CONFIG.PSU__GEN_IPI_1__MASTER {RPU0} \
    CONFIG.PSU__GEN_IPI_2__MASTER {RPU1} \
    CONFIG.PSU__GEN_IPI_3__MASTER {PMU} \
    CONFIG.PSU__GEN_IPI_4__MASTER {PMU} \
    CONFIG.PSU__GEN_IPI_5__MASTER {PMU} \
    CONFIG.PSU__GEN_IPI_6__MASTER {PMU} \
    CONFIG.PSU__GEN_IPI_7__MASTER {NONE} \
    CONFIG.PSU__GEN_IPI_8__MASTER {NONE} \
    CONFIG.PSU__GEN_IPI_9__MASTER {NONE} \
    CONFIG.PSU__GPIO0_MIO__IO {MIO 0 .. 25} \
    CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__GPIO1_MIO__IO {MIO 26 .. 51} \
    CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__GPIO2_MIO__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__GPIO_EMIO_WIDTH {3} \
    CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__GPIO_EMIO__PERIPHERAL__IO {3} \
    CONFIG.PSU__GPIO_EMIO__WIDTH {[94:0]} \
    CONFIG.PSU__GPU_PP0__POWER__ON {1} \
    CONFIG.PSU__GPU_PP1__POWER__ON {1} \
    CONFIG.PSU__GT_REF_CLK__FREQMHZ {33.333} \
    CONFIG.PSU__GT__LINK_SPEED {HBR} \
    CONFIG.PSU__GT__PRE_EMPH_LVL_4 {0} \
    CONFIG.PSU__GT__VLT_SWNG_LVL_4 {0} \
    CONFIG.PSU__HPM0_FPD__NUM_READ_THREADS {4} \
    CONFIG.PSU__HPM0_FPD__NUM_WRITE_THREADS {4} \
    CONFIG.PSU__HPM0_LPD__NUM_READ_THREADS {4} \
    CONFIG.PSU__HPM0_LPD__NUM_WRITE_THREADS {4} \
    CONFIG.PSU__HPM1_FPD__NUM_READ_THREADS {4} \
    CONFIG.PSU__HPM1_FPD__NUM_WRITE_THREADS {4} \
    CONFIG.PSU__I2C0_LOOP_I2C1__ENABLE {0} \
    CONFIG.PSU__I2C0__GRP_INT__ENABLE {0} \
    CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__I2C0__PERIPHERAL__IO {MIO 22 .. 23} \
    CONFIG.PSU__I2C1__GRP_INT__ENABLE {0} \
    CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 8 .. 9} \
    CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC0_SEL {APB} \
    CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC1_SEL {APB} \
    CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC2_SEL {APB} \
    CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC3_SEL {APB} \
    CONFIG.PSU__IOU_SLCR__TTC0__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__IOU_SLCR__TTC1__ACT_FREQMHZ {100} \
    CONFIG.PSU__IOU_SLCR__TTC1__FREQMHZ {100} \
    CONFIG.PSU__IOU_SLCR__TTC2__ACT_FREQMHZ {100} \
    CONFIG.PSU__IOU_SLCR__TTC2__FREQMHZ {100} \
    CONFIG.PSU__IOU_SLCR__TTC3__ACT_FREQMHZ {100} \
    CONFIG.PSU__IOU_SLCR__TTC3__FREQMHZ {100} \
    CONFIG.PSU__IOU_SLCR__WDT0__ACT_FREQMHZ {100} \
    CONFIG.PSU__IOU_SLCR__WDT0__FREQMHZ {100} \
    CONFIG.PSU__IRQ_P2F_ADMA_CHAN__INT {0} \
    CONFIG.PSU__IRQ_P2F_AIB_AXI__INT {0} \
    CONFIG.PSU__IRQ_P2F_AMS__INT {0} \
    CONFIG.PSU__IRQ_P2F_APM_FPD__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_COMM__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_CPUMNT__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_CTI__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_EXTERR__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_IPI__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_L2ERR__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_PMU__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_REGS__INT {0} \
    CONFIG.PSU__IRQ_P2F_ATB_LPD__INT {0} \
    CONFIG.PSU__IRQ_P2F_CLKMON__INT {0} \
    CONFIG.PSU__IRQ_P2F_DDR_SS__INT {0} \
    CONFIG.PSU__IRQ_P2F_DPDMA__INT {0} \
    CONFIG.PSU__IRQ_P2F_DPORT__INT {0} \
    CONFIG.PSU__IRQ_P2F_EFUSE__INT {0} \
    CONFIG.PSU__IRQ_P2F_ENT0_WAKEUP__INT {0} \
    CONFIG.PSU__IRQ_P2F_ENT0__INT {0} \
    CONFIG.PSU__IRQ_P2F_FPD_APB__INT {0} \
    CONFIG.PSU__IRQ_P2F_FPD_ATB_ERR__INT {0} \
    CONFIG.PSU__IRQ_P2F_FP_WDT__INT {0} \
    CONFIG.PSU__IRQ_P2F_GDMA_CHAN__INT {0} \
    CONFIG.PSU__IRQ_P2F_GPIO__INT {0} \
    CONFIG.PSU__IRQ_P2F_GPU__INT {0} \
    CONFIG.PSU__IRQ_P2F_I2C0__INT {0} \
    CONFIG.PSU__IRQ_P2F_I2C1__INT {0} \
    CONFIG.PSU__IRQ_P2F_LPD_APB__INT {0} \
    CONFIG.PSU__IRQ_P2F_LPD_APM__INT {0} \
    CONFIG.PSU__IRQ_P2F_LP_WDT__INT {0} \
    CONFIG.PSU__IRQ_P2F_OCM_ERR__INT {0} \
    CONFIG.PSU__IRQ_P2F_PCIE_DMA__INT {0} \
    CONFIG.PSU__IRQ_P2F_PCIE_LEGACY__INT {0} \
    CONFIG.PSU__IRQ_P2F_PCIE_MSC__INT {0} \
    CONFIG.PSU__IRQ_P2F_PCIE_MSI__INT {0} \
    CONFIG.PSU__IRQ_P2F_PL_IPI__INT {0} \
    CONFIG.PSU__IRQ_P2F_QSPI__INT {0} \
    CONFIG.PSU__IRQ_P2F_R5_CORE0_ECC_ERR__INT {0} \
    CONFIG.PSU__IRQ_P2F_R5_CORE1_ECC_ERR__INT {0} \
    CONFIG.PSU__IRQ_P2F_RPU_IPI__INT {0} \
    CONFIG.PSU__IRQ_P2F_RPU_PERMON__INT {0} \
    CONFIG.PSU__IRQ_P2F_RTC_ALARM__INT {0} \
    CONFIG.PSU__IRQ_P2F_RTC_SECONDS__INT {0} \
    CONFIG.PSU__IRQ_P2F_SATA__INT {0} \
    CONFIG.PSU__IRQ_P2F_SDIO1_WAKE__INT {0} \
    CONFIG.PSU__IRQ_P2F_SDIO1__INT {0} \
    CONFIG.PSU__IRQ_P2F_SPI0__INT {0} \
    CONFIG.PSU__IRQ_P2F_TTC0__INT0 {0} \
    CONFIG.PSU__IRQ_P2F_TTC0__INT1 {0} \
    CONFIG.PSU__IRQ_P2F_TTC0__INT2 {0} \
    CONFIG.PSU__IRQ_P2F_UART0__INT {0} \
    CONFIG.PSU__IRQ_P2F_UART1__INT {0} \
    CONFIG.PSU__IRQ_P2F_USB3_ENDPOINT__INT0 {0} \
    CONFIG.PSU__IRQ_P2F_USB3_ENDPOINT__INT1 {0} \
    CONFIG.PSU__IRQ_P2F_USB3_OTG__INT0 {0} \
    CONFIG.PSU__IRQ_P2F_USB3_OTG__INT1 {0} \
    CONFIG.PSU__IRQ_P2F_USB3_PMU_WAKEUP__INT {0} \
    CONFIG.PSU__IRQ_P2F_XMPU_FPD__INT {0} \
    CONFIG.PSU__IRQ_P2F_XMPU_LPD__INT {0} \
    CONFIG.PSU__IRQ_P2F__INTF_FPD_SMMU__INT {0} \
    CONFIG.PSU__IRQ_P2F__INTF_PPD_CCI__INT {0} \
    CONFIG.PSU__L2_BANK0__POWER__ON {1} \
    CONFIG.PSU__LPDMA0_COHERENCY {0} \
    CONFIG.PSU__LPDMA1_COHERENCY {0} \
    CONFIG.PSU__LPDMA2_COHERENCY {0} \
    CONFIG.PSU__LPDMA3_COHERENCY {0} \
    CONFIG.PSU__LPDMA4_COHERENCY {0} \
    CONFIG.PSU__LPDMA5_COHERENCY {0} \
    CONFIG.PSU__LPDMA6_COHERENCY {0} \
    CONFIG.PSU__LPDMA7_COHERENCY {0} \
    CONFIG.PSU__LPD_SLCR__CSUPMU_WDT_CLK_SEL__SELECT {APB} \
    CONFIG.PSU__LPD_SLCR__CSUPMU__ACT_FREQMHZ {100} \
    CONFIG.PSU__LPD_SLCR__CSUPMU__FREQMHZ {100} \
    CONFIG.PSU__MAXIGP2__DATA_WIDTH {32} \
    CONFIG.PSU__M_AXI_GP0_SUPPORTS_NARROW_BURST {1} \
    CONFIG.PSU__M_AXI_GP1_SUPPORTS_NARROW_BURST {1} \
    CONFIG.PSU__M_AXI_GP2_SUPPORTS_NARROW_BURST {1} \
    CONFIG.PSU__NAND__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__NAND__READY_BUSY__ENABLE {0} \
    CONFIG.PSU__NUM_FABRIC_RESETS {1} \
    CONFIG.PSU__OCM_BANK0__POWER__ON {1} \
    CONFIG.PSU__OCM_BANK1__POWER__ON {1} \
    CONFIG.PSU__OCM_BANK2__POWER__ON {1} \
    CONFIG.PSU__OCM_BANK3__POWER__ON {1} \
    CONFIG.PSU__OVERRIDE_HPX_QOS {0} \
    CONFIG.PSU__OVERRIDE__BASIC_CLOCK {0} \
    CONFIG.PSU__PCIE__ACS_VIOLAION {0} \
    CONFIG.PSU__PCIE__AER_CAPABILITY {0} \
    CONFIG.PSU__PCIE__BAR0_ENABLE {0} \
    CONFIG.PSU__PCIE__BAR0_VAL {0x0} \
    CONFIG.PSU__PCIE__BAR1_ENABLE {0} \
    CONFIG.PSU__PCIE__BAR1_VAL {0x0} \
    CONFIG.PSU__PCIE__BAR2_VAL {0x0} \
    CONFIG.PSU__PCIE__BAR3_VAL {0x0} \
    CONFIG.PSU__PCIE__BAR4_VAL {0x0} \
    CONFIG.PSU__PCIE__BAR5_VAL {0x0} \
    CONFIG.PSU__PCIE__CLASS_CODE_BASE {0x06} \
    CONFIG.PSU__PCIE__CLASS_CODE_INTERFACE {0x0} \
    CONFIG.PSU__PCIE__CLASS_CODE_SUB {0x04} \
    CONFIG.PSU__PCIE__CLASS_CODE_VALUE {0x60400} \
    CONFIG.PSU__PCIE__CRS_SW_VISIBILITY {0} \
    CONFIG.PSU__PCIE__DEVICE_ID {0xD011} \
    CONFIG.PSU__PCIE__DEVICE_PORT_TYPE {Root Port} \
    CONFIG.PSU__PCIE__EROM_ENABLE {0} \
    CONFIG.PSU__PCIE__EROM_VAL {0x0} \
    CONFIG.PSU__PCIE__INTX_GENERATION {0} \
    CONFIG.PSU__PCIE__LANE0__ENABLE {1} \
    CONFIG.PSU__PCIE__LANE0__IO {GT Lane0} \
    CONFIG.PSU__PCIE__LANE1__ENABLE {0} \
    CONFIG.PSU__PCIE__LANE2__ENABLE {0} \
    CONFIG.PSU__PCIE__LANE3__ENABLE {0} \
    CONFIG.PSU__PCIE__LINK_SPEED {5.0 Gb/s} \
    CONFIG.PSU__PCIE__MAXIMUM_LINK_WIDTH {x1} \
    CONFIG.PSU__PCIE__MAX_PAYLOAD_SIZE {256 bytes} \
    CONFIG.PSU__PCIE__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__PCIE__PERIPHERAL__ENDPOINT_ENABLE {0} \
    CONFIG.PSU__PCIE__PERIPHERAL__ROOTPORT_ENABLE {1} \
    CONFIG.PSU__PCIE__PERIPHERAL__ROOTPORT_IO {MIO 7} \
    CONFIG.PSU__PCIE__REF_CLK_FREQ {100} \
    CONFIG.PSU__PCIE__REF_CLK_SEL {Ref Clk0} \
    CONFIG.PSU__PCIE__RESET__POLARITY {Active Low} \
    CONFIG.PSU__PCIE__REVISION_ID {0x0} \
    CONFIG.PSU__PCIE__SUBSYSTEM_ID {0x7} \
    CONFIG.PSU__PCIE__SUBSYSTEM_VENDOR_ID {0x10EE} \
    CONFIG.PSU__PCIE__VENDOR_ID {0x10EE} \
    CONFIG.PSU__PJTAG__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__PL_CLK0_BUF {TRUE} \
    CONFIG.PSU__PL_CLK1_BUF {TRUE} \
    CONFIG.PSU__PL_CLK2_BUF {TRUE} \
    CONFIG.PSU__PL__POWER__ON {1} \
    CONFIG.PSU__PMU__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__PRESET_APPLIED {1} \
    CONFIG.PSU__PROTECTION__DDR_SEGMENTS {NONE} \
    CONFIG.PSU__PROTECTION__ENABLE {0} \
    CONFIG.PSU__PROTECTION__FPD_SEGMENTS {SA:0xFD1A0000; SIZE:1280; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware  |   SA:0xFD000000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write;\
subsystemId:PMU Firmware  |   SA:0xFD010000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware  |   SA:0xFD020000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write;\
subsystemId:PMU Firmware  |   SA:0xFD030000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware  |   SA:0xFD040000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write;\
subsystemId:PMU Firmware  |   SA:0xFD050000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware  |   SA:0xFD610000; SIZE:512; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write;\
subsystemId:PMU Firmware  |   SA:0xFD5D0000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware  |  SA:0xFD1A0000 ; SIZE:1280; UNIT:KB; RegionTZ:Secure ; WrAllowed:Read/Write;\
subsystemId:Secure Subsystem} \
    CONFIG.PSU__PROTECTION__LPD_SEGMENTS {SA:0xFF980000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware| SA:0xFF5E0000; SIZE:2560; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write;\
subsystemId:PMU Firmware| SA:0xFFCC0000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware| SA:0xFF180000; SIZE:768; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU\
Firmware| SA:0xFF410000; SIZE:640; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware| SA:0xFFA70000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware|\
SA:0xFF9A0000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware|SA:0xFF5E0000 ; SIZE:2560; UNIT:KB; RegionTZ:Secure ; WrAllowed:Read/Write; subsystemId:Secure Subsystem|SA:0xFFCC0000\
; SIZE:64; UNIT:KB; RegionTZ:Secure ; WrAllowed:Read/Write; subsystemId:Secure Subsystem|SA:0xFF180000 ; SIZE:768; UNIT:KB; RegionTZ:Secure ; WrAllowed:Read/Write; subsystemId:Secure Subsystem|SA:0xFF9A0000\
; SIZE:64; UNIT:KB; RegionTZ:Secure ; WrAllowed:Read/Write; subsystemId:Secure Subsystem} \
    CONFIG.PSU__PROTECTION__MASTERS {USB1:NonSecure;1|USB0:NonSecure;1|S_AXI_LPD:NA;0|S_AXI_HPC1_FPD:NA;0|S_AXI_HPC0_FPD:NA;0|S_AXI_HP3_FPD:NA;0|S_AXI_HP2_FPD:NA;0|S_AXI_HP1_FPD:NA;0|S_AXI_HP0_FPD:NA;1|S_AXI_ACP:NA;0|S_AXI_ACE:NA;0|SD1:NonSecure;1|SD0:NonSecure;0|SATA1:NonSecure;0|SATA0:NonSecure;0|RPU1:Secure;1|RPU0:Secure;1|QSPI:NonSecure;1|PMU:NA;1|PCIe:NonSecure;1|NAND:NonSecure;0|LDMA:NonSecure;1|GPU:NonSecure;1|GEM3:NonSecure;0|GEM2:NonSecure;0|GEM1:NonSecure;0|GEM0:NonSecure;1|FDMA:NonSecure;1|DP:NonSecure;1|DAP:NA;1|Coresight:NA;1|CSU:NA;1|APU:NA;1}\
\
    CONFIG.PSU__PROTECTION__MASTERS_TZ {GEM0:NonSecure|SD1:NonSecure|GEM2:NonSecure|GEM1:NonSecure|GEM3:NonSecure|PCIe:NonSecure|DP:NonSecure|NAND:NonSecure|GPU:NonSecure|USB1:NonSecure|USB0:NonSecure|LDMA:NonSecure|FDMA:NonSecure|QSPI:NonSecure|SD0:NonSecure}\
\
    CONFIG.PSU__PROTECTION__OCM_SEGMENTS {NONE} \
    CONFIG.PSU__PROTECTION__PRESUBSYSTEMS {NONE} \
    CONFIG.PSU__PROTECTION__SLAVES {LPD;USB3_1_XHCI;FE300000;FE3FFFFF;1|LPD;USB3_1;FF9E0000;FF9EFFFF;1|LPD;USB3_0_XHCI;FE200000;FE2FFFFF;1|LPD;USB3_0;FF9D0000;FF9DFFFF;1|LPD;UART1;FF010000;FF01FFFF;1|LPD;UART0;FF000000;FF00FFFF;1|LPD;TTC3;FF140000;FF14FFFF;0|LPD;TTC2;FF130000;FF13FFFF;0|LPD;TTC1;FF120000;FF12FFFF;0|LPD;TTC0;FF110000;FF11FFFF;1|FPD;SWDT1;FD4D0000;FD4DFFFF;0|LPD;SWDT0;FF150000;FF15FFFF;0|LPD;SPI1;FF050000;FF05FFFF;0|LPD;SPI0;FF040000;FF04FFFF;1|FPD;SMMU_REG;FD5F0000;FD5FFFFF;1|FPD;SMMU;FD800000;FDFFFFFF;1|FPD;SIOU;FD3D0000;FD3DFFFF;1|FPD;SERDES;FD400000;FD47FFFF;1|LPD;SD1;FF170000;FF17FFFF;1|LPD;SD0;FF160000;FF16FFFF;0|FPD;SATA;FD0C0000;FD0CFFFF;0|LPD;RTC;FFA60000;FFA6FFFF;1|LPD;RSA_CORE;FFCE0000;FFCEFFFF;1|LPD;RPU;FF9A0000;FF9AFFFF;1|LPD;R5_TCM_RAM_GLOBAL;FFE00000;FFE3FFFF;1|LPD;R5_1_Instruction_Cache;FFEC0000;FFECFFFF;1|LPD;R5_1_Data_Cache;FFED0000;FFEDFFFF;1|LPD;R5_1_BTCM_GLOBAL;FFEB0000;FFEBFFFF;1|LPD;R5_1_ATCM_GLOBAL;FFE90000;FFE9FFFF;1|LPD;R5_0_Instruction_Cache;FFE40000;FFE4FFFF;1|LPD;R5_0_Data_Cache;FFE50000;FFE5FFFF;1|LPD;R5_0_BTCM_GLOBAL;FFE20000;FFE2FFFF;1|LPD;R5_0_ATCM_GLOBAL;FFE00000;FFE0FFFF;1|LPD;QSPI_Linear_Address;C0000000;DFFFFFFF;1|LPD;QSPI;FF0F0000;FF0FFFFF;1|LPD;PMU_RAM;FFDC0000;FFDDFFFF;1|LPD;PMU_GLOBAL;FFD80000;FFDBFFFF;1|FPD;PCIE_MAIN;FD0E0000;FD0EFFFF;1|FPD;PCIE_LOW;E0000000;EFFFFFFF;1|FPD;PCIE_HIGH2;8000000000;BFFFFFFFFF;1|FPD;PCIE_HIGH1;600000000;7FFFFFFFF;1|FPD;PCIE_DMA;FD0F0000;FD0FFFFF;1|FPD;PCIE_ATTRIB;FD480000;FD48FFFF;1|LPD;OCM_XMPU_CFG;FFA70000;FFA7FFFF;1|LPD;OCM_SLCR;FF960000;FF96FFFF;1|OCM;OCM;FFFC0000;FFFFFFFF;1|LPD;NAND;FF100000;FF10FFFF;0|LPD;MBISTJTAG;FFCF0000;FFCFFFFF;1|LPD;LPD_XPPU_SINK;FF9C0000;FF9CFFFF;1|LPD;LPD_XPPU;FF980000;FF98FFFF;1|LPD;LPD_SLCR_SECURE;FF4B0000;FF4DFFFF;1|LPD;LPD_SLCR;FF410000;FF4AFFFF;1|LPD;LPD_GPV;FE100000;FE1FFFFF;1|LPD;LPD_DMA_7;FFAF0000;FFAFFFFF;1|LPD;LPD_DMA_6;FFAE0000;FFAEFFFF;1|LPD;LPD_DMA_5;FFAD0000;FFADFFFF;1|LPD;LPD_DMA_4;FFAC0000;FFACFFFF;1|LPD;LPD_DMA_3;FFAB0000;FFABFFFF;1|LPD;LPD_DMA_2;FFAA0000;FFAAFFFF;1|LPD;LPD_DMA_1;FFA90000;FFA9FFFF;1|LPD;LPD_DMA_0;FFA80000;FFA8FFFF;1|LPD;IPI_CTRL;FF380000;FF3FFFFF;1|LPD;IOU_SLCR;FF180000;FF23FFFF;1|LPD;IOU_SECURE_SLCR;FF240000;FF24FFFF;1|LPD;IOU_SCNTRS;FF260000;FF26FFFF;1|LPD;IOU_SCNTR;FF250000;FF25FFFF;1|LPD;IOU_GPV;FE000000;FE0FFFFF;1|LPD;I2C1;FF030000;FF03FFFF;1|LPD;I2C0;FF020000;FF02FFFF;1|FPD;GPU;FD4B0000;FD4BFFFF;1|LPD;GPIO;FF0A0000;FF0AFFFF;1|LPD;GEM3;FF0E0000;FF0EFFFF;0|LPD;GEM2;FF0D0000;FF0DFFFF;0|LPD;GEM1;FF0C0000;FF0CFFFF;0|LPD;GEM0;FF0B0000;FF0BFFFF;1|FPD;FPD_XMPU_SINK;FD4F0000;FD4FFFFF;1|FPD;FPD_XMPU_CFG;FD5D0000;FD5DFFFF;1|FPD;FPD_SLCR_SECURE;FD690000;FD6CFFFF;1|FPD;FPD_SLCR;FD610000;FD68FFFF;1|FPD;FPD_DMA_CH7;FD570000;FD57FFFF;1|FPD;FPD_DMA_CH6;FD560000;FD56FFFF;1|FPD;FPD_DMA_CH5;FD550000;FD55FFFF;1|FPD;FPD_DMA_CH4;FD540000;FD54FFFF;1|FPD;FPD_DMA_CH3;FD530000;FD53FFFF;1|FPD;FPD_DMA_CH2;FD520000;FD52FFFF;1|FPD;FPD_DMA_CH1;FD510000;FD51FFFF;1|FPD;FPD_DMA_CH0;FD500000;FD50FFFF;1|LPD;EFUSE;FFCC0000;FFCCFFFF;1|FPD;Display\
Port;FD4A0000;FD4AFFFF;1|FPD;DPDMA;FD4C0000;FD4CFFFF;1|FPD;DDR_XMPU5_CFG;FD050000;FD05FFFF;1|FPD;DDR_XMPU4_CFG;FD040000;FD04FFFF;1|FPD;DDR_XMPU3_CFG;FD030000;FD03FFFF;1|FPD;DDR_XMPU2_CFG;FD020000;FD02FFFF;1|FPD;DDR_XMPU1_CFG;FD010000;FD01FFFF;1|FPD;DDR_XMPU0_CFG;FD000000;FD00FFFF;1|FPD;DDR_QOS_CTRL;FD090000;FD09FFFF;1|FPD;DDR_PHY;FD080000;FD08FFFF;1|DDR;DDR_LOW;0;7FFFFFFF;1|DDR;DDR_HIGH;800000000;87FFFFFFF;1|FPD;DDDR_CTRL;FD070000;FD070FFF;1|LPD;Coresight;FE800000;FEFFFFFF;1|LPD;CSU_DMA;FFC80000;FFC9FFFF;1|LPD;CSU;FFCA0000;FFCAFFFF;1|LPD;CRL_APB;FF5E0000;FF85FFFF;1|FPD;CRF_APB;FD1A0000;FD2DFFFF;1|FPD;CCI_REG;FD5E0000;FD5EFFFF;1|LPD;CAN1;FF070000;FF07FFFF;0|LPD;CAN0;FF060000;FF06FFFF;0|FPD;APU;FD5C0000;FD5CFFFF;1|LPD;APM_INTC_IOU;FFA20000;FFA2FFFF;1|LPD;APM_FPD_LPD;FFA30000;FFA3FFFF;1|FPD;APM_5;FD490000;FD49FFFF;1|FPD;APM_0;FD0B0000;FD0BFFFF;1|LPD;APM2;FFA10000;FFA1FFFF;1|LPD;APM1;FFA00000;FFA0FFFF;1|LPD;AMS;FFA50000;FFA5FFFF;1|FPD;AFI_5;FD3B0000;FD3BFFFF;1|FPD;AFI_4;FD3A0000;FD3AFFFF;1|FPD;AFI_3;FD390000;FD39FFFF;1|FPD;AFI_2;FD380000;FD38FFFF;1|FPD;AFI_1;FD370000;FD37FFFF;1|FPD;AFI_0;FD360000;FD36FFFF;1|LPD;AFIFM6;FF9B0000;FF9BFFFF;1|FPD;ACPU_GIC;F9010000;F907FFFF;1}\
\
    CONFIG.PSU__PROTECTION__SUBSYSTEMS {PMU Firmware:PMU|Secure Subsystem:} \
    CONFIG.PSU__PSS_ALT_REF_CLK__ENABLE {0} \
    CONFIG.PSU__PSS_ALT_REF_CLK__FREQMHZ {33.333} \
    CONFIG.PSU__PSS_REF_CLK__FREQMHZ {30} \
    CONFIG.PSU__QSPI_COHERENCY {0} \
    CONFIG.PSU__QSPI_ROUTE_THROUGH_FPD {0} \
    CONFIG.PSU__QSPI__GRP_FBCLK__ENABLE {1} \
    CONFIG.PSU__QSPI__GRP_FBCLK__IO {MIO 6} \
    CONFIG.PSU__QSPI__PERIPHERAL__DATA_MODE {x4} \
    CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__QSPI__PERIPHERAL__IO {MIO 0 .. 5} \
    CONFIG.PSU__QSPI__PERIPHERAL__MODE {Single} \
    CONFIG.PSU__REPORT__DBGLOG {0} \
    CONFIG.PSU__RPU_COHERENCY {0} \
    CONFIG.PSU__RPU__POWER__ON {1} \
    CONFIG.PSU__SATA__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__SAXIGP2__DATA_WIDTH {128} \
    CONFIG.PSU__SD0__CLK_100_SDR_OTAP_DLY {0x3} \
    CONFIG.PSU__SD0__CLK_200_SDR_OTAP_DLY {0x3} \
    CONFIG.PSU__SD0__CLK_50_DDR_ITAP_DLY {0x3D} \
    CONFIG.PSU__SD0__CLK_50_DDR_OTAP_DLY {0x4} \
    CONFIG.PSU__SD0__CLK_50_SDR_ITAP_DLY {0x15} \
    CONFIG.PSU__SD0__CLK_50_SDR_OTAP_DLY {0x5} \
    CONFIG.PSU__SD0__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__SD0__RESET__ENABLE {0} \
    CONFIG.PSU__SD1_COHERENCY {0} \
    CONFIG.PSU__SD1_ROUTE_THROUGH_FPD {0} \
    CONFIG.PSU__SD1__CLK_100_SDR_OTAP_DLY {0x3} \
    CONFIG.PSU__SD1__CLK_200_SDR_OTAP_DLY {0x3} \
    CONFIG.PSU__SD1__CLK_50_DDR_ITAP_DLY {0x3D} \
    CONFIG.PSU__SD1__CLK_50_DDR_OTAP_DLY {0x4} \
    CONFIG.PSU__SD1__CLK_50_SDR_ITAP_DLY {0x15} \
    CONFIG.PSU__SD1__CLK_50_SDR_OTAP_DLY {0x5} \
    CONFIG.PSU__SD1__DATA_TRANSFER_MODE {8Bit} \
    CONFIG.PSU__SD1__GRP_CD__ENABLE {1} \
    CONFIG.PSU__SD1__GRP_CD__IO {MIO 45} \
    CONFIG.PSU__SD1__GRP_POW__ENABLE {1} \
    CONFIG.PSU__SD1__GRP_POW__IO {MIO 43} \
    CONFIG.PSU__SD1__GRP_WP__ENABLE {0} \
    CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__SD1__PERIPHERAL__IO {MIO 39 .. 51} \
    CONFIG.PSU__SD1__SLOT_TYPE {SD 3.0} \
    CONFIG.PSU__SPI0_LOOP_SPI1__ENABLE {0} \
    CONFIG.PSU__SPI0__GRP_SS0__IO {MIO 15} \
    CONFIG.PSU__SPI0__GRP_SS1__ENABLE {1} \
    CONFIG.PSU__SPI0__GRP_SS1__IO {MIO 14} \
    CONFIG.PSU__SPI0__GRP_SS2__ENABLE {0} \
    CONFIG.PSU__SPI0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__SPI0__PERIPHERAL__IO {MIO 12 .. 17} \
    CONFIG.PSU__SPI1__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__SWDT0__PERIPHERAL__IO {NA} \
    CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__SWDT1__PERIPHERAL__IO {NA} \
    CONFIG.PSU__TCM0A__POWER__ON {1} \
    CONFIG.PSU__TCM0B__POWER__ON {1} \
    CONFIG.PSU__TCM1A__POWER__ON {1} \
    CONFIG.PSU__TCM1B__POWER__ON {1} \
    CONFIG.PSU__TESTSCAN__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__TRACE__INTERNAL_WIDTH {32} \
    CONFIG.PSU__TRACE__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__TRISTATE__INVERTED {1} \
    CONFIG.PSU__TSU__BUFG_PORT_PAIR {0} \
    CONFIG.PSU__TTC0__CLOCK__ENABLE {0} \
    CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__TTC0__PERIPHERAL__IO {NA} \
    CONFIG.PSU__TTC0__WAVEOUT__ENABLE {0} \
    CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__TTC1__PERIPHERAL__IO {NA} \
    CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__TTC2__PERIPHERAL__IO {NA} \
    CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__TTC3__PERIPHERAL__IO {NA} \
    CONFIG.PSU__UART0_LOOP_UART1__ENABLE {0} \
    CONFIG.PSU__UART0__BAUD_RATE {115200} \
    CONFIG.PSU__UART0__MODEM__ENABLE {0} \
    CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__UART0__PERIPHERAL__IO {MIO 18 .. 19} \
    CONFIG.PSU__UART1__BAUD_RATE {115200} \
    CONFIG.PSU__UART1__MODEM__ENABLE {0} \
    CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__UART1__PERIPHERAL__IO {EMIO} \
    CONFIG.PSU__USB0_COHERENCY {0} \
    CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__USB0__PERIPHERAL__IO {MIO 52 .. 63} \
    CONFIG.PSU__USB0__REF_CLK_FREQ {100} \
    CONFIG.PSU__USB0__REF_CLK_SEL {Ref Clk0} \
    CONFIG.PSU__USB1_COHERENCY {0} \
    CONFIG.PSU__USB1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__USB1__PERIPHERAL__IO {MIO 64 .. 75} \
    CONFIG.PSU__USB2_0__EMIO__ENABLE {0} \
    CONFIG.PSU__USB2_1__EMIO__ENABLE {0} \
    CONFIG.PSU__USB3_0__EMIO__ENABLE {0} \
    CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__USB3_0__PERIPHERAL__IO {GT Lane1} \
    CONFIG.PSU__USB3_1__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__USB__RESET__MODE {Disable} \
    CONFIG.PSU__USE_DIFF_RW_CLK_GP2 {0} \
    CONFIG.PSU__USE__ADMA {0} \
    CONFIG.PSU__USE__APU_LEGACY_INTERRUPT {0} \
    CONFIG.PSU__USE__AUDIO {0} \
    CONFIG.PSU__USE__CLK {0} \
    CONFIG.PSU__USE__CLK0 {0} \
    CONFIG.PSU__USE__CLK1 {0} \
    CONFIG.PSU__USE__CLK2 {0} \
    CONFIG.PSU__USE__CLK3 {0} \
    CONFIG.PSU__USE__CROSS_TRIGGER {0} \
    CONFIG.PSU__USE__DDR_INTF_REQUESTED {0} \
    CONFIG.PSU__USE__DEBUG__TEST {0} \
    CONFIG.PSU__USE__EVENT_RPU {0} \
    CONFIG.PSU__USE__FABRIC__RST {1} \
    CONFIG.PSU__USE__FTM {0} \
    CONFIG.PSU__USE__GDMA {0} \
    CONFIG.PSU__USE__IRQ {0} \
    CONFIG.PSU__USE__IRQ0 {1} \
    CONFIG.PSU__USE__IRQ1 {1} \
    CONFIG.PSU__USE__M_AXI_GP0 {0} \
    CONFIG.PSU__USE__M_AXI_GP1 {0} \
    CONFIG.PSU__USE__M_AXI_GP2 {1} \
    CONFIG.PSU__USE__PROC_EVENT_BUS {0} \
    CONFIG.PSU__USE__RPU_LEGACY_INTERRUPT {0} \
    CONFIG.PSU__USE__RST0 {0} \
    CONFIG.PSU__USE__RST1 {0} \
    CONFIG.PSU__USE__RST2 {0} \
    CONFIG.PSU__USE__RST3 {0} \
    CONFIG.PSU__USE__RTC {0} \
    CONFIG.PSU__USE__STM {0} \
    CONFIG.PSU__USE__S_AXI_ACE {0} \
    CONFIG.PSU__USE__S_AXI_ACP {0} \
    CONFIG.PSU__USE__S_AXI_GP0 {0} \
    CONFIG.PSU__USE__S_AXI_GP1 {0} \
    CONFIG.PSU__USE__S_AXI_GP2 {1} \
    CONFIG.PSU__USE__S_AXI_GP3 {0} \
    CONFIG.PSU__USE__S_AXI_GP4 {0} \
    CONFIG.PSU__USE__S_AXI_GP5 {0} \
    CONFIG.PSU__USE__S_AXI_GP6 {0} \
    CONFIG.PSU__USE__USB3_0_HUB {0} \
    CONFIG.PSU__USE__USB3_1_HUB {0} \
    CONFIG.PSU__USE__VIDEO {0} \
    CONFIG.PSU__VIDEO_REF_CLK__ENABLE {0} \
    CONFIG.PSU__VIDEO_REF_CLK__FREQMHZ {33.333} \
    CONFIG.QSPI_BOARD_INTERFACE {custom} \
    CONFIG.SATA_BOARD_INTERFACE {custom} \
    CONFIG.SD0_BOARD_INTERFACE {custom} \
    CONFIG.SD1_BOARD_INTERFACE {custom} \
    CONFIG.SPI0_BOARD_INTERFACE {custom} \
    CONFIG.SPI1_BOARD_INTERFACE {custom} \
    CONFIG.SUBPRESET1 {Custom} \
    CONFIG.SUBPRESET2 {Custom} \
    CONFIG.SWDT0_BOARD_INTERFACE {custom} \
    CONFIG.SWDT1_BOARD_INTERFACE {custom} \
    CONFIG.TRACE_BOARD_INTERFACE {custom} \
    CONFIG.TTC0_BOARD_INTERFACE {custom} \
    CONFIG.TTC1_BOARD_INTERFACE {custom} \
    CONFIG.TTC2_BOARD_INTERFACE {custom} \
    CONFIG.TTC3_BOARD_INTERFACE {custom} \
    CONFIG.UART0_BOARD_INTERFACE {custom} \
    CONFIG.UART1_BOARD_INTERFACE {custom} \
    CONFIG.USB0_BOARD_INTERFACE {custom} \
    CONFIG.USB1_BOARD_INTERFACE {custom} \
  ] $zynq_ultra_ps_e_0


  # Create interface connections
  connect_bd_intf_net -intf_net audio_ss_0_axis_audio_out [get_bd_intf_pins audio_ss_0/axis_audio_out] [get_bd_intf_pins v_hdmi_tx_ss_0/AUDIO_IN]
  connect_bd_intf_net -intf_net audio_test_M_AXI_MM2S [get_bd_intf_pins audio_test/M_AXI_MM2S] [get_bd_intf_pins axi_smc/S00_AXI]
  connect_bd_intf_net -intf_net audio_test_M_AXI_MM2S1 [get_bd_intf_pins audio_test/M_AXI_MM2S1] [get_bd_intf_pins axi_smc/S02_AXI]
  connect_bd_intf_net -intf_net audio_test_M_AXI_S2MM [get_bd_intf_pins audio_test/M_AXI_S2MM] [get_bd_intf_pins axi_smc/S01_AXI]
  connect_bd_intf_net -intf_net audio_test_M_AXI_S2MM1 [get_bd_intf_pins audio_test/M_AXI_S2MM1] [get_bd_intf_pins axi_smc/S03_AXI]
  connect_bd_intf_net -intf_net axi_gpio_btn_GPIO [get_bd_intf_ports pl_buttons] [get_bd_intf_pins uio/pl_buttons]
  connect_bd_intf_net -intf_net axi_gpio_led_GPIO [get_bd_intf_ports pl_leds] [get_bd_intf_pins uio/pl_leds]
  connect_bd_intf_net -intf_net axi_gpio_sw_GPIO [get_bd_intf_ports pl_switches] [get_bd_intf_pins uio/pl_switches]
  connect_bd_intf_net -intf_net axi_iic_0_IIC [get_bd_intf_ports mux] [get_bd_intf_pins axi_iic_0/IIC]
  connect_bd_intf_net -intf_net axi_iic_1_IIC [get_bd_intf_ports aud] [get_bd_intf_pins axi_iic_1/IIC]
  connect_bd_intf_net -intf_net axi_smc_M00_AXI [get_bd_intf_pins axi_smc/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP0_FPD]
  connect_bd_intf_net -intf_net axis_audio_in_1 [get_bd_intf_pins audio_ss_0/axis_audio_in] [get_bd_intf_pins v_hdmi_rx_ss_0/AUDIO_OUT]
  connect_bd_intf_net -intf_net gpio_sfp_ip_GPIO [get_bd_intf_ports gpio_sfp] [get_bd_intf_pins gpio_sfp_ip/GPIO]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M00_AXI [get_bd_intf_pins ps8_0_axi_periph/M00_AXI] [get_bd_intf_pins uio/S_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M01_AXI [get_bd_intf_pins ps8_0_axi_periph/M01_AXI] [get_bd_intf_pins uio/S_AXI2]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M02_AXI [get_bd_intf_pins ps8_0_axi_periph/M02_AXI] [get_bd_intf_pins uio/S_AXI3]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M03_AXI [get_bd_intf_pins ps8_0_axi_periph/M03_AXI] [get_bd_intf_pins uio/S_AXI1]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M04_AXI [get_bd_intf_pins ps8_0_axi_periph/M04_AXI] [get_bd_intf_pins v_hdmi_tx_ss_0/S_AXI_CPU_IN]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M05_AXI [get_bd_intf_pins ps8_0_axi_periph/M05_AXI] [get_bd_intf_pins v_hdmi_rx_ss_0/S_AXI_CPU_IN]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M06_AXI [get_bd_intf_pins ps8_0_axi_periph/M06_AXI] [get_bd_intf_pins vid_phy_controller_0/vid_phy_axi4lite]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M07_AXI [get_bd_intf_pins audio_ss_0/S00_AXI] [get_bd_intf_pins ps8_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M08_AXI [get_bd_intf_pins ps8_0_axi_periph/M08_AXI] [get_bd_intf_pins v_tpg_ss_0/S_AXI_TPG]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M09_AXI [get_bd_intf_pins ps8_0_axi_periph/M09_AXI] [get_bd_intf_pins v_tpg_ss_0/S_AXI_GPIO]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M10_AXI [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins ps8_0_axi_periph/M10_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M11_AXI [get_bd_intf_pins Control_SI5342_LOLN/S_AXI] [get_bd_intf_pins ps8_0_axi_periph/M11_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M12_AXI [get_bd_intf_pins audio_test/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M12_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M13_AXI [get_bd_intf_pins audio_test/S_AXI_LITE1] [get_bd_intf_pins ps8_0_axi_periph/M13_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M14_AXI [get_bd_intf_pins audio_test/S_AXI] [get_bd_intf_pins ps8_0_axi_periph/M14_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M15_AXI [get_bd_intf_pins audio_test/S_AXI1] [get_bd_intf_pins ps8_0_axi_periph/M15_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M16_AXI [get_bd_intf_pins audio_test/AXI_L] [get_bd_intf_pins ps8_0_axi_periph/M16_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M17_AXI [get_bd_intf_pins ps8_0_axi_periph/M17_AXI] [get_bd_intf_pins short_loopback_tests/S_AXI1]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M18_AXI [get_bd_intf_pins ps8_0_axi_periph/M18_AXI] [get_bd_intf_pins short_loopback_tests/S_AXI2]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M19_AXI [get_bd_intf_pins ps8_0_axi_periph/M19_AXI] [get_bd_intf_pins short_loopback_tests/S_AXI3]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M20_AXI [get_bd_intf_pins ps8_0_axi_periph/M20_AXI] [get_bd_intf_pins short_loopback_tests/S_AXI5]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M21_AXI [get_bd_intf_pins ps8_0_axi_periph/M21_AXI] [get_bd_intf_pins short_loopback_tests/S_AXI6]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M22_AXI [get_bd_intf_pins ps8_0_axi_periph/M22_AXI] [get_bd_intf_pins short_loopback_tests/S_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M23_AXI [get_bd_intf_pins ps8_0_axi_periph/M23_AXI] [get_bd_intf_pins short_loopback_tests/S_AXI4]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M24_AXI [get_bd_intf_pins gpio_sfp_ip/S_AXI] [get_bd_intf_pins ps8_0_axi_periph/M24_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M25_AXI [get_bd_intf_pins ps8_0_axi_periph/M25_AXI] [get_bd_intf_pins short_loopback_tests/S_AXI7]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M26_AXI [get_bd_intf_pins ps8_0_axi_periph/M26_AXI] [get_bd_intf_pins short_loopback_tests/S_AXI8]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M27_AXI [get_bd_intf_pins ps8_0_axi_periph/M27_AXI] [get_bd_intf_pins set_vadj_level/S_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M28_AXI [get_bd_intf_pins axi_iic_1/S_AXI] [get_bd_intf_pins ps8_0_axi_periph/M28_AXI]
  connect_bd_intf_net -intf_net s_axis_video_1 [get_bd_intf_pins rx_video_axis_reg_slice/M_AXIS] [get_bd_intf_pins v_tpg_ss_0/s_axis_video]
  connect_bd_intf_net -intf_net set_vadj_level_GPIO_0 [get_bd_intf_ports vadj_set] [get_bd_intf_pins set_vadj_level/vadj_set]
  connect_bd_intf_net -intf_net short_loopback_tests_GPIO2_0 [get_bd_intf_ports fmc_la_00_n] [get_bd_intf_pins short_loopback_tests/fmc_la_00_n]
  connect_bd_intf_net -intf_net short_loopback_tests_GPIO2_1 [get_bd_intf_ports fmc_la_01_n] [get_bd_intf_pins short_loopback_tests/fmc_la_01_n]
  connect_bd_intf_net -intf_net short_loopback_tests_GPIO2_2 [get_bd_intf_ports syzygy_2] [get_bd_intf_pins short_loopback_tests/syzygy_2]
  connect_bd_intf_net -intf_net short_loopback_tests_GPIO2_3 [get_bd_intf_ports ffc_a1] [get_bd_intf_pins short_loopback_tests/ffc_a1]
  connect_bd_intf_net -intf_net short_loopback_tests_GPIO2_4 [get_bd_intf_ports ffc_b1] [get_bd_intf_pins short_loopback_tests/ffc_b1]
  connect_bd_intf_net -intf_net short_loopback_tests_GPIO_0 [get_bd_intf_ports fmc_prsnt] [get_bd_intf_pins short_loopback_tests/fmc_prsnt]
  connect_bd_intf_net -intf_net short_loopback_tests_GPIO_1 [get_bd_intf_ports fmc_la_01_p] [get_bd_intf_pins short_loopback_tests/fmc_la_01_p]
  connect_bd_intf_net -intf_net short_loopback_tests_GPIO_2 [get_bd_intf_ports fmc_la_00_p] [get_bd_intf_pins short_loopback_tests/fmc_la_00_p]
  connect_bd_intf_net -intf_net short_loopback_tests_GPIO_3 [get_bd_intf_ports syzygy_1] [get_bd_intf_pins short_loopback_tests/syszygy_1]
  connect_bd_intf_net -intf_net short_loopback_tests_GPIO_4 [get_bd_intf_ports ffc_a] [get_bd_intf_pins short_loopback_tests/ffc_a]
  connect_bd_intf_net -intf_net short_loopback_tests_GPIO_5 [get_bd_intf_ports ffc_b] [get_bd_intf_pins short_loopback_tests/ffc_b]
  connect_bd_intf_net -intf_net short_loopback_tests_PG_VADJ_R [get_bd_intf_ports PG_VADJ_R] [get_bd_intf_pins short_loopback_tests/PG_VADJ_R]
  connect_bd_intf_net -intf_net short_loopback_tests_gpio_rtl_0 [get_bd_intf_ports pmod] [get_bd_intf_pins short_loopback_tests/pmod]
  connect_bd_intf_net -intf_net short_loopback_tests_gpio_rtl_1 [get_bd_intf_ports pmod2] [get_bd_intf_pins short_loopback_tests/pmod2]
  connect_bd_intf_net -intf_net short_loopback_tests_syzygy_detectedn [get_bd_intf_ports syzygy_detectedn] [get_bd_intf_pins short_loopback_tests/syzygy_detectedn]
  connect_bd_intf_net -intf_net tx_video_axis_reg_slice_M_AXIS [get_bd_intf_pins tx_video_axis_reg_slice/M_AXIS] [get_bd_intf_pins v_hdmi_tx_ss_0/VIDEO_IN]
  connect_bd_intf_net -intf_net v_hdmi_rx_ss_0_DDC_OUT [get_bd_intf_ports hdmi_rx_ddc] [get_bd_intf_pins v_hdmi_rx_ss_0/DDC_OUT]
  connect_bd_intf_net -intf_net v_hdmi_rx_ss_0_VIDEO_OUT [get_bd_intf_pins rx_video_axis_reg_slice/S_AXIS] [get_bd_intf_pins v_hdmi_rx_ss_0/VIDEO_OUT]
  connect_bd_intf_net -intf_net v_hdmi_tx_ss_0_DDC_OUT [get_bd_intf_ports hdmi_tx_i2c] [get_bd_intf_pins v_hdmi_tx_ss_0/DDC_OUT]
  connect_bd_intf_net -intf_net v_hdmi_tx_ss_0_LINK_DATA0_OUT [get_bd_intf_pins v_hdmi_tx_ss_0/LINK_DATA0_OUT] [get_bd_intf_pins vid_phy_controller_0/vid_phy_tx_axi4s_ch0]
  connect_bd_intf_net -intf_net v_hdmi_tx_ss_0_LINK_DATA1_OUT [get_bd_intf_pins v_hdmi_tx_ss_0/LINK_DATA1_OUT] [get_bd_intf_pins vid_phy_controller_0/vid_phy_tx_axi4s_ch1]
  connect_bd_intf_net -intf_net v_hdmi_tx_ss_0_LINK_DATA2_OUT [get_bd_intf_pins v_hdmi_tx_ss_0/LINK_DATA2_OUT] [get_bd_intf_pins vid_phy_controller_0/vid_phy_tx_axi4s_ch2]
  connect_bd_intf_net -intf_net v_tpg_ss_0_m_axis_video [get_bd_intf_pins tx_video_axis_reg_slice/S_AXIS] [get_bd_intf_pins v_tpg_ss_0/m_axis_video]
  connect_bd_intf_net -intf_net vid_phy_controller_0_vid_phy_rx_axi4s_ch0 [get_bd_intf_pins v_hdmi_rx_ss_0/LINK_DATA0_IN] [get_bd_intf_pins vid_phy_controller_0/vid_phy_rx_axi4s_ch0]
  connect_bd_intf_net -intf_net vid_phy_controller_0_vid_phy_rx_axi4s_ch1 [get_bd_intf_pins v_hdmi_rx_ss_0/LINK_DATA1_IN] [get_bd_intf_pins vid_phy_controller_0/vid_phy_rx_axi4s_ch1]
  connect_bd_intf_net -intf_net vid_phy_controller_0_vid_phy_rx_axi4s_ch2 [get_bd_intf_pins v_hdmi_rx_ss_0/LINK_DATA2_IN] [get_bd_intf_pins vid_phy_controller_0/vid_phy_rx_axi4s_ch2]
  connect_bd_intf_net -intf_net vid_phy_controller_0_vid_phy_status_sb_rx [get_bd_intf_pins v_hdmi_rx_ss_0/SB_STATUS_IN] [get_bd_intf_pins vid_phy_controller_0/vid_phy_status_sb_rx]
  connect_bd_intf_net -intf_net vid_phy_controller_0_vid_phy_status_sb_tx [get_bd_intf_pins v_hdmi_tx_ss_0/SB_STATUS_IN] [get_bd_intf_pins vid_phy_controller_0/vid_phy_status_sb_tx]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_GPIO_0 [get_bd_intf_ports gpio_emio] [get_bd_intf_pins zynq_ultra_ps_e_0/GPIO_0]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM0_LPD [get_bd_intf_pins ps8_0_axi_periph/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_LPD]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_UART_1 [get_bd_intf_ports UART_CTL] [get_bd_intf_pins zynq_ultra_ps_e_0/UART_1]

  # Create port connections
  connect_bd_net -net Control_SI5342_LOLN_gpio_io_o [get_bd_pins Control_SI5342_LOLN/gpio_io_o] [get_bd_pins OR_LOGIC/Op1]
  connect_bd_net -net Net [get_bd_pins audio_ss_0/aud_rstn] [get_bd_pins v_hdmi_rx_ss_0/s_axis_audio_aresetn] [get_bd_pins v_hdmi_tx_ss_0/s_axis_audio_aresetn]
  connect_bd_net -net OR_LOGIC_Res [get_bd_pins OR_LOGIC/Res] [get_bd_pins vid_phy_controller_0/tx_refclk_rdy]
  connect_bd_net -net SDATA_I_0_1 [get_bd_ports aud_adc_sdata] [get_bd_pins audio_test/SDATA_I_0]
  connect_bd_net -net aud_acr_cts_in_1 [get_bd_pins v_hdmi_rx_ss_0/acr_cts] [get_bd_pins audio_ss_0/aud_acr_cts_in]
  connect_bd_net -net aud_acr_n_in_1 [get_bd_pins v_hdmi_rx_ss_0/acr_n] [get_bd_pins audio_ss_0/aud_acr_n_in]
  connect_bd_net -net aud_acr_valid_in_1 [get_bd_pins v_hdmi_rx_ss_0/acr_valid] [get_bd_pins audio_ss_0/aud_acr_valid_in]
  connect_bd_net -net audio_ss_0_aud_acr_cts_out [get_bd_pins audio_ss_0/aud_acr_cts_out] [get_bd_pins v_hdmi_tx_ss_0/acr_cts]
  connect_bd_net -net audio_ss_0_aud_acr_n_out [get_bd_pins audio_ss_0/aud_acr_n_out] [get_bd_pins v_hdmi_tx_ss_0/acr_n]
  connect_bd_net -net audio_ss_0_aud_acr_valid_out [get_bd_pins audio_ss_0/aud_acr_valid_out] [get_bd_pins v_hdmi_tx_ss_0/acr_valid]
  connect_bd_net -net audio_ss_0_audio_clk [get_bd_pins audio_ss_0/audio_clk] [get_bd_pins v_hdmi_rx_ss_0/s_axis_audio_aclk] [get_bd_pins v_hdmi_tx_ss_0/s_axis_audio_aclk]
  connect_bd_net -net audio_test_BCLK_O_0 [get_bd_pins audio_test/BCLK_O_0] [get_bd_ports aud_bclk]
  connect_bd_net -net audio_test_LRCLK1_O_0 [get_bd_pins audio_test/LRCLK1_O_0] [get_bd_ports aud_lrclk]
  connect_bd_net -net audio_test_MCLK_O_0 [get_bd_pins audio_test/MCLK_O_0] [get_bd_ports aud_mclk]
  connect_bd_net -net audio_test_SDATA_O_0 [get_bd_pins audio_test/SDATA_O_0] [get_bd_ports aud_dac_sdata]
  connect_bd_net -net audio_test_iic2intc_irpt [get_bd_pins audio_test/iic2intc_irpt] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net audio_test_mm2s_introut_0 [get_bd_pins audio_test/mm2s_introut_0] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net audio_test_mm2s_introut_1 [get_bd_pins audio_test/mm2s_introut_1] [get_bd_pins xlconcat_0/In5]
  connect_bd_net -net audio_test_s2mm_introut_0 [get_bd_pins audio_test/s2mm_introut_0] [get_bd_pins xlconcat_0/In6]
  connect_bd_net -net audio_test_s2mm_introut_1 [get_bd_pins audio_test/s2mm_introut_1] [get_bd_pins xlconcat_0/In7]
  connect_bd_net -net clkgth_loln_ls_1 [get_bd_ports clkgth_loln_ls] [get_bd_pins OR_LOGIC/Op2]
  connect_bd_net -net dp_aux_data_in_0_1 [get_bd_ports dp_aux_din] [get_bd_pins zynq_ultra_ps_e_0/dp_aux_data_in]
  connect_bd_net -net dp_hot_plug_detect_0_1 [get_bd_ports dp_aux_hotplug_detect] [get_bd_pins zynq_ultra_ps_e_0/dp_hot_plug_detect]
  connect_bd_net -net hdmi_clk_1 [get_bd_pins vid_phy_controller_0/tx_tmds_clk] [get_bd_pins audio_ss_0/hdmi_clk]
  connect_bd_net -net hdmi_rx_5v_detn_1 [get_bd_ports hdmi_rx_5v_detn] [get_bd_pins v_hdmi_rx_ss_0/cable_detect]
  connect_bd_net -net hdmi_tx_hpd_1 [get_bd_ports hdmi_tx_hpd] [get_bd_pins v_hdmi_tx_ss_0/hpd]
  connect_bd_net -net link_clk1_1 [get_bd_pins vid_phy_controller_0/txoutclk] [get_bd_pins v_hdmi_tx_ss_0/link_clk] [get_bd_pins vid_phy_controller_0/vid_phy_tx_axi4s_aclk]
  connect_bd_net -net link_clk_1 [get_bd_pins vid_phy_controller_0/rxoutclk] [get_bd_pins v_hdmi_rx_ss_0/link_clk] [get_bd_pins vid_phy_controller_0/vid_phy_rx_axi4s_aclk]
  connect_bd_net -net mgtrefclk0_pad_n_in_0_1 [get_bd_ports mgtrefclk0_pad_n_in_0] [get_bd_pins vid_phy_controller_0/mgtrefclk0_pad_n_in]
  connect_bd_net -net mgtrefclk0_pad_p_in_0_1 [get_bd_ports mgtrefclk0_pad_p_in_0] [get_bd_pins vid_phy_controller_0/mgtrefclk0_pad_p_in]
  connect_bd_net -net mgtrefclk1_pad_n_in_0_1 [get_bd_ports mgtrefclk1_pad_n_in_0] [get_bd_pins vid_phy_controller_0/mgtrefclk1_pad_n_in]
  connect_bd_net -net mgtrefclk1_pad_p_in_0_1 [get_bd_ports mgtrefclk1_pad_p_in_0] [get_bd_pins vid_phy_controller_0/mgtrefclk1_pad_p_in]
  connect_bd_net -net phy_rxn_in_0_1 [get_bd_ports phy_rxn_in_0] [get_bd_pins vid_phy_controller_0/phy_rxn_in]
  connect_bd_net -net phy_rxp_in_0_1 [get_bd_ports phy_rxp_in_0] [get_bd_pins vid_phy_controller_0/phy_rxp_in]
  connect_bd_net -net pwm_rgb_0_RGB [get_bd_pins uio/pl_rgb_led] [get_bd_ports pl_rgb_led]
  connect_bd_net -net rst_ps8_0_100M_peripheral_aresetn [get_bd_pins rst_ps8_0_100M/peripheral_aresetn] [get_bd_pins v_tpg_ss_0/s_axi_aresetn_0] [get_bd_pins ps8_0_axi_periph/M08_ARESETN] [get_bd_pins ps8_0_axi_periph/M09_ARESETN] [get_bd_pins rx_video_axis_reg_slice/aresetn] [get_bd_pins tx_video_axis_reg_slice/aresetn] [get_bd_pins v_hdmi_rx_ss_0/s_axis_video_aresetn] [get_bd_pins v_hdmi_tx_ss_0/s_axis_video_aresetn]
  connect_bd_net -net rst_ps8_0_50M_interconnect_aresetn [get_bd_pins rst_ps8_0_50M/interconnect_aresetn] [get_bd_pins ps8_0_axi_periph/ARESETN]
  connect_bd_net -net rst_ps8_0_50M_peripheral_aresetn [get_bd_pins rst_ps8_0_50M/peripheral_aresetn] [get_bd_pins audio_ss_0/ARESETN] [get_bd_pins audio_test/axi_resetn] [get_bd_pins set_vadj_level/s_axi_aresetn] [get_bd_pins short_loopback_tests/s_axi_aresetn] [get_bd_pins uio/s_axi_aresetn] [get_bd_pins Control_SI5342_LOLN/s_axi_aresetn] [get_bd_pins axi_iic_0/s_axi_aresetn] [get_bd_pins axi_iic_1/s_axi_aresetn] [get_bd_pins axi_smc/aresetn] [get_bd_pins gpio_sfp_ip/s_axi_aresetn] [get_bd_pins ps8_0_axi_periph/S00_ARESETN] [get_bd_pins ps8_0_axi_periph/M00_ARESETN] [get_bd_pins ps8_0_axi_periph/M01_ARESETN] [get_bd_pins ps8_0_axi_periph/M02_ARESETN] [get_bd_pins ps8_0_axi_periph/M03_ARESETN] [get_bd_pins ps8_0_axi_periph/M04_ARESETN] [get_bd_pins ps8_0_axi_periph/M05_ARESETN] [get_bd_pins ps8_0_axi_periph/M06_ARESETN] [get_bd_pins ps8_0_axi_periph/M07_ARESETN] [get_bd_pins ps8_0_axi_periph/M10_ARESETN] [get_bd_pins ps8_0_axi_periph/M11_ARESETN] [get_bd_pins ps8_0_axi_periph/M12_ARESETN] [get_bd_pins ps8_0_axi_periph/M13_ARESETN] [get_bd_pins ps8_0_axi_periph/M14_ARESETN] [get_bd_pins ps8_0_axi_periph/M15_ARESETN] [get_bd_pins ps8_0_axi_periph/M16_ARESETN] [get_bd_pins ps8_0_axi_periph/M17_ARESETN] [get_bd_pins ps8_0_axi_periph/M18_ARESETN] [get_bd_pins ps8_0_axi_periph/M19_ARESETN] [get_bd_pins ps8_0_axi_periph/M20_ARESETN] [get_bd_pins ps8_0_axi_periph/M21_ARESETN] [get_bd_pins ps8_0_axi_periph/M22_ARESETN] [get_bd_pins ps8_0_axi_periph/M23_ARESETN] [get_bd_pins ps8_0_axi_periph/M24_ARESETN] [get_bd_pins ps8_0_axi_periph/M25_ARESETN] [get_bd_pins ps8_0_axi_periph/M26_ARESETN] [get_bd_pins ps8_0_axi_periph/M27_ARESETN] [get_bd_pins ps8_0_axi_periph/M28_ARESETN] [get_bd_pins v_hdmi_rx_ss_0/s_axi_cpu_aresetn] [get_bd_pins v_hdmi_tx_ss_0/s_axi_cpu_aresetn] [get_bd_pins vid_phy_controller_0/vid_phy_sb_aresetn] [get_bd_pins vid_phy_controller_0/vid_phy_axi4lite_aresetn]
  connect_bd_net -net uio_ip2intc_irpt [get_bd_pins uio/ip2intc_irpt] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net uio_ip2intc_irpt1 [get_bd_pins uio/ip2intc_irpt1] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins util_vector_logic_0/Res] [get_bd_ports dp_aux_doe]
  connect_bd_net -net v_hdmi_rx_ss_0_fid [get_bd_pins v_hdmi_rx_ss_0/fid] [get_bd_pins v_hdmi_tx_ss_0/fid]
  connect_bd_net -net v_hdmi_rx_ss_0_hpd [get_bd_pins v_hdmi_rx_ss_0/hpd] [get_bd_ports hdmi_rx_hpd]
  connect_bd_net -net v_hdmi_rx_ss_0_irq [get_bd_pins v_hdmi_rx_ss_0/irq] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net v_hdmi_tx_ss_0_irq [get_bd_pins v_hdmi_tx_ss_0/irq] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net vid_phy_controller_0_irq [get_bd_pins vid_phy_controller_0/irq] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net vid_phy_controller_0_phy_txn_out [get_bd_pins vid_phy_controller_0/phy_txn_out] [get_bd_ports phy_txn_out_0]
  connect_bd_net -net vid_phy_controller_0_phy_txp_out [get_bd_pins vid_phy_controller_0/phy_txp_out] [get_bd_ports phy_txp_out_0]
  connect_bd_net -net vid_phy_controller_0_rx_tmds_clk_n [get_bd_pins vid_phy_controller_0/rx_tmds_clk_n] [get_bd_ports hdmi_rec_clk_n]
  connect_bd_net -net vid_phy_controller_0_rx_tmds_clk_p [get_bd_pins vid_phy_controller_0/rx_tmds_clk_p] [get_bd_ports hdmi_rec_clk_p]
  connect_bd_net -net vid_phy_controller_0_rx_video_clk [get_bd_pins vid_phy_controller_0/rx_video_clk] [get_bd_pins v_hdmi_rx_ss_0/video_clk]
  connect_bd_net -net vid_phy_controller_0_tx_tmds_clk_n [get_bd_pins vid_phy_controller_0/tx_tmds_clk_n] [get_bd_ports hdmi_tx_clk_c_n]
  connect_bd_net -net vid_phy_controller_0_tx_tmds_clk_p [get_bd_pins vid_phy_controller_0/tx_tmds_clk_p] [get_bd_ports hdmi_tx_clk_c_p]
  connect_bd_net -net vid_phy_controller_0_tx_video_clk [get_bd_pins vid_phy_controller_0/tx_video_clk] [get_bd_pins v_hdmi_tx_ss_0/video_clk]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins xlconcat_0/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins xlconcat_1/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq1]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconstant_0/dout] [get_bd_ports hdmi_tx_oe] [get_bd_pins vid_phy_controller_0/vid_phy_tx_axi4s_aresetn] [get_bd_pins vid_phy_controller_0/vid_phy_rx_axi4s_aresetn]
  connect_bd_net -net zynq_ultra_ps_e_0_dp_aux_data_oe_n [get_bd_pins zynq_ultra_ps_e_0/dp_aux_data_oe_n] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net zynq_ultra_ps_e_0_dp_aux_data_out [get_bd_pins zynq_ultra_ps_e_0/dp_aux_data_out] [get_bd_ports dp_aux_dout]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins audio_ss_0/ACLK] [get_bd_pins audio_test/m_axi_mm2s_aclk] [get_bd_pins set_vadj_level/s_axi_aclk] [get_bd_pins short_loopback_tests/s_axi_aclk] [get_bd_pins uio/s_axi_aclk] [get_bd_pins rst_ps8_0_50M/slowest_sync_clk] [get_bd_pins Control_SI5342_LOLN/s_axi_aclk] [get_bd_pins axi_iic_0/s_axi_aclk] [get_bd_pins axi_iic_1/s_axi_aclk] [get_bd_pins axi_smc/aclk] [get_bd_pins gpio_sfp_ip/s_axi_aclk] [get_bd_pins ps8_0_axi_periph/ACLK] [get_bd_pins ps8_0_axi_periph/S00_ACLK] [get_bd_pins ps8_0_axi_periph/M00_ACLK] [get_bd_pins ps8_0_axi_periph/M01_ACLK] [get_bd_pins ps8_0_axi_periph/M02_ACLK] [get_bd_pins ps8_0_axi_periph/M03_ACLK] [get_bd_pins ps8_0_axi_periph/M04_ACLK] [get_bd_pins ps8_0_axi_periph/M05_ACLK] [get_bd_pins ps8_0_axi_periph/M06_ACLK] [get_bd_pins ps8_0_axi_periph/M07_ACLK] [get_bd_pins ps8_0_axi_periph/M10_ACLK] [get_bd_pins ps8_0_axi_periph/M11_ACLK] [get_bd_pins ps8_0_axi_periph/M12_ACLK] [get_bd_pins ps8_0_axi_periph/M13_ACLK] [get_bd_pins ps8_0_axi_periph/M14_ACLK] [get_bd_pins ps8_0_axi_periph/M15_ACLK] [get_bd_pins ps8_0_axi_periph/M16_ACLK] [get_bd_pins ps8_0_axi_periph/M17_ACLK] [get_bd_pins ps8_0_axi_periph/M18_ACLK] [get_bd_pins ps8_0_axi_periph/M19_ACLK] [get_bd_pins ps8_0_axi_periph/M20_ACLK] [get_bd_pins ps8_0_axi_periph/M21_ACLK] [get_bd_pins ps8_0_axi_periph/M22_ACLK] [get_bd_pins ps8_0_axi_periph/M23_ACLK] [get_bd_pins ps8_0_axi_periph/M24_ACLK] [get_bd_pins ps8_0_axi_periph/M25_ACLK] [get_bd_pins ps8_0_axi_periph/M26_ACLK] [get_bd_pins ps8_0_axi_periph/M27_ACLK] [get_bd_pins ps8_0_axi_periph/M28_ACLK] [get_bd_pins v_hdmi_rx_ss_0/s_axi_cpu_aclk] [get_bd_pins v_hdmi_tx_ss_0/s_axi_cpu_aclk] [get_bd_pins vid_phy_controller_0/vid_phy_sb_aclk] [get_bd_pins vid_phy_controller_0/vid_phy_axi4lite_aclk] [get_bd_pins vid_phy_controller_0/drpclk] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_lpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihp0_fpd_aclk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk2 [get_bd_pins zynq_ultra_ps_e_0/pl_clk2] [get_bd_pins v_tpg_ss_0/ap_clk] [get_bd_pins rst_ps8_0_100M/slowest_sync_clk] [get_bd_pins ps8_0_axi_periph/M08_ACLK] [get_bd_pins ps8_0_axi_periph/M09_ACLK] [get_bd_pins rx_video_axis_reg_slice/aclk] [get_bd_pins tx_video_axis_reg_slice/aclk] [get_bd_pins v_hdmi_rx_ss_0/s_axis_video_aclk] [get_bd_pins v_hdmi_tx_ss_0/s_axis_video_aclk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins rst_ps8_0_100M/ext_reset_in] [get_bd_pins rst_ps8_0_50M/ext_reset_in]

  # Create address segments
  assign_bd_address -offset 0x80006000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs Control_SI5342_LOLN/S_AXI/Reg] -force
  assign_bd_address -offset 0x80140000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs short_loopback_tests/PG_VADJ_R/S_AXI/Reg] -force
  assign_bd_address -offset 0x90000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs audio_ss_0/aud_pat_gen/axi/reg0] -force
  assign_bd_address -offset 0x80070000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs audio_test/axi_dma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x80080000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs audio_test/axi_dma_1/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x80090000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs audio_test/axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x80160000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs set_vadj_level/axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x80004000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs v_tpg_ss_0/axi_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x80000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs uio/axi_gpio_btn/S_AXI/Reg] -force
  assign_bd_address -offset 0x80002000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs uio/axi_gpio_led/S_AXI/Reg] -force
  assign_bd_address -offset 0x80001000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs uio/axi_gpio_sw/S_AXI/Reg] -force
  assign_bd_address -offset 0x80170000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_iic_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x800A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_iic_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x80040000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs audio_ss_0/clk_wiz/s_axi_lite/Reg] -force
  assign_bd_address -offset 0x800B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs audio_test/digilent_axi_i2s_0/AXI_L/AXI_L_reg] -force
  assign_bd_address -offset 0x800C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs short_loopback_tests/fmc_prsnt/S_AXI/Reg] -force
  assign_bd_address -offset 0x80130000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs gpio_sfp_ip/S_AXI/Reg] -force
  assign_bd_address -offset 0x88000000 -range 0x08000000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs audio_ss_0/hdmi_acr_ctrl/axi/reg0] -force
  assign_bd_address -offset 0x800D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs short_loopback_tests/la_00/S_AXI/Reg] -force
  assign_bd_address -offset 0x800E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs short_loopback_tests/la_01/S_AXI/Reg] -force
  assign_bd_address -offset 0x800F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs short_loopback_tests/mipi_ffc_a/S_AXI/Reg] -force
  assign_bd_address -offset 0x80100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs short_loopback_tests/mipi_ffc_b/S_AXI/Reg] -force
  assign_bd_address -offset 0x80110000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs short_loopback_tests/pmods/S_AXI/Reg] -force
  assign_bd_address -offset 0x80003000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs uio/pwm_rgb_led/S_AXI/S_AXI_reg] -force
  assign_bd_address -offset 0x80120000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs short_loopback_tests/syszygy/S_AXI/Reg] -force
  assign_bd_address -offset 0x80150000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs short_loopback_tests/syzygy_detectedn/S_AXI/Reg] -force
  assign_bd_address -offset 0x80010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs v_hdmi_rx_ss_0/S_AXI_CPU_IN/Reg] -force
  assign_bd_address -offset 0x80020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs v_hdmi_tx_ss_0/S_AXI_CPU_IN/Reg] -force
  assign_bd_address -offset 0x80060000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs v_tpg_ss_0/v_tpg/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0x80050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs vid_phy_controller_0/vid_phy_axi4lite/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces audio_test/axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces audio_test/axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces audio_test/axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces audio_test/axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces audio_test/axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces audio_test/axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces audio_test/axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces audio_test/axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces audio_test/axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces audio_test/axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces audio_test/axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces audio_test/axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces audio_test/axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_HIGH]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces audio_test/axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM]
  exclude_bd_addr_seg -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces audio_test/axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_HIGH]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces audio_test/axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM]
  exclude_bd_addr_seg -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces audio_test/axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_HIGH]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces audio_test/axi_dma_1/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM]
  exclude_bd_addr_seg -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces audio_test/axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_HIGH]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces audio_test/axi_dma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM]


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


