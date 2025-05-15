/**
 * @module data_memory
 * @brief 16-bit data memory with separate read and write paths.
 *
 * @description
 * Implements a 16-bit wide, 256-word memory.
 * Word-aligned accesses only; address bits [0] must be 0.
 * Write occurs on clock edge when `mem_write_en` is high.
 * Read is combinational and gated by `mem_read`.
 *
 * @author  Xhovani Mali
 * @date    2025
 */

`timescale 1ns/1ps

module data_memory #(
    parameter int MEM_DEPTH = 256,
    parameter int DATA_WIDTH = 16,
    parameter int ADDR_WIDTH = $clog2(MEM_DEPTH)
) (
    input  logic                   clk,
    input  logic [DATA_WIDTH-1:0] mem_access_addr,
    input  logic [DATA_WIDTH-1:0] mem_write_data,
    input  logic                   mem_write_en,
    input  logic                   mem_read,
    output logic [DATA_WIDTH-1:0] mem_read_data
);

    // Memory declaration
    logic [DATA_WIDTH-1:0] ram [0:MEM_DEPTH-1];
    logic [ADDR_WIDTH-1:0] ram_addr;

    // Word-aligned addressing
    assign ram_addr = mem_access_addr[ADDR_WIDTH:1];

    // Initialize memory (for simulation only)
    initial begin
        for (int i = 0; i < MEM_DEPTH; i++)
            ram[i] = '0;

        ram[0] = 16'd0; // <- Start counting from 0
    end

    // Synchronous write
    always_ff @(posedge clk) begin
        if (mem_write_en)
            ram[ram_addr] <= mem_write_data;
    end

    // Combinational read
    always_comb begin
        mem_read_data = mem_read ? ram[ram_addr] : '0;
    end

    // Runtime assertion for valid address (word-aligned, in bounds)
    always_ff @(posedge clk) begin
        assert ((mem_access_addr[0] == 1'b0) && (mem_access_addr[15:ADDR_WIDTH+1] == 0)) else
            $fatal("Invalid address: %h. Must be word-aligned and within 0-%0d.", mem_access_addr, MEM_DEPTH-1);
    end

endmodule
