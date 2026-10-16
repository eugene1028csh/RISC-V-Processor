`timescale 1ns/1ps

module rv32i_core_lw_tb;
    logic clk;
    logic reset;

    rv32i_core dut(
        .clk(clk),
        .reset(reset)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        //load program into instruction memory
        dut.imem.mem[0] = 32'h00C00093;
        dut.imem.mem[1] = 32'h00102023;
        dut.imem.mem[2] = 32'h00002103;
        dut.imem.mem[3] = 32'h001101B3;

        //reset CPU
        reset = 1'b1;

        @(posedge clk);
        #1;

        reset = 1'b0;

        //execute instruction 4 times
        //Use 4 because test program has 4 instructions
        //Since this is a single-cycle CPU, each instruction completes in one clock cycle.

        repeat (4) begin
            @(posedge clk);
            #1;
        end

        assert (dut.regfile.regs[1] == 32'd12)
            else $fatal(1, "x1 wrong");

        assert (dut.dmem.mem[0] == 32'd12)
            else $fatal(1, "DMEM wrong");

        assert (dut.regfile.regs[2] == 32'd12)
            else $fatal(1, "LW failed");

        assert (dut.regfile.regs[3] == 32'd24)
            else $fatal(1, "ADD after LW failed");

        $display("PASS: LW integration test");
        $finish;


    end


endmodule
