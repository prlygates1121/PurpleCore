`timescale 1ns / 1ps
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
    input clk,
    input reset,
    
    input [31:0] IF_pc,
    input [31:0] IF_pc_plus_4,
    input [31:0] IF_inst,
    input [31:0] IF_I_addr,
    input IF_branch_predict,
    input [31:0] WB_reg_w_data,
    input WB_reg_w_en,
    input [4:0] WB_rd,

    output [3:0] ID_alu_op_sel,
    output ID_alu_src1_sel,
    output ID_alu_src2_sel,
    output ID_reg_w_en,
    output [1:0] ID_reg_w_data_sel,
    output [1:0] ID_store_width,
    output [1:0] ID_load_width,
    output ID_load_un,
    output [31:0] ID_imm,
    output ID_br_un,
    output [31:0] ID_rs1_data,
    output [31:0] ID_rs2_data,
    output [4:0] ID_rs1,
    output [4:0] ID_rs2,
    output [4:0] ID_rd,
    output [31:0] ID_pc,
    output [31:0] ID_pc_plus_4,
    output [31:0] ID_I_addr,
    output ID_jump,
    output [2:0] ID_branch_type,
    output ID_branch_predict,
    output [31:0] ID_inst

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
    wire [1:0] reg_w_data_sel;
    wire reg_w_en;
    wire [1:0] D_store_width;
    wire [1:0] D_load_width;
    wire D_load_un;
    wire [2:0] imm_sel;
    wire br_un;

    inst_decoder inst_decoder_0(
        .inst(IF_inst),

        .opcode(opcode),
        .funct7(funct7),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .imm(imm_raw)
    );

    control_logic ctrl_logic_0(
        .inst(IF_inst),

        .alu_op_sel(alu_op_sel),
        .alu_src1_sel(alu_src1_sel),
        .alu_src2_sel(alu_src2_sel),
        .reg_w_en(reg_w_en),
        .reg_w_data_sel(reg_w_data_sel),
        .store_width(D_store_width),
        .load_width(D_load_width),
        .load_un(D_load_un),
        .imm_sel(imm_sel),
        .br_un(br_un),
        .jump(ID_jump),
        .branch_type(ID_branch_type)
    );

    imm_gen imm_gen_0(
        .imm_raw(imm_raw),
        .imm_sel(imm_sel),

        .imm(imm)
    );

    // NOTE: Writeback-related signals come from the WB stage
    regfile regfile_0(
        .clk(clk),
        .reset(reset),
        .write_en(WB_reg_w_en),
        .rs1(rs1),
        .rs2(rs2),
        .dest(WB_rd),
        .write_data(WB_reg_w_data),

        .rs1_data(ID_rs1_data),
        .rs2_data(ID_rs2_data)
    );

    assign ID_alu_op_sel = alu_op_sel;
    assign ID_alu_src1_sel = alu_src1_sel;
    assign ID_alu_src2_sel = alu_src2_sel;
    assign ID_reg_w_en = reg_w_en;
    assign ID_reg_w_data_sel = reg_w_data_sel;
    assign ID_store_width = D_store_width;
    assign ID_load_width = D_load_width;
    assign ID_load_un = D_load_un;
    assign ID_imm = imm;
    assign ID_br_un = br_un;
    assign ID_rs1 = rs1;
    assign ID_rs2 = rs2;
    assign ID_rd = rd;
    assign ID_pc = IF_pc;
    assign ID_pc_plus_4 = IF_pc_plus_4;
    assign ID_I_addr = IF_I_addr;
    assign ID_branch_predict = IF_branch_predict;
    assign ID_inst = IF_inst;

endmodule
