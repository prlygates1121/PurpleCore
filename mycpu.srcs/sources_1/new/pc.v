`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2025 04:36:50 PM
// Design Name: 
// Module Name: pc
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


module pc(
    input clk,
    input reset,
    input pc_sel,
    input [31:0] alu_result,
    output [31:0] pc_current
    );

    reg [31:0] pc;

    wire [31:0] pc_next = pc_sel ? (alu_result + 4) : (pc + 4);

    always @(posedge clk) begin
        if (reset) begin
            pc <= 32'h0;
        end else begin
            pc <= pc_next;
        end
    end

    assign pc_current = pc;
endmodule
