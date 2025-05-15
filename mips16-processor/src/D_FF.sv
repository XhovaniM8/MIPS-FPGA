/**
 * @module D_FF
 * @brief Asynchronous-reset D flip-flop with configurable initial value.
 *
 * @description
 * This module implements a positive-edge triggered D flip-flop with an asynchronous active-low reset.
 * On reset, the output `q` is assigned the value of `init_value`. On the rising edge of `clk`,
 * `q` takes the value of `d`.
 *
 * @ports
 * - input  logic clk         : Clock signal (positive edge triggered)
 * - input  logic rst_n       : Asynchronous active-low reset
 * - input  logic d           : Input data to the flip-flop
 * - input  logic init_value  : Initial value to set on reset
 * - output logic q           : Flip-flop output
 *
 * @example
 * D_FF u_ff (
 *   .clk(clk),
 *   .rst_n(rst_n),
 *   .d(d),
 *   .init_value(1'b0),
 *   .q(q)
 * );
 *
 * @author  Xhovani Mali
 * @date    2025
 */

 `timescale 1ns/1ps


module D_FF (
    input  logic clk,
    input  logic rst_n,
    input  logic d,
    input  logic init_value,
    output logic q
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= init_value;
        else
            q <= d;
    end

endmodule // D_FF

