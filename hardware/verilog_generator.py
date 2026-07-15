import math
import os
from collections import defaultdict
from typing import List, Tuple, Optional

# ==========================================
# 1. Basic Helper Functions
# ==========================================
def ceil_log2(x: int) -> int:
    if x <= 0: return 0
    return math.ceil(math.log2(x)) if x > 1 else 0

def get_output_width(c: int, data_width: int) -> int:
    if c == 0: return 1
    return data_width + (ceil_log2(c) if c > 1 else 0)

def is_power_of_two(x: int) -> bool:
    return x > 0 and (x & (x - 1)) == 0

# ==========================================
# 2. Register Cost and Savings Evaluation
# ==========================================
def calculate_total_bitwidth(coefficients: List[int], x_bitwidth: int = 8) -> int:
    max_x = (1 << x_bitwidth) - 1
    total_bits = 0
    for k in coefficients:
        max_val = k * max_x
        bits_needed = 1 if max_val == 0 else max_val.bit_length()
        total_bits += bits_needed
    return total_bits

def calculate_bit_savings(coefficients: List[int], x_bitwidth: int = 8) -> int:
    if not coefficients: return 0
    n = len(coefficients)
    max_x = (1 << x_bitwidth) - 1
    max_val = max(k * max_x for k in coefficients)
    max_bits = max_val.bit_length() if max_val > 0 else 1
    distinct_coeffs = len(set(coefficients))
    max_coeff = max(coefficients)
    
    total_savings = 0
    i = 0
    while i < max_bits:
        mod = 1 << (i + 1)
        groups = set()
        for k in coefficients:
            residue = k % mod
            groups.add(residue)
        num_groups = len(groups)
        total_savings += (n - num_groups)
        
        if mod > max_coeff:
            remaining_bits = max_bits - i - 1
            if remaining_bits > 0:
                total_savings += (n - distinct_coeffs) * remaining_bits
            break
        i += 1
    return total_savings

def int_to_bit_list(width: int, c: int) -> list[int]:
    if width <= 0: raise ValueError("Width must be a positive integer.")
    return [(c >> i) & 1 for i in range(width)]

def count_consecutive_same_elements(list1: List[int], list2: List[int]) -> int:
    count = 0
    for i in range(len(list1)):
        if list1[i] == list2[i]: count += 1
        else: break
    return count

def bitsave_points(stage_constants: list[int]) -> list[list[int]]:
    if not stage_constants: return []
    max_width = max(stage_constants).bit_length()
    bit_lists = []
    for c in stage_constants:
        bit_lists.append(int_to_bit_list(max_width, c))

    result = []
    for i, lst in enumerate(bit_lists):
        current_bits = [stage_constants[i]] * max_width
        if i > 0:
            num_of_same_bits = 0
            num_j = 0
            for j in range(i):
                current_same_bits = count_consecutive_same_elements(bit_lists[i], bit_lists[j])
                if current_same_bits > num_of_same_bits:
                    num_of_same_bits = current_same_bits
                    num_j = j
            current_bits[:num_of_same_bits] = result[num_j][:num_of_same_bits]
        result.append(current_bits)
    return result

def bitsave_in_stage(c: int, points: List[int]) -> int:
    counts = 0
    for bit in points:
        if c != bit: counts += 1
    return counts

def points_to_namestring(points: List[int], stage: int) -> str:
    if len(set(points)) == 1:
        string_name = f'reg_{stage}_{points[-1]}'
    else:
        string_name = f'{{reg_{stage}_{points[-1]}'
        for i in range(len(points) - 1, -1, -1):
            if points[i] != points[-1]:
                string_name += f', reg_{stage}_{points[i]}[{i}]'
        string_name += f'}}'
    return string_name

# ==========================================
# 3. Shift-and-Add Topology Search
# ==========================================
def estimate_lut_cost(c_left_val: int, c_right_val: int, shift_num: int, data_width: int) -> int:
    # Get effective bit-width of both operands
    w_left = get_output_width(c_left_val, data_width)
    w_right = get_output_width(c_right_val, data_width)
    
    # Estimate adder width by aligning operands based on the shift value
    return max(w_left + shift_num, w_right)

