/**
 * @module adder
 * @brief Single-bit full adder.
 *
 * @description
 * Computes the sum and carry-out of two 1-bit inputs and a carry-in bit.
 * Implements the equation: sum = a ^ b ^ cin; cout = (a & b) | (cin & (a ^ b))
 *
 * @ports
 * - input  logic a     : First operand bit
 * - input  logic b     : Second operand bit
 * - input  logic cin   : Carry input
 * - output logic sum   : Sum output
 * - output logic cout  : Carry output
 *
 * @example
 * adder u_adder (
 *   .a(a),
 *   .b(b),
 *   .cin(cin),
 *   .sum(sum),
 *   .cout(cout)
 * );
 *
 * @author  Xhovani Mali
 * @date    2025
 */

 `timescale 1ns/1ps

module adder (
    input  logic a,
    input  logic b,
    input  logic cin,
    output logic sum,
    output logic cout
);
    // Behavioral modeling (RTL)
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
    
endmodule // adder
