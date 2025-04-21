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
    input [1:0] ID_reg_w_data_sel,
    input [1:0] ID_store_width,
    input [1:0] ID_load_width,
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
    input ID_jump,
    input [2:0] ID_branch_type,
    input ID_branch_predict,

    output reg [3:0] EX_alu_op_sel,
    output reg EX_alu_src1_sel,
    output reg EX_alu_src2_sel,
    output reg EX_reg_w_en,
    output reg [1:0] EX_reg_w_data_sel,
    output reg [1:0] EX_store_width,
    output reg [1:0] EX_load_width,
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
    output reg EX_jump,
    output reg [2:0] EX_branch_type,
    output reg EX_branch_predict
    );

    always @(posedge clk) begin
        if (reset) begin
            EX_alu_op_sel <= 4'h0;
            EX_alu_src1_sel <= 1'b0;
            EX_alu_src2_sel <= 1'b0;
            EX_reg_w_en <= 1'b0;
            EX_reg_w_data_sel <= 2'h0;
            EX_store_width <= 2'h3;
            EX_load_width <= 2'h3;
            EX_load_un <= 1'b0;
            EX_imm <= 32'h0;
            EX_br_un <= 1'b0;
            EX_rs1_data <= 32'h0;
            EX_rs2_data <= 32'h0;
            EX_rs1 <= 5'h0;
            EX_rs2 <= 5'h0;
            EX_rd <= 5'h0;
            EX_pc <= 32'h0;
            EX_pc_plus_4 <= 32'h0;
            EX_jump <= 1'b0;
            EX_branch_type <= `NO_BRANCH;
            EX_I_addr <= 32'h0;
            EX_branch_predict <= 1'b0;
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
            EX_jump <= ID_jump;
            EX_branch_type <= ID_branch_type;
            EX_branch_predict <= ID_branch_predict;
        end
    end
endmodule