def cal_shift_and_add(constant_list: List[int], c: int, shift_max: int, data_width: int = 8) -> Optional[List[int]]:
    if c in constant_list:
        return [constant_list.index(c), 0, 0, 0, 0]

    n = len(constant_list)
    valid_solutions = []

    # Iterate through all possible operand and shift combinations
    for c_left in range(n):
        val_left = constant_list[c_left]
        for c_right in range(n):
            val_right = constant_list[c_right]
            for shift_num in range(shift_max + 1):
                # Case 1: (left << shift) + right
                if val_left * (1 << shift_num) + val_right == c:
                    valid_solutions.append([c_left, c_right, shift_num, 1])
                # Case 1 variant: (left << shift) - right
                if val_left * (1 << shift_num) - val_right == c:
                    valid_solutions.append([c_left, c_right, shift_num, -1])
                # Case 2: right - (left << shift)
                if val_right - val_left * (1 << shift_num) == c:
                    valid_solutions.append([c_left, c_right, shift_num, 2])
                
                # Case 3: Pre-addition followed by shift
                if val_left + val_right == (c << shift_num):
                    valid_solutions.append([c_left, c_right, shift_num, 3, 1])
                if val_left - val_right == (c << shift_num):
                    valid_solutions.append([c_left, c_right, shift_num, 3, -1])

    if not valid_solutions:
        return None

    # Structural Optimization: Find the solution with minimum estimated LUT cost
    best_solution = None
    min_lut_cost = float('inf')

    for sol in valid_solutions:
        left_val = constant_list[sol[0]]
        right_val = constant_list[sol[1]]
        shift_val = sol[2]
        
        if len(sol) == 4: # Standard shift-add/sub
            cost = estimate_lut_cost(left_val, right_val, shift_val, data_width)
        else: # Pre-add and shift
            cost = max(get_output_width(left_val, data_width), get_output_width(right_val, data_width)) + 1
        
        if cost < min_lut_cost:
            min_lut_cost = cost
            best_solution = sol

    return best_solution

