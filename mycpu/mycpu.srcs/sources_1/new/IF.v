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
    
    input pc_sel,

    input [31:0] alu_result,

    output reg [31:0] pc,
    output reg [31:0] pc_prev_1,
    output reg [31:0] pc_prev_2
    );

    wire [31:0] pc_next = pc_sel ? (alu_result) : (pc + 4);

    always @(posedge clk) begin
        if (reset) begin
            pc <= 32'h0;
        end else begin
            pc <= pc_next;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            pc_prev_1 <= 32'b0;
        end else begin
            pc_prev_1 <= pc;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            pc_prev_2 <= 32'b0;
        end else begin
            pc_prev_2 <= pc_prev_1;
        end
    end

endmodule
