`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2025 11:52:56 PM
// Design Name: 
// Module Name: vga_sim
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


module vga_sim(
    );

    parameter CLK_PERIOD = 10;
    parameter CLK_PIXEL_PERIOD = 40;

    reg clk, reset;
    wire h_sync, v_sync;
    wire [3:0] r;
    wire [3:0] g;
    wire [3:0] b;

    wire locked;
    wire clk_pixel; // Pixel clock: 25.20325 MHz ~= 800 * 525 * 60
    clk_pixel_gen clk_gen(
        .clk_system(clk),
        .reset(reset),
        .locked(locked),
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

    initial begin
        clk = 1'b1;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    initial begin
        reset = 1'b1;
        # (CLK_PERIOD * 5);
        reset = 1'b0;
        # (CLK_PERIOD * 10);
    end

    initial begin
        # (CLK_PIXEL_PERIOD * 10000);
        $finish;
    end

endmodule
