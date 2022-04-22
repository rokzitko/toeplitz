// Testbench for chunker_with_buffer
// Rok Zitko, April 2022

`default_nettype none

//`define VERBOSE

timeunit 1ns;
timeprecision 100fs;

module tb_chunker_with_buffer;

reg clk;
initial clk <= 0;
always #0.5 clk <= ~clk;

reg reset;
initial begin
 reset <= 1;
 #1;
 reset <= 0;
end

parameter L = 8;
reg [L-1:0] data_in;
initial data_in <= 'b01101011;

integer cnt;

reg strobe;
initial begin
 strobe <= 0;
 #2;
 strobe <= 1;
 #1;
 strobe <= 0;

 // and again
 #4;
 cnt <= 0;
 strobe <= 1;
 #1;
 strobe <= 0;

 // and again, but with no "wait state"
 #3
// cnt <= 0; // let it wrap around!
 strobe <= 1;
 #1;
 strobe <= 0;
end

parameter M = 2;
parameter NR = L/M;
reg [M-1:0] q;
reg valid;

chunker_with_buffer #(.L(L),.M(M)) ser1(.clk, .reset, .data_in, .strobe, .q, .valid);

initial begin
  $timeformat(-9, 2, " ns", 20);
  #20;
  $finish;
end

initial begin
  cnt <= 0;
  while (1) begin
    @(posedge clk);
    if (valid == 1) begin
      assert(data_in[((NR-1)-cnt)*M +: M] == q);
      cnt <= (cnt+1) % NR; // wrap around
    end
  end
end

`ifdef VERBOSE
always @(posedge clk) begin
  $display("t=%t data_in=%b q=%b valid=%b", $time, data_in, q, valid);
end
`endif

endmodule: tb_chunker_with_buffer

