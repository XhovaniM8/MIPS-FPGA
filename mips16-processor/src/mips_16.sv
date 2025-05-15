/**
 * @module mips_16
 * @brief Top-level module for a single-cycle 16-bit MIPS processor.
 *
 * @description
 * Implements the full datapath of a simplified 16-bit MIPS processor, including:
 * - Instruction fetch
 * - Register file
 * - Immediate extension
 * - ALU operation
 * - Control unit
 * - Data memory
 * - PC update logic (supports jumps, branches, and JR)
 *
 * @ports
 * - input  logic       clk         : Clock input
 * - input  logic       reset       : Active-high reset
 * - output logic [15:0] pc_out     : Program counter output
 * - output logic [15:0] alu_result : Final ALU result
 *
 * @author Xhovani Mali
 * @date   2025
 */

`timescale 1ns/1ps

module mips_16 (
    input  logic       clk,
    input  logic       reset,
    output logic [15:0] instruction,
    output logic [15:0] pc_out,
    output logic [15:0] alu_result
);

    // === PC Register ===
    logic [15:0] pc_current, pc_next, pc2;
    assign pc2 = pc_current + 16'd2;

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            pc_current <= 16'd0;
        else
            pc_current <= pc_next;
    end

    // === Instruction Fetch ===
    logic [15:0] instr;
    instr_mem instruction_memory(.pc(pc_current), .instruction(instr));
    assign instruction = instr;  // <-- moved here, after instr declared

    // === Control Signals ===
    logic [1:0] reg_dst, mem_to_reg, alu_op;
    logic jump, branch, mem_read, mem_write, alu_src, reg_write, sign_or_zero;

    control control_unit (
        .opcode(instr[15:13]),
        .reset(reset),
        .reg_dst(reg_dst),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .jump(jump),
        .branch(branch),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .sign_or_zero(sign_or_zero)
    );

    // === Register File Interface ===
    logic [2:0] reg_write_dest, reg_read_addr_1, reg_read_addr_2;
    logic [15:0] reg_read_data_1, reg_read_data_2, reg_write_data;

    assign reg_read_addr_1 = instr[12:10];
    assign reg_read_addr_2 = instr[9:7];

    assign reg_write_dest = (reg_dst == 2'b10) ? 3'd7 :
                            (reg_dst == 2'b01) ? instr[6:4] :
                                                 instr[9:7];

    register_file reg_file (
        .clk(clk),
        .rst(reset),
        .reg_write_en(reg_write),
        .reg_write_dest(reg_write_dest),
        .reg_write_data(reg_write_data),
        .reg_read_addr_1(reg_read_addr_1),
        .reg_read_data_1(reg_read_data_1),
        .reg_read_addr_2(reg_read_addr_2),
        .reg_read_data_2(reg_read_data_2)
    );

    // === Immediate Extension ===
    logic [15:0] sign_ext_im, zero_ext_im, imm_ext;
    assign sign_ext_im = {{9{instr[6]}}, instr[6:0]};
    assign zero_ext_im = {9'd0, instr[6:0]};
    assign imm_ext     = sign_or_zero ? sign_ext_im : zero_ext_im;

    // === JR Control ===
    logic JRControl;
    jr_control jr_control (
        .alu_op(alu_op),
        .funct(instr[3:0]),
        .JRControl(JRControl)
    );

    // === ALU Control ===
    logic [2:0] ALU_Control;
    alu_control alu_ctrl (
        .ALUOp(alu_op),
        .Function(instr[3:0]),
        .ALU_Control(ALU_Control)
    );

    // === ALU ===
    logic [15:0] read_data2, ALU_out;
    assign read_data2 = alu_src ? imm_ext : reg_read_data_2;

    logic zero_flag;
    alu alu_unit (
        .a(reg_read_data_1),
        .b(read_data2),
        .alu_control(ALU_Control),
        .result(ALU_out),
        .zero(zero_flag)
    );

    // === Branch Logic ===
    logic [15:0] im_shift_1, no_sign_ext, PC_beq, PC_4beq;
    logic [14:0] jump_shift_1;
    logic [15:0] PC_j, PC_4beqj, PC_jr;

    assign im_shift_1 = {imm_ext[14:0], 1'b0};
    assign no_sign_ext = ~im_shift_1 + 1'b1;

    assign PC_beq = im_shift_1[15] ? (pc2 - no_sign_ext) : (pc2 + im_shift_1);
    assign PC_4beq = branch && zero_flag ? PC_beq : pc2;

    assign jump_shift_1 = {instr[13:0], 1'b0};
    assign PC_j = {pc2[15], jump_shift_1};
    assign PC_4beqj = jump ? PC_j : PC_4beq;
    assign PC_jr = reg_read_data_1;

    assign pc_next = JRControl ? PC_jr : PC_4beqj;

    // === Data Memory ===
    logic [15:0] mem_read_data;
    data_memory datamem (
        .clk(clk),
        .mem_access_addr(ALU_out),
        .mem_write_data(reg_read_data_2),
        .mem_write_en(mem_write),
        .mem_read(mem_read),
        .mem_read_data(mem_read_data)
    );

    // === Write Back Mux ===
    assign reg_write_data = (mem_to_reg == 2'b10) ? pc2 :
                            (mem_to_reg == 2'b01) ? mem_read_data :
                                                     ALU_out;

    // === Outputs ===
    assign pc_out = pc_current;
    assign alu_result = ALU_out;

endmodule
