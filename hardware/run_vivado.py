import os
import subprocess
import time

# ==========================================
# Vivado Batch Execution Controller
# ==========================================

# 1. Resolve absolute paths for the execution environment
script_dir = os.path.dirname(os.path.abspath(__file__))
v_src_dir = os.path.join(script_dir, "v_src")
report_dir = os.path.join(script_dir, "reports")
tcl_script = os.path.join(script_dir, "run_vivado.tcl")

# Ensure the report directory exists
os.makedirs(report_dir, exist_ok=True)

# 2. Retrieve target Verilog files
if not os.path.exists(v_src_dir):
    print(f"Error: Verilog source directory not found at {v_src_dir}")
    exit(1)

verilog_files = [f for f in os.listdir(v_src_dir) if f.endswith(".v")]

if not verilog_files:
    print(f"Warning: No .v files found in {v_src_dir}. Please run verilog_generator.py first.")
    exit(0)

print(f"Found {len(verilog_files)} Verilog files. Starting batch synthesis and implementation...\n" + "="*60)

start_total_time = time.time()

# 3. Execute Vivado process for each module
for v_file in verilog_files:
    module_name = v_file[:-2]
    file_path = os.path.join(v_src_dir, v_file)
    
    print(f"Processing: {module_name} ...")
    start_time = time.time()
    
    # Construct Vivado command for batch mode execution
    # Ensure paths are enclosed in quotes to handle potential spaces in directory names
    cmd = f'vivado -mode batch -notrace -source "{tcl_script}" -tclargs "{module_name}" "{file_path}" "{report_dir}"'
    
    # Execute command. shell=True is required to parse .bat executables and system PATH on Windows.
    subprocess.run(cmd, shell=True)
    
    cost_time = time.time() - start_time
    print(f"Completed: {module_name} | Elapsed Time: {cost_time:.2f} seconds\n" + "-"*60)

total_time = time.time() - start_total_time
print(f"All {len(verilog_files)} modules processed successfully.")
print(f"Total Execution Time: {total_time/60:.2f} minutes.")
print(f"Hardware evaluation reports have been saved to: {report_dir}")