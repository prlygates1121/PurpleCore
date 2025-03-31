`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2025 01:00:42 AM
// Design Name: 
// Module Name: cpu_arith_test
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


module cpu_arith_test(

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

        send_instruction(32'h00A00513);
        send_instruction(32'h00500593);
        send_instruction(32'hFFD00613);
        send_instruction(32'hFF000693);
        send_instruction(32'h80000737);
        send_instruction(32'h00070713);
        send_instruction(32'h800007B7);
        send_instruction(32'hFFF78793);
        send_instruction(32'h00F00813);
        send_instruction(32'h00300893);
        send_instruction(32'h00B502B3);
        send_instruction(32'h40B50333);
        send_instruction(32'h011513B3);
        send_instruction(32'h01155E33);
        send_instruction(32'h0116DEB3);
        send_instruction(32'h41165F33);
        send_instruction(32'h41175FB3);
        send_instruction(32'h01056433);
        send_instruction(32'h010574B3);
        send_instruction(32'h00A5A933);
        send_instruction(32'h00B529B3);
        send_instruction(32'h00B62A33);
        send_instruction(32'h00C5AAB3);
        send_instruction(32'h00A5BB33);
        send_instruction(32'h00B53BB3);
        send_instruction(32'h00B631B3);
        send_instruction(32'h00C5B233);

        // send some NOPs
        send_instruction(32'h00000013);
        send_instruction(32'h00000013);
        send_instruction(32'h00000013);
        send_instruction(32'h00000013);
        send_instruction(32'h00000013);
        send_instruction(32'h00000013);
        send_instruction(32'h00000013);
        send_instruction(32'h00000013);

        // test immediate arithmetic
        send_instruction(32'h00750293);
        send_instruction(32'h00A60313);
        send_instruction(32'hFFB50393);
        send_instruction(32'h00451E13);
        send_instruction(32'h00255E93);
        send_instruction(32'h0046DF13);
        send_instruction(32'h40265F93);
        send_instruction(32'h40475F93);
        send_instruction(32'h00F54413);
        send_instruction(32'h00F56493);
        send_instruction(32'h00F57913);
        send_instruction(32'h00C52993);
        send_instruction(32'h00852A13);
        send_instruction(32'h00062A93);
        send_instruction(32'hFFF52B13);
        send_instruction(32'h00C53B93);
        send_instruction(32'h00853193);
        send_instruction(32'h00063213);

        // send some NOPs
        send_instruction(32'h00000013);
        send_instruction(32'h00000013);
        send_instruction(32'h00000013);
        send_instruction(32'h00000013);
        send_instruction(32'h00000013);
        send_instruction(32'h00000013);
        send_instruction(32'h00000013);
        send_instruction(32'h00000013);


        #(CLK_100_PERIOD * 15000);
        $finish;
    end

    integer reg_read_val;
    task check_reg(input [4:0] reg_num, input [31:0] expected_val);
        begin
            reg_read_val = top0.core_0.id_0.regfile_0.registers[reg_num];
            if (reg_read_val == expected_val) begin
                $display("PASSED: x[%d] = %b.", reg_num, expected_val);
            end else begin
                $display("FAILED: x[%d] = %b. Expected %b.", reg_num, reg_read_val, expected_val);
            end
        end
    endtask

    always @(posedge top0.clk_25) begin
        if (top0.core_0.core_mode) begin
            case (top0.core_0.IF_I_addr)
                32'h0000008c: begin
                    $display("Testing R-type arithmetic instrucitons:");
                    check_reg(10, 10);
                    check_reg(11, 5);
                    check_reg(12, -3);
                    check_reg(13, -16);
                    check_reg(14, -2147483648);
                    check_reg(15, 2147483647);
                    check_reg(16, 15);
                    check_reg(17, 3);
                    check_reg(5, 15);
                    check_reg(6, 5);
                    check_reg(7, 80);
                    check_reg(28, 1);
                    check_reg(29, 536870910);
                    check_reg(30, -1);
                    check_reg(31, -268435456);
                    check_reg(8, 15);
                    check_reg(9, 10);
                    check_reg(18, 1);
                    check_reg(19, 0);
                    check_reg(20, 1);
                    check_reg(21, 0);
                    check_reg(22, 1);
                    check_reg(23, 0);
                    check_reg(3, 0);
                    check_reg(4, 1);  
                end
                32'h000000ec: begin
                    $display("Testing I-type arithmetic instrucitons:");
                    check_reg(10, 10);
                    check_reg(11, 5);
                    check_reg(12, -3);
                    check_reg(13, -16);
                    check_reg(14, -2147483648);
                    check_reg(15, 2147483647);
                    check_reg(16, 15);
                    check_reg(17, 3);
                    check_reg(5, 17);
                    check_reg(6, 7);
                    check_reg(7, 5);
                    check_reg(28, 160);
                    check_reg(29, 2);
                    check_reg(30, 268435455);
                    check_reg(31, -134217728);
                    check_reg(8, 5);
                    check_reg(9, 15);
                    check_reg(18, 10);
                    check_reg(19, 1);
                    check_reg(20, 0);
                    check_reg(21, 1);
                    check_reg(22, 0);
                    check_reg(23, 1);
                    check_reg(3, 0);
                    check_reg(4, 0);  
                end
 
            endcase
        end
    end


endmodule
