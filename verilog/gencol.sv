// Generate successive columns of the Toeplitz matrix
// Rok Zitko, March-April 2022

module gencol #(
 parameter BS = 64,
 parameter N = 256,
 parameter L = 128,
 parameter STRIDE = 1,
 parameter INDEX = 0
)
(
input clk,
input reset,
input wire [N-1:0] rrow0,
input wire [L-1:0] col0,
output reg [L-1:0] col
);

parameter XSZ = N/BS;
parameter YSZ = L/BS;

logic [N-1:0] rrow;

integer cnt;

always @(posedge clk) begin
  if (reset || cnt == N-STRIDE+INDEX) begin
    if (INDEX == 0)
      col <= col0;
    else
      col <= { rrow0[(INDEX>0 ? INDEX-1 : INDEX):0], col0[L-1:INDEX] };
    rrow <= rrow0 >> INDEX;
    cnt <= INDEX;
  end else begin
    col <= { rrow[STRIDE-1:0], col[L-1:STRIDE] };
    rrow <= { {STRIDE{1'b0}}, rrow[N-1:STRIDE] };
    cnt <= cnt+STRIDE;
  end
end

endmodule: gencol
