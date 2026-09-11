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


        $display("immediate generator test passed!");
    $finish;
    end

endmodule