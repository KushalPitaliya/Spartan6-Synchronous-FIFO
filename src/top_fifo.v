module top_fifo (
input clk_50mhz,
input rst_btn,
input [7:0] sw_data,
input wr_btn,
input rd_btn,
output [7:0] led_data,
output led_full,
output led_empty
);
wire fifo_full_w;
wire fifo_empty_w;
wire [7:0] fifo_r_data_w;
wire master_rst_n;
// Internal wires for the clean, debounced button pulses
wire rst_pulse;
wire wr_en_pulse;
wire rd_en_pulse;
wire rst_n_internal = ~rst_btn;
// Power-On Reset Circuit (No changes)
reg [7:0] pwr_on_rst_counter = 8'h00;
always @(posedge clk_50mhz) begin
if (pwr_on_rst_counter != 8'hFF) pwr_on_rst_counter <= pwr_on_rst_counter + 1;
end
assign master_rst_n = (pwr_on_rst_counter == 8'hFF) && rst_n_internal;
//
debounce DEBOUNCE_RESET ( .clk(clk_50mhz), .rst_n(master_rst_n), .noisy_in(rst_btn), .debounced_pulse(rst_pulse) );
debounce DEBOUNCE_WRITE
( .clk(clk_50mhz), .rst_n(master_rst_n), .noisy_in(wr_btn), .debounced_pulse(wr_en_pulse) );
debounce DEBOUNCE_READ
( .clk(clk_50mhz), .rst_n(master_rst_n), .noisy_in(rd_btn), .debounced_pulse(rd_en_pulse) );
// Instantiate the FIFO core
fifo_sync FIFO_CORE_INST (
.clk(clk_50mhz),
.rst_n(master_rst_n),
.wr_en(wr_en_pulse), // Use the clean pulse from the debouncer
.w_data(sw_data),
.full(fifo_full_w),
.rd_en(rd_en_pulse), // Use the clean pulse from the debouncer
.r_data(fifo_r_data_w),
.empty(fifo_empty_w)
);
// Connect FIFO outputs to the physical LEDs
assign led_data = fifo_r_data_w;
assign led_full = fifo_full_w;
assign led_empty = fifo_empty_w;
endmodule
