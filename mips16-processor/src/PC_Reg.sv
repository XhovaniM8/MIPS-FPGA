/**
 * @module PC_Reg
 * @brief 32-bit Program Counter (PC) register built from D flip-flops.
 *
 * @description
 * Stores the current program counter value (`PCOut`) using 32 D flip-flops.
 * Each flip-flop is initialized on reset and updated on the rising edge of `clk`.
 *
 * @ports
 * - input  logic        clk    : Clock signal
 * - input  logic        reset  : Asynchronous reset
 * - input  logic [31:0] PCin   : Input program counter value
 * - output logic [31:0] PCOut  : Stored program counter value
 *
 * @example
 * PC_Reg u_pc (
 *   .clk(clk),
 *   .reset(reset),
 *   .PCin(next_pc),
 *   .PCOut(current_pc)
 * );
 *
 * @note
 * Requires external D_FF module with this signature:
 * module D_FF(output logic q, input logic d, input logic rst_n, input logic clk, input logic init_value);
 *
 * @author  Xhovani Mali
 * @date    2025
 */

 `timescale 1ns/1ps

module PC_Reg (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] PCin,
    output logic [31:0] PCOut
);

    genvar i;
    generate
        for (i = 0; i < 32; i++) begin : dff_array
            D_FF dff_inst (
                .q(PCOut[i]),
                .d(PCin[i]),
                .rst_n(reset), // Assuming active-low reset
                .clk(clk),
                .init_value(1'b0)
            );
        end
    endgenerate

endmodule
