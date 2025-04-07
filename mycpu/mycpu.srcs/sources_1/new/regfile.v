`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2025 08:24:22 PM
// Design Name: 
// Module Name: regfile
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


module regfile(
    input clk,
    input reset,
    input write_en,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] dest,
    input  [31:0] write_data,
    output [31:0] rs1_data,
    output [31:0] rs2_data
    );

    reg [31:0] registers [31:0];

    assign rs1_data = registers[rs1];
    assign rs2_data = registers[rs2];

    integer i;

    always @(negedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= i == 2 ? `ADDR_SP_START : 32'h0;
            end
        end else if (write_en & |dest) begin
            registers[dest] <= write_data;
        end
    end
endmodule
