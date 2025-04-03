`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2025 07:42:15 PM
// Design Name: 
// Module Name: cpu_vga_test
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


module cpu_vga_test(

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
            send_byte(inst[31:24]);
            send_byte(inst[23:16]);
            send_byte(inst[15:8]);
            send_byte(inst[7:0]);
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

        send_instruction(32'hA0000437);
        send_instruction(32'h00040413);
        send_instruction(32'hA00264B7);
        send_instruction(32'h80048493);
        send_instruction(32'h00040293);
        send_instruction(32'h00100313);
        send_instruction(32'h111113B7);
        send_instruction(32'h11138393);
        send_instruction(32'h01000913);
        send_instruction(32'h0072A023);
        send_instruction(32'h00428293);
        send_instruction(32'h00928463);
        send_instruction(32'hFF5FF06F);
        send_instruction(32'h00040293);
        send_instruction(32'h00130313);
        send_instruction(32'h03230263);
        send_instruction(32'h00030393);
        send_instruction(32'h00439E13);
        send_instruction(32'h01C3E3B3);
        send_instruction(32'h00839E13);
        send_instruction(32'h01C3E3B3);
        send_instruction(32'h01039E13);
        send_instruction(32'h01C3E3B3);
        send_instruction(32'hFC9FF06F);
        send_instruction(32'h00000313);
        send_instruction(32'h00000393);
        send_instruction(32'hFD9FF06F);



        #(CLK_100_PERIOD * 40000);
        $finish;

    end


    
endmodule
