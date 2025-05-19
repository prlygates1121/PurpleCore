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
    output [31:0] douta,       // Data output for port A
    
    // Port B
    input clkb,                    // Clock for port B
    input enb,                     // Enable for port B
    input [3:0] web,               // Write enable for port B (byte-wise)
    input [13:0] addrb,            // Address for port B
    input [31:0] dinb,             // Data input for port B
    output [31:0] doutb        // Data output for port B
);

    // Memory array
    reg [31:0] ram [0:12287];

    // Initialize memory
    integer i;
    initial begin
        i = 0;
ram[i]=32'h00F00413;
i=i+1;
ram[i]=32'h0000A937;
i=i+1;
ram[i]=32'h00090913;
i=i+1;
ram[i]=32'h00090493;
i=i+1;
ram[i]=32'h00000293;
i=i+1;
ram[i]=32'h0054A023;
i=i+1;
ram[i]=32'h00448493;
i=i+1;
ram[i]=32'h00300293;
i=i+1;
ram[i]=32'h0054A023;
i=i+1;
ram[i]=32'h00448493;
i=i+1;
ram[i]=32'h00500293;
i=i+1;
ram[i]=32'h0054A023;
i=i+1;
ram[i]=32'h00448493;
i=i+1;
ram[i]=32'hFFF00293;
i=i+1;
ram[i]=32'h0054A023;
i=i+1;
ram[i]=32'h00448493;
i=i+1;
ram[i]=32'h00700293;
i=i+1;
ram[i]=32'h0054A023;
i=i+1;
ram[i]=32'h00448493;
i=i+1;
ram[i]=32'h00400293;
i=i+1;
ram[i]=32'h0054A023;
i=i+1;
ram[i]=32'h00448493;
i=i+1;
ram[i]=32'h00200293;
i=i+1;
ram[i]=32'h0054A023;
i=i+1;
ram[i]=32'h00448493;
i=i+1;
ram[i]=32'h00B00293;
i=i+1;
ram[i]=32'h0054A023;
i=i+1;
ram[i]=32'h00448493;
i=i+1;
ram[i]=32'hFFC00293;
i=i+1;
ram[i]=32'h0054A023;
i=i+1;
ram[i]=32'h00448493;
i=i+1;
ram[i]=32'h02A00293;
i=i+1;
ram[i]=32'h0054A023;
i=i+1;
ram[i]=32'h00448493;
i=i+1;
ram[i]=32'h00200293;
i=i+1;
ram[i]=32'h0054A023;
i=i+1;
ram[i]=32'h00448493;
i=i+1;
ram[i]=32'h00100293;
i=i+1;
ram[i]=32'h0054A023;
i=i+1;
ram[i]=32'h00448493;
i=i+1;
ram[i]=32'hF9D00293;
i=i+1;
ram[i]=32'h0054A023;
i=i+1;
ram[i]=32'h00448493;
i=i+1;
ram[i]=32'h04B00293;
i=i+1;
ram[i]=32'h0054A023;
i=i+1;
ram[i]=32'h00448493;
i=i+1;
ram[i]=32'h02C00293;
i=i+1;
ram[i]=32'h0054A023;
i=i+1;
ram[i]=32'h00090513;
i=i+1;
ram[i]=32'h00000593;
i=i+1;
ram[i]=32'hFFF40613;
i=i+1;
ram[i]=32'h0DC000EF;
i=i+1;
ram[i]=32'h00090513;
i=i+1;
ram[i]=32'h00040593;
i=i+1;
ram[i]=32'h140000EF;
i=i+1;
ram[i]=32'h0000006F;
i=i+1;
ram[i]=32'h00259293;
i=i+1;
ram[i]=32'h00A282B3;
i=i+1;
ram[i]=32'h0002A383;
i=i+1;
ram[i]=32'h00261313;
i=i+1;
ram[i]=32'h00A30333;
i=i+1;
ram[i]=32'h00032E03;
i=i+1;
ram[i]=32'h01C2A023;
i=i+1;
ram[i]=32'h00732023;
i=i+1;
ram[i]=32'h00008067;
i=i+1;
ram[i]=32'hFE410113;
i=i+1;
ram[i]=32'h00112023;
i=i+1;
ram[i]=32'h00812223;
i=i+1;
ram[i]=32'h00912423;
i=i+1;
ram[i]=32'h01212623;
i=i+1;
ram[i]=32'h01312823;
i=i+1;
ram[i]=32'h01412A23;
i=i+1;
ram[i]=32'h01512C23;
i=i+1;
ram[i]=32'h00060A93;
i=i+1;
ram[i]=32'h002A9413;
i=i+1;
ram[i]=32'h00A40433;
i=i+1;
ram[i]=32'h00042403;
i=i+1;
ram[i]=32'hFFF58493;
i=i+1;
ram[i]=32'h00058913;
i=i+1;
ram[i]=32'h001A8993;
i=i+1;
ram[i]=32'h03390A63;
i=i+1;
ram[i]=32'h00291A13;
i=i+1;
ram[i]=32'h00AA0A33;
i=i+1;
ram[i]=32'h000A2A03;
i=i+1;
ram[i]=32'h008A4663;
i=i+1;
ram[i]=32'h00190913;
i=i+1;
ram[i]=32'hFE9FF06F;
i=i+1;
ram[i]=32'h00148493;
i=i+1;
ram[i]=32'h00048593;
i=i+1;
ram[i]=32'h00090613;
i=i+1;
ram[i]=32'hF79FF0EF;
i=i+1;
ram[i]=32'h00190913;
i=i+1;
ram[i]=32'hFD1FF06F;
i=i+1;
ram[i]=32'h00148593;
i=i+1;
ram[i]=32'h000A8613;
i=i+1;
ram[i]=32'hF65FF0EF;
i=i+1;
ram[i]=32'h00058513;
i=i+1;
ram[i]=32'h00012083;
i=i+1;
ram[i]=32'h00412403;
i=i+1;
ram[i]=32'h00812483;
i=i+1;
ram[i]=32'h00C12903;
i=i+1;
ram[i]=32'h01012983;
i=i+1;
ram[i]=32'h01412A03;
i=i+1;
ram[i]=32'h01812A83;
i=i+1;
ram[i]=32'h01C10113;
i=i+1;
ram[i]=32'h00008067;
i=i+1;
ram[i]=32'h00C5C463;
i=i+1;
ram[i]=32'h00008067;
i=i+1;
ram[i]=32'hFEC10113;
i=i+1;
ram[i]=32'h00112023;
i=i+1;
ram[i]=32'h00812223;
i=i+1;
ram[i]=32'h00912423;
i=i+1;
ram[i]=32'h01212623;
i=i+1;
ram[i]=32'h01312823;
i=i+1;
ram[i]=32'h00050413;
i=i+1;
ram[i]=32'h00058493;
i=i+1;
ram[i]=32'h00060913;
i=i+1;
ram[i]=32'hF31FF0EF;
i=i+1;
ram[i]=32'h00050993;
i=i+1;
ram[i]=32'h00040513;
i=i+1;
ram[i]=32'h00048593;
i=i+1;
ram[i]=32'hFFF98613;
i=i+1;
ram[i]=32'hFC1FF0EF;
i=i+1;
ram[i]=32'h00040513;
i=i+1;
ram[i]=32'h00198593;
i=i+1;
ram[i]=32'h00090613;
i=i+1;
ram[i]=32'hFB1FF0EF;
i=i+1;
ram[i]=32'h00012083;
i=i+1;
ram[i]=32'h00412403;
i=i+1;
ram[i]=32'h00812483;
i=i+1;
ram[i]=32'h00C12903;
i=i+1;
ram[i]=32'h01012983;
i=i+1;
ram[i]=32'h01410113;
i=i+1;
ram[i]=32'h00008067;
i=i+1;
ram[i]=32'h00000293;
i=i+1;
ram[i]=32'h00050393;
i=i+1;
ram[i]=32'h00B28C63;
i=i+1;
ram[i]=32'h00229313;
i=i+1;
ram[i]=32'h00730333;
i=i+1;
ram[i]=32'h00032503;
i=i+1;
ram[i]=32'h00128293;
i=i+1;
ram[i]=32'hFEDFF06F;
i=i+1;
ram[i]=32'h00008067;






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
        end
    end
    
    assign douta = ram[addra];

    // Port B logic
    always @(posedge clkb) begin
        if (enb) begin
            // Byte-wise write enable
            if (web[0]) ram[addrb][7:0] <= dinb[7:0];
            if (web[1]) ram[addrb][15:8] <= dinb[15:8];
            if (web[2]) ram[addrb][23:16] <= dinb[23:16];
            if (web[3]) ram[addrb][31:24] <= dinb[31:24];
            
        end
    end
    
    assign doutb = ram[addrb];


endmodule
