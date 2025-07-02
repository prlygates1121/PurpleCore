`timescale 1ns / 1ps
`include "params.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2025 07:24:38 PM
// Design Name: 
// Module Name: button_handler
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


module button_handler(
    input       clk,
    input       reset,
    input       bt_raw,
    output reg  bt_state,
    output      bt_pressed,
    output      bt_released
    );

    // timeout in ns
    // localparam TIMEOUT = 200_000_000_000;
    // counter max out value
    localparam COUNTER_MAX = 5_000_000;

    reg [31:0] counter;
    wire counter_max_out = counter == COUNTER_MAX;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 32'h0;
        end else begin
            if (bt_raw == bt_state) begin
                counter <= 32'h0;
            end else begin
                counter <= counter_max_out ? 32'h0 : counter + 1;
            end
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            bt_state <= 1'b0;
        end else if (counter_max_out) begin
            bt_state <= ~bt_state;
        end
    end

    assign bt_pressed   = counter_max_out & (bt_state == 1'b0);
    assign bt_released  = counter_max_out & (bt_state == 1'b1);

endmodule
