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
    input uart_tx_ready
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
    localparam [10:0] ASCII         = 11'd1;    // r_
    localparam [10:0] LED           = 11'd2;    // _w
    localparam [10:0] SW            = 11'd3;    // r_
    localparam [10:0] VGA           = 11'd4;    // rw
    localparam [10:0] KEYBOARD      = 11'd5;    // r_
    localparam [10:0] BUTTON        = 11'd6;    // r_
    localparam [10:0] SEG_DISPLAY   = 11'd7;    // _w
    localparam [10:0] UART          = 11'd8;    // rw

    localparam [3:0] UART_DATA_REG      = 4'd0;
    localparam [3:0] UART_STATUS_REG    = 4'd1;

    /*
        D_load_data <---part_select--- load_word <-----io_en--- mem_load_word <------------ main memory
                                                    |
                                                    --!io_en--- io_load_word  <---io_sel--- I/Os
    */

    reg [63:0] ascii_data [95:0];
    
    assign byte_offset = D_addr[1:0];
    assign store = D_store_width != 2'h3;
    assign load  = D_load_width  != 2'h3;

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
                          io_sel == ASCII       ? (D_addr[2] ? ascii_data[D_addr[9:3]][63:32] : ascii_data[D_addr[9:3]][31:0]) :
                          io_sel == SW          ? {16'h0, sws_l, sws_r} : 
                          io_sel == VGA         ? vga_load_word :
                          io_sel == KEYBOARD    ? {24'h0, key_code} :
                          io_sel == BUTTON      ? {27'h0, bts_state} :
                          io_sel == UART        ? uart_load_word :
                          32'h0;

    assign uart_load_word = uart_sel == UART_DATA_REG ? {24'b0, uart_rx_data} :
                            uart_sel == UART_STATUS_REG ? {30'b0, uart_tx_ready, uart_rx_ready} :
                            32'h0;

    // load_word: the 32-bit data loaded from either the main memory or the I/O
    assign load_word = io_en ? io_load_word : mem_load_word;

    // D_load_data: the part-selected data of load_word
    assign D_load_data = (D_load_width == `LOAD_BYTE | D_load_width == `LOAD_BYTE_UN) ? (byte_offset == 2'h0 ? {(D_load_un ? {24{1'b0}} : {24{load_word[7]}}), load_word[7:0]} :
                                                                                         byte_offset == 2'h1 ? {(D_load_un ? {24{1'b0}} : {24{load_word[15]}}), load_word[15:8]} :
                                                                                         byte_offset == 2'h2 ? {(D_load_un ? {24{1'b0}} : {24{load_word[24]}}), load_word[23:16]} :
                                                                                         byte_offset == 2'h3 ? {(D_load_un ? {24{1'b0}} : {24{load_word[31]}}), load_word[31:24]} : {32{1'b0}}) :
                         (D_load_width == `LOAD_HALF | D_load_width == `LOAD_HALF_UN) ? (byte_offset == 2'h0 ? {(D_load_un ? {16{1'b0}} : {16{load_word[15]}}), load_word[15:0]} :
                                                                                         byte_offset == 2'h2 ? {(D_load_un ? {16{1'b0}} : {16{load_word[31]}}), load_word[31:16]} : {32{1'b0}}) :
                          D_load_width == `LOAD_WORD ? (byte_offset == 2'h0 ? load_word : {32{1'b0}}) : 
                                                                                         load_word;

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
        end else begin
            if (io_en) begin
                // memory mapped I/O can be stored in words only
                // here lists all the writable I/O registers
                if (D_store_width == `STORE_WORD) begin
                    case (io_sel)
                        LED: begin
                            {leds_l, leds_r} <= mem_store_data[15:0];
                        end
                        SEG_DISPLAY: begin
                            seg_display_hex <= mem_store_data;
                        end
                        UART: begin
                            if (uart_sel == UART_DATA_REG) begin
                                uart_tx_data <= mem_store_data[7:0];
                            end
                        end
                    endcase
                end
            end
        end
    end

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

    always @(posedge clk) begin
        if (reset) begin
            ascii_data[`SPACE        ] <= 64'h0000000000000000;   // U+0020 (space)
            ascii_data[`EXCLAMATION  ] <= 64'h00180018183c3c18;   // U+0021 (!)
            ascii_data[`QUOTE        ] <= 64'h0000000000003636;   // U+0022 (")
            ascii_data[`HASH         ] <= 64'h0036367f367f3636;   // U+0023 (#)
            ascii_data[`DOLLAR       ] <= 64'h000c1f301e033e0c;   // U+0024 ($)
            ascii_data[`PERCENT      ] <= 64'h0063660c18336300;   // U+0025 (%)
            ascii_data[`AMPERSAND    ] <= 64'h006e333b6e1c361c;   // U+0026 (&)
            ascii_data[`APOSTROPHE   ] <= 64'h0000000000030606;   // U+0027 (')
            ascii_data[`L_PARENTHESIS] <= 64'h00180c0606060c18;   // U+0028 (()
            ascii_data[`R_PARENTHESIS] <= 64'h00060c1818180c06;   // U+0029 ())
            ascii_data[`ASTERISK     ] <= 64'h0000663cff3c6600;   // U+002A (*)
            ascii_data[`PLUS         ] <= 64'h00000c0c3f0c0c00;   // U+002B (+)
            ascii_data[`COMMA        ] <= 64'h060c0c0000000000;   // U+002C (,)
            ascii_data[`HYPHEN       ] <= 64'h000000003f000000;   // U+002D (-)
            ascii_data[`PERIOD       ] <= 64'h000c0c0000000000;   // U+002E (.)
            ascii_data[`SLASH        ] <= 64'h000103060c183060;   // U+002F (/)
            ascii_data[`ZERO         ] <= 64'h003e676f7b73633e;   // U+0030 (0)
            ascii_data[`ONE          ] <= 64'h003f0c0c0c0c0e0c;   // U+0031 (1)
            ascii_data[`TWO          ] <= 64'h003f33061c30331e;   // U+0032 (2)
            ascii_data[`THREE        ] <= 64'h001e33301c30331e;   // U+0033 (3)
            ascii_data[`FOUR         ] <= 64'h0078307f33363c38;   // U+0034 (4)
            ascii_data[`FIVE         ] <= 64'h001e3330301f033f;   // U+0035 (5)
            ascii_data[`SIX          ] <= 64'h001e33331f03061c;   // U+0036 (6)
            ascii_data[`SEVEN        ] <= 64'h000c0c0c1830333f;   // U+0037 (7)
            ascii_data[`EIGHT        ] <= 64'h001e33331e33331e;   // U+0038 (8)
            ascii_data[`NINE         ] <= 64'h000e18303e33331e;   // U+0039 (9)
            ascii_data[`COLON        ] <= 64'h000c0c00000c0c00;   // U+003A (:)
            ascii_data[`SEMICOLON    ] <= 64'h060c0c00000c0c00;   // U+003B (;)
            ascii_data[`LESS         ] <= 64'h00180c0603060c18;   // U+003C (<)
            ascii_data[`EQUAL        ] <= 64'h00003f00003f0000;   // U+003D (=)
            ascii_data[`GREATER      ] <= 64'h00060c1830180c06;   // U+003E (>)
            ascii_data[`QUESTION     ] <= 64'h000c000c1830331e;   // U+003F (?)
            ascii_data[`AT           ] <= 64'h001e037b7b7b633e;   // U+0040 (@)
            ascii_data[`A            ] <= 64'h0033333f33331e0c;   // U+0041 (A)
            ascii_data[`B            ] <= 64'h003f66663e66663f;   // U+0042 (B)
            ascii_data[`C            ] <= 64'h003c66030303663c;   // U+0043 (C)
            ascii_data[`D            ] <= 64'h001f36666666361f;   // U+0044 (D)
            ascii_data[`E            ] <= 64'h007f46161e16467f;   // U+0045 (E)
            ascii_data[`F            ] <= 64'h000f06161e16467f;   // U+0046 (F)
            ascii_data[`G            ] <= 64'h007c66730303663c;   // U+0047 (G)
            ascii_data[`H            ] <= 64'h003333333f333333;   // U+0048 (H)
            ascii_data[`I            ] <= 64'h001e0c0c0c0c0c1e;   // U+0049 (I)
            ascii_data[`J            ] <= 64'h001e333330303078;   // U+004A (J)
            ascii_data[`K            ] <= 64'h006766361e366667;   // U+004B (K)
            ascii_data[`L            ] <= 64'h007f66460606060f;   // U+004C (L)
            ascii_data[`M            ] <= 64'h0063636b7f7f7763;   // U+004D (M)
            ascii_data[`N            ] <= 64'h006363737b6f6763;   // U+004E (N)
            ascii_data[`O            ] <= 64'h001c36636363361c;   // U+004F (O)
            ascii_data[`P            ] <= 64'h000f06063e66663f;   // U+0050 (P)
            ascii_data[`Q            ] <= 64'h00381e3b3333331e;   // U+0051 (Q)
            ascii_data[`R            ] <= 64'h006766363e66663f;   // U+0052 (R)
            ascii_data[`S            ] <= 64'h001e33380e07331e;   // U+0053 (S)
            ascii_data[`T            ] <= 64'h001e0c0c0c0c2d3f;   // U+0054 (T)
            ascii_data[`U            ] <= 64'h003f333333333333;   // U+0055 (U)
            ascii_data[`V            ] <= 64'h000c1e3333333333;   // U+0056 (V)
            ascii_data[`W            ] <= 64'h0063777f6b636363;   // U+0057 (W)
            ascii_data[`X            ] <= 64'h0063361c1c366363;   // U+0058 (X)
            ascii_data[`Y            ] <= 64'h001e0c0c1e333333;   // U+0059 (Y)
            ascii_data[`Z            ] <= 64'h007f664c1831637f;   // U+005A (Z)
            ascii_data[`L_BRACKET    ] <= 64'h001e06060606061e;   // U+005B ([)
            ascii_data[`BACKSLASH    ] <= 64'h00406030180c0603;   // U+005C (\)
            ascii_data[`R_BRACKET    ] <= 64'h001e18181818181e;   // U+005D (])
            ascii_data[`CARET        ] <= 64'h0000000063361c08;   // U+005E (^)
            ascii_data[`UNDERSCORE   ] <= 64'hff00000000000000;   // U+005F (_)
            ascii_data[`BACKTICK     ] <= 64'h0000000000180c0c;   // U+0060 (`)
            ascii_data[`a            ] <= 64'h006e333e301e0000;   // U+0061 (a)
            ascii_data[`b            ] <= 64'h003b66663e060607;   // U+0062 (b)
            ascii_data[`c            ] <= 64'h001e3303331e0000;   // U+0063 (c)
            ascii_data[`d            ] <= 64'h006e33333e303038;   // U+0064 (d)
            ascii_data[`e            ] <= 64'h001e033f331e0000;   // U+0065 (e)
            ascii_data[`f            ] <= 64'h000f06060f06361c;   // U+0066 (f)
            ascii_data[`g            ] <= 64'h1f303e33336e0000;   // U+0067 (g)
            ascii_data[`h            ] <= 64'h006766666e360607;   // U+0068 (h)
            ascii_data[`i            ] <= 64'h001e0c0c0c0e000c;   // U+0069 (i)
            ascii_data[`j            ] <= 64'h1e33333030300030;   // U+006A (j)
            ascii_data[`k            ] <= 64'h0067361e36660607;   // U+006B (k)
            ascii_data[`l            ] <= 64'h001e0c0c0c0c0c0e;   // U+006C (l)
            ascii_data[`m            ] <= 64'h00636b7f7f330000;   // U+006D (m)
            ascii_data[`n            ] <= 64'h00333333331f0000;   // U+006E (n)
            ascii_data[`o            ] <= 64'h001e3333331e0000;   // U+006F (o)
            ascii_data[`p            ] <= 64'h0f063e66663b0000;   // U+0070 (p)
            ascii_data[`q            ] <= 64'h78303e33336e0000;   // U+0071 (q)
            ascii_data[`r            ] <= 64'h000f06666e3b0000;   // U+0072 (r)
            ascii_data[`s            ] <= 64'h001f301e033e0000;   // U+0073 (s)
            ascii_data[`t            ] <= 64'h00182c0c0c3e0c08;   // U+0074 (t)
            ascii_data[`u            ] <= 64'h006e333333330000;   // U+0075 (u)
            ascii_data[`v            ] <= 64'h000c1e3333330000;   // U+0076 (v)
            ascii_data[`w            ] <= 64'h00367f7f6b630000;   // U+0077 (w)
            ascii_data[`x            ] <= 64'h0063361c36630000;   // U+0078 (x)
            ascii_data[`y            ] <= 64'h1f303e3333330000;   // U+0079 (y)
            ascii_data[`z            ] <= 64'h003f260c193f0000;   // U+007A (z)
            ascii_data[`L_BRACE      ] <= 64'h00380c0c070c0c38;   // U+007B ({)
            ascii_data[`PIPE         ] <= 64'h0018181800181818;   // U+007C (|)
            ascii_data[`R_BRACE      ] <= 64'h00070c0c380c0c07;   // U+007D (})
            ascii_data[`TILDE        ] <= 64'h0000000000003b6e;   // U+007E (~)
            ascii_data[`DELETE       ] <= 64'h0000000000000000;   // U+007F (delete)
        end
    end

endmodule