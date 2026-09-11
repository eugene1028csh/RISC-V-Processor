typedef enum logic [3:0] {
    ALU_ADD,
    ALU_SUB,
    ALU_AND,
    ALU_OR,
    ALU_XOR,
    ALU_SLL,
    ALU_SRL,
    ALU_SRA,
    ALU_SLT,
    ALU_SLTU
} alu_op_t;

typedef enum logic [2:0] {
    IMM_I,
    IMM_S,
    IMM_B,
    IMM_U,
    IMM_J
} imm_type_t;

typedef enum logic [1:0] {
    RES_ALU,
    RES_MEM,
    RES_PC4
} result_src_t;


module rv32i_decoder(

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
    7'b0110011: begin
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
        default: begin
            // Keep safe defaults
        end


            endcase
    end
endmodule