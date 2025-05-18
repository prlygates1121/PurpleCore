`timescale 1ns / 1ps
`include "params.v"
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
        `ifdef LOAD_AT_0X200
            i = 32'h80;
        `else
            i = 32'h0;
        `endif

        ram[i] = 32'h0000B117;
        i = i + 1;
        ram[i] = 32'hE0010113;
        i = i + 1;
        ram[i] = 32'h00000517;
        i = i + 1;
        ram[i] = 32'h4B450513;
        i = i + 1;
        ram[i] = 32'h00009597;
        i = i + 1;
        ram[i] = 32'hDF058593;
        i = i + 1;
        ram[i] = 32'h00009617;
        i = i + 1;
        ram[i] = 32'hDE860613;
        i = i + 1;
        ram[i] = 32'h00C58C63;
        i = i + 1;
        ram[i] = 32'h00052283;
        i = i + 1;
        ram[i] = 32'h0055A023;
        i = i + 1;
        ram[i] = 32'h00450513;
        i = i + 1;
        ram[i] = 32'h00458593;
        i = i + 1;
        ram[i] = 32'hFEDFF06F;
        i = i + 1;
        ram[i] = 32'h00009517;
        i = i + 1;
        ram[i] = 32'hDC850513;
        i = i + 1;
        ram[i] = 32'h00009597;
        i = i + 1;
        ram[i] = 32'hE4858593;
        i = i + 1;
        ram[i] = 32'h00B50863;
        i = i + 1;
        ram[i] = 32'h00052023;
        i = i + 1;
        ram[i] = 32'h00450513;
        i = i + 1;
        ram[i] = 32'hFF5FF06F;
        i = i + 1;
        ram[i] = 32'h00000297;
        i = i + 1;
        ram[i] = 32'h31028293;
        i = i + 1;
        ram[i] = 32'h30529073;
        i = i + 1;
        ram[i] = 32'h00009297;
        i = i + 1;
        ram[i] = 32'hD9C28293;
        i = i + 1;
        ram[i] = 32'h34029073;
        i = i + 1;
        ram[i] = 32'h0000C317;
        i = i + 1;
        ram[i] = 32'hD9030313;
        i = i + 1;
        ram[i] = 32'h0062A023;
        i = i + 1;
        ram[i] = 32'h00000317;
        i = i + 1;
        ram[i] = 32'h1F430313;
        i = i + 1;
        ram[i] = 32'h0062A223;
        i = i + 1;
        ram[i] = 32'h00800293;
        i = i + 1;
        ram[i] = 32'h3002A073;
        i = i + 1;
        ram[i] = 32'h008000EF;
        i = i + 1;
        ram[i] = 32'h0000006F;
        i = i + 1;
        ram[i] = 32'hFF010113;
        i = i + 1;
        ram[i] = 32'h00F00513;
        i = i + 1;
        ram[i] = 32'h00112623;
        i = i + 1;
        ram[i] = 32'h0E4000EF;
        i = i + 1;
        ram[i] = 32'h02C000EF;
        i = i + 1;
        ram[i] = 32'h0F000513;
        i = i + 1;
        ram[i] = 32'h0D8000EF;
        i = i + 1;
        ram[i] = 32'h020000EF;
        i = i + 1;
        ram[i] = 32'h00001537;
        i = i + 1;
        ram[i] = 32'hF0050513;
        i = i + 1;
        ram[i] = 32'h0C8000EF;
        i = i + 1;
        ram[i] = 32'h00C12083;
        i = i + 1;
        ram[i] = 32'h00000513;
        i = i + 1;
        ram[i] = 32'h01010113;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'h00000893;
        i = i + 1;
        ram[i] = 32'h00000073;
        i = i + 1;
        ram[i] = 32'h00008067;
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
        ram[i] = 32'h02058863;
        i = i + 1;
        ram[i] = 32'h80800737;
        i = i + 1;
        ram[i] = 32'h00B50633;
        i = i + 1;
        ram[i] = 32'h00470713;
        i = i + 1;
        ram[i] = 32'h808005B7;
        i = i + 1;
        ram[i] = 32'h00054683;
        i = i + 1;
        ram[i] = 32'h00074783;
        i = i + 1;
        ram[i] = 32'h0027F793;
        i = i + 1;
        ram[i] = 32'hFE078CE3;
        i = i + 1;
        ram[i] = 32'h00D58023;
        i = i + 1;
        ram[i] = 32'h00150513;
        i = i + 1;
        ram[i] = 32'hFEC514E3;
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
        ram[i] = 32'h802007B7;
        i = i + 1;
        ram[i] = 32'h00A79023;
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
        ram[i] = 32'h807007B7;
        i = i + 1;
        ram[i] = 32'h00A7A023;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'h803007B7;
        i = i + 1;
        ram[i] = 32'h0007D783;
        i = i + 1;
        ram[i] = 32'h40A7D533;
        i = i + 1;
        ram[i] = 32'h00157513;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'h803007B7;
        i = i + 1;
        ram[i] = 32'h0007D503;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'h806007B7;
        i = i + 1;
        ram[i] = 32'h0007C503;
        i = i + 1;
        ram[i] = 32'h00255513;
        i = i + 1;
        ram[i] = 32'h00157513;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'h806007B7;
        i = i + 1;
        ram[i] = 32'h0007C503;
        i = i + 1;
        ram[i] = 32'h00355513;
        i = i + 1;
        ram[i] = 32'h00157513;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'h806007B7;
        i = i + 1;
        ram[i] = 32'h0007C503;
        i = i + 1;
        ram[i] = 32'h00157513;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'h806007B7;
        i = i + 1;
        ram[i] = 32'h0007C503;
        i = i + 1;
        ram[i] = 32'h00155513;
        i = i + 1;
        ram[i] = 32'h00157513;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'h806007B7;
        i = i + 1;
        ram[i] = 32'h0007C503;
        i = i + 1;
        ram[i] = 32'h00455513;
        i = i + 1;
        ram[i] = 32'h00157513;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'h806007B7;
        i = i + 1;
        ram[i] = 32'h0007C503;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'hFF010113;
        i = i + 1;
        ram[i] = 32'h00912223;
        i = i + 1;
        ram[i] = 32'h000094B7;
        i = i + 1;
        ram[i] = 32'h00112623;
        i = i + 1;
        ram[i] = 32'h00812423;
        i = i + 1;
        ram[i] = 32'h218000EF;
        i = i + 1;
        ram[i] = 32'h00048413;
        i = i + 1;
        ram[i] = 32'h00A42423;
        i = i + 1;
        ram[i] = 32'h21C000EF;
        i = i + 1;
        ram[i] = 32'h00B00793;
        i = i + 1;
        ram[i] = 32'h02F50263;
        i = i + 1;
        ram[i] = 32'h00842503;
        i = i + 1;
        ram[i] = 32'h204000EF;
        i = i + 1;
        ram[i] = 32'h00812403;
        i = i + 1;
        ram[i] = 32'h00C12083;
        i = i + 1;
        ram[i] = 32'h00048513;
        i = i + 1;
        ram[i] = 32'h00412483;
        i = i + 1;
        ram[i] = 32'h01010113;
        i = i + 1;
        ram[i] = 32'h1400006F;
        i = i + 1;
        ram[i] = 32'h00842783;
        i = i + 1;
        ram[i] = 32'h00478793;
        i = i + 1;
        ram[i] = 32'h00F42423;
        i = i + 1;
        ram[i] = 32'h04C42783;
        i = i + 1;
        ram[i] = 32'hFC0798E3;
        i = i + 1;
        ram[i] = 32'h07700513;
        i = i + 1;
        ram[i] = 32'hE0DFF0EF;
        i = i + 1;
        ram[i] = 32'h06800513;
        i = i + 1;
        ram[i] = 32'hE05FF0EF;
        i = i + 1;
        ram[i] = 32'h06100513;
        i = i + 1;
        ram[i] = 32'hDFDFF0EF;
        i = i + 1;
        ram[i] = 32'h07400513;
        i = i + 1;
        ram[i] = 32'hDF5FF0EF;
        i = i + 1;
        ram[i] = 32'hFADFF06F;
        i = i + 1;
        ram[i] = 32'hFF010113;
        i = i + 1;
        ram[i] = 32'h00812423;
        i = i + 1;
        ram[i] = 32'h00009437;
        i = i + 1;
        ram[i] = 32'h00040793;
        i = i + 1;
        ram[i] = 32'h0087A503;
        i = i + 1;
        ram[i] = 32'h00112623;
        i = i + 1;
        ram[i] = 32'h198000EF;
        i = i + 1;
        ram[i] = 32'h00040513;
        i = i + 1;
        ram[i] = 32'h00812403;
        i = i + 1;
        ram[i] = 32'h00C12083;
        i = i + 1;
        ram[i] = 32'h01010113;
        i = i + 1;
        ram[i] = 32'h0D80006F;
        i = i + 1;
        ram[i] = 32'h000097B7;
        i = i + 1;
        ram[i] = 32'h00078793;
        i = i + 1;
        ram[i] = 32'h04C7A783;
        i = i + 1;
        ram[i] = 32'h00078463;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'hFF010113;
        i = i + 1;
        ram[i] = 32'h07700513;
        i = i + 1;
        ram[i] = 32'h00112623;
        i = i + 1;
        ram[i] = 32'hD9DFF0EF;
        i = i + 1;
        ram[i] = 32'h06800513;
        i = i + 1;
        ram[i] = 32'hD95FF0EF;
        i = i + 1;
        ram[i] = 32'h06100513;
        i = i + 1;
        ram[i] = 32'hD8DFF0EF;
        i = i + 1;
        ram[i] = 32'h00C12083;
        i = i + 1;
        ram[i] = 32'h07400513;
        i = i + 1;
        ram[i] = 32'h01010113;
        i = i + 1;
        ram[i] = 32'hD7DFF06F;
        i = i + 1;
        ram[i] = 32'h34051573;
        i = i + 1;
        ram[i] = 32'h00152623;
        i = i + 1;
        ram[i] = 32'h00252823;
        i = i + 1;
        ram[i] = 32'h00352A23;
        i = i + 1;
        ram[i] = 32'h00452C23;
        i = i + 1;
        ram[i] = 32'h00552E23;
        i = i + 1;
        ram[i] = 32'h02652023;
        i = i + 1;
        ram[i] = 32'h02752223;
        i = i + 1;
        ram[i] = 32'h02852423;
        i = i + 1;
        ram[i] = 32'h02952623;
        i = i + 1;
        ram[i] = 32'h02B52A23;
        i = i + 1;
        ram[i] = 32'h02C52C23;
        i = i + 1;
        ram[i] = 32'h02D52E23;
        i = i + 1;
        ram[i] = 32'h04E52023;
        i = i + 1;
        ram[i] = 32'h04F52223;
        i = i + 1;
        ram[i] = 32'h05052423;
        i = i + 1;
        ram[i] = 32'h05152623;
        i = i + 1;
        ram[i] = 32'h05252823;
        i = i + 1;
        ram[i] = 32'h05352A23;
        i = i + 1;
        ram[i] = 32'h05452C23;
        i = i + 1;
        ram[i] = 32'h05552E23;
        i = i + 1;
        ram[i] = 32'h07652023;
        i = i + 1;
        ram[i] = 32'h07752223;
        i = i + 1;
        ram[i] = 32'h07852423;
        i = i + 1;
        ram[i] = 32'h07952623;
        i = i + 1;
        ram[i] = 32'h07A52823;
        i = i + 1;
        ram[i] = 32'h07B52A23;
        i = i + 1;
        ram[i] = 32'h07C52C23;
        i = i + 1;
        ram[i] = 32'h07D52E23;
        i = i + 1;
        ram[i] = 32'h09E52023;
        i = i + 1;
        ram[i] = 32'h09F52223;
        i = i + 1;
        ram[i] = 32'h340022F3;
        i = i + 1;
        ram[i] = 32'h02552823;
        i = i + 1;
        ram[i] = 32'h00052103;
        i = i + 1;
        ram[i] = 32'h00452283;
        i = i + 1;
        ram[i] = 32'h00028067;
        i = i + 1;
        ram[i] = 32'h341022F3;
        i = i + 1;
        ram[i] = 32'h80700337;
        i = i + 1;
        ram[i] = 32'h00532023;
        i = i + 1;
        ram[i] = 32'h03052283;
        i = i + 1;
        ram[i] = 32'h34029073;
        i = i + 1;
        ram[i] = 32'h00C52083;
        i = i + 1;
        ram[i] = 32'h01052103;
        i = i + 1;
        ram[i] = 32'h01452183;
        i = i + 1;
        ram[i] = 32'h01852203;
        i = i + 1;
        ram[i] = 32'h01C52283;
        i = i + 1;
        ram[i] = 32'h02052303;
        i = i + 1;
        ram[i] = 32'h02452383;
        i = i + 1;
        ram[i] = 32'h02852403;
        i = i + 1;
        ram[i] = 32'h02C52483;
        i = i + 1;
        ram[i] = 32'h03452583;
        i = i + 1;
        ram[i] = 32'h03852603;
        i = i + 1;
        ram[i] = 32'h03C52683;
        i = i + 1;
        ram[i] = 32'h04052703;
        i = i + 1;
        ram[i] = 32'h04452783;
        i = i + 1;
        ram[i] = 32'h04852803;
        i = i + 1;
        ram[i] = 32'h04C52883;
        i = i + 1;
        ram[i] = 32'h05052903;
        i = i + 1;
        ram[i] = 32'h05452983;
        i = i + 1;
        ram[i] = 32'h05852A03;
        i = i + 1;
        ram[i] = 32'h05C52A83;
        i = i + 1;
        ram[i] = 32'h06052B03;
        i = i + 1;
        ram[i] = 32'h06452B83;
        i = i + 1;
        ram[i] = 32'h06852C03;
        i = i + 1;
        ram[i] = 32'h06C52C83;
        i = i + 1;
        ram[i] = 32'h07052D03;
        i = i + 1;
        ram[i] = 32'h07452D83;
        i = i + 1;
        ram[i] = 32'h07852E03;
        i = i + 1;
        ram[i] = 32'h07C52E83;
        i = i + 1;
        ram[i] = 32'h08052F03;
        i = i + 1;
        ram[i] = 32'h08452F83;
        i = i + 1;
        ram[i] = 32'h34051573;
        i = i + 1;
        ram[i] = 32'h30200073;
        i = i + 1;
        ram[i] = 32'h30002573;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'h30051073;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'h34102573;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'h34151073;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'h34202573;
        i = i + 1;
        ram[i] = 32'h00008067;
        i = i + 1;
        ram[i] = 32'h34251073;
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
