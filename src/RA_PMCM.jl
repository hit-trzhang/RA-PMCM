# ==========================================
# RA-PMCM Core Mathematical Formulation
# ==========================================
using JuMP, Gurobi

# --- Helper Functions ---
function get_min_wordlength(number::Int)
    return round(Int, max(log2(odd(abs(number))), 1), RoundUp)
end

function get_min_number_of_adders(C::Vector{Int})
    oddabsC = sort!(filter!(x -> x > 1, unique!(odd.(abs.(C)))), by=x->sum_nonzero(int2csd(x)))
    csd_stage = round.(Int, log2.(sum_nonzero.(int2csd.(oddabsC))), RoundUp)
    return maximum(csd_stage)
end

get_min_number_of_adders(C::Int) = get_min_number_of_adders([C])

function get_max_number_of_adders(C::Vector{Int})
    oddabsC = sort!(filter!(x -> x > 1, unique!(odd.(abs.(C)))), by=x->sum_nonzero(int2csd(x)))
    return sum(sum_nonzero(int2csd(val))-1 for val in oddabsC)
end

function odd(number::Int)
    if number == 0 return 0 end
    while mod(number, 2) == 0
        number = div(number, 2)
    end
    return number
end

function int2bin(number::Int)
    @assert number >= 0
    return reverse(digits(number, base=2))
end

function bin2csd!(vector_bin2csd::Vector{Int})
    @assert issubset(unique(vector_bin2csd), [-1,0,1])
    first_non_zero = 0
    for i in length(vector_bin2csd):-1:1
        if vector_bin2csd[i] != 0
            if first_non_zero == 0
                first_non_zero = i
            end
        elseif first_non_zero - i >= 2
            for j in (i+1):first_non_zero
                vector_bin2csd[j] = 0
            end
            vector_bin2csd[first_non_zero] = -1
            vector_bin2csd[i] = 1
            first_non_zero = i
        else
            first_non_zero = 0
        end
    end
    if first_non_zero > 1
        for j in 1:first_non_zero
            vector_bin2csd[j] = 0
        end
        vector_bin2csd[first_non_zero] = -1
        pushfirst!(vector_bin2csd, 1)
    end
    return vector_bin2csd
end

function bin2csd(vector_bin::Vector{Int})
    @assert issubset(unique(vector_bin), [-1,0,1])
    vector_csd = copy(vector_bin)
    return bin2csd!(vector_csd)
end

function int2csd(number::Int)
    return bin2csd!(int2bin(number))
end

function sum_nonzero(vector_binorcsd::Vector{Int})
    @assert issubset(unique(vector_binorcsd), [-1,0,1])
    sum = 0
    for i in vector_binorcsd
        if i != 0 sum += 1 end
    end
    return sum
end

