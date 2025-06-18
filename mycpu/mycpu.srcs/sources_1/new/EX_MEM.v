`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2025 11:21:42 PM
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(
    input clk,
    input reset,

    input [31:0] EX_alu_result,
    input [31:0] EX_alu_mul_result,
    input EX_reg_w_en,
    input EX_reg_w_en_mul,
    input [2:0] EX_reg_w_data_sel,
    input [1:0] EX_store_width,
    input [2:0] EX_load_width,
    input EX_load_un,
    input [31:0] EX_pc_plus_4,
    input [4:0] EX_rd,
    input [4:0] EX_rd_mul,
    input [31:0] EX_rs2_data,
    input [11:0] EX_csr_addr,
    input [31:0] EX_csr_w_data,
    input EX_csr_w_en,
    input [31:0] EX_csr_r_data,
    input [31:0] EX_w_mstatus,
    input [31:0] EX_w_mepc,
    input [31:0] EX_w_mcause,

    output reg [31:0] MEM_alu_result,
    output reg [31:0] MEM_alu_mul_result,
    output reg MEM_reg_w_en,
    output reg MEM_reg_w_en_mul,
    output reg [2:0] MEM_reg_w_data_sel,
    output reg [1:0] MEM_store_width,
    output reg [2:0] MEM_load_width,
    output reg MEM_load_un,
    output reg [31:0] MEM_pc_plus_4,
    output reg [4:0] MEM_rd,
    output reg [4:0] MEM_rd_mul,
    output reg [31:0] MEM_rs2_data,
    output reg [11:0] MEM_csr_addr,
    output reg [31:0] MEM_csr_w_data,
    output reg MEM_csr_w_en,
    output reg [31:0] MEM_csr_r_data,
    output reg [31:0] MEM_w_mstatus,
    output reg [31:0] MEM_w_mepc,
    output reg [31:0] MEM_w_mcause
    );

    always @(posedge clk) begin
        if (reset) begin
            MEM_alu_result <= 32'b0;
            MEM_alu_mul_result <= 32'b0;
            MEM_reg_w_en <= 1'b0;
            MEM_reg_w_en_mul <= 1'b0;
            MEM_reg_w_data_sel <= 3'b0;
            MEM_store_width <= 2'h3;
            MEM_load_width <= 3'h3;
            MEM_load_un <= 1'b0;
            MEM_pc_plus_4 <= 32'b0;
            MEM_rd <= 5'b0;
            MEM_rd_mul <= 5'b0;
            MEM_rs2_data <= 32'b0;
            MEM_csr_addr <= 12'h0;
            MEM_csr_w_data <= 32'h0;
            MEM_csr_w_en <= 1'b0;
            MEM_csr_r_data <= 32'h0;
            MEM_w_mstatus <= 32'h0;
            MEM_w_mepc <= 32'h0;
            MEM_w_mcause <= 32'h0;
        end else begin
            MEM_alu_result <= EX_alu_result;
            MEM_alu_mul_result <= EX_alu_mul_result;
            MEM_reg_w_en <= EX_reg_w_en;
            MEM_reg_w_en_mul <= EX_reg_w_en_mul;
            MEM_reg_w_data_sel <= EX_reg_w_data_sel;
            MEM_store_width <= EX_store_width;
            MEM_load_width <= EX_load_width;
            MEM_load_un <= EX_load_un;
            MEM_pc_plus_4 <= EX_pc_plus_4;
            MEM_rd <= EX_rd;
            MEM_rd_mul <= EX_rd_mul;
            MEM_rs2_data <= EX_rs2_data;
            MEM_csr_addr <= EX_csr_addr;
            MEM_csr_w_data <= EX_csr_w_data;
            MEM_csr_w_en <= EX_csr_w_en;
            MEM_csr_r_data <= EX_csr_r_data;
            MEM_w_mstatus <= EX_w_mstatus;
            MEM_w_mepc <= EX_w_mepc;
            MEM_w_mcause <= EX_w_mcause;
        end
    end
endmodule
