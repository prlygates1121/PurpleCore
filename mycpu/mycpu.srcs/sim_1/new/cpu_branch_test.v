`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2025 12:09:46 AM
// Design Name: 
// Module Name: cpu_branch_test
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


module cpu_branch_test(

    );
    parameter CLK_100_PERIOD = 10;
    parameter CLK_100_FREQ = 100_000_000;
    parameter UART_FREQ = 2_000_000; // real: 115200, test: 2_000_000
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

        send_instruction(32'h00A00513);
        send_instruction(32'h00A00593);
        send_instruction(32'h00500613);
        send_instruction(32'hFFB00693);
        send_instruction(32'hFF000713);
        send_instruction(32'h00A00793);
        send_instruction(32'h00B50463);
        send_instruction(32'h00C0006F);
        send_instruction(32'h00128293);
        send_instruction(32'h00C0006F);
        send_instruction(32'h00228293);
        send_instruction(32'h0040006F);
        send_instruction(32'h00C51463);
        send_instruction(32'h00C0006F);
        send_instruction(32'h00130313);
        send_instruction(32'h00C0006F);
        send_instruction(32'h00230313);
        send_instruction(32'h0040006F);
        send_instruction(32'h00A64463);
        send_instruction(32'h00C0006F);
        send_instruction(32'h00138393);
        send_instruction(32'h00C0006F);
        send_instruction(32'h00238393);
        send_instruction(32'h0040006F);
        send_instruction(32'h00C54463);
        send_instruction(32'h00C0006F);
        send_instruction(32'h00338393);
        send_instruction(32'h0080006F);
        send_instruction(32'h00438393);
        send_instruction(32'h00C6C463);
        send_instruction(32'h00C0006F);
        send_instruction(32'h00538393);
        send_instruction(32'h00C0006F);
        send_instruction(32'h00638393);
        send_instruction(32'h0040006F);
        send_instruction(32'h00B55463);
        send_instruction(32'h00C0006F);
        send_instruction(32'h001E0E13);
        send_instruction(32'h00C0006F);
        send_instruction(32'h002E0E13);
        send_instruction(32'h0040006F);
        send_instruction(32'h00C55463);
        send_instruction(32'h00C0006F);
        send_instruction(32'h003E0E13);
        send_instruction(32'h00C0006F);
        send_instruction(32'h004E0E13);
        send_instruction(32'h0040006F);
        send_instruction(32'h00A65463);
        send_instruction(32'h00C0006F);
        send_instruction(32'h005E0E13);
        send_instruction(32'h0080006F);
        send_instruction(32'h006E0E13);
        send_instruction(32'h00A66463);
        send_instruction(32'h00C0006F);
        send_instruction(32'h001E8E93);
        send_instruction(32'h00C0006F);
        send_instruction(32'h002E8E93);
        send_instruction(32'h0040006F);
        send_instruction(32'h00A76463);
        send_instruction(32'h00C0006F);
        send_instruction(32'h003E8E93);
        send_instruction(32'h0080006F);
        send_instruction(32'h004E8E93);
        send_instruction(32'h00F56463);
        send_instruction(32'h00C0006F);
        send_instruction(32'h005E8E93);
        send_instruction(32'h0080006F);
        send_instruction(32'h006E8E93);
        send_instruction(32'h00B57463);
        send_instruction(32'h00C0006F);
        send_instruction(32'h001F0F13);
        send_instruction(32'h00C0006F);
        send_instruction(32'h002F0F13);
        send_instruction(32'h0040006F);
        send_instruction(32'h00C57463);
        send_instruction(32'h00C0006F);
        send_instruction(32'h003F0F13);
        send_instruction(32'h0080006F);
        send_instruction(32'h004F0F13);
        send_instruction(32'h00A77463);
        send_instruction(32'h00C0006F);
        send_instruction(32'h005F0F13);
        send_instruction(32'h0080006F);
        send_instruction(32'h006F0F13);
        send_instruction(32'h00100073);
        

        #(CLK_100_PERIOD * 15000);
        $finish;
    end


    
endmodule
