`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2025 10:04:09 PM
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
    input [14:0] addra,            // Address for port A (32768 addresses)
    input [31:0] dina,             // Data input for port A
    output reg [31:0] douta,       // Data output for port A
    
    // Port B
    input clkb,                    // Clock for port B
    input enb,                     // Enable for port B
    input [3:0] web,               // Write enable for port B (byte-wise)
    input [14:0] addrb,            // Address for port B
    input [31:0] dinb,             // Data input for port B
    output reg [31:0] doutb        // Data output for port B
);

    // Memory array
    reg [31:0] ram [0:32767]; // 32768 x 32-bit memory

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