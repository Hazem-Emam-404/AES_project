module inv_shiftrow127(
    input wire [127:0] State,
    output reg [127:0] next 
);


always@(*)begin
///////////////////////////first row
next[7:0]<=State[7:0];
next[39:32]<=State[39:32];
next[71:64]<=State[71:64];
next[103:96]<=State[103:96];
////////////////////////////second row
next[15:8]<=State[111:109];
next[47:40]<=State[15:8];
next[79:72]<=State[47:40];
next[111:109]<=State[79:72];
////////////////////////////third row
next[23:16]<=State[87:80];
next[55:48]<=State[119:112];
next[87:80]<=State[23:16];
next[119:112]<=State[55:48];
/////////////////////////fourth row
next[31:24]<=State[63:56];
next[63:56]<=State[95:88];
next[95:88]<=State[127:120];
next[127:120]<=State[31:24];
	


end
endmodule