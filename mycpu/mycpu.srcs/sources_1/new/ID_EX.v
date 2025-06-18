`timescale 1ns / 1ps
`include "params.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2025 11:20:56 PM
// Design Name: 
// Module Name: ID_EX
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module ID_EX(
    input clk,
    input reset,

    input [3:0] ID_alu_op_sel,
    input ID_alu_src1_sel,
    input ID_alu_src2_sel,
    input ID_reg_w_en,
    input [2:0] ID_reg_w_data_sel,
    input [1:0] ID_store_width,
    input [2:0] ID_load_width,
    input ID_load_un,
    input [31:0] ID_imm,
    input ID_br_un,
    input [31:0] ID_rs1_data,
    input [31:0] ID_rs2_data,
    input [4:0] ID_rs1,
    input [4:0] ID_rs2,
    input [4:0] ID_rd,
    input [31:0] ID_pc,
    input [31:0] ID_pc_plus_4,
    input [31:0] ID_I_addr,
    input ID_jal,
    input ID_jalr,
    input [2:0] ID_branch_type,
    input ID_branch_predict,
    input [31:0] ID_inst,
    input ID_ecall,
    input ID_mret,
    input [11:0] ID_csr_addr,
    input [2:0] ID_csr_op,
    input [31:0] ID_csr_r_data,
    input [31:0] ID_mtvec,
    input [31:0] ID_mepc,
    input [31:0] ID_mboot,
    input ID_calc_slow,
    input ID_reset,

    output reg [3:0] EX_alu_op_sel,
    output reg EX_alu_src1_sel,
    output reg EX_alu_src2_sel,
    output reg EX_reg_w_en,
    output reg [2:0] EX_reg_w_data_sel,
    output reg [1:0] EX_store_width,
    output reg [2:0] EX_load_width,
    output reg EX_load_un,
    output reg [31:0] EX_imm,
    output reg EX_br_un,
    output reg [31:0] EX_rs1_data,
    output reg [31:0] EX_rs2_data,
    output reg [4:0] EX_rs1,
    output reg [4:0] EX_rs2,
    output reg [4:0] EX_rd,
    output reg [31:0] EX_pc,
    output reg [31:0] EX_pc_plus_4,
    output reg [31:0] EX_I_addr,
    output reg EX_jal,
    output reg EX_jalr,
    output reg [2:0] EX_branch_type,
    output reg EX_branch_predict,
    output reg [31:0] EX_inst,
    output reg EX_ecall,
    output reg EX_mret,
    output reg [11:0] EX_csr_addr,
    output reg [2:0]  EX_csr_op,
    output reg [31:0] EX_csr_r_data,
    output reg [31:0] EX_mtvec,
    output reg [31:0] EX_mepc,
    output reg [31:0] EX_mboot,
    output reg EX_calc_slow,
    output reg EX_reset

    );

    always @(posedge clk) begin
        if (reset) begin
            EX_alu_op_sel <= 4'h0;
            EX_alu_src1_sel <= 1'b0;
            EX_alu_src2_sel <= 1'b0;
            EX_reg_w_en <= 1'b0;
            EX_reg_w_data_sel <= 3'h0;
            EX_store_width <= 2'h3;
            EX_load_width <= 3'h3;
            EX_load_un <= 1'b0;
            EX_imm <= 32'h0;
            EX_br_un <= 1'b0;
            EX_rs1_data <= 32'h0;
            EX_rs2_data <= 32'h0;
            EX_rs1 <= 5'h0;
            EX_rs2 <= 5'h0;
            EX_rd <= 5'h0;
            `ifdef SIMULATION
                `ifdef LOAD_AT_0X200
                    EX_pc <= 32'h200;
                `else
                    EX_pc <= 32'h0;
                `endif
            `else
                EX_pc <= 32'h0;
            `endif
            EX_pc_plus_4 <= 32'h0;
            EX_jal <= 1'b0;
            EX_jalr <= 1'b0;
            EX_branch_type <= `NO_BRANCH;
            EX_I_addr <= 32'h0;
            EX_branch_predict <= 1'b0;
            EX_inst <= `NOP;
            EX_ecall <= 1'b0;
            EX_mret <= 1'b0;
            EX_csr_addr <= 12'h0;
            EX_csr_op <= 3'h0;
            EX_csr_r_data <= 32'h0;
            EX_mtvec <= 32'h0;
            EX_mepc <= 32'h0;
            EX_calc_slow <= 1'b0;
        end else begin
            EX_alu_op_sel <= ID_alu_op_sel;
            EX_alu_src1_sel <= ID_alu_src1_sel;
            EX_alu_src2_sel <= ID_alu_src2_sel;
            EX_reg_w_en <= ID_reg_w_en;
            EX_reg_w_data_sel <= ID_reg_w_data_sel;
            EX_store_width <= ID_store_width;
            EX_load_width <= ID_load_width;
            EX_load_un <= ID_load_un;
            EX_imm <= ID_imm;
            EX_br_un <= ID_br_un;
            EX_rs1_data <= ID_rs1_data;
            EX_rs2_data <= ID_rs2_data;
            EX_rs1 <= ID_rs1;
            EX_rs2 <= ID_rs2;
            EX_rd <= ID_rd;
            EX_pc <= ID_pc;
            EX_pc_plus_4 <= ID_pc_plus_4;
            EX_I_addr <= ID_I_addr;
            EX_jal <= ID_jal;
            EX_jalr <= ID_jalr;
            EX_branch_type <= ID_branch_type;
            EX_branch_predict <= ID_branch_predict;
            EX_inst <= ID_inst;
            EX_ecall <= ID_ecall;
            EX_mret <= ID_mret;
            EX_csr_addr <= ID_csr_addr;
            EX_csr_op <= ID_csr_op;
            EX_csr_r_data <= ID_csr_r_data;
            EX_mtvec <= ID_mtvec;
            EX_mepc <= ID_mepc;
            EX_calc_slow <= ID_calc_slow;
        end
        EX_mboot <= ID_mboot;
        EX_reset <= reset | ID_reset;
    end
endmodule
