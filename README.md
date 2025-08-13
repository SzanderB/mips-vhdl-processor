# 5-Stage MIPS Processor (VHDL)

## Overview
A pipelined 5-stage MIPS processor implemented in VHDL. Supports instruction fetch, decode, execute, memory access, and write-back stages with proper handling of hazards and branching. Designed and tested as part of the digital design course project.  
**NOTE:** Most of code not included as its a school project.

## Features
- 5-stage pipeline: IF, ID, EX, MEM, WB
- Implements key instructions (ADD, SUB, AND, OR, LW, SW, BEQ, etc)
- Testbench included for simulation and verification
- Modular design for easy expansion or modification
- RTL Viewer diagram shows full processor layout and signal flow

## Technologies
- **Hardware Description Language:** VHDL  
- **Simulation & Synthesis:** Intel Quartus
- **Testbench:** Top-level testbench for verifying pipeline functionality  
- **Visualization:** RTL Viewer for complete pipeline overview

## Development Notes
- Designed top-level module and all components including ALU, registers, and memory components
- Used RTL Viewer to validate pipeline connections and instruction flow
- Verified correctness with custom testbench and simulation waveforms

## Key Learnings
- Deepened understanding of pipelined processor architecture and branch handling
- Learned modular VHDL design and effective testbench practices
