// Split blocks of L bits into blocks of M bits.
// Warning: the input is not buffered, it is assumed constant for the duration of "chunking".
// Rok Zitko, March 2022

module chunker #(
 parameter L = 128,
 parameter M = 32
)
(
input clk,
input reset,
input [L-1:0] data_in,
input strobe, // pulsed when data_in updated
output reg [M-1:0] q,
output reg valid // true when valid data in q
);

integer l;
reg done, ready;

parameter NR = L/M;

always @(posedge clk) begin
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