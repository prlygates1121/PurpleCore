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
    input           clk_100,
    input           reset_n,

    input           uart_rx_in,
    output          uart_tx_out,

    input [7:0]     sws_l,
    input [7:0]     sws_r,

    input [4:0]     bts,

    output [7:0]    leds_l,
    output [7:0]    leds_r,
    
    output [3:0]    vga_r,
    output [3:0]    vga_g,
    output [3:0]    vga_b,
    output          vga_h_sync,
    output          vga_v_sync,

    output [7:0]    tube_ena,
    output [7:0]    left_tube_content,
    output [7:0]    right_tube_content,

    input           ps2_clk,
    input           ps2_data

    );
    
    wire locked_main, locked_pixel;
    wire locked = locked_main & locked_pixel;

    wire [4:0]  bts_state;
    wire [31:0] seg_display_hex;
    wire [31:0] vga_addr, vga_data;
    wire [7:0]  key_code;
    wire [7:0]  uart_rx_data;
    wire [7:0]  uart_tx_data;
    wire        uart_read, uart_write;
    wire        uart_rx_ready, uart_tx_ready;
    wire [31:0] uart_ctrl;

    wire clk_main;                    // generates clk_main from clk_100
    clk_main_gen clk_main_gen_0(
        .clk_out1                       (clk_main),
        .reset                          (~reset_n),
        .locked                         (locked_main),
        .clk_in1                        (clk_100)
    );

    wire clk_pixel;                 // Pixel clock: 25.20325 MHz ~= 800 * 525 * 60
    clk_pixel_gen clk_gen(
    .clk_system                         (clk_100),
        .reset                          (~reset_n),
        .locked                         (locked_pixel),
        .clk_pixel                      (clk_pixel)
    );

    // the init_counter starts once all clocks are locked
    // when the init_counter reaches 0, the reset_modules signal is released
    // this is used to reset the modules in the design
    reg [7:0] init_counter;
    reg reset_modules_clk100;

    always @(posedge clk_100) begin
        if (~reset_n) begin
            init_counter <= 8'hFF;
            reset_modules_clk100 <= 1'b1; // hold reset
        end else if (locked) begin
            // decrement until reaching 0
            if (|init_counter) begin
                init_counter <= init_counter - 1;
            end else begin
                reset_modules_clk100 <= 1'b0; // release reset
            end
        end else begin
            reset_modules_clk100 <= 1'b1; // hold reset
        end
    end

    reg reset_sync_pixel_s1, reset_sync_pixel_s2;
    always @(posedge clk_pixel) begin
        reset_sync_pixel_s1 <= reset_modules_clk100;
        reset_sync_pixel_s2 <= reset_sync_pixel_s1;
    end

    reg reset_sync_main_s1, reset_sync_main_s2;
    always @(posedge clk_main) begin
        reset_sync_main_s1 <= reset_modules_clk100;
        reset_sync_main_s2 <= reset_sync_main_s1;
    end

    core core_0(
        `ifdef DEBUG
            .clk_100                    (clk_100),
        `endif
        .clk                            (clk_main),
        .reset                          (reset_sync_main_s2),

        .sws_l                          (sws_l),
        .sws_r                          (sws_r),

        .bts_state                      (bts_state),

        .seg_display_hex                (seg_display_hex),

        .leds_l                         (leds_l),
        .leds_r                         (leds_r),

        .clk_pixel                      (clk_pixel),
        .vga_addr                       (vga_addr),
        .vga_data                       (vga_data),

        .key_code                       (key_code),

        .uart_rx_data                   (uart_rx_data),
        .uart_tx_data                   (uart_tx_data),
        .uart_read                      (uart_read),
        .uart_write                     (uart_write),
        .uart_rx_ready                  (uart_rx_ready),
        .uart_tx_ready                  (uart_tx_ready),
        .uart_ctrl                      (uart_ctrl)
    );

    vga_top vga(
        .clk                            (clk_pixel),
        .reset                          (reset_sync_pixel_s2),
        .r                              (vga_r),
        .g                              (vga_g),
        .b                              (vga_b),
        .h_sync                         (vga_h_sync),
        .v_sync                         (vga_v_sync),
        .vga_addr                       (vga_addr),
        .vga_data                       (vga_data)
    );

    uart uart_0(
    	.clk    	                    (clk_main),
    	.reset  	                    (reset_sync_main_s2),
    	.read   	                    (uart_read),
    	.rx_in  	                    (uart_rx_in),
    	.rx_out 	                    (uart_rx_data),
        .rx_ready                       (uart_rx_ready),
    	.write  	                    (uart_write),
    	.tx_in  	                    (uart_tx_data),
    	.tx_out 	                    (uart_tx_out),
        .tx_ready                       (uart_tx_ready),
        .ctrl                           (uart_ctrl)
    );

    seg_display_handler seg_display_handler_0(
        .clk                            (clk_main),
        .reset                          (reset_sync_main_s2),
        .hex_digits                     (seg_display_hex),
        .tube_ena                       (tube_ena),
        .left_tube_content              (left_tube_content),
        .right_tube_content             (right_tube_content)
    );

    wire debug_shift;
    wire [7:0] debug_scan_code;
    keyboard keyboard_0 (
        .debug_shift                    (debug_shift),
        .debug_scan_code                (debug_scan_code),

        .clk                            (clk_main),
        .reset                          (reset_sync_main_s2),
        .ps2_clk                        (ps2_clk),
        .ps2_data                       (ps2_data),
        .key_code                       (key_code)
    );

    genvar i;
    generate
        for (i = 0; i < 5; i = i + 1) begin
            button_handler button_handler_0(
                .clk         	        (clk_main),
                .reset       	        (reset_sync_main_s2),
                .bt_raw      	        (bts[i]),
                .bt_state    	        (bts_state[i])
            );
        end
    endgenerate

endmodule
