# ==========================================
# Vivado Synthesis & Implementation Script
# ==========================================

# 1. Parse arguments passed from the Python controller
if { $argc != 3 } {
    puts "Error: Expected 3 arguments (module_name, verilog_file, report_dir)"
    exit 1
}

set module_name [lindex $argv 0]
set verilog_file [lindex $argv 1]
set report_dir [lindex $argv 2]

# Target device specified in the experimental setup
set part_num "xc7v585tffg1761-3" 

# 2. Read RTL source
read_verilog $verilog_file

# 3. Synthesis
# Apply Out-Of-Context (OOC) mode to isolate core arithmetic logic evaluation 
# from I/O parasitic routing effects.
synth_design -top $module_name -part $part_num -mode out_of_context

# 4. Timing Constraints
# Define a virtual clock to evaluate the critical path delay and dynamic power.
# A stringent 2.0 ns target clock period is applied.
create_clock -period 2.0 -name clk [get_ports clk]

# 5. Implementation
opt_design
place_design
route_design

# 6. Report Generation
report_utilization -file "$report_dir/${module_name}_util.txt"
report_timing_summary -file "$report_dir/${module_name}_timing.txt"
report_power -file "$report_dir/${module_name}_power.txt"

# 7. Terminate process gracefully
exit