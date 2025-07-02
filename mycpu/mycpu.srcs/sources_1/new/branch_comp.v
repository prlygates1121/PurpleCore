`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2025 04:52:34 PM
// Design Name: 
// Module Name: branch_comp
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


module branch_comp(
    input [31:0]    rs1_data,
    input [31:0]    rs2_data,
    input           br_un,
    output          br_eq,
    output          br_lt
    );
    assign br_eq = rs1_data == rs2_data;
    assign br_lt = br_un ? (rs1_data < rs2_data) : ($signed(rs1_data) < $signed(rs2_data));
endmodule
