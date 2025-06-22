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
    input clk,
    input reset,
    input write_disorder,

    input [3:0] ID_alu_op_sel,
    input [3:0] ID_alu_mul_op_sel,
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
    input [4:0] ID_rd_mul,

    input [1:0] ID_store_width,
    input [2:0] ID_load_width,
    input ID_load_un,

    input ID_reg_w_en,
    input ID_reg_w_en_mul,
    input [2:0] ID_reg_w_data_sel,

    input [31:0] ID_pc,
    input [31:0] ID_pc_plus_4,
    input ID_jal,
    input ID_jalr,
    input [2:0] ID_branch_type,
    input ID_branch_predict,
    input ID_ecall,
    input ID_mret,

    input [31:0] MEM_reg_w_data_forwarded,
    input [31:0] MEM_reg_w_data_mul_forwarded,
    input [31:0] WB_reg_w_data_forwarded,
    input [31:0] WB_reg_w_data_mul_forwarded,
    input [2:0] forward_rs1_sel,
    input [2:0] forward_rs2_sel,

    input [31:0] MEM_csr_w_data_forwarded,
    input [31:0] WB_csr_w_data_forwarded,
    input [1:0] forward_csr_sel,

    input [11:0] ID_csr_addr,
    input [2:0] ID_csr_op,
    input [31:0] ID_csr_r_data,
    input [31:0] ID_mtvec,
    input [31:0] ID_mepc,
    input [31:0] ID_mboot,

    input ID_calc_slow,

    input ID_reset,

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
    output EX_ecall,
    output EX_mret,
    output [31:0] EX_trap_dest,

    output [11:0] EX_csr_addr,
    output reg [31:0] EX_csr_w_data,
    output [31:0] EX_csr_r_data,
    output EX_csr_w_en,
    output [2:0] EX_csr_op,

    output reg [31:0] EX_w_mstatus,
    output [31:0] EX_w_mepc,
    output [31:0] EX_w_mcause,

    output EX_excp,
    output inst_access_fault,

    output [31:0] EX_alu_mul_result,
    output EX_reg_w_en_mul,
    output [4:0] EX_rd_mul

    );

    wire [31:0] fwd_rs1_data;
    wire [31:0] fwd_rs2_data;
    wire [31:0] fwd_csr_data;
    wire [31:0] alu_src1;
    wire [31:0] alu_src2;
    reg [30:0] excp_code;
    wire EX_br_eq, EX_br_lt;

    wire [3:0] alu_mul_op_sel;

    always @(*) begin
        excp_code = `NO_EXCP;

        if (~ID_reset) begin
            // once the control leaves bootloader, it is not allowed to execute bootloader code
            if (ID_mboot == 32'h0 & (ID_pc < `S_TEXT | ID_pc >= `S_DATA)) begin
                excp_code = `INST_ACCESS_FAULT;
            end else if (ID_ecall) begin
                excp_code = `ECALL_M;
            end else if (ID_mboot == 32'h0) begin
                if (ID_store_width != `NO_STORE) begin
                    if (EX_alu_result[31] == 1'b0 & EX_alu_result < `S_DATA) begin
                        excp_code = `STORE_ACCESS_FAULT;
                    end
                end else if (ID_load_width != `NO_LOAD) begin
                    if (EX_alu_result[31] == 1'b0 & EX_alu_result < `S_TEXT) begin
                        excp_code = `LOAD_ACCESS_FAULT;
                    end
                end
            end
        end
    end

    assign inst_access_fault = excp_code == `INST_ACCESS_FAULT;

    assign fwd_rs1_data = (forward_rs1_sel == `FORWARD_PREV)       ? MEM_reg_w_data_forwarded :
                          (forward_rs1_sel == `FORWARD_PREV_PREV)  ? WB_reg_w_data_forwarded  :
                          (forward_rs1_sel == `FORWARD_PREV_MUL)   ? MEM_reg_w_data_mul_forwarded :
                          (forward_rs1_sel == `FORWARD_PREV_PREV_MUL) ? WB_reg_w_data_mul_forwarded :
                        ID_rs1_data;
    assign fwd_rs2_data = (forward_rs2_sel == `FORWARD_PREV)       ? MEM_reg_w_data_forwarded :
                          (forward_rs2_sel == `FORWARD_PREV_PREV)  ? WB_reg_w_data_forwarded  :
                          (forward_rs2_sel == `FORWARD_PREV_MUL)   ? MEM_reg_w_data_mul_forwarded :
                          (forward_rs2_sel == `FORWARD_PREV_PREV_MUL) ? WB_reg_w_data_mul_forwarded :
                        ID_rs2_data;
    assign fwd_csr_data = (forward_csr_sel == `FORWARD_PREV)       ? MEM_csr_w_data_forwarded : 
                          (forward_csr_sel == `FORWARD_PREV_PREV)  ? WB_csr_w_data_forwarded  : ID_csr_r_data;

    assign alu_src1 = (ID_alu_src1_sel == `ALU_SRC1_RS1) ? fwd_rs1_data : ID_I_addr;
    assign alu_src2 = (ID_alu_src2_sel == `ALU_SRC2_RS2) ? fwd_rs2_data : ID_imm;

    assign EX_w_mcause = EX_excp ? {1'b0, excp_code} : `CSR_NO_WRITE;
    assign EX_w_mepc   = EX_excp ? ID_pc : `CSR_NO_WRITE;

    assign branch = ID_branch_type == `BEQ  ?   EX_br_eq :
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

    alu_mul alu_mul_0 (
        .clk(clk),
        .src1(alu_src1),
        .src2(alu_src2),
        .op_sel(alu_mul_op_sel),
        .result(EX_alu_mul_result)
    );

    shift_reg #(
        .BIT_WIDTH      (4),
        .DEPTH          (2)
    ) shift_reg_op_sel (
        .clk            (clk),
        .reset          (reset),
        .data_in        (write_disorder ? `ADD : ID_alu_mul_op_sel),
        .data_out       (alu_mul_op_sel)
    );

    shift_reg #(
        .BIT_WIDTH      (1),
        .DEPTH          (2)
    ) shift_reg_reg_w_en (
        .clk            (clk),
        .reset          (reset),
        .data_in        (write_disorder ? 1'b0 : ID_reg_w_en_mul),
        .data_out       (EX_reg_w_en_mul)
    );

    shift_reg #(
        .BIT_WIDTH      (5),
        .DEPTH          (2)
    ) shift_reg_rd (
        .clk            (clk),
        .reset          (reset),
        .data_in        (write_disorder ? 5'b0 : ID_rd_mul),
        .data_out       (EX_rd_mul)
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

    always @(*) begin
        if (ID_ecall) begin
            EX_w_mstatus  = 32'h0;
        end else if (ID_mret) begin
            EX_w_mstatus  = `MSTATUS_MIE;
        end else begin
            EX_w_mstatus  = `CSR_NO_WRITE;
        end
    end

    assign EX_reg_w_en = excp_code == `LOAD_ACCESS_FAULT ? 1'b0 : ID_reg_w_en;
    assign EX_reg_w_data_sel = ID_reg_w_data_sel;
    assign EX_store_width = excp_code == `STORE_ACCESS_FAULT ? `NO_STORE : ID_store_width;
    assign EX_load_width = excp_code == `LOAD_ACCESS_FAULT ? `NO_LOAD : ID_load_width;
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
    assign EX_ecall = ID_ecall;
    assign EX_mret = ID_mret;
    assign EX_trap_dest = (ID_ecall | EX_excp) ? 
                                     ((forward_csr_sel == `FORWARD_PREV)       ? MEM_csr_w_data_forwarded : 
                                      (forward_csr_sel == `FORWARD_PREV_PREV)  ? WB_csr_w_data_forwarded  :
                                       ID_mtvec) :
                          ID_mret  ? ((forward_csr_sel == `FORWARD_PREV)       ? MEM_csr_w_data_forwarded :
                                      (forward_csr_sel == `FORWARD_PREV_PREV)  ? WB_csr_w_data_forwarded  :
                                       ID_mepc) : 
                                     32'h0;
    assign EX_csr_addr = ID_csr_addr;
    assign EX_csr_r_data = fwd_csr_data;
    assign EX_csr_op = ID_csr_op;
    // if the CSR operation is setting/clearing bits and the rs1/imm is x0/0, do not write to CSR at all
    // see unprivileged RISC-V manual page 46
    assign EX_csr_w_en = (ID_csr_op == `CSRRW | ID_csr_op == `CSRRWI) | 
                         (ID_csr_op == `CSRRC | ID_csr_op == `CSRRCI | ID_csr_op == `CSRRS | ID_csr_op == `CSRRSI) & (ID_rs1 != 5'h0);
    assign EX_excp = excp_code != `NO_EXCP;
endmodule
