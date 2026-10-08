# FPGA-Based Health Monitoring System

An RTL-based health monitoring system implemented in Verilog and deployed on FPGA using Xilinx Vivado.

## Overview

This project simulates the monitoring of three health parameters:

- Heart Rate
- Body Temperature
- SpO2

The system uses FPGA switches to provide simulated parameter values and classifies the measured condition as **Normal, Warning, or Critical** based on predefined thresholds.

## Features

- Simulated heart rate monitoring
- Simulated body temperature monitoring
- Simulated SpO2 monitoring
- Parameter selection using FPGA switches
- Clocked parameter storage
- Threshold-based decision logic
- Normal / Warning / Critical status classification
- Seven-segment display output
- LED/RGB status indication

## Input Configuration

The FPGA switches are used to provide the simulated parameter value.

- `SW[7:0]` → Parameter value
- `SW[9:8]` → Parameter selection

### Parameter Selection

| SW[9:8] | Parameter |
|---|---|
| `00` | Temperature |
| `01` | Heart Rate |
| `10` | SpO2 |
| `11` | Health Status |

## Design

The design consists of:

- Parameter selection logic
- Clocked parameter storage
- Combinational threshold-based decision logic
- Seven-segment display logic
- LED/RGB status indication

## Verification

A Verilog testbench was developed to verify multiple **Normal, Warning, and Critical** input scenarios.

The design was simulated and verified using **Xilinx Vivado** before FPGA implementation.

## Hardware & Tools

- Verilog HDL
- FPGA
- Xilinx Vivado

## Project Files

- `vlsi_pbl.v` — Main Verilog RTL design
- `vlsi_pbl_TB.v` — Verilog testbench
- `PBL.xdc` — FPGA pin constraints

## Results

The project was implemented on FPGA and tested using simulated health parameter inputs provided through the FPGA switches.

---

### Technologies

`Verilog` `RTL Design` `FPGA` `Xilinx Vivado` `Digital Logic Design`
