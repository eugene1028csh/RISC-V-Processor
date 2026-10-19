`timescale 1ns/1ps

module rv32i_core_mmio_tb;

    logic clk = 0;
    logic reset;

    logic [31:0] bus_addr;
    logic [31:0] bus_write_data;
    logic        bus_write_en;
    logic [31:0] bus_read_data;
    logic        bus_hit;

    logic saw_mmio_write;

    always #5 clk = ~clk;

    rv32i_core dut (
        .clk(clk),
        .reset(reset),

        .bus_addr(bus_addr),
        .bus_write_data(bus_write_data),
        .bus_write_en(bus_write_en),

        .bus_read_data(bus_read_data),
        .bus_hit(bus_hit)
    );

    mock_nna_mmio mock_nna (
        .bus_addr(bus_addr),
        .bus_write_data(bus_write_data),
        .bus_write_en(bus_write_en),

        .bus_read_data(bus_read_data),
        .bus_hit(bus_hit)
    );

    // Check whether CPU actually performs the MMIO store
    always_ff @(posedge clk) begin
        if (
            bus_write_en &&
            bus_addr == 32'h40000010 &&
            bus_write_data == 32'd42
        )
            saw_mmio_write <= 1'b1;
    end

    initial begin
        reset = 1;
        saw_mmio_write = 0;

        // Program:
        // x10 = 0x40000000
        // x5  = 42
        // SW x5 -> INPUT0
        // Read STATUS
        // Read OUT1
        // Read OUT2

        dut.imem.mem[0] = 32'h40000537; // lui  x10, 0x40000
        dut.imem.mem[1] = 32'h02A00293; // addi x5, x0, 42
        dut.imem.mem[2] = 32'h00552823; // sw   x5, 0x10(x10)

        dut.imem.mem[3] = 32'h00452083; // lw x1, 0x04(x10) -> STATUS = 1
        dut.imem.mem[4] = 32'h0C452103; // lw x2, 0xC4(x10) -> OUT1 = 10
        dut.imem.mem[5] = 32'h0C852183; // lw x3, 0xC8(x10) -> OUT2 = 115

        repeat (2) @(posedge clk);
        reset = 0;

        repeat (10) @(posedge clk);

        if (!saw_mmio_write)
            $fatal(1, "MMIO write was not observed");

        if (dut.regfile.regs[1] !== 32'd1)
            $fatal(1, "STATUS read failed: x1=%0d", dut.regfile.regs[1]);

        if (dut.regfile.regs[2] !== 32'd10)
            $fatal(1, "OUT1 read failed: x2=%0d", dut.regfile.regs[2]);

        if (dut.regfile.regs[3] !== 32'd115)
            $fatal(1, "OUT2 read failed: x3=%0d", dut.regfile.regs[3]);

        $display("PASS: CPU MMIO routing test");

        $finish;
    end

endmodule