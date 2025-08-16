`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/05/2025 12:31:02 AM
// Design Name: 
// Module Name: rd_queue
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


module rd_queue #(
    parameter SIZE = 4
)(
    input                   clk,
    input                   reset,
    input                   stall,
    input [SIZE-2:0]        flush_sel,
    input [4:0]             rd_in,
    output reg [SIZE*5-1:0] rd_queue
);
    integer i;
    always @(posedge clk) begin
        if (reset) begin
            rd_queue <= 0;
        end else begin
            rd_queue[(SIZE-1)*5+:5] <= stall ? 5'b0 : rd_in;
            for (i = 0; i <= SIZE-2; i = i + 1) begin
                rd_queue[(SIZE-1-i-1)*5+:5] <= flush_sel[i] ? 5'b0 : rd_queue[(SIZE-1-i)*5+:5];
            end
        end
    end
endmodule
