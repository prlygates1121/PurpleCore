`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2025 11:47:45 PM
// Design Name: 
// Module Name: cpu_jump_test
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

module cpu_jump_test(

    );

    parameter CLK_100_PERIOD = 10;
    parameter CLK_100_FREQ = 100_000_000;
    parameter UART_FREQ = 2_000_000; // real: 115200, test: 10_000_000
    parameter UART_PERIOD = CLK_100_PERIOD * (CLK_100_FREQ / UART_FREQ + 1);

    reg clk_100, reset_n, uart_rx_in;
    wire uart_tx_out;

    top top0(
        .clk_100(clk_100),
        .reset_n(reset_n),    
        .uart_rx_in(uart_rx_in),
        .uart_tx_out(uart_tx_out)
    );

    integer i;

    task send_byte(input reg [7:0] data_byte);
        begin
            // start bit
            uart_rx_in = 1'b0;
            #(UART_PERIOD);

            // data bits
            for (i = 0; i < 8; i = i + 1) begin
                uart_rx_in = data_byte[i];
                #(UART_PERIOD);
            end

            // stop bit
            uart_rx_in = 1'b1;
            #(UART_PERIOD);
        end
    endtask

    task send_instruction(input reg [31:0] inst);
        begin
            send_byte(inst[7:0]);
            send_byte(inst[15:8]);
            send_byte(inst[23:16]);
            send_byte(inst[31:24]);
        end
    endtask

    initial begin
        clk_100 = 1'b0;
        forever #(CLK_100_PERIOD/2) clk_100 = ~clk_100;
    end

    initial begin
        uart_rx_in = 1'b1;
        reset_n = 1'b0;
        #(CLK_100_PERIOD * 2);
        reset_n = 1'b1;
        #(CLK_100_PERIOD * 5000);

        send_instruction(32'h00100513);
        send_instruction(32'h00200593);
        send_instruction(32'h010000EF);
        send_instruction(32'h00100293);
        send_instruction(32'h00100313);
        send_instruction(32'h00C0006F);
        send_instruction(32'h00B50533);
        send_instruction(32'h00008067);

    
        #(CLK_100_PERIOD * 15000);
        $finish;

    end


    
endmodule
