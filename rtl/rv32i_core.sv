import rv32i_types::*;

module rv32i_core (
    input logic clk,
    input logic reset
);
    logic [31:0] pc;
    logic [31:0] next_pc;
    logic [31:0] instruction;

    logic [4:0]  rs1_addr;
    logic [4:0]  rs2_addr;
    logic [4:0]  rd_addr;

    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    logic [31:0] writeback_data;

    logic [31:0] immediate;

    logic [31:0] alu_a;
    logic [31:0] alu_b;
    logic [31:0] alu_result;

    logic [31:0] mem_read_data;

    logic        reg_write;
    logic        alu_src;
    logic        alu_a_pc;
    logic        mem_write;
    logic        branch;
    logic        branch_taken;
    logic        jump;
    logic        jalr;

    alu_op_t      alu_op;
    imm_type_t    imm_type;
    result_src_t  result_src;

    //instantiating pc
    rv32i_pc pc_unit (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    //connect pc to imem
    rv32i_imem imem (
        .addr(pc),
        .instruction(instruction)
    );

    //instruction field extration for register addresses
    assign rs1_addr = instruction[19:15];
    assign rs2_addr = instruction[24:20];
    assign rd_addr  = instruction[11:7];

    //instantiating decoder
    rv32i_decoder decoder (
        .instruction(instruction),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .alu_a_pc(alu_a_pc),
        .mem_write(mem_write),
        .result_src(result_src),
        .branch(branch),
        .jump(jump),
        .jalr(jalr),
        .alu_op(alu_op),
        .imm_type(imm_type)
    );

    //reg file
    rv32i_regfile regfile (
    .clk(clk),
    .write_en(reg_write), //connect the register file’s write_en input to the core’s reg_write signal.
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .wr_addr(rd_addr),
    .wr_data(writeback_data),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data)
    );

    //immediate generator
    rv32i_imme_gnrtr immgen (
    .instruction(instruction),
    .imm_type(imm_type),
    .immediate(immediate)
    );

    assign alu_a = alu_a_pc ? pc : rs1_data;
    assign alu_b = alu_src ? immediate : rs2_data;


    rv32i_alu alu (
        .operand_a(alu_a),
        .operand_b(alu_b),
        .alu_op(alu_op),
        .result(alu_result)
    );

    rv32i_branch_unit branch_unit (
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),

        .funct3(instruction[14:12]),

        .branch_taken(branch_taken)
    );

    rv32i_dmem dmem (
        .clk(clk),
        .mem_write(mem_write),

        .addr(alu_result),
        .write_data(rs2_data),

        .read_data(mem_read_data)
    );

    assign pc_plus4 = pc + 32'd4;

    always_comb begin

        case (result_src)

            RES_ALU:
                writeback_data = alu_result;

            RES_MEM:
                writeback_data = mem_read_data;

            RES_PC4:
                writeback_data = pc_plus4;

            RES_IMM:
                writeback_data = immediate;

            default:
                writeback_data = 32'd0;

        endcase

    end

 rv32i_next_pc next_pc_unit (
        .pc(pc),
        .immediate(immediate),

        .branch(branch),
        .branch_taken(branch_taken),

        .jump(jump),
        .jalr(jalr),

        .rs1_data(rs1_data),

        .next_pc(next_pc)
    );

endmodule

