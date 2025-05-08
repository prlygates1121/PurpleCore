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

    input [4:0] MEM_rd,         
    input [31:0] MEM_reg_w_data,
    input MEM_reg_w_en,

    input [4:0] WB_rd,          
    input [31:0] WB_reg_w_data, 
    input WB_reg_w_en,

    input [2:0] EX_csr_op,
    input [4:0] EX_rs1,
    input [4:0] EX_rs2,
    input EX_ecall,
    input EX_mret,

    input [11:0] EX_csr_addr,
    input [11:0] MEM_csr_addr,
    input [11:0] WB_csr_addr,

    input [31:0] MEM_csr_w_data,
    input [31:0] WB_csr_w_data,

    input MEM_csr_w_en,
    input WB_csr_w_en,

    output [31:0] MEM_reg_w_data_forwarded,
    output [31:0] WB_reg_w_data_forwarded, 
    output [31:0] MEM_csr_w_data_forwarded,
    output [31:0] WB_csr_w_data_forwarded,
    output [1:0] forward_rs1_sel,
    output [1:0] forward_rs2_sel,
    output [1:0] forward_csr_sel,

    input [4:0] ID_rs1,
    input [4:0] ID_rs2,
    input [4:0] EX_rd, 
    input EX_load,     

    output load_stall, 
    output load_flush  

    );

    assign MEM_reg_w_data_forwarded = MEM_reg_w_data;
    assign WB_reg_w_data_forwarded = WB_reg_w_data;

    // when to forward? the same register (MEM_rd == EX_rs1) is previously written to (MEM_reg_w_en) and currently read (EX_rs1 != 5'b0)
    assign forward_rs1_sel = (MEM_reg_w_en & (EX_rs1 != 5'b0) & (MEM_rd == EX_rs1)) ? `FORWARD_PREV :
                             (WB_reg_w_en  & (EX_rs1 != 5'b0) & (WB_rd  == EX_rs1)) ? `FORWARD_PREV_PREV : 
                                                                                      `FORWARD_NONE;

    assign forward_rs2_sel = (MEM_reg_w_en & (EX_rs2 != 5'b0) & (MEM_rd == EX_rs2)) ? `FORWARD_PREV :
                             (WB_reg_w_en  & (EX_rs2 != 5'b0) & (WB_rd  == EX_rs2)) ? `FORWARD_PREV_PREV : 
                                                                                      `FORWARD_NONE;

    assign MEM_csr_w_data_forwarded = MEM_csr_w_data;
    assign WB_csr_w_data_forwarded = WB_csr_w_data;

    // when to forward? the same register (MEM_csr_addr == EX_csr_addr) is previously written to (MEM_csr_w_en) and currently read (EX_csr_op != `NO_CSR)
    // for ecall, we need to forward when MTVEC is previously written to (MEM_csr_addr == `MTVEC) and currently read (EX_ecall)
    // for mret, we need to forward when MEPC is previously written to (MEM_csr_addr == `MEPC) and currently read (EX_mret)
    assign forward_csr_sel = (MEM_csr_w_en & ((EX_csr_op != `NO_CSR) & (MEM_csr_addr == EX_csr_addr) | 
                                              (EX_ecall & MEM_csr_addr == `MTVEC) | 
                                              (EX_mret & MEM_csr_addr == `MEPC))) ? `FORWARD_PREV :
                             (WB_csr_w_en  & ((EX_csr_op != `NO_CSR) & (WB_csr_addr  == EX_csr_addr) | 
                                              (EX_ecall & WB_csr_addr  == `MTVEC) | 
                                              (EX_mret & WB_csr_addr  == `MEPC))) ? `FORWARD_PREV_PREV :
                                                                                    `FORWARD_NONE;

    assign load_stall = (EX_load & (ID_rs1 != 5'b0) & (EX_rd == ID_rs1)) | (EX_load & (ID_rs2 != 5'b0) & (EX_rd == ID_rs2));
    assign load_flush = (EX_load & (ID_rs1 != 5'b0) & (EX_rd == ID_rs1)) | (EX_load & (ID_rs2 != 5'b0) & (EX_rd == ID_rs2));

endmodule
