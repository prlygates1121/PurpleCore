`timescale 1ns / 1ps
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

    // data hazard (forwarding)
    // hazard unit takes effect in the EX stage, so signals from MEM stage are considered from the previous instruction
    // and signals from WB stage are considered from the instruction before the previous instruction
    input [4:0] MEM_rd,                         // destination register of the previous instruction
    input MEM_reg_w_en,                         // whether the previous instruction writes to the register file
    input [31:0] MEM_alu_result,                // ALU result of the previous instruction
    input [4:0] WB_rd,                          // destination register of the instruction before the previous instruction
    input WB_reg_w_en,                          // whether the instruction before the previous instruction writes to the register file
    input [31:0] WB_alu_result,                 // ALU result of the instruction before the previous instruction

    input [4:0] EX_rs1,                         // source register 1 of the current instruction
    input [4:0] EX_rs2,                         // source register 2 of the current instruction

    output [31:0] MEM_alu_result_forwarded,     // ALU result forwarded from previous instruction
    output [31:0] WB_alu_result_forwarded,      // ALU result forwarded from the instruction before the previous instruction
    output [1:0] forward_rs1_sel,               // decides where to forward the data for rs1
    output [1:0] forward_rs2_sel,               // decides where to forward the data for rs2

    // stall and flush signals for load hazard
    // to handle load hazard, the hazard unit has to take effect in the ID stage,
    // so the signals from the ID stage are considered from the current instruction,
    // and the signals from the EX stage are considered from the previous instruction
    input [4:0] ID_rs1,                         // source register 1 of the current instruction
    input [4:0] ID_rs2,                         // source register 2 of the current instruction
    input [4:0] EX_rd,                          // destination register of the previous instruction
    input EX_load,                              // whether the previous instruction is a load instruction

    output load_stall,                          // stall if there is a load hazard
    output load_flush,                          // flush if there is a load hazard

    // flush signals for branch hazard
    input EX_pc_sel,                            // whether the current instruction initiates a branch
    output branch_flush                         // flush if there is a branch hazard

    );

    assign MEM_alu_result_forwarded = MEM_alu_result;
    assign WB_alu_result_forwarded = WB_alu_result;
    assign forward_rs1_sel = (MEM_reg_w_en & (EX_rs1 != 5'b0) & (MEM_rd == EX_rs1)) ? 2'b01 :
                             (WB_reg_w_en & (EX_rs1 != 5'b0) & (WB_rd == EX_rs1)) ? 2'b10 : 2'b00;
    assign forward_rs2_sel = (MEM_reg_w_en & (EX_rs2 != 5'b0) & (MEM_rd == EX_rs2)) ? 2'b01 :
                             (WB_reg_w_en & (EX_rs2 != 5'b0) & (WB_rd == EX_rs2)) ? 2'b10 : 2'b00;

    assign load_stall = (EX_load & (ID_rs1 != 5'b0) & (EX_rd == ID_rs1)) | (EX_load & (ID_rs2 != 5'b0) & (EX_rd == ID_rs2));
    assign load_flush = (EX_load & (ID_rs1 != 5'b0) & (EX_rd == ID_rs1)) | (EX_load & (ID_rs2 != 5'b0) & (EX_rd == ID_rs2));

    assign branch_flush = EX_pc_sel;


endmodule
