`timescale 1ns/1ps

module rv32i_regfile_tb;
    logic clk;
    logic write_en;
    logic [4:0] rs1_addr; //which register i want to read from
    logic [4:0] rs2_addr;//which register i want to read from
    logic [4:0] wr_addr; //which register i want to write to
    logic [31:0] wr_data; // what is the data i want to write
    logic [31:0] rs1_data; //what is the data at the register i want to read from
    logic [31:0] rs2_data; //what is the data at the register i want to read from

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
        rs1_addr = 5'd0;
        rs2_addr = 5'd0;
        write_en = 1;
        wr_addr = 5'd4;
        wr_data = 32'd123;

        @(posedge clk);
        rs1_addr = 5'd4;

        #1;

        assert (rs1_data == 32'd123)
            else $error("rs1_data wrong");

        //test x0
        rs1_addr = 5'd6;
        rs2_addr = 5'd7;
        write_en = 1;
        wr_addr = 5'd0;
        wr_data = 32'd67;

        @(posedge clk);
        rs1_addr = 5'd0;

        #1;

        assert (rs1_data == 32'd0)
            else $error("rs1_data wrong");

        //2 registers
        //write x6 = 67
        write_en = 1;
        wr_addr = 5'd6;
        wr_data = 32'd67;
        @(posedge clk);
        #1;

        //write x7 = 47
        write_en =1;
        wr_addr = 5'd7;
        wr_data = 32'd47;
        @(posedge clk);
        #1;

        //read both simulataneously
        write_en = 0;
        rs1_addr = 5'd6;
        rs2_addr = 5'd7;

        #1;

        assert (rs1_data == 32'd67)
            else $error("rs1_data wrong");
        assert (rs2_data == 32'd47)
            else $error("rs2_data wrong");

        //write_en is 0
        write_en = 0;
        wr_addr = 5'd6;
        wr_data = 32'd88;

        @(posedge clk);
        #1;

        rs1_addr = 5'd6;
        
        #1;

        assert (rs1_data == 32'd67)
            else $error("rs1_data wrong");
        
        //overwrite register test
        write_en = 1;
        wr_addr = 5'd6;
        wr_data = 32'd90;

        @(posedge clk);
        rs1_addr = 5'd6;

        #1;

        assert (rs1_data == 32'd90)
            else $error("rs1_data wrong");

        //read from x0
        write_en = 0;
        rs1_addr = 5'd0;
        rs2_addr = 5'd0;

        #1;

        assert (rs1_data == 32'd0)
            else $error("x0 read port 1 failed");

        assert (rs2_data == 32'd0)
            else $error("x0 read port 2 failed");

    $display("Register file write/read test passed!");
    $finish;
    end

endmodule
