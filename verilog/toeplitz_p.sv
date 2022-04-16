// Toeplitz extractor, top level module
// Parallelized version
// Rok Zitko, April 2022

`default_nettype none

//`define DEBUG

timeunit 1ns;
timeprecision 100fs;

module toeplitz_p #(
 parameter BS = 64,
 parameter N = 256,
 parameter L = 128,
 parameter WIDTH = 2
)
(
input wire clk,
input wire reset,
input wire [WIDTH-1:0] data,
output reg [L-1:0] q,
output reg qstrobe // pulsed when q updated
);

parameter XSZ = N/BS;
parameter YSZ = L/BS;

logic [N-1:0] rrow0;
logic [L-1:0] col0;
readrc #(.BS(BS), .N(N), .L(L)) readrc_inst(.rrow0, .col0);

logic [L-1:0] col[WIDTH];
genvar k;
generate for (k = 0; k < WIDTH; k = k+1) begin
  gencol #(.BS(BS), .N(N), .L(L), .STRIDE(WIDTH), .INDEX(k)) gencol_inst (.clk, .reset, .rrow0, .col0, .col(col[WIDTH-1-k])); // !!
end
endgenerate

reg [L-1:0] y;
reg [L-1:0] ynew;

integer cnt;

always @(posedge clk) begin
  if (reset) begin
    q <= 0;
    qstrobe <= 0;
    y <= 0;
    cnt <= 0;
  end else begin
    for (int i = 0; i < L; i++) begin
      ynew[i] = y[i];
      for (int k = 0; k < WIDTH; k = k+1) begin
        ynew[i] = ynew[i] ^ (data[k] & col[k][i]);
      end
    end
`ifdef DEBUG
    $display("ynew=%b cnt=%d", ynew, cnt);
`endif
    if (cnt < (N-WIDTH)) begin
      cnt <= cnt+WIDTH;
      qstrobe <= 0;
      y <= ynew;
    end else begin
      cnt <= 0;
      qstrobe <= 1;
      q <= ynew;
      y <= 0;
`ifdef DEBUG
    #0.01 $display("** q=%b", q);
`endif
    end
`ifdef DEBUG
    #0.01 $display("   y=%b cnt=%d", y, cnt);
`endif
  end
end

endmodule: toeplitz_p
