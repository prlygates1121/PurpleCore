`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2025 01:37:10 PM
// Design Name: 
// Module Name: my_blk_mem
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



module my_blk_mem(
    // Port A
    input clka,                    // Clock for port A
    input ena,                     // Enable for port A
    input [3:0] wea,               // Write enable for port A (byte-wise)
    input [13:0] addra,            // Address for port A
    input [31:0] dina,             // Data input for port A
    output reg [31:0] douta,       // Data output for port A
    
    // Port B
    input clkb,                    // Clock for port B
    input enb,                     // Enable for port B
    input [3:0] web,               // Write enable for port B (byte-wise)
    input [13:0] addrb,            // Address for port B
    input [31:0] dinb,             // Data input for port B
    output reg [31:0] doutb        // Data output for port B
);

    // Memory array
    reg [31:0] ram [0:12287];

    // Initialize memory
    integer i = 0;
    initial begin
        ram[i] = 32'h80800437;
        i = i + 1;
        ram[i] = 32'h00040413;
        i = i + 1;
        ram[i] = 32'h20000493;
        i = i + 1;
        ram[i] = 32'h40000A13;
        i = i + 1;
        ram[i] = 32'h00000A93;
        i = i + 1;
        ram[i] = 32'h00000B13;
        i = i + 1;
        ram[i] = 32'h80200BB7;
        i = i + 1;
        ram[i] = 32'h000B8B93;
        i = i + 1;
        ram[i] = 32'h00400913;
        i = i + 1;
        ram[i] = 32'h00000993;
        i = i + 1;
        ram[i] = 32'h00831313;
        i = i + 1;
        ram[i] = 32'h000B0463;
        i = i + 1;
        ram[i] = 32'h001A8A93;
        i = i + 1;
        ram[i] = 32'h00442283;
        i = i + 1;
        ram[i] = 32'h0012F293;
        i = i + 1;
        ram[i] = 32'h034A8663;
        i = i + 1;
        ram[i] = 32'hFE0286E3;
        i = i + 1;
        ram[i] = 32'h00100B13;
        i = i + 1;
        ram[i] = 32'h00000A93;
        i = i + 1;
        ram[i] = 32'h00042283;
        i = i + 1;
        ram[i] = 32'h00530333;
        i = i + 1;
        ram[i] = 32'h00198993;
        i = i + 1;
        ram[i] = 32'hFD2998E3;
        i = i + 1;
        ram[i] = 32'h0064A023;
        i = i + 1;
        ram[i] = 32'h00448493;
        i = i + 1;
        ram[i] = 32'hFBDFF06F;
        i = i + 1;
        ram[i] = 32'h0FF00293;
        i = i + 1;
        ram[i] = 32'h005B8023;
        i = i + 1;
        ram[i] = 32'h20000493;
        i = i + 1;
        ram[i] = 32'h00048067;
        i = i + 1;


    end

    // Port A logic
    always @(posedge clka) begin
        if (ena) begin
            // Byte-wise write enable
            if (wea[0]) ram[addra][7:0] <= dina[7:0];
            if (wea[1]) ram[addra][15:8] <= dina[15:8];
            if (wea[2]) ram[addra][23:16] <= dina[23:16];
            if (wea[3]) ram[addra][31:24] <= dina[31:24];
            
            // Read operation (WRITE_FIRST mode)
            douta <= ram[addra];
        end
    end

    // Port B logic
    always @(posedge clkb) begin
        if (enb) begin
            // Byte-wise write enable
            if (web[0]) ram[addrb][7:0] <= dinb[7:0];
            if (web[1]) ram[addrb][15:8] <= dinb[15:8];
            if (web[2]) ram[addrb][23:16] <= dinb[23:16];
            if (web[3]) ram[addrb][31:24] <= dinb[31:24];
            
            // Read operation (WRITE_FIRST mode)
            doutb <= ram[addrb];
        end
    end

endmodule
