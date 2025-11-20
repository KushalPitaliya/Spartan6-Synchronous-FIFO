module fifo_sync #(
parameter DATA_WIDTH = 8,
parameter ADDR_WIDTH = 4
)
(
input clk,
input rst_n,
input wr_en,
input [DATA_WIDTH-1:0] w_data
output full,
input rd_en
output reg [DATA_WIDTH-1:0] r_data, // CHANGE 1: Make the output a 'reg'
output empty
);
localparam FIFO_DEPTH = 1 << ADDR_WIDTH;
reg [DATA_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
reg [ADDR_WIDTH-1:0] wr_ptr;
reg [ADDR_WIDTH-1:0] rd_ptr;
reg [ADDR_WIDTH:0] item_count;
// CHANGE 2: REMOVE the continuous 'assign' statement for r_data
// assign r_data = mem[rd_ptr]; // This line is now deleted.
assign full = (item_count == FIFO_DEPTH);
assign empty = (item_count == 0);
always @(posedge clk or negedge rst_n) begin
if (!rst_n) begin
wr_ptr <= 0;
rd_ptr <= 0;
item_count <= 0;
r_data <= 0; // CHANGE 3: On reset, force the output to a known value (0).
end else begin
if (wr_en && !full) begin
mem[wr_ptr] <= w_data;
wr_ptr <= wr_ptr + 1;
item_count <= item_count + 1;
end
if (rd_en && !empty) begin
r_data <= mem[rd_ptr]; // CHANGE 4: Assign memory value to output ONLY on a valid read.
rd_ptr <= rd_ptr + 1;
item_count <= item_count - 1;
end
end
end
endmodule
