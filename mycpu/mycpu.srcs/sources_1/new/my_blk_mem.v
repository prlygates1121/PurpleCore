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
    input [13:0] addra,            // Address for port A (32768 addresses)
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
    reg [31:0] ram [0:12287]; // 32768 x 32-bit memory

    // Initialize memory
    integer i = 0;
    initial begin
        ram[i] = 32'hFC010113;
        i = i + 1;
        ram[i] = 32'h02112E23;
        i = i + 1;
        ram[i] = 32'h02812C23;
        i = i + 1;
        ram[i] = 32'h04010413;
        i = i + 1;
        ram[i] = 32'h00100793;
        i = i + 1;
        ram[i] = 32'hFCF42023;
        i = i + 1;
        ram[i] = 32'h00500793;
        i = i + 1;
        ram[i] = 32'hFCF42223;
        i = i + 1;
        ram[i] = 32'h00700793;
        i = i + 1;
        ram[i] = 32'hFCF42423;
        i = i + 1;
        ram[i] = 32'h00200793;
        i = i + 1;
        ram[i] = 32'hFCF42623;
        i = i + 1;
        ram[i] = 32'hFC042823;
        i = i + 1;
        ram[i] = 32'h00800793;
        i = i + 1;
        ram[i] = 32'hFCF42A23;
        i = i + 1;
        ram[i] = 32'h00900793;
        i = i + 1;
        ram[i] = 32'hFCF42C23;
        i = i + 1;
        ram[i] = 32'hFFF00793;
        i = i + 1;
        ram[i] = 32'hFCF42E23;
        i = i + 1;
        ram[i] = 32'h02000793;
        i = i + 1;
        ram[i] = 32'hFEF42023;
        i = i + 1;
        ram[i] = 32'h00600793;
        i = i + 1;
        ram[i] = 32'hFEF42223;
        i = i + 1;
        ram[i] = 32'h00A00793;
        i = i + 1;
        ram[i] = 32'hFEF42423;
        i = i + 1;
        ram[i] = 32'hFC040793;
        i = i + 1;
        ram[i] = 32'hFE842583;
        i = i + 1;
        ram[i] = 32'h00078513;
        i = i + 1;
        ram[i] = 32'h1DC000EF;
        i = i + 1;
        ram[i] = 32'h00100793;
        i = i + 1;
        ram[i] = 32'hFEF42623;
        i = i + 1;
        ram[i] = 32'h0540006F;
        i = i + 1;
        ram[i] = 32'hFEC42783;
        i = i + 1;
        ram[i] = 32'h00279793;
        i = i + 1;
        ram[i] = 32'hFF078793;
        i = i + 1;
        ram[i] = 32'h008787B3;
        i = i + 1;
        ram[i] = 32'hFD07A703;
        i = i + 1;
        ram[i] = 32'hFEC42783;
        i = i + 1;
        ram[i] = 32'hFFF78793;
        i = i + 1;
        ram[i] = 32'h00279793;
        i = i + 1;
        ram[i] = 32'hFF078793;
        i = i + 1;
        ram[i] = 32'h008787B3;
        i = i + 1;
        ram[i] = 32'hFD07A783;
        i = i + 1;
        ram[i] = 32'h00F75C63;
        i = i + 1;
        ram[i] = 32'h00100513;
        i = i + 1;
        ram[i] = 32'h00000013;
        i = i + 1;
        ram[i] = 32'h00000013;
        i = i + 1;
        ram[i] = 32'h00000013;
        i = i + 1;
        ram[i] = 32'h00000013;
        i = i + 1;
        ram[i] = 32'hFEC42783;
        i = i + 1;
        ram[i] = 32'h00178793;
        i = i + 1;
        ram[i] = 32'hFEF42623;
        i = i + 1;
        ram[i] = 32'hFEC42703;
        i = i + 1;
        ram[i] = 32'hFE842783;
        i = i + 1;
        ram[i] = 32'hFAF744E3;
        i = i + 1;
        ram[i] = 32'h00000513;
        i = i + 1;
        ram[i] = 32'h00000013;
        i = i + 1;
        ram[i] = 32'h00000013;
        i = i + 1;
        ram[i] = 32'h00000013;
        i = i + 1;
        ram[i] = 32'h00000013;
        i = i + 1;
        ram[i] = 32'h00000793;
        i = i + 1;
        ram[i] = 32'h00078513;
        i = i + 1;
        ram[i] = 32'h03C12083;
        i = i + 1;
        ram[i] = 32'h03812403;
        i = i + 1;
        ram[i] = 32'h04010113;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'hFD010113;
        i = i + 1;
        ram[i] = 32'h02112623;
        i = i + 1;
        ram[i] = 32'h02812423;
        i = i + 1;
        ram[i] = 32'h03010413;
        i = i + 1;
        ram[i] = 32'hFCA42E23;
        i = i + 1;
        ram[i] = 32'hFCB42C23;
        i = i + 1;
        ram[i] = 32'hFCC42A23;
        i = i + 1;
        ram[i] = 32'hFD442783;
        i = i + 1;
        ram[i] = 32'h00179793;
        i = i + 1;
        ram[i] = 32'hFEF42423;
        i = i + 1;
        ram[i] = 32'hFE842783;
        i = i + 1;
        ram[i] = 32'h00178793;
        i = i + 1;
        ram[i] = 32'hFEF42223;
        i = i + 1;
        ram[i] = 32'hFD442783;
        i = i + 1;
        ram[i] = 32'hFEF42623;
        i = i + 1;
        ram[i] = 32'hFE842703;
        i = i + 1;
        ram[i] = 32'hFD842783;
        i = i + 1;
        ram[i] = 32'h02F75C63;
        i = i + 1;
        ram[i] = 32'hFE842783;
        i = i + 1;
        ram[i] = 32'h00279793;
        i = i + 1;
        ram[i] = 32'hFDC42703;
        i = i + 1;
        ram[i] = 32'h00F707B3;
        i = i + 1;
        ram[i] = 32'h0007A703;
        i = i + 1;
        ram[i] = 32'hFD442783;
        i = i + 1;
        ram[i] = 32'h00279793;
        i = i + 1;
        ram[i] = 32'hFDC42683;
        i = i + 1;
        ram[i] = 32'h00F687B3;
        i = i + 1;
        ram[i] = 32'h0007A783;
        i = i + 1;
        ram[i] = 32'h00E7D663;
        i = i + 1;
        ram[i] = 32'hFE842783;
        i = i + 1;
        ram[i] = 32'hFEF42623;
        i = i + 1;
        ram[i] = 32'hFE442703;
        i = i + 1;
        ram[i] = 32'hFD842783;
        i = i + 1;
        ram[i] = 32'h02F75C63;
        i = i + 1;
        ram[i] = 32'hFE442783;
        i = i + 1;
        ram[i] = 32'h00279793;
        i = i + 1;
        ram[i] = 32'hFDC42703;
        i = i + 1;
        ram[i] = 32'h00F707B3;
        i = i + 1;
        ram[i] = 32'h0007A703;
        i = i + 1;
        ram[i] = 32'hFEC42783;
        i = i + 1;
        ram[i] = 32'h00279793;
        i = i + 1;
        ram[i] = 32'hFDC42683;
        i = i + 1;
        ram[i] = 32'h00F687B3;
        i = i + 1;
        ram[i] = 32'h0007A783;
        i = i + 1;
        ram[i] = 32'h00E7D663;
        i = i + 1;
        ram[i] = 32'hFE442783;
        i = i + 1;
        ram[i] = 32'hFEF42623;
        i = i + 1;
        ram[i] = 32'hFEC42703;
        i = i + 1;
        ram[i] = 32'hFD442783;
        i = i + 1;
        ram[i] = 32'h06F70663;
        i = i + 1;
        ram[i] = 32'hFD442783;
        i = i + 1;
        ram[i] = 32'h00279793;
        i = i + 1;
        ram[i] = 32'hFDC42703;
        i = i + 1;
        ram[i] = 32'h00F707B3;
        i = i + 1;
        ram[i] = 32'h0007A783;
        i = i + 1;
        ram[i] = 32'hFEF42023;
        i = i + 1;
        ram[i] = 32'hFEC42783;
        i = i + 1;
        ram[i] = 32'h00279793;
        i = i + 1;
        ram[i] = 32'hFDC42703;
        i = i + 1;
        ram[i] = 32'h00F70733;
        i = i + 1;
        ram[i] = 32'hFD442783;
        i = i + 1;
        ram[i] = 32'h00279793;
        i = i + 1;
        ram[i] = 32'hFDC42683;
        i = i + 1;
        ram[i] = 32'h00F687B3;
        i = i + 1;
        ram[i] = 32'h00072703;
        i = i + 1;
        ram[i] = 32'h00E7A023;
        i = i + 1;
        ram[i] = 32'hFEC42783;
        i = i + 1;
        ram[i] = 32'h00279793;
        i = i + 1;
        ram[i] = 32'hFDC42703;
        i = i + 1;
        ram[i] = 32'h00F707B3;
        i = i + 1;
        ram[i] = 32'hFE042703;
        i = i + 1;
        ram[i] = 32'h00E7A023;
        i = i + 1;
        ram[i] = 32'hFEC42603;
        i = i + 1;
        ram[i] = 32'hFD842583;
        i = i + 1;
        ram[i] = 32'hFDC42503;
        i = i + 1;
        ram[i] = 32'hED5FF0EF;
        i = i + 1;
        ram[i] = 32'h00000013;
        i = i + 1;
        ram[i] = 32'h02C12083;
        i = i + 1;
        ram[i] = 32'h02812403;
        i = i + 1;
        ram[i] = 32'h03010113;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'hFD010113;
        i = i + 1;
        ram[i] = 32'h02112623;
        i = i + 1;
        ram[i] = 32'h02812423;
        i = i + 1;
        ram[i] = 32'h03010413;
        i = i + 1;
        ram[i] = 32'hFCA42E23;
        i = i + 1;
        ram[i] = 32'hFCB42C23;
        i = i + 1;
        ram[i] = 32'hFD842783;
        i = i + 1;
        ram[i] = 32'h00179793;
        i = i + 1;
        ram[i] = 32'hFFF78793;
        i = i + 1;
        ram[i] = 32'hFEF42623;
        i = i + 1;
        ram[i] = 32'h0200006F;
        i = i + 1;
        ram[i] = 32'hFEC42603;
        i = i + 1;
        ram[i] = 32'hFD842583;
        i = i + 1;
        ram[i] = 32'hFDC42503;
        i = i + 1;
        ram[i] = 32'hE85FF0EF;
        i = i + 1;
        ram[i] = 32'hFEC42783;
        i = i + 1;
        ram[i] = 32'hFFF78793;
        i = i + 1;
        ram[i] = 32'hFEF42623;
        i = i + 1;
        ram[i] = 32'hFEC42783;
        i = i + 1;
        ram[i] = 32'hFE07D0E3;
        i = i + 1;
        ram[i] = 32'hFD842783;
        i = i + 1;
        ram[i] = 32'hFFF78793;
        i = i + 1;
        ram[i] = 32'hFEF42423;
        i = i + 1;
        ram[i] = 32'h0600006F;
        i = i + 1;
        ram[i] = 32'hFE842783;
        i = i + 1;
        ram[i] = 32'h00279793;
        i = i + 1;
        ram[i] = 32'hFDC42703;
        i = i + 1;
        ram[i] = 32'h00F707B3;
        i = i + 1;
        ram[i] = 32'h0007A783;
        i = i + 1;
        ram[i] = 32'hFEF42223;
        i = i + 1;
        ram[i] = 32'hFE842783;
        i = i + 1;
        ram[i] = 32'h00279793;
        i = i + 1;
        ram[i] = 32'hFDC42703;
        i = i + 1;
        ram[i] = 32'h00F707B3;
        i = i + 1;
        ram[i] = 32'hFDC42703;
        i = i + 1;
        ram[i] = 32'h00072703;
        i = i + 1;
        ram[i] = 32'h00E7A023;
        i = i + 1;
        ram[i] = 32'hFDC42783;
        i = i + 1;
        ram[i] = 32'hFE442703;
        i = i + 1;
        ram[i] = 32'h00E7A023;
        i = i + 1;
        ram[i] = 32'h00000613;
        i = i + 1;
        ram[i] = 32'hFE842583;
        i = i + 1;
        ram[i] = 32'hFDC42503;
        i = i + 1;
        ram[i] = 32'hE11FF0EF;
        i = i + 1;
        ram[i] = 32'hFE842783;
        i = i + 1;
        ram[i] = 32'hFFF78793;
        i = i + 1;
        ram[i] = 32'hFEF42423;
        i = i + 1;
        ram[i] = 32'hFE842783;
        i = i + 1;
        ram[i] = 32'hFAF040E3;
        i = i + 1;
        ram[i] = 32'h00000013;
        i = i + 1;
        ram[i] = 32'h00000013;
        i = i + 1;
        ram[i] = 32'h02C12083;
        i = i + 1;
        ram[i] = 32'h02812403;
        i = i + 1;
        ram[i] = 32'h03010113;
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
