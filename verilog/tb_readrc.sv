// Testbench for module readrc
// Rok Zitko, April 2022

`default_nettype none

//`define VERBOSE

timeunit 1ns;
timeprecision 100fs;

module tb_readrc;

parameter BS = 64;
parameter N = 256;
parameter L = 128;

reg clk;
initial clk <= 0;
always #0.5 clk <= ~clk;

reg reset;
initial begin
 reset <= 1;
 #1;
 reset <= 0;
end

logic [N-1:0] rrow0;
logic [L-1:0] col0;
readrc #(.BS(BS), .N(N), .L(L)) readrc_inst(.rrow0, .col0);

initial begin
  $timeformat(-9, 2, " ns", 20);
`ifdef VERBOSE
  $display("rrow0=%b", rrow0);
  $display(" col0=%b", col0);
`endif
  assert(rrow0 == 256'b0100010111110110011010110101001001001001101100010111000000100001101110001010011010001101000011110110101111011011001000101101111010001100101000010011011011010011101001111111011111100000101001101111100011101110011010000001100100000001001100001010010100011100);
  assert( col0 == 128'b00000010001100110011010001100000010111010010010001100110110000101101111010010111001001011110001001110000111100001110111010010011);
  $finish;
end

endmodule: tb_readrc
