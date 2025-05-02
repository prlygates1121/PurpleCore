`timescale 1ns / 1ps
`include "params.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2025 01:11:15 AM
// Design Name: 
// Module Name: uart
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


module uart(
    input clk,
    input reset,

    input read,
    input rx_in,
    output [7:0] rx_out,
    output reg rx_ready,

    input write,
    input [7:0] tx_in,
    output tx_out,
    output reg tx_ready
    );

    localparam [31:0] COUNTER_MAX = `CLK_MAIN_FREQ / `UART_FREQ;

    reg uart_en;
    reg [9:0] counter;

    reg rx_in_prev;
    reg rx_active;
    reg tx_new;
    wire tx_done, rx_done;
    wire [1:0] rx_state;
    wire rx_negedge = rx_in == 1'b0 & rx_in_prev == 1'b1;

    always @(posedge clk) begin
        if (reset) begin
            rx_in_prev <= 1'b0;
        end else begin
            rx_in_prev <= rx_in;
        end
    end

    // rx_active indicates if data reception has started, it remains active since the first negative edge of rx_in
    always @(posedge clk) begin
        if (reset) begin
            rx_active <= 1'b0;
        end else if (rx_negedge) begin
            rx_active <= 1'b1;
        end 
    end

    // uart_en is triggered for 1 clock cycle every 1/115200Hz, and is synchronized with transmitter clock on encountering a start bit
    always @(posedge clk) begin
        if (reset) begin
            counter <= 10'b0;
            uart_en <= 1'b0;
        end else if (rx_negedge & (rx_state == 2'b00 | rx_state == 2'b11)) begin
            // when encountering rx_negedge while in IDLE or STOP state, set next sample at 1/2 uart period later, exactly at the center of the start bit signal
            counter <= COUNTER_MAX/2;
            uart_en <= 1'b0;
        end else if (rx_active) begin
            // increment counter if data reception has started
            if (counter != COUNTER_MAX) begin
                counter <= counter + 1;
                uart_en <= 1'b0;
            end else begin
                counter <= 10'b0;
                uart_en <= 1'b1;
            end
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            rx_ready <= 1'b0;
        end else if (read) begin
            rx_ready <= 1'b0;
        end else if (rx_done) begin
            rx_ready <= 1'b1;
        end
    end

    uart_rx rx(
        .clk                (clk),
        .reset              (reset),
        .uart_en            (uart_en),

        .rx_in              (rx_in),
        .rx_out             (rx_out),
        .done               (rx_done),
        .rx_state           (rx_state)
    );

    always @(posedge clk) begin
        if (reset) begin
            tx_new <= 1'b0;
        end else if (write) begin
            tx_new <= 1'b1;
        end else if (uart_en) begin
            tx_new <= 1'b0;
        end
    end

    uart_tx tx(
        .clk                (clk),
        .reset              (reset),
        .uart_en            (uart_en),

        .tx_new             (tx_new),
        .tx_in              (tx_in),
        .tx_out             (tx_out),
        .done               (tx_done)
    );

    always @(posedge clk) begin
        if (reset) begin
            tx_ready <= 1'b0;
        end else if (write) begin
            tx_ready <= 1'b0;
        end else if (tx_done) begin
            tx_ready <= 1'b1;
        end
    end
    

endmodule
