`timescale 1ns/1ps

module rv32i_next_pc_tb;
    logic [31:0] pc;
    logic [31:0] immediate;
    logic branch;
    logic branch_taken;
    logic [31:0] next_pc;

    rv32i_next_pc dut(
        .pc(pc),
        .immediate(immediate),
        .branch(branch),
        .branch_taken(branch_taken),
        .next_pc(next_pc)
    );

    initial begin
        //0b 0bt
        pc = 32'd100;
        immediate = 32'd7;
        branch = 1'b0;
        branch_taken = 1'b0;

        #1;

        assert (next_pc == 32'd104)
            else $error("0b 0bt test failed");

        //1b 0bt
        pc = 32'd100;
        immediate = 32'd7;
        branch = 1'b1;
        branch_taken = 1'b0;

        #1;

        assert (next_pc == 32'd104)
            else $error("1b 0bt test failed");

        //1b 1bt
        pc = 32'd100;
        immediate = 32'd7;
        branch = 1'b1;
        branch_taken = 1'b1;

        #1;

        assert (next_pc == 32'd107)
            else $error("1b 1bt test failed");

    $display("Next PC test passed");
    $finish;
    end
endmodule