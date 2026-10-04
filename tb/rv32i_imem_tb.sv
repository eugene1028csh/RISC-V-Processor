`timescale 1ns/1ps

module rv32i_imem_tb;

    logic [31:0] addr;
    logic [31:0] instruction;

    rv32i_imem dut (
        .addr(addr),
        .instruction(instruction)
    );

    initial begin

        //insert known values into instruction memory
        dut.mem[0] = 32'h11111111;
        dut.mem[1] = 32'h22222222;
        dut.mem[2] = 32'h33333333;
        dut.mem[5] = 32'h55555555;


        //Address 0, mem[0] test
        addr = 32'd0;
        #1;

        assert (instruction == 32'h11111111)
            else $error("IMEM address 0 failed :()");

        //Address 4, mem[1] test
        addr = 32'd4;
        #1;

        assert (instruction == 32'h22222222)
            else $error("IMEM address 4 failed");


        //Address 8, mem[2] test
        addr = 32'd8;
        #1;

        assert (instruction == 32'h33333333)
            else $error("IMEM address 8 failed");


        //Address 20, mem[5] test
        addr = 32'd20;
        #1;

        assert (instruction == 32'h55555555)
            else $error("IMEM address 20 failed");

        $display("IMEM tests passed");
        $finish;
    end

endmodule