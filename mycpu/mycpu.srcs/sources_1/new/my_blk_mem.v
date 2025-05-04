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
        ram[i] = 32'h0C0000EF;
        i = i + 1;
        ram[i] = 32'h0000006F;
        i = i + 1;
        ram[i] = 32'h80800737;
        i = i + 1;
        ram[i] = 32'h00470713;
        i = i + 1;
        ram[i] = 32'h00074783;
        i = i + 1;
        ram[i] = 32'h0027F793;
        i = i + 1;
        ram[i] = 32'hFE078CE3;
        i = i + 1;
        ram[i] = 32'h808007B7;
        i = i + 1;
        ram[i] = 32'h00A78023;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'h80800737;
        i = i + 1;
        ram[i] = 32'h00470713;
        i = i + 1;
        ram[i] = 32'h00074783;
        i = i + 1;
        ram[i] = 32'h0017F793;
        i = i + 1;
        ram[i] = 32'hFE078CE3;
        i = i + 1;
        ram[i] = 32'h808007B7;
        i = i + 1;
        ram[i] = 32'h0007C503;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'h808007B7;
        i = i + 1;
        ram[i] = 32'h0047C503;
        i = i + 1;
        ram[i] = 32'h00157513;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'h802006B7;
        i = i + 1;
        ram[i] = 32'h0006D783;
        i = i + 1;
        ram[i] = 32'h00100713;
        i = i + 1;
        ram[i] = 32'h00A71733;
        i = i + 1;
        ram[i] = 32'h00E7E7B3;
        i = i + 1;
        ram[i] = 32'h01079793;
        i = i + 1;
        ram[i] = 32'h0107D793;
        i = i + 1;
        ram[i] = 32'h00F69023;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'h802006B7;
        i = i + 1;
        ram[i] = 32'h0006D703;
        i = i + 1;
        ram[i] = 32'h00100793;
        i = i + 1;
        ram[i] = 32'h00A797B3;
        i = i + 1;
        ram[i] = 32'hFFF7C793;
        i = i + 1;
        ram[i] = 32'h00F77733;
        i = i + 1;
        ram[i] = 32'h00E69023;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'h802006B7;
        i = i + 1;
        ram[i] = 32'h0006D783;
        i = i + 1;
        ram[i] = 32'h00100713;
        i = i + 1;
        ram[i] = 32'h00A71733;
        i = i + 1;
        ram[i] = 32'h00E7C7B3;
        i = i + 1;
        ram[i] = 32'h01079793;
        i = i + 1;
        ram[i] = 32'h0107D793;
        i = i + 1;
        ram[i] = 32'h00F69023;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'hFF010113;
        i = i + 1;
        ram[i] = 32'h0BA00513;
        i = i + 1;
        ram[i] = 32'h00112623;
        i = i + 1;
        ram[i] = 32'hF3DFF0EF;
        i = i + 1;
        ram[i] = 32'h00E00513;
        i = i + 1;
        ram[i] = 32'hF35FF0EF;
        i = i + 1;
        ram[i] = 32'h01000513;
        i = i + 1;
        ram[i] = 32'hF2DFF0EF;
        i = i + 1;
        ram[i] = 32'h08400513;
        i = i + 1;
        ram[i] = 32'hF25FF0EF;
        i = i + 1;
        ram[i] = 32'h0CC00513;
        i = i + 1;
        ram[i] = 32'hF1DFF0EF;
        i = i + 1;
        ram[i] = 32'h0DD00513;
        i = i + 1;
        ram[i] = 32'hF15FF0EF;
        i = i + 1;
        ram[i] = 32'h0FF00513;
        i = i + 1;
        ram[i] = 32'hF0DFF0EF;
        i = i + 1;
        ram[i] = 32'h0EE00513;
        i = i + 1;
        ram[i] = 32'hF05FF0EF;
        i = i + 1;
        ram[i] = 32'h01100513;
        i = i + 1;
        ram[i] = 32'hEFDFF0EF;
        i = i + 1;
        ram[i] = 32'h00000513;
        i = i + 1;
        ram[i] = 32'hEF5FF0EF;
        i = i + 1;
        ram[i] = 32'h09900513;
        i = i + 1;
        ram[i] = 32'hEEDFF0EF;
        i = i + 1;
        ram[i] = 32'h01200513;
        i = i + 1;
        ram[i] = 32'hEE5FF0EF;
        i = i + 1;
        ram[i] = 32'h00C12083;
        i = i + 1;
        ram[i] = 32'h00000513;
        i = i + 1;
        ram[i] = 32'h01010113;
        i = i + 1;
        ram[i] = 32'h00008067;
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
