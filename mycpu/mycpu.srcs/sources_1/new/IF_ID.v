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
    input               clk,
    input               reset,
    input               stall,
    input [31:0]        IF_pc,
    input [31:0]        IF_pc_plus_4,
    input [31:0]        IF_inst,
    input               IF_branch_predict,

    output reg [31:0]   ID_pc,
    output reg [31:0]   ID_pc_plus_4,
    output reg [31:0]   ID_inst,
    output reg          ID_branch_predict,
    output reg          ID_reset
    );

    always @(posedge clk) begin
        if (reset) begin
            `ifdef SIMULATION
                `ifdef LOAD_AT_0X200
                    ID_pc <= 32'h200;
                `else
                    ID_pc <= 32'h0;
                `endif
            `else
                ID_pc <= 32'h0;
            `endif
            ID_pc_plus_4        <= 32'b0;
            ID_inst             <= `NOP;
            ID_branch_predict   <= 1'b0;
        end else if (~stall) begin
            ID_pc               <= IF_pc;
            ID_pc_plus_4        <= IF_pc_plus_4;
            ID_inst             <= IF_inst;
            ID_branch_predict   <= IF_branch_predict;
        end
        ID_reset                <= reset;
    end
    
endmodule
