`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/19/2025 01:30:34 AM
// Design Name: 
// Module Name: bram_tb
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


module bram_tb(

    );

    parameter CLK_25_PERIOD = 40;

    reg clk_25, reset;
    reg [31:0] pc;
    reg [3:0] wea;
    reg [31:0] dina;
    wire [31:0] inst;
 
    memory memory_0(
        .clk(clk_25),
        .reset(reset),

        .ena(1'b1),
        .wea(wea),
        .addra(pc),
        .dina(dina),

        .enb(1'b0),

        .douta(inst)
    );

    initial begin
        clk_25 = 1'b0;
        forever #(CLK_25_PERIOD/2) clk_25 = ~clk_25;
    end

    initial begin
        reset = 1'b1;
        #(CLK_25_PERIOD)
        reset = 1'b0;

        pc = 32'b0;
        dina = 32'h12345678;
        wea = 4'b1111;
        #(CLK_25_PERIOD);

        pc = pc + 4;
        dina = 32'hDEADBEEF;
        #(CLK_25_PERIOD);

        pc = pc + 4;
        dina = 32'hBABEDEAF;
        #(CLK_25_PERIOD);

        wea = 4'b0;
        pc = 32'b0;
        #(CLK_25_PERIOD);

        pc = pc + 4;
        #(CLK_25_PERIOD);

        pc = pc + 4;
        #(CLK_25_PERIOD);

        #(CLK_25_PERIOD);

        $finish;
    end

endmodule
