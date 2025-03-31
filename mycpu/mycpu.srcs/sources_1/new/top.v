`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2025 12:58:52 AM
// Design Name: 
// Module Name: top
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


module top(
    input clk_100,
    input reset_n,

    input uart_rx_in,
    output uart_tx_out,

    input [7:0] sws_l,
    input [7:0] sws_r,

    output [7:0] leds_l,
    output [7:0] leds_r,
    
    output [3:0] vga_r,
    output [3:0] vga_g,
    output [3:0] vga_b,
    output vga_h_sync,
    output vga_v_sync,

    output [7:0] tube_ena,
    output [7:0] left_tube_content,
    output [7:0] right_tube_content

    );
    wire clk_25, locked;

    wire uart_mem_write, uart_inst_loaded;
    wire [31:0] uart_addr, uart_inst;

    // generates clk_25 from clk_100
    clk_main_gen clk_main_gen_0(
        .clk_out1(clk_25),
        .reset(~reset_n),
        .locked(locked),
        .clk_in1(clk_100)
    );

    // reset_modules is sent as reset signal to all modules once clk_25 is locked
    // it remains high for 2^8 cycles (100Mhz)
    reg [7:0] init_counter;
    wire reset_modules = |init_counter;
    always @(posedge clk_100) begin
        if (~reset_n) begin
            init_counter <= 8'hFF;
        end else if (locked) begin
            // decrement until reaching 0
            if (|init_counter) begin
                init_counter <= init_counter - 1;
            end
        end
    end

    wire [31:0] I_read;

    core core_0(
        .clk(clk_25),
        .reset(reset_modules),
        
        .uart_addr(uart_addr),
        .uart_inst(uart_inst),
        .uart_write(uart_mem_write),
        .uart_inst_loaded(uart_inst_loaded),

        .I_read(I_read),

        .sws_l(sws_l),
        .sws_r(sws_r),

        .leds_l(leds_l),
        .leds_r(leds_r)
    );

    // vga_top vga(
    //     .clk(clk_100),
    //     .reset(reset_modules),
    //     .r(vga_r),
    //     .g(vga_g),
    //     .b(vga_b),
    //     .h_sync(vga_h_sync),
    //     .v_sync(vga_v_sync)
    // );

    uart_handler uart_handler_0(
        .clk(clk_25),
        .reset(reset_modules),
        .rx_in(uart_rx_in),

        .I_read(I_read),

        .tx_out(uart_tx_out),
        .inst_loaded(uart_inst_loaded),
        .addr(uart_addr),
        .inst(uart_inst),
        .mem_write(uart_mem_write)
    );

    seg_display_handler seg_display_handler_0(
        .clk(clk_25),
        .reset(reset_modules),
        .hex_digits(I_read),
        .tube_ena(tube_ena),
        .left_tube_content(left_tube_content),
        .right_tube_content(right_tube_content)
    );



    // assign leds_l = uart_addr[15:8];
    // assign leds_l[2] = uart_rx_in;
    // assign leds_l[1] = load_begin;
    // assign leds_l[0] = uart_inst_loaded;
    // assign leds_r = uart_addr[7:0];

endmodule
