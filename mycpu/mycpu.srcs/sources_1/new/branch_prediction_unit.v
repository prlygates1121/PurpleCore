`timescale 1ns / 1ps
`include "params.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2025 10:14:54 PM
// Design Name: 
// Module Name: branch_prediction_unit
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


module branch_prediction_unit(
    input clk,
    input reset,
    
    input [31:0] IF_pc,
    input [31:0] IF_inst,
    input [31:0] ID_ra_data,
    input [31:0] EX_pc,
    input [31:0] EX_branch_target,
    input EX_jal,
    input EX_jalr,
    input [4:0] EX_rs1,
    input [4:0] EX_rd,
    input [2:0] EX_branch_type,
    input EX_pc_sel,
    input EX_branch_predict,
    input EX_is_branch_inst,

    output branch_predict,
    output [31:0] branch_target,
    output EX_false_target,
    output EX_false_direction,
    output EX_branch_flush
    );

    localparam [1:0] STRONG_TAKEN       = 2'b11, 
                     WEAK_TAKEN         = 2'b10,
                     WEAK_NOT_TAKEN     = 2'b01,
                     STRONG_NOT_TAKEN   = 2'b00;

    assign EX_is_branch_inst = EX_jal | EX_jalr | (EX_branch_type != `NO_BRANCH);

    wire [31:0] RAS_out;
    reg [31:0] RAS_in;
    reg [1:0] RAS_op;

    // pre-decode the instruction
    wire [6:0] opcode = IF_inst[6:0];
    wire [2:0] funct3 = IF_inst[14:12];

    wire [4:0] IF_rd  = IF_inst[11:7];
    wire [4:0] IF_rs1 = IF_inst[19:15];
    wire IF_B      = opcode == 7'b1100011;
    wire IF_jal    = opcode == 7'b1101111;
    wire IF_jalr   = opcode == 7'b1100111 & funct3 == 3'h0;

    // detect call and return instructions (see unpriviledge RISC-V spec "2.5. Control Transfer Instructions" at page 29)
    wire IF_call = (IF_jal & (IF_rd == 5'h1 | IF_rd == 5'h5)) |
                (IF_jalr & (IF_rd == 5'h1 | IF_rd == 5'h5) & 
                ((IF_rs1 != 5'h1 & IF_rs1 != 5'h5) | (IF_rs1 == 5'h1 | IF_rs1 == 5'h5) & (IF_rd == IF_rs1)));
    wire IF_return =  (IF_jalr & (IF_rd != 5'h1 & IF_rd != 5'h5) & 
                (IF_rs1 == 5'h1 | IF_rs1 == 5'h1));
    // wire IF_return_and_call = (IF_jalr & (IF_rd == 5'h1 | IF_rd == 5'h5) & (IF_rs1 == 5'h1 | IF_rs1 == 5'h5) & (IF_rd != IF_rs1));

    reg ID_call, ID_return;
    reg [31:0] ID_RAS_out;
    always @(posedge clk) begin
        if (reset) begin
            ID_call <= 1'b0;
            ID_return <= 1'b0;
            ID_RAS_out <= 32'h0;
        end else begin
            ID_call <= IF_call;
            ID_return <= IF_return;
            ID_RAS_out <= RAS_out;
        end
    end

    reg EX_call, EX_return;
    reg [31:0] EX_RAS_out;
    always @(posedge clk) begin
        if (reset) begin
            EX_call <= 1'b0;
            EX_return <= 1'b0;
            EX_RAS_out <= 32'h0;
        end else begin
            EX_call <= ID_call;
            EX_return <= ID_return;
            EX_RAS_out <= ID_RAS_out;
        end
    end

    always @(*) begin
        if (EX_branch_flush) begin
            RAS_in <= EX_pc + 4;
        end else begin
            if (IF_call) begin
                RAS_in <= IF_pc + 4;
            end else begin
                RAS_in <= 32'h0;
            end
        end
    end

    always @(*) begin
        if (EX_branch_flush) begin
            if (ID_call) begin
                RAS_op <= `RING_POP;
            end else if (ID_return) begin
                RAS_op <= `RING_PUSH;
            end else begin
                RAS_op <= `RING_NOOP;
            end
        end else begin
            if (IF_call) begin
                RAS_op <= `RING_PUSH;
            end else if (IF_return) begin
                RAS_op <= `RING_POP;
            end else begin
                RAS_op <= `RING_NOOP;
            end
        end
    end

    // Branch Prediction Table and Branch Target Buffer
    reg [1:0] prediction_table [127:0];
    reg [31:0] branch_target_buffer [127:0];
    integer i;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 128; i = i + 1) begin
                prediction_table[i] <= WEAK_NOT_TAKEN;
            end
        end else begin
            if (EX_is_branch_inst) begin
                if (EX_pc_sel) begin
                    if (prediction_table[EX_pc[8:2]] != STRONG_TAKEN) begin
                        prediction_table[EX_pc[8:2]] <= prediction_table[EX_pc[8:2]] + 1;
                    end
                end else begin
                    if (prediction_table[EX_pc[8:2]] != STRONG_NOT_TAKEN) begin
                        prediction_table[EX_pc[8:2]] <= prediction_table[EX_pc[8:2]] - 1;
                    end
                end
            end else begin
                if (prediction_table[EX_pc[8:2]] != STRONG_NOT_TAKEN) begin
                    prediction_table[EX_pc[8:2]] <= prediction_table[EX_pc[8:2]] - 1;
                end
            end
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 128; i = i + 1) begin
                branch_target_buffer[i] <= 32'b00;
            end
        end else if (EX_is_branch_inst) begin
            branch_target_buffer[EX_pc[8:2]] <= EX_branch_target;
        end
    end

    ring #(
        .BIT_WIDTH      (32),
        .DEPTH          (16)
    ) RAS (
        .clk            (clk),
        .reset          (reset),
        .op             (RAS_op),
        .data_in        (RAS_in),
        .data_out       (RAS_out)
    );

    assign branch_predict = (IF_jal | IF_jalr) ? 1'b1 : IF_B ? (prediction_table[IF_pc[8:2]] >= WEAK_TAKEN) : 1'b0;
    assign branch_target = IF_return ? RAS_out : branch_target_buffer[IF_pc[8:2]];
    assign EX_false_direction = EX_is_branch_inst ? (EX_branch_predict != EX_pc_sel) : EX_branch_predict;
    assign EX_false_target = EX_is_branch_inst ? EX_return ? (EX_RAS_out != EX_branch_target) : (branch_target_buffer[EX_pc[8:2]] != EX_branch_target) : 1'b0;
    assign EX_branch_flush = EX_false_direction | (EX_false_target & EX_branch_predict);  

endmodule
