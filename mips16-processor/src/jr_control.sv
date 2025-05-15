/**
 * @module JR_Control
 * @brief Detects the 'jr' (jump register) instruction.
 *
 * @description
 * Asserts `JRControl` if the combination of `alu_op` and `funct` matches the encoding
 * of a `jr` instruction (typically `alu_op == 2'b00` and `funct == 4'b1000`).
 *
 * @ports
 * - input  logic [1:0] alu_op    : ALU operation type (from main control unit)
 * - input  logic [3:0] funct     : Function field (from R-type instruction)
 * - output logic       JRControl : High if instruction is `jr`
 *
 * @author  Xhovani Mali
 * @date    2025
 */

`timescale 1ns/1ps

module jr_control (
    input  logic [1:0] alu_op,
    input  logic [3:0] funct,
    output logic       JRControl
);

    assign JRControl = ({alu_op, funct} == 6'b001000);

endmodule
