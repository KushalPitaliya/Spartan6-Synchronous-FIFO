// This version uses a shift register to ensure signal stability.
module debounce (
input clk,
input rst_n,
input noisy_in,
output reg debounced_pulse
);
// This shift register needs to be all 1s for the signal to be considered HIGH
// The length determines how long the signal must be stable.
// At 50MHz, 20 bits is very short, so we'll use a counter.
parameter COUNTER_WIDTH = 20; // Makes the debounce time ~20ms
reg [COUNTER_WIDTH-1:0] counter = 0;
reg synced_input_reg = 0;
reg debounced_signal_reg = 0;
reg prev_debounced_signal = 0;
always @(posedge clk or negedge rst_n) begin
if (!rst_n) begin
// Reset all logic
counter <= 0;
synced_input_reg <= 0;
debounced_signal_reg <= 0;
prev_debounced_signal <= 0;
end else begin
// Synchronize the noisy input
synced_input_reg <= noisy_in;
// Check if the input has been stable
if (synced_input_reg == debounced_signal_reg) begin
// If the signal is stable, reset the counter
counter <= 0;
end else begin
// If it's different, start counting
counter <= counter + 1;
end
// If the counter fills up, the signal has been stable long enough.
// Update the debounced signal with the new value.
if (&counter) begin // '&' is a reduction AND operator, true when all bits are 1
debounced_signal_reg <= synced_input_reg;
end
// Store the previous state for edge detection
prev_debounced_signal <= debounced_signal_reg;
end
end
// Generate a single pulse on the RISING edge of the clean signal
always @(posedge clk) begin
debounced_pulse <= debounced_signal_reg & ~prev_debounced_signal;
end
endmodule
