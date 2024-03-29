// Testbench for Toeplitz extractor (parallelized version)
// Rok Zitko, April 2022

`default_nettype none

//`define VERBOSE
//`define DEBUG

timeunit 1ns;
timeprecision 100fs;

module tb_toeplitz_p8;

parameter BS = 64;
parameter N = 256;
parameter L = 128;
parameter WIDTH = 8;
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

reg [WIDTH-1:0] data;
wire [L-1:0] q;
wire qstrobe;

toeplitz_p #(.BS(BS), .N(N), .L(L), .WIDTH(WIDTH)) inst(.clk, .reset, .data, .q, .qstrobe);

reg qbit, qbiten;

serializer #(.L(L)) sinst(.clk, .reset, .q, .qstrobe, .qbit, .qbiten);

initial begin
  $timeformat(-9, 2, " ns", 20);
end

// Input feeding
reg [N-1:0] xx;
integer cnt;
always @(posedge clk) begin
  #0.1;
  data = xx[(N-WIDTH)-cnt*WIDTH +: WIDTH];
`ifdef DEBUG
  $display("time=%t data=%b", $time, data);
`endif
  cnt++;
end

task load(input string fn);
  logic [BS-1:0] x [0:XSZ-1];
  $readmemh(fn, x);
  xx = {>>{x}};
  cnt = 0;
`ifdef DEBUG
  $display("time=%t xx=%b", $time, xx);
`endif
  #(N/WIDTH);
endtask

initial begin
  load("x64-nr1-hex.dat");
  load("x64-nr2-hex.dat");
  load("x64-nr3-hex.dat");
  load("x64-nr4-hex.dat");
end

// Output checking
task check(input string fn);
  logic [BS-1:0] y [0:YSZ-1];
  wait(qstrobe == 1);
  @(posedge clk);
  $display("time=%t", $time);
  $readmemh(fn, y);
`ifdef VERBOSE
  $display("q=%b", q);
  $display("y=%b", {>>{y}});
`endif
  assert(q == {>>{y}});
  #1;
endtask

initial begin
  check("y64-nr1-hex.dat");
  check("y64-nr2-hex.dat");
  check("y64-nr3-hex.dat");
  check("y64-nr4-hex.dat");
  $finish;
end

endmodule: tb_toeplitz_p8
