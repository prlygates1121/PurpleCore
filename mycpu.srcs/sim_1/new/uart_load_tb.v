`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2025 03:03:26 AM
// Design Name: 
// Module Name: uart_load_tb
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


module uart_load_tb(

    );

    parameter CLOCK_PERIOD_100Mhz = 10;
    parameter CLOCK_PERIOD_25MHz = 40;
    parameter SERIAL_PERIOD = CLOCK_PERIOD_100Mhz * 869;

    reg clk, reset_n, rx;
    top top_tb(
        .clk_100(clk),
        .reset_n(reset_n),
        .uart_rx_in(rx)
    );

    initial begin
        clk = 1'b0;
        forever #(CLOCK_PERIOD_100Mhz/2) clk = ~clk;
    end

    initial begin
        // rx is 1 by default
        rx = 1;

        reset_n = 1'b0;
        #(CLOCK_PERIOD_100Mhz * 2);
        reset_n = 1'b1;

        
        // Wait some time before sending UART signals
        #(CLOCK_PERIOD_100Mhz * 5000);


        #(SERIAL_PERIOD);

        // START BIT
        rx = 0;
        #(SERIAL_PERIOD);
        // DATA: MSB 11111111 LSB
        rx = 1;
        #(SERIAL_PERIOD * 8);

        // STOP BIT
        #(SERIAL_PERIOD);

        // START BIT immediately after STOP BIT
        rx = 0;
        #(SERIAL_PERIOD);

        // DATA: MSB 00011000 LSB
        #(SERIAL_PERIOD * 3);
        rx = 1;
        #(SERIAL_PERIOD * 2);
        rx = 0;
        #(SERIAL_PERIOD * 3);

        // STOP BIT
        rx = 1;
        #(SERIAL_PERIOD);

        // START BIT
        rx = 0;
        #(SERIAL_PERIOD);
        
        rx = 1;
        #(SERIAL_PERIOD * 4);
        rx = 0;
        #(SERIAL_PERIOD * 4);

        // STOP BIT
        rx = 1;
        #(SERIAL_PERIOD);

        // START BIT
        rx = 0;
        #(SERIAL_PERIOD);
        
        rx = 1;
        #(SERIAL_PERIOD * 4);
        rx = 0;
        #(SERIAL_PERIOD * 4);

        // STOP BIT
        rx = 1;
        #(SERIAL_PERIOD);

        #(SERIAL_PERIOD * 18);
        
        $finish;
    end

endmodule
