`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2025 01:12:07 AM
// Design Name: 
// Module Name: uart_handler
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


module uart_handler(
    input clk,
    input reset,
    input rx_in,

    input [31:0] I_read,

    output tx_out,
    output inst_loaded,
    output reg [31:0] addr,
    output reg [31:0] inst,
    output mem_write
    );

    // send received bytes back to computer via tx
    reg tx_en;
    reg [7:0] tx_in;
    always @(posedge clk) begin
        if (reset) begin
            tx_en <= 1'b0;
            tx_in <= 8'b0;
        end else if (inst_loaded) begin
            tx_en <= 1'b0;
            tx_in <= 8'b0;
        end else if (rx_done) begin
            tx_en <= 1'b1;
            tx_in <= rx_out;
        end
    end

    // done signals are active for 1 cycle whenever 8 bits of data are received/transmitted
    wire rx_done, tx_done;
    wire [7:0] rx_out;
    uart uart_0(
        .clk(clk),
        .reset(reset),
        .rx_en(1'b1),
        .tx_en(tx_en),
        .rx_in(rx_in),
        .tx_in(tx_in),
        .rx_out(rx_out),
        .tx_out(tx_out),
        .rx_done(rx_done)
    );

    // byte_counter maxes out for every 4 bytes of data (1 instruction) received
    reg [2:0] byte_counter;
    // word_received indicates when to write an instruction to memory
    wire word_received = byte_counter == 3'h4;
    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 3'h0;
        end else if (~inst_loaded) begin
            if (word_received) begin
                byte_counter <= 3'h0;
            end else if (rx_done) begin
                byte_counter <= byte_counter + 1;
            end
        end
    end

    // the address is incremented by 4 bytes for each instruciton received
    always @(posedge clk) begin
        if (reset) begin
            addr <= 32'h0;
        end else if (word_received) begin
            addr <= addr + 4;
        end
    end

    // byte_counter indicates which part of inst[31:0] is filled with the incoming 8 bits of data
    always @(posedge clk) begin
        if (reset) begin
            inst <= 32'h0;
        end else if (rx_done) begin
            case (byte_counter)
                3'h0:       inst[31:24] <= rx_out;
                3'h1:       inst[23:16] <= rx_out;
                3'h2:       inst[15:8] <= rx_out;
                3'h3:       inst[7:0] <= rx_out;
            endcase
        end
    end

    reg load_begin;
    always @(posedge clk) begin
        if (reset) begin
            load_begin <= 1'b0;
        end else if (word_received) begin
            load_begin <= 1'b1;
        end
    end

    // timeout_counter determines all instructions have been loaded when it maxes out
    // each rx_done signal flushes the counter, indicating that a byte has been received
    // not getting rx_done over a period of time results in the counter maxing out, thus making inst_loaded high
    reg [19:0] timeout_counter;
    always @(posedge clk) begin
        if (reset) begin
            timeout_counter <= 20'h0;
        end else if (load_begin) begin
            if (rx_done) begin
                timeout_counter <= 20'h0;
            end else if (~inst_loaded) begin
                timeout_counter <= timeout_counter + 1;
            end
        end
    end

    assign mem_write = word_received;

    // WARNING: inappropriate max out value of the timeout_counter results in errors in program execution
    assign inst_loaded = timeout_counter == 20'hFFF;
endmodule
