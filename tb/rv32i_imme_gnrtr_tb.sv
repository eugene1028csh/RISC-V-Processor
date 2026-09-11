`timescale 1ns/1ps
module rv32i_imme_gnrtr_tb;
    logic [31:0] instruction;
    logic [31:0] immediate;
    imm_type_t imm_type;

    rv32i_imme_gnrtr dut (
    .immediate(immediate),
    .instruction(instruction),
    .imm_type(imm_type)
    );

    initial begin
        instruction = 32'd0; //set whole instruction to 0
        instruction[31:20] = 12'd4; //put immediate value 4 into bits [31:20]
        imm_type = IMM_I;

        #1;

        assert (immediate == 32'd4)
            else $error("imme_gnrtr wrongg");

        //-ve instruction
        instruction = 32'd0;
        instruction [31:20] = 12'hFFF;
        imm_type = IMM_I;

        #1;

        assert (immediate == 32'hFFFFFFFF)
            else $error("-ve test wrong");

        //S-type test
        instruction = 32'd0;
        instruction[31:25] = 7'b0000000;
        instruction[11:7] = 5'b01000;
        imm_type = IMM_S;

        #1;

        assert (immediate == 32'd8)
            else $error("S-Type test fail");

        //S type -ve test
        instruction = 32'd0;
        instruction [31:25] = 7'b1111111;
        instruction [11:7] = 5'b11111;
        imm_type = IMM_S;

        #1;

        assert (immediate == 32'hFFFFFFFF)
            else $error("Negative S-Type test failed");

        //type B test
        instruction = 32'd0;
        instruction[31]    = 1'b0;
        instruction[30:25] = 6'b000000;
        instruction[11:8]  = 4'b0100;
        instruction[7]     = 1'b0;
        imm_type = IMM_B;

        #1;

        assert (immediate == 32'd8)
            else $error("B-type +8 test failed");

        //-ve type-B test
        instruction = 32'd0;
        instruction[31]    = 1'b1;       // imm[12]
        instruction[30:25] = 6'b111111;  // imm[10:5]
        instruction[11:8]  = 4'b1110;    // imm[4:1]
        instruction[7]     = 1'b1;       // imm[11]
        imm_type = IMM_B;

        #1;

        assert (immediate == 32'hFFFFFFFC)
            else $error("B-type -ve test failed");

        //U-type test
        instruction = 32'd0;
        instruction [31:12] = 20'h12345;
        imm_type = IMM_U;

        #1;

        assert (immediate == 32'h12345000)
            else $error("U type test failed");

        //U-type high-bit test
        instruction = 32'd0;
        instruction [31:12] = 20'hFFFFF;
        imm_type = IMM_U;

        #1;

        assert (immediate == 32'hFFFFF000)
            else $error("U type -ve test failed");

        // J-type +8 test
        instruction = 32'd0;
        instruction[31]    = 1'b0;          // imm[20]
        instruction[19:12] = 8'b00000000;   // imm[19:12]
        instruction[20]    = 1'b0;          // imm[11]
        instruction[30:21] = 10'b0000000100; // imm[10:1]
        imm_type = IMM_J;

        #1;

        assert (immediate == 32'd8)
            else $error("J-type +8 test failed");


        // J-type -4 test
        instruction = 32'd0;
        instruction[31]    = 1'b1;          // imm[20]
        instruction[19:12] = 8'b11111111;   // imm[19:12]
        instruction[20]    = 1'b1;          // imm[11]
        instruction[30:21] = 10'b1111111110; // imm[10:1]
        imm_type = IMM_J;

        #1;

        assert (immediate == 32'hFFFFFFFC)
            else $error("J-type -4 test failed");


        $display("immediate generator test passed!");


    $finish;
    end

endmodule