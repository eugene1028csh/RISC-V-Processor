`timescale 1ns/1ps

module rv32i_branch_unit_tb;
    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    logic [2:0] funct3;
    logic branch_taken;

    rv32i_branch_unit dut(
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .funct3(funct3),
        .branch_taken(branch_taken)
    );

    initial begin
        //BEQ
        rs1_data = 32'd10;
        rs2_data = 32'd10;
        funct3 = 3'b000;

        #1;

        assert (branch_taken == 1'b1)
            else $error("BEQ test failed");

        //BEQ false
        rs1_data = 32'd10;
        rs2_data = 32'd5;
        funct3 = 3'b000;

        #1;

        assert (branch_taken == 1'b0)
            else $error("BEQ false test failed");


        //BNE
        rs1_data = 32'd10;
        rs2_data = 32'd25;
        funct3 = 3'b001;

        #1;

        assert (branch_taken == 1'b1)
            else $error("BNE test failed");

        //BlT
        rs1_data = 32'hFFFFFFF9; //-7 signed
        rs2_data = 32'd20;
        funct3 = 3'b100;

        #1;

        assert (branch_taken == 1'b1)
            else $error("BLT test failed");   
        
        //BGE
        rs1_data = 32'd20;
        rs2_data = 32'hFFFFFFF9; //-7 signed
        funct3 = 3'b101;

        #1;

        assert (branch_taken == 1'b1)
            else $error("BGE test failed");   
                
        //BLTU
        rs1_data = 32'd7;
        rs2_data = 32'd20;
        funct3 = 3'b110;

        #1;

        assert (branch_taken == 1'b1)
            else $error("BLTU test failed");   
        
        //BLTU with -7 in signed, but a huge number in unsigned
        rs1_data = 32'hFFFFFFF9;
        rs2_data = 32'd20;
        funct3   = 3'b110;

        #1;

        assert (branch_taken == 1'b0)
            else $error("BLTU unsigned test failed");
                        
        //BGEU
        rs1_data = 32'd20;
        rs2_data = 32'd8;
        funct3 = 3'b111;

        #1;

        assert (branch_taken == 1'b1)
            else $error("BGEU test failed");
        

        $display("Branch unit tests passed");
        $finish;

    end

endmodule