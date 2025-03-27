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
    output [7:0] leds_r
    );

    parameter LOADING = 0, RUNNING = 1;

    wire core_mode      = uart_inst_loaded ? RUNNING : LOADING;
    wire core_reset     = reset | core_mode == LOADING;

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
    wire [1:0] D_load_width;
    wire D_load_un;
    wire [2:0] imm_sel;
    wire br_un;
    wire store = D_store_width != 2'h3;
    wire load = D_load_width != 2'h3;

    // Hazard Detection
    reg [31:0] D_addr_prev;
    reg store_prev;
    reg load_prev;
    always @(posedge clk) begin
        if (reset) begin
            store_prev <= 1'b0;
            load_prev <= 1'b0;
        end else begin
            store_prev <= store;
            load_prev <= load;
        end
    end
    

    // Program Counter
    reg pc_sel_reg;
    reg [31:0] addra_prev_1, addra_prev_2;
    always @(posedge clk) begin
        if (core_reset) begin
            pc_sel_reg <= 1'b0;
            addra_prev_1 <= 32'b0;
            addra_prev_2 <= 32'b0;
        end else begin
            pc_sel_reg <= pc_sel;
            addra_prev_1 <= addra;
            addra_prev_2 <= addra_prev_1;
        end
    end

    wire [31:0] pc, pc_prev_1, pc_prev_2;
    wire [31:0] mem_inst;
    wire [31:0] inst = (core_mode == LOADING | pc_sel_reg | store_prev | load_prev) ? `NOP : mem_inst;

    // Branch Comparator
    wire br_eq, br_lt;

    // ALU
    wire [31:0] alu_src1 = alu_src1_sel ? rs1_data : addra_prev_2;
    wire [31:0] alu_src2 = alu_src2_sel ? rs2_data : imm;
    wire [31:0] alu_result;

    // Register File
    wire [31:0] reg_w_data = reg_w_data_sel == 2'h0 ? alu_result :
                             reg_w_data_sel == 2'h1 ? D_load_data :
                             reg_w_data_sel == 2'h2 ? (pc_prev_2 + 4) : 32'h0;
    wire [31:0] rs1_data, rs2_data;

    // Memory
    wire [3:0] wea = {4{core_mode == LOADING & uart_write}};
    wire [31:0] addra = core_mode == LOADING ? uart_addr :
                                      pc_sel ? alu_result :
                              (store | load) ? pc_prev_1 :
                                         pc;

    wire [31:0] D_store_data = rs2_data;
    wire [31:0] D_addr = alu_result; // alu_result
    wire [31:0] D_load_data; 

    wire [7:1] leds_r_mem;

    // io
    assign leds_r = {leds_r_mem, core_mode};

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
        .clk(clk),
        .reset(core_reset),

        .I_en(1'b1),
        .I_write_en(wea),
        .I_addr(addra),
        .I_store_data(uart_inst),
        .I_load_data(mem_inst),

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
        .leds_r(leds_r_mem)
    );

    IF IF_0(
        .clk(clk),
        .reset(core_reset),
        .store(store),
        .load(load),
        .pc_sel(pc_sel),
        .alu_result(alu_result),

        .pc(pc),
        .pc_prev_1(pc_prev_1),
        .pc_prev_2(pc_prev_2)
    );

    alu alu_0(
        .src1(alu_src1),
        .src2(alu_src2),
        .op_sel(alu_op_sel),
        .result(alu_result)
    );

    reg stop;
    reg [31:0] pc_debug, addra_debug, inst_debug;
    reg pc_sel_debug;
    always @(posedge clk) begin
        if (core_reset) begin
            stop <= 1'b0;
        end else if (inst != 32'h0) begin
            if (stop == 1'b0) begin
                pc_debug <= pc; // save the pc when we first meet an illegal instruction
                pc_sel_debug <= pc_sel;
                addra_debug <= addra;
                inst_debug <= inst;
            end
            stop <= 1'b1;
        end
    end

    // assign leds_l = pc[7:0];

    // assign leds_l[7] = stop;
    // assign leds_l[6:0] = inst_debug[6:0];
    // assign leds_r = {pc_sel_debug, pc_debug[5:0], core_mode};
    assign I_read = inst_debug;

endmodule
