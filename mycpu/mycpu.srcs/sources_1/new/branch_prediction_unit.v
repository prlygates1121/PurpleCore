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
    input [31:0] EX_pc,
    input [31:0] EX_branch_target,
    input EX_is_branch_inst,
    input EX_branch_taken,

    output branch_predict,
    output [31:0] branch_target,
    output branch_target_update
    );

    reg [1:0] prediction_table [127:0];
    reg [31:0] branch_target_table [127:0];
    integer i;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 128; i = i + 1) begin
                prediction_table[i] <= 2'b01;
            end
        end else begin
            if (EX_is_branch_inst) begin
                if (EX_branch_taken) begin
                    if (prediction_table[EX_pc[7:1]] != 2'b11) begin
                        prediction_table[EX_pc[7:1]] <= prediction_table[EX_pc[7:1]] + 1;
                    end
                end else begin
                    if (prediction_table[EX_pc[7:1]] != 2'b00) begin
                        prediction_table[EX_pc[7:1]] <= prediction_table[EX_pc[7:1]] - 1;
                    end
                end
            end else begin
                if (prediction_table[EX_pc[7:1]] != 2'b00) begin
                    prediction_table[EX_pc[7:1]] <= prediction_table[EX_pc[7:1]] - 1;
                end
            end
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 128; i = i + 1) begin
                branch_target_table[i] <= 32'b00;
            end
        end else if (EX_is_branch_inst) begin
            branch_target_table[EX_pc[7:1]] <= EX_branch_target;
        end
    end

    assign branch_predict = prediction_table[IF_pc[7:1]] >= 2'b10;
    assign branch_target = branch_target_table[IF_pc[7:1]];
    assign branch_target_update = EX_is_branch_inst & (branch_target_table[EX_pc[7:1]] != EX_branch_target);
endmodule
