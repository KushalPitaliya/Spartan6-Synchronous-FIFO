# Spartan6-Synchronous-FIFO
# Design and Implementation of 8-bit Synchronous FIFO on Spartan-6 FPGA

## Project Overview
This project implements a robust, hardware-verified synchronous FIFO memory buffer on a Xilinx Spartan-6 FPGA. The design features a modular architecture including a core FIFO engine, a custom debounce filter for noise elimination, and a top-level hardware interface.

## Key Features
- **Hardware Verified:** Fully tested on the EDGE Spartan 6 Board.
- **Robust Input Handling:** Implemented a custom timer-based debouncing module to filter mechanical button noise.
- **Reliable Initialization:** Features a power-on reset circuit to ensure deterministic startup state.
- **Status Indicators:** Real-time visual feedback for 'Full' and 'Empty' states.

## Technical Stack
- **Language:** Verilog HDL
- **Hardware:** Xilinx Spartan-6 (XC6SLX9)
- **Tools:** Xilinx ISE Design Suite 14.7, iMPACT, ISim

## The Challenge & Solution
The biggest challenge was bridging the gap between simulation and reality. Initial hardware tests failed due to "button bounce," where a single press generated multiple write pulses. I engineered a robust `debounce.v` module to filter these signals, ensuring 100% reliability in the final implementation.
