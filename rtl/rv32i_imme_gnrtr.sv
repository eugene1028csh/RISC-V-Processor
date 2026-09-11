typedef enum logic [2:0] {
    IMM_I,
    IMM_S,
    IMM_B,
    IMM_U,
    IMM_J
} imm_type_t;


module rv32i_imme_gnrtr(
input logic [31:0] instruction,
output logic [31:0] immediate,
input imm_type_t imm_type
);

always_comb begin
    case (imm_type)

    IMM_I : immediate = {{20{instruction[31]}}, instruction [31:20]};
    /*
    20 * MSB (bit 31) +
    append the original 12-bit immediate instruction[31:20]
    */
    IMM_S : immediate = {{20{instruction[31]}}, instruction [31:25], instruction [11:7]};
    /*
    20 copied sign bits + 7 upper immediate bits + 5 lower immediate bits = 32 bits total
    */

    default  : immediate = 32'd0;

    endcase
end

endmodule