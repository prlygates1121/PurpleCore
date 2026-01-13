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

// `define LOG_COMMIT
// `define GET_BRANCH_STAT

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

    integer i;

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
        
        // send_instruction(32'h00000413);
        // send_instruction(32'h808004B7);
        // send_instruction(32'h00048493);
        // send_instruction(32'h123452B7);
        // send_instruction(32'h67828293);
        // send_instruction(32'h0054A023);


    end

    always @(posedge top0.clk_main) begin
        if (top0.core_0.if_0.IF_pc == 32'h8000A000) begin
            $finish;
        end
    end

    integer cycle = 0;

    `ifdef GET_BRANCH_STAT
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
    `endif

    `ifdef LOG_COMMIT
        integer log_file;

        wire [31:0] EX_pc = top0.core_0.ex_0.EX_pc;
        reg [31:0] MEM_pc, WB_pc;

        wire [31:0] EX_inst = top0.core_0.id_ex_0.EX_inst;
        reg [31:0] MEM_inst, WB_inst;

        wire commit = ~(WB_inst == 32'h00000013 & WB_pc == 32'h80000200);

        wire MEM_load = top0.core_0.memory_0.load;
        reg WB_load;

        wire EX_store = top0.core_0.memory_0.store;
        reg MEM_store, WB_store;

        wire [31:0] EX_addr = top0.core_0.memory_0.D_addr;
        reg [31:0] MEM_addr, WB_addr;

        wire [31:0] MEM_store_data = top0.core_0.mem_0.D_store_data;
        reg [31:0] WB_store_data;

        wire [4:0] WB_rd = top0.core_0.wb_0.WB_rd;
        wire [31:0] WB_reg_w_data = top0.core_0.wb_0.WB_reg_w_data;

        always @(posedge top0.clk_main) begin
            if (top0.core_0.reset == 0) begin
                MEM_pc          <= EX_pc;
                WB_pc           <= MEM_pc;
                MEM_inst        <= EX_inst;
                WB_inst         <= MEM_inst;
                WB_load         <= MEM_load;
                MEM_store       <= EX_store;
                WB_store        <= MEM_store;
                MEM_addr        <= EX_addr;
                WB_addr         <= MEM_addr;
                WB_store_data   <= MEM_store_data;
            end
        end

        initial begin
            log_file = $fopen("../../../../../difftest/vivado_dut.log", "w");
            if (log_file == 0) begin
                $display("Failed to create file vivado_dut.log");
            end else begin
                $display("Successfully created file vivado_dut.log");
            end
        end
    `endif

    always @(posedge top0.clk_main) begin
        if (top0.core_0.reset == 0) begin
            cycle = cycle + 1;
            `ifdef LOG_COMMIT
                if (commit) begin
                    $fwrite(log_file, "core   0: 3 0x%h (0x%h) ",
                                WB_pc,
                                WB_inst);
                    if (WB_store) begin
                        $fdisplay(log_file, "mem 0x%h 0x%h",
                                    WB_addr,
                                    WB_store_data);
                    end else if (WB_load) begin
                        $fdisplay(log_file, "x%-2d 0x%h mem 0x%h",
                                    WB_rd,
                                    WB_reg_w_data,
                                    WB_addr);
                    end else if (WB_rd != 32'h0) begin
                        $fdisplay(log_file, "x%-2d 0x%h",
                                    WB_rd,
                                    WB_reg_w_data);
                    end else begin
                        $fdisplay(log_file, "");
                    end
                    // Exit simulation on an infinite loop
                    if (WB_inst == 32'h0000006F) begin
                        $finish;
                    end
                end
            `endif
            
            `ifdef GET_BRANCH_STAT
                if (top0.core_0.ex_0.ID_branch_type != `NO_BRANCH) begin
                    branch_count = branch_count + 1;
                    if (top0.core_0.ex_0.branch) begin
                        branch_taken = branch_taken + 1;
                    end else begin
                        branch_untaken = branch_untaken + 1;
                    end
                end

                if (top0.core_0.ex_0.ID_jal) begin
                    jump_count = jump_count + 1;
                end

                if (top0.core_0.ex_0.ID_jalr) begin
                    return_count = return_count + 1;
                end

                if (top0.core_0.EX_branch_flush) begin
                    branch_flushes = branch_flushes + 1;
                    if (top0.core_0.EX_false_target) begin
                        branch_target_outdated = branch_target_outdated + 1;
                    end
                    if (top0.core_0.EX_false_direction) begin
                        if (top0.core_0.ex_0.ID_jal) begin
                            misprediction_jump = misprediction_jump + 1;
                        end else if (top0.core_0.ex_0.ID_jalr) begin
                            misprediction_return = misprediction_return + 1;
                        end else begin
                            misprediction_branch = misprediction_branch + 1;
                        end
                    end
                end

                if (top0.core_0.ex_0.ID_ecall) begin
                    total_branch_jump_return = branch_count + jump_count + return_count;
                    total_mispredictions = misprediction_branch + misprediction_jump + misprediction_return;
                    $display("Cycles:                       %0d",    cycle);
                    $display("End Address:                  0x%h",   top0.core_0.if_0.IF_pc);
                    $display("Jumps:                        %0d",    jump_count);
                    $display("Branches:                     %0d",    branch_count);
                    $display("Returns:                      %0d",    return_count);
                    $display("Jumps + Branches + Returns:   %0d",    total_branch_jump_return);
                    $display("Branches Taken:               %0d",    branch_taken);
                    $display("Branches Untaken:             %0d",    branch_untaken);
                    $display("Mispredictions (Branch):      %0d",    misprediction_branch);
                    $display("Mispredictions (Jump):        %0d",    misprediction_jump);
                    $display("Mispredictions (Return):      %0d",    misprediction_return);
                    $display("Mispredictions (Total):       %0d",    total_mispredictions);
                    $display("Target Outdated:              %0d",    branch_target_outdated);
                    $display("Flushes:                      %0d",    branch_flushes);
                    $display("Flush Rate:                   %0f%%",  branch_flushes * 100.0 / (total_branch_jump_return));
                    $display("Mispredict Rate:              %0f%%",  total_mispredictions * 100.0 / (total_branch_jump_return));
                    $display("Target Outdated Rate:         %0f%%",  branch_target_outdated * 100.0 / (total_branch_jump_return));
                   $finish;
                end
            `endif
        end
    end

    
endmodule

