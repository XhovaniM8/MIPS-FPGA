/**
 * @module internal_xor_5_bit_lfsr
 * @brief 5-bit Linear Feedback Shift Register (LFSR) with internal XOR feedback.
 *
 * @description
 * Implements a 5-bit LFSR where the feedback is the XOR of bits 1 and 4,
 * fed into bit 2. Flip-flops are initialized using `S_initial` and operate
 * on the rising edge of `clk` with asynchronous active-low reset `rst_n`.
 *
 * The register chain is:
 * s0 <- s4  
 * s1 <- s0  
 * s2 <- s1 ^ s4  
 * s3 <- s2  
 * s4 <- s3
 *
 * @ports
 * - input  logic        clk        : Clock signal (rising edge)
 * - input  logic        rst_n      : Asynchronous active-low reset
 * - input  logic [4:0]  S_initial  : Initial values for each flip-flop
 * - output logic [4:0]  Sout       : Current value of the 5-bit shift register
 *
 * @example
 * internal_xor_5_bit_lfsr u_lfsr (
 *   .clk(clk),
 *   .rst_n(rst_n),
 *   .S_initial(5'b10101),
 *   .Sout(lfsr_out)
 * );
 *
 * @author  Xhovani Mali
 * @date    2025
 */

`timescale 1ns/1ps

 module internal_xor_5_bit_lfsr (
    input   logic       clk,
    input   logic       rst_n,
    input   logic [4:0] S_initial,
    output  logic [4:0] Sout
 );

    logic [4:0] s_reg;
    logic d_xor;

    // Internal wiring using D_FF Module
    D_FF s0(.q(s_reg[0])), .d(s_reg[4]), .rst_n(rst_n), .clk(clk), .init_value(S_initial[0]);
    D_FF s1(.q(s_reg[1])), .d(s_reg[0]), .rst_n(rst_n), .clk(clk), .init_value(S_initial[1]);

    assign d_xor = s_reg[1] ^ s_reg[4];

    D_FF s2(.q(s_reg[2])), .d(d_xor), .rst_n(rst_n), .clk(clk), .init_value(S_initial[2])
    D_FF s0(.q(s_reg[3])), .d(s_reg[2]), .rst_n(rst_n), .clk(clk), .init_value(S_initial[3]);
    D_FF s1(.q(s_reg[4])), .d(s_reg[3]), .rst_n(rst_n), .clk(clk), .init_value(S_initial[4]);
