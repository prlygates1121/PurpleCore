`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2025 11:22:14 PM
// Design Name: 
// Module Name: MEM
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


module MEM(
    input [31:0] EX_alu_result,
    input [31:0] EX_alu_mul_result,
    input EX_reg_w_en,
    input EX_reg_w_en_mul,
    input [2:0] EX_reg_w_data_sel,
    input [1:0] EX_store_width,
    input [2:0] EX_load_width,
    input EX_load_un,
    input [31:0] EX_pc_plus_4,
    input [4:0] EX_rd,
    input [4:0] EX_rd_mul,
    input [31:0] EX_rs2_data,
    input [11:0] EX_csr_addr,
    input [31:0] EX_csr_w_data,
    input EX_csr_w_en,
    input [31:0] EX_csr_r_data,
    input [31:0] EX_w_mstatus,
    input [31:0] EX_w_mepc,
    input [31:0] EX_w_mcause,

    // interface with data memory
    output [31:0] D_addr,
    output [31:0] D_store_data,
    output [1:0] D_store_width,
    output [2:0] D_load_width,
    output D_load_un,
    input [31:0] D_load_data,

    output MEM_reg_w_en,
    output MEM_reg_w_en_mul,
    output [2:0] MEM_reg_w_data_sel,
    output [31:0] MEM_reg_w_data,
    output [31:0] MEM_pc_plus_4,
    output [4:0] MEM_rd,
    output [4:0] MEM_rd_mul,
    output [31:0] MEM_dmem_data,
    output [31:0] MEM_alu_result,
    output [31:0] MEM_alu_mul_result,
    output [11:0] MEM_csr_addr,
    output [31:0] MEM_csr_w_data,
    output MEM_csr_w_en,
    output [31:0] MEM_csr_r_data,
    output [31:0] MEM_w_mstatus,
    output [31:0] MEM_w_mepc,
    output [31:0] MEM_w_mcause
    );

    assign D_addr = EX_alu_result;
    assign D_store_data = EX_rs2_data;
    assign D_store_width = EX_store_width;
    assign D_load_width = EX_load_width;
    assign D_load_un = EX_load_un;
    assign MEM_reg_w_en = EX_reg_w_en;
    assign MEM_reg_w_en_mul = EX_reg_w_en_mul;
    assign MEM_reg_w_data_sel = EX_reg_w_data_sel;
    // MEM_reg_w_data is used for forwarding to the EX stage of the next instruction
    // we never forward loaded data to the next instruction (we add a stall instead), so EX_reg_w_data_sel == `REG_W_DATA_MEM is not considered
    assign MEM_reg_w_data = EX_reg_w_data_sel == `REG_W_DATA_ALU ? EX_alu_result :
                            EX_reg_w_data_sel == `REG_W_DATA_PC  ? EX_pc_plus_4 :
                            EX_reg_w_data_sel == `REG_W_DATA_CSR ? EX_csr_r_data :
                            32'h0;
    assign MEM_pc_plus_4 = EX_pc_plus_4;
    assign MEM_rd = EX_rd;
    assign MEM_rd_mul = EX_rd_mul;
    assign MEM_dmem_data = D_load_data;
    assign MEM_alu_result = EX_alu_result;
    assign MEM_alu_mul_result = EX_alu_mul_result;
    assign MEM_csr_addr = EX_csr_addr;
    assign MEM_csr_w_data = EX_csr_w_data;
    assign MEM_csr_w_en = EX_csr_w_en;
    assign MEM_csr_r_data = EX_csr_r_data;
    assign MEM_w_mstatus = EX_w_mstatus;
    assign MEM_w_mepc = EX_w_mepc;
    assign MEM_w_mcause = EX_w_mcause;
endmodule
