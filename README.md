# (Data Communication Networks) Waiting Time Analysis for Markovian Queues Using Discrete Event Simulations

Discrete-event simulation and analytical queueing models in MATLAB. Prepared by Yan Liang for ELEC9123 Design Proficiency (Task D), UNSW, 2025.

The project examines how arrival rates, service-time distributions, finite capacity and multiple servers affect system occupancy and time in system. Airport check-in scenarios illustrate concepts also relevant to communications and service-capacity planning; this is not a deployed network monitoring system.

## Models and entry points

| Directory | Model | Run from that directory |
| --- | --- | --- |
| `level_2` | M/M/1 | `main_MM1` |
| `level_3` | M/M/1/K (finite capacity) | `main_MM1K` |
| `level_4` | M/G/1, including uniform or deterministic service | `main_MG1` |
| `level_5` | M/M/m, business/economy check-in scenarios | `main` |

Each model has separate simulation (`*_DES.m`) and analytical (`*_analysis.m`) functions. Level 4 also includes a plotting helper.

## Run

Requires MATLAB and Statistics and Machine Learning Toolbox for `exprnd` and related random-distribution functions. The original MATLAB release was not recorded. From the repository root:

```matlab
cd level_2
main_MM1
```

Return to the repository root and enter the relevant model folder for subsequent runs. Do not assume all main scripts can be called from one working directory without setting paths.

## What to inspect

- Printed analytical versus simulated average system size and system time.
- Comparison bar charts and time evolution of occupancy.
- Sensitivity to service-time distributions and number of servers.
- Stability assumptions and unit conversions between hours and minutes.

System size includes customers in service; it is not necessarily the waiting-queue length, even where plot labels use the word queue. System time includes waiting and service.

## Reproducibility and limitations

- All 13 MATLAB source files are preserved byte-for-byte; hashes are in `SOURCE_MANIFEST.json`.
- No new MATLAB run, benchmark or numerical validation was performed during publication.
- Review numerical values rather than relying on comments: for example, `main_MG1.m` sets `sim_time_min = 1e7`, although the adjacent comment describes a different duration. This can require substantial time and memory.
- Some simulations set a seed internally; do not assume independent repeated runs without checking the implementation.
- Steady-state formulas require their corresponding arrival/service and stability assumptions. Startup transients, finite horizons and treatment of unfinished customers can affect comparisons.
- Raw coursework reports with student identifiers and autosave files are excluded.

## Skills demonstrated

MATLAB · Discrete-event simulation · Queueing theory · Performance modeling · Capacity analysis · Data visualization
