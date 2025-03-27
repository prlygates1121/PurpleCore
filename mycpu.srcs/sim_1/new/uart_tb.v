`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2025 07:51:24 PM
// Design Name: 
// Module Name: uart_tb
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


module uart_tb(
    );

    parameter CLOCK_PERIOD = 20;
    parameter SERIAL_PERIOD = CLOCK_PERIOD * 4;

    reg clk;
    reg reset;
    reg rx_in;
    wire [7:0] rx_out;
    wire rx_done;
    wire [7:0] rx_out_valid = rx_out & {8{rx_done}};

    reg uart_en;
    reg [9:0] counter;
    always @(posedge clk) begin
        if (reset) begin
            counter <= 10'b0;
            uart_en <= 1'b0;
        end else if (counter < 3) begin
            counter <= counter + 1;
            uart_en <= 1'b0;
        end else begin
            counter <= 10'b0;
            uart_en <= 1'b1;
        end
    end

    uart_rx rx(
        .clk(clk),
        .reset(reset),
        .uart_en(uart_en),
        .rx_in(rx_in),
        .rx_out(rx_out),
        .done(rx_done)
    );

    reg [7:0] tx_in;
    wire tx_out;
    wire tx_done;

    uart_tx tx(
        .clk(clk),
        .reset(reset),
        .uart_en(uart_en),
        .tx_in(tx_in),
        .tx_out(tx_out),
        .done(tx_done)
    );
    
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        reset = 1;
        #(2 * CLOCK_PERIOD + 15) reset = 0;
    end

    // test rx
    // initial begin
    //     rx_in = 1;
    //     // START BIT
    //     #(4 * CLOCK_PERIOD + 5) rx_in = 0;                     
    //     // DATA: MSB 00110111 LSB
    //     #(SERIAL_PERIOD) rx_in = 1;    
    //     #(SERIAL_PERIOD * 3) rx_in = 0;
    //     #(SERIAL_PERIOD) rx_in = 1;
    //     #(SERIAL_PERIOD * 2) rx_in = 0;
    //     // STOP BIT + 2 ones, forcing IDLE
    //     #(SERIAL_PERIOD * 2) rx_in = 1;
    //     #(SERIAL_PERIOD * 3);

    //     // START BIT
    //     rx_in = 0;
    //     #(SERIAL_PERIOD);
    //     // DATA: MSB 11111111 LSB
    //     rx_in = 1;
    //     #(SERIAL_PERIOD * 8);

    //     // STOP BIT
    //     #(SERIAL_PERIOD);

    //     // START BIT immediately after STOP BIT
    //     rx_in = 0;
    //     #(SERIAL_PERIOD);

    //     // DATA: MSB 00011000 LSB
    //     #(SERIAL_PERIOD * 3);
    //     rx_in = 1;
    //     #(SERIAL_PERIOD * 2);
    //     rx_in = 0;
    //     #(SERIAL_PERIOD * 3);

    //     // 4 zeros, forcing WAIT
    //     #(SERIAL_PERIOD * 4)

    //     // STOP BIT
    //     rx_in = 1;
    //     #(SERIAL_PERIOD);

    //     #(SERIAL_PERIOD * 2);
    //     $finish;
    // end

    // test tx
    initial begin
        tx_in = 8'hab;
        #(CLOCK_PERIOD * 7 + 10);
        #(SERIAL_PERIOD * 10);
        tx_in = 8'hcd;
        #(SERIAL_PERIOD * 10);

        #(SERIAL_PERIOD * 2);
        $display("Timeout");
        $finish;
    end

    // always @(tx_done) begin
    //     if (tx_done) begin
    //         $display("Transmission finished.");
    //         #(SERIAL_PERIOD);
    //         $finish;
    //     end
    // end

endmodule
