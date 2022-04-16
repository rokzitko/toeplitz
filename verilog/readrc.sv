// Read row and column data from a file
// Rok Zitko, March-April 2022

module readrc #(
 parameter BS = 64,
 parameter N = 256,
 parameter L = 128
)
(
output reg [N-1:0] rrow0, // reversed order row
output reg [L-1:0] col0
);

parameter XSZ = N/BS;
parameter YSZ = L/BS;

// First elements of rows and columns of the Toeplitz matrix.
logic [BS-1:0] r [0:XSZ-1];
logic [BS-1:0] c [0:YSZ-1];

logic [N-1:0] row0;

initial begin
  integer i;
  $readmemh("c64-hex.dat", c);
  $readmemh("r64-hex.dat", r);
  row0 = {>>{r}} << 1; // shift one immediately, because already in 'col'
  col0 = {>>{c}};
  for (i = 0; i < N; i = i+1) begin
    rrow0[i] = row0[N-1-i];
  end
end

endmodule: readrc
