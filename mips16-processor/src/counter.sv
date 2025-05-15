/**
 * @module counter
 * @brief 4-bit synchronous up-counter with enable and async reset.
 *
 * @description
 * A 4-bit up-counter that increments on each rising edge of `clk` when `enable` is asserted.
 * When `rst_n` is deasserted (low), the counter resets asynchronously to 0.
 *
 * @ports
 * - input  logic clk     : Clock input (rising edge triggered)
 * - input  logic rst_n   : Asynchronous active-low reset
 * - input  logic enable  : Counter enable signal
 * - output logic [3:0] count : Current counter value
 *
 * @example
 * counter u_counter (
 *   .clk(clk),
 *   .rst_n(rst_n),
 *   .enable(enable),
 *   .count(count)
 * );
 *
 * @author  Xhovani Mali
 * @date    2025
 */

`timescale 1ns/1ps

 module counter (
    input logic clk,
    input logic rst_n,
    input logic enable,
    output logic [3:0] count
 );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 4'd0;
        else if (enable)
            count <= count + 4'd1;
    end
endmodule

