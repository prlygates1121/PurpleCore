`timescale 1ns / 1ps
`include "params.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2025 09:12:12 PM
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(
    input clk,
    input reset,
    input [31:0] IF_pc_prev_2,
    input [31:0] IF_pc_prev_2_plus_4,
    input [31:0] IF_inst,
    input [31:0] IF_I_addr_prev_2,

    output reg [31:0] ID_pc_prev_2,
    output reg [31:0] ID_pc_prev_2_plus_4,
    output reg [31:0] ID_inst,
    output reg [31:0] ID_I_addr_prev_2
    );

    always @(posedge clk) begin
        if (reset) begin
            ID_pc_prev_2 <= 32'b0;
            ID_pc_prev_2_plus_4 <= 32'b0;
            ID_inst <= `NOP;
            ID_I_addr_prev_2 <= 32'b0;
        end else begin
            ID_pc_prev_2 <= IF_pc_prev_2;
            ID_pc_prev_2_plus_4 <= IF_pc_prev_2_plus_4;
            ID_inst <= IF_inst;
            ID_I_addr_prev_2 <= IF_I_addr_prev_2;
        end
    end
    
endmodule
