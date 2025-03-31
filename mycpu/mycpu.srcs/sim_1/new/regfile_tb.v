`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2025 09:14:19 PM
// Design Name: 
// Module Name: regfile_tb
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


module regfile_tb(
    );

    reg clk, reset;
    reg [4:0] rs1, rs2, rd;
    reg reg_w_en;
    reg [31:0] reg_w_data;
    wire [31:0] rs1_data, rs2_data;

    regfile regfile_0(
        .clk(clk),
        .reset(reset),
        .write_en(reg_w_en),
        .rs1(rs1),
        .rs2(rs2),
        .dest(rd),
        .write_data(reg_w_data),

        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        #20 reset = 0;

        // Write to register 1
        reg_w_en = 1;
        rs1 = 1;
        rs2 = 2;
        rd = 1; // Write to register 1
        reg_w_data = 32'h12345678;
        #20;

        // Write to register 2 while reading from register 1
        reg_w_en = 1;
        rs1 = 1;
        rs2 = 2;
        rd = 2; // Write to register 2
        reg_w_data = 32'h87654321;
        #20;

        // Attempt to write to register 0
        reg_w_en = 1;
        rs1 = 1;
        rs2 = 2;
        rd = 0; // Write to register 0
        reg_w_data = 32'habcdef01;
        #20;

        // Read from register 0 and 1
        reg_w_en = 0;
        rs1 = 0;
        rs2 = 1;
        rd = 1;
        reg_w_data = 32'h0;
        #20;

        $finish;
    end
endmodule
