`timescale 1ns / 1ps
`include "params.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2025 11:28:57 AM
// Design Name: 
// Module Name: ring
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


module ring #(
    parameter BIT_WIDTH = 32,
    parameter DEPTH = 8
)(
    input clk,
    input reset,
    input [1:0] op,
    input [BIT_WIDTH-1:0] data_in,
    output [BIT_WIDTH-1:0] data_out
);

    reg [BIT_WIDTH-1:0] ring_buffer [DEPTH-1:0];
    reg [31:0] ring_pointer;
    wire [31:0] ring_pointer_top;

    integer i = 0;
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                ring_buffer[i] <= 32'h0;
            end
            ring_pointer <= 32'h0;
        end else begin
            case (op)
                `RING_PUSH: begin
                    ring_buffer[ring_pointer] <= data_in;
                    if (ring_pointer == DEPTH - 1) begin
                        ring_pointer <= 32'h0;
                    end else begin
                        ring_pointer <= ring_pointer + 1;
                    end
                end
                `RING_POP: begin
                    if (ring_pointer == 32'h0) begin
                        ring_pointer <= DEPTH - 1;
                    end else begin
                        ring_pointer <= ring_pointer - 1;
                    end
                end
                `RING_POP_AND_PUSH: begin
                    ring_buffer[ring_pointer_top] <= data_in;
                end
                default: begin
                    // No operation
                end
            endcase
        end
    end
    assign ring_pointer_top = ring_pointer == 32'h0 ? DEPTH - 1 : ring_pointer - 1;
    assign data_out = ring_buffer[ring_pointer_top];
endmodule
