`timescale 1ns/1ps

module rv32i_core_branch_tb;
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
        dut.imem.mem[0] = 32'h00500093; // addi x1,x0,5
        dut.imem.mem[1] = 32'h00500113; // addi x2,x0,5
        dut.imem.mem[2] = 32'h00000193; // addi x3,x0,0
        dut.imem.mem[3] = 32'h00208463; // beq  x1,x2,+8
        dut.imem.mem[4] = 32'h06300193; // addi x3,x0,99  <-- skipped
        dut.imem.mem[5] = 32'h02A00213; // addi x4,x0,42
        dut.imem.mem[6] = 32'h00209463; // bne  x1,x2,+8
        dut.imem.mem[7] = 32'h00700293; // addi x5,x0,7

        //reset CPU
        reset = 1'b1;

        @(posedge clk);
        #1;

        reset = 1'b0;

        // Execute 7 instructions
    // 8 instructions are stored, but the taken BEQ skips one
        //Since this is a single-cycle CPU, each instruction completes in one clock cycle.

        repeat (7) begin
            @(posedge clk);
            #1;
        end

        assert (dut.regfile.regs[1] == 32'd5)
            else $fatal(1, "x1 wrong");

        assert (dut.regfile.regs[2] == 32'd5)
            else $fatal(1, "x2 wrong");

        assert (dut.regfile.regs[3] == 32'd0)
            else $fatal(1, "BEQ failed: skipped instruction executed");

        assert (dut.regfile.regs[4] == 32'd42)
            else $fatal(1, "BEQ target failed");

        assert (dut.regfile.regs[5] == 32'd7)
            else $fatal(1, "BNE not-taken path failed");

        $display("PASS: Branch integration test");
        $finish;


    end


endmodule
