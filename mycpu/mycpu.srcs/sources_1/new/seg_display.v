`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2025 10:39:59 PM
// Design Name: 
// Module Name: seg_display
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

module seg_display(
    input clk,
    input reset,
    input display_ena,
    input [31:0] hex_digits,
    output reg [7:0] tube_ena,
    output reg [7:0] left_tube_content,
    output reg [7:0] right_tube_content
    );

    reg [63:0] tube_content;
    integer i;
    always @(*) begin
        for (i = 0; i < 8; i = i + 1) begin
            tube_content[i*8 +: 8] = 
                hex_digits[i*4 +: 4] == 4'b0000 ? 8'b1111_1100 :    // "0"
                hex_digits[i*4 +: 4] == 4'b0001 ? 8'b0110_0000 :    // "1"
                hex_digits[i*4 +: 4] == 4'b0010 ? 8'b1101_1010 :    // "2"
                hex_digits[i*4 +: 4] == 4'b0011 ? 8'b1111_0010 :    // "3"
                hex_digits[i*4 +: 4] == 4'b0100 ? 8'b0110_0110 :    // "4"
                hex_digits[i*4 +: 4] == 4'b0101 ? 8'b1011_0110 :    // "5"
                hex_digits[i*4 +: 4] == 4'b0110 ? 8'b1011_1110 :    // "6"
                hex_digits[i*4 +: 4] == 4'b0111 ? 8'b1110_0000 :    // "7"
                hex_digits[i*4 +: 4] == 4'b1000 ? 8'b1111_1110 :    // "8"
                hex_digits[i*4 +: 4] == 4'b1001 ? 8'b1110_0110 :    // "9"
                hex_digits[i*4 +: 4] == 4'b1010 ? 8'b1110_1110 :    // "A"
                hex_digits[i*4 +: 4] == 4'b1011 ? 8'b0011_1110 :    // "B"
                hex_digits[i*4 +: 4] == 4'b1100 ? 8'b1001_1100 :    // "C"
                hex_digits[i*4 +: 4] == 4'b1101 ? 8'b0111_1010 :    // "D"
                hex_digits[i*4 +: 4] == 4'b1110 ? 8'b1001_1110 :    // "E"
                hex_digits[i*4 +: 4] == 4'b1111 ? 8'b1000_1110 :    // "F"
                8'b1001_1110;                                       // "E" by default
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            tube_ena <= 8'b0001_0001;
            left_tube_content <= 8'b1111_1111;
            right_tube_content <= 8'b1111_1111;
        end else if (display_ena) begin
            case (tube_ena)
                8'b0001_0001: begin
                    left_tube_content <= tube_content[47:40];
                    right_tube_content <= tube_content[15:8];
                    tube_ena <= 8'b0010_0010;
                end
                8'b0010_0010: begin
                    left_tube_content <= tube_content[55:48];
                    right_tube_content <= tube_content[23:16];
                    tube_ena <= 8'b0100_0100;
                end
                8'b0100_0100: begin
                    left_tube_content <= tube_content[63:56];
                    right_tube_content <= tube_content[31:24];
                    tube_ena <= 8'b1000_1000;
                end
                8'b1000_1000: begin
                    left_tube_content <= tube_content[39:32];
                    right_tube_content <= tube_content[7:0];
                    tube_ena <= 8'b0001_0001;
                end
                // by default, display "E" on both tubes
                default: begin
                    left_tube_content <= 8'b1001_1110;
                    right_tube_content <= 8'b1001_1110;
                    tube_ena <= 8'b0001_0001;
                end
            endcase
        end
    end

endmodule