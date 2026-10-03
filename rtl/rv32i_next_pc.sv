module rv32i_next_pc(
    input  logic [31:0] pc,
    input  logic [31:0] immediate,
    input  logic        branch,
    input  logic        branch_taken,
    output logic [31:0] next_pc
);
always_comb begin
    next_pc = pc + 32'd4;

    if (branch && branch_taken)
        next_pc = pc + immediate;
end
endmodule