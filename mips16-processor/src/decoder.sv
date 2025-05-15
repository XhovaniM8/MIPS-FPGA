/**
 * @module decoder
 * @brief Generates one-hot write enable signals for a 32-register file.
 *
 * @description
 * Given a 5-bit register address and a write-enable control signal, this module generates
 * a 32-bit one-hot `WriteEn` output where only one bit is high if `RegWrite` is asserted.
 * Register 0 is hardwired to zero and never written to.
 *
 * @ports
 * - input  logic        RegWrite       : Global register write enable
 * - input  logic [4:0]  WriteRegister  : Destination register address
 * - output logic [31:0] WriteEn        : One-hot encoded write enable signals
 *
 * @example
 * decoder u_decoder (
 *   .RegWrite(w_en),
 *   .WriteRegister(rd),
 *   .WriteEn(write_en)
 * );
 */

`timescale 1ns/1ps

module decoder (
    input  logic        RegWrite,
    input  logic [4:0]  WriteRegister,
    output logic [31:0] WriteEn
);

    logic [31:0] OE;

    dec5to32 u_dec(.Adr(WriteRegister), .Out(OE));

    // Write enable = OE[i] & RegWrite; reg 0 is hardwired to 0
    always_comb begin
        WriteEn = 32'd0;
        for (int i = 1; i < 32; i++) begin
            WriteEn[i] = OE[i] & RegWrite;
        end
    end

endmodule
