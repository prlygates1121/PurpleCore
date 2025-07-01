`timescale 1ns / 1ps
`include "params.v"
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
    `ifdef DEBUG
        output [31:0] t0,
        output [31:0] t1,
        output [31:0] t2,
        output [31:0] t3,
    `endif
    input clk,
    input reset,
    input write_en,
    input write_en_mul,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] dest,
    input [4:0] dest_mul,
    input  [31:0] write_data,
    input  [31:0] write_data_mul,
    output [31:0] rs1_data,
    output [31:0] rs2_data
    );

    reg [31:0] registers [31:0];

    assign rs1_data = registers[rs1];
    assign rs2_data = registers[rs2];

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                if (i == 2) begin
                    // initialize the stack pointer, needed only when there is no startup code (entry.s)
                    registers[i] <= `ADDR_SP_START;
                end else begin
                    registers[i] <= 32'h0;
                end
            end
        end else begin 
            if (write_en & |dest) begin
                registers[dest] <= write_data;
            end
            // mul write is blocked when both write ports write to the same register
            if (write_en_mul & |dest_mul & !(write_en & dest_mul == dest)) begin
                registers[dest_mul] <= write_data_mul;
            end
        end
    end

    `ifdef DEBUG
        assign t0 = registers[5];
        assign t1 = registers[6];
        assign t2 = registers[7];
        assign t3 = registers[28];
    `endif
endmodule
