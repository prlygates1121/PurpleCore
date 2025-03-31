`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2025 11:27:53 PM
// Design Name: 
// Module Name: vga_data
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


module vga_data(
    input clk_pixel,
    input reset,
    input [9:0] x,
    input [9:0] y,
    input data_en,
    output reg [3:0] r,
    output reg [3:0] g,
    output reg [3:0] b
    );

    always @(posedge clk_pixel or posedge reset) begin
        if (reset) begin
            r <= 0;
            g <= 0;
            b <= 0;
        end else if (~data_en) begin
            r <= 0;
            g <= 0;
            b <= 0;
        end else begin
            if (y >= 240) begin
                r <= 4'hf;
                g <= 4'hd;
                b <= 0;
            end else begin
                r <= 0;
                g <= 4'h5;
                b <= 4'hb;
            end
        end
    end

endmodule
