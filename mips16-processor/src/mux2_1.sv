/**
 * @module mux2_1
 * @brief 1-bit 2-to-1 multiplexer.
 *
 * @description
 * Outputs one of two input bits (`A` or `B`) based on the select signal `sel`.
 *
 * @ports
 * - input  logic A    : Input 0
 * - input  logic B    : Input 1
 * - input  logic sel  : Select line
 * - output logic O    : Selected output
 *
 * @example
 * mux2_1 u_mux (.A(a), .B(b), .sel(sel), .O(out));
 * 
 * @author  Xhovani Mali
 * @date    2025
 */

`timescale 1ns/1ps

 module mux2_1 (
    input  logic A,
    input  logic B,
    input  logic sel,
    output logic O
);
    assign O = (sel == 1'b0) ? A : B;
endmodule
