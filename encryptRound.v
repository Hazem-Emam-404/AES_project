module encryptRound(state_in, key_round, state_out );

    input [127:0] state_in; 
    input [127:0] key_round;
    output [127:0] state_out;


    wire [127:0] after_shifRows;
    wire [127:0] after_mixColumns;
    wire [127:0] after_subBytes;
    wire [127:0] after_addRoundKey;


    subByte SB(.state(state_in), .statebar(after_subBytes));
    shiftrow127 SR(.State(after_subBytes), .next(after_shifRows));
    MixColumns MC(.state(after_shifRows), .out(after_mixColumns));
    AddRoundKey RK(.state(after_mixColumns), .roundKey(key_round), .outState(state_out));



endmodule