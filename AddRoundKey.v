module AddRoundKey(state,roundKey,outState);

    input [127:0] state;
    input [127:0] roundKey;
    output  [127:0] outState;


    assign outState = state ^ roundKey;



endmodule