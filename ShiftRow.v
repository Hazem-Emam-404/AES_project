module shiftrow127(
    input [0:127] State,
    output [0:127] next 
);


///////////////////////////
assign next[0:7]=State[0:7];
assign next[32:39]=State[32:39];
assign next[64:71]=State[64:71];
assign next[96:103]=State[96:103];
///////////////////////////
assign next[8:15]=State[40:47];
assign next[40:47]=State[72:79];
assign next[72:79]=State[104:111];
assign next[104:111]=State[8:15];
//////////////////////////////
assign next[16:23]=State[80:87];
assign next[48:55]=State[112:119];
assign next[80:87]=State[16:23];
assign next[112:119]=State[48:55];
//////////////////////////////
assign next[24:31]=State[120:127];
assign next[56:63]=State[24:31];
assign next[88:95]=State[56:63];
assign next[120:127]=State[88:95];
	

<<<<<<< Updated upstream
endmodule

=======
endmodule
>>>>>>> Stashed changes
