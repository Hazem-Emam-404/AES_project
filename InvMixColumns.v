module InvMixColumns(input wire [127:0] state, output reg [127:0] out);


	//mult by 2
	function [7:0] mb2;
		input [7:0] a, n;
		reg [7:0] j;
		begin
			for(j = 0; j < n; j = j + 1)
				a = a[7] == 1? (a << 1) ^ 8'b00011011 : a << 1 ;
			mb2 = a;
		end
	endfunction
	


	//mult by e => 14
	function [7:0] mb0e;
		input [7:0] a;
		mb0e = mb2(a,3) ^ mb2(a,2) ^ mb2(a,1);
	endfunction


    //mult by b => 11
	function [7:0] mb0b;
		input [7:0] a;
		mb0b = mb2(a,3) ^ mb2(a,1) ^ a;
	endfunction


    //mult by d => 13 
	function [7:0] mb0d;
		input [7:0] a;
		mb0d = mb2(a,3) ^ mb2(a,2) ^ a;
	endfunction

	//mult by 9
	function [7:0] mb09;
		input [7:0] a;
		mb09 = mb2(a,3) ^ a;
	endfunction


	reg [7:0] i;
	always @(*) begin
		for(i = 0; i < 4; i = i + 1) begin
			out[(i*32 + 24)+:8] = mb0e(state[(i*32 + 24)+:8]) ^ mb0b(state[(i*32 + 16)+:8]) ^ mb0d(state[(i*32 + 8)+:8]) ^ mb09(state[i*32+:8]);
			out[(i*32 + 16)+:8] = mb09(state[(i*32 + 24)+:8]) ^ mb0e(state[(i*32 + 16)+:8]) ^ mb0b(state[(i*32 + 8)+:8]) ^ mb0d(state[i*32+:8]);
			out[(i*32 + 8)+:8] = mb0d(state[(i*32 + 24)+:8]) ^ mb09(state[(i*32 + 16)+:8]) ^ mb0e(state[(i*32 + 8)+:8]) ^ mb0b(state[i*32+:8]);
   			out[i*32+:8] = mb0b(state[(i*32 + 24)+:8]) ^ mb0d(state[(i*32 + 16)+:8]) ^ mb09(state[(i*32 + 8)+:8]) ^ mb0e(state[i*32+:8]);
		end
	end


endmodule