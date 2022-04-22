// Split blocks of L bits into blocks of M bits.
// Warning: the input is not buffered, it is assumed constant for the duration of "chunking".
// Rok Zitko, March-April 2022

`default_nettype none

module chunker #(
 parameter L = 128,
 parameter M = 32
)
(
input wire clk,
input wire reset,
input wire [L-1:0] data_in,
input wire strobe, // pulsed when data_in updated
output reg [M-1:0] q,
output reg valid // true when valid data in q
);

integer l;
reg done, ready;

parameter NR = L/M;

// reset is asynchronous
always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 0;
    valid <= 0;
    ready <= 0;
    done <= 0;
    l <= 0;
  end else begin
    if (ready && !done) begin
      if (l <= NR-1) begin
        q[M-1:0] <= data_in[((NR-1)-l)*M +: M]; // MSB towards LSB
        valid <= 1;
        l <= l+1;
      end else begin
        q <= 0; // clear output for clarity; this is not strictly necessary
        valid <= 0;
        done <= 1;
      end
    end else begin
      if (strobe) begin
        q[M-1:0] <= data_in[(NR-1)*M +: M]; // MSB first!
        valid <= 1;
        l <= 1;
        ready <= 1;
        done <= 0;
      end
    end
  end
end

endmodule: chunker

`default_nettype wire
