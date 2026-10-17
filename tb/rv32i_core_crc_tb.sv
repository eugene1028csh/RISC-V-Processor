`timescale 1ns/1ps

module rv32i_core_crc_tb;;
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
            "PC=%0d instr=%h rd=%0d reg_write=%b result_src=%0d crc=%h wb=%h",
            dut.pc,
            dut.instruction,
            dut.rd_addr,
            dut.reg_write,
            dut.result_src,
            dut.crc_result,
            dut.writeback_data
        );
    end
end

    initial begin
        //load program into instruction memory
        // addi x1, x0, 13
        dut.imem.mem[0] = 32'h00D00093;

        // addi x2, x0, 0
        dut.imem.mem[1] = 32'h00000113;

        // CRCB x3, x1, x2
        dut.imem.mem[2] = 32'h802081B3;

        //reset CPU
        reset = 1'b1;

        @(posedge clk);
        #1;

        reset = 1'b0;


        repeat (3) begin
            @(posedge clk);
            #1;
        end
    

        if (dut.regfile.regs[1] !== 32'h0000000D)
            $fatal(1, "x1 wrong");

        if (dut.regfile.regs[2] !== 32'h00000000)
            $fatal(1, "x2 wrong");

        if (dut.regfile.regs[3] !== 32'h0000D1AD)
            $fatal(1, "CRCB result wrong: got %h", dut.regfile.regs[3]);

        $display("PASS: XiCRC full-core integration test");
        $finish;


    end


endmodule
