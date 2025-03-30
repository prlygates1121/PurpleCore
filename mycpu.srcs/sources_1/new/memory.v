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
    output [7:1] leds_r
);
    localparam [3:0] LED = 4'h0;
    localparam [3:0] SW = 4'h1;

    // io_en: the instruction is accessing memory mapped I/O
    wire io_en = D_addr[31:20] == 12'hFFF;
    // io_sel: select a type of I/O
    wire io_sel = D_addr[19:16];
    reg [31:0] io_load_word;

    wire store = D_store_width != 2'h3;
    wire load = D_load_width != 2'h3;
    wire [1:0] byte_offset = D_addr[1:0];
    wire [31:0] load_word;
    wire [3:0] web;

    blk_mem main_memory(
        .clka(~clk),
        .ena(I_en),
        .wea(I_write_en),
        .addra(I_addr[16:2]),
        .dina(I_store_data),
        .douta(I_load_data),
        .clkb(~clk),
        .enb(D_en),
        .web(web),
        .addrb(D_addr[16:2]),
        .dinb(D_store_data),
        .doutb(load_word)
    );

    assign D_load_data = io_en ? {16'h0000, sws_l, sws_r} : (D_load_width == 2'h0 ? (byte_offset == 2'h0 ? {(D_load_un ? {24{1'b0}} : {24{load_word[7]}}), load_word[7:0]} :
                                                                                     byte_offset == 2'h1 ? {(D_load_un ? {24{1'b0}} : {24{load_word[15]}}), load_word[15:8]} :
                                                                                     byte_offset == 2'h2 ? {(D_load_un ? {24{1'b0}} : {24{load_word[24]}}), load_word[24:15]} :
                                                                                     byte_offset == 2'h3 ? {(D_load_un ? {24{1'b0}} : {24{load_word[31]}}), load_word[31:24]} : {32{1'b0}}) :
                                                             D_load_width == 2'h1 ? (byte_offset == 2'h0 ? {(D_load_un ? {16{1'b0}} : {16{load_word[15]}}), load_word[15:0]} :
                                                                                     byte_offset == 2'h2 ? {(D_load_un ? {16{1'b0}} : {16{load_word[31]}}), load_word[31:16]} : {32{1'b0}}) :
                                                             D_load_width == 2'h2 ? (byte_offset == 2'h0 ? load_word : {32{1'b0}}) : load_word);

    assign web = io_en ? 4'b0000 : (D_store_width == 2'h0 ? (1'b1 << byte_offset) :                                     // sb
                                    D_store_width == 2'h1 ? (byte_offset == 2'h0 ? 4'b0011 :                            // sh
                                                           byte_offset == 2'h2 ? 4'b1100 : 4'b0000) :
                                    D_store_width == 2'h2 ? (byte_offset == 2'h0 ? 4'b1111 : 4'b0000) :                 // sw
                                    4'b0000);

    reg [7:0] leds_l_reg;
    reg [7:1] leds_r_reg;

    always @(posedge clk) begin
        if (reset) begin
            leds_l_reg <= 8'b0;
            leds_r_reg[7:1] <= 7'b0;
            // io_load_word <= 8'b0;
        end else begin
            if (io_en) begin
                if (D_store_width == 2'h2) begin
                    case (io_sel)
                        LED: begin
                            leds_l_reg <= D_addr[15:8];
                            leds_r_reg[7:1] <= D_addr[7:1];
                        end
                    endcase
                end else if (D_load_width == 2'h2) begin
                    case (io_sel)
                        SW: begin
                            // io_load_word <= {16'h0000, sws_l, sws_r};
                        end
                    endcase
                end
            end
        end
    end

    assign leds_l = leds_l_reg;
    assign leds_r = leds_r_reg;


endmodule