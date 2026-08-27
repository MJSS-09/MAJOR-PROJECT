# MAJOR-PROJECT

# POWER-OPTIMIZED VERILOG BASED ARCHITECTURE FOR REAL TIME BUS TICKETING SYSTEM

A Verilog HDL implementation of an automatic bus ticketing system, synthesized and simulated in Xilinx Vivado targeting an **Artix-7 FPGA**. The design integrates **flip-flop based clock gating** to reduce dynamic power consumption without affecting timing performance.

📄 **Published Paper:** [IJERT, Vol. 15, Issue 03, March 2026](https://www.ijert.org/)

## Overview

Traditional manual bus ticketing systems suffer from queuing delays, fare-calculation errors, and heavy staffing requirements. This project automates the entire ticketing workflow — route selection, fare calculation, coin/change handling, and display — directly in hardware using Verilog HDL, while applying a glitch-free clock gating technique to cut unnecessary switching power in idle modules.

**Result:** 34% reduction in dynamic power (10.525 W → 6.904 W) with only 1 additional LUT and **no change** to the critical path delay (5.610 ns).

## System Architecture

The system is composed of four core functional modules plus a clock gating module, unified under a single top-level module:

| Module | Description |
|---|---|
| **Ticket Selection Module** | Captures route (`path_1`, `path_2`), price (`pri3`, `pri4`, `pri5`), and quantity (`qua_1`, `qua_2`) selections |
| **Rupees Calculation Module** | Counts inserted 5-rupee and 10-rupee coins and accumulates the total amount |
| **Return Processing Module** | Validates payment against fare, calculates change, and authenticates the ticket |
| **Display Interface Module** | Drives a 6-digit 7-segment display via a Mod-6 counter, 6-to-1 selector, and BCD-to-7-segment decoder |
| **Flip-Flop Based Clock Gating Module** | Gates the system clock using a D flip-flop + AND gate to suppress switching in idle logic |

```
                     ┌─────────────────────┐
  clk ───────────────►  Flip-Flop Clock     │
                     │  Gating Module       ├── gated_clk ──┐
                     └─────────────────────┘                │
                                                              ▼
 path/price/qty ──► Ticket Selection ──┐         ┌─────────────────────┐
                                        ├────────►│  Return Processing   │
 five_in/ten_in ──► Rupees Calculation ─┘         │  (change, valid_tic) │
                                                   └──────────┬──────────┘
                                                              ▼
                                                   Display Interface
                                                   (digit_select, segments)
```

## Key Technique: Flip-Flop Based Clock Gating

Instead of directly ANDing the clock with a combinational enable signal (which risks glitches), the enable is first **registered through a D flip-flop on the falling clock edge**, then ANDed with the clock:

```
gated_clk = clk AND q_out
q_out = D-FF(enable, sampled on negedge clk)
```

This guarantees a clean, hazard-free gated clock and prevents spurious pulses that could corrupt downstream flip-flops. The enable signal is derived from `FIVE_IN OR TEN_IN`, so all four modules remain clock-gated (and power-idle) whenever the system is waiting for a coin insertion.

## Tools & Target Platform

- **HDL:** Verilog
- **Design/Synthesis:** Xilinx Vivado Design Suite
- **Target Device:** AMD-Xilinx Artix-7 FPGA (validated on XC7A35T / Nexys A7)
- **Simulation:** Vivado XSIM behavioral simulation

## Results Summary

| Parameter | Existing (No Clock Gating) | Proposed (Clock Gated) |
|---|---|---|
| Area (LUTs) | 44 | 45 |
| Total Power (W) | 10.525 | **6.904** |
| Dynamic Power (W) | 10.350 | **6.749** |
| Static Power (W) | 0.175 | 0.155 |
| Junction Temp (°C) | 44.7 | 37.9 |
| Critical Path Delay (ns) | 5.610 | 5.610 (unchanged) |

All four functional modules and the integrated top-level design were verified through behavioral simulation in Vivado, with waveforms confirming correct route selection, fare calculation, change dispensing, and multiplexed display output.

## How to Run

1. Open Xilinx Vivado and create a new RTL project.
2. Add all files from `Source codes/` as design sources.
3. Add all files from `TestBench/` as simulation sources.
4. Set the target part to an Artix-7 device (e.g., `xc7a35tcpg236-1` for Nexys A7).
5. Run **Behavioral Simulation** on `bus_ticketing_system_tb_EXT.v` to verify the complete system.
6. Run **Synthesis → Implementation** and open the **Power** and **Timing** reports to reproduce the results above.

## Future Scope

- Contactless/UPI/RFID payment integration
- LCD/TFT display upgrade with multilingual support
- IoT/GSM connectivity for centralized fare monitoring
- Support for additional routes and dynamic (GPS-based) fare structures
- Physical FPGA board validation

## Author

**M. Jayantha Siva Srinivas**
B.Tech, Electronics and Communication Engineering, Seshadri Rao Gudlavalleru Engineering College

Project team: M. Sai Priya, M. Dinesh, M. Vani
Guide: Sri Y. Mamillu, Assistant Professor, ECE

## License

This work is part of an academic capstone project. See the published paper for citation details.
