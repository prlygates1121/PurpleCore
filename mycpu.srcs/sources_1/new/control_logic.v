`timescale 1ns / 1ps
`include "params.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2025 08:54:35 PM
// Design Name: 
// Module Name: control_logic
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


module control_logic(

    // instruction
    input [31:0] inst,

    // decides what ALU does
    output [3:0] alu_op_sel,

    // decides what ALU gets as operands
    // 0: PC
    // 1: rs1
    output alu_src1_sel,

    // 0: immediate
    // 1: rs2
    output alu_src2_sel,

    // decides whether to write to register file
    // 0: Don't write
    // 1: Write
    output reg_w_en,

    // decides what to write to register file
    // 0: ALU result
    // 1: Memory
    // 2: PC + 4
    output [1:0] reg_w_data_sel,

    // indicates the store width
    // 0: byte
    // 1: halfword
    // 2: word
    // 3: no store
    output [1:0] store_width,

    // indicates the load width
    // 0: byte
    // 1: halfword
    // 2: word
    output [1:0] load_width,

    // indicates the load signedness
    output load_un,

    // decides where to extract the immediate
    output [2:0] imm_sel,

    // tells branch comparator whether to treat input as unsigned
    output br_un,

    // whether this is a jump instruction (jal, jalr, auipc)
    output jump,

    output [2:0] branch_type
    );


    wire [6:0] opcode = inst[6:0];
    wire [2:0] funct3 = inst[14:12];
    wire [6:0] funct7 = inst[31:25];

    wire I_ecall = opcode == 7'b1110011 & inst[31:20] == 12'h0;
    wire I_ebreak = opcode == 7'b1110011 & inst[31:20] == 12'h1;
    wire I_load = opcode == 7'b0000011;
    wire I_jalr = opcode == 7'b1100111 & funct3 == 3'h0;
    wire I_arith = opcode == 7'b0010011;
    wire I_shift = opcode == 7'b0010011 & (funct3 == 3'h1 | funct3 == 3'h5);

    wire R =    opcode == 7'b0110011;
    wire I =    opcode == 7'b0010011 | 
                opcode == 7'b0000011 | 
                opcode == 7'b1100111 | 
                opcode == 7'b1110011;
    wire S =    opcode == 7'b0100011;
    wire B =    opcode == 7'b1100011;
    wire U =    opcode == 7'b0110111 | opcode == 7'b0010111;
    wire J =    opcode == 7'b1101111;

    wire U_auipc = U & (opcode == 7'b0010111);


    assign imm_sel = I_shift ? `IMM_I_SHIFT :
                           I ? `IMM_I :
                           S ? `IMM_S :
                           B ? `IMM_B :
                           U ? `IMM_U :
                           J ? `IMM_J : 3'h6;

    assign br_un = B & (funct3 == 3'h6 | funct3 == 3'h7); // bltu, bgeu
    
    assign reg_w_en = R | U | J | I_load | I_jalr | I_arith;

    assign reg_w_data_sel = (J | I_jalr)  ? 2'h2 :        // PC + 4
                            (I_load)      ? 2'h1 :        // Memory
                            (R | U | I_arith) ? 2'h0 : 2'h3;  // ALU result

    assign alu_op_sel = (R & funct3 == 3'h0 & funct7 == 7'h20)          ? `SUB :     // sub
                        (R & funct3 == 3'h4 & funct7 == 7'h00 |                     // xor
                         I_arith & funct3 == 3'h4)                      ? `XOR :     // xori
                        (R & funct3 == 3'h6 & funct7 == 7'h00 |                     // or
                         I_arith & funct3 == 3'h6)                      ? `OR :      // ori
                        (R & funct3 == 3'h7 & funct7 == 7'h00 |                     // and
                         I_arith & funct3 == 3'h7)                      ? `AND :     // andi
                        (R & funct3 == 3'h1 & funct7 == 7'h00 |                     // sll
                         I_arith & funct3 == 3'h1 & funct7 == 7'h00)    ? `SLL :     // slli
                        (R & funct3 == 3'h5 & funct7 == 7'h00 |                     // srl
                         I_arith & funct3 == 3'h5 & funct7 == 7'h00)    ? `SRL :     // srli
                        (R & funct3 == 3'h5 & funct7 == 7'h20 |                     // sra
                         I_arith & funct3 == 3'h5 & funct7 == 7'h20)    ? `SRA :     // srai
                        (R & funct3 == 3'h2 & funct7 == 7'h00 |                     // slt
                         I_arith & funct3 == 3'h2)                      ? `SLT :     // slti
                        (R & funct3 == 3'h3 & funct7 == 7'h00 |                     // sltu
                         I_arith & funct3 == 3'h3)                      ? `SLTU :    // sltiu
                        (R & funct3 == 3'h0 & funct7 == 7'h01)          ? `MUL :     // mul
                        (R & funct3 == 3'h1 & funct7 == 7'h01)          ? `MULH :    // mulh
                        (R & funct3 == 3'h3 & funct7 == 7'h01)          ? `MULU :    // mulu
                        (opcode == 7'b0110111)                          ? `BSEL :    // lui
                        `ADD;

    assign mem_w_en = S ? (funct3 == 3'h0 ? 4'b0001 :                   // sb
                           funct3 == 3'h1 ? 4'b0011 :                   // sh
                           funct3 == 3'h2 ? 4'b1111 : 4'h0) : 4'h0;     // sw

    assign store_width = S ? funct3[1:0] : 2'h3;
    assign load_width = I_load ? funct3[1:0] : 2'h3;
    assign load_un = I_load & (funct3 == 3'h4 | funct3 == 3'h5);

    assign alu_src1_sel = R | I | S;
    assign alu_src2_sel = R;

    assign jump = J | I_jalr | U_auipc;
    assign branch_type = B ? funct3 : 3'h2;

endmodule
