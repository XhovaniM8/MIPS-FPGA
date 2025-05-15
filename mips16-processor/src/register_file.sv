/**
 * @module register_file
 * @brief 8-register, 16-bit dual-read, single-write register file.
 *
 * @description
 * Implements a register file with 8 general-purpose 16-bit registers. Supports:
 * - Asynchronous reset (clears all registers)
 * - Synchronous write on rising clock edge when `reg_write_en` is asserted
 * - Two independent read ports
 *
 * Register 0 is hardwired to 16'b0 and cannot be written to.
 *
 * @ports
 * - input  logic        clk              : Clock signal
 * - input  logic        rst              : Asynchronous reset
 * - input  logic        reg_write_en     : Enable signal for write
 * - input  logic [2:0]  reg_write_dest   : Destination register index
 * - input  logic [15:0] reg_write_data   : Data to write
 * - input  logic [2:0]  reg_read_addr_1  : Address of register for read port 1
 * - output logic [15:0] reg_read_data_1  : Data from read port 1
 * - input  logic [2:0]  reg_read_addr_2  : Address of register for read port 2
 * - output logic [15:0] reg_read_data_2  : Data from read port 2
 *
 * @example
 * register_file u_rf (
 *   .clk(clk),
 *   .rst(rst),
 *   .reg_write_en(w_en),
 *   .reg_write_dest(rd),
 *   .reg_write_data(w_data),
 *   .reg_read_addr_1(rs1),
 *   .reg_read_data_1(r_data1),
 *   .reg_read_addr_2(rs2),
 *   .reg_read_data_2(r_data2)
 * );
 *
 * @author  Xhovani Mali
 * @date    2025
 */

 `timescale 1ns/1ps

module register_file (
    input  logic        clk,
    input  logic        rst,
    input  logic        reg_write_en,
    input  logic [2:0]  reg_write_dest,
    input  logic [15:0] reg_write_data,
    input  logic [2:0]  reg_read_addr_1,
    output logic [15:0] reg_read_data_1,
    input  logic [2:0]  reg_read_addr_2,
    output logic [15:0] reg_read_data_2
);

    logic [15:0] reg_array [7:0];

    // Write logic with async reset
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (int i = 0; i < 8; i++) begin
                reg_array[i] <= 16'd0;
            end
        end else if (reg_write_en && reg_write_dest != 3'd0) begin
            reg_array[reg_write_dest] <= reg_write_data;
        end
    end

    // Read ports (register 0 hardwired to 0)
    assign reg_read_data_1 = (reg_read_addr_1 == 3'd0) ? 16'd0 : reg_array[reg_read_addr_1];
    assign reg_read_data_2 = (reg_read_addr_2 == 3'd0) ? 16'd0 : reg_array[reg_read_addr_2];

endmodule
