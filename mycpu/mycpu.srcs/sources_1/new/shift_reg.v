`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/18/2025 11:57:21 PM
// Design Name: 
// Module Name: shift_reg
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


module shift_reg #(
    parameter BIT_WIDTH = 32,
    parameter DEPTH = 8
)(
    input                   clk,
    input                   reset,
    input [BIT_WIDTH-1:0]   data_in,
    output [BIT_WIDTH-1:0]  data_out
);
    reg [BIT_WIDTH-1:0] shift_reg [DEPTH-1:0];

    integer i;
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                shift_reg[i] <= 0;
            end
        end else begin
            for (i = 0; i < DEPTH - 1; i = i + 1) begin
                shift_reg[i] <= shift_reg[i + 1];
            end
            shift_reg[DEPTH - 1] <= data_in;
        end
    end

    assign data_out = shift_reg[0];
endmodule
