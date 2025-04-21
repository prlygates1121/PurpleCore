`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/19/2025 10:56:50 AM
// Design Name: 
// Module Name: IF
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


module IF(
    input clk,
    input reset,
    input stall,
    
    input EX_pc_sel,
    input EX_mispredict,
    input EX_branch_target_update,
    input [31:0] EX_alu_result,
    input [31:0] EX_pc_plus_4,
    input EX_branch_predict,

    // interface with memory
    output [31:0] I_addr,       // address to read from memory
    input [31:0] I_load_data,   // data read from memory

    output [31:0] IF_pc,
    output [31:0] IF_pc_plus_4,
    output [31:0] IF_inst,
    output [31:0] IF_I_addr,

    input branch_predict,
    input [31:0] branch_target

    );

    reg [31:0] pc;

    wire [31:0] pc_next = EX_branch_target_update ? (EX_pc_sel ? EX_alu_result : EX_pc_plus_4) : 
                          EX_mispredict ? (EX_branch_predict ? EX_pc_plus_4 : EX_alu_result) :
                          branch_predict ? branch_target :
                          (pc + 4);

    always @(posedge clk) begin
        if (reset) begin
            pc <= 32'h0;
        end else if (~stall) begin
            pc <= pc_next;
        end
    end

    assign IF_pc = pc;
    assign IF_pc_plus_4 = pc + 4;
    assign IF_inst = (reset) ? `NOP : I_load_data;
    assign I_addr = pc;
    assign IF_I_addr = I_addr;
endmodule
