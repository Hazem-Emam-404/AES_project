module ADD4BIT(    //01000101
input [7:0] in,
output [9:0] out
);
wire [3:0] temp0;
wire [3:0] temp01;
wire [3:0] temp02;
wire [3:0] temp03;
wire [3:0] temp04;
wire [3:0] temp05;
wire [3:0] temp06;
assign temp0[2:0]=in[7:5];
assign temp0[3]=1'b0;
wire [3:0] temp1;
wire [3:0] temp2;
wire [3:0] temp3;
wire [3:0] temp4;
wire [3:0] temp5;
wire [3:0] temp6;
wire [3:0] temp7;


add3 t1 (.in(temp0),.out(temp1));
assign temp01[3:1]=temp1[2:0];
assign temp01[0]=in[4];
//////////////////////////
add3 t2 (.in(temp01),.out(temp2));
assign temp02[3:1]=temp2[2:0];
assign temp02[0]=in[3];
////////////////////////////////
add3 t3 (.in(temp02),.out(temp3));
assign temp03[3:1]=temp3[2:0];
assign temp03[0]=in[2];
//////////////////////////////////
add3 t4 (.in(temp03),.out(temp4));
assign temp04[3:1]=temp4[2:0];
assign temp04[0]=in[1];
//////////////////////////////////////
add3 t5 (.in(temp04),.out(temp5));

////////////////////////////////////////
assign temp05[3]=1'b0;
assign temp05[2]=temp1[3];
assign temp05[1]=temp2[3];
assign temp05[0]=temp3[3];
add3 t6 (.in(temp05),.out(temp6));
assign temp06[0]=temp4[3];
assign temp06[3:1]=temp6[2:0];
///////////////////////////////
add3 t7 (.in(temp06),.out(temp7));
//////////////////////////////////
assign out[0]=in[0];
assign out[4:1]=temp5;
assign out[8:5]=temp7;
assign out[9]=temp6[3];




endmodule