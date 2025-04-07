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
    input [1:0] D_load_width,
    input D_load_un,

    input [7:0] sws_l,
    input [7:0] sws_r,

    output [7:0] leds_l,
    output [7:0] leds_r,

    input clk_pixel,
    input [31:0] vga_addr,
    output [31:0] vga_data
);
    wire store = D_store_width != 2'h3;
    wire load = D_load_width != 2'h3;
    wire [1:0] byte_offset = D_addr[1:0];
    wire [31:0] mem_load_word, vga_load_word;
    wire [31:0] mem_store_data;
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
        .dinb(mem_store_data),
        .doutb(mem_load_word)
    );

    localparam [10:0] SYS_INFO = 11'd0;
    localparam [10:0] LED      = 11'd1;
    localparam [10:0] SW       = 11'd2;
    localparam [10:0] VGA      = 11'd3;
    localparam [10:0] ASCII    = 11'd4;

    // io_en: the instruction is accessing memory mapped I/O
    wire io_en = D_addr[31];
    // io_sel: select a type of I/O
    wire [10:0] io_sel = D_addr[30:20];
    // io_load_word: the data loaded from memory mapped I/O
    wire [31:0] io_load_word = io_sel == SYS_INFO    ? 32'h0 :
                               io_sel == LED         ? {16'h0000, leds_l_reg, leds_r_reg} : 
                               io_sel == SW          ? {16'h0000, sws_l, sws_r} : 
                               io_sel == VGA         ? vga_load_word :
                               io_sel == ASCII       ? (D_addr[2] ? ascii_data[D_addr[9:3]][63:32] : ascii_data[D_addr[9:3]][31:0]) :
                               32'h0;

    // load_word: the 32-bit data loaded from either the main memory or the I/O
    wire [31:0] load_word = io_en ? io_load_word : mem_load_word;

    // D_load_data: the part-selected data of load_word
    assign D_load_data = D_load_width == 2'h0 ? (byte_offset == 2'h0 ? {(D_load_un ? {24{1'b0}} : {24{load_word[7]}}), load_word[7:0]} :
                                                 byte_offset == 2'h1 ? {(D_load_un ? {24{1'b0}} : {24{load_word[15]}}), load_word[15:8]} :
                                                 byte_offset == 2'h2 ? {(D_load_un ? {24{1'b0}} : {24{load_word[24]}}), load_word[23:16]} :
                                                 byte_offset == 2'h3 ? {(D_load_un ? {24{1'b0}} : {24{load_word[31]}}), load_word[31:24]} : {32{1'b0}}) :
                         D_load_width == 2'h1 ? (byte_offset == 2'h0 ? {(D_load_un ? {16{1'b0}} : {16{load_word[15]}}), load_word[15:0]} :
                                                 byte_offset == 2'h2 ? {(D_load_un ? {16{1'b0}} : {16{load_word[31]}}), load_word[31:16]} : {32{1'b0}}) :
                         D_load_width == 2'h2 ? (byte_offset == 2'h0 ? load_word : {32{1'b0}}) : load_word;

    // we: global write enable signal, determined directly by the store width and the byte offset
    assign we = D_store_width == 2'h0 ? (4'b1 << byte_offset) :                                     // sb
                D_store_width == 2'h1 ? (byte_offset == 2'h0 ? 4'b0011 :                            // sh
                                         byte_offset == 2'h2 ? 4'b1100 : 4'b0000) :
                D_store_width == 2'h2 ? (byte_offset == 2'h0 ? 4'b1111 : 4'b0000) :                 // sw
                4'b0000;
    // web: write enable signal for the data memory, cleared when accessing I/O
    assign web = io_en ? 4'b0000 : we;
    // wevga: write enable signal for the VGA memory, set when accessing the VGA memory
    assign wevga = (io_en & (io_sel == VGA)) ? we : 4'b0000;

    // mem_store_data: the data to be stored in the memory, determined by the store width and the byte offset
    assign mem_store_data = D_store_width == 2'h0 ? (byte_offset == 2'h0 ? {24'b0, D_store_data[7:0]} :
                                                     byte_offset == 2'h1 ? {16'b0, D_store_data[7:0], 8'b0} :
                                                     byte_offset == 2'h2 ? {8'b0, D_store_data[7:0], 16'b0} :
                                                     byte_offset == 2'h3 ? {D_store_data[7:0], 24'b0} : 32'h0) :
                            D_store_width == 2'h1 ? (byte_offset == 2'h0 ? {16'b0, D_store_data[15:0]} :
                                                     byte_offset == 2'h2 ? {D_store_data[15:0], 16'b0} : 32'h0) :
                            D_store_width == 2'h2 ? (byte_offset == 2'h0 ? D_store_data : 32'h0) : 32'h0;

    reg [7:0] leds_l_reg, leds_r_reg;

    always @(posedge clk) begin
        if (reset) begin
            leds_l_reg <= 8'b0;
            leds_r_reg <= 8'b0;
        end else begin
            if (io_en) begin
                // memory mapped I/O can be accessed in words only
                // here lists all the writable I/O registers
                if (D_store_width == 2'h2) begin
                    case (io_sel)
                        LED: begin
                            {leds_l_reg, leds_r_reg} <= mem_store_data[15:0];
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
        .dinb(mem_store_data),
        .doutb(vga_load_word)
    );

    reg [63:0] ascii_data [95:0];
    always @(posedge clk) begin
        if (reset) begin
            ascii_data[0]  <= 64'h0000000000000000;   // U+0020 (space)
            ascii_data[1]  <= 64'h00180018183c3c18;   // U+0021 (!)
            ascii_data[2]  <= 64'h0000000000006c6c;   // U+0022 (")
            ascii_data[3]  <= 64'h006c6cfe6cfe6c6c;   // U+0023 (#)
            ascii_data[4]  <= 64'h0030f80c78c07c30;   // U+0024 ($)
            ascii_data[5]  <= 64'h00c6663018ccc600;   // U+0025 (%)
            ascii_data[6]  <= 64'h0076ccdc76386c38;   // U+0026 (&)
            ascii_data[7]  <= 64'h0000000000c06060;   // U+0027 (')
            ascii_data[8]  <= 64'h0018306060603018;   // U+0028 (()
            ascii_data[9]  <= 64'h0060301818183060;   // U+0029 ())
            ascii_data[10] <= 64'h0000663cff3c6600;   // U+002A (*)
            ascii_data[11] <= 64'h00003030fc303000;   // U+002B (+)
            ascii_data[12] <= 64'h6030300000000000;   // U+002C (,)
            ascii_data[13] <= 64'h00000000fc000000;   // U+002D (-)
            ascii_data[14] <= 64'h0030300000000000;   // U+002E (.)
            ascii_data[15] <= 64'h0080c06030180c06;   // U+002F (/)
            ascii_data[16] <= 64'h007ce6f6decec67c;   // U+0030 (0)
            ascii_data[17] <= 64'h00fc303030307030;   // U+0031 (1)
            ascii_data[18] <= 64'h00fccc60380ccc78;   // U+0032 (2)
            ascii_data[19] <= 64'h0078cc0c380ccc78;   // U+0033 (3)
            ascii_data[20] <= 64'h001e0cfecc6c3c1c;   // U+0034 (4)
            ascii_data[21] <= 64'h0078cc0c0cf8c0fc;   // U+0035 (5)
            ascii_data[22] <= 64'h0078ccccf8c06038;   // U+0036 (6)
            ascii_data[23] <= 64'h00303030180cccfc;   // U+0037 (7)
            ascii_data[24] <= 64'h0078cccc78cccc78;   // U+0038 (8)
            ascii_data[25] <= 64'h0070180c7ccccc78;   // U+0039 (9)
            ascii_data[26] <= 64'h0030300000303000;   // U+003A (:)
            ascii_data[27] <= 64'h6030300000303000;   // U+003B (;)
            ascii_data[28] <= 64'h00183060c0603018;   // U+003C (<)
            ascii_data[29] <= 64'h0000fc0000fc0000;   // U+003D (=)
            ascii_data[30] <= 64'h006030180c183060;   // U+003E (>)
            ascii_data[31] <= 64'h00300030180ccc78;   // U+003F (?)
            ascii_data[32] <= 64'h0078c0dededec67c;   // U+0040 (@)
            ascii_data[33] <= 64'h00ccccfccccc7830;   // U+0041 (A)
            ascii_data[34] <= 64'h00fc66667c6666fc;   // U+0042 (B)
            ascii_data[35] <= 64'h003c66c0c0c0663c;   // U+0043 (C)
            ascii_data[36] <= 64'h00f86c6666666cf8;   // U+0044 (D)
            ascii_data[37] <= 64'h00fe6268786862fe;   // U+0045 (E)
            ascii_data[38] <= 64'h00f06068786862fe;   // U+0046 (F)
            ascii_data[39] <= 64'h003e66cec0c0663c;   // U+0047 (G)
            ascii_data[40] <= 64'h00ccccccfccccccc;   // U+0048 (H)
            ascii_data[41] <= 64'h0078303030303078;   // U+0049 (I)
            ascii_data[42] <= 64'h0078cccc0c0c0c1e;   // U+004A (J)
            ascii_data[43] <= 64'h00e6666c786c66e6;   // U+004B (K)
            ascii_data[44] <= 64'h00fe6662606060f0;   // U+004C (L)
            ascii_data[45] <= 64'h00c6c6d6fefeeec6;   // U+004D (M)
            ascii_data[46] <= 64'h00c6c6cedef6e6c6;   // U+004E (N)
            ascii_data[47] <= 64'h00386cc6c6c66c38;   // U+004F (O)
            ascii_data[48] <= 64'h00f060607c6666fc;   // U+0050 (P)
            ascii_data[49] <= 64'h001c78dccccccc78;   // U+0051 (Q)
            ascii_data[50] <= 64'h00e6666c7c6666fc;   // U+0052 (R)
            ascii_data[51] <= 64'h0078cc1c70e0cc78;   // U+0053 (S)
            ascii_data[52] <= 64'h007830303030b4fc;   // U+0054 (T)
            ascii_data[53] <= 64'h00fccccccccccccc;   // U+0055 (U)
            ascii_data[54] <= 64'h003078cccccccccc;   // U+0056 (V)
            ascii_data[55] <= 64'h00c6eefed6c6c6c6;   // U+0057 (W)
            ascii_data[56] <= 64'h00c66c38386cc6c6;   // U+0058 (X)
            ascii_data[57] <= 64'h0078303078cccccc;   // U+0059 (Y)
            ascii_data[58] <= 64'h00fe6632188cc6fe;   // U+005A (Z)
            ascii_data[59] <= 64'h0078606060606078;   // U+005B ([)
            ascii_data[60] <= 64'h0002060c183060c0;   // U+005C (\)
            ascii_data[61] <= 64'h0078181818181878;   // U+005D (])
            ascii_data[62] <= 64'h00000000c66c3810;   // U+005E (^)
            ascii_data[63] <= 64'hff00000000000000;   // U+005F (_)
            ascii_data[64] <= 64'h0000000000183030;   // U+0060 (`)
            ascii_data[65] <= 64'h0076cc7c0c780000;   // U+0061 (a)
            ascii_data[66] <= 64'h00dc66667c6060e0;   // U+0062 (b)
            ascii_data[67] <= 64'h0078ccc0cc780000;   // U+0063 (c)
            ascii_data[68] <= 64'h0076cccc7c0c0c1c;   // U+0064 (d)
            ascii_data[69] <= 64'h0078c0fccc780000;   // U+0065 (e)
            ascii_data[70] <= 64'h00f06060f0606c38;   // U+0066 (f)
            ascii_data[71] <= 64'hf80c7ccccc760000;   // U+0067 (g)
            ascii_data[72] <= 64'h00e66666766c60e0;   // U+0068 (h)
            ascii_data[73] <= 64'h0078303030700030;   // U+0069 (i)
            ascii_data[74] <= 64'h78cccc0c0c0c000c;   // U+006A (j)
            ascii_data[75] <= 64'h00e66c786c6660e0;   // U+006B (k)
            ascii_data[76] <= 64'h0078303030303070;   // U+006C (l)
            ascii_data[77] <= 64'h00c6d6fefecc0000;   // U+006D (m)
            ascii_data[78] <= 64'h00ccccccccf80000;   // U+006E (n)
            ascii_data[79] <= 64'h0078cccccc780000;   // U+006F (o)
            ascii_data[80] <= 64'hf0607c6666dc0000;   // U+0070 (p)
            ascii_data[81] <= 64'h1e0c7ccccc760000;   // U+0071 (q)
            ascii_data[82] <= 64'h00f0606676dc0000;   // U+0072 (r)
            ascii_data[83] <= 64'h00f80c78c07c0000;   // U+0073 (s)
            ascii_data[84] <= 64'h00183430307c3010;   // U+0074 (t)
            ascii_data[85] <= 64'h0076cccccccc0000;   // U+0075 (u)
            ascii_data[86] <= 64'h003078cccccc0000;   // U+0076 (v)
            ascii_data[87] <= 64'h006cfefed6c60000;   // U+0077 (w)
            ascii_data[88] <= 64'h00c66c386cc60000;   // U+0078 (x)
            ascii_data[89] <= 64'hf80c7ccccccc0000;   // U+0079 (y)
            ascii_data[90] <= 64'h00fc643098fc0000;   // U+007A (z)
            ascii_data[91] <= 64'h001c3030e030301c;   // U+007B ({)
            ascii_data[92] <= 64'h0018181800181818;   // U+007C (|)
            ascii_data[93] <= 64'h00e030301c3030e0;   // U+007D (})
            ascii_data[94] <= 64'h000000000000dc76;   // U+007E (~)
            ascii_data[95] <= 64'h0000000000000000;   // U+007F (delete)
        end
    end

endmodule