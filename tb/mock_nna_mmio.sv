module mock_nna_mmio (
    input  logic [31:0] bus_addr,
    input  logic [31:0] bus_write_data,
    input  logic        bus_write_en,

    output logic [31:0] bus_read_data,
    output logic        bus_hit
);

    always_comb begin
        bus_hit       = 1'b0;
        bus_read_data = 32'd0;

        if (bus_addr[31:8] == 24'h400000) begin
            bus_hit = 1'b1;

            case (bus_addr)
                32'h40000004:
                    bus_read_data = 32'h00000001; // pretend DONE

                32'h400000C0:
                    bus_read_data = 32'd0;

                32'h400000C4:
                    bus_read_data = 32'd10;

                32'h400000C8:
                    bus_read_data = 32'd115;

                32'h400000CC:
                    bus_read_data = 32'd0;

                default:
                    bus_read_data = 32'd0;
            endcase
        end
    end

endmodule