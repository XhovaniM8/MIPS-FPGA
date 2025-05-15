/**
 * @module mux2x5to5
 * @brief 5-bit wide 2-to-1 multiplexer.
 *
 * @description
 * Selects between two 5-bit input vectors (`Addr0`, `Addr1`) based on `Select`
 * and outputs a single 5-bit vector `AddrOut`.
 *
 * @ports
 * - input  logic [4:0] Addr0    : First input vector
 * - input  logic [4:0] Addr1    : Second input vector
 * - input  logic       Select   : Select line (0 = Addr0, 1 = Addr1)
 * - output logic [4:0] AddrOut  : Output vector
 *
 * @example
 * mux2x5to5 u_mux5 (
 *   .Addr0(addr0),
 *   .Addr1(addr1),
 *   .Select(sel),
 *   .AddrOut(out)
 * );
 *
 * @author  Xhovani Mali
 * @date    2025
 */

`timescale 1ns/1ps

module mux2_5to5 (
    input  logic [4:0] Addr0,
    input  logic [4:0] Addr1,
    input  logic       Select,
    output logic [4:0] AddrOut
);

    genvar i;
    generate
        for (i = 0; i < 5; i++) begin : mux_loop
            mux2_1 u_mux (
                .A(Addr0[i]),
                .B(Addr1[i]),
                .sel(Select),
                .O(AddrOut[i])
            );
        end
    endgenerate

endmodule
