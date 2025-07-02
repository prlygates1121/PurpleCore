`timescale 1ns / 1ps
`include "params.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2025 04:52:08 PM
// Design Name: 
// Module Name: imm_gen
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


module imm_gen(
    input [31:7]    imm_raw,
    input [2:0]     imm_sel,
    output [31:0]   imm
    );

    reg [31:0] imm_reg;

    always @(*) begin
        case (imm_sel) 
            `IMM_I: begin
                imm_reg[11:0]   = imm_raw[31:20];
                imm_reg[31:12]  = {20{imm_raw[31]}};
            end
            `IMM_I_SHIFT: begin
                imm_reg[4:0]    = imm_raw[24:20];
                imm_reg[31:5]   = 27'b0;
            end
            `IMM_S: begin
                imm_reg[11:5]   = imm_raw[31:25];
                imm_reg[4:0]    = imm_raw[11:7];
                imm_reg[31:12]  = {20{imm_raw[31]}};
            end
            `IMM_B: begin
                imm_reg[0]      = 1'b0;
                imm_reg[4:1]    = imm_raw[11:8];
                imm_reg[10:5]   = imm_raw[30:25];
                imm_reg[11]     = imm_raw[7];
                imm_reg[12]     = imm_raw[31];
                imm_reg[31:13]  = {19{imm_raw[31]}};
            end
            `IMM_U: begin
                imm_reg[11:0]   = 12'b0;
                imm_reg[31:12]  = imm_raw[31:12];
            end
            `IMM_J: begin
                imm_reg[0]      = 1'b0;
                imm_reg[10:1]   = imm_raw[30:21];
                imm_reg[11]     = imm_raw[20];
                imm_reg[19:12]  = imm_raw[19:12];
                imm_reg[20]     = imm_raw[31];
                imm_reg[31:21]  = {11{imm_raw[31]}};
            end
            default:
                imm_reg         = 32'b0;
        endcase
    end

    assign imm = imm_reg;
endmodule
