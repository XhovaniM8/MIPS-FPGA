/**
 * @module instr_mem
 * @brief 16-word, 16-bit instruction ROM (read-only memory).
 *
 * @description
 * A simple synthesizable ROM used as instruction memory.
 * Fetches a 16-bit instruction using the current program counter (`pc`).
 * Each word is aligned to 2 bytes; only bits [4:1] of `pc` are used as address.
 * If `pc` exceeds valid range (>= 32), outputs zero.
 *
 * @ports
 * - input  logic [15:0] pc          : Program counter input (byte address)
 * - output logic [15:0] instruction : Fetched 16-bit instruction
 *
 * @example
 * instr_mem u_instr_mem (
 *   .pc(pc),
 *   .instruction(instr)
 * );
 *
 * @author  Xhovani Mali
 * @date    2025
 */

`timescale 1ns/1ps

module instr_mem (
    input  logic [15:0] pc,
    output logic [15:0] instruction
);

    logic [15:0] rom [0:15];  // 16-word ROM

    // Address is word-aligned: use pc[4:1]
    wire [3:0] rom_addr = pc[4:1];

    // ROM Initialization (example program)
    initial begin
        // Loop:
        rom[0] = 16'b100000_000_011_0000; // lw   $3, 0($0)      ; $3 = mem[0]
        rom[1] = 16'b001010_011_001_1100; // slti $1, $3, 28     ; $1 = ($3 < 28)
        rom[2] = 16'b110100_001_000_0111; // beq  $1, $0, +7     ; if not < 28, skip
        rom[3] = 16'b000000_100_100_011; // add  $4, $4, $3      ; $4 += $3
        rom[4] = 16'b111000_011_011_0001; // addi $3, $3, 1      ; $3 += 1
        rom[5] = 16'b110000_000_000_1101; // beq  $0, $0, -3     ; loop to ROM[3]
        rom[6] = 16'd0;
        rom[7] = 16'd0;
        rom[8] = 16'd0;
        rom[9] = 16'd0;
        rom[10] = 16'd0;
        rom[11] = 16'd0;
        rom[12] = 16'd0;
        rom[13] = 16'd0;
        rom[14] = 16'd0;
        rom[15] = 16'd0;
    end


    // Output instruction, guard against out-of-bounds access
    assign instruction = (pc < 16'd32) ? rom[rom_addr] : 16'd0;

endmodule
