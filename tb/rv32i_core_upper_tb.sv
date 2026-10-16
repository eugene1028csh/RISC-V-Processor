`timescale 1ns/1ps

module rv32i_core_upper_tb;
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
        dut.imem.mem[0] = 32'h123450B7; // lui   x1,0x12345
        dut.imem.mem[1] = 32'h00001117; // auipc x2,0x1
        dut.imem.mem[2] = 32'h00700193; // addi  x3,x0,7

        //reset CPU
        reset = 1'b1;

        @(posedge clk);
        #1;

        reset = 1'b0;

        //execute instruction 3 times
        //Use 3 because test program has 3 instructions
        //Since this is a single-cycle CPU, each instruction completes in one clock cycle.

        repeat (3) begin
            @(posedge clk);
            #1;
        end

        assert (dut.regfile.regs[1] == 32'h12345000)
            else $fatal(1, "LUI failed");

        assert (dut.regfile.regs[2] == 32'h00001004)
            else $fatal(1, "AUIPC failed");

        assert (dut.regfile.regs[3] == 32'd7)
            else $fatal(1, "Instruction after AUIPC failed");

        $display("PASS: LUI/AUIPC integration test");
        $finish;


    end


endmodule
