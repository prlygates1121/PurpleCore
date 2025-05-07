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

    input [4:0] ID_rs1,
    input [4:0] ID_rs2,
    input [4:0] ID_rd,

    input [1:0] ID_store_width,
    input [2:0] ID_load_width,
    input ID_load_un,

    input ID_reg_w_en,
    input [2:0] ID_reg_w_data_sel,

    input [31:0] ID_pc,
    input [31:0] ID_pc_plus_4,
    input ID_jal,
    input ID_jalr,
    input [2:0] ID_branch_type,
    input ID_branch_predict,
    input ID_ecall,

    input [31:0] MEM_alu_result_forwarded,
    input [31:0] WB_alu_result_forwarded,
    input [1:0] forward_rs1_sel,
    input [1:0] forward_rs2_sel,

    input [31:0] MEM_csr_w_data_forwarded,
    input [31:0] WB_csr_w_data_forwarded,
    input [1:0] forward_csr_sel,

    input [11:0] ID_csr_addr,
    input [2:0] ID_csr_op,
    input [31:0] ID_csr_r_data,

    output [31:0] EX_alu_result,                // -> MEM -> WB
    output EX_pc_sel,                           // -> IF
    output EX_reg_w_en,                         // -> MEM -> WB
    output [2:0] EX_reg_w_data_sel,             // -> MEM -> WB
    output [1:0] EX_store_width,                // -> MEM
    output [2:0] EX_load_width,                 // -> MEM
    output EX_load_un,                          // -> MEM
    output [31:0] EX_pc_plus_4,                 // -> MEM -> WB
    output [4:0] EX_rd,                         // -> MEM -> WB
    output [31:0] EX_rs2_data,                  // -> MEM

    output [4:0] EX_rs1,                        // -> hazard_unit
    output [4:0] EX_rs2,                        // -> hazard_unit

    output [31:0] EX_pc,                        // -> branch_prediction_unit
    output EX_branch_predict,

    output EX_jal,
    output EX_jalr,
    output [2:0] EX_branch_type,

    output [11:0] EX_csr_addr,
    output reg [31:0] EX_csr_w_data,
    output [31:0] EX_csr_r_data,
    output EX_csr_w_en,
    output [2:0] EX_csr_op

    );

    wire [31:0] fwd_rs1_data = (forward_rs1_sel == `FORWARD_PREV)       ? MEM_alu_result_forwarded :
                               (forward_rs1_sel == `FORWARD_PREV_PREV)  ? WB_alu_result_forwarded  : ID_rs1_data;
    wire [31:0] fwd_rs2_data = (forward_rs2_sel == `FORWARD_PREV)       ? MEM_alu_result_forwarded :
                               (forward_rs2_sel == `FORWARD_PREV_PREV)  ? WB_alu_result_forwarded  : ID_rs2_data;
    wire [31:0] fwd_csr_data = (forward_csr_sel == `FORWARD_PREV)       ? MEM_csr_w_data_forwarded : 
                               (forward_csr_sel == `FORWARD_PREV_PREV)  ? WB_csr_w_data_forwarded  : ID_csr_r_data;

    wire [31:0] alu_src1 = (ID_alu_src1_sel == `ALU_SRC1_RS1) ? fwd_rs1_data : ID_I_addr;
    wire [31:0] alu_src2 = (ID_alu_src2_sel == `ALU_SRC2_RS2) ? fwd_rs2_data : ID_imm;

    wire EX_br_eq, EX_br_lt;
    wire branch = ID_branch_type == `BEQ  ?   EX_br_eq :
                  ID_branch_type == `BNE  ?  ~EX_br_eq :
                  ID_branch_type == `BLT  ?   EX_br_lt :
                  ID_branch_type == `BGE  ?  ~EX_br_lt :
                  ID_branch_type == `BLTU ?   EX_br_lt :
                  ID_branch_type == `BGEU ?  ~EX_br_lt : 1'b0;
    assign EX_pc_sel = ID_jal | ID_jalr | branch;

    branch_comp branch_comp_0(
        .rs1_data(fwd_rs1_data),
        .rs2_data(fwd_rs2_data),
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

    always @(*) begin
        case (ID_csr_op) 
            `CSRRW:     EX_csr_w_data = fwd_rs1_data;
            `CSRRS:     EX_csr_w_data = fwd_csr_data | fwd_rs1_data;
            `CSRRC:     EX_csr_w_data = fwd_csr_data & ~fwd_rs1_data;
            // ID_rs1 is treated as 5-bit immediate and zero-extended in below instructions
            `CSRRWI:    EX_csr_w_data = {27'b0, ID_rs1};
            `CSRRSI:    EX_csr_w_data = fwd_csr_data | {27'b0, ID_rs1};
            `CSRRCI:    EX_csr_w_data = fwd_csr_data & ~{27'b0, ID_rs1};
            default:    EX_csr_w_data = 32'h0;
        endcase
    end

    assign EX_reg_w_en = ID_reg_w_en;
    assign EX_reg_w_data_sel = ID_reg_w_data_sel;
    assign EX_store_width = ID_store_width;
    assign EX_load_width = ID_load_width;
    assign EX_load_un = ID_load_un;
    assign EX_pc_plus_4 = ID_pc_plus_4;
    assign EX_rd = ID_rd;
    assign EX_rs2_data = fwd_rs2_data;
    assign EX_rs1 = ID_rs1;
    assign EX_rs2 = ID_rs2;
    assign EX_pc = ID_pc;
    assign EX_branch_predict = ID_branch_predict;
    assign EX_jal = ID_jal;
    assign EX_jalr = ID_jalr;
    assign EX_branch_type = ID_branch_type;
    assign EX_csr_addr = ID_csr_addr;
    assign EX_csr_r_data = fwd_csr_data;
    assign EX_csr_op = ID_csr_op;
    // if the CSR operation is setting/clearing bits and the rs1/imm is x0/0, do not write to CSR at all
    // see unprivileged RISC-V manual page 46
    assign EX_csr_w_en = (ID_csr_op == `CSRRW | ID_csr_op == `CSRRWI) | 
                         (ID_csr_op == `CSRRC | ID_csr_op == `CSRRCI | ID_csr_op == `CSRRS | ID_csr_op == `CSRRSI) & (ID_rs1 != 5'h0);
endmodule
