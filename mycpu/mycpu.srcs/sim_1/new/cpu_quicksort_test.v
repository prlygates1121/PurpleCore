`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2025 10:41:50 PM
// Design Name: 
// Module Name: cpu_quicksort_test
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


module cpu_quicksort_test(

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
        
        send_instruction(32'h00F00413);
        send_instruction(32'h00010937);
        send_instruction(32'h00090913);
        send_instruction(32'h00090493);
        send_instruction(32'h00000293);
        send_instruction(32'h0054A023);
        send_instruction(32'h00448493);
        send_instruction(32'h00300293);
        send_instruction(32'h0054A023);
        send_instruction(32'h00448493);
        send_instruction(32'h00500293);
        send_instruction(32'h0054A023);
        send_instruction(32'h00448493);
        send_instruction(32'hFFF00293);
        send_instruction(32'h0054A023);
        send_instruction(32'h00448493);
        send_instruction(32'h00700293);
        send_instruction(32'h0054A023);
        send_instruction(32'h00448493);
        send_instruction(32'h00400293);
        send_instruction(32'h0054A023);
        send_instruction(32'h00448493);
        send_instruction(32'h00200293);
        send_instruction(32'h0054A023);
        send_instruction(32'h00448493);
        send_instruction(32'h00B00293);
        send_instruction(32'h0054A023);
        send_instruction(32'h00448493);
        send_instruction(32'hFFC00293);
        send_instruction(32'h0054A023);
        send_instruction(32'h00448493);
        send_instruction(32'h02A00293);
        send_instruction(32'h0054A023);
        send_instruction(32'h00448493);
        send_instruction(32'h00200293);
        send_instruction(32'h0054A023);
        send_instruction(32'h00448493);
        send_instruction(32'h00100293);
        send_instruction(32'h0054A023);
        send_instruction(32'h00448493);
        send_instruction(32'hF9D00293);
        send_instruction(32'h0054A023);
        send_instruction(32'h00448493);
        send_instruction(32'h04B00293);
        send_instruction(32'h0054A023);
        send_instruction(32'h00448493);
        send_instruction(32'h02C00293);
        send_instruction(32'h0054A023);
        send_instruction(32'h00090513);
        send_instruction(32'h00000593);
        send_instruction(32'hFFF40613);
        send_instruction(32'h0DC000EF);
        send_instruction(32'h00090513);
        send_instruction(32'h00040593);
        send_instruction(32'h140000EF);
        send_instruction(32'h1600006F);
        send_instruction(32'h00259293);
        send_instruction(32'h00A282B3);
        send_instruction(32'h0002A383);
        send_instruction(32'h00261313);
        send_instruction(32'h00A30333);
        send_instruction(32'h00032E03);
        send_instruction(32'h01C2A023);
        send_instruction(32'h00732023);
        send_instruction(32'h00008067);
        send_instruction(32'hFE410113);
        send_instruction(32'h00112023);
        send_instruction(32'h00812223);
        send_instruction(32'h00912423);
        send_instruction(32'h01212623);
        send_instruction(32'h01312823);
        send_instruction(32'h01412A23);
        send_instruction(32'h01512C23);
        send_instruction(32'h00060A93);
        send_instruction(32'h002A9413);
        send_instruction(32'h00A40433);
        send_instruction(32'h00042403);
        send_instruction(32'hFFF58493);
        send_instruction(32'h00058913);
        send_instruction(32'h001A8993);
        send_instruction(32'h03390A63);
        send_instruction(32'h00291A13);
        send_instruction(32'h00AA0A33);
        send_instruction(32'h000A2A03);
        send_instruction(32'h008A4663);
        send_instruction(32'h00190913);
        send_instruction(32'hFE9FF06F);
        send_instruction(32'h00148493);
        send_instruction(32'h00048593);
        send_instruction(32'h00090613);
        send_instruction(32'hF79FF0EF);
        send_instruction(32'h00190913);
        send_instruction(32'hFD1FF06F);
        send_instruction(32'h00148593);
        send_instruction(32'h000A8613);
        send_instruction(32'hF65FF0EF);
        send_instruction(32'h00058513);
        send_instruction(32'h00012083);
        send_instruction(32'h00412403);
        send_instruction(32'h00812483);
        send_instruction(32'h00C12903);
        send_instruction(32'h01012983);
        send_instruction(32'h01412A03);
        send_instruction(32'h01812A83);
        send_instruction(32'h01C10113);
        send_instruction(32'h00008067);
        send_instruction(32'h00C5C463);
        send_instruction(32'h00008067);
        send_instruction(32'hFEC10113);
        send_instruction(32'h00112023);
        send_instruction(32'h00812223);
        send_instruction(32'h00912423);
        send_instruction(32'h01212623);
        send_instruction(32'h01312823);
        send_instruction(32'h00050413);
        send_instruction(32'h00058493);
        send_instruction(32'h00060913);
        send_instruction(32'hF31FF0EF);
        send_instruction(32'h00050993);
        send_instruction(32'h00040513);
        send_instruction(32'h00048593);
        send_instruction(32'hFFF98613);
        send_instruction(32'hFC1FF0EF);
        send_instruction(32'h00040513);
        send_instruction(32'h00198593);
        send_instruction(32'h00090613);
        send_instruction(32'hFB1FF0EF);
        send_instruction(32'h00012083);
        send_instruction(32'h00412403);
        send_instruction(32'h00812483);
        send_instruction(32'h00C12903);
        send_instruction(32'h01012983);
        send_instruction(32'h01410113);
        send_instruction(32'h00008067);
        send_instruction(32'h00000293);
        send_instruction(32'h00050393);
        send_instruction(32'h00B28C63);
        send_instruction(32'h00229313);
        send_instruction(32'h00730333);
        send_instruction(32'h00032503);
        send_instruction(32'h00128293);
        send_instruction(32'hFEDFF06F);
        send_instruction(32'h00008067);

    end

    always @(posedge top0.clk_main) begin
        if (top0.core_0.if_0.IF_pc == 32'h0000A000) begin
            $finish;
        end
    end

    integer ended = 0;
    integer zero = 0;
    integer cycle = 0;
    always @(posedge top0.clk_main) begin
        if (top0.core_0.core_reset == 0) begin
            cycle = cycle + 1;
            if (top0.core_0.if_0.IF_inst == 32'h00000000) begin
                zero = zero + 1;
            end
            if (zero == 2 & ended == 0) begin
                $display("Cycles taken: %d", cycle);
                ended = 1;
            end
        end
    end

    
endmodule

