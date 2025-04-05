`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2025 11:37:23 PM
// Design Name: 
// Module Name: cpu_data_hazard_test
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


module cpu_data_hazard_test (

    );
    parameter CLK_100_PERIOD = 10;
    parameter CLK_100_FREQ = 100_000_000;
    parameter UART_FREQ = 115200; // real: 115200, test: 2_000_000
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
            // #(UART_PERIOD);
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

        send_instruction(32'hDEADC0B7);
        send_instruction(32'hEEF08093);
        send_instruction(32'hFF010113);
        send_instruction(32'h00112023);
        send_instruction(32'h00000013);
        send_instruction(32'h00012283);
        send_instruction(32'h00028313);
        send_instruction(32'h00030393);
        send_instruction(32'h01010113);
        send_instruction(32'hFF010113);
        send_instruction(32'h00012403);
        send_instruction(32'h00012483);
        send_instruction(32'h00010537);
        send_instruction(32'hFFF50513);
        send_instruction(32'h00410113);
        send_instruction(32'h00A12023);
        send_instruction(32'h00012583);
        send_instruction(32'h00058613);
        send_instruction(32'h0000F6B7);
        send_instruction(32'hEEE68693);
        send_instruction(32'h00D12223);
        send_instruction(32'h00412703);

        #(CLK_100_PERIOD * 15000);
        $finish;
    end


    
endmodule
