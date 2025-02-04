module main_AES(reset,mode,LED, _7seg2, _7seg1, _7seg0, clk, decription_en);

    input clk;
    input reset;
    input [1:0] mode;
    input decription_en;
    output reg LED;
    output wire [6:0] _7seg2, _7seg1, _7seg0;
	 


    reg [7:0] out_Byte;
    integer Nr ;

    integer round_num;
    integer round_num_inv;
    wire [127:0] plain_text;
    assign plain_text=128'haa112233445566778899aabbccddeeff;

    /////////// ------->input key
    wire [127:0] in_key128;
    wire [191:0] in_key192;
    wire [255:0] in_key256;


    assign in_key128 =128'h000102030405060708090a0b0c0d0e0f;  
    assign in_key192 =192'h000102030405060708090a0b0c0d0e0f0001020304050607;  
    assign in_key256 =256'h000102030405060708090a0b0c0d0e0f000102030405060708090a0b0c0d0e0f;
    //-----------------------------------------------


    /////////// --->Expanded key
    wire [ 1407 : 0 ] Exp_key128;
    wire [ 1663 : 0 ] Exp_key192;
    wire [ 1919 : 0 ] Exp_key256;
    //----------------for Encryption---------------------------------

        //128
    wire [127:0] out_state128;
    wire [127:0] first_out_state128;
    wire [127:0] last_out_state128;
    reg [127:0] Encrypt_output;
    reg [127:0] state;

        //192
    wire [127:0] out_state192;
    wire [127:0] first_out_state192;
    wire [127:0] last_out_state192;
   // reg [127:0] Encrypt_output192;

        //256
    wire [127:0] out_state256;
    wire [127:0] first_out_state256;
    wire [127:0] last_out_state256;
   // reg [127:0] Encrypt_output256;

    //---------------for dycription------------------------------
        //128
    wire [127:0] out_state_inv128;
    wire [127:0] first_out_state_inv128;
    wire [127:0] last_out_state_inv128;
    reg [127:0] decrypt_output;
    reg [127:0] state_inv;

        //192
    wire [127:0] out_state_inv192;
    wire [127:0] first_out_state_inv192;
    wire [127:0] last_out_state_inv192;
  //  reg [127:0] decrypt_output192;

        //256
    wire [127:0] out_state_inv256;
    wire [127:0] first_out_state_inv256;
    wire [127:0] last_out_state_inv256;
  //  reg [127:0] decrypt_output256;




