// Testbench for serializer
// Rok Zitko, March 2022

`default_nettype none

timeunit 1ns;
timeprecision 100fs;

module tb_ser;

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
reg [L-1:0] q;
initial q <= 'b01101001;

integer cnt;

reg qstrobe;
initial begin
 qstrobe <= 0;
 #2;
 qstrobe <= 1;
 #1;
 qstrobe <= 0;

 // and again
 #10;
 cnt <= 0;
 qstrobe <= 1;
 #1;
 qstrobe <= 0;
end

reg qbit, qbiten;

serializer #(.L(L)) ser1(.clk, .reset, .q, .qstrobe, .qbit, .qbiten);

initial begin
  $timeformat(-9, 2, " ns", 20);
  #40;
  $finish;
end

initial begin
  cnt <= 0;
  while (1) begin
    @(posedge clk);
    if (qbiten == 1) begin
      assert(q[(L-1)-cnt] == qbit); // from MSB to LSB
      cnt <= cnt+1;
    end
  end
end

endmodule: tb_ser
