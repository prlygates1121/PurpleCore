`timescale 1ns / 1ps
`include "params.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2025 05:31:28 PM
// Design Name: 
// Module Name: hazard_unit
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


module hazard_unit(
    input [4:0]     MEM_rd,         
    input [4:0]     MEM_rd_mul,
    input [31:0]    MEM_reg_w_data,
    input [31:0]    MEM_reg_w_data_mul,
    input           MEM_reg_w_en,
    input           MEM_reg_w_en_mul,

    input [4:0]     WB_rd,     
    input [4:0]     WB_rd_mul,     
    input [31:0]    WB_reg_w_data, 
    input [31:0]    WB_reg_w_data_mul,
    input           WB_reg_w_en,
    input           WB_reg_w_en_mul,

    input [2:0]     EX_csr_op,
    input [4:0]     EX_rs1,
    input [4:0]     EX_rs2,
    input           EX_ecall,
    input           EX_mret,

    input [11:0]    EX_csr_addr,
    input [11:0]    MEM_csr_addr,
    input [11:0]    WB_csr_addr,

    input [31:0]    MEM_csr_w_data,
    input [31:0]    WB_csr_w_data,

    input           MEM_csr_w_en,
    input           WB_csr_w_en,

    output [31:0]   MEM_reg_w_data_forwarded,
    output [31:0]   MEM_reg_w_data_mul_forwarded,
    output [31:0]   WB_reg_w_data_forwarded, 
    output [31:0]   WB_reg_w_data_mul_forwarded,
    output [31:0]   MEM_csr_w_data_forwarded,
    output [31:0]   WB_csr_w_data_forwarded,
    output [2:0]    forward_rs1_sel,
    output [2:0]    forward_rs2_sel,
    output [1:0]    forward_csr_sel,

    input [4:0]     ID_rs1,
    input [4:0]     ID_rs2,
    input [4:0]     EX_rd, 
    input           EX_load,     

    input [14:0]    rd_queue,

    input           ID_reg_w_en,
    input [4:0]     ID_rd,

    output          load_stall, 
    output          load_flush,

    output          calc_stall,
    output          calc_flush,

    output          write_disorder

    );

    assign MEM_reg_w_data_forwarded     = MEM_reg_w_data;
    assign MEM_reg_w_data_mul_forwarded = MEM_reg_w_data_mul;
    assign WB_reg_w_data_forwarded      = WB_reg_w_data;
    assign WB_reg_w_data_mul_forwarded  = WB_reg_w_data_mul;

    // when to forward? when the same register (MEM_rd == EX_rs1) is previously written to (MEM_reg_w_en) and currently read (EX_rs1 != 5'b0)
    assign forward_rs1_sel              = (MEM_reg_w_en      & (EX_rs1 != 5'b0) & (MEM_rd == EX_rs1))        ? `FORWARD_PREV :
                                          (WB_reg_w_en       & (EX_rs1 != 5'b0) & (WB_rd  == EX_rs1))        ? `FORWARD_PREV_PREV : 
                                          (MEM_reg_w_en_mul  & (EX_rs1 != 5'b0) & (MEM_rd_mul == EX_rs1))    ? `FORWARD_PREV_MUL :
                                          (WB_reg_w_en_mul   & (EX_rs1 != 5'b0) & (WB_rd_mul == EX_rs1))     ? `FORWARD_PREV_PREV_MUL :
                                                                                                               `FORWARD_NONE;

    assign forward_rs2_sel              = (MEM_reg_w_en      & (EX_rs2 != 5'b0) & (MEM_rd == EX_rs2))        ? `FORWARD_PREV :
                                          (WB_reg_w_en       & (EX_rs2 != 5'b0) & (WB_rd  == EX_rs2))        ? `FORWARD_PREV_PREV : 
                                          (MEM_reg_w_en_mul  & (EX_rs2 != 5'b0) & (MEM_rd_mul == EX_rs2))    ? `FORWARD_PREV_MUL :
                                          (WB_reg_w_en_mul   & (EX_rs2 != 5'b0) & (WB_rd_mul == EX_rs2))     ? `FORWARD_PREV_PREV_MUL :
                                                                                                  `FORWARD_NONE;

    assign MEM_csr_w_data_forwarded     = MEM_csr_w_data;
    assign WB_csr_w_data_forwarded      = WB_csr_w_data;

    // when to forward? when the same register (MEM_csr_addr == EX_csr_addr) is previously written to (MEM_csr_w_en) and currently read (EX_csr_op != `NO_CSR)
    // for ecall, we need to forward when MTVEC is previously written to (MEM_csr_addr == `MTVEC) and currently read (EX_ecall)
    // for mret, we need to forward when MEPC is previously written to (MEM_csr_addr == `MEPC) and currently read (EX_mret)
    assign forward_csr_sel              = (MEM_csr_w_en & ((EX_csr_op != `NO_CSR) & (MEM_csr_addr == EX_csr_addr) | 
                                                           (EX_ecall & MEM_csr_addr == `MTVEC) | 
                                                           (EX_mret & MEM_csr_addr == `MEPC))) ? `FORWARD_PREV :
                                          (WB_csr_w_en  & ((EX_csr_op != `NO_CSR) & (WB_csr_addr  == EX_csr_addr) | 
                                                           (EX_ecall & WB_csr_addr  == `MTVEC) | 
                                                           (EX_mret & WB_csr_addr  == `MEPC))) ? `FORWARD_PREV_PREV :
                                                                                                 `FORWARD_NONE;

    assign load_stall                   = (EX_load & (ID_rs1 != 5'b0) & (EX_rd == ID_rs1)) | (EX_load & (ID_rs2 != 5'b0) & (EX_rd == ID_rs2));
    assign load_flush                   = load_stall;

    // rd_queue stores the numbers of the last 3 rd register that were written to by a multicycle instruction (e.g. mul)
    // if ID_rs1 or ID_rs2 is not 0 and matches either the most recent rd (rd_queue[14:10]) or the second most recent rd (rd_queue[9:5]),
    // then, calc_stall / calc_flush are sent to IF and IF_ID to stall the fetching of instructions
    assign calc_stall                   = (ID_rs1 != 5'b0 & (rd_queue[9:5]   == ID_rs1 |
                                                             rd_queue[14:10] == ID_rs1)) |
                                          (ID_rs2 != 5'b0 & (rd_queue[9:5]   == ID_rs2 |
                                                             rd_queue[14:10] == ID_rs2));
    assign calc_flush                   = calc_stall;

    // write_disorder is used to indicate that the current instruction is trying to write to a register that is currently being written to by a previous multicycle instruction
    // note that the previous multicycle instruction is fetched before the current instruction, but it writes to the register after the current instruction
    // so, if write_disorder is true, we need to cancel the register write of the previous multicycle instruction, and write the current instruction's result instead
    assign write_disorder               = ID_reg_w_en & (ID_rd == rd_queue[14:10]) & (ID_rd != 5'b0); 
endmodule
