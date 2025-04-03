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
    input clk,
    input reset,

    input [31:0] uart_addr,
    input [31:0] uart_inst,
    input uart_write,
    input uart_inst_loaded,

    output [31:0] I_read,

    input [7:0] sws_l,
    input [7:0] sws_r,

    output [7:0] leds_l,
    output [7:0] leds_r,

    input clk_pixel,
    input [31:0] vga_addr,
    output [31:0] vga_data
    );

    parameter LOADING = 0, RUNNING = 1;

    wire core_mode      = uart_inst_loaded ? RUNNING : LOADING;
    wire core_reset     = reset | core_mode == LOADING;

    // Memory
    wire [3:0] wea = {4{core_mode == LOADING & uart_write}};
    wire [31:0] I_addr = core_mode == LOADING ? uart_addr : IF_I_addr;
    wire [31:0] I_store_data = uart_inst;
    wire [31:0] D_addr, D_store_data, D_load_data;
    wire [1:0] D_store_width, D_load_width;
    wire D_load_un;

    // IO
    assign leds_r = {leds_r_mem, core_mode};
    wire [7:1] leds_r_mem;

    // WB signals
    wire WB_out_reg_w_en;
    wire [31:0] WB_out_reg_w_data;
    wire [4:0] WB_out_rd;

    wire [31:0] IF_I_addr, I_load_data;
    wire [31:0] IF_out_pc, IF_out_pc_plus_4, IF_out_inst, IF_out_I_addr;
    wire [31:0] ID_in_pc, ID_in_pc_plus_4, ID_in_inst, ID_in_I_addr;
    wire [1:0] ID_out_store_width, ID_out_load_width;

    wire load_stall, load_flush, branch_flush;

    IF if_0 (
        .clk                    (clk),
        .reset                  (core_reset),
        .stall                  (load_stall),
        .EX_pc_sel              (EX_out_pc_sel),
        .EX_alu_result          (EX_out_alu_result),
        // interface with memory
        .I_addr                 (IF_I_addr),            // address to read from memory
        .I_load_data            (I_load_data),          // data read from memory

        .IF_pc                  (IF_out_pc),
        .IF_pc_plus_4           (IF_out_pc_plus_4),
        .IF_inst                (IF_out_inst),
        .IF_I_addr              (IF_out_I_addr)
    );

    IF_ID if_id_0(
        .clk                    (clk),
        .reset                  (core_reset | branch_flush),
        .stall                  (load_stall),

        .IF_pc                  (IF_out_pc),
        .IF_pc_plus_4           (IF_out_pc_plus_4),
        .IF_inst                (IF_out_inst),
        .IF_I_addr              (IF_out_I_addr),

        .ID_pc                  (ID_in_pc),
        .ID_pc_plus_4           (ID_in_pc_plus_4),
        .ID_inst                (ID_in_inst),
        .ID_I_addr              (ID_in_I_addr)
    );

    wire [3:0] ID_out_alu_op_sel;
    wire ID_out_alu_src1_sel;
    wire ID_out_alu_src2_sel;
    wire ID_out_reg_w_en;
    wire [1:0] ID_out_reg_w_data_sel;
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
    wire ID_out_jump;
    wire [2:0] ID_out_branch_type;

    wire [3:0] EX_in_alu_op_sel;
    wire EX_in_alu_src1_sel;
    wire EX_in_alu_src2_sel;
    wire EX_in_reg_w_en;
    wire [1:0] EX_in_reg_w_data_sel;
    wire [1:0] EX_in_store_width;
    wire [1:0] EX_in_load_width;
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
    wire EX_in_jump;
    wire [2:0] EX_in_branch_type;

    ID id_0 (
        .clk                    (clk),
        .reset                  (core_reset),
        .IF_pc                  (ID_in_pc),
        .IF_pc_plus_4           (ID_in_pc_plus_4),
        .IF_inst                (ID_in_inst),
        .IF_I_addr              (ID_in_I_addr),
        .WB_reg_w_data          (WB_out_reg_w_data),
        .WB_reg_w_en            (WB_out_reg_w_en),
        .WB_rd                  (WB_out_rd),
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
        .ID_jump                (ID_out_jump),
        .ID_branch_type         (ID_out_branch_type)
    );

    ID_EX id_ex_0 (
        .clk                    (clk),
        .reset                  (core_reset | load_flush | branch_flush),
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
        .ID_jump                (ID_out_jump),
        .ID_branch_type         (ID_out_branch_type),

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
        .EX_jump                (EX_in_jump),
        .EX_branch_type         (EX_in_branch_type)
    );

    wire [31:0] EX_out_alu_result;
    wire EX_out_pc_sel;
    wire EX_out_reg_w_en;
    wire [1:0] EX_out_reg_w_data_sel;
    wire [1:0] EX_out_store_width;
    wire [1:0] EX_out_load_width;
    wire EX_out_load_un;
    wire [31:0] EX_out_pc_plus_4;
    wire [4:0] EX_out_rd;
    wire [31:0] EX_out_rs2_data;
    wire [4:0] EX_out_rs1, EX_out_rs2;

    wire [31:0] MEM_alu_result_forwarded;
    wire [31:0] WB_alu_result_forwarded;
    wire [1:0] forward_rs1_sel;
    wire [1:0] forward_rs2_sel;

    wire [31:0] MEM_in_alu_result;
    wire MEM_in_reg_w_en;
    wire [1:0] MEM_in_reg_w_data_sel;
    wire [1:0] MEM_in_store_width;
    wire [1:0] MEM_in_load_width;
    wire MEM_in_load_un;
    wire [31:0] MEM_in_pc_plus_4;
    wire [4:0] MEM_in_rd;
    wire [31:0] MEM_in_rs2_data;

    EX ex_0 (
        .ID_alu_op_sel              (EX_in_alu_op_sel),
        .ID_alu_src1_sel            (EX_in_alu_src1_sel),
        .ID_alu_src2_sel            (EX_in_alu_src2_sel),
        .ID_imm                     (EX_in_imm),
        .ID_rs1_data                (EX_in_rs1_data),
        .ID_rs2_data                (EX_in_rs2_data),
        .ID_br_un                   (EX_in_br_un),
        .ID_I_addr                  (EX_in_I_addr),
        .ID_rs1                     (EX_in_rs1),
        // TBD  
        .ID_rs2                     (EX_in_rs2),
        // TBD  
        .ID_rd                      (EX_in_rd),
        .ID_store_width             (EX_in_store_width),
        .ID_load_width              (EX_in_load_width),
        .ID_load_un                 (EX_in_load_un),
        .ID_reg_w_en                (EX_in_reg_w_en),
        .ID_reg_w_data_sel          (EX_in_reg_w_data_sel),
        .ID_pc                      (EX_in_pc),
        .ID_pc_plus_4               (EX_in_pc_plus_4),
        .ID_jump                    (EX_in_jump),
        .ID_branch_type             (EX_in_branch_type),

        .MEM_alu_result_forwarded   (MEM_alu_result_forwarded),
        .WB_alu_result_forwarded    (WB_alu_result_forwarded),
        .forward_rs1_sel            (forward_rs1_sel),
        .forward_rs2_sel            (forward_rs2_sel),

        .EX_alu_result              (EX_out_alu_result),
        .EX_pc_sel                  (EX_out_pc_sel),
        .EX_reg_w_en                (EX_out_reg_w_en),
        .EX_reg_w_data_sel          (EX_out_reg_w_data_sel),
        .EX_store_width             (EX_out_store_width),
        .EX_load_width              (EX_out_load_width),
        .EX_load_un                 (EX_out_load_un),
        .EX_pc_plus_4               (EX_out_pc_plus_4),
        .EX_rd                      (EX_out_rd),
        .EX_rs2_data                (EX_out_rs2_data),
        .EX_rs1                     (EX_out_rs1),
        .EX_rs2                     (EX_out_rs2)
    );

    EX_MEM ex_mem_0 (
        .clk                     (clk),
        .reset                   (core_reset),
        .EX_alu_result           (EX_out_alu_result),
        .EX_reg_w_en             (EX_out_reg_w_en),
        .EX_reg_w_data_sel       (EX_out_reg_w_data_sel),
        .EX_store_width          (EX_out_store_width),
        .EX_load_width           (EX_out_load_width),
        .EX_load_un              (EX_out_load_un),
        .EX_pc_plus_4            (EX_out_pc_plus_4),
        .EX_rd                   (EX_out_rd),
        .EX_rs2_data             (EX_out_rs2_data),
        .MEM_alu_result          (MEM_in_alu_result),
        .MEM_reg_w_en            (MEM_in_reg_w_en),
        .MEM_reg_w_data_sel      (MEM_in_reg_w_data_sel),
        .MEM_store_width         (MEM_in_store_width),
        .MEM_load_width          (MEM_in_load_width),
        .MEM_load_un             (MEM_in_load_un),
        .MEM_pc_plus_4           (MEM_in_pc_plus_4),
        .MEM_rd                  (MEM_in_rd),
        .MEM_rs2_data            (MEM_in_rs2_data)
    );

    wire [31:0] MEM_out_alu_result;
    wire MEM_out_reg_w_en;
    wire [1:0] MEM_out_reg_w_data_sel;
    wire [31:0] MEM_out_pc_plus_4;
    wire [4:0] MEM_out_rd;
    wire [31:0] MEM_out_dmem_data;

    wire [31:0] WB_in_alu_result;
    wire WB_in_reg_w_en;
    wire [1:0] WB_in_reg_w_data_sel;
    wire [31:0] WB_in_pc_plus_4;
    wire [4:0] WB_in_rd;
    wire [31:0] WB_in_dmem_data;

    MEM mem_0 (
        .EX_alu_result           (MEM_in_alu_result),
        .EX_reg_w_en             (MEM_in_reg_w_en),
        .EX_reg_w_data_sel       (MEM_in_reg_w_data_sel),
        .EX_store_width          (MEM_in_store_width),
        .EX_load_width           (MEM_in_load_width),
        .EX_load_un              (MEM_in_load_un),
        .EX_pc_plus_4            (MEM_in_pc_plus_4),
        .EX_rd                   (MEM_in_rd),
        .EX_rs2_data             (MEM_in_rs2_data),
        // interface with data memory
        .D_addr                  (D_addr),
        .D_store_data            (D_store_data),
        .D_store_width           (D_store_width),
        .D_load_width            (D_load_width),
        .D_load_un               (D_load_un),
        .D_load_data             (D_load_data),
        .MEM_reg_w_en            (MEM_out_reg_w_en),
        .MEM_reg_w_data_sel      (MEM_out_reg_w_data_sel),
        .MEM_pc_plus_4           (MEM_out_pc_plus_4),
        .MEM_rd                  (MEM_out_rd),
        .MEM_dmem_data           (MEM_out_dmem_data),
        .MEM_alu_result          (MEM_out_alu_result)
    );

    MEM_WB mem_wb_0 (
        .clk                     (clk),
        .reset                   (core_reset),
        .MEM_reg_w_en            (MEM_out_reg_w_en),
        .MEM_reg_w_data_sel      (MEM_out_reg_w_data_sel),
        .MEM_pc_plus_4           (MEM_out_pc_plus_4),
        .MEM_rd                  (MEM_out_rd),
        .MEM_dmem_data           (MEM_out_dmem_data),
        .MEM_alu_result          (MEM_out_alu_result),
        .WB_reg_w_en             (WB_in_reg_w_en),
        .WB_reg_w_data_sel       (WB_in_reg_w_data_sel),
        .WB_pc_plus_4            (WB_in_pc_plus_4),
        .WB_rd                   (WB_in_rd),
        .WB_dmem_data            (WB_in_dmem_data),
        .WB_alu_result           (WB_in_alu_result)
    );



    WB wb_0 (
        .MEM_reg_w_en            (WB_in_reg_w_en),
        .MEM_reg_w_data_sel      (WB_in_reg_w_data_sel),
        .MEM_pc_plus_4           (WB_in_pc_plus_4),
        .MEM_rd                  (WB_in_rd),
        .MEM_dmem_data           (WB_in_dmem_data),
        .MEM_alu_result          (WB_in_alu_result),
        .WB_reg_w_en             (WB_out_reg_w_en),
        .WB_reg_w_data           (WB_out_reg_w_data),
        .WB_rd                   (WB_out_rd)
    );

    hazard_unit u_hazard_unit (
        .MEM_rd                      (MEM_out_rd),
        .MEM_reg_w_en                (MEM_out_reg_w_en),
        .MEM_alu_result              (MEM_out_alu_result),
        .WB_rd                       (WB_out_rd),
        .WB_reg_w_en                 (WB_out_reg_w_en),
        .WB_alu_result               (WB_out_reg_w_data),
        .EX_rs1                      (EX_out_rs1),
        .EX_rs2                      (EX_out_rs2),
        .MEM_alu_result_forwarded    (MEM_alu_result_forwarded),
        .WB_alu_result_forwarded     (WB_alu_result_forwarded),
        .forward_rs1_sel             (forward_rs1_sel),
        .forward_rs2_sel             (forward_rs2_sel),
        .ID_rs1                      (ID_out_rs1),
        .ID_rs2                      (ID_out_rs2),
        .EX_rd                       (EX_out_rd),
        .EX_load                     (EX_out_reg_w_data_sel[0]),
        .load_stall                  (load_stall),
        .load_flush                  (load_flush),
        .EX_pc_sel                   (EX_out_pc_sel),
        .branch_flush                (branch_flush)
    );

    memory memory_0(
        .clk(clk),
        .reset(core_reset),

        .I_en(1'b1),
        .I_write_en(wea),
        .I_addr(I_addr),
        .I_store_data(I_store_data),
        .I_load_data(I_load_data),

        .D_en(1'b1),
        .D_addr(D_addr),
        .D_store_data(D_store_data),
        .D_store_width(D_store_width),
        .D_load_data(D_load_data),
        .D_load_width(D_load_width),
        .D_load_un(D_load_un),


        .sws_l(sws_l),
        .sws_r(sws_r),

        .leds_l(leds_l),
        .leds_r(leds_r_mem),

        .clk_pixel(clk_pixel),
        .vga_addr(vga_addr),
        .vga_data(vga_data)
    );

    /* -------------------------------------- Debug -------------------------------------- */

    // reg stop;
    // reg [31:0] pc_debug, addra_debug, inst_debug;
    // reg pc_sel_debug;
    // always @(posedge clk) begin
    //     if (core_reset) begin
    //         stop <= 1'b0;
    //     end else if (inst != 32'h0) begin
    //         if (stop == 1'b0) begin
    //             pc_debug <= pc; // save the pc when we first meet an illegal instruction
    //             pc_sel_debug <= pc_sel;
    //             addra_debug <= addra;
    //             inst_debug <= inst;
    //         end
    //         stop <= 1'b1;
    //     end
    // end

    // assign leds_l = pc[7:0];

    // assign leds_l[7] = stop;
    // assign leds_l[6:0] = inst_debug[6:0];
    // assign leds_r = {pc_sel_debug, pc_debug[5:0], core_mode};
    // assign I_read = inst_debug;

endmodule
