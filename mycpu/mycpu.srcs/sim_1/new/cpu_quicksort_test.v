`timescale 1ns / 1ps
`include "../../sources_1/new/params.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2025 10:41:50 PM
// Design Name: 
// Module Name: cpu_quicksort_test
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


module cpu_quicksort_test(

    );
    parameter CLK_100_PERIOD = 10;
    parameter CLK_100_FREQ = 100_000_000;
    parameter CLK_MAIN_PERIOD = 40;

    reg clk_100, reset_n;
    reg [7:0] sws_l, sws_r;
    reg [4:0] bts_state;

    top top0(
        .clk_100(clk_100),
        .reset_n(reset_n),
        .sws_l(sws_l),
        .sws_r(sws_r),
        .bts(bts_state)
    );

    integer i;

    initial begin
        clk_100 = 1'b0;
        forever #(CLK_100_PERIOD/2) clk_100 = ~clk_100;
    end

    initial begin
        sws_l = 8'd0;
        sws_r = 8'd0;
        bts_state = 5'b00000;
        reset_n = 1'b0;
        #(CLK_100_PERIOD * 2);
        reset_n = 1'b1;
        #(CLK_100_PERIOD * 2000);
        sws_r = 8'd1;
        #(CLK_MAIN_PERIOD * 30);
        sws_l = 8'd4;
        #(CLK_MAIN_PERIOD * 30);
        bts_state = 5'b10000;
        #(CLK_MAIN_PERIOD * 30);
        bts_state = 5'b00000;
        #(CLK_MAIN_PERIOD * 30);
        sws_r = 8'd2;
        #(CLK_MAIN_PERIOD * 30);
        sws_l = 8'd4;
        #(CLK_MAIN_PERIOD * 30);
        bts_state = 5'b10000;
        #(CLK_MAIN_PERIOD * 30);
        bts_state = 5'b00000;
        #(CLK_MAIN_PERIOD * 30);
        sws_r = 8'd3;
        #(CLK_MAIN_PERIOD * 30);
        bts_state = 5'b10000;
        #(CLK_MAIN_PERIOD * 30);
        bts_state = 5'b00000;
    end

    always @(posedge top0.clk_25) begin
        if (top0.core_0.pc == 32'h0000A000) begin
            $finish;
        end
    end


endmodule

