set DESIGN rtc_main
set clockname rtc_clk
set_db auto_ungroup none
set_db / .information_level 7
set SYSTEM_NAME mec-pdint26-u51
###############################################################
## Library setup
###############################################################

set_db library [list \
/home/sclpdk_new/SCLPDK_V3.0_KIT/scl180/stdcell/fs120/6M1L/liberty/lib_flow_ss/tsl18fs120_scl_ss.lib \
/home/sclpdk_new/SCLPDK_V3.0_KIT/scl180/iopad/cio150/6M1L/liberty/tsl18cio150_max.lib \
/home/sclpdk_new/SCLPDK_V3.0_KIT/scl180/stdcell/fs120/6M1L/liberty/lib_flow_ff/tsl18fs120_scl_ff.lib \
/home/sclpdk_new/SCLPDK_V3.0_KIT/scl180/iopad/cio150/6M1L/liberty/tsl18cio150_min.lib \
]

read_hdl /home/${SYSTEM_NAME}/Internship_26/RTC/Inputs_RTC/rtc_main.v

elaborate $DESIGN
puts "Runtime & Memory after 'read_hdl'"
time_info Elaboration
check_design -unresolved

read_sdc /home/${SYSTEM_NAME}/Internship_26/RTC/Synthesis_RTC/constraints.sdc

report_timing -lint -verbose
set_db lp_power_analysis_effort high

#Generic Synthesis
set_db / .syn_generic_effort medium
syn_generic 
puts "Runtime & Memory after 'syn_generic'"
time_info GENERIC

report_dp  > ../report_files/generic/design_datapath.rpt
write_hdl  > ../output_files/design_generic.v 
write_sdc  >../output_files/design_generic.sdc

#Map Synthesis
set_db / .syn_map_effort high 
syn_map 
puts "Runtime & Memory after 'syn_map'"
time_info GENERIC

report_dp > ../report_files/map/design_datapath.rpt
write_hdl > ../output_files/design_map.v
write_sdc >../output_files/design_map.sdc                                                                                             


set_db / .syn_opt_effort high 
syn_opt
puts "Runtime & Memory after 'syn_opt'"
time_info OP

write_hdl  >  ../output_files/design_incremental.v 
write_sdc  > ../output_files/design_incremental.sdc
#################################
### write_do_lec
#################################
write_do_lec -revised_design fv_map -logfile ../log_files/rtl2intermediate.lec.log > ../output_files/rtl2intermediate.lec.do

write_do_lec -golden_design fv_map -revised_design ../output_files/design_incremental.v -logfile ../log_files/intermediate2final.lec.log > ../output_files/intermediate2final.lec.do


# PPA Reports

report_power   > ../report_files/design_power.rpt
report_area    > ../report_files/design_area.rpt
report_timing  > ../report_files/design_timing.rpt
report_gates   > ../report_files/design_gates.rpt


###### SDF file Generation ############
write_sdf -version 2.1 -recrem split -setuphold merge_when_paired -edges check_edge > ../output_files/design_synth.sdf

puts "Synthesis Finished ........."
puts "============================"