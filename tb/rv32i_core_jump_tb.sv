`timescale 1ns/1ps

module rv32i_core_jump_tb;
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

    always @(negedge clk) begin
        if (!reset) begin
            $display(
                "PC=%0d instr=%h rd=%0d reg_write=%b result_src=%0d pc4=%0d wb=%0d",
                dut.pc,
                dut.instruction,
                dut.rd_addr,
                dut.reg_write,
                dut.result_src,
                dut.pc_plus4,
                dut.writeback_data
            );
        end
    end

    initial begin
        //load program into instruction memory
        dut.imem.mem[0] = 32'h00100113; // addi x2,x0,1
        dut.imem.mem[1] = 32'h008000EF; // jal  x1,+8
        dut.imem.mem[2] = 32'h06300113; // addi x2,x0,99  skipped
        dut.imem.mem[3] = 32'h02A00193; // addi x3,x0,42

        dut.imem.mem[4] = 32'h00100313; // addi x6,x0,1
        dut.imem.mem[5] = 32'h01C00213; // addi x4,x0,28
        dut.imem.mem[6] = 32'h004202E7; // jalr x5,4(x4)
        dut.imem.mem[7] = 32'h06300313; // addi x6,x0,99  skipped
        dut.imem.mem[8] = 32'h00700393; // addi x7,x0,7

        //reset CPU
        reset = 1'b1;

        @(posedge clk);
        #1;

        reset = 1'b0;

        // 9 instructions are stored, but only 7 execute
        // because JAL and JALR each skip one instruction.
        //Since this is a single-cycle CPU, each instruction completes in one clock cycle.

        repeat (7) begin
            @(posedge clk);
            #1;
        end

        

        $display("PC = %0d", dut.pc);
        $display("x1 = %h", dut.regfile.regs[1]);
        $display("x2 = %h", dut.regfile.regs[2]);
        $display("x3 = %h", dut.regfile.regs[3]);
        $display("x4 = %h", dut.regfile.regs[4]);
        $display("x5 = %h", dut.regfile.regs[5]);
        $display("x6 = %h", dut.regfile.regs[6]);
        $display("x7 = %h", dut.regfile.regs[7]);

        assert (dut.regfile.regs[1] == 32'd8)
            else $fatal(1, "JAL return address wrong");

        assert (dut.regfile.regs[2] == 32'd1)
            else $fatal(1, "JAL failed to skip instruction");

        assert (dut.regfile.regs[3] == 32'd42)
            else $fatal(1, "JAL target failed");

        assert (dut.regfile.regs[5] == 32'd28)
            else $fatal(1, "JALR return address wrong");

        assert (dut.regfile.regs[6] == 32'd1)
            else $fatal(1, "JALR failed to skip instruction");

        assert (dut.regfile.regs[7] == 32'd7)
            else $fatal(1, "JALR target failed");

        $display("PASS: JAL/JALR integration test");
        $finish;


    end


endmodule