# ==========================================
# 4. Verilog Code Generator
# ==========================================
def generate_verilog_module(stage_constants: List[List[int]], data_width: int=8, module_name: str="PMCM_addergraph", enable_reg_save: bool=True) -> str:
    verilog = f"module {module_name}\n"
    verilog += "#(\n    parameter DATA_WIDTH = {}\n)\n(\n".format(data_width)
    verilog += "    input                               clk,\n"
    verilog += "    input          [DATA_WIDTH-1:0]     x_in,\n"
    
    # --- Output Ports ---
    ports = []
    for c in stage_constants[-1]:
        width = get_output_width(c, data_width)
        port_name = f"wire_o_{c}"
        if width == 1:
            ports.append(f"    output                              {port_name}")
        else:
            ports.append(f"    output         [{width-1}:0]     {port_name}")
    verilog += ",\n".join(ports) + "\n);\n\n"

    # --- Wires ---
    verilog += "\n    // ============ Wires ============\n"
    for stage in range(len(stage_constants)):
        for c in stage_constants[stage]:
            width = get_output_width(c, data_width)
            verilog += f"    wire    [{width-1}:0]    wire_{stage+1}_{c};\n"

    # --- Registers (with LSB Redundancy Elimination) ---
    verilog += "\n    // ============ Registers ============\n"
    for stage in range(len(stage_constants)):
        for i, c in enumerate(stage_constants[stage]):
            width = get_output_width(c, data_width)
            if enable_reg_save:
                points = bitsave_points(stage_constants[stage])
                savebit = bitsave_in_stage(c, points[i])
                # Truncate the LSB index directly to naturally resolve routing alignment
                if savebit == 0:
                    verilog += f"    reg     [{width-1}:0]    reg_{stage+1}_{c};\n"
                else:
                    verilog += f"    reg     [{width-1}:{savebit}]    reg_{stage+1}_{c};\n"
            else:
                verilog += f"    reg     [{width-1}:0]    reg_{stage+1}_{c};\n"

    # --- Node References ---
    reg_adder_name = []
    for idx, sublist in enumerate(stage_constants, start=1):
        row = []
        if enable_reg_save:
            points = bitsave_points(sublist)
            for k in points:
                row.append(points_to_namestring(k, idx))
        else:
            for c in sublist:
                row.append(f"reg_{idx}_{c}")
        reg_adder_name.append(row)

    # --- Combinational Logic (Assign) ---
    verilog += "\n    // ============ Combinational Logic ============\n"
    shift_max = get_output_width(max(stage_constants[-1]), data_width)
    
    for stage, constants in enumerate(stage_constants, start=1):
        for i, c in enumerate(constants):
            if stage == 1:
                shift_and_add = cal_shift_and_add([1], c, shift_max, data_width)
                if shift_and_add is None:
                    raise ValueError(f"Stage 1 cannot synthesize constant {c} from input [1].")
                
                if shift_and_add == [0,0,0,0,0]:
                    verilog += f"    assign wire_{stage}_{c} = x_in;\n"
                else:
                    if shift_and_add[3] == 1:
                        verilog += f"    assign wire_{stage}_{c} = (x_in<<{shift_and_add[2]}) + x_in;\n"
                    if shift_and_add[3] == -1:
                        verilog += f"    assign wire_{stage}_{c} = (x_in<<{shift_and_add[2]}) - x_in;\n"

            if stage > 1:
                shift_and_add = cal_shift_and_add(stage_constants[stage-2], c, shift_max, data_width)
                if shift_and_add is None:
                    raise ValueError(f"Constant {c} in Stage {stage} cannot be generated from the previous stage. Topology error detected.")
                
                left_op = reg_adder_name[stage-2][shift_and_add[0]]
                if shift_and_add == [0,0,0,0,0] or shift_and_add[3] == 0:
                    verilog += f"    assign wire_{stage}_{c} = {left_op};\n"
                else:
                    right_op = reg_adder_name[stage-2][shift_and_add[1]]
                    if shift_and_add[3] == 1:
                        verilog += f"    assign wire_{stage}_{c} = ({left_op}<<{shift_and_add[2]}) + {right_op};\n"
                    if shift_and_add[3] == -1:
                        verilog += f"    assign wire_{stage}_{c} = ({left_op}<<{shift_and_add[2]}) - {right_op};\n"
                    if shift_and_add[3] == 2:
                        verilog += f"    assign wire_{stage}_{c} = {right_op} - ({left_op}<<{shift_and_add[2]});\n"
                    if shift_and_add[3] == 3:  
                        if shift_and_add[4] == 1:
                            verilog += f"    assign wire_{stage}_{c} = ({{{shift_and_add[2]}'b0, {left_op}}} + {{{shift_and_add[2]}'b0, {right_op}}})>>{shift_and_add[2]};\n"
                        if shift_and_add[4] == -1:
                            verilog += f"    assign wire_{stage}_{c} = ({{{shift_and_add[2]}'b0, {left_op}}} - {{{shift_and_add[2]}'b0, {right_op}}})>>{shift_and_add[2]};\n"

    # --- Sequential Logic (Always) ---
    verilog += "\n    // ============ Sequential Logic ============\n"
    verilog += f"    always@(posedge clk) begin\n"
    for stage, constants in enumerate(stage_constants, start=1):
        for i, c in enumerate(constants):
            width = get_output_width(c, data_width)
            if enable_reg_save:
                points = bitsave_points(constants)
                savebit = bitsave_in_stage(c, points[i])
                verilog += f"        reg_{stage}_{c} <= wire_{stage}_{c}[{width-1}:{savebit}];\n"
            else:
                verilog += f"        reg_{stage}_{c} <= wire_{stage}_{c};\n"
    verilog += f"    end\n"

    # --- Output Assignment ---
    verilog += "\n    // ============ Outputs ============\n"
    output_constants = stage_constants[-1]
    output_constants_name = reg_adder_name[-1]
    for i, c in enumerate(output_constants):
        verilog += f"    assign wire_o_{c} = {output_constants_name[i]};\n"
    verilog += "\nendmodule\n"

    return verilog

