`timescale 1ns / 1ps
`include "params.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2025 11:22:20 PM
// Design Name: 
// Module Name: WB
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


module WB(
    input MEM_reg_w_en,
    input [1:0] MEM_reg_w_data_sel,
    input [31:0] MEM_pc_plus_4,
    input [4:0] MEM_rd,
    input [31:0] MEM_dmem_data,
    input [31:0] MEM_alu_result,

    output WB_reg_w_en,
    output [31:0] WB_reg_w_data,
    output [4:0] WB_rd
    );

    assign WB_reg_w_data = MEM_reg_w_data_sel == `REG_W_DATA_ALU ? MEM_alu_result :
                           MEM_reg_w_data_sel == `REG_W_DATA_MEM ? MEM_dmem_data :
                           MEM_reg_w_data_sel == `REG_W_DATA_PC  ? MEM_pc_plus_4 : 32'h0;
    assign WB_reg_w_en = MEM_reg_w_en;
    assign WB_rd = MEM_rd;
endmodule