//----------------> initialization /////////////////////
    initial begin 
        round_num=0;
        LED = 0;
	state = plain_text;
        out_Byte = plain_text[7:0];
        if(mode == 2'b01)
        begin
            Nr = 10;        
            round_num_inv= 10;
        end
        else if(mode == 2'b10)
        begin
            Nr = 12;
            round_num_inv= 12;
        end
        else if(mode == 2'b11)
        begin
            Nr = 14;
            round_num_inv= 14;
        end
        else
        begin
            Nr = 10;
            round_num_inv= 10;
        end

    end
//------------------------------------------------------------



    //KeyExpansion  #(Nk,Nr,Nb) KEX (in_key,Exp_key);
    KeyExpansion128 KEXP128 (in_key128,Exp_key128);
    KeyExpansion192 KEXP192 (in_key192,Exp_key192);
    KeyExpansion256 KEXP256 (in_key256,Exp_key256);

  // ----------> Encryption128  ///////////////////////////

    AddRoundKey AK128 (plain_text,Exp_key128[127+128*(Nr) -: 128],first_out_state128);
    encryptRound ER128 (state,Exp_key128[127+128*(Nr-round_num) -: 128],out_state128);

    // last round 
    wire [127:0] after_shifRows128;
    wire [127:0] after_subBytes128;
    subByte SB128(.state(state), .statebar(after_subBytes128));
    shiftrow127 SR128(.State(after_subBytes128), .next(after_shifRows128));
    AddRoundKey RK128(.state(after_shifRows128), .roundKey(Exp_key128[127 : 0]), .outState(last_out_state128));
    //---------------------------------------------------------------------------------------------

  // ----------> Encryption192  ///////////////////////////   

    AddRoundKey AK192 (plain_text,Exp_key192[127+128*(Nr) -: 128],first_out_state192);
    encryptRound ER192 (state,Exp_key192[127+128*(Nr-round_num) -: 128],out_state192);

    // last round 
    wire [127:0] after_shifRows192;
    wire [127:0] after_subBytes192;
    subByte SB192(.state(state), .statebar(after_subBytes192));
    shiftrow127 SR192(.State(after_subBytes192), .next(after_shifRows192));
    AddRoundKey RK192(.state(after_shifRows192), .roundKey(Exp_key192[127 : 0]), .outState(last_out_state192));
    //---------------------------------------------------------------------------------------------

  // ----------> Encryption256  ///////////////////////////  

    AddRoundKey AK256 (plain_text,Exp_key256[127+128*(Nr) -: 128],first_out_state256);
    encryptRound ER256 (state,Exp_key256[127+128*(Nr-round_num) -: 128],out_state256);

    // last round 
    wire [127:0] after_shifRows256;
    wire [127:0] after_subBytes256;
    subByte SB256(.state(state), .statebar(after_subBytes256));
    shiftrow127 SR256(.State(after_subBytes256), .next(after_shifRows256));
    AddRoundKey RK256(.state(after_shifRows256), .roundKey(Exp_key256[127 : 0]), .outState(last_out_state256));
    //---------------------------------------------------------------------------------------------


 //--------------> Decryption128  /////////////////////////////  

    AddRoundKey IAK128 (Encrypt_output,Exp_key128[127 -: 128],first_out_state_inv128);
    decryptRound IDR128 (state_inv,Exp_key128[127+128*(Nr-round_num_inv) -: 128],out_state_inv128);

    // last round 
    wire [127:0] after_InvshifRows128;
    wire [127:0] after_InvsubBytes128;
    inv_shiftrow127 ISR128(state_inv, after_InvshifRows128);
    inverse_subByte ISB128(.statebar(after_InvshifRows128), .state(after_InvsubBytes128));
    AddRoundKey IRK128(.state(after_InvsubBytes128), .roundKey(Exp_key128[128*(Nr+1)-1 -: 128]), .outState(last_out_state_inv128));
 ///-----------------------------------------------------------------------------------------------

  //--------------> Decryption192  /////////////////////////////  

    AddRoundKey IAK192 (Encrypt_output,Exp_key192[127 -: 128],first_out_state_inv192);
    decryptRound IDR192 (state_inv,Exp_key192[127+128*(Nr-round_num_inv) -: 128],out_state_inv192);

    // last round 
    wire [127:0] after_InvshifRows192;
    wire [127:0] after_InvsubBytes192;
    inv_shiftrow127 ISR192(state_inv, after_InvshifRows192);
    inverse_subByte ISB192(.statebar(after_InvshifRows192), .state(after_InvsubBytes192));
    AddRoundKey IRK192(.state(after_InvsubBytes192), .roundKey(Exp_key192[128*(Nr+1)-1 -: 128]), .outState(last_out_state_inv192));
 ///-----------------------------------------------------------------------------------------------

  //--------------> Decryption256  /////////////////////////////  

    AddRoundKey IAK256 (Encrypt_output,Exp_key256[127 -: 128],first_out_state_inv256);
    decryptRound IDR256 (state_inv,Exp_key256[127+128*(Nr-round_num_inv) -: 128],out_state_inv256);

    // last round 
    wire [127:0] after_InvshifRows256;
    wire [127:0] after_InvsubBytes256;
    inv_shiftrow127 ISR256(state_inv, after_InvshifRows256);
    inverse_subByte ISB256(.statebar(after_InvshifRows256), .state(after_InvsubBytes256));
    AddRoundKey IRK256(.state(after_InvsubBytes256), .roundKey(Exp_key256[128*(Nr+1)-1 -: 128]), .outState(last_out_state_inv256));
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



    always @ (posedge reset,posedge clk) begin 

        if(reset)   begin 
            out_Byte <= plain_text[7:0];
	        state <= plain_text;
            round_num <= 0;
            decrypt_output <= Encrypt_output;
            LED = 0;
            if(mode == 2'b01)
            begin
                Nr <= 10;        
                round_num_inv<= 10;
            end
            else if(mode == 2'b10)
            begin
                Nr <= 12;
                round_num_inv<= 12;
            end
            else if(mode == 2'b11)
            begin
                Nr <= 14;
                round_num_inv<= 14;
            end
            else
            begin
                Nr <= 10;
                round_num_inv<= 10;
            end
        end

        else begin
            if(round_num == 0)
            begin
                if(mode == 2'b01)
                begin
                    state = first_out_state128;
                end
                else if(mode == 2'b10)
                begin
                    state = first_out_state192;
                end
                else if(mode == 2'b11)
                begin
                    state = first_out_state256;
                end
                else
                begin
                    state = first_out_state128;
                end
            end

        else if(round_num < Nr) begin
            if(mode == 2'b01)
            begin
                state = out_state128;
            end
            else if(mode == 2'b10)
            begin
                state = out_state192;
            end
            else if(mode == 2'b11)
            begin
                state = out_state256;
            end
            else    
            begin
                state = out_state128;
            end        
        end
        else if (round_num == Nr) begin
            if(mode == 2'b01)
            begin
                state = last_out_state128;
                Encrypt_output = last_out_state128;
            end
            else if(mode == 2'b10)
            begin
                state = last_out_state192;
                Encrypt_output = last_out_state192;
            end
            else if(mode == 2'b11)
            begin
                state = last_out_state256;
                Encrypt_output = last_out_state256;
             end
            else
            begin
                state = last_out_state128;
                Encrypt_output = last_out_state128;
            end  
        end
        if (round_num>Nr &&  decription_en == 1) begin

            if(round_num_inv == Nr) begin
                if(mode == 2'b01)
                begin
                    state_inv = first_out_state_inv128;
                end
                else if(mode == 2'b10)
                begin
                        state_inv = first_out_state_inv192;
                end
                else if(mode == 2'b11)
                begin
                        state_inv = first_out_state_inv256;
                end
                else
                begin
                         state_inv = first_out_state_inv128;
                end                
            end

            else if(round_num_inv > 0) begin
                if(mode == 2'b01)
                begin
                        state_inv = out_state_inv128;
                end
                else if(mode == 2'b10)
                begin
                        state_inv = out_state_inv192;
                end
                else if(mode == 2'b11)
                begin
                        state_inv = out_state_inv256;
                end
                else
                begin
                        state_inv = out_state_inv128;
                end   
            end
            else if (round_num_inv == 0) begin

                 if(mode == 2'b01)
                begin
                         state_inv = last_out_state_inv128;
                        decrypt_output = last_out_state_inv128;
                end
                else if(mode == 2'b10)
                begin
                        state_inv = last_out_state_inv192;
                        decrypt_output = last_out_state_inv192;
                end
                else if(mode == 2'b11)
                begin
                        state_inv = last_out_state_inv256;
                        decrypt_output = last_out_state_inv256;
                end
                else
                begin
                        state_inv = last_out_state_inv128;
                        decrypt_output = last_out_state_inv128;
                 end                  
            end
            if(round_num_inv>-1)
            round_num_inv = round_num_inv - 1;
        end

	    if(plain_text == decrypt_output)
		    LED = 1; 

        if(round_num< Nr+1)
				out_Byte = state[7:0];
        else if(decription_en) 
				out_Byte = state_inv[7:0];
        else out_Byte = 8'b00000000;
    

        round_num = round_num + 1;
    end
    end
endmodule