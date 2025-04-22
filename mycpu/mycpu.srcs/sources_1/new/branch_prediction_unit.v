`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2025 10:14:54 PM
// Design Name: 
// Module Name: branch_prediction_unit
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


module branch_prediction_unit(
    input clk,
    input reset,
    
    input [31:0] IF_pc,
    input [31:0] IF_inst,
    input [31:0] ID_ra_data,
    input [31:0] EX_pc,
    input [31:0] EX_branch_target,
    input EX_jal,
    input EX_jalr,
    input [2:0] EX_branch_type,
    input EX_branch_taken,

    output branch_predict,
    output [31:0] branch_target,
    output EX_false_target
    );

    localparam [1:0] STRONG_TAKEN       = 2'b11, 
                     WEAK_TAKEN         = 2'b10,
                     WEAK_NOT_TAKEN     = 2'b01,
                     STRONG_NOT_TAKEN   = 2'b00;

    wire EX_is_branch_inst = EX_jal | EX_jalr | (EX_branch_type != `NO_BRANCH);

    // pre-decode the instruction
    wire [6:0] opcode = IF_inst[6:0];
    wire [2:0] funct3 = IF_inst[14:12];

    wire B      = opcode == 7'b1100011;
    wire J      = opcode == 7'b1101111;
    wire I_jalr = opcode == 7'b1100111 & funct3 == 3'h0;

    reg [1:0] prediction_table [127:0];
    reg [31:0] branch_target_buffer [127:0];
    integer i;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 128; i = i + 1) begin
                prediction_table[i] <= WEAK_NOT_TAKEN;
            end
        end else begin
            if (EX_is_branch_inst) begin
                if (EX_branch_taken) begin
                    if (prediction_table[EX_pc[8:2]] != STRONG_TAKEN) begin
                        prediction_table[EX_pc[8:2]] <= prediction_table[EX_pc[8:2]] + 1;
                    end
                end else begin
                    if (prediction_table[EX_pc[8:2]] != STRONG_NOT_TAKEN) begin
                        prediction_table[EX_pc[8:2]] <= prediction_table[EX_pc[8:2]] - 1;
                    end
                end
            end else begin
                if (prediction_table[EX_pc[8:2]] != STRONG_NOT_TAKEN) begin
                    prediction_table[EX_pc[8:2]] <= prediction_table[EX_pc[8:2]] - 1;
                end
            end
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 128; i = i + 1) begin
                branch_target_buffer[i] <= 32'b00;
            end
        end else if (EX_is_branch_inst) begin
            branch_target_buffer[EX_pc[8:2]] <= EX_branch_target;
        end
    end

    assign branch_predict = (J | I_jalr) ? 1'b1 : B ? (prediction_table[IF_pc[8:2]] >= WEAK_TAKEN) : 1'b0;
    assign branch_target = branch_target_buffer[IF_pc[8:2]];
    assign EX_false_target = EX_is_branch_inst & ((branch_target_buffer[EX_pc[8:2]]) != EX_branch_target);
endmodule
