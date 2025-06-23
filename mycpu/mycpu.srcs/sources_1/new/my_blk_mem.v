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

    // Initialize memory from instruction file
    integer i, file, status;
    reg [31:0] instruction;
    initial begin
        // Initialize all memory locations to 0 first
        for (i = 0; i < 12288; i = i + 1) begin
            ram[i] = 32'h0;
        end

        // Determine starting address based on configuration
        `ifdef LOAD_AT_0X200
            i = 32'h80;  // 0x200/4 = 0x80 (word address)
        `else
            i = 32'h0;
        `endif

        // Open the instruction file
        file = $fopen("../../../../mycpu.srcs/sources_1/new/program.hex", "r");
        if (file == 0) begin
            $display("Error: Failed to open instruction file!");
        end else begin
            // Read instructions from file line by line
            while (!$feof(file)) begin
                status = $fscanf(file, "%h\n", instruction);
                if (status == 1) begin  // Successfully read an instruction
                    ram[i] = instruction;
                    i = i + 1;
                end
            end
            $fclose(file);
            $display("Program loaded successfully!", i);
        end
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
            if (wea != 4'b0000) begin
                douta <= dina;  // If writing, output the written data
            end else begin
                // If not writing, read from memory
                douta <= ram[addra];
            end
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
            if (web != 4'b0000) begin
                doutb <= dinb;  // If writing, output the written data
            end else begin
                // If not writing, read from memory
                doutb <= ram[addrb];
            end

        end
    end

endmodule
