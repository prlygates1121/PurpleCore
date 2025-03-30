`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2025 11:22:14 PM
// Design Name: 
// Module Name: MEM
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


module MEM(
    input [31:0] EX_alu_result,
    input EX_reg_w_en,
    input [1:0] EX_reg_w_data_sel,
    input [1:0] EX_store_width,
    input [1:0] EX_load_width,
    input EX_load_un,
    input [31:0] EX_pc_plus_4,
    input [4:0] EX_rd,
    input [31:0] EX_rs2_data,

    // interface with data memory
    output [31:0] D_addr,
    output [31:0] D_store_data,
    output [1:0] D_store_width,
    output [1:0] D_load_width,
    output D_load_un,
    input [31:0] D_load_data,

    output MEM_reg_w_en,
    output [1:0] MEM_reg_w_data_sel,
    output [31:0] MEM_pc_plus_4,
    output [4:0] MEM_rd,
    output [31:0] MEM_dmem_data,
    output [31:0] MEM_alu_result
    );

    assign D_addr = EX_alu_result;
    assign D_store_data = EX_rs2_data;
    assign D_store_width = EX_store_width;
    assign D_load_width = EX_load_width;
    assign D_load_un = EX_load_un;
    assign MEM_reg_w_en = EX_reg_w_en;
    assign MEM_reg_w_data_sel = EX_reg_w_data_sel;
    assign MEM_pc_plus_4 = EX_pc_plus_4;
    assign MEM_rd = EX_rd;
    assign MEM_dmem_data = D_load_data;
    assign MEM_alu_result = EX_alu_result;
endmodule
