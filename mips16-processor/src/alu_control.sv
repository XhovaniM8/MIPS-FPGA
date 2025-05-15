/**
 * @module ALUControl
 * @brief ALU control unit that selects the ALU operation based on ALUOp and Function code.
 *
 * @description
 * Based on the `ALUOp` from the main control unit and the `Function` field from the instruction,
 * this module determines the ALU operation (3-bit code) to execute.
 *
 * @ports
 * - input  logic [1:0] ALUOp       : ALU operation type from main control unit
 * - input  logic [3:0] Function    : Function code from R-type instruction
 * - output logic [2:0] ALU_Control : ALU operation selector
 *
 * @author  Xhovani Mali
 * @date    2025
 */

`timescale 1ns/1ps

module alu_control (
    input  logic [1:0] ALUOp,
    input  logic [3:0] Function,
    output logic [2:0] ALU_Control
);

    logic [5:0] ALUControlIn;
    assign ALUControlIn = {ALUOp, Function};

    always_comb begin
        casez (ALUControlIn)
            6'b11????: ALU_Control = 3'b000; // lw/sw/addi → ADD
            6'b10????: ALU_Control = 3'b100; // slti        → SLT
            6'b01????: ALU_Control = 3'b001; // beq         → SUB

            // R-type Function decoding
            6'b000000: ALU_Control = 3'b000; // ADD
            6'b000001: ALU_Control = 3'b001; // SUB
            6'b000010: ALU_Control = 3'b010; // AND
            6'b000011: ALU_Control = 3'b011; // OR
            6'b000100: ALU_Control = 3'b100; // SLT

            default  : ALU_Control = 3'b000;
        endcase
    end

endmodule
