`timescale 1ns / 1ps
`include "params.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/18/2026 06:26:01 PM
// Design Name: 
// Module Name: plic
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


module plic (
    input                      clk,
    input                      reset,

    input [`PLIC_SOURCES-1:0]    irq_sources,
    input [`PLIC_SOURCES-1:0]    irq_clear,

    input                      claim,
    input                      complete,
    input [31:0]               control,

    input [(`PLIC_SOURCES * `PLIC_PRIORITY_BITS)-1:0] priorities,
    input [`PLIC_SOURCES-1:0]                         enables,
    input [`PLIC_PRIORITY_BITS-1:0]                   threshold,

    output reg [`PLIC_SOURCES-1:0]    pending_gates,
    output reg [3:0]                  winner_id,

    output                     eip
    );

    reg [`PLIC_SOURCES-1:0]         active_servicing;

    reg [`PLIC_PRIORITY_BITS-1:0] max_priority;

    reg [`PLIC_SOURCES-1:0]         irq_latch;

    integer i;

    always @(posedge clk) begin
        for (i = 0; i < `PLIC_SOURCES; i = i + 1) begin
            if (reset) begin
                irq_latch[i] <= 0;
            end else if (irq_clear[i]) begin
                irq_latch[i] <= 0;
            end else if (irq_sources[i]) begin
                irq_latch[i] <= 1;
            end 
        end
    end

    always @(*) begin
        for (i = 0; i < `PLIC_SOURCES; i = i + 1) begin
            pending_gates[i] = irq_latch[i] & enables[i] & !active_servicing[i];
        end
    end

    always @(*) begin
        max_priority = 0;
        winner_id = 0;
        for (i = 0; i < `PLIC_SOURCES; i = i + 1) begin
            if (pending_gates[i]) begin
                if (priorities[i*`PLIC_PRIORITY_BITS +: `PLIC_PRIORITY_BITS] > max_priority) begin
                    max_priority = priorities[i*`PLIC_PRIORITY_BITS +: `PLIC_PRIORITY_BITS];
                    winner_id = i[3:0];
                end
            end
        end
    end

    assign eip = (max_priority > threshold);

    always @(posedge clk) begin
        if (reset) begin
            active_servicing <= 0;
        end else begin
            if (claim) begin
                if (~(&winner_id)) begin
                    active_servicing[winner_id] <= 1'b1;
                end
            end else if (complete) begin
                if (~(&control)) begin
                    active_servicing[control] <= 1'b0;
                end
            end
        end
    end

endmodule
