`timescale 1ns / 1ps
`include "params.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2025 09:20:24 PM
// Design Name: 
// Module Name: ID
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


module ID(
    `ifdef DEBUG
        output [31:0] t0,
        output [31:0] t1,
        output [31:0] t2,
        output [31:0] t3,
    `endif
    input clk,
    input reset,
    input stall,
    input write_disorder,
    
    input [31:0] IF_pc,
    input [31:0] IF_pc_plus_4,
    input [31:0] IF_inst,
    input IF_branch_predict,
    input [31:0] WB_reg_w_data,
    input [31:0] WB_reg_w_data_mul,
    input WB_reg_w_en,
    input WB_reg_w_en_mul,
    input [4:0] WB_rd,
    input [4:0] WB_rd_mul,
    input [11:0] WB_csr_addr,
    input WB_csr_w_en,
    input [31:0] WB_csr_w_data,
    input [31:0] WB_w_mstatus,
    input [31:0] WB_w_mepc,
    input [31:0] WB_w_mcause,

    output [3:0] ID_alu_op_sel,
    output [3:0] ID_alu_mul_op_sel,
    output ID_alu_src1_sel,
    output ID_alu_src2_sel,
    output ID_reg_w_en,
    output ID_reg_w_en_mul,
    output [2:0] ID_reg_w_data_sel,
    output [1:0] ID_store_width,
    output [2:0] ID_load_width,
    output ID_load_un,
    output [31:0] ID_imm,
    output ID_br_un,
    output [31:0] ID_rs1_data,
    output [31:0] ID_rs2_data,
    output [4:0] ID_rs1,
    output [4:0] ID_rs2,
    output [4:0] ID_rd,
    output [4:0] ID_rd_mul,
    output [31:0] ID_pc,
    output [31:0] ID_pc_plus_4,
    output ID_jal,
    output ID_jalr,
    output [2:0] ID_branch_type,
    output ID_branch_predict,
    output [31:0] ID_inst,
    output ID_ecall,
    output ID_mret,

    output [11:0] ID_csr_addr,
    output [2:0] ID_csr_op,
    output [31:0] ID_csr_r_data,

    output [31:0] ID_mtvec,
    output [31:0] ID_mepc,
    output [31:0] ID_mboot,

    output ID_calc_slow,
    output reg [14:0] rd_queue

    );

    // Instruction Decode
    wire [6:0] opcode;
    wire [6:0] funct7;
    wire [2:0] funct3;
    wire [4:0] rs1, rs2, rd;
    wire [24:0] imm_raw;

    // Immediate Generator
    wire [31:0] imm;

    // Control Logic
    wire [3:0] alu_op_sel;
    wire alu_src1_sel, alu_src2_sel;
    wire [2:0] reg_w_data_sel;
    wire reg_w_en;
    wire [1:0] D_store_width;
    wire [2:0] D_load_width;
    wire D_load_un;
    wire [2:0] imm_sel;
    wire br_un;
    wire [11:0] csr_addr;
    wire [2:0] csr_op;
    wire [31:0] csr_r_data;

    assign ID_calc_slow = alu_op_sel == `MUL    |
                       alu_op_sel == `MULH   |
                       alu_op_sel == `MULSU  |
                       alu_op_sel == `MULU;

    always @(posedge clk) begin
        if (reset) begin
            rd_queue <= 15'h0;
        end else if (ID_calc_slow & ~stall) begin
            rd_queue[14:10] <= rd;
            rd_queue[9:5] <= write_disorder ? 5'b0 : rd_queue[14:10];
            rd_queue[4:0] <= rd_queue[9:5];
        end else begin
            rd_queue[14:0] <= 5'b0;
            rd_queue[9:5] <= write_disorder ? 5'b0 : rd_queue[14:10];
            rd_queue[4:0] <= rd_queue[9:5];
        end 
    end

    control_logic ctrl_logic_0(
        .inst               (IF_inst),

        .alu_op_sel         (alu_op_sel),
        .alu_src1_sel       (alu_src1_sel),
        .alu_src2_sel       (alu_src2_sel),
        .reg_w_en           (reg_w_en),
        .reg_w_data_sel     (reg_w_data_sel),
        .store_width        (D_store_width),
        .load_width         (D_load_width),
        .load_un            (D_load_un),
        .imm_sel            (imm_sel),
        .br_un              (br_un),
        .jal                (ID_jal),
        .jalr               (ID_jalr),
        .branch_type        (ID_branch_type),
        .rs1                (rs1),
        .rs2                (rs2),
        .rd                 (rd),
        .imm                (imm_raw),
        .ecall              (ID_ecall),
        .mret               (ID_mret),
        .csr_addr           (csr_addr),
        .csr_op             (csr_op)
    );

    imm_gen imm_gen_0(
        .imm_raw(imm_raw),
        .imm_sel(imm_sel),

        .imm(imm)
    );

    // NOTE: Writeback-related signals come from the WB stage
    regfile regfile_0(
        `ifdef DEBUG
            .t0         (t0),
            .t1         (t1),
            .t2         (t2),
            .t3         (t3),
        `endif
        .clk            (clk),
        .reset          (reset),
        .write_en       (WB_reg_w_en),
        .write_en_mul   (WB_reg_w_en_mul),
        .rs1            (rs1),
        .rs2            (rs2),
        .dest           (WB_rd),
        .dest_mul       (WB_rd_mul),
        .write_data     (WB_reg_w_data),
        .write_data_mul (WB_reg_w_data_mul),

        .rs1_data       (ID_rs1_data),
        .rs2_data       (ID_rs2_data)
    );

    csr csr_0(
        .clk            (clk),
        .reset          (reset),
        .csr_w_en       (WB_csr_w_en),
        .csr_w_data     (WB_csr_w_data),
        .csr_w_addr     (WB_csr_addr),
        .csr_r_addr     (csr_addr),
        .csr_r_data     (csr_r_data),

        .w_mstatus      (WB_w_mstatus),
        .w_mie          (`CSR_NO_WRITE),
        .w_mtvec        (`CSR_NO_WRITE),
        .w_mscratch     (`CSR_NO_WRITE),
        .w_mepc         (WB_w_mepc),
        .w_mcause       (WB_w_mcause),
        .w_mtval        (`CSR_NO_WRITE),
        .w_mip          (`CSR_NO_WRITE),
        .w_mboot        (`CSR_NO_WRITE),

        .r_mstatus      (),
        .r_mie          (),
        .r_mtvec        (ID_mtvec),
        .r_mscratch     (),
        .r_mepc         (ID_mepc),
        .r_mcause       (),
        .r_mtval        (),
        .r_mip          (),
        .r_mboot        (ID_mboot)
    );

    assign ID_alu_op_sel = ID_calc_slow ? `ADD : alu_op_sel;
    assign ID_alu_mul_op_sel = ID_calc_slow ? alu_op_sel : `ADD;
    assign ID_alu_src1_sel = alu_src1_sel;
    assign ID_alu_src2_sel = alu_src2_sel;
    assign ID_reg_w_en = ID_calc_slow ? 1'b0 : reg_w_en;
    assign ID_reg_w_en_mul = ID_calc_slow ? reg_w_en : 1'b0;
    assign ID_reg_w_data_sel = reg_w_data_sel;
    assign ID_store_width = D_store_width;
    assign ID_load_width = D_load_width;
    assign ID_load_un = D_load_un;
    assign ID_imm = imm;
    assign ID_br_un = br_un;
    assign ID_rs1 = rs1;
    assign ID_rs2 = rs2;
    assign ID_rd = ID_calc_slow ? 5'b0 : rd;
    assign ID_rd_mul = ID_calc_slow ? rd : 5'b0;
    assign ID_pc = IF_pc;
    assign ID_pc_plus_4 = IF_pc_plus_4;
    assign ID_branch_predict = IF_branch_predict;
    assign ID_inst = IF_inst;
    assign ID_csr_addr = csr_addr;
    assign ID_csr_op = csr_op;
    assign ID_csr_r_data = csr_r_data;

endmodule
