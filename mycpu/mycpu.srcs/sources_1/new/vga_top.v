`timescale 1ns / 1ps
`include "params.v"
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
    output reg [3:0] r,
    output reg [3:0] g,
    output reg [3:0] b,
    output h_sync,
    output v_sync,
    output reg [31:0] vga_addr,         // used to fetch pixel data from memory
    input [31:0] vga_data               // pixel data from memory
    );

    reg [9:0] x, y;
    wire data_en;

    assign h_sync   = ~((x >= `H_SYNC_START) & (x <= `H_SYNC_END));
    assign v_sync   = ~((y >= `V_SYNC_START) & (y <= `V_SYNC_END));
    assign data_en  = (x <= `H_ACTIVE_END) & (y <= `V_ACTIVE_END);

    // Update cursor coordinate
    always @(posedge clk) begin
        if (reset) begin
            x <= 0;
            y <= 0;
        end else if (x == `H_END) begin
            x <= 0;
            y <= (y == `V_END) ? 0 : (y + 1);
        end else begin
            x <= x + 1;
        end
    end

    // VGA address iteration
    reg [2:0] vga_addr_offset;          // Offset for access to each 4-bit pixel in a word
    always @(posedge clk) begin
        if (reset) begin
            vga_addr <= 32'h8040_0000;  // VGA memory base address
            vga_addr_offset <= 3'b0;
        end else if (data_en) begin
            if (vga_addr_offset == 3'b111) begin
                vga_addr <= (vga_addr == 32'h8042_57FC) ? 32'h8040_0000 : vga_addr + 4; //A002_57FC
                vga_addr_offset <= 3'b0;
            end else begin
                vga_addr_offset <= vga_addr_offset + 1;
            end
        end
    end

    // VGA data decoder
    wire [3:0] vga_data_pixel = vga_addr_offset == 3'b000 ? vga_data[3:0] :
                                vga_addr_offset == 3'b001 ? vga_data[7:4] :
                                vga_addr_offset == 3'b010 ? vga_data[11:8] :
                                vga_addr_offset == 3'b011 ? vga_data[15:12] :
                                vga_addr_offset == 3'b100 ? vga_data[19:16] :
                                vga_addr_offset == 3'b101 ? vga_data[23:20] :
                                vga_addr_offset == 3'b110 ? vga_data[27:24] : vga_data[31:28]; // Default to last pixel
                                
    wire [11:0] vga_data_pixel_decoded = vga_data_pixel == `BLACK_CODE ? `BLACK_VALUE :
                                         vga_data_pixel == `WHITE_CODE ? `WHITE_VALUE :
                                         vga_data_pixel == `RED_CODE ? `RED_VALUE :
                                         vga_data_pixel == `ORANGE_CODE ? `ORANGE_VALUE :
                                         vga_data_pixel == `YELLOW_CODE ? `YELLOW_VALUE :
                                         vga_data_pixel == `LIGHT_GREEN_CODE ? `LIGHT_GREEN_VALUE :
                                         vga_data_pixel == `GREEN_CODE ? `GREEN_VALUE :
                                         vga_data_pixel == `SPRING_GREEN_CODE ? `SPRING_GREEN_VALUE :
                                         vga_data_pixel == `CYAN_CODE ? `CYAN_VALUE :
                                         vga_data_pixel == `SKY_BLUE_CODE ? `SKY_BLUE_VALUE :
                                         vga_data_pixel == `BLUE_CODE ? `BLUE_VALUE :
                                         vga_data_pixel == `PURPLE_CODE ? `PURPLE_VALUE :
                                         vga_data_pixel == `PINK_CODE ? `PINK_VALUE :
                                         vga_data_pixel == `ROSE_CODE ? `ROSE_VALUE : 
                                         vga_data_pixel == `SUPERNOVA_CODE ? `SUPERNOVA_VALUE :
                                         vga_data_pixel == `GRAY_CODE ? `GRAY_VALUE : `BLACK_VALUE; // Default to black if no match

    // VGA data output
    always @(posedge clk) begin
        if (reset) begin
            {r, g, b} <= 12'h0;
        end else if (~data_en) begin
            {r, g, b} <= 12'h0;
        end else begin
            {r, g, b} <= vga_data_pixel_decoded;
        end
    end


endmodule
