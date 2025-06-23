`timescale 1ns / 1ps
`include "params.v"
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


module IF (
    input clk,
    input reset,
    input stall,
    input inst_access_fault,

    input [31:0] EX_trap_dest,
    
    input EX_excp,
    input EX_mret,
    input EX_pc_sel,
    input EX_false_direction,
    input EX_false_target,
    input [31:0] EX_alu_result,
    input [31:0] EX_pc_plus_4,
    input EX_branch_predict,

    // interface with memory
    output [31:0] I_addr,       // address to read from memory
    input [31:0] I_load_data,   // data read from memory

    output [31:0] IF_pc,
    output [31:0] IF_pc_plus_4,
    output [31:0] IF_inst,

    input branch_predict,
    input [31:0] branch_target

    );

    reg [31:0] pc;

`ifdef BRANCH_PREDICT_ENA
    wire [31:0] pc_next = (EX_excp | EX_mret) ? EX_trap_dest :
                          EX_false_target ? (EX_pc_sel ? EX_alu_result : EX_pc_plus_4) : 
                          EX_false_direction ? (EX_branch_predict ? EX_pc_plus_4 : EX_alu_result) :
                          stall ? pc :
                          branch_predict ? branch_target :
                          (pc + 4);
`else 
    wire [31:0] pc_next = (EX_excp | EX_mret) ? EX_trap_dest : EX_pc_sel ? EX_alu_result : stall ? pc : (pc + 4);
`endif

    always @(posedge clk) begin
        if (reset) begin
            `ifdef SIMULATION
                `ifdef LOAD_AT_0X200
                    pc <= 32'h200;
                `else
                    pc <= 32'h0;
                `endif
            `else
                pc <= 32'h0;
            `endif
        end else if (inst_access_fault) begin
            pc <= pc_next;
        end else if (~stall) begin
            pc <= pc_next;
        end
    end

    assign IF_pc = pc;
    assign IF_pc_plus_4 = pc + 4;
    assign IF_inst = (reset) ? `NOP : I_load_data;
    assign I_addr = reset ? pc : pc_next;
endmodule
