`timescale 1ns/1ps

module rv32i_core_tb;

    logic clk;
    logic reset;

    rv32i_core dut (
        .clk(clk),
        .reset(reset)
    );


    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end


    initial begin
        //load program into instruction memory
        //addi x1, x0, 5
        dut.imem.mem[0] = 32'h00500093;

        //addi x2, x0, 7
        dut.imem.mem[1] = 32'h00700113;

        //add x3, x1, x2
        dut.imem.mem[2] = 32'h002081B3;

        //sw x3, 0(x0)
        dut.imem.mem[3] = 32'h00302023;

        //reset CPU
        reset = 1'b1;

        @(posedge clk);
        #1;

        reset = 1'b0;

        
        repeat (4) begin
            @(posedge clk);
            #1;
        end

        //check final register values
        assert (dut.regfile.regs[1] == 32'd5)
            else $error("x1 failed");

        assert (dut.regfile.regs[2] == 32'd7)
            else $error("x2 failed");

        assert (dut.regfile.regs[3] == 32'd12)
            else $error("x3 failed");

        //data memory
        assert (dut.dmem.mem[0] == 32'd12)
            else $error("DMEM[0] failed");


        $display("FULL CPU PROGRAM TEST PASSED");
        $finish;

    end

endmodule