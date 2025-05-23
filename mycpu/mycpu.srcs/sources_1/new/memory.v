`timescale 1ns / 1ps
`include "params.v"
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
    input [2:0] D_load_width,
    input D_load_un,

    input [7:0] sws_l,
    input [7:0] sws_r,

    input [4:0] bts_state,

    output reg [31:0] seg_display_hex,

    output reg [7:0] leds_l,
    output reg [7:0] leds_r,

    input clk_pixel,
    input [31:0] vga_addr,
    output [31:0] vga_data,

    input [7:0] key_code,

    input [7:0] uart_rx_data,
    output reg [7:0] uart_tx_data,
    output uart_read,
    output uart_write,
    input uart_rx_ready,
    input uart_tx_ready,
    output reg [31:0] uart_ctrl
);
    wire store, load;
    wire [1:0] byte_offset;
    wire [31:0] load_word;
    wire [31:0] mem_load_word, vga_load_word, uart_load_word;
    wire [31:0] mem_store_data;
    wire [3:0] we, web, wevga;
    wire io_en;
    wire [10:0] io_sel;
    wire [31:0] io_load_word;
    wire [3:0] uart_sel;

`ifdef SIMULATION
    my_blk_mem main_memory(
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
        .dinb(mem_store_data),
        .doutb(mem_load_word)
    );
`else
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
        .dinb(mem_store_data),
        .doutb(mem_load_word)
    );
