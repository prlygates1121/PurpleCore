`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2025 07:48:37 PM
// Design Name: 
// Module Name: vga_top
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


module vga_top(
    input clk,
    input reset,
    output [3:0] r,
    output [3:0] g,
    output [3:0] b,
    output h_sync,
    output v_sync
    );

    wire clk_pixel; // Pixel clock: 25.20325 MHz ~= 800 * 525 * 60
    clk_pixel_gen clk_gen(
        .clk_system(clk),
        .reset(reset),
        .clk_pixel(clk_pixel)
    );

    wire [9:0] x;
    wire [9:0] y;
    wire data_en;
    vga_control ctrl(
        .clk_pixel(clk_pixel),
        .reset(reset),
        .x(x),
        .y(y),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .data_en(data_en)
    );

    vga_data data(
        .clk_pixel(clk_pixel),
        .reset(reset),
        .x(x),
        .y(y),
        .data_en(data_en),
        .r(r),
        .g(g),
        .b(b)
    );


endmodule
