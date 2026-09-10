`timescale 1ns/1ps

module rv32i_alu_tb;
    logic [31:0] operand_a;
    logic [31:0] operand_b;
    alu_op_t alu_op;
    logic [31:0] result;

    //instantiate
    rv32i_alu dut (
        .operand_a(operand_a),
        .operand_b(operand_b),
        .alu_op(alu_op),
        .result(result)
    );

    initial begin
        //ADD
        operand_a = 32'd10;
        operand_b = 32'd10;
        alu_op = ALU_ADD;

        #1;
        /*
        wait 1 simulation time unit before continuing, 1ns
        ALU is combinational. In real hardware, signals need a tiny propagation delay through gates. 
        In simulation, #1 gives the simulator time to update everything before the assertion checks result
        */
        assert(result == 32'd20)
            else $error("ADD test failed");

        //SUB
        operand_a = 32'd30;
        operand_b = 32'd10;
        alu_op = ALU_SUB;

        #1;

        assert(result == 32'd20)
            else $error("SUB test failedd");

        //AND
        operand_a = 4'b1110;
        operand_b = 4'b1010;
        alu_op = ALU_AND;

        #1;

        assert(result == 4'b1010)
            else $error("AND test faillll");

        //OR
        operand_a = 4'b1001;
        operand_b = 4'b0111;
        alu_op = ALU_OR;

        #1;

        assert (result == 4'b1111)
            else $error("OR test failure");

        //XOR
        operand_a = 4'b0110;
        operand_b = 4'b1111;
        alu_op = ALU_XOR;

        #1;

        assert (result == 4'b1001)
            else $error("XOR test no good");

        //SLL
        operand_a = 4'b0010;
        operand_b = 2;
        alu_op = ALU_SLL;

        #1;

        assert (result == 4'b1000)
            else $error("SLL wrong");

        //SRL
        operand_a = 4'b1100;
        operand_b = 2;
        alu_op = ALU_SRL;

        #1;

        assert (result == 4'b0011)
            else $error("SRL wrong");

        //SRA
        operand_a = 32'hFFFFFFF8; //-8
        /*
        32'hFFFFFFF8 means “a 32-bit hexadecimal value”; each hex digit represents 4 bits, 
        and this bit pattern equals -8 when interpreted as signed two’s complement.
        */
        operand_b = 1;
        alu_op = ALU_SRA;

        #1;

        assert (result == 32'hFFFFFFFC)
            else $error("SRA bad");

        //SLT
        operand_a = 32'hFFFFFFFF; // -1 signed, 4294967295 unsigned
        operand_b = 32'd1; //1
        alu_op = ALU_SLT;

        #1;

        assert (result == 32'd1)
            else $error("SLT bad");

        //SLTU
        operand_a = 32'hFFFFFFFF; // -1 signed, 4294967295 unsigned
        operand_b = 32'd1; //1
        alu_op = ALU_SLTU;

        #1;

        assert (result == 32'd0)
            else $error("SLTU test is bad");

        $finish;
    end

endmodule