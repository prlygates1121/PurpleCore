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
    parameter UART_PERIOD = CLK_100_PERIOD * (CLK_100_FREQ / `UART_FREQ + 1);

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
        #(CLK_100_PERIOD * 2000);
        

         send_instruction(32'h00000413);
         send_instruction(32'h808004B7);
         send_instruction(32'h00048493);
         send_instruction(32'h123452B7);
         send_instruction(32'h67828293);
         send_instruction(32'h0054A023);


    end

    always @(posedge top0.clk_25) begin
        if (top0.core_0.pc == 32'h0000A000) begin
            $finish;
        end
    end

    integer cycle = 0;
    integer branch_count = 0;
    integer jump_count = 0;
    integer return_count = 0;
    integer total_branch_jump_return = 0;
    integer branch_taken = 0;
    integer branch_untaken = 0;
    integer misprediction_branch = 0;
    integer misprediction_jump = 0;
    integer misprediction_return = 0;
    integer total_mispredictions = 0;
    integer branch_target_outdated = 0;
    integer branch_flushes = 0;
    always @(posedge top0.clk_25) begin
        if (top0.core_0.reset == 0) begin
            cycle = cycle + 1;
            
//            if (top0.core_0.ex_0.ID_branch_type != `NO_BRANCH) begin
//                branch_count = branch_count + 1;
//                if (top0.core_0.ex_0.branch) begin
//                    branch_taken = branch_taken + 1;
//                end else begin
//                    branch_untaken = branch_untaken + 1;
//                end
//            end
            
//            if (top0.core_0.ex_0.ID_jal) begin
//                jump_count = jump_count + 1;
//            end

//            if (top0.core_0.ex_0.ID_jalr) begin
//                return_count = return_count + 1;
//            end

//            if (top0.core_0.EX_branch_flush) begin
//                branch_flushes = branch_flushes + 1;
//                if (top0.core_0.EX_false_target) begin
//                    branch_target_outdated = branch_target_outdated + 1;
//                end
//                if (top0.core_0.EX_false_direction) begin
//                    if (top0.core_0.ex_0.ID_jal) begin
//                        misprediction_jump = misprediction_jump + 1;
//                    end else if (top0.core_0.ex_0.ID_jalr) begin
//                        misprediction_return = misprediction_return + 1;
//                    end else begin
//                        misprediction_branch = misprediction_branch + 1;
//                    end
//                end
//            end

            // if (top0.core_0.ex_0.ID_ecall) begin
            //     total_branch_jump_return = branch_count + jump_count + return_count;
            //     total_mispredictions = misprediction_branch + misprediction_jump + misprediction_return;
            //     $display("Cycles:                       %0d",    cycle);
            //     $display("End Address:                  0x%h",   top0.core_0.if_0.IF_pc);
            //     $display("Jumps:                        %0d",    jump_count);
            //     $display("Branches:                     %0d",    branch_count);
            //     $display("Returns:                      %0d",    return_count);
            //     $display("Jumps + Branches + Returns:   %0d",    total_branch_jump_return);
            //     $display("Branches Taken:               %0d",    branch_taken);
            //     $display("Branches Untaken:             %0d",    branch_untaken);
            //     $display("Mispredictions (Branch):      %0d",    misprediction_branch);
            //     $display("Mispredictions (Jump):        %0d",    misprediction_jump);
            //     $display("Mispredictions (Return):      %0d",    misprediction_return);
            //     $display("Mispredictions (Total):       %0d",    total_mispredictions);
            //     $display("Target Outdated:              %0d",    branch_target_outdated);
            //     $display("Flushes:                      %0d",    branch_flushes);
            //     $display("Flush Rate:                   %0f%%",  branch_flushes * 100.0 / (total_branch_jump_return));
            //     $display("Mispredict Rate:              %0f%%",  total_mispredictions * 100.0 / (total_branch_jump_return));
            //     $display("Target Outdated Rate:         %0f%%",  branch_target_outdated * 100.0 / (total_branch_jump_return));
            //    $finish;
            // end
        end
    end

    
endmodule

