# Reproducing the manuscript experiments

## Mapping Table I to saved RTL

The `_coopt` suffix means LSB sharing is enabled in the RTL generator. It does
not by itself identify how the topology was optimized.

| Benchmark | jMCM | jMCM + post-processing | RA-PMCM |
|---|---|---|---|
| G.3 | G3_baseline.v | G3_coopt.v | G3_coopt.v |
| G.5 | G5_jmcm_baseline.v | G5_jmcm_coopt.v | G5_coopt.v |
| HP5 | HP5_baseline.v | HP5_coopt.v | HP5_coopt.v |
| HP9 | HP9_baseline.v | HP9_coopt.v | HP9_coopt.v |
| HP15 | HP15_baseline.v | HP15_coopt.v | HP15_coopt.v |
| L.3 | L3_baseline.v | L3_coopt.v | L3_coopt.v |
| LP5 | LP5_baseline.v | LP5_coopt.v | LP5_coopt.v |
| LP9 | LP9_baseline.v | LP9_coopt.v | LP9_coopt.v |
| LP15 | LP15_jmcm_baseline.v | LP15_jmcm_coopt.v | LP15_coopt.v |
| U.3-1 | U3_1_baseline.v | U3_1_coopt.v | U3_1_coopt.v |
| U.3-2 | U3_2_baseline.v | U3_2_coopt.v | U3_2_coopt.v |

For nine benchmarks the sharing configurations use the same saved topology.
`G5_baseline.v` and `LP15_baseline.v` disable sharing on the RA-PMCM topology;
they are extra variants, not the jMCM baseline in Table I.

## Analytical checks

Sharing-aware allocated register counts from the saved topologies:

| Benchmark | jMCM topology + sharing | RA-PMCM topology + sharing |
|---|---:|---:|
| G.3 | 53 | 53 |
| G.5 | 97 | 95 |
| HP5 | 65 | 65 |
| HP9 | 73 | 73 |
| HP15 | 146 | 146 |
| L.3 | 55 | 55 |
| LP5 | 87 | 87 |
| LP9 | 170 | 170 |
| LP15 | 341 | 339 |
| U.3-1 | 50 | 50 |
| U.3-2 | 79 | 79 |

These are analytical checks, not newly measured Vivado results. The gross RTL
allocation before sharing can differ from implemented FF counts because
synthesis can merge or remove registers. The generator also contains a
numerical minimum-width helper, `calculate_total_bitwidth`; that quantity is
distinct from declared RTL widths. Neither replaces implementation measurements.

## Known limits of this snapshot

1. Historical RPAG warm-start assignments and their derivation of node bounds
   are not included. The script provides explicit node bounds and only a
   commented warm-start template. Fresh runtimes and time-limited incumbents
   need not match the paper, especially for LP15.
2. Historical solver logs, proof bounds, and Vivado reports are not included.
   Saved topologies are circuit artifacts, not optimality certificates.
3. There is no automatic complete operand/shift graph export from the solver
   into the RTL generator. The latter uses saved stage-wise coefficient lists
   and selects arithmetic realizations.
4. The default script runs only the sharing-aware model. The optional gross-cost
   mode is a comparison mode of this code, not an independent jMCM distribution.
5. The paper reports Vivado 2018.3 and Gurobi 13.0. Tool versions and settings
   can affect results. The Tcl script loads no switching-activity trace and
   does not explicitly set switching activity. Power is estimated, not measured.
6. Historical Julia package versions are not locked in this snapshot.

Distinguish solver reruns from hardware evaluation of saved circuits. Do not
present new runs as replacements for missing original experimental records.
