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
    integer i;
    initial begin
        i = 0;
        ram[i] = 32'h300023F3;
        i = i + 1;
        ram[i] = 32'h00800313;
        i = i + 1;
        ram[i] = 32'h30031E73;
        i = i + 1;
        ram[i] = 32'h30002EF3;
        i = i + 1;
        ram[i] = 32'h08000313;
        i = i + 1;
        ram[i] = 32'h30032E73;
        i = i + 1;
        ram[i] = 32'h30002EF3;
        i = i + 1;
        ram[i] = 32'h00800313;
        i = i + 1;
        ram[i] = 32'h30033E73;
        i = i + 1;
        ram[i] = 32'h30002EF3;
        i = i + 1;
        ram[i] = 32'h3002DE73;
        i = i + 1;
        ram[i] = 32'h30002EF3;
        i = i + 1;
        ram[i] = 32'h30086E73;
        i = i + 1;
        ram[i] = 32'h30002EF3;
        i = i + 1;
        ram[i] = 32'h3000FE73;
        i = i + 1;
        ram[i] = 32'h30002EF3;
        i = i + 1;
        ram[i] = 32'h30039073;
        i = i + 1;
        ram[i] = 32'h304023F3;
        i = i + 1;
        ram[i] = 32'h00001337;
        i = i + 1;
        ram[i] = 32'h88830313;
        i = i + 1;
        ram[i] = 32'h30431E73;
        i = i + 1;
        ram[i] = 32'h30402EF3;
        i = i + 1;
        ram[i] = 32'h10000313;
        i = i + 1;
        ram[i] = 32'h30432E73;
        i = i + 1;
        ram[i] = 32'h30402EF3;
        i = i + 1;
        ram[i] = 32'h00001337;
        i = i + 1;
        ram[i] = 32'h80030313;
        i = i + 1;
        ram[i] = 32'h30433E73;
        i = i + 1;
        ram[i] = 32'h30402EF3;
        i = i + 1;
        ram[i] = 32'h3043DE73;
        i = i + 1;
        ram[i] = 32'h30402EF3;
        i = i + 1;
        ram[i] = 32'h30446E73;
        i = i + 1;
        ram[i] = 32'h30402EF3;
        i = i + 1;
        ram[i] = 32'h30417E73;
        i = i + 1;
        ram[i] = 32'h30402EF3;
        i = i + 1;
        ram[i] = 32'h30439073;
        i = i + 1;
        ram[i] = 32'h343023F3;
        i = i + 1;
        ram[i] = 32'hCAFEC337;
        i = i + 1;
        ram[i] = 32'hABE30313;
        i = i + 1;
        ram[i] = 32'h34331E73;
        i = i + 1;
        ram[i] = 32'h34302EF3;
        i = i + 1;
        ram[i] = 32'h00100313;
        i = i + 1;
        ram[i] = 32'h34332E73;
        i = i + 1;
        ram[i] = 32'h34302EF3;
        i = i + 1;
        ram[i] = 32'h00F00313;
        i = i + 1;
        ram[i] = 32'h34333E73;
        i = i + 1;
        ram[i] = 32'h34302EF3;
        i = i + 1;
        ram[i] = 32'h3438DE73;
        i = i + 1;
        ram[i] = 32'h34302EF3;
        i = i + 1;
        ram[i] = 32'h34326E73;
        i = i + 1;
        ram[i] = 32'h34302EF3;
        i = i + 1;
        ram[i] = 32'h3430FE73;
        i = i + 1;
        ram[i] = 32'h34302EF3;
        i = i + 1;
        ram[i] = 32'h34339073;
        i = i + 1;
        ram[i] = 32'h342023F3;
        i = i + 1;
        ram[i] = 32'h00B00313;
        i = i + 1;
        ram[i] = 32'h34231E73;
        i = i + 1;
        ram[i] = 32'h34202EF3;
        i = i + 1;
        ram[i] = 32'h80000337;
        i = i + 1;
        ram[i] = 32'h34232E73;
        i = i + 1;
        ram[i] = 32'h34202EF3;
        i = i + 1;
        ram[i] = 32'h00B00313;
        i = i + 1;
        ram[i] = 32'h34233E73;
        i = i + 1;
        ram[i] = 32'h34202EF3;
        i = i + 1;
        ram[i] = 32'h3421DE73;
        i = i + 1;
        ram[i] = 32'h34202EF3;
        i = i + 1;
        ram[i] = 32'h34246E73;
        i = i + 1;
        ram[i] = 32'h34202EF3;
        i = i + 1;
        ram[i] = 32'h3420FE73;
        i = i + 1;
        ram[i] = 32'h34202EF3;
        i = i + 1;
        ram[i] = 32'h34239073;
        i = i + 1;
        ram[i] = 32'h341023F3;
        i = i + 1;
        ram[i] = 32'h80001337;
        i = i + 1;
        ram[i] = 32'h34131E73;
        i = i + 1;
        ram[i] = 32'h34102EF3;
        i = i + 1;
        ram[i] = 32'h00400313;
        i = i + 1;
        ram[i] = 32'h34132E73;
        i = i + 1;
        ram[i] = 32'h34102EF3;
        i = i + 1;
        ram[i] = 32'h00C00313;
        i = i + 1;
        ram[i] = 32'h34133E73;
        i = i + 1;
        ram[i] = 32'h34102EF3;
        i = i + 1;
        ram[i] = 32'h341F5E73;
        i = i + 1;
        ram[i] = 32'h34102EF3;
        i = i + 1;
        ram[i] = 32'h3410EE73;
        i = i + 1;
        ram[i] = 32'h34102EF3;
        i = i + 1;
        ram[i] = 32'h34117E73;
        i = i + 1;
        ram[i] = 32'h34102EF3;
        i = i + 1;
        ram[i] = 32'h34139073;
        i = i + 1;
        ram[i] = 32'h344023F3;
        i = i + 1;
        ram[i] = 32'h00001337;
        i = i + 1;
        ram[i] = 32'hAAA30313;
        i = i + 1;
        ram[i] = 32'h34431E73;
        i = i + 1;
        ram[i] = 32'h34402EF3;
        i = i + 1;
        ram[i] = 32'h00001337;
        i = i + 1;
        ram[i] = 32'h88830313;
        i = i + 1;
        ram[i] = 32'h34432E73;
        i = i + 1;
        ram[i] = 32'h34402EF3;
        i = i + 1;
        ram[i] = 32'h00001337;
        i = i + 1;
        ram[i] = 32'h88830313;
        i = i + 1;
        ram[i] = 32'h34433E73;
        i = i + 1;
        ram[i] = 32'h34402EF3;
        i = i + 1;
        ram[i] = 32'h3442DE73;
        i = i + 1;
        ram[i] = 32'h34402EF3;
        i = i + 1;
        ram[i] = 32'h34446E73;
        i = i + 1;
        ram[i] = 32'h34402EF3;
        i = i + 1;
        ram[i] = 32'h34417E73;
        i = i + 1;
        ram[i] = 32'h34402EF3;
        i = i + 1;
        ram[i] = 32'h34439073;
        i = i + 1;
        ram[i] = 32'h00000013;
        i = i + 1;
        ram[i] = 32'h0000006F;
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
