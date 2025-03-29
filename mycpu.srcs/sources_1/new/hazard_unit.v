`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2025 05:31:28 PM
// Design Name: 
// Module Name: hazard_unit
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


module hazard_unit(
    input [4:0] MEM_rd,
    input MEM_reg_w_en,
    input [31:0] MEM_alu_result,
    input [4:0] WB_rd,
    input WB_reg_w_en,
    input [31:0] WB_alu_result,

    input [4:0] EX_rs1,
    input [4:0] EX_rs2,

    output [31:0] MEM_alu_result_forwarded,
    output [31:0] WB_alu_result_forwarded,
    output [1:0] forward_rs1_sel,
    output [1:0] forward_rs2_sel

    );

    assign MEM_alu_result_forwarded = MEM_alu_result;
    assign WB_alu_result_forwarded = WB_alu_result;
    assign forward_rs1_sel = (MEM_reg_w_en & (MEM_rd != 5'b0) & (MEM_rd == EX_rs1)) ? 2'b01 :
                             (WB_reg_w_en & (MEM_rd != 5'b0) & (WB_rd == EX_rs1)) ? 2'b10 : 2'b00;
    assign forward_rs2_sel = (MEM_reg_w_en & (MEM_rd != 5'b0) & (MEM_rd == EX_rs2)) ? 2'b01 :
                             (WB_reg_w_en & (MEM_rd != 5'b0) & (WB_rd == EX_rs2)) ? 2'b10 : 2'b00;


endmodule
