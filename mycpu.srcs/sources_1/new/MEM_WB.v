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
    input [1:0] MEM_reg_w_data_sel,
    input [31:0] MEM_pc_plus_4,
    input [4:0] MEM_rd,
    input [31:0] MEM_dmem_data,
    input [31:0] MEM_alu_result,

    output reg WB_reg_w_en,
    output reg [1:0] WB_reg_w_data_sel,
    output reg [31:0] WB_pc_plus_4,
    output reg [4:0] WB_rd,
    output reg [31:0] WB_dmem_data,
    output reg [31:0] WB_alu_result
    );

    always @(posedge clk) begin
        if (reset) begin
            WB_reg_w_en <= 1'b0;
            WB_reg_w_data_sel <= 2'b0;
            WB_pc_plus_4 <= 32'b0;
            WB_rd <= 5'b0;
            WB_dmem_data <= 32'b0;
            WB_alu_result <= 32'b0;
        end else begin
            WB_reg_w_en <= MEM_reg_w_en;
            WB_reg_w_data_sel <= MEM_reg_w_data_sel;
            WB_pc_plus_4 <= MEM_pc_plus_4;
            WB_rd <= MEM_rd;
            WB_dmem_data <= MEM_dmem_data;
            WB_alu_result <= MEM_alu_result;
        end
    end
endmodule