# --- Core ILP Model Builder ---
"""
    build_pmcm_model(C::Vector{Int}, NA::Int, reg_save_option::Bool)

Builds and returns the JuMP model and a dictionary of variable references for PMCM structure optimization.
"""
function build_pmcm_model(C::Vector{Int}, NA::Int, reg_save_option::Bool)
    bit_level = true
    NO = length(C)
    wordlength = maximum(get_min_wordlength.(C))
    min_stage = get_min_number_of_adders(C)
    M = 2^(wordlength)
    Smin, Smax = -wordlength, wordlength
    STAGE = min_stage
    wordlength_in = 8 

    model = Model(Gurobi.Optimizer)
    
    # Node mapping and stage assignment
    @variable(model, 1 <= ca[0:NA] <= M-1, Int)
    @variable(model, ca_stage[0:NA, 0:STAGE], Bin)
    
    fix(ca[0], 1, force=true)
    for a in NA-NO+1:NA
        fix(ca[a], C[a+NO-NA], force=true)
    end

    @constraint(model, [a in 0:NA], ca[a] <= 1 + (1 - ca_stage[a,0])*M)
    if STAGE > 1
        @constraint(model, [a in 1:NA, k in 0:(a-1), s in 1:STAGE-1], ca[k] + 1 <= ca[a] + (2-ca_stage[a,s]-ca_stage[k,s])*M)
    end

    # Dummy node constraints
    fix(ca_stage[0,0], 1, force=true)
    for s in 1:STAGE
        fix(ca_stage[0,s], 0, force=true)
    end
    for a in NA-NO+1:NA
        fix(ca_stage[a,STAGE], 1, force=true)
    end
    for a in 1:(NA-NO)
        fix(ca_stage[a,STAGE], 0, force=true)
    end

    @constraint(model, [a in 0:NA], sum(ca_stage[a,s] for s in 0:STAGE) == 1)
    @constraint(model, [s in 0:STAGE-1], sum(ca_stage[a,s] for a in 0:NA) >= 1)
    for stage in 0:STAGE
        @constraint(model, [a in 0:NA-1], sum(ca_stage[a,s] for s in 0:stage) >= sum(ca_stage[a+1,s] for s in 0:stage))
    end

    # Topology connections
    @variable(model, connection_add_l[a in 1:NA, k in 0:(a-1)], Bin)
    @variable(model, connection_add_r[a in 1:NA, k in 0:(a-1)], Bin)
    @constraint(model, [a in 1:NA, k in 0:(a-1), s in 0:STAGE-1], connection_add_l[a,k] <= 0 + (1-(ca_stage[a,s+1] - ca_stage[k,s])))
    @constraint(model, [a in 1:NA, k in 0:(a-1), s in 0:STAGE-1], connection_add_r[a,k] <= 0 + (1-(ca_stage[a,s+1] - ca_stage[k,s])))
    @constraint(model, [a in 1:NA], sum(connection_add_l[a,k] for k in 0:(a-1)) == 1)
    @constraint(model, [a in 1:NA], sum(connection_add_r[a,k] for k in 0:(a-1)) == 1)
    
    # Arithmetic logic parameters
    MAX_SH_VAL = M * (2^Smax) 
    @variable(model, 1 <= ca_no_shift[1:NA] <= M*2, Int)
    @variable(model, 1 <= cai[1:NA, 1:2] <= M-1, Int)
    @variable(model, 1 <= cai_left_sh[1:NA] <= MAX_SH_VAL, Int) 
    @variable(model, -MAX_SH_VAL <= cai_left_shsg[1:NA] <= MAX_SH_VAL, Int)
    @variable(model, -M <= cai_right_sg[1:NA] <= M, Int)
    @variable(model, Phiai[1:NA, 1:2], Bin)
    @variable(model, phias[1:NA, 0:Smax], Bin)
    @variable(model, leftshift[1:NA, 0:Smax], Bin)

    @constraint(model, [a in 1:NA], sum(phias[a,s] for s in 0:Smax) == 1)
    @constraint(model, [a in 1:NA], sum(leftshift[a,s] for s in 0:Smax) == 1)
    @constraint(model, [a in 1:NA], leftshift[a,0] + phias[a,0] == 1)
    @constraint(model, [a in 1:NA], Phiai[a,1] + Phiai[a,2] <= 1)

    # Multiplexers and operations
    @variable(model, conn_val_l[a in 1:NA, k in 0:(a-1)] >= 0, Int)
    @constraint(model, [a in 1:NA, k in 0:(a-1)], conn_val_l[a,k] <= M * connection_add_l[a,k])
    @constraint(model, [a in 1:NA, k in 0:(a-1)], conn_val_l[a,k] <= ca[k])
    @constraint(model, [a in 1:NA, k in 0:(a-1)], conn_val_l[a,k] >= ca[k] - M * (1 - connection_add_l[a,k]))
    @constraint(model, [a in 1:NA], cai[a,1] == sum(conn_val_l[a,k] for k in 0:(a-1)))

    @variable(model, conn_val_r[a in 1:NA, k in 0:(a-1)] >= 0, Int)
    @constraint(model, [a in 1:NA, k in 0:(a-1)], conn_val_r[a,k] <= M * connection_add_r[a,k])
    @constraint(model, [a in 1:NA, k in 0:(a-1)], conn_val_r[a,k] <= ca[k])
    @constraint(model, [a in 1:NA, k in 0:(a-1)], conn_val_r[a,k] >= ca[k] - M * (1 - connection_add_r[a,k]))
    @constraint(model, [a in 1:NA], cai[a,2] == sum(conn_val_r[a,k] for k in 0:(a-1)))

    @variable(model, shift_val_l[a in 1:NA, s in 0:Smax] >= 0, Int)
    @constraint(model, [a in 1:NA, s in 0:Smax], shift_val_l[a,s] <= M * phias[a,s])
    @constraint(model, [a in 1:NA, s in 0:Smax], shift_val_l[a,s] <= cai[a,1])
    @constraint(model, [a in 1:NA, s in 0:Smax], shift_val_l[a,s] >= cai[a,1] - M * (1 - phias[a,s]))
    @constraint(model, [a in 1:NA], cai_left_sh[a] == sum(shift_val_l[a,s] * (2^s) for s in 0:Smax))

    @variable(model, sign_val_l[a in 1:NA] >= 0, Int)
    @constraint(model, [a in 1:NA], sign_val_l[a] <= MAX_SH_VAL * Phiai[a,1])
    @constraint(model, [a in 1:NA], sign_val_l[a] <= cai_left_sh[a])
    @constraint(model, [a in 1:NA], sign_val_l[a] >= cai_left_sh[a] - MAX_SH_VAL * (1 - Phiai[a,1]))
    @constraint(model, [a in 1:NA], cai_left_shsg[a] == cai_left_sh[a] - 2 * sign_val_l[a])

    @variable(model, sign_val_r[a in 1:NA] >= 0, Int)
    @constraint(model, [a in 1:NA], sign_val_r[a] <= M * Phiai[a,2])
    @constraint(model, [a in 1:NA], sign_val_r[a] <= cai[a,2])
    @constraint(model, [a in 1:NA], sign_val_r[a] >= cai[a,2] - M * (1 - Phiai[a,2]))
    @constraint(model, [a in 1:NA], cai_right_sg[a] == cai[a,2] - 2 * sign_val_r[a])

    @constraint(model, [a in 1:NA], ca_no_shift[a] == cai_left_shsg[a] + cai_right_sg[a])

    @variable(model, out_shift_val[a in 1:NA, s in 0:Smax] >= 0, Int)
    @constraint(model, [a in 1:NA, s in 0:Smax], out_shift_val[a,s] <= M * leftshift[a,s])
    @constraint(model, [a in 1:NA, s in 0:Smax], out_shift_val[a,s] <= ca[a])
    @constraint(model, [a in 1:NA, s in 0:Smax], out_shift_val[a,s] >= ca[a] - M * (1 - leftshift[a,s]))
    @constraint(model, [a in 1:NA], ca_no_shift[a] == sum(out_shift_val[a,s] * (2^s) for s in 0:Smax))

    # Symmetry breaking and dummy node restrictions
    @constraint(model, [a in 1:NA], connection_add_l[a,0] >= ca_stage[a,0])
    @constraint(model, [a in 1:NA], connection_add_r[a,0] >= ca_stage[a,0])
    @constraint(model, [a in 1:NA], phias[a,0] >= ca_stage[a,0]) 
    @constraint(model, [a in 1:NA], Phiai[a,1] <= 1 - ca_stage[a,0])
    @constraint(model, [a in 1:NA], Phiai[a,2] <= 1 - ca_stage[a,0])
    @constraint(model, [a in 1:NA], leftshift[a,1] >= ca_stage[a,0])

    for a in 1:(NA-NO)
        fan_out = sum(connection_add_l[b,a] + connection_add_r[b,a] for b in (a+1):NA)
        @constraint(model, fan_out >= 1 - ca_stage[a,0])
    end

    # Bit-level Evaluation
    if bit_level
        @variable(model, ca_bin[a in 1:NA, b in 1:wordlength], Bin)
        @constraint(model, [a in 1:NA], ca[a] == sum((2^(b-1)*ca_bin[a,b]) for b in 1:wordlength))
        @constraint(model, [a in 1:NA], ca_bin[a,1] == 1)

        # SOS1 constraints for bit-width bounding
        @variable(model, is_width[a in 1:NA, w in 1:wordlength], Bin)
        @constraint(model, [a in 1:NA], sum(is_width[a,w] for w in 1:wordlength) == 1)
        @constraint(model, [a in 1:NA], ca[a] >= sum(2^(w-1) * is_width[a,w] for w in 1:wordlength))
        @constraint(model, [a in 1:NA], ca[a] <= sum((2^w - 1) * is_width[a,w] for w in 1:wordlength))
        @expression(model, real_width[a in 1:NA], sum(w * is_width[a,w] for w in 1:wordlength))

        # Redundancy Modeling (Proposed Co-Opt)
        if reg_save_option
            @variable(model, ca_last_n_bits[a in 1:NA, b in 2:wordlength-1, k in 0:2^(b-1)-1], Bin)
            for a in 1:NA
                for b in 2:wordlength-1
                    @constraint(model, sum((2^(bit-2)*ca_bin[a,bit]) for bit in 2:b) == sum(ca_last_n_bits[a,b,k]*k for k in 0:2^(b-1)-1))
                end
            end
            @constraint(model, [a in 1:NA, b in 2:wordlength-1], sum(ca_last_n_bits[a,b,k] for k in 0:2^(b-1)-1) == 1)

            @variable(model, u[s in 1:STAGE, b in 2:wordlength-1, k in 0:2^(b-1)-1], Bin)
            for s in 1:STAGE
                for b in 2:wordlength-1
                    for a in 1:NA
                        for k in 0:2^(b-1)-1
                            @constraint(model, u[s,b,k] >= ca_last_n_bits[a,b,k] - (1-ca_stage[a,s]))
                        end
                    end
                end
            end
        end
    else
        @variable(model, ca_bin[a in 1:NA, b in 1:wordlength], Bin)
        @constraint(model, [a in 1:NA], ca[a] == sum((2^(b-1)*ca_bin[a,b]) for b in 1:wordlength))
        @constraint(model, [a in 1:NA], ca_bin[a,1] == 1)
    end

    # Objective Function
    if bit_level
        @expression(model, node_cost[a in 1:NA], real_width[a] + wordlength_in - is_width[a,1])
        @variable(model, active_cost[1:NA] >= 0)
        M_cost = wordlength + wordlength_in + 5 
        @constraint(model, [a in 1:NA], active_cost[a] >= node_cost[a] - M_cost * ca_stage[a,0])
        @expression(model, reg_num_bit, sum(active_cost[a] for a in 1:NA))

        if reg_save_option
            @expression(model, save_bit, (wordlength-1)*sum(sum(ca_stage[a,s] for a in 1:NA) for s in 1:STAGE) - sum(sum(sum(u[s,b,k] for k in 0:2^(b-1)-1) for b in 2:wordlength-1) for s in 1:STAGE) - STAGE)
            @expression(model, obj_function, reg_num_bit - save_bit)
        else
            @expression(model, obj_function, reg_num_bit)
            @expression(model, save_bit, 0) # Dummy expression for consistency
        end
    else
        @expression(model, reg_num, NA-sum(ca_stage[a,0] for a in 1:NA))
        @expression(model, obj_function, reg_num)
        @expression(model, save_bit, 0) 
    end
    
    @objective(model, Min, obj_function)

    # Pack variable references for extraction during solving
    vars = Dict(
        "ca" => ca,
        "ca_stage" => ca_stage,
        "save_bit" => save_bit,
        "STAGE" => STAGE
    )
    
    return model, vars
end