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
logic [BS-1:0] rr [0:XSZ-1];
logic [BS-1:0] c [0:YSZ-1];

initial begin
  $readmemh("c64-hex.dat", c);
  $readmemh("rr64-hex.dat", rr);
  rrow0 = {>>{rr}} >> 1; // shift one immediately, because already in 'col'
  col0 = {>>{c}};
end

endmodule: readrc
