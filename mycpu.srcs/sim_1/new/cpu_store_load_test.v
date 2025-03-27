`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2025 02:39:54 AM
// Design Name: 
// Module Name: cpu_store_load_test
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


module cpu_store_load_test(

    );
    parameter CLK_100_PERIOD = 10;
    parameter CLK_100_FREQ = 100_000_000;
    parameter UART_FREQ = 2_000_000; // real: 115200, test: 10_000_000
    parameter UART_PERIOD = CLK_100_PERIOD * (CLK_100_FREQ / UART_FREQ + 1);
    
    reg clk_100, reset_n, uart_rx_in;
    wire uart_tx_out;
    reg [7:0] sws_l, sws_r;
    
    top top0(
        .clk_100(clk_100),
        .reset_n(reset_n),    
        .uart_rx_in(uart_rx_in),
        .uart_tx_out(uart_tx_out),
        .sws_l(sws_l),
        .sws_r(sws_r)
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

        send_instruction(32'h0FF00293);
        send_instruction(32'h0AA00E13);
        send_instruction(32'h01C12223);
        send_instruction(32'h00512023);
        send_instruction(32'h00012303);
        send_instruction(32'h00030393);
        send_instruction(32'h00412303);
        send_instruction(32'h00030393);

        // send_instruction(32'hFFF102B7);
        // send_instruction(32'h00028293);
        // send_instruction(32'hFFF00337);
        // send_instruction(32'h00030313);
        // send_instruction(32'h0002A383);
        // send_instruction(32'h00730E33);
        // send_instruction(32'h007E2023);
        // send_instruction(32'hFF5FF06F);

        send_instruction(32'h00000293);
        send_instruction(32'h00A28293);
        send_instruction(32'hFFDFF06F);

        

        
        #(CLK_100_PERIOD * 15000);
        $finish;
    end

    initial begin
        sws_l = 8'b0;
        forever #(CLK_100_PERIOD * 5) sws_l <= sws_l + 8'b1;
    end

    initial begin
        sws_r = 8'b0;
        forever #(CLK_100_PERIOD * 5) sws_r <= sws_r + 8'b1;
    end
endmodule
