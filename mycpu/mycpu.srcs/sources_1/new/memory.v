`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2025 08:47:52 PM
// Design Name: 
// Module Name: memory
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


module memory(
    input clk,
    input reset,

    input I_en,
    input [3:0] I_write_en,
    input [31:0] I_addr,
    input [31:0] I_store_data,
    output [31:0] I_load_data,

    input D_en,
    input [31:0] D_addr,
    input [31:0] D_store_data,
    output [31:0] D_load_data,

    input [1:0] D_store_width,
    input [1:0] D_load_width,
    input D_load_un,

    input [7:0] sws_l,
    input [7:0] sws_r,

    output [7:0] leds_l,
    output [7:1] leds_r,

    input clk_pixel,
    input [31:0] vga_addr,
    output [31:0] vga_data
);
    localparam [2:0] LED = 3'h0;
    localparam [2:0] SW = 3'h1;
    localparam [2:0] VGA = 3'h2;

    // io_en: the instruction is accessing memory mapped I/O
    wire io_en = D_addr[31];
    // io_sel: select a type of I/O
    wire [2:0] io_sel = D_addr[30:28];
    // io_load_word: the data to be loaded from memory mapped I/O
    wire [31:0] io_load_word;

    wire store = D_store_width != 2'h3;
    wire load = D_load_width != 2'h3;
    wire [1:0] byte_offset = D_addr[1:0];
    wire [31:0] load_word;
    wire [3:0] we, web, wevga;

    blk_mem main_memory(
        .clka(~clk),
        .ena(I_en),
        .wea(I_write_en),
        .addra(I_addr[15:2]),
        .dina(I_store_data),
        .douta(I_load_data),
        .clkb(~clk),
        .enb(D_en),
        .web(web),
        .addrb(D_addr[15:2]),
        .dinb(D_store_data),
        .doutb(load_word)
    );

    assign D_load_data = io_en ? io_load_word : (D_load_width == 2'h0 ? (byte_offset == 2'h0 ? {(D_load_un ? {24{1'b0}} : {24{load_word[7]}}), load_word[7:0]} :
                                                                         byte_offset == 2'h1 ? {(D_load_un ? {24{1'b0}} : {24{load_word[15]}}), load_word[15:8]} :
                                                                         byte_offset == 2'h2 ? {(D_load_un ? {24{1'b0}} : {24{load_word[24]}}), load_word[24:15]} :
                                                                         byte_offset == 2'h3 ? {(D_load_un ? {24{1'b0}} : {24{load_word[31]}}), load_word[31:24]} : {32{1'b0}}) :
                                                 D_load_width == 2'h1 ? (byte_offset == 2'h0 ? {(D_load_un ? {16{1'b0}} : {16{load_word[15]}}), load_word[15:0]} :
                                                                         byte_offset == 2'h2 ? {(D_load_un ? {16{1'b0}} : {16{load_word[31]}}), load_word[31:16]} : {32{1'b0}}) :
                                                 D_load_width == 2'h2 ? (byte_offset == 2'h0 ? load_word : {32{1'b0}}) : load_word);

    assign we = D_store_width == 2'h0 ? (1'b1 << byte_offset) :                                     // sb
                D_store_width == 2'h1 ? (byte_offset == 2'h0 ? 4'b0011 :                            // sh
                                         byte_offset == 2'h2 ? 4'b1100 : 4'b0000) :
                D_store_width == 2'h2 ? (byte_offset == 2'h0 ? 4'b1111 : 4'b0000) :                 // sw
                4'b0000;
    assign web = io_en ? 4'b0000 : we;
    assign wevga = io_en & (io_sel == VGA) ? we : 4'b0000;

    assign io_load_word = io_sel == LED ? {16'h0000, sws_l, sws_r} : 
                          io_sel == SW ? {16'h0000, sws_l, sws_r} : 
                          32'h0;

    reg [7:0] leds_l_reg;
    reg [7:1] leds_r_reg;

    always @(posedge clk) begin
        if (reset) begin
            leds_l_reg <= 8'b0;
            leds_r_reg[7:1] <= 7'b0;
        end else begin
            if (io_en) begin
                if (D_store_width == 2'h2) begin
                    case (io_sel)
                        LED: begin
                            leds_l_reg <= D_addr[15:8];
                            leds_r_reg[7:1] <= D_addr[7:1];
                        end
                    endcase
                end
            end
        end
    end

    assign leds_l = leds_l_reg;
    assign leds_r = leds_r_reg;

    blk_mem_vga vga_memory(
        // ports by which VGA controller reads data from memory
        .clka(~clk_pixel),
        .ena(1'b1),
        .wea(4'b0),
        .addra(vga_addr[17:2]), // valid vga address is 17 bits
        .dina(32'h0),
        .douta(vga_data),

        // ports by which CPU writes data to memory
        .clkb(~clk),
        .enb(1'b1),
        .web(wevga),
        .addrb(D_addr[17:2]),   // valid vga address is 17 bits
        .dinb(D_store_data),
        .doutb()
    );


endmodule