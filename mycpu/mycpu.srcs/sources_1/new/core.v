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

    output [31:0] I_read,

    input [7:0] sws_l,
    input [7:0] sws_r,

    input [4:0] bts_state,

    output [31:0] seg_display_hex,

    output [7:0] leds_l,
    output [7:0] leds_r
    );

    parameter LOADING = 0, RUNNING = 1;


    wire core_reset     = reset;

    // Instruction Decode
    wire [6:0] opcode;
    wire [6:0] funct7;
    wire [2:0] funct3;
    wire [4:0] rs1, rs2, rd;
    wire [24:0] imm_raw;

    // Immediate Generator
    wire [31:0] imm;

    // Control Logic
    wire pc_sel;
    wire [3:0] alu_op_sel;
    wire alu_src1_sel, alu_src2_sel;
    wire reg_w_en;
    wire [1:0] reg_w_data_sel;
    wire [1:0] D_store_width;
    wire [2:0] D_load_width;
    wire D_load_un;
    wire [2:0] imm_sel;
    wire br_un;
    
    reg [31:0] pc;    
    wire [31:0] mem_inst;
    wire [31:0] inst = mem_inst;

    wire [31:0] D_load_data; 

    // Branch Comparator
    wire br_eq, br_lt;

    wire [31:0] alu_result;
    // Register File
    wire [31:0] reg_w_data = reg_w_data_sel == 2'h0 ? alu_result :
                             reg_w_data_sel == 2'h1 ? D_load_data :
                             reg_w_data_sel == 2'h2 ? pc + 4: 32'h0;
                             
    wire [31:0] rs1_data, rs2_data;
    
    wire [31:0] addra = pc;
    // ALU
    wire [31:0] alu_src1 = alu_src1_sel ? rs1_data : addra;
    wire [31:0] alu_src2 = alu_src2_sel ? rs2_data : imm;
    
        // Memory
    wire [3:0] wea = 4'b0;


    wire [31:0] I_store_data = 32'b0;
    wire [31:0] I_load_data;//Didn't used?
    wire [31:0] D_store_data = rs2_data;
    wire [31:0] D_addr = alu_result; // alu_result

    
    wire [31:0] pc_next = pc_sel ? (alu_result) : (pc + 4);

    always @(posedge clk) begin
        if (reset) begin
            pc <= 32'h0;
        end else begin
            pc <= pc_next;
        end
    end

    wire [31:0] t0, t1, sp, a0;

    control_logic ctrl_logic_0(
        .inst(inst),
        .br_eq(br_eq),
        .br_lt(br_lt),

        .pc_sel(pc_sel),
        .alu_op_sel(alu_op_sel),
        .alu_src1_sel(alu_src1_sel),
        .alu_src2_sel(alu_src2_sel),
        .reg_w_en(reg_w_en),
        .reg_w_data_sel(reg_w_data_sel),
        .store_width(D_store_width),
        .load_width(D_load_width),
        .load_un(D_load_un),
        .imm_sel(imm_sel),
        .br_un(br_un)
    );

    branch_comp branch_comp_0(
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .br_un(br_un),
        .br_eq(br_eq),
        .br_lt(br_lt)
    );

    inst_decoder inst_decoder_0(
        .inst(inst),

        .opcode(opcode),
        .funct7(funct7),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .imm(imm_raw)
    );

    imm_gen imm_gen_0(
        .imm_raw(imm_raw),
        .imm_sel(imm_sel),

        .imm(imm)
    );

    regfile regfile_0(
        .t0(t0),
        .t1(t1),
        .sp(sp),
        .a0(a0),
        .clk(clk),
        .reset(core_reset),
        .write_en(reg_w_en),
        .rs1(rs1),
        .rs2(rs2),
        .dest(rd),
        .write_data(reg_w_data),

        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    memory memory_0(
        .clk                        (clk),
        .reset                      (reset),

        .I_en                       (1'b1),
        .I_write_en                 (wea),
        .I_addr                     (addra),
        .I_store_data               (I_store_data),
        .I_load_data                (mem_inst),//question

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
        .leds_r                     (leds_r)

    );


    alu alu_0(
        .src1(alu_src1),
        .src2(alu_src2),
        .op_sel(alu_op_sel),
        .result(alu_result)
    );

    ila_0 ila_0_0 (
        .clk(clk),
        .probe0(pc),
        .probe1(inst),
        .probe2(t0),
        .probe3(t1),
        .probe4(sp),
        .probe5(D_load_data),
        .probe6(D_load_width),
        .probe7(D_load_un),
        .probe8(D_addr),
        .probe9(alu_src1),
        .probe10(alu_src2),
        .probe11(alu_result),
        .probe12(pc_sel),
        .probe13(rs1_data),
        .probe14(rs2_data),
        .probe15(br_eq),
        .probe16(br_lt),
        .probe17(br_un),
        .probe18(a0)
    );

endmodule
