# RA-PMCM: Redundancy-Aware Pipelined Multiple Constant Multiplication

Code and benchmark artifacts accompanying **Exact Redundancy-Aware
Co-Optimization for Pipelined Multiple Constant Multiplication**.

The ILP model minimizes net register cost by accounting for stage-wise LSB
sharing during topology optimization. Optimality is conditional on the specified
node, coefficient, shift, and pipeline-depth bounds and a solver certificate.
A time-limited feasible solution is not an optimality certificate.

## Repository contents

- `src/RA_PMCM.jl`: JuMP/Gurobi model.
- `example.jl`: a 60-second G.3 example.
- `scripts/run_experiments.jl`: all 11 target coefficient sets and node bounds;
  default execution uses sharing-aware optimization with a 1800-second limit.
- `hardware/verilog_generator.py`: saved topologies and RTL generation.
- `hardware/v_src/`: 26 generated RTL files.
- `hardware/run_vivado.py` and `hardware/run_vivado.tcl`: implementation flow.
- [Reproduction notes](docs/REPRODUCIBILITY.md): table-to-file mapping and limitations.

There are two separate workflows: **solve new topologies** and **evaluate saved
hardware designs**. The current scripts do not automatically transfer new solver
results into the RTL generator. Benchmark coefficients and saved topologies are
shared input data embedded in the source files.

## Installation

Requirements: Julia with JuMP and Gurobi.jl, Python 3, and a valid Gurobi license.
Python scripts use only the standard library. Hardware evaluation additionally
requires Vivado with support for the target Virtex-7 device.

From the repository root:

```sh
julia --project=. -e 'using Pkg; Pkg.instantiate()'
julia --project=. example.jl
```

If your shell handles quotes differently, run `using Pkg; Pkg.activate(".");
Pkg.instantiate()` in the Julia REPL. `Project.toml` declares dependencies and
compatibility ranges, not the exact historical environment of the paper.
No historical `Manifest.toml` is supplied.

Every user must obtain and configure their own appropriate Gurobi license.
Do not upload `gurobi.lic`, WLS credentials, license keys, or account secrets.
See [Gurobi license setup](https://support.gurobi.com/hc/en-us/articles/12872879801105-How-do-I-retrieve-and-set-up-a-Gurobi-license).
Gurobi and Vivado are separately licensed dependencies and are not distributed here.

## Optimization experiments

```sh
julia --project=. scripts/run_experiments.jl
```

The default run includes 11 sharing-aware instances and can take approximately
5.5 hours at the per-instance limit, plus model-building overhead. Each invocation
writes a unique log under `results/`. To run fewer cases, edit `cases_to_run`.

**The historical RPAG initial solutions used in the paper are not included.**
The script contains a commented template, not an active warm start. New runs can
therefore differ in runtime and time-limited incumbents, particularly LP15.
Disabling `reg_save_option` changes the objective in this implementation; it is
not a bundled independent copy of the published jMCM implementation.

## Evaluate saved hardware designs

```sh
python hardware/verilog_generator.py
python hardware/run_vivado.py
```

RTL generation overwrites the corresponding files in `hardware/v_src/` from
the saved topology library; it does not run Gurobi. Add Vivado to `PATH`, or use
`python hardware/run_vivado.py --vivado /path/to/vivado`. See `--help` for options.

The flow uses out-of-context synthesis, `xc7v585tffg1761-3`, and a 2.0 ns clock.
Designs use an 8-bit unsigned input. The paper reports Vivado 2018.3 and Gurobi
13.0. Different tool versions/settings can change implementation results.
Reports are written under `hardware/reports/` in a separate run directory.

Power is a Vivado estimate, not a board measurement. No measured activity trace
is supplied. The generator's analytical register accounting is not a substitute
for post-implementation FF utilization. Consult the reproduction notes for the
mapping between file names and the three configurations in Table I.

## Code reuse and licensing

This snapshot does not yet include an author-selected software `LICENSE`.
Public availability alone does not specify reuse permissions. The authors should
agree on a license before adding one. Such a license governs this project's
code; it does not grant access to Gurobi or Vivado and must never contain their
license credentials.
