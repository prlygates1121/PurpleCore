`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2025 11:22:06 PM
// Design Name: 
// Module Name: vga_control
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


module vga_control(
    input clk_pixel,
    input reset,
    output reg [9:0] x,
    output reg [9:0] y,
    output h_sync,
    output v_sync,
    output data_en
    );

    // Timing configurations

    // Horizontal
    // Active:          0 --------- 639 (640)
    // Front Porch:     640 ------- 655 (16)
    // Sync:            656 ------- 751 (96)
    // Back Porch:      752 ------- 799 (48)
    parameter H_ACTIVE_END  = 639;
    parameter H_SYNC_START  = H_ACTIVE_END + 17;
    parameter H_SYNC_END    = H_SYNC_START + 95;
    parameter H_END         = 799;

    // Vertical
    parameter V_ACTIVE_END  = 479;
    parameter V_SYNC_START  = V_ACTIVE_END + 11;
    parameter V_SYNC_END    = V_SYNC_START + 1;
    parameter V_END         = 524;

    assign h_sync   = ~(x >= H_SYNC_START & x <= H_SYNC_END);
    assign v_sync   = ~(y >= V_SYNC_START & y <= V_SYNC_END);
    assign data_en  = x <= H_ACTIVE_END & y <= V_ACTIVE_END;

    // Update cursor coordinate
    always @(posedge clk_pixel or posedge reset) begin
        if (reset) begin
            x <= 0;
            y <= 0;
        end else if (x == H_END) begin
            x <= 0;
            y <= y == V_END ? 0 : y + 1;
        end else begin
            x <= x + 1;
        end
    end


endmodule
