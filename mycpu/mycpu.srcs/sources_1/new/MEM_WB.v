`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2025 11:21:57 PM
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(
    input clk,
    input reset,

    input MEM_reg_w_en,
    input MEM_reg_w_en_mul,
    input [2:0] MEM_reg_w_data_sel,
    input [31:0] MEM_pc_plus_4,
    input [4:0] MEM_rd,
    input [4:0] MEM_rd_mul,
    input [31:0] MEM_dmem_data,
    input [31:0] MEM_alu_result,
    input [31:0] MEM_alu_mul_result,
    input [11:0] MEM_csr_addr,
    input [31:0] MEM_csr_w_data,
    input MEM_csr_w_en,
    input [31:0] MEM_csr_r_data,
    input [31:0] MEM_w_mstatus,
    input [31:0] MEM_w_mepc,
    input [31:0] MEM_w_mcause,

    output reg WB_reg_w_en,
    output reg WB_reg_w_en_mul,
    output reg [2:0] WB_reg_w_data_sel,
    output reg [31:0] WB_pc_plus_4,
    output reg [4:0] WB_rd,
    output reg [4:0] WB_rd_mul,
    output reg [31:0] WB_dmem_data,
    output reg [31:0] WB_alu_result,
    output reg [31:0] WB_alu_mul_result,
    output reg [11:0] WB_csr_addr,
    output reg [31:0] WB_csr_w_data,
    output reg WB_csr_w_en,
    output reg [31:0] WB_csr_r_data,
    output reg [31:0] WB_w_mstatus,
    output reg [31:0] WB_w_mepc,
    output reg [31:0] WB_w_mcause
    );

    always @(posedge clk) begin
        if (reset) begin
            WB_reg_w_en <= 1'b0;
            WB_reg_w_en_mul <= 1'b0;
            WB_reg_w_data_sel <= 3'b0;
            WB_pc_plus_4 <= 32'b0;
            WB_rd <= 5'b0;
            WB_rd_mul <= 5'b0;
            WB_dmem_data <= 32'b0;
            WB_alu_result <= 32'b0;
            WB_alu_mul_result <= 32'b0;
            WB_csr_addr <= 12'h0;
            WB_csr_w_data <= 32'h0;
            WB_csr_w_en <= 1'b0;
            WB_csr_r_data <= 32'h0;
            WB_w_mstatus <= 32'h0;
            WB_w_mepc <= 32'h0;
            WB_w_mcause <= 32'h0;
        end else begin
            WB_reg_w_en <= MEM_reg_w_en;
            WB_reg_w_en_mul <= MEM_reg_w_en_mul;
            WB_reg_w_data_sel <= MEM_reg_w_data_sel;
            WB_pc_plus_4 <= MEM_pc_plus_4;
            WB_rd <= MEM_rd;
            WB_rd_mul <= MEM_rd_mul;
            WB_dmem_data <= MEM_dmem_data;
            WB_alu_result <= MEM_alu_result;
            WB_alu_mul_result <= MEM_alu_mul_result;
            WB_csr_addr <= MEM_csr_addr;
            WB_csr_w_data <= MEM_csr_w_data;
            WB_csr_w_en <= MEM_csr_w_en;
            WB_csr_r_data <= MEM_csr_r_data;
            WB_w_mstatus <= MEM_w_mstatus;
            WB_w_mepc <= MEM_w_mepc;
            WB_w_mcause <= MEM_w_mcause;
        end
    end
endmodule
