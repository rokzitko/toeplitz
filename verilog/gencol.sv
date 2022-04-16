// Generate successive columns of the Toeplitz matrix
// Rok Zitko, March 2022

module gencol #(
 parameter BS = 64,
 parameter N = 256,
 parameter L = 128
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
  if (reset || cnt == N-1) begin
    col <= col0;
    row <= row0;
    cnt <= 0;
  end else begin
    col <= { row[N-1], col[L-1:1] };
    row <= row << 1;
    cnt <= cnt+1;
  end
end

endmodule: gencol
