`timescale 1ns / 1ps
`include "params.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2025 12:57:01 AM
// Design Name: 
// Module Name: core
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


module core(
    `ifdef DEBUG
        input clk_100,
    `endif
    input clk,
    input reset,

    input [7:0] sws_l,
    input [7:0] sws_r,

    input [4:0] bts_state,

    output [31:0] seg_display_hex,

    output [7:0] leds_l,
    output [7:0] leds_r,

    input clk_pixel,
    input [31:0] vga_addr,
    output [31:0] vga_data,

    input [7:0] key_code,

    input [7:0] uart_rx_data,
    output [7:0] uart_tx_data,
    output uart_read,
    output uart_write,
    input uart_rx_ready,
    input uart_tx_ready,
    output [31:0] uart_ctrl
    );

    `ifdef DEBUG
        wire [31:0] t0;
        wire [31:0] t1;
        wire [31:0] t2;
        wire [31:0] t3;
    `endif

    wire [14:0] rd_queue;

    wire inst_access_fault;

    wire [31:0] IF_I_addr, I_load_data;
    wire [31:0] IF_out_pc, IF_out_pc_plus_4, IF_out_inst, IF_out_I_addr;
    wire [31:0] ID_in_pc, ID_in_pc_plus_4, ID_in_inst, ID_in_I_addr;
    wire IF_ID_reset;
    wire ID_in_branch_predict;
    wire [1:0] ID_out_store_width;
    wire [2:0] ID_out_load_width;

    wire [3:0] ID_out_alu_op_sel;
    wire ID_out_alu_src1_sel;
    wire ID_out_alu_src2_sel;
    wire ID_out_reg_w_en;
    wire [2:0] ID_out_reg_w_data_sel;
    wire ID_out_load_un;
    wire [31:0] ID_out_imm;
    wire ID_out_br_un;
    wire [31:0] ID_out_rs1_data;
    wire [31:0] ID_out_rs2_data;
    wire [4:0] ID_out_rs1;
    wire [4:0] ID_out_rs2;
    wire [4:0] ID_out_rd;
    wire [31:0] ID_out_pc;
    wire [31:0] ID_out_pc_plus_4;
    wire [31:0] ID_out_I_addr;
    wire [31:0] ID_out_inst;
    wire ID_out_jal;
    wire ID_out_jalr;
    wire [2:0] ID_out_branch_type;
    wire ID_out_branch_predict;
    wire ID_out_ecall;
    wire ID_out_mret;
    wire [11:0] ID_out_csr_addr;
    wire [2:0] ID_out_csr_op;
    wire [31:0] ID_out_csr_r_data;
    wire [31:0] ID_out_mtvec;
    wire [31:0] ID_out_mepc;
    wire [31:0] ID_out_mboot;
    wire ID_out_calc_slow;

    wire [3:0] EX_in_alu_op_sel;
    wire EX_in_alu_src1_sel;
    wire EX_in_alu_src2_sel;
    wire EX_in_reg_w_en;
    wire [2:0] EX_in_reg_w_data_sel;
    wire [1:0] EX_in_store_width;
    wire [2:0] EX_in_load_width;
    wire EX_in_load_un;
    wire [31:0] EX_in_imm;
    wire EX_in_br_un;
    wire [31:0] EX_in_rs1_data;
    wire [31:0] EX_in_rs2_data;
    wire [4:0] EX_in_rs1;
    wire [4:0] EX_in_rs2;
    wire [4:0] EX_in_rd;
    wire [31:0] EX_in_pc;
    wire [31:0] EX_in_pc_plus_4;
    wire [31:0] EX_in_I_addr;
    wire EX_in_jal;
    wire EX_in_jalr;
    wire [2:0] EX_in_branch_type;
    wire EX_in_branch_predict;
    wire [31:0] EX_in_inst;
    wire EX_in_ecall;
    wire EX_in_mret;
    wire [31:0] EX_out_trap_dest;
    wire [11:0] EX_in_csr_addr;
    wire [2:0]  EX_in_csr_op;
    wire [31:0] EX_in_csr_r_data;
    wire [31:0] EX_in_mtvec;
    wire [31:0] EX_in_mepc;
    wire [31:0] EX_in_mboot;
    wire EX_in_calc_slow;
    wire ID_EX_reset;

    wire [31:0] EX_out_alu_result;
    wire EX_out_pc_sel;
    wire EX_out_reg_w_en;
    wire [2:0] EX_out_reg_w_data_sel;
    wire [1:0] EX_out_store_width;
    wire [2:0] EX_out_load_width;
    wire EX_out_load_un;
    wire [31:0] EX_out_pc_plus_4;
    wire [4:0] EX_out_rd;
    wire [31:0] EX_out_rs2_data;
    wire [4:0] EX_out_rs1, EX_out_rs2;
    wire [31:0] EX_out_pc;
    wire EX_out_branch_predict;
    wire EX_out_jal;
    wire EX_out_jalr;
    wire [2:0] EX_out_branch_type;
    wire EX_out_ecall;
    wire EX_out_mret;
    wire [11:0] EX_out_csr_addr;
    wire [31:0] EX_out_csr_w_data;
    wire [31:0] EX_out_csr_r_data;
    wire [2:0] EX_out_csr_op;
    wire EX_out_csr_w_en;
    wire [31:0] EX_out_w_mstatus;
    wire [31:0] EX_out_w_mepc;
    wire [31:0] EX_out_w_mcause;
    wire EX_out_excp;
    wire [31:0] EX_out_alu_mul_result;
    wire [4:0] EX_out_rd_mul;
    wire EX_out_reg_w_en_mul;

    wire [31:0] MEM_reg_w_data_forwarded;
    wire [31:0] WB_reg_w_data_forwarded;
    wire [1:0] forward_rs1_sel;
    wire [1:0] forward_rs2_sel;
    wire [31:0] MEM_csr_w_data_forwarded;
    wire [31:0] WB_csr_w_data_forwarded;
    wire [1:0] forward_csr_sel;

    wire [31:0] MEM_in_alu_result;
    wire MEM_in_reg_w_en;
    wire [2:0] MEM_in_reg_w_data_sel;
    wire [1:0] MEM_in_store_width;
    wire [2:0] MEM_in_load_width;
    wire MEM_in_load_un;
    wire [31:0] MEM_in_pc_plus_4;
    wire [4:0] MEM_in_rd;
    wire [31:0] MEM_in_rs2_data;
    wire [11:0] MEM_in_csr_addr;
    wire [31:0] MEM_in_csr_w_data;
    wire [31:0] MEM_in_csr_r_data;
    wire MEM_in_csr_w_en;
    wire [31:0] MEM_in_w_mstatus;
    wire [31:0] MEM_in_w_mepc;
    wire [31:0] MEM_in_w_mcause;
    wire [31:0] MEM_in_alu_mul_result;
    wire [4:0] MEM_in_rd_mul;
    wire MEM_in_reg_w_en_mul;

    wire [31:0] MEM_out_alu_result;
    wire MEM_out_reg_w_en;
    wire [2:0] MEM_out_reg_w_data_sel;
    wire [31:0] MEM_out_reg_w_data;
    wire [31:0] MEM_out_pc_plus_4;
    wire [4:0] MEM_out_rd;
    wire [31:0] MEM_out_dmem_data;
    wire [11:0] MEM_out_csr_addr;
    wire [31:0] MEM_out_csr_w_data;
    wire [31:0] MEM_out_csr_r_data;
    wire MEM_out_csr_w_en;
    wire [31:0] MEM_out_w_mstatus;
    wire [31:0] MEM_out_w_mepc;
    wire [31:0] MEM_out_w_mcause;
    wire [31:0] MEM_out_alu_mul_result;
    wire [4:0] MEM_out_rd_mul;
    wire MEM_out_reg_w_en_mul;

    wire [31:0] WB_in_alu_result;
    wire WB_in_reg_w_en;
    wire [2:0] WB_in_reg_w_data_sel;
    wire [31:0] WB_in_pc_plus_4;
    wire [4:0] WB_in_rd;
    wire [31:0] WB_in_dmem_data;
    wire [11:0] WB_in_csr_addr;
    wire [31:0] WB_in_csr_w_data;
    wire [31:0] WB_in_csr_r_data;
    wire WB_in_csr_w_en;
    wire [31:0] WB_in_w_mstatus;
    wire [31:0] WB_in_w_mepc;
    wire [31:0] WB_in_w_mcause;
    wire [31:0] WB_in_alu_mul_result;
    wire [4:0] WB_in_rd_mul;
    wire WB_in_reg_w_en_mul;

    wire WB_out_reg_w_en;
    wire [31:0] WB_out_reg_w_data;
    wire [4:0] WB_out_rd;
    wire [11:0] WB_out_csr_addr;
    wire [31:0] WB_out_csr_w_data;
    wire WB_out_csr_w_en;
    wire [31:0] WB_out_w_mstatus;
    wire [31:0] WB_out_w_mepc;
    wire [31:0] WB_out_w_mcause;
    wire [31:0] WB_out_reg_w_data_mul;
    wire [4:0] WB_out_rd_mul;
    wire WB_out_reg_w_en_mul;

    // branch_prediction_unit
    wire branch_predict;
    wire [31:0] branch_target;
    wire EX_false_target;
    wire EX_false_direction;
    wire EX_branch_flush;

    // hazard_unit
    wire load_stall, load_flush;
    wire calc_stall, calc_flush;

    // Memory
    wire [3:0] wea = 4'b0;
    wire [31:0] I_addr = IF_I_addr;
    wire [31:0] I_store_data = 32'b0;
    wire [31:0] D_addr, D_store_data, D_load_data;
    wire [1:0] D_store_width;
    wire [2:0] D_load_width;
    wire D_load_un;

    IF if_0 (
        .clk                        (clk),
        .reset                      (reset),
        .stall                      (load_stall | calc_stall),
        .inst_access_fault          (inst_access_fault),

        .EX_trap_dest               (EX_out_trap_dest),
        .EX_excp                    (EX_out_excp),
        .EX_mret                    (EX_out_mret),
        .EX_pc_sel                  (EX_out_pc_sel),
        .EX_false_direction         (EX_false_direction),
        .EX_false_target            (EX_false_target),
        .EX_alu_result              (EX_out_alu_result),
        .EX_pc_plus_4               (EX_out_pc_plus_4),
        .EX_branch_predict          (EX_out_branch_predict),

        .I_addr                     (IF_I_addr),
        .I_load_data                (I_load_data),

        .IF_pc                      (IF_out_pc),
        .IF_pc_plus_4               (IF_out_pc_plus_4),
        .IF_inst                    (IF_out_inst),
        .IF_I_addr                  (IF_out_I_addr),

        .branch_predict             (branch_predict),
        .branch_target              (branch_target)
    );

    IF_ID if_id_0(
        .clk                    (clk),
        .reset                  (reset | EX_branch_flush | EX_out_excp | EX_out_mret),
        .stall                  (load_stall | calc_stall),

        .IF_pc                  (IF_out_pc),
        .IF_pc_plus_4           (IF_out_pc_plus_4),
        .IF_inst                (IF_out_inst),
        .IF_I_addr              (IF_out_I_addr),
        .IF_branch_predict      (branch_predict),

        .ID_pc                  (ID_in_pc),
        .ID_pc_plus_4           (ID_in_pc_plus_4),
        .ID_inst                (ID_in_inst),
        .ID_I_addr              (ID_in_I_addr),
        .ID_branch_predict      (ID_in_branch_predict),
        .ID_reset               (IF_ID_reset)
    );

    ID id_0 (
        `ifdef DEBUG
            .t0                 (t0),
            .t1                 (t1),
            .t2                 (t2),
            .t3                 (t3),
        `endif
        .clk                    (clk),
        .reset                  (reset),
        .stall                  (calc_stall),
        .IF_pc                  (ID_in_pc),
        .IF_pc_plus_4           (ID_in_pc_plus_4),
        .IF_inst                (ID_in_inst),
        .IF_I_addr              (ID_in_I_addr),
        .IF_branch_predict      (ID_in_branch_predict),
        .WB_reg_w_data          (WB_out_reg_w_data),
        .WB_reg_w_data_mul      (WB_out_reg_w_data_mul),
        .WB_reg_w_en            (WB_out_reg_w_en),
        .WB_reg_w_en_mul        (WB_out_reg_w_en_mul),
        .WB_rd                  (WB_out_rd),
        .WB_rd_mul              (WB_out_rd_mul),
        .WB_csr_addr            (WB_out_csr_addr),
        .WB_csr_w_en            (WB_out_csr_w_en),
        .WB_csr_w_data          (WB_out_csr_w_data),
        .WB_w_mstatus           (WB_out_w_mstatus),
        .WB_w_mepc              (WB_out_w_mepc),
        .WB_w_mcause            (WB_out_w_mcause),
        .ID_alu_op_sel          (ID_out_alu_op_sel),
        .ID_alu_src1_sel        (ID_out_alu_src1_sel),
        .ID_alu_src2_sel        (ID_out_alu_src2_sel),
        .ID_reg_w_en            (ID_out_reg_w_en),
        .ID_reg_w_data_sel      (ID_out_reg_w_data_sel),
        .ID_store_width         (ID_out_store_width),
        .ID_load_width          (ID_out_load_width),
        .ID_load_un             (ID_out_load_un),
        .ID_imm                 (ID_out_imm),
        .ID_br_un               (ID_out_br_un),
        .ID_rs1_data            (ID_out_rs1_data),
        .ID_rs2_data            (ID_out_rs2_data),
        .ID_rs1                 (ID_out_rs1),
        .ID_rs2                 (ID_out_rs2),
        .ID_rd                  (ID_out_rd),
        .ID_pc                  (ID_out_pc),
        .ID_pc_plus_4           (ID_out_pc_plus_4),
        .ID_I_addr              (ID_out_I_addr),
        .ID_jal                 (ID_out_jal),
        .ID_jalr                (ID_out_jalr),
        .ID_branch_type         (ID_out_branch_type),
        .ID_branch_predict      (ID_out_branch_predict),
        .ID_inst                (ID_out_inst),
        .ID_ecall               (ID_out_ecall),
        .ID_mret                (ID_out_mret),
        .ID_csr_addr            (ID_out_csr_addr),
        .ID_csr_op              (ID_out_csr_op),
        .ID_csr_r_data          (ID_out_csr_r_data),
        .ID_mtvec               (ID_out_mtvec),
        .ID_mepc                (ID_out_mepc),
        .ID_mboot               (ID_out_mboot),
        .ID_calc_slow           (ID_out_calc_slow),
        .rd_queue               (rd_queue)
    );

    ID_EX id_ex_0 (
        .clk                    (clk),
        .reset                  (reset | load_flush | calc_flush | EX_branch_flush | EX_out_excp | EX_out_mret),
        .ID_alu_op_sel          (ID_out_alu_op_sel),
        .ID_alu_src1_sel        (ID_out_alu_src1_sel),
        .ID_alu_src2_sel        (ID_out_alu_src2_sel),
        .ID_reg_w_en            (ID_out_reg_w_en),
        .ID_reg_w_data_sel      (ID_out_reg_w_data_sel),
        .ID_store_width         (ID_out_store_width),
        .ID_load_width          (ID_out_load_width),
        .ID_load_un             (ID_out_load_un),
        .ID_imm                 (ID_out_imm),
        .ID_br_un               (ID_out_br_un),
        .ID_rs1_data            (ID_out_rs1_data),
        .ID_rs2_data            (ID_out_rs2_data),
        .ID_rs1                 (ID_out_rs1),
        .ID_rs2                 (ID_out_rs2),
        .ID_rd                  (ID_out_rd),
        .ID_pc                  (ID_out_pc),
        .ID_pc_plus_4           (ID_out_pc_plus_4),
        .ID_I_addr              (ID_out_I_addr),
        .ID_jal                 (ID_out_jal),
        .ID_jalr                (ID_out_jalr),
        .ID_branch_type         (ID_out_branch_type),
        .ID_branch_predict      (ID_out_branch_predict),
        .ID_inst                (ID_out_inst),
        .ID_ecall               (ID_out_ecall),
        .ID_mret                (ID_out_mret),
        .ID_csr_addr            (ID_out_csr_addr),
        .ID_csr_op              (ID_out_csr_op),
        .ID_csr_r_data          (ID_out_csr_r_data),
        .ID_mtvec               (ID_out_mtvec),
        .ID_mepc                (ID_out_mepc),
        .ID_mboot               (ID_out_mboot),
        .ID_calc_slow           (ID_out_calc_slow),
        .ID_reset               (IF_ID_reset),

        .EX_alu_op_sel          (EX_in_alu_op_sel),
        .EX_alu_src1_sel        (EX_in_alu_src1_sel),
        .EX_alu_src2_sel        (EX_in_alu_src2_sel),
        .EX_reg_w_en            (EX_in_reg_w_en),
        .EX_reg_w_data_sel      (EX_in_reg_w_data_sel),
        .EX_store_width         (EX_in_store_width),
        .EX_load_width          (EX_in_load_width),
        .EX_load_un             (EX_in_load_un),
        .EX_imm                 (EX_in_imm),
        .EX_br_un               (EX_in_br_un),
        .EX_rs1_data            (EX_in_rs1_data),
        .EX_rs2_data            (EX_in_rs2_data),
        .EX_rs1                 (EX_in_rs1),
        .EX_rs2                 (EX_in_rs2),
        .EX_rd                  (EX_in_rd),
        .EX_pc                  (EX_in_pc),
        .EX_pc_plus_4           (EX_in_pc_plus_4),
        .EX_I_addr              (EX_in_I_addr),
        .EX_jal                 (EX_in_jal),
        .EX_jalr                (EX_in_jalr),
        .EX_branch_type         (EX_in_branch_type),
        .EX_branch_predict      (EX_in_branch_predict),
        .EX_inst                (EX_in_inst),
        .EX_ecall               (EX_in_ecall),
        .EX_mret                (EX_in_mret),
        .EX_csr_addr            (EX_in_csr_addr),
        .EX_csr_op              (EX_in_csr_op),
        .EX_csr_r_data          (EX_in_csr_r_data),
        .EX_mtvec               (EX_in_mtvec),
        .EX_mepc                (EX_in_mepc),
        .EX_mboot               (EX_in_mboot),
        .EX_calc_slow           (EX_in_calc_slow),
        .EX_reset               (ID_EX_reset)
    );

    EX ex_0 (
        .clk                        (clk),
        .reset                      (reset),
        .ID_alu_op_sel              (EX_in_alu_op_sel),
        .ID_alu_src1_sel            (EX_in_alu_src1_sel),
        .ID_alu_src2_sel            (EX_in_alu_src2_sel),
        .ID_imm                     (EX_in_imm),
        .ID_rs1_data                (EX_in_rs1_data),
        .ID_rs2_data                (EX_in_rs2_data),
        .ID_br_un                   (EX_in_br_un),
        .ID_I_addr                  (EX_in_I_addr),
        .ID_rs1                     (EX_in_rs1),
        .ID_rs2                     (EX_in_rs2),
        .ID_rd                      (EX_in_rd),
        .ID_store_width             (EX_in_store_width),
        .ID_load_width              (EX_in_load_width),
        .ID_load_un                 (EX_in_load_un),
        .ID_reg_w_en                (EX_in_reg_w_en),
        .ID_reg_w_data_sel          (EX_in_reg_w_data_sel),
        .ID_pc                      (EX_in_pc),
        .ID_pc_plus_4               (EX_in_pc_plus_4),
        .ID_jal                     (EX_in_jal),
        .ID_jalr                    (EX_in_jalr),
        .ID_branch_type             (EX_in_branch_type),
        .ID_branch_predict          (EX_in_branch_predict),
        .ID_ecall                   (EX_in_ecall),
        .ID_mret                    (EX_in_mret),

        .ID_csr_addr                (EX_in_csr_addr),
        .ID_csr_op                  (EX_in_csr_op),
        .ID_csr_r_data              (EX_in_csr_r_data),
        .ID_mtvec                   (EX_in_mtvec),
        .ID_mepc                    (EX_in_mepc),
        .ID_mboot                   (EX_in_mboot),

        .ID_calc_slow               (EX_in_calc_slow),

        .ID_reset                   (ID_EX_reset),

        .MEM_reg_w_data_forwarded   (MEM_reg_w_data_forwarded),
        .WB_reg_w_data_forwarded    (WB_reg_w_data_forwarded),
        .forward_rs1_sel            (forward_rs1_sel),
        .forward_rs2_sel            (forward_rs2_sel),

        .MEM_csr_w_data_forwarded   (MEM_csr_w_data_forwarded),
        .WB_csr_w_data_forwarded    (WB_csr_w_data_forwarded),
        .forward_csr_sel            (forward_csr_sel),

        .EX_alu_result              (EX_out_alu_result),
        .EX_alu_mul_result          (EX_out_alu_mul_result),
        .EX_pc_sel                  (EX_out_pc_sel),
        .EX_reg_w_en                (EX_out_reg_w_en),
        .EX_reg_w_en_mul            (EX_out_reg_w_en_mul),
        .EX_reg_w_data_sel          (EX_out_reg_w_data_sel),
        .EX_store_width             (EX_out_store_width),
        .EX_load_width              (EX_out_load_width),
        .EX_load_un                 (EX_out_load_un),
        .EX_pc_plus_4               (EX_out_pc_plus_4),
        .EX_rd                      (EX_out_rd),
        .EX_rd_mul                  (EX_out_rd_mul),
        .EX_rs2_data                (EX_out_rs2_data),
        .EX_rs1                     (EX_out_rs1),
        .EX_rs2                     (EX_out_rs2),
        .EX_pc                      (EX_out_pc),
        .EX_branch_predict          (EX_out_branch_predict),
        .EX_jal                     (EX_out_jal),
        .EX_jalr                    (EX_out_jalr),
        .EX_branch_type             (EX_out_branch_type),
        .EX_ecall                   (EX_out_ecall),
        .EX_mret                    (EX_out_mret),
        .EX_trap_dest               (EX_out_trap_dest),

        .EX_csr_addr                (EX_out_csr_addr),
        .EX_csr_w_data              (EX_out_csr_w_data),
        .EX_csr_w_en                (EX_out_csr_w_en),
        .EX_csr_r_data              (EX_out_csr_r_data),
        .EX_csr_op                  (EX_out_csr_op),

        .EX_w_mstatus               (EX_out_w_mstatus),
        .EX_w_mepc                  (EX_out_w_mepc),
        .EX_w_mcause                (EX_out_w_mcause),
        .EX_excp                    (EX_out_excp),

        .inst_access_fault          (inst_access_fault)
    );

    EX_MEM ex_mem_0 (
        .clk                     (clk),
        .reset                   (reset | calc_flush),
        .EX_alu_result           (EX_out_alu_result),
        .EX_alu_mul_result       (EX_out_alu_mul_result),
        .EX_reg_w_en             (EX_out_reg_w_en),
        .EX_reg_w_en_mul         (EX_out_reg_w_en_mul),
        .EX_reg_w_data_sel       (EX_out_reg_w_data_sel),
        .EX_store_width          (EX_out_store_width),
        .EX_load_width           (EX_out_load_width),
        .EX_load_un              (EX_out_load_un),
        .EX_pc_plus_4            (EX_out_pc_plus_4),
        .EX_rd                   (EX_out_rd),
        .EX_rd_mul               (EX_out_rd_mul),
        .EX_rs2_data             (EX_out_rs2_data),
        .EX_csr_addr             (EX_out_csr_addr),
        .EX_csr_w_data           (EX_out_csr_w_data),
        .EX_csr_w_en             (EX_out_csr_w_en),
        .EX_csr_r_data           (EX_out_csr_r_data),
        .EX_w_mstatus            (EX_out_w_mstatus),
        .EX_w_mepc               (EX_out_w_mepc),
        .EX_w_mcause             (EX_out_w_mcause),
        .MEM_alu_result          (MEM_in_alu_result),
        .MEM_alu_mul_result      (MEM_in_alu_mul_result),
        .MEM_reg_w_en            (MEM_in_reg_w_en),
        .MEM_reg_w_en_mul        (MEM_in_reg_w_en_mul),
        .MEM_reg_w_data_sel      (MEM_in_reg_w_data_sel),
        .MEM_store_width         (MEM_in_store_width),
        .MEM_load_width          (MEM_in_load_width),
        .MEM_load_un             (MEM_in_load_un),
        .MEM_pc_plus_4           (MEM_in_pc_plus_4),
        .MEM_rd                  (MEM_in_rd),
        .MEM_rd_mul              (MEM_in_rd_mul),
        .MEM_rs2_data            (MEM_in_rs2_data),
        .MEM_csr_addr            (MEM_in_csr_addr),
        .MEM_csr_w_data          (MEM_in_csr_w_data),
        .MEM_csr_w_en            (MEM_in_csr_w_en),
        .MEM_csr_r_data          (MEM_in_csr_r_data),
        .MEM_w_mstatus           (MEM_in_w_mstatus),
        .MEM_w_mepc              (MEM_in_w_mepc),
        .MEM_w_mcause            (MEM_in_w_mcause)
    );

    MEM mem_0 (
        .EX_alu_result           (MEM_in_alu_result),
        .EX_alu_mul_result       (MEM_in_alu_mul_result),
        .EX_reg_w_en             (MEM_in_reg_w_en),
        .EX_reg_w_en_mul         (MEM_in_reg_w_en_mul),
        .EX_reg_w_data_sel       (MEM_in_reg_w_data_sel),
        .EX_store_width          (MEM_in_store_width),
        .EX_load_width           (MEM_in_load_width),
        .EX_load_un              (MEM_in_load_un),
        .EX_pc_plus_4            (MEM_in_pc_plus_4),
        .EX_rd                   (MEM_in_rd),
        .EX_rd_mul               (MEM_in_rd_mul),
        .EX_rs2_data             (MEM_in_rs2_data),
        .EX_csr_addr             (MEM_in_csr_addr),
        .EX_csr_w_data           (MEM_in_csr_w_data),
        .EX_csr_w_en             (MEM_in_csr_w_en),
        .EX_csr_r_data           (MEM_in_csr_r_data),
        .EX_w_mstatus            (MEM_in_w_mstatus),
        .EX_w_mepc               (MEM_in_w_mepc),
        .EX_w_mcause             (MEM_in_w_mcause),
        .D_addr                  (D_addr),
        .D_store_data            (D_store_data),
        .D_store_width           (D_store_width),
        .D_load_width            (D_load_width),
        .D_load_un               (D_load_un),
        .D_load_data             (D_load_data),
        .MEM_reg_w_en            (MEM_out_reg_w_en),
        .MEM_reg_w_en_mul        (MEM_out_reg_w_en_mul),
        .MEM_reg_w_data_sel      (MEM_out_reg_w_data_sel),
        .MEM_reg_w_data          (MEM_out_reg_w_data),
        .MEM_pc_plus_4           (MEM_out_pc_plus_4),
        .MEM_rd                  (MEM_out_rd),
        .MEM_rd_mul              (MEM_out_rd_mul),
        .MEM_dmem_data           (MEM_out_dmem_data),
        .MEM_alu_result          (MEM_out_alu_result),
        .MEM_alu_mul_result      (MEM_out_alu_mul_result),
        .MEM_csr_addr            (MEM_out_csr_addr),
        .MEM_csr_w_data          (MEM_out_csr_w_data),
        .MEM_csr_w_en            (MEM_out_csr_w_en),
        .MEM_csr_r_data          (MEM_out_csr_r_data),
        .MEM_w_mstatus           (MEM_out_w_mstatus),
        .MEM_w_mepc              (MEM_out_w_mepc),
        .MEM_w_mcause            (MEM_out_w_mcause)
    );

    MEM_WB mem_wb_0 (
        .clk                     (clk),
        .reset                   (reset),
        .MEM_reg_w_en            (MEM_out_reg_w_en),
        .MEM_reg_w_en_mul        (MEM_out_reg_w_en_mul),
        .MEM_reg_w_data_sel      (MEM_out_reg_w_data_sel),
        .MEM_pc_plus_4           (MEM_out_pc_plus_4),
        .MEM_rd                  (MEM_out_rd),
        .MEM_rd_mul              (MEM_out_rd_mul),
        .MEM_dmem_data           (MEM_out_dmem_data),
        .MEM_alu_result          (MEM_out_alu_result),
        .MEM_alu_mul_result      (MEM_out_alu_mul_result),
        .MEM_csr_addr            (MEM_out_csr_addr),
        .MEM_csr_w_data          (MEM_out_csr_w_data),
        .MEM_csr_w_en            (MEM_out_csr_w_en),
        .MEM_csr_r_data          (MEM_out_csr_r_data),
        .MEM_w_mstatus           (MEM_out_w_mstatus),
        .MEM_w_mepc              (MEM_out_w_mepc),
        .MEM_w_mcause            (MEM_out_w_mcause),
        .WB_reg_w_en             (WB_in_reg_w_en),
        .WB_reg_w_en_mul         (WB_in_reg_w_en_mul),
        .WB_reg_w_data_sel       (WB_in_reg_w_data_sel),
        .WB_pc_plus_4            (WB_in_pc_plus_4),
        .WB_rd                   (WB_in_rd),
        .WB_rd_mul               (WB_in_rd_mul),
        .WB_dmem_data            (WB_in_dmem_data),
        .WB_alu_result           (WB_in_alu_result),
        .WB_alu_mul_result       (WB_in_alu_mul_result),
        .WB_csr_addr             (WB_in_csr_addr),
        .WB_csr_w_data           (WB_in_csr_w_data),
        .WB_csr_w_en             (WB_in_csr_w_en),
        .WB_csr_r_data           (WB_in_csr_r_data),
        .WB_w_mstatus            (WB_in_w_mstatus),
        .WB_w_mepc               (WB_in_w_mepc),
        .WB_w_mcause             (WB_in_w_mcause)
    );

    WB wb_0 (
        .MEM_reg_w_en            (WB_in_reg_w_en),
        .MEM_reg_w_en_mul        (WB_in_reg_w_en_mul),
        .MEM_reg_w_data_sel      (WB_in_reg_w_data_sel),
        .MEM_pc_plus_4           (WB_in_pc_plus_4),
        .MEM_rd                  (WB_in_rd),
        .MEM_rd_mul              (WB_in_rd_mul),
        .MEM_dmem_data           (WB_in_dmem_data),
        .MEM_alu_result          (WB_in_alu_result),
        .MEM_alu_mul_result      (WB_in_alu_mul_result),
        .MEM_csr_addr            (WB_in_csr_addr),
        .MEM_csr_w_data          (WB_in_csr_w_data),
        .MEM_csr_w_en            (WB_in_csr_w_en),
        .MEM_csr_r_data          (WB_in_csr_r_data),
        .MEM_w_mstatus           (WB_in_w_mstatus),
        .MEM_w_mepc              (WB_in_w_mepc),
        .MEM_w_mcause            (WB_in_w_mcause),
        .WB_reg_w_en             (WB_out_reg_w_en),
        .WB_reg_w_en_mul         (WB_out_reg_w_en_mul),
        .WB_reg_w_data           (WB_out_reg_w_data),
        .WB_reg_w_data_mul       (WB_out_reg_w_data_mul),
        .WB_rd                   (WB_out_rd),
        .WB_rd_mul               (WB_out_rd_mul),
        .WB_csr_addr             (WB_out_csr_addr),
        .WB_csr_w_data           (WB_out_csr_w_data),
        .WB_csr_w_en             (WB_out_csr_w_en),
        .WB_w_mstatus            (WB_out_w_mstatus),
        .WB_w_mepc               (WB_out_w_mepc),
        .WB_w_mcause             (WB_out_w_mcause)
    );

    hazard_unit hazard_unit_0 (
        .MEM_rd                      (MEM_out_rd),
        .MEM_reg_w_en                (MEM_out_reg_w_en),
        .MEM_reg_w_data              (MEM_out_reg_w_data),
        .WB_rd                       (WB_out_rd),
        .WB_reg_w_en                 (WB_out_reg_w_en),
        .WB_reg_w_data               (WB_out_reg_w_data),
        .EX_rs1                      (EX_out_rs1),
        .EX_rs2                      (EX_out_rs2),
        .EX_ecall                    (EX_out_ecall), 
        .EX_mret                     (EX_out_mret),
        .EX_csr_op                   (EX_out_csr_op),
        .MEM_csr_w_en                (MEM_out_csr_w_en),
        .WB_csr_w_en                 (WB_out_csr_w_en),
        .EX_csr_addr                 (EX_out_csr_addr),
        .MEM_csr_addr                (MEM_out_csr_addr),
        .WB_csr_addr                 (WB_out_csr_addr),
        .MEM_csr_w_data              (MEM_out_csr_w_data),
        .WB_csr_w_data               (WB_out_csr_w_data),
        .rd_queue                    (rd_queue),

        .MEM_csr_w_data_forwarded    (MEM_csr_w_data_forwarded),
        .WB_csr_w_data_forwarded     (WB_csr_w_data_forwarded),
        .forward_csr_sel             (forward_csr_sel),
        .MEM_reg_w_data_forwarded    (MEM_reg_w_data_forwarded),
        .WB_reg_w_data_forwarded     (WB_reg_w_data_forwarded),
        .forward_rs1_sel             (forward_rs1_sel),
        .forward_rs2_sel             (forward_rs2_sel),
        .ID_rs1                      (ID_out_rs1),
        .ID_rs2                      (ID_out_rs2),
        .EX_rd                       (EX_out_rd),
        .EX_load                     (EX_out_load_width != `NO_LOAD),
        .load_stall                  (load_stall),
        .load_flush                  (load_flush),
        .calc_stall                  (calc_stall),
        .calc_flush                  (calc_flush)
    );

`ifdef BRANCH_PREDICT_ENA
    branch_prediction_unit branch_prediction_unit_0 (
        .clk                   (clk),
        .reset                 (reset),
        .stall                 (load_stall),
        .IF_pc                 (IF_out_pc),
        .IF_inst               (IF_out_inst),
        .EX_pc                 (EX_out_pc),
        .EX_alu_result         (EX_out_alu_result),
        .EX_jal                (EX_out_jal),
        .EX_jalr               (EX_out_jalr),
        .EX_branch_type        (EX_out_branch_type),
        .EX_pc_sel             (EX_out_pc_sel),
        .branch_predict        (branch_predict),
        .branch_target         (branch_target),
        .EX_false_target       (EX_false_target),
        .EX_false_direction    (EX_false_direction),
        .EX_branch_flush       (EX_branch_flush)
    );
`else
    assign EX_branch_flush = EX_out_pc_sel;
`endif

    memory memory_0(
        .clk                        (clk),
        .reset                      (reset),

        .I_en                       (1'b1),
        .I_write_en                 (wea),
        .I_addr                     (I_addr),
        .I_store_data               (I_store_data),
        .I_load_data                (I_load_data),

        .D_en                       (1'b1),
        .D_addr                     (D_addr),
        .D_store_data               (D_store_data),
        .D_store_width              (D_store_width),
        .D_load_data                (D_load_data),
        .D_load_width               (D_load_width),
        .D_load_un                  (D_load_un),

        .sws_l                      (sws_l),
        .sws_r                      (sws_r),

        .bts_state                  (bts_state),

        .seg_display_hex            (seg_display_hex),

        .leds_l                     (leds_l),
        .leds_r                     (leds_r),

        .clk_pixel                  (clk_pixel),
        .vga_addr                   (vga_addr),
        .vga_data                   (vga_data),

        .key_code                   (key_code),

        .uart_rx_data               (uart_rx_data),
        .uart_tx_data               (uart_tx_data),
        .uart_read                  (uart_read),
        .uart_write                 (uart_write),

        .uart_rx_ready              (uart_rx_ready),
        .uart_tx_ready              (uart_tx_ready),

        .uart_ctrl                  (uart_ctrl)
    );

    `ifdef DEBUG
        ila_0 ila_0_0 (
            .clk                     (clk),
            .probe0                  (),
            .probe1                  (EX_branch_flush),
            .probe2                  (load_stall),
            .probe3                  (IF_out_pc),
            .probe4                  (IF_out_inst),
            .probe5                  (EX_in_pc),
            .probe6                  (EX_in_inst),
            .probe7                  (MEM_reg_w_data_forwarded),
            .probe8                  (WB_reg_w_data_forwarded),
            .probe9                  (EX_in_rs1_data),
            .probe10                 (EX_in_rs2_data),
            .probe11                 (EX_out_alu_result),
            .probe12                 (t0),
            .probe13                 (t1),
            .probe14                 (t2),
            .probe15                 (t3),
            .probe16                 (),
            .probe17                 ()
        );
    `endif

endmodule
