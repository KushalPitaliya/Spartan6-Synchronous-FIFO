// This is the testbench to simulate your FIFO design and generate the waveform.
`timescale 1ns / 1ps
module tb_fifo;
// Inputs to the FIFO (declared as 'reg' because the testbench controls them)
reg clk_50mhz;
reg rst_btn;
reg wr_btn;
reg rd_btn;
reg [7:0] sw_data;
// Outputs from the FIFO (declared as 'wire' because the testbench monitors them)
wire [7:0] led_data;
wire led_empty;
wire led_full;
// Instantiate the Device Under Test (DUT) - your top_fifo module
top_fifo DUT (
.clk_50mhz(clk_50mhz),
.rst_btn(rst_btn),
.sw_data(sw_data),
.wr_btn(wr_btn),
.rd_btn(rd_btn),
.led_data(led_data),
.led_full(led_full),
.led_empty(led_empty)
);
// 1. Clock Generation Block
// Create a 50 MHz clock (20 ns period)
always begin
clk_50mhz = 0; #10;
clk_50mhz = 1; #10;
end
// 2. Stimulus Block
// This defines the sequence of actions for the test.
initial begin
// --- Initialization ---
// Set all inputs to a known, stable state at the beginning.
rst_btn <= 0;
wr_btn <= 0;
rd_btn <= 0;
sw_data <= 8'h00;
#50; // Wait for a few clock cycles
// --- Step 1: Test the Reset ---
$display("Testing Reset...");
rst_btn <= 1; // Pulse the reset button HIGH
@(posedge clk_50mhz);
rst_btn <= 0;
#50;
// --- Step 2: Write three data values into the FIFO ---
$display("Writing 3 values: AA, BB, CC");
// Write 0xAA
sw_data <= 8'hAA;
wr_btn <= 1;
@(posedge clk_50mhz);
wr_btn <= 0;
// Write 0xBB
sw_data <= 8'hBB;
wr_btn <= 1;
@(posedge clk_50mhz);
wr_btn <= 0;
// Write 0xCC
sw_data <= 8'hCC;
wr_btn <= 1;
@(posedge clk_50mhz);
wr_btn <= 0;
sw_data <= 8'h00; // Clear the data bus
#100; // Wait for a moment
// --- Step 3: Read the three values out of the FIFO ---
$display("Reading 3 values out...");
// First Read (should be 0xAA)
rd_btn <= 1;
@(posedge clk_50mhz);
rd_btn <= 0;
#20; // Wait to see the result on the output
// Second Read (should be 0xBB)
rd_btn <= 1;
@(posedge clk_50mhz);
rd_btn <= 0;
#20;
// Third Read (should be 0xCC)
rd_btn <= 1;
@(posedge clk_50mhz);
rd_btn <= 0;
#100; // Wait for the 'empty' flag to re-assert
// --- End of Test ---
$display("Simulation Finished.");
end