# ==========================================
# 5. Execution Controller & Benchmark Library
# ==========================================
if __name__ == "__main__":
    # Benchmark topologies library
    all_test_cases = {
        "G3": [[1, 5], [3, 21, 159]],
        "G5_jmcm": [[1, 5], [1, 19, 39], [1, 23, 343, 1267]],
        "G5": [[1, 5], [1, 21, 161], [1, 23, 343, 1267]],
        "HP5": [[1, 7], [1, 3, 5, 7, 121]],
        "HP9": [[1, 3], [1, 3, 5, 7, 11, 125]],
        "HP15": [[1, 3, 5], [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 507]],
        "L3": [[5, 7], [5, 21, 107]],
        "LP5": [[1, 3, 7], [11, 33, 35, 53, 103]],
        "LP9": [[1, 5, 7, 17], [1, 5, 7, 25, 31, 63, 65, 67, 73, 97, 117, 165, 303]],
        "LP15_jmcm": [[1, 5], [1, 9, 13, 17, 37, 75], [1, 5, 7, 13, 17, 19, 21, 27, 41, 43, 45, 53, 61, 79, 93, 101, 103, 113, 133, 137, 199, 331, 333, 613, 1097, 1197]],
        "LP15": [[1, 5], [1, 9, 13, 17, 45, 75], [1, 5, 7, 13, 17, 19, 21, 27, 41, 43, 45, 53, 61, 79, 93, 101, 103, 113, 133, 137, 199, 331, 333, 613, 1097, 1197]],
        "U3_1": [[1, 5], [3, 11, 69]],
        "U3_2": [[1, 5], [1, 85], [43, 171, 1109]]
    }

    # Select benchmarks to generate
    cases_to_run = list(all_test_cases.keys()) 

    data_width = 8
    
    # Resolve absolute path to ensure correct output directory (hardware/v_src)
    script_dir = os.path.dirname(os.path.abspath(__file__))
    output_dir = os.path.join(script_dir, "v_src")
    os.makedirs(output_dir, exist_ok=True)

    print(f"🚀 Starting batch Verilog RTL generation to '{output_dir}'...\n" + "="*50)

    for case_name in cases_to_run:
        if case_name not in all_test_cases:
            print(f"⚠️ Warning: Test case '{case_name}' not found. Skipping.")
            continue
            
        stage_constants = all_test_cases[case_name]
        print(f"🔄 Processing test case: {case_name}")
        
        # --- Theoretical Data Evaluation ---
        reg_counts = 0
        reg_save = 0
        for constants in stage_constants:
            reg_counts += calculate_total_bitwidth(constants, data_width)
            reg_save += calculate_bit_savings(constants)
        print(f"   [Theoretical Bound] Baseline: {reg_counts} FFs | Proposed: {reg_counts - reg_save} FFs (Saved {reg_save} bits)")

        try:
            # --- Generate Model 1: Proposed Co-Opt (with LSB redundancy elimination) ---
            module_name_coopt = f"{case_name}_coopt"
            verilog_proposed = generate_verilog_module(stage_constants, data_width, module_name_coopt, enable_reg_save=True)
            with open(os.path.join(output_dir, f"{module_name_coopt}.v"), "w") as f:
                f.write(verilog_proposed)

            # --- Generate Model 2: Baseline (independent registers) ---
            module_name_baseline = f"{case_name}_baseline"
            verilog_baseline = generate_verilog_module(stage_constants, data_width, module_name_baseline, enable_reg_save=False)
            with open(os.path.join(output_dir, f"{module_name_baseline}.v"), "w") as f:
                f.write(verilog_baseline)

            print(f"✅ Successfully generated: {module_name_coopt}.v and {module_name_baseline}.v\n" + "-"*50)
            
        except ValueError as e:
            print(f"❌ Generation failed [{case_name}]: {e}\n" + "-"*50)

    print(f"🎉 All generation tasks completed! Please check the '{output_dir}' directory.")