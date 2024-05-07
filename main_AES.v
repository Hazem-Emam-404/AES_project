module main_AES(LED, _7seg2, _7seg1, _7seg0, clk, decription_en);

    input clk;
    input decription_en;
    output reg LED;
    output wire [6:0] _7seg2, _7seg1, _7seg0;
	 reg [7:0] out_Byte;


    localparam Nk = 8;
    localparam Nr = 14;
    localparam Nb = 4;
    integer round_num;
    integer round_num_inv;
    wire [127:0] plain_text;
    assign plain_text=128'h00112233445566778899aabbccddeeff;

    /////////// ------->input key
    wire [32*Nk-1:0] in_key;


    //assign in_key =128'h000102030405060708090a0b0c0d0e0f;  
    //assign in_key =192'h000102030405060708090a0b0c0d0e0f1011121314151617;  
    assign in_key =256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
    //-----------------------------------------------



    // ----------------> Expected
    wire [127:0] expected_out;
    //assign expected_out = 128'hdda97ca4864cdfe06eaf70a0ec0d7191;
	 //assign expected_out = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
	 assign expected_out = 128'h8ea2b7ca516745bfeafc49904b496089;

    /////////// --->Expanded key
    wire [ 128*(Nr+1)-1 : 0 ] Exp_key;

    //----------------for Encryption---------------------------------
    wire [127:0] out_state;
    wire [127:0] first_out_state;
    wire [127:0] last_out_state;
    reg [127:0] Encrypt_output;
    reg [127:0] state;

    //---------------for dycription------------------------------
    wire [127:0] out_state_inv;
    wire [127:0] first_out_state_inv;
    wire [127:0] last_out_state_inv;
    reg [127:0] decrypt_output;
    reg [127:0] state_inv;

   // reg [127:0] state;


//----------------> initialization /////////////////////
    initial begin 
        round_num=0;
        round_num_inv= Nr;
        LED = 0;
	    state = plain_text;
        out_Byte = plain_text[7:0];
    end
//------------------------------------------------------------




// ----------> Encryption  ///////////////////////////

    AddRoundKey AK (plain_text,Exp_key[127+128*(Nr-round_num) -: 128],first_out_state);
    KeyExpansion  #(Nk,Nr,Nb) KEX (in_key,Exp_key);
    encryptRound ER (state,Exp_key[127+128*(Nr-round_num) -: 128],out_state);

    // last round 
    wire [127:0] after_shifRows;
    wire [127:0] after_subBytes;
    subByte SB(.state(state), .statebar(after_subBytes));
    shiftrow127 SR(.State(after_subBytes), .next(after_shifRows));
    AddRoundKey RK(.state(after_shifRows), .roundKey(Exp_key[127 : 0]), .outState(last_out_state));
    //---------------------------------------------------------------------------------------------


 //--------------> Decryption  /////////////////////////////

    AddRoundKey IAK (Encrypt_output,Exp_key[127 -: 128],first_out_state_inv);
    decryptRound IDR (state_inv,Exp_key[127+128*(Nr-round_num_inv) -: 128],out_state_inv);

    // last round 
    wire [127:0] after_InvshifRows;
    wire [127:0] after_InvsubBytes;
    inv_shiftrow127 ISR(state_inv, after_InvshifRows);
    inverse_subByte ISB(.statebar(after_InvshifRows), .state(after_InvsubBytes));
    AddRoundKey IRK(.state(after_InvsubBytes), .roundKey(Exp_key[128*(Nr+1)-1 -: 128]), .outState(last_out_state_inv));
 ///-----------------------------------------------------------------------------------------------

    //7 segment 
    //wire[6:0] _7seg0, _7seg1, _7seg2;
    wire [9:0] lastByte;
    wire[11:0] lastByteBCD;
    ADD4BIT a(out_Byte, lastByte);
    assign lastByteBCD = {1'b0,1'b0, lastByte};
    BCD_7seg b(lastByteBCD[3:0],_7seg0);
    BCD_7seg c(lastByteBCD[7:4],_7seg1);
    BCD_7seg d(lastByteBCD[11:8],_7seg2);





    always @ (posedge clk) begin 

        if(round_num == 0)
            state = first_out_state;
        else if(round_num < Nr)
            state = out_state;
        else if (round_num == Nr) begin
            state = last_out_state;
            Encrypt_output = last_out_state;
            end
        if (round_num>Nr &&  decription_en == 1) begin
            if(round_num_inv == Nr)
                state_inv = first_out_state_inv;
            else if(round_num_inv > 0)
                state_inv = out_state_inv;
            else if (round_num_inv == 0) begin
                state_inv = last_out_state_inv;
                decrypt_output = last_out_state_inv;
                end
            if(round_num_inv>-1)
            round_num_inv = round_num_inv - 1;
        end

	    if(plain_text == decrypt_output)
		    LED = 1; 

       if(round_num< Nr+1)
				out_Byte = state[7:0];
       else 
				out_Byte = state_inv[7:0];
    

        round_num = round_num + 1;
    end
endmodule