`timescale 1ns/1ps

module rv32i_pc_tb;

    logic clk;
    logic reset;
    logic [31:0] next_pc;
    logic [31:0] pc;

    rv32i_pc dut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
    reset = 1;
    next_pc = 32'h12345678;

    @(posedge clk);
    #1;

    assert (pc == 32'd0)
        else $error("reset failure");

    reset = 0;
    next_pc = 32'h00000004;

    @(posedge clk);
    #1;

    assert (pc == 32'h00000004)
        else $error("PC update failure");

    reset = 0;
    next_pc = 32'h00000008;

    @(posedge clk);
    #1;

    assert (pc == 32'h00000008)
        else $error("PC update failure");

    reset = 1;
    next_pc = 32'hDEADBEEF;

    @(posedge clk);
    #1;

    assert (pc == 32'd0)
        else $error("PC reset priority failed");
    $finish;
    end

endmodule