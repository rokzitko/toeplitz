// Toeplitz extractor, top level module
// Rok Zitko, March 2022

`default_nettype none

module toeplitz #(
 parameter BS = 64,
 parameter N = 256,
 parameter L = 128
)
(
input wire clk,
input wire reset,
input wire data,
output reg [L-1:0] q,
output reg qstrobe // pulsed when q updated
);

parameter XSZ = N/BS;
parameter YSZ = L/BS;

logic [N-1:0] rrow0;
logic [L-1:0] col0;
readrc #(.BS(BS), .N(N), .L(L)) readrc_inst(.rrow0, .col0);

logic [L-1:0] col;
gencol #(.BS(BS), .N(N), .L(L)) gencol_inst (.clk, .reset, .rrow0, .col0, .col);

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
      ynew[i] = y[i] ^ (data & col[i]);
    end
    if (cnt < (N-1)) begin
      cnt <= cnt+1;
      qstrobe <= 0;
      y <= ynew;
    end else begin
      cnt <= 0;
      qstrobe <= 1;
      q <= ynew;
      y <= 0;
    end
  end
end

endmodule: toeplitz
