`timescale 1ns / 1ps
`include "params.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2025 11:03:31 PM
// Design Name: 
// Module Name: seg_display_handler
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


module seg_display_handler(
    input clk,
    input reset,
    input [31:0] hex_digits,
    output [7:0] tube_ena,
    output [7:0] left_tube_content,
    output [7:0] right_tube_content
    );

    parameter TUBE_FREQ = 32'd500;
    parameter COUNTER_MAX = `CLK_MAIN_FREQ / TUBE_FREQ;

    reg [31:0] counter;
    always @(posedge clk) begin
        if (reset) begin
            counter <= 32'd0;
        end else if (counter == COUNTER_MAX - 1) begin
            counter <= 32'd0;
        end else begin
            counter <= counter + 1;
        end
    end
    wire display_ena = counter == COUNTER_MAX - 1;

    seg_display seg_display_0(
        .clk                    (clk),
        .reset                  (reset),
        .display_ena            (display_ena),
        .hex_digits             (hex_digits),
        .tube_ena               (tube_ena),
        .left_tube_content      (left_tube_content),
        .right_tube_content     (right_tube_content)
    );


endmodule
