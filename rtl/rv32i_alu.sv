typedef enum logic [3:0]{ //4 bits for each enum value
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

module rv32i_alu (
    input logic [31:0] operand_a,
    input logic [31:0] operand_b,
    input alu_op_t alu_op,
    output logic [31:0] result
);

endmodule