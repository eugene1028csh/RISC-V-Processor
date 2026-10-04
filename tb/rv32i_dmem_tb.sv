`timescale 1ns/1ps

module rv32i_dmem_tb;

    logic        clk;
    logic        mem_write;
    logic [31:0] addr;
    logic [31:0] write_data;
    logic [31:0] read_data;

    rv32i_dmem dut (
        .clk(clk),
        .mem_write(mem_write),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        //Write 0x67676767 into address 8 -> mem[2]
        addr       = 32'd8;
        write_data = 32'h67676767;
        mem_write  = 1'b1;

        @(posedge clk);
        #1;

        assert (read_data == 32'h67676767)
            else $error("DMEM rw test failed");

        //Attempt to overwrite with mem_write = 0
        write_data = 32'hAAAAAAAA;
        mem_write  = 1'b0;

        @(posedge clk);
        #1;

        assert (read_data == 32'h67676767)
            else $error("DMEM mem_write disable test failed");

        
        // Write another location
        addr       = 32'd20;
        write_data = 32'h1283902;
        mem_write  = 1'b1;

        @(posedge clk);
        #1;

        assert (read_data == 32'h1283902)
            else $error("DMEM second address test failed");


        $display("DMEM tests passed");
        $finish;
    end

endmodule