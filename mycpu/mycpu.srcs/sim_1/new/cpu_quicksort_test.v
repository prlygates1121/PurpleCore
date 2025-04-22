`timescale 1ns / 1ps
`include "../../sources_1/new/params.v"
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

        // Heap sort
        send_instruction(32'hFC010113);
    end

    always @(posedge top0.clk_main) begin
        if (top0.core_0.if_0.IF_pc == 32'h0000A000) begin
            $finish;
        end
    end

    integer zero = 0;
    integer cycle = 0;
    integer branch_count = 0;
    integer jump_count = 0;
    integer branch_taken = 0;
    integer branch_untaken = 0;
    integer misprediction = 0;
    integer branch_target_outdated = 0;
    integer branch_flushes = 0;
    always @(posedge top0.clk_main) begin
        if (top0.core_0.core_reset == 0) begin
            cycle = cycle + 1;

            if (top0.core_0.if_0.IF_inst == 32'h00000000 | top0.core_0.if_0.IF_inst == 32'h00000013) begin
                zero = zero + 1;
            end else begin
                zero = 0;
            end
            
            if (top0.core_0.ex_0.ID_branch_type != `NO_BRANCH) begin
                branch_count = branch_count + 1;
                if (top0.core_0.ex_0.branch) begin
                    branch_taken = branch_taken + 1;
                end else begin
                    branch_untaken = branch_untaken + 1;
                end
            end
            if (top0.core_0.ex_0.ID_jump) begin
                jump_count = jump_count + 1;
            end
            if (top0.core_0.EX_branch_target_update & top0.core_0.EX_out_branch_predict) begin
                branch_target_outdated = branch_target_outdated + 1;
                branch_flushes = branch_flushes + 1;
            end else if (top0.core_0.EX_mispredict) begin
                misprediction = misprediction + 1;
                branch_flushes = branch_flushes + 1;
            end

            if (zero == 4) begin
                $display("Total Cycles:                 %0d",    cycle);
                $display("Address:                      0x%h",   top0.core_0.if_0.IF_pc);
                $display("Total Jumps:                  %0d",    jump_count);
                $display("Total Branches:               %0d",    branch_count);
                $display("Total Jumps + Branches:       %0d",    jump_count + branch_count);
                $display("Total Branches Taken:         %0d",    branch_taken);
                $display("Total Branches Untaken:       %0d",    branch_untaken);
                $display("Total Mispredictions:         %0d",    misprediction);
                $display("Total Branch Target Outdated: %0d",    branch_target_outdated);
                $display("Total Flushes:                %0d",    branch_flushes);
                $display("Branch Flush Rate:            %0f%%",  branch_flushes * 100.0 / (branch_count + jump_count));
                $display("Branch Mispredict Rate:       %0f%%",  misprediction * 100.0 / (branch_count + jump_count));
                $display("Branch Target Outdated Rate:  %0f%%",  branch_target_outdated * 100.0 / (branch_count + jump_count));
                $finish;
            end
        end
    end

    
endmodule

