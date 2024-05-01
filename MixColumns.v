module MixColumns(input wire [127:0] state, output reg [127:0] out);

	function [7:0] mb2;
		input [7:0] a;
		mb2 = a[7] == 1? (a << 1) ^ 8'b00011011 : a << 1 ;
	endfunction

	reg[7:0] i;

	always@(*) begin
		for(i = 0; i < 4; i = i + 1) begin
			out[(i*32 + 24)+:8] = mb2(state[(i*32 + 24)+:8]) ^ mb2(state[(i*32 + 16)+:8]) ^ state[(i*32 + 16)+:8] ^ state[(i*32 + 8)+:8] ^ state[i*32+:8];
			out[(i*32 + 16)+:8] = state[(i*32 + 24)+:8] ^ mb2(state[(i*32 + 16)+:8]) ^ mb2(state[(i*32 + 8)+:8]) ^ state[(i*32 + 8)+:8] ^ state[i*32+:8];
			out[(i*32 + 8)+:8] = state[(i*32 + 24)+:8] ^ state[(i*32 + 16)+:8] ^ mb2(state[(i*32 + 8)+:8]) ^ mb2(state[i*32+:8]) ^ state[i*32+:8];
   		out[i*32+:8] = mb2(state[(i*32 + 24)+:8]) ^ state[(i*32 + 24)+:8] ^ state[(i*32 + 16)+:8] ^ state[(i*32 + 8)+:8] ^ mb2(state[i*32+:8]);
		end
	end
	
endmodule