`timescale 1ns / 1ps
`include "params.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2025 11:21:06 PM
// Design Name: 
// Module Name: EX
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


module EX(
    input [3:0] ID_alu_op_sel,
    input ID_alu_src1_sel,
    input ID_alu_src2_sel,
    input [31:0] ID_imm,
    input [31:0] ID_rs1_data,
    input [31:0] ID_rs2_data,
    input ID_br_un,
    input [31:0] ID_I_addr,

    input [4:0] ID_rs1,     // TBD
    input [4:0] ID_rs2,     // TBD
    input [4:0] ID_rd,

    input [1:0] ID_store_width,
    input [1:0] ID_load_width,
    input ID_load_un,

    input ID_reg_w_en,
    input [1:0] ID_reg_w_data_sel,

    input [31:0] ID_pc,
    input [31:0] ID_pc_plus_4,
    input ID_jump,
    input [2:0] ID_branch_type,

    input ID_branch_predict,

    input [31:0] MEM_alu_result_forwarded,
    input [31:0] WB_alu_result_forwarded,
    input [1:0] forward_rs1_sel,
    input [1:0] forward_rs2_sel,

    output [31:0] EX_alu_result,                // -> MEM -> WB
    output EX_pc_sel,                           // -> IF
    output EX_reg_w_en,                         // -> MEM -> WB
    output [1:0] EX_reg_w_data_sel,             // -> MEM -> WB
    output [1:0] EX_store_width,                // -> MEM
    output [1:0] EX_load_width,                 // -> MEM
    output EX_load_un,                          // -> MEM
    output [31:0] EX_pc_plus_4,                 // -> MEM -> WB
    output [4:0] EX_rd,                         // -> MEM -> WB
    output [31:0] EX_rs2_data,                  // -> MEM

    output [4:0] EX_rs1,                        // -> hazard_unit
    output [4:0] EX_rs2,                        // -> hazard_unit

    output [31:0] EX_pc,                        // -> branch_prediction_unit
    output EX_is_branch_inst,
    output EX_branch_predict

    );

    wire [31:0] rs1_data = (forward_rs1_sel == 2'b01) ? MEM_alu_result_forwarded :
                           (forward_rs1_sel == 2'b10) ? WB_alu_result_forwarded : ID_rs1_data;
    wire [31:0] rs2_data = (forward_rs2_sel == 2'b01) ? MEM_alu_result_forwarded :
                           (forward_rs2_sel == 2'b10) ? WB_alu_result_forwarded : ID_rs2_data;

    // ALU
    wire [31:0] alu_src1 = ID_alu_src1_sel ? rs1_data : ID_I_addr;
    wire [31:0] alu_src2 = ID_alu_src2_sel ? rs2_data : ID_imm;

    wire EX_br_eq, EX_br_lt;
    wire branch = ID_branch_type == `BEQ ? EX_br_eq :
                  ID_branch_type == `BNE ? ~EX_br_eq :
                  ID_branch_type == `BLT ? EX_br_lt :
                  ID_branch_type == `BGE ? ~EX_br_lt :
                  ID_branch_type == `BLTU ? EX_br_lt :
                  ID_branch_type == `BGEU ? ~EX_br_lt : 1'b0;
    assign EX_pc_sel = ID_jump | branch;

    branch_comp branch_comp_0(
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .br_un(ID_br_un),

        .br_eq(EX_br_eq),
        .br_lt(EX_br_lt)
    );

    alu alu_0(
        .src1(alu_src1),
        .src2(alu_src2),
        .op_sel(ID_alu_op_sel),
        .result(EX_alu_result)
    );

    assign EX_reg_w_en = ID_reg_w_en;
    assign EX_reg_w_data_sel = ID_reg_w_data_sel;
    assign EX_store_width = ID_store_width;
    assign EX_load_width = ID_load_width;
    assign EX_load_un = ID_load_un;
    assign EX_pc_plus_4 = ID_pc_plus_4;
    assign EX_rd = ID_rd;
    assign EX_rs2_data = rs2_data;
    assign EX_rs1 = ID_rs1;
    assign EX_rs2 = ID_rs2;
    assign EX_pc = ID_pc;
    assign EX_is_branch_inst = ID_jump | (ID_branch_type != `NO_BRANCH);
    assign EX_branch_predict = ID_branch_predict;
endmodule
