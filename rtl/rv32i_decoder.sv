import rv32i_types::*;

module rv32i_decoder(
    //ports
    input  logic [31:0] instruction,
    output logic        reg_write,
    output logic        alu_src,
    output logic        mem_write,
    output result_src_t result_src,
    output logic        branch,
    output logic        jump,
    output alu_op_t      alu_op,
    output imm_type_t    imm_type
);
    //internal signals
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];

always_comb begin
    reg_write  = 1'b0;
    alu_src    = 1'b0;
    mem_write  = 1'b0;
    result_src = RES_ALU;
    branch     = 1'b0;
    jump       = 1'b0;
    alu_op     = ALU_ADD;
    imm_type   = IMM_I;
case (opcode)
    7'b0110011: begin //If the instruction opcode is 0110011, this is an R-type ALU instruction
    //Control signals for all R-type instructions
            reg_write  = 1'b1;
            alu_src    = 1'b0;
            mem_write  = 1'b0;
            result_src = RES_ALU;
            branch     = 1'b0;
            jump       = 1'b0;

            case (funct3)
                3'b000: begin
                    if (funct7 == 7'b0100000)
                        alu_op = ALU_SUB;
                    else
                        alu_op = ALU_ADD;
                end
                3'b111: alu_op = ALU_AND;
                3'b110: alu_op = ALU_OR;
                3'b100: alu_op = ALU_XOR;

                3'b001: alu_op = ALU_SLL;

                3'b101: begin
                    if (funct7 == 7'b0100000)
                        alu_op = ALU_SRA;
                    else
                        alu_op = ALU_SRL;
                end

                3'b010: alu_op = ALU_SLT;
                3'b011: alu_op = ALU_SLTU;

                default: alu_op = ALU_ADD;

            endcase
        end

        //if the opcode is not 0110011, don’t enter the R-type decode block.
        default: begin
            // Keep safe defaults

        end


            endcase
    end
endmodule