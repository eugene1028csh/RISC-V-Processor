`timescale 1ns/1ps

import rv32i_types::*;

module rv32i_decoder_tb;

    logic [31:0] instruction;

    logic        reg_write;
    logic        alu_src;
    logic        mem_write;
    result_src_t result_src;
    logic        branch;
    logic        jump;
    alu_op_t     alu_op;
    imm_type_t   imm_type;


    // DUT
    rv32i_decoder dut (
        .instruction(instruction),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .result_src(result_src),
        .branch(branch),
        .jump(jump),
        .alu_op(alu_op),
        .imm_type(imm_type)
    );

    // R-TYPE TEST TASK
    task test_r_type(
        input logic [2:0] test_funct3,
        input logic [6:0] test_funct7,
        input alu_op_t expected_op
    );
    begin

        instruction = 32'd0;

        instruction[6:0]   = 7'b0110011;   // R-type opcode
        instruction[14:12] = test_funct3;
        instruction[31:25] = test_funct7;

        #1;

        assert (reg_write == 1'b1)
            else $error("R-type reg_write failed");

        assert (alu_src == 1'b0)
            else $error("R-type alu_src failed");

        assert (mem_write == 1'b0)
            else $error("R-type mem_write failed");

        assert (result_src == RES_ALU)
            else $error("R-type result_src failed");

        assert (branch == 1'b0)
            else $error("R-type branch failed");

        assert (jump == 1'b0)
            else $error("R-type jump failed");

        assert (alu_op == expected_op)
            else $error("R-type alu_op failed");

    end
    endtask


    // I-TYPE ALU TEST TASK
    task test_i_type(
        input logic [2:0] test_funct3,
        input logic [6:0] test_funct7,
        input alu_op_t expected_op
    );
    begin

        instruction = 32'd0;

        instruction[6:0]   = 7'b0010011;   // I-type ALU opcode
        instruction[14:12] = test_funct3;
        instruction[31:25] = test_funct7;

        #1;

        assert (reg_write == 1'b1)
            else $error("I-type reg_write failed");

        assert (alu_src == 1'b1)
            else $error("I-type alu_src failed");

        assert (mem_write == 1'b0)
            else $error("I-type mem_write failed");

        assert (result_src == RES_ALU)
            else $error("I-type result_src failed");

        assert (branch == 1'b0)
            else $error("I-type branch failed");

        assert (jump == 1'b0)
            else $error("I-type jump failed");

        assert (imm_type == IMM_I)
            else $error("I-type imm_type failed");

        assert (alu_op == expected_op)
            else $error("I-type alu_op failed");

    end
    endtask

    initial begin
    // R-TYPE TESTS
        test_r_type(
            3'b000,
            7'b0000000,
            ALU_ADD
        ); // ADD

        test_r_type(
            3'b000,
            7'b0100000,
            ALU_SUB
        ); // SUB

        test_r_type(
            3'b111,
            7'b0000000,
            ALU_AND
        ); // AND

        test_r_type(
            3'b110,
            7'b0000000,
            ALU_OR
        ); // OR

        test_r_type(
            3'b100,
            7'b0000000,
            ALU_XOR
        ); // XOR

        test_r_type(
            3'b001,
            7'b0000000,
            ALU_SLL
        ); // SLL

        test_r_type(
            3'b101,
            7'b0000000,
            ALU_SRL
        ); // SRL

        test_r_type(
            3'b101,
            7'b0100000,
            ALU_SRA
        ); // SRA

        test_r_type(
            3'b010,
            7'b0000000,
            ALU_SLT
        ); // SLT

        test_r_type(
            3'b011,
            7'b0000000,
            ALU_SLTU
        ); // SLTU

    // I-TYPE ALU
        test_i_type(
            3'b000,
            7'b0000000,
            ALU_ADD
        ); // ADDI

        test_i_type(
            3'b010,
            7'b0000000,
            ALU_SLT
        ); // SLTI

        test_i_type(
            3'b011,
            7'b0000000,
            ALU_SLTU
        ); // SLTIU

        test_i_type(
            3'b100,
            7'b0000000,
            ALU_XOR
        ); // XORI

        test_i_type(
            3'b110,
            7'b0000000,
            ALU_OR
        ); // ORI

        test_i_type(
            3'b111,
            7'b0000000,
            ALU_AND
        ); // ANDI

        test_i_type(
            3'b001,
            7'b0000000,
            ALU_SLL
        ); // SLLI

        test_i_type(
            3'b101,
            7'b0000000,
            ALU_SRL
        ); // SRLI

        test_i_type(
            3'b101,
            7'b0100000,
            ALU_SRA
        ); // SRAI


        $display("R-type and I-type decoder tests passed!");

        $finish;

    end

endmodule