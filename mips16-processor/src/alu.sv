/**
 * @module alu
 * @brief 16-bit Arithmetic Logic Unit (ALU).
 *
 * @description
 * A simple 16-bit ALU supporting arithmetic and logic operations. The result is based on the `alu_control` signal,
 * which selects from `add`, `sub`, `and`, `or`, and `slt` (set-on-less-than). A `zero` output is also provided
 * to indicate whether the result is zero.
 *
 * @ports
 * - input  logic [15:0] a            : First operand
 * - input  logic [15:0] b            : Second operand
 * - input  logic [2:0]  alu_control  : Operation selector
 * - output logic [15:0] result       : Computed result
 * - output logic        zero         : High if result == 0
 *
 * @example
 * alu u_alu (
 *   .a(a),
 *   .b(b),
 *   .alu_control(alu_control),
 *   .result(result),
 *   .zero(zero)
 * );
 *
 * @author  Xhovani Mali
 * @date    2025
 */

 `timescale 1ns/1ps


 module alu (
    input   logic     [15:0]    a,
    input   logic     [15:0]    b,
    input   logic     [2:0]     alu_control,
    output  logic     [15:0]    result,
    output  logic               zero
 );

    always_comb begin
        case (alu_control)
            3'b000: result = a + b;              // ADD
            3'b001: result = a - b;              // SUB
            3'b010: result = a & b;              // AND
            3'b011: result = a | b;              // OR
            3'b100: result = (a < b) ? 16'd1 : 16'd0;  // SLT
            default: result = 16'd0;             // Default case
        endcase
    end

    assign zero = (result == 16'd0);
    
 endmodule
