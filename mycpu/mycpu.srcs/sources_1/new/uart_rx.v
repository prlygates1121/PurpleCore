`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2025 03:59:21 PM
// Design Name: 
// Module Name: uart_rx
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


module uart_rx(
    input clk,
    input reset,
    input uart_en,
    input rx_in,
    output [7:0] rx_out,
    output reg done,
    output [1:0] rx_state
    );

    localparam [1:0] IDLE = 2'b00, DATA = 2'b01, WAIT = 2'b10, STOP = 2'b11;
    reg [1:0] state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else if (uart_en) begin
            state <= next_state;
        end
    end

    reg [3:0] counter;
    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'b0;
        end else if (uart_en & state == DATA) begin
            counter <= counter == 4'h8 ? 4'b0 : counter + 4'b1;
        end
    end

    always @(*) begin
        case (state)
            IDLE:       next_state = rx_in ? IDLE : DATA;
            DATA:       next_state = ((counter == 4'h8) ? (rx_in ? STOP : WAIT) : DATA);
            WAIT:       next_state = rx_in ? STOP : WAIT;
            STOP:       next_state = rx_in ? IDLE : DATA;
            default:    next_state = IDLE;
        endcase
    end

    reg [7:0] rx_out_buf;
    always @(posedge clk) begin
        if (reset) begin
            rx_out_buf <= 8'b0;
        end else if (uart_en & state == DATA) begin
            rx_out_buf <= (counter == 4'h8) ? rx_out_buf : {rx_in, rx_out_buf[7:1]};
        end
    end

    // done is 1 for one cycle every time 8 bits of data are received
    reg first_stop;
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            first_stop <= 1'b0;
        end else if (state == STOP) begin
            done <= first_stop ? 1'b0 : 1'b1;
            first_stop <= 1'b1;
        end else begin
            done <= 1'b0;
            first_stop <= 1'b0;
        end
    end

    assign rx_out = rx_out_buf;
    assign rx_state = state;
endmodule
