# ==========================================
# Minimal Example for RA-PMCM Optimization
# ==========================================
using Pkg
# Optional: Activate project environment
# Pkg.activate(@__DIR__)

using JuMP, Gurobi

# Include the core model builder
include("src/RA_PMCM.jl")

function run_simple_example()
    println("==================================================")
    println("RA-PMCM Minimal Example")
    println("==================================================")

    # 1. Define target constants and upper bound of nodes
    # Using a small test case (G.3) to ensure fast execution
    C = [3, 21, 159]
    NA = 6
    reg_save_option = true # Enable the proposed redundancy-aware co-optimization
    time_limit_sec = 60.0  # Short time limit for demonstration purposes

    println("Target Constants (C): $C")
    println("Max Nodes (NA): $NA")
    println("RegSave Option: ON")
    println("Time Limit: $time_limit_sec seconds")
    println("--------------------------------------------------")

    # 2. Build the exact ILP model
    println("Building the ILP model...")
    model, vars = build_pmcm_model(C, NA, reg_save_option)

    # 3. Apply time constraints
    set_time_limit_sec(model, time_limit_sec)

    # 4. Execute optimization
    println("\nOptimizing...")
    optimize!(model)

    # 5. Extract and display results
    term_status = termination_status(model)
    println("\n--------------------------------------------------")
    println("Optimization Status: $term_status")

    if has_values(model)
        obj_val = round(Int, objective_value(model))
        saved_bits = round(Int, value(vars["save_bit"]))
        
        println("Objective Value (Net FF count): $obj_val")
        println("Redundant Bits Saved: $saved_bits")
        
        println("\nNode Assignment Details:")
        for a in 0:NA
            val = round(Int, value(vars["ca"][a]))
            # Locate the assigned pipeline stage for each node
            stage_assigned = findfirst(s -> round(Int, value(vars["ca_stage"][a, s])) == 1, 0:vars["STAGE"]) - 1
            
            if stage_assigned == 0 && a != 0
                println("  Node $a:\t[Unused Dummy Node]")
            else
                println("  Node $a:\tValue = $val \t(Stage = $stage_assigned)")
            end
        end
    else
        println("No feasible solution found within the given time limit.")
    end
    println("==================================================")
end

# Trigger the example
run_simple_example()