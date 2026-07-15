# RA-PMCM: Redundancy-Aware Pipelined Multiple Constant Multiplication

This repository provides the official open-source implementation for the paper:  
**"Exact Redundancy-Aware Co-Optimization for Pipelined Multiple Constant Multiplication."**

The proposed integer linear programming (ILP) framework globally minimizes the net register bit count in PMCM circuits by inherently embedding stage-wise least significant bit (LSB) redundancy elimination directly into the topology generation search space. This repository contains both the exact mathematical optimization models and the automated RTL generation/evaluation toolchain.

## Repository Structure

```text
RA-PMCM/
├── README.md
├── example.jl                         # Minimal example for quick testing
├── src/
│   └── RA_PMCM.jl                     # Core ILP mathematical formulation
├── scripts/
│   └── run_experiments.jl             # Automated benchmark execution script (Table I)
└── hardware/
    ├── verilog_generator.py           # Generates RTL (.v) from topology configurations
    ├── run_vivado.py                  # Batch execution controller for Vivado
    └── run_vivado.tcl                 # Vivado synthesis & implementation constraints (OOC mode)# RA-PMCM
