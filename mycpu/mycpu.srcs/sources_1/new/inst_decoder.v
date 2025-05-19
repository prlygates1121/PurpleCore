`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2025 04:31:51 PM
// Design Name: 
// Module Name: inst_decoder
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


module inst_decoder(
    input [31:0] inst,
    output [6:0] opcode,
    output [6:0] funct7,
    output [2:0] funct3,
    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd,
    output [24:0] imm
    );

    assign opcode = inst[6:0];
    assign funct3 = inst[14:12];
    assign funct7 = inst[31:25];
    assign rs1 = inst[19:15];
    assign rs2 = inst[24:20];
    assign rd = inst[11:7];
    assign imm = inst[31:7];
endmodule
