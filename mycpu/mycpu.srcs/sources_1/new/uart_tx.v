`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2025 03:58:40 PM
// Design Name: 
// Module Name: uart_tx
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


module uart_tx(
    input clk,
    input reset,
    input uart_en,
    input [7:0] tx_in,
    input tx_new,
    output tx_out,
    output done
    );

    localparam [1:0] IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;

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
        end else if (uart_en & (state == DATA | state == START)) begin
            counter <= ((counter == 4'h8) ? 4'h0 : (counter + 1));
        end
    end

    always @(*) begin
        case (state)
            IDLE:       next_state = tx_new ? START : IDLE;
            START:      next_state = DATA;
            DATA:       next_state = counter == 4'h8 ? STOP : DATA;
            STOP:       next_state = tx_new ? START : IDLE;
            default:    next_state = IDLE;
        endcase
    end

    assign tx_out = state == IDLE ? 1'b1 :
                    state == START ? 1'b0 :
                    state == DATA ? tx_in[counter - 1] :
                    1'b1;

    assign done = state == STOP;

endmodule
