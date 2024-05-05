module decryptRound(state_in, key_round, state_out );

    input [127:0] state_in; 
    input [127:0] key_round;
    output [127:0] state_out;


    wire [127:0] after_InvshifRows;
    wire [127:0] after_InvmixColumns;
    wire [127:0] after_InvsubBytes;
    wire [127:0] after_addRoundKey;


    inv_shiftrow127 ISR(state_in, after_InvshifRows);
    inverse_subByte ISB(.statebar(after_InvshifRows), .state(after_InvsubBytes));
    AddRoundKey RK(.state(after_InvsubBytes), .roundKey(key_round), .outState(after_addRoundKey));
    InvMixColumns MC(.state(after_addRoundKey), .out(state_out));



endmodule