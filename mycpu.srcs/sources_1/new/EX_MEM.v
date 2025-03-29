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
    input EX_reg_w_en,
    input [1:0] EX_reg_w_data_sel,
    input [1:0] EX_store_width,
    input [1:0] EX_load_width,
    input EX_load_un,
    input [31:0] EX_pc_prev_2_plus_4,
    input [4:0] EX_rd,
    input [31:0] EX_rs2_data,

    output reg [31:0] MEM_alu_result,
    output reg MEM_reg_w_en,
    output reg [1:0] MEM_reg_w_data_sel,
    output reg [1:0] MEM_store_width,
    output reg [1:0] MEM_load_width,
    output reg MEM_load_un,
    output reg [31:0] MEM_pc_prev_2_plus_4,
    output reg [4:0] MEM_rd,
    output reg [31:0] MEM_rs2_data
    );

    always @(posedge clk) begin
        if (reset) begin
            MEM_alu_result <= 32'b0;
            MEM_reg_w_en <= 1'b0;
            MEM_reg_w_data_sel <= 2'b0;
            MEM_store_width <= 2'h3;
            MEM_load_width <= 2'h3;
            MEM_load_un <= 1'b0;
            MEM_pc_prev_2_plus_4 <= 32'b0;
            MEM_rd <= 5'b0;
            MEM_rs2_data <= 32'b0;
        end else begin
            MEM_alu_result <= EX_alu_result;
            MEM_reg_w_en <= EX_reg_w_en;
            MEM_reg_w_data_sel <= EX_reg_w_data_sel;
            MEM_store_width <= EX_store_width;
            MEM_load_width <= EX_load_width;
            MEM_load_un <= EX_load_un;
            MEM_pc_prev_2_plus_4 <= EX_pc_prev_2_plus_4;
            MEM_rd <= EX_rd;
            MEM_rs2_data <= EX_rs2_data;
        end
    end
endmodule