`endif

    localparam [10:0] SYS_INFO      = 11'd0;    // r_
    localparam [10:0] LED           = 11'd2;    // _w
    localparam [10:0] SW            = 11'd3;    // r_
    localparam [10:0] VGA           = 11'd4;    // rw
    localparam [10:0] KEYBOARD      = 11'd5;    // r_
    localparam [10:0] BUTTON        = 11'd6;    // r_
    localparam [10:0] SEG_DISPLAY   = 11'd7;    // _w
    localparam [10:0] UART          = 11'd8;    // rw

    localparam [3:0] UART_DATA_REG      = 4'd0;
    localparam [3:0] UART_STATUS_REG    = 4'd1;
    localparam [3:0] UART_CONTROL_REG   = 4'd2;

    /*
        D_load_data <---part_select--- load_word <-----io_en--- mem_load_word <------------ main memory
                                                    |
                                                    --!io_en--- io_load_word  <---io_sel--- I/Os
    */
    
    assign byte_offset = D_addr[1:0];
    assign store = D_store_width != 2'h3;
    assign load  = D_load_width  != 3'h3;

    // select from uart data register and uart status register
    assign uart_sel = D_addr[5:2];
    // 
    assign uart_read = (io_sel == UART) & (uart_sel == UART_DATA_REG) & load;
    assign uart_write = (io_sel == UART) & (uart_sel == UART_DATA_REG) & store;

    // io_en: the instruction is accessing memory mapped I/O
    assign io_en = D_addr[31];
    // io_sel: select a type of I/O
    assign io_sel = D_addr[30:20];
    // io_load_word: the data loaded from memory mapped I/O
    assign io_load_word = io_sel == SYS_INFO    ? 32'h0 :
                          io_sel == SW          ? {16'h0, sws_l, sws_r} : 
                          io_sel == VGA         ? vga_load_word :
                          io_sel == KEYBOARD    ? {24'h0, key_code} :
                          io_sel == BUTTON      ? {27'h0, bts_state} :
                          io_sel == UART        ? uart_load_word :
                          32'h0;

    assign uart_load_word = uart_sel == UART_DATA_REG ? {24'b0, uart_rx_data} :
                            uart_sel == UART_STATUS_REG ? {30'b0, uart_tx_ready, uart_rx_ready} :
                            uart_sel == UART_CONTROL_REG ? uart_ctrl :
                            32'h0;

    // load_word: the 32-bit data loaded from either the main memory or the I/O
    assign load_word = io_en ? io_load_word : mem_load_word;

    // D_load_data: the part-selected data of load_word
    assign D_load_data = (D_load_width == `LOAD_BYTE | D_load_width == `LOAD_BYTE_UN) ? (byte_offset == 2'h0 ? {(D_load_un ? {24{1'b0}} : {24{load_word[7]}}), load_word[7:0]} :
                                                                                         byte_offset == 2'h1 ? {(D_load_un ? {24{1'b0}} : {24{load_word[15]}}), load_word[15:8]} :
                                                                                         byte_offset == 2'h2 ? {(D_load_un ? {24{1'b0}} : {24{load_word[24]}}), load_word[23:16]} :
                                                                                         byte_offset == 2'h3 ? {(D_load_un ? {24{1'b0}} : {24{load_word[31]}}), load_word[31:24]} : 32'h0) :
                         (D_load_width == `LOAD_HALF | D_load_width == `LOAD_HALF_UN) ? (byte_offset == 2'h0 ? {(D_load_un ? {16{1'b0}} : {16{load_word[15]}}), load_word[15:0]} :
                                                                                         byte_offset == 2'h2 ? {(D_load_un ? {16{1'b0}} : {16{load_word[31]}}), load_word[31:16]} : 32'h0) :
                          D_load_width == `LOAD_WORD ? (byte_offset == 2'h0 ? load_word : 32'h0) : 
                                                                                          32'h0;

    // we: global write enable signal, determined directly by the store width and the byte offset
    assign we = D_store_width == `STORE_BYTE ? (4'b1 << byte_offset) :                                     // sb
                D_store_width == `STORE_HALF ? (byte_offset == 2'h0 ? 4'b0011 :                            // sh
                                                byte_offset == 2'h2 ? 4'b1100 : 4'b0000) :
                D_store_width == `STORE_WORD ? (byte_offset == 2'h0 ? 4'b1111 : 4'b0000) :                 // sw
                4'b0000;
    // web: write enable signal for the data memory, cleared when accessing I/O
    assign web = io_en ? 4'b0000 : we;
    // wevga: write enable signal for the VGA memory, set when accessing the VGA memory
    assign wevga = (io_en & (io_sel == VGA)) ? we : 4'b0000;

    // mem_store_data: the data to be stored in the memory, determined by the store width and the byte offset
    assign mem_store_data = D_store_width == `STORE_BYTE ? (byte_offset == 2'h0 ? {24'b0, D_store_data[7:0]} :
                                                            byte_offset == 2'h1 ? {16'b0, D_store_data[7:0], 8'b0} :
                                                            byte_offset == 2'h2 ? {8'b0, D_store_data[7:0], 16'b0} :
                                                            byte_offset == 2'h3 ? {D_store_data[7:0], 24'b0} : 32'h0) :
                            D_store_width == `STORE_HALF ? (byte_offset == 2'h0 ? {16'b0, D_store_data[15:0]} :
                                                            byte_offset == 2'h2 ? {D_store_data[15:0], 16'b0} : 32'h0) :
                            D_store_width == `STORE_WORD ? (byte_offset == 2'h0 ? D_store_data : 32'h0) : 
                                                            32'h0;

    always @(posedge clk) begin
        if (reset) begin
            leds_l <= 8'b0;
            leds_r <= 8'b0;
            seg_display_hex <= 32'h0;
            uart_tx_data <= 8'h0;
            uart_ctrl <= `CLK_MAIN_FREQ / `UART_FREQ;
        end else begin
            if (io_en & store) begin
                // here lists all the writable I/O
                case (io_sel)
                    LED: begin
                        if (we[0]) leds_r <= mem_store_data[7:0];
                        if (we[1]) leds_l <= mem_store_data[15:8];
                    end
                    SEG_DISPLAY: begin
                        if (we[0]) seg_display_hex[7:0]   <= mem_store_data[7:0];
                        if (we[1]) seg_display_hex[15:8]  <= mem_store_data[15:8];
                        if (we[2]) seg_display_hex[23:16] <= mem_store_data[23:16];
                        if (we[3]) seg_display_hex[31:24] <= mem_store_data[31:24];
                    end
                    UART: begin
                        case (uart_sel)
                            UART_DATA_REG: begin
                                if (we[0]) uart_tx_data <= mem_store_data[7:0];
                            end
                            UART_CONTROL_REG: begin
                                if (we[0]) uart_ctrl[7:0]   <= mem_store_data[7:0];
                                if (we[1]) uart_ctrl[15:8]  <= mem_store_data[15:8];
                                if (we[2]) uart_ctrl[23:16] <= mem_store_data[23:16];
                                if (we[3]) uart_ctrl[31:24] <= mem_store_data[31:24];
                            end
                        endcase
                    end
                endcase
            end
        end
    end

    `ifdef VGA
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
            .dinb(mem_store_data),
            .doutb(vga_load_word)
        );
    `endif

endmodule