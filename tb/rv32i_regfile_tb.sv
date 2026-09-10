`timescale 1ns/1ps

module rv32i_regfile_tb;
    logic clk;
    logic write_en;
    logic [4:0] rs1_addr;
    logic [4:0] rs2_addr;
    logic [4:0] wr_addr;
    logic [31:0] wr_data;
    logic [31:0] rs1_data;
    logic [31:0] rs2_data;

    //instantiate
    rv32i_regfile dut (
        .clk(clk),
        .write_en(write_en),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    //clock setup
    initial begin
        clk =0;
        forever #5 clk = ~clk; //every 5 ns, flip the clock value.
    end

    initial begin
        write_en = 1;
        wr_addr = 5'd4;
        wr_data = 32'd123;

        @(posedge clk);
        rs1_addr = 5'd4;

        #1;

        assert (rs1_data == 32'd123)
            else $error("rs1_data wrong");

    end

endmodule
