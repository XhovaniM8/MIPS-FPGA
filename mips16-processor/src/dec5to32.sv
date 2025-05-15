/**
 * @module dec5to32
 * @brief 5-bit to 32-bit one-hot decoder.
 *
 * @description
 * Decodes a 5-bit input address into a 32-bit one-hot vector.
 * Only one output bit is high, corresponding to the binary value of the input.
 *
 * @ports
 * - input  logic [4:0]  Adr : Register address input
 * - output logic [31:0] Out : One-hot output vector
 *
 * @example
 * dec5to32 u_dec (.Adr(5'd4), .Out(one_hot));
 */

`timescale 1ns/1ps


module dec5to32 (
    input  logic [4:0]  Adr,
    output logic [31:0] Out
);

    always_comb begin
        Out = 32'd0;
        Out[Adr] = 1'b1;
    end

endmodule
