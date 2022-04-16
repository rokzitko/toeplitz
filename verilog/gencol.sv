// Generate successive columns of the Toeplitz matrix
// Rok Zitko, March 2022

module gencol #(
 parameter BS = 64,
 parameter N = 256,
 parameter L = 128,
 parameter STRIDE = 1,
 parameter INDEX = 1
)
(
input clk,
input reset,
input wire [N-1:0] row0,
input wire [L-1:0] col0,
output reg [L-1:0] col
);

parameter XSZ = N/BS;
parameter YSZ = L/BS;

logic [N-1:0] row;

integer cnt;

always @(posedge clk) begin
  if (reset || cnt == N-STRIDE) begin
    col <= col0;
    row <= row0;
    cnt <= 0;
  end else begin
    col <= { row[N-1:N-STRIDE], col[L-STRIDE:STRIDE] };
    row <= row << STRIDE;
    cnt <= cnt+STRIDE;
  end
end

endmodule: gencol
