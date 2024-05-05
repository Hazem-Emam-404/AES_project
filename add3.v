module add3(
input [3:0] in,
output [3:0] out
);

assign out=
(in>=4'b0101)?in+4'b0011:in;


endmodule