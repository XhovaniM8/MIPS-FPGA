/**
 * @module control
 * @brief Control unit for a simplified 16-bit MIPS processor.
 *
 * @description
 * Decodes a 3-bit opcode and generates control signals for ALU, memory, register file,
 * and branching. Handles both R-type and I/J-type instructions. A synchronous `reset`
 * sets all outputs to default no-operation values.
 *
 * @ports
 * - input  logic [2:0] opcode         : 3-bit instruction opcode
 * - input  logic       reset          : Active-high reset
 * - output logic [1:0] reg_dst        : Destination register selector
 * - output logic [1:0] mem_to_reg     : Data source for register write-back
 * - output logic [1:0] alu_op         : ALU control code
 * - output logic       jump           : Jump control signal
 * - output logic       branch         : Branch control signal
 * - output logic       mem_read       : Memory read enable
 * - output logic       mem_write      : Memory write enable
 * - output logic       alu_src        : ALU operand source selector
 * - output logic       reg_write      : Register file write enable
 * - output logic       sign_or_zero   : Selects sign or zero extension for immediate
 *
 * @author  Xhovani Mali
 * @date    2025
 */

`timescale 1ns/1ps

module control (
    input  logic [2:0] opcode,
    input  logic       reset,
    output logic [1:0] reg_dst,
    output logic [1:0] mem_to_reg,
    output logic [1:0] alu_op,
    output logic       jump,
    output logic       branch,
    output logic       mem_read,
    output logic       mem_write,
    output logic       alu_src,
    output logic       reg_write,
    output logic       sign_or_zero
);

    always_comb begin
        if (reset) begin
            reg_dst       = 2'b00;
            mem_to_reg    = 2'b00;
            alu_op        = 2'b00;
            jump          = 1'b0;
            branch        = 1'b0;
            mem_read      = 1'b0;
            mem_write     = 1'b0;
            alu_src       = 1'b0;
            reg_write     = 1'b0;
            sign_or_zero  = 1'b1;
        end else begin
            // Default values
            reg_dst       = 2'b01;
            mem_to_reg    = 2'b00;
            alu_op        = 2'b00;
            jump          = 1'b0;
            branch        = 1'b0;
            mem_read      = 1'b0;
            mem_write     = 1'b0;
            alu_src       = 1'b0;
            reg_write     = 1'b1;
            sign_or_zero  = 1'b1;

            case (opcode)
                3'b000: begin // R-type (add)
                    reg_dst      = 2'b01;
                    mem_to_reg   = 2'b00;
                    alu_op       = 2'b00;
                    alu_src      = 1'b0;
                    reg_write    = 1'b1;
                end

                3'b001: begin // slti
                    reg_dst      = 2'b00;
                    mem_to_reg   = 2'b00;
                    alu_op       = 2'b10;
                    alu_src      = 1'b1;
                    reg_write    = 1'b1;
                    sign_or_zero = 1'b0;
                end

                3'b010: begin // jump
                    jump         = 1'b1;
                    reg_write    = 1'b0;
                end

                3'b011: begin // jal
                    reg_dst      = 2'b10;
                    mem_to_reg   = 2'b10;
                    jump         = 1'b1;
                    reg_write    = 1'b1;
                end

                3'b100: begin // lw
                    reg_dst      = 2'b00;
                    mem_to_reg   = 2'b01;
                    alu_op       = 2'b11;
                    alu_src      = 1'b1;
                    mem_read     = 1'b1;
                    reg_write    = 1'b1;
                end

                3'b101: begin // sw
                    alu_op       = 2'b11;
                    alu_src      = 1'b1;
                    mem_write    = 1'b1;
                    reg_write    = 1'b0;
                end

                3'b110: begin // beq
                    alu_op       = 2'b01;
                    branch       = 1'b1;
                    reg_write    = 1'b0;
                end

                3'b111: begin // addi
                    reg_dst      = 2'b00;
                    mem_to_reg   = 2'b00;
                    alu_op       = 2'b11;
                    alu_src      = 1'b1;
                    reg_write    = 1'b1;
                end
            endcase
        end
    end

endmodule
