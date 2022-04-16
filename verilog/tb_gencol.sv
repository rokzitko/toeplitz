// Testbench for module gencol
// Rok Zitko, April 2022

`default_nettype none

//`define VERBOSE

timeunit 1ns;
timeprecision 100fs;

module tb_gencol;

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
  #0.5;
`ifdef VERBOSE
  $display("rrow0=%b", rrow0);
  $display(" col0=%b", col0);
`endif
  #300;
  $finish;
end

`define INST1
`define INST2
`define INST3
`define INST4
`define INST5
`define INST6
`define INST7
`define CHECKS

`ifdef INST1
logic [L-1:0] col1;
gencol #(.BS(BS), .N(N), .L(L), .STRIDE(1)) gencol_inst1 (.clk, .reset, .rrow0, .col0, .col(col1));

`ifdef VERBOSE
always @(posedge clk) begin
  #0.01; // show values *after* update
  $display("t=%t col1=%b cnt=%d", $time, col1, gencol_inst1.cnt);
end
`endif

initial begin
  #299; @(posedge clk); #0.01;
`ifdef VERBOSE
  $display("t=%t col1=%b cnt=%d", $time, col1, gencol_inst1.cnt);
`endif
  assert(gencol_inst1.cnt == 43);
  assert(col1 == 128'b00000011001000000010011000010100101000111000000001000110011001101000110000001011101001001000110011011000010110111101001011100100);
end
`endif

`ifdef INST2
logic [L-1:0] col2;
gencol #(.BS(BS), .N(N), .L(L), .STRIDE(2)) gencol_inst2 (.clk, .reset, .rrow0, .col0, .col(col2));

`ifdef VERBOSE
always @(posedge clk) begin
  #0.01;
  $display("t=%t col2=%b cnt=%d", $time, col2, gencol_inst2.cnt);
end
`endif

initial begin
  #299; @(posedge clk); #0.01;
`ifdef VERBOSE
  $display("t=%t col2=%b cnt=%d", $time, col2, gencol_inst2.cnt);
`endif
  assert(gencol_inst2.cnt == 86);
  assert(col2 == 128'b11011111100000101001101111100011101110011010000001100100000001001100001010010100011100000000100011001100110100011000000101110100);
end
`endif

`ifdef INST3
logic [L-1:0] col3;
gencol #(.BS(BS), .N(N), .L(L), .STRIDE(4)) gencol_inst3 (.clk, .reset, .rrow0, .col0, .col(col3));

`ifdef VERBOSE
always @(posedge clk) begin
  #0.01;
  $display("t=%t col3=%b cnt=%d", $time, col3, gencol_inst3.cnt);
end
`endif

initial begin
  #299; @(posedge clk); #0.01;
`ifdef VERBOSE
  $display("t=%t col3=%b cnt=%d", $time, col3, gencol_inst3.cnt);
`endif
  assert(gencol_inst3.cnt == 172);
  assert(col3 == 128'b11010000111101101011110110110010001011011110100011001010000100110110110100111010011111110111111000001010011011111000111011100110);
end
`endif

`ifdef INST4
logic [L-1:0] col4;
gencol #(.BS(BS), .N(N), .L(L), .STRIDE(2), .INDEX(1)) gencol_inst4 (.clk, .reset, .rrow0, .col0, .col(col4));

`ifdef VERBOSE
always @(posedge clk) begin
  #0.01;
  $display("t=%t col4=%b cnt=%d", $time, col4, gencol_inst4.cnt);
end
`endif

initial begin
  #299; @(posedge clk); #0.01;
`ifdef VERBOSE
  $display("t=%t col4=%b cnt=%d", $time, col4, gencol_inst4.cnt);
`endif
  assert(gencol_inst4.cnt == 87);
  assert(col4 == 128'b11101111110000010100110111110001110111001101000000110010000000100110000101001010001110000000010001100110011010001100000010111010);
end
`endif

`ifdef INST5
logic [L-1:0] col5;
gencol #(.BS(BS), .N(N), .L(L), .STRIDE(4), .INDEX(1)) gencol_inst5 (.clk, .reset, .rrow0, .col0, .col(col5));

`ifdef VERBOSE
always @(posedge clk) begin
  #0.01;
  $display("t=%t col5=%b cnt=%d", $time, col5, gencol_inst5.cnt);
end
`endif

initial begin
  #299; @(posedge clk); #0.01;
`ifdef VERBOSE
  $display("t=%t col5=%b cnt=%d", $time, col5, gencol_inst5.cnt);
`endif
  assert(gencol_inst5.cnt == 173);
  assert(col5 == 128'b01101000011110110101111011011001000101101111010001100101000010011011011010011101001111111011111100000101001101111100011101110011);
end
`endif

`ifdef INST6
logic [L-1:0] col6;
gencol #(.BS(BS), .N(N), .L(L), .STRIDE(4), .INDEX(2)) gencol_inst6 (.clk, .reset, .rrow0, .col0, .col(col6));

`ifdef VERBOSE
always @(posedge clk) begin
  #0.01;
  $display("t=%t col6=%b cnt=%d", $time, col6, gencol_inst6.cnt);
end
`endif

initial begin
  #299; @(posedge clk); #0.01;
`ifdef VERBOSE
  $display("t=%t col6=%b cnt=%d", $time, col6, gencol_inst6.cnt);
`endif
  assert(gencol_inst6.cnt == 174);
  assert(col6 == 128'b00110100001111011010111101101100100010110111101000110010100001001101101101001110100111111101111110000010100110111110001110111001);
end
`endif

`ifdef INST7
logic [L-1:0] col7;
gencol #(.BS(BS), .N(N), .L(L), .STRIDE(4), .INDEX(3)) gencol_inst7 (.clk, .reset, .rrow0, .col0, .col(col7));

`ifdef VERBOSE
always @(posedge clk) begin
  #0.01;
  $display("t=%t col7=%b cnt=%d", $time, col7, gencol_inst7.cnt);
end
`endif

initial begin
  #299; @(posedge clk); #0.01;
`ifdef VERBOSE
  $display("t=%t col7=%b cnt=%d", $time, col7, gencol_inst7.cnt);
`endif
  assert(gencol_inst7.cnt == 175);
  assert(col7 == 128'b00011010000111101101011110110110010001011011110100011001010000100110110110100111010011111110111111000001010011011111000111011100);
end
`endif

`ifdef CHECKS
`define CHECK(N,INST1,INST2) \
initial begin \
  logic [L-1:0] ref1; \
  logic [L-1:0] ref2; \
  wait (gencol_inst``INST2.cnt == N); \
  #0.1 ref2 <= col``INST2; \
  wait (gencol_inst``INST1.cnt == N); \
  #0.1 ref1 <= col``INST1; \
  #0.5; \
`ifdef VERBOSE \
  $display("ref1=%b", ref1); \
  $display("ref2=%b", ref2); \
`endif \
  assert(ref1 == ref2); \
end
`CHECK(2,1,2)
`CHECK(4,1,2)
`CHECK(4,1,3)
`CHECK(8,1,2)
`CHECK(8,1,3)
`CHECK(16,1,2)
`CHECK(16,1,3)
`CHECK(3,1,4)
`CHECK(17,1,4)
`CHECK(17,1,5)
`CHECK(18,1,6)
`CHECK(19,1,7)
`endif

endmodule: tb_gencol
