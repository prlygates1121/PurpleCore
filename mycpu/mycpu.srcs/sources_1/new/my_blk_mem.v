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
    input [3:0] wea,               // Write enable for port A (byte-wise)
    input [13:0] addra,            // Address for port A
    input [31:0] dina,             // Data input for port A
    output [31:0] douta,             // Data output for port A
    
    // // Port B
    input clkb,                    // Clock for port B
    // input enb,                     // Enable for port B
    input [3:0] web,               // Write enable for port B (byte-wise)
    input [13:0] addrb,            // Address for port B
    input [31:0] dinb,             // Data input for port B
    output [31:0] doutb             // Data output for port B
);

    // Memory array
    reg [31:0] ram [0:255];

    // Initialize memory
    integer i;
    initial begin
        i = 0;
        ram[i] = 32'h00000893;
        i = i + 1;
        ram[i] = 32'h00058893;
        i = i + 1;
        ram[i] = 32'h80600537;
        i = i + 1;
        ram[i] = 32'h00050513;
        i = i + 1;
        ram[i] = 32'h00054583;
        i = i + 1;
        ram[i] = 32'h0045D593;
        i = i + 1;
        ram[i] = 32'hFE0586E3;
        i = i + 1;
        ram[i] = 32'hFE0894E3;
        i = i + 1;
        ram[i] = 32'h80300537;
        i = i + 1;
        ram[i] = 32'h00050513;
        i = i + 1;
        ram[i] = 32'h00054603;
        i = i + 1;
        ram[i] = 32'h00000513;
        i = i + 1;
        ram[i] = 32'h02C50E63;
        i = i + 1;
        ram[i] = 32'h00100513;
        i = i + 1;
        ram[i] = 32'h04C50863;
        i = i + 1;
        ram[i] = 32'h00200513;
        i = i + 1;
        ram[i] = 32'h06C50463;
        i = i + 1;
        ram[i] = 32'h00300513;
        i = i + 1;
        ram[i] = 32'h08C50063;
        i = i + 1;
        ram[i] = 32'h00400513;
        i = i + 1;
        ram[i] = 32'h0AC50663;
        i = i + 1;
        ram[i] = 32'h00500513;
        i = i + 1;
        ram[i] = 32'h0CC50C63;
        i = i + 1;
        ram[i] = 32'h00600513;
        i = i + 1;
        ram[i] = 32'h10C50263;
        i = i + 1;
        ram[i] = 32'h00700513;
        i = i + 1;
        ram[i] = 32'h12C50C63;
        i = i + 1;
        ram[i] = 32'h803002B7;
        i = i + 1;
        ram[i] = 32'h00128293;
        i = i + 1;
        ram[i] = 32'h0002C303;
        i = i + 1;
        ram[i] = 32'h802002B7;
        i = i + 1;
        ram[i] = 32'h00128293;
        i = i + 1;
        ram[i] = 32'h00628023;
        i = i + 1;
        ram[i] = 32'hF81FF06F;
        i = i + 1;
        ram[i] = 32'h803002B7;
        i = i + 1;
        ram[i] = 32'h00128293;
        i = i + 1;
        ram[i] = 32'h00028303;
        i = i + 1;
        ram[i] = 32'h807002B7;
        i = i + 1;
        ram[i] = 32'h00028293;
        i = i + 1;
        ram[i] = 32'h0062A023;
        i = i + 1;
        ram[i] = 32'hFE612E23;
        i = i + 1;
        ram[i] = 32'hF61FF06F;
        i = i + 1;
        ram[i] = 32'h803002B7;
        i = i + 1;
        ram[i] = 32'h00128293;
        i = i + 1;
        ram[i] = 32'h0002C303;
        i = i + 1;
        ram[i] = 32'h807002B7;
        i = i + 1;
        ram[i] = 32'h00028293;
        i = i + 1;
        ram[i] = 32'h0062A023;
        i = i + 1;
        ram[i] = 32'hFE612C23;
        i = i + 1;
        ram[i] = 32'hF41FF06F;
        i = i + 1;
        ram[i] = 32'hFFC12303;
        i = i + 1;
        ram[i] = 32'hFF812383;
        i = i + 1;
        ram[i] = 32'h00730C63;
        i = i + 1;
        ram[i] = 32'h00000313;
        i = i + 1;
        ram[i] = 32'h802002B7;
        i = i + 1;
        ram[i] = 32'h00128293;
        i = i + 1;
        ram[i] = 32'h00628023;
        i = i + 1;
        ram[i] = 32'hF21FF06F;
        i = i + 1;
        ram[i] = 32'h0FF00313;
        i = i + 1;
        ram[i] = 32'h802002B7;
        i = i + 1;
        ram[i] = 32'h00128293;
        i = i + 1;
        ram[i] = 32'h00628023;
        i = i + 1;
        ram[i] = 32'hF0DFF06F;
        i = i + 1;
        ram[i] = 32'hFFC12303;
        i = i + 1;
        ram[i] = 32'hFF812383;
        i = i + 1;
        ram[i] = 32'h00734C63;
        i = i + 1;
        ram[i] = 32'h00000313;
        i = i + 1;
        ram[i] = 32'h802002B7;
        i = i + 1;
        ram[i] = 32'h00128293;
        i = i + 1;
        ram[i] = 32'h00628023;
        i = i + 1;
        ram[i] = 32'hEEDFF06F;
        i = i + 1;
        ram[i] = 32'h0FF00313;
        i = i + 1;
        ram[i] = 32'h802002B7;
        i = i + 1;
        ram[i] = 32'h00128293;
        i = i + 1;
        ram[i] = 32'h00628023;
        i = i + 1;
        ram[i] = 32'hED9FF06F;
        i = i + 1;
        ram[i] = 32'hFFC12303;
        i = i + 1;
        ram[i] = 32'hFF812383;
        i = i + 1;
        ram[i] = 32'h00736C63;
        i = i + 1;
        ram[i] = 32'h00000313;
        i = i + 1;
        ram[i] = 32'h802002B7;
        i = i + 1;
        ram[i] = 32'h00128293;
        i = i + 1;
        ram[i] = 32'h00628023;
        i = i + 1;
        ram[i] = 32'hEB9FF06F;
        i = i + 1;
        ram[i] = 32'h0FF00313;
        i = i + 1;
        ram[i] = 32'h802002B7;
        i = i + 1;
        ram[i] = 32'h00128293;
        i = i + 1;
        ram[i] = 32'h00628023;
        i = i + 1;
        ram[i] = 32'hEA5FF06F;
        i = i + 1;
        ram[i] = 32'hFFC12303;
        i = i + 1;
        ram[i] = 32'hFF812383;
        i = i + 1;
        ram[i] = 32'h00000E13;
        i = i + 1;
        ram[i] = 32'h00732E33;
        i = i + 1;
        ram[i] = 32'h000E0C63;
        i = i + 1;
        ram[i] = 32'h00100313;
        i = i + 1;
        ram[i] = 32'h802002B7;
        i = i + 1;
        ram[i] = 32'h00128293;
        i = i + 1;
        ram[i] = 32'h00628023;
        i = i + 1;
        ram[i] = 32'hE7DFF06F;
        i = i + 1;
        ram[i] = 32'h00000313;
        i = i + 1;
        ram[i] = 32'h802002B7;
        i = i + 1;
        ram[i] = 32'h00128293;
        i = i + 1;
        ram[i] = 32'h00628023;
        i = i + 1;
        ram[i] = 32'hE69FF06F;
        i = i + 1;
        ram[i] = 32'hFFC12303;
        i = i + 1;
        ram[i] = 32'hFF812383;
        i = i + 1;
        ram[i] = 32'h00000E13;
        i = i + 1;
        ram[i] = 32'h00733E33;
        i = i + 1;
        ram[i] = 32'h000E0C63;
        i = i + 1;
        ram[i] = 32'h00100313;
        i = i + 1;
        ram[i] = 32'h802002B7;
        i = i + 1;
        ram[i] = 32'h00128293;
        i = i + 1;
        ram[i] = 32'h00628023;
        i = i + 1;
        ram[i] = 32'hE41FF06F;
        i = i + 1;
        ram[i] = 32'h00000313;
        i = i + 1;
        ram[i] = 32'h802002B7;
        i = i + 1;
        ram[i] = 32'h00128293;
        i = i + 1;
        ram[i] = 32'h00628023;
        i = i + 1;
        ram[i] = 32'hE2DFF06F;
        i = i + 1;


    end

    // Port A logic
    always @(posedge clka) begin
        if (wea[0]) ram[addra][7:0] <= dina[7:0];
        if (wea[1]) ram[addra][15:8] <= dina[15:8];
        if (wea[2]) ram[addra][23:16] <= dina[23:16];
        if (wea[3]) ram[addra][31:24] <= dina[31:24];
    end
    
    assign douta = ram[addra];

    reg [31:0] what[0:255];

    // Port B logic
    always @(posedge clkb) begin
        if (web[0]) what[addrb][7:0] <= dinb[7:0];
        if (web[1]) what[addrb][15:8] <= dinb[15:8];
        if (web[2]) what[addrb][23:16] <= dinb[23:16];
        if (web[3]) what[addrb][31:24] <= dinb[31:24];
    end
    
    assign doutb = what[addrb];


endmodule
