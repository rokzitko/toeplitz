// Serialize a packed array of bits (from MSB to LSB)
// Rok Zitko, March 2022

module serializer #(
 parameter L = 128
)
(
input clk,
input reset,
input [L-1:0] q,
input qstrobe, // pulsed when q updated
output reg qbit,
output reg qbiten // true when valid data on qbit
);

integer l;
reg qdone, qready;

always @(posedge clk) begin
  if (reset) begin
    qbit <= 0;
    qbiten <= 0;
    qready <= 0;
    qdone <= 0;
    l <= 0;
  end else begin
    if (qready && !qdone) begin
      if (l <= L-1) begin
        qbit <= q[(L-1)-l]; // MSB towards LSB
        qbiten <= 1;
        l <= l+1;
      end else begin
        qbiten <= 0;
        qdone <= 1;
      end
    end else begin
      if (qstrobe) begin
        qbit <= q[L-1]; // MSB first!
        qbiten <= 1;
        l <= 1;
        qready <= 1;
        qdone <= 0;
      end
    end
  end
end

endmodule: serializer
