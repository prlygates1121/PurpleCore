`timescale 1ns / 1ps
`include "../../sources_1/new/params.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2025 06:14:13 PM
// Design Name: 
// Module Name: ring_test
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


module ring_test(
    );
    reg clk;
    reg reset;
    reg [1:0] op;
    reg [31:0] data_in;
    wire [31:0] data_out;

    ring #(
        .BIT_WIDTH(32),
        .DEPTH(8)
    ) uut (
        .clk(clk),
        .reset(reset),
        .op(op),
        .data_in(data_in),
        .data_out(data_out)
    );

    initial begin
        reset = 1;
        op = `RING_NOOP;
        data_in = 32'h0;

        #10 reset = 0;
        #5;

        // Test RING_PUSH
        op = `RING_PUSH;
        data_in = 32'hA5A5A5A5;
        #10;

        // Test RING_POP
        op = `RING_POP;
        #10;

        // push again
        op = `RING_PUSH;
        data_in = 32'hB5B5B5B5;
        #10;

        // Test RING_POP_AND_PUSH
        op = `RING_POP_AND_PUSH;
        data_in = 32'h5A5A5A5A;
        #10;

        $finish;
    end
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Generate clock signal
    end
endmodule
