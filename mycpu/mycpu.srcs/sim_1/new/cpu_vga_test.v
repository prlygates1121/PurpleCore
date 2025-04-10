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

        send_instruction(32'h805004B7);
        send_instruction(32'h00A00913);
        send_instruction(32'h00A00993);
        send_instruction(32'h1CC00B13);
        send_instruction(32'h00000413);
        send_instruction(32'h01600A93);
        send_instruction(32'h00090513);
        send_instruction(32'h00098593);
        send_instruction(32'h000A8613);
        send_instruction(32'h00000693);
        send_instruction(32'h008000EF);
        send_instruction(32'h0000006F);
        send_instruction(32'hFD810113);
        send_instruction(32'h00112023);
        send_instruction(32'h00812223);
        send_instruction(32'h00912423);
        send_instruction(32'h01212623);
        send_instruction(32'h01312823);
        send_instruction(32'h01412A23);
        send_instruction(32'h01512C23);
        send_instruction(32'h01612E23);
        send_instruction(32'h03712023);
        send_instruction(32'h03812223);
        send_instruction(32'h80400437);
        send_instruction(32'h28000B93);
        send_instruction(32'h80300C37);
        send_instruction(32'h00361613);
        send_instruction(32'h00860633);
        send_instruction(32'h00062403);
        send_instruction(32'h00000A93);
        send_instruction(32'h00200B13);
        send_instruction(32'h00400913);
        send_instruction(32'h096A8263);
        send_instruction(32'h000A8463);
        send_instruction(32'h00462403);
        send_instruction(32'h00000493);
        send_instruction(32'h00050A13);
        send_instruction(32'h07248463);
        send_instruction(32'h00147993);
        send_instruction(32'h02098E63);
        send_instruction(32'h0F000F93);
        send_instruction(32'h037583B3);
        send_instruction(32'h014383B3);
        send_instruction(32'h0013FE13);
        send_instruction(32'h002E1E13);
        send_instruction(32'h00F6FE93);
        send_instruction(32'h01CE9EB3);
        send_instruction(32'h01CFDFB3);
        send_instruction(32'h0013D393);
        send_instruction(32'h018383B3);
        send_instruction(32'h0003CF03);
        send_instruction(32'h01FF7F33);
        send_instruction(32'h01DF6F33);
        send_instruction(32'h01E38023);
        send_instruction(32'h001A0A13);
        send_instruction(32'h00148493);
        send_instruction(32'h00145413);
        send_instruction(32'h00800293);
        send_instruction(32'h40AA0333);
        send_instruction(32'h00531663);
        send_instruction(32'h00050A13);
        send_instruction(32'h00158593);
        send_instruction(32'hF9DFF06F);
        send_instruction(32'h001A8A93);
        send_instruction(32'hF81FF06F);
        send_instruction(32'h00012083);
        send_instruction(32'h00412403);
        send_instruction(32'h00812483);
        send_instruction(32'h00C12903);
        send_instruction(32'h01012983);
        send_instruction(32'h01412A03);
        send_instruction(32'h01812A83);
        send_instruction(32'h01C12B03);
        send_instruction(32'h02012B83);
        send_instruction(32'h02412C03);
        send_instruction(32'h02810113);
        send_instruction(32'h00008067);





        #(CLK_100_PERIOD * 200000);
        $finish;

    end


    
endmodule
