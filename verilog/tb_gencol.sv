// Testbench for module gencol
// Rok Zitko, April 2022

timeunit 1ns;
timeprecision 100fs;

module tb_gencol;

parameter BS = 64;
parameter N = 256;
parameter L = 128;
parameter XSZ = N/BS;
parameter YSZ = L/BS;

reg clk;
initial clk <= 0;
always #0.5 clk <= ~clk;

reg reset;
initial begin
 reset <= 1;
 #1;
 reset <= 0;
end

logic [N-1:0] row0;
logic [L-1:0] col0;
readrc #(.BS(BS), .N(N), .L(L)) readrc_inst(.row0, .col0);

initial begin
  $timeformat(-9, 2, " ns", 20);
  #0.5 $display("row0=%b col0=%b", row0, col0);
  #300;
  $finish;
end

logic [L-1:0] col1;
gencol #(.BS(BS), .N(N), .L(L), .STRIDE(1)) gencol_inst1 (.clk, .reset, .row0, .col0, .col(col1));

always @(posedge clk) begin
//  $display("t=%t col1=%b cnt=%d", $time, col1, gencol_inst1.cnt);
end

initial begin
  #299 @(posedge clk);
  assert(col1 == 128'b00000110010000000100110000101001010001110000000010001100110011010001100000010111010010010001100110110000101101111010010111001001);
end

logic [L-1:0] col2;
gencol #(.BS(BS), .N(N), .L(L), .STRIDE(2)) gencol_inst2 (.clk, .reset, .row0, .col0, .col(col2));

always @(posedge clk) begin
//  $display("t=%t col2=%b cnt=%d", $time, col2, gencol_inst2.cnt);
end

initial begin
  #299 @(posedge clk);
  assert(col2 == 128'b01011110100000101100111110100110111011001010000100110000000100011000001011010001011000000010001100110011010001100000010111010010);
end

logic [L-1:0] col3;
gencol #(.BS(BS), .N(N), .L(L), .STRIDE(4)) gencol_inst3 (.clk, .reset, .row0, .col0, .col(col3));

always @(posedge clk) begin
//  $display("t=%t col3=%b cnt=%d", $time, col3, gencol_inst3.cnt);
end

initial begin
  #299 @(posedge clk);
  assert(col3 == 128'b00000001111011011011011110101000100101101110001001101011000110001101011110001011110111111100111000001010110111100010111011101100);
end

endmodule: tb_gencol
