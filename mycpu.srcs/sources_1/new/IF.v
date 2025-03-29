`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/19/2025 10:56:50 AM
// Design Name: 
// Module Name: IF
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


module IF(
    input clk,
    input reset,
    
    input EX_pc_sel,
    input [1:0] ID_store_width,
    input [1:0] ID_load_width,
    input [31:0] EX_alu_result,

    // interface with memory
    output [31:0] I_addr,       // address to read from memory
    input [31:0] I_load_data,   // data read from memory

    output [31:0] IF_pc_prev_2,
    output [31:0] IF_pc_prev_2_plus_4,
    output [31:0] IF_inst,
    output [31:0] IF_I_addr_prev_2
    );

    wire ID_store = ID_store_width != 2'h3;
    wire ID_load = ID_load_width != 2'h3;

    reg pc_sel_reg;
    reg [31:0] I_addr_prev_1, I_addr_prev_2;
    reg [31:0] pc, pc_prev_1, pc_prev_2;

    wire [31:0] pc_next = EX_pc_sel ? (EX_alu_result + 4) : (ID_store | ID_load) ? pc : (pc + 4);

    always @(posedge clk) begin
        if (reset) begin
            pc <= 32'h0;
        end else begin
            pc <= pc_next;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            pc_prev_1 <= 32'b0;
        end else begin
            pc_prev_1 <= pc;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            pc_prev_2 <= 32'b0;
        end else begin
            pc_prev_2 <= pc_prev_1;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            pc_sel_reg <= 1'b0;
            I_addr_prev_1 <= 32'b0;
            I_addr_prev_2 <= 32'b0;
        end else begin
            pc_sel_reg <= EX_pc_sel;
            I_addr_prev_1 <= I_addr;
            I_addr_prev_2 <= I_addr_prev_1;
        end
    end

    reg ID_store_prev;
    reg ID_load_prev;
    always @(posedge clk) begin
        if (reset) begin
            ID_store_prev <= 1'b0;
            ID_load_prev <= 1'b0;
        end else begin
            ID_store_prev <= ID_store;
            ID_load_prev <= ID_load;
        end
    end

    assign IF_pc_prev_2 = pc_prev_2;
    assign IF_pc_prev_2_plus_4 = pc_prev_2 + 4;
    assign IF_inst = (reset | pc_sel_reg | ID_store_prev | ID_load_prev) ? `NOP : I_load_data;
    assign I_addr = EX_pc_sel ? EX_alu_result : (ID_store | ID_load) ? pc_prev_1 : pc;
    assign IF_I_addr_prev_2 = I_addr_prev_2;
endmodule
