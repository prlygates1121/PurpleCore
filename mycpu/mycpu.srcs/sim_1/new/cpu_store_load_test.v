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

        // send_instruction(32'h00009337);
        // send_instruction(32'h00030313);
        // send_instruction(32'h123452B7);
        // send_instruction(32'h67828293);
        // send_instruction(32'h00532023);
        // send_instruction(32'h00032383);
        // send_instruction(32'h0E729663);
        // send_instruction(32'hABCDF2B7);
        // send_instruction(32'hF0128293);
        // send_instruction(32'h00532223);
        // send_instruction(32'h00432383);
        // send_instruction(32'h0C729C63);
        // send_instruction(32'h1122F2B7);
        // send_instruction(32'hEFF28293);
        // send_instruction(32'h00532423);
        // send_instruction(32'h000062B7);
        // send_instruction(32'hA5A28293);
        // send_instruction(32'h00531423);
        // send_instruction(32'h00831383);
        // send_instruction(32'h00006E37);
        // send_instruction(32'hA5AE0E13);
        // send_instruction(32'h0BC39863);
        // send_instruction(32'h00835383);
        // send_instruction(32'h00006E37);
        // send_instruction(32'hA5AE0E13);
        // send_instruction(32'h0BC39063);
        // send_instruction(32'h0000A2B7);
        // send_instruction(32'h5A528293);
        // send_instruction(32'h00531523);
        // send_instruction(32'h00A31383);
        // send_instruction(32'hFFFFAE37);
        // send_instruction(32'h5A5E0E13);
        // send_instruction(32'h09C39263);
        // send_instruction(32'h00A35383);
        // send_instruction(32'h0000AE37);
        // send_instruction(32'h5A5E0E13);
        // send_instruction(32'h07C39A63);
        // send_instruction(32'h112232B7);
        // send_instruction(32'h34428293);
        // send_instruction(32'h00532623);
        // send_instruction(32'h07F00293);
        // send_instruction(32'h00530623);
        // send_instruction(32'h00C30383);
        // send_instruction(32'h07F00E13);
        // send_instruction(32'h05C39A63);
        // send_instruction(32'h00C34383);
        // send_instruction(32'h07F00E13);
        // send_instruction(32'h05C39463);
        // send_instruction(32'h08000293);
        // send_instruction(32'h005306A3);
        // send_instruction(32'h00D30383);
        // send_instruction(32'hF8000E13);
        // send_instruction(32'h03C39A63);
        // send_instruction(32'h00D34383);
        // send_instruction(32'h08000E13);
        // send_instruction(32'h03C39463);
        // send_instruction(32'h0FF00293);
        // send_instruction(32'h00530723);
        // send_instruction(32'h00E30383);
        // send_instruction(32'hFFF00E13);
        // send_instruction(32'h01C39A63);
        // send_instruction(32'h00E34383);
        // send_instruction(32'h0FF00E13);
        // send_instruction(32'h01C39463);
        // send_instruction(32'h0000006F);
        // send_instruction(32'h00100513);
        // send_instruction(32'hFFDFF06F);

        send_instruction(32'h00000413);
        send_instruction(32'h1E000493);
        send_instruction(32'h00000913);
        send_instruction(32'h00A00993);
        send_instruction(32'h01400A13);
        send_instruction(32'h00A00A93);
        send_instruction(32'h04940863);
        send_instruction(32'h28000293);
        send_instruction(32'h80300337);
        send_instruction(32'h0F000F93);
        send_instruction(32'h025403B3);
        send_instruction(32'h008383B3);
        send_instruction(32'h0013FE13);
        send_instruction(32'h002E1E13);
        send_instruction(32'h01C91EB3);
        send_instruction(32'h01CFDFB3);
        send_instruction(32'h0013D393);
        send_instruction(32'h006383B3);
        send_instruction(32'h0003CF03);
        send_instruction(32'h01FF7F33);
        send_instruction(32'h01DF6F33);
        send_instruction(32'h01E38023);
        send_instruction(32'h0003CF03);
        send_instruction(32'h00190913);
        send_instruction(32'h00140413);
        send_instruction(32'hFB5FF06F);
        send_instruction(32'h0000006F);


        
        #(CLK_100_PERIOD * 50000);
        $finish;
    end

    // initial begin
    //     sws_l = 8'b0;
    //     forever #(CLK_100_PERIOD * 5) sws_l <= sws_l + 8'b1;
    // end

    // initial begin
    //     sws_r = 8'b0;
    //     forever #(CLK_100_PERIOD * 5) sws_r <= sws_r + 8'b1;
    // end
endmodule
