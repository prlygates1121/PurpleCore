`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2025 09:56:07 PM
// Design Name: 
// Module Name: memory_tb
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


module memory_tb(
    );
    parameter PERIOD = 10;

    reg clk, ena, wea, enb, web;
    reg [31:0] addra, dina, addrb, dinb;
    wire [31:0] douta, doutb;

    memory mem_test(
        .clk(clk),
        .ena(ena),
        .wea(wea),
        .addra(addra),
        .dina(dina),
        .douta(douta),
        .enb(enb),
        .web(web),
        .addrb(addrb),
        .dinb(dinb),
        .doutb(doutb)
    );

    initial begin
        clk = 1'b0;
        forever #(PERIOD/2) clk = ~clk;
    end

    initial begin
        ena = 1'b0;
        enb = 1'b0;
        wea = 1'b0;
        web = 1'b0;
        #(PERIOD * 2);
        ena = 1'b1;
        enb = 1'b1;

        wea = 1'b1;
        web = 1'b1;

        addra = 32'habc;
        dina = 32'habcdef12;

        addrb = 32'hcba;
        dinb = 32'hDEAFFACE;
        #(PERIOD * 3);
        wea = 1'b0;
        web = 1'b0;

        addrb = 32'hcba;
        addra = 32'habc;

        #(PERIOD * 2);
        $finish;
    end


endmodule
