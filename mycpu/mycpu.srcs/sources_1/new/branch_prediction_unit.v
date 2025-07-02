`timescale 1ns / 1ps
`include "params.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2025 10:14:54 PM
// Design Name: 
// Module Name: branch_prediction_unit
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


module branch_prediction_unit(
    input           clk,
    input           reset,
    input           stall,
    
    input [31:0]    IF_pc,
    input [31:0]    IF_inst,
    input [31:0]    EX_pc,
    input [31:0]    EX_alu_result,
    input           EX_jal,
    input           EX_jalr,
    input [2:0]     EX_branch_type,
    input           EX_pc_sel,

    output          branch_predict,
    output [31:0]   branch_target,
    output          EX_false_target,
    output          EX_false_direction,
    output          EX_branch_flush
    );
    integer i;

    localparam PREDICTOR_DEPTH_LOG = 7;
    localparam BRANCH_HISTORY_SELECTED_BITS = 4;

    localparam [1:0] STRONG_TAKEN       = 2'b11, 
                     WEAK_TAKEN         = 2'b10,
                     WEAK_NOT_TAKEN     = 2'b01,
                     STRONG_NOT_TAKEN   = 2'b00;

    wire EX_is_branch_inst = EX_jal | EX_jalr | (EX_branch_type != `NO_BRANCH);

    reg ID_branch_predict, EX_branch_predict;
    reg [31:0] branch_target_prev_1, branch_target_prev_2;

    wire [31:0] RAS_out;
    reg [31:0] RAS_in;
    reg [1:0] RAS_op;

    // pre-decode the instruction
    wire [6:0] opcode = IF_inst[6:0];
    wire [2:0] funct3 = IF_inst[14:12];

    wire [4:0] IF_rd  = IF_inst[11:7];
    wire [4:0] IF_rs1 = IF_inst[19:15];
    wire IF_B      = opcode == 7'b1100011;
    wire IF_jal    = opcode == 7'b1101111;
    wire IF_jalr   = opcode == 7'b1100111 & funct3 == 3'h0;

    // detect call and return instructions (see unprivileged RISC-V spec "2.5. Control Transfer Instructions" at page 29)
    wire IF_call = (IF_jal & (IF_rd == 5'h1 | IF_rd == 5'h5)) |
                (IF_jalr & (IF_rd == 5'h1 | IF_rd == 5'h5) & 
                ((IF_rs1 != 5'h1 & IF_rs1 != 5'h5) | (IF_rs1 == 5'h1 | IF_rs1 == 5'h5) & (IF_rd == IF_rs1)));
    wire IF_return =  (IF_jalr & (IF_rd != 5'h1 & IF_rd != 5'h5) & 
                (IF_rs1 == 5'h1 | IF_rs1 == 5'h1));
    // wire IF_return_and_call = (IF_jalr & (IF_rd == 5'h1 | IF_rd == 5'h5) & (IF_rs1 == 5'h1 | IF_rs1 == 5'h5) & (IF_rd != IF_rs1));

    reg ID_call, ID_return;
    reg [31:0] ID_RAS_out;

    reg EX_call, EX_return;
    reg [31:0] EX_RAS_out;

    // Branch Prediction Table (BPT) and Branch Target Buffer (BTB)
    reg [1:0]                       prediction_table     [(1 << PREDICTOR_DEPTH_LOG)-1:0];
    reg [31:0]                      branch_target_buffer [(1 << PREDICTOR_DEPTH_LOG)-1:0];
    reg [PREDICTOR_DEPTH_LOG-1:0]   branch_history_local [(1 << PREDICTOR_DEPTH_LOG)-1:0];
    reg [PREDICTOR_DEPTH_LOG-1:0]   branch_history;
    wire [PREDICTOR_DEPTH_LOG-1:0]  IF_prediction_index;
    reg [PREDICTOR_DEPTH_LOG-1:0]   prediction_index_prev_1, prediction_index_prev_2;

    reg branch_predict_prev_1, branch_predict_prev_2;

    // always @(posedge clk) begin
    //     if (reset) begin
    //         IF_prediction_index <= 0;
    //     end else begin
    //         /* Index with PC only */
    //         // IF_prediction_index <= IF_pc[2+:PREDICTOR_DEPTH_LOG];

    //         /* Index with concatenation of global branch history and PC*/
    //         IF_prediction_index <= {IF_pc[2+:PREDICTOR_DEPTH_LOG-BRANCH_HISTORY_SELECTED_BITS], branch_history[0+:BRANCH_HISTORY_SELECTED_BITS]};
            
    //         /* Index with XOR of global branch history and PC (gshare) */
    //         // IF_prediction_index <= branch_history ^ IF_pc[2+:PREDICTOR_DEPTH_LOG];

    //         /* Index with concatenation of local branch history and PC */
    //         // IF_prediction_index <= {IF_pc[2+:PREDICTOR_DEPTH_LOG-BRANCH_HISTORY_SELECTED_BITS], 
    //         //                         branch_history_local[IF_pc[2+:PREDICTOR_DEPTH_LOG]][0+:BRANCH_HISTORY_SELECTED_BITS]};
    //     end
    // end

    assign IF_prediction_index = {IF_pc[2+:PREDICTOR_DEPTH_LOG-BRANCH_HISTORY_SELECTED_BITS], branch_history[0+:BRANCH_HISTORY_SELECTED_BITS]};

    always @(posedge clk) begin
        if (reset) begin
            branch_history <= 0;
        end else begin
            if (EX_is_branch_inst) begin
                branch_history <= {branch_history[PREDICTOR_DEPTH_LOG-2:0], EX_pc_sel};
            end
        end
    end

    // always @(posedge clk) begin
    //     if (reset) begin
    //         for (i = 0; i < (1 << PREDICTOR_DEPTH_LOG); i = i + 1) begin
    //             branch_history_local[i] <= 0;
    //         end
    //     end else begin
    //         if (EX_is_branch_inst) begin
    //             branch_history_local[EX_pc[2+:PREDICTOR_DEPTH_LOG]] <= {branch_history_local[EX_pc[2+:PREDICTOR_DEPTH_LOG]], EX_pc_sel};
    //         end
    //     end
    // end

    always @(posedge clk) begin
        if (reset) begin
            ID_call     <= 1'b0;  
            EX_call     <= 1'b0;
            ID_return   <= 1'b0;    
            EX_return   <= 1'b0;
            ID_RAS_out  <= 32'h0;      
            EX_RAS_out  <= 32'h0;
        end else begin
            ID_call     <= IF_call;
            EX_call     <= ID_call;
            ID_return   <= IF_return;
            EX_return   <= ID_return;
            ID_RAS_out  <= RAS_out;
            EX_RAS_out  <= ID_RAS_out;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            prediction_index_prev_1 <= 0;           
            prediction_index_prev_2 <= 0;
        end else if (~stall) begin
            prediction_index_prev_1 <= IF_prediction_index;
            prediction_index_prev_2 <= prediction_index_prev_1;
        end
    end

    always @(*) begin
        if (IF_call & ~EX_branch_flush) begin
            RAS_in = IF_pc + 4;
        end else begin
            RAS_in = 32'h0;
        end
    end

    always @(*) begin
        if (EX_branch_flush) begin
            // if a branch flush is needed, restore RAS to previous state
            if (ID_call) begin
                // if a call was speculatively fetched, pop the mistakenly pushed address
                RAS_op = `RING_POP;
            end else if (ID_return) begin
                // if a return was speculatively fetched, restore the mistakenly popped address by incrementing the RAS pointer
                RAS_op = `RING_CANCEL_POP;
            end else begin
                // if the RAS was never changed, do nothing
                RAS_op = `RING_NOOP;
            end
        end else begin
            // otherwise, update the RAS according to recently fetched inst, as normal
            if (IF_call) begin
                // if a call is fetched, push the return address to RAS
                RAS_op = `RING_PUSH;
            end else if (IF_return) begin
                // if a call is fetched, pop a return address out of RAS
                RAS_op = `RING_POP;
            end else begin
                // otherwise, do nothing
                RAS_op = `RING_NOOP;
            end
        end
    end

    wire [PREDICTOR_DEPTH_LOG-1:0] prediction_index_update = prediction_index_prev_2;
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < (1 << PREDICTOR_DEPTH_LOG); i = i + 1) begin
                prediction_table[i] <= WEAK_NOT_TAKEN;
            end
        end else begin
            if (EX_is_branch_inst) begin
                if (~EX_call & ~EX_return) begin
                    // we do not update BPT for:
                    //      1. instructions that are neither jumps nor branches
                    //      2. calls and returns (as they are always predicted to be taken), thus saving up BPT entries for other instructions
                    if (EX_pc_sel) begin
                        if (prediction_table[prediction_index_update] != STRONG_TAKEN) begin
                            prediction_table[prediction_index_update] <= prediction_table[prediction_index_update] + 1;
                        end
                    end else begin
                        if (prediction_table[prediction_index_update] != STRONG_NOT_TAKEN) begin
                            prediction_table[prediction_index_update] <= prediction_table[prediction_index_update] - 1;
                        end
                    end
                end
            end 
        end
    end

    // unlike BPT, BTB is only indexed by lower bits of PC, regardless of the branch history,
    //      because branch target is solely determined by the address of a branch (the instruction itself), not the branch history
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < (1 << PREDICTOR_DEPTH_LOG); i = i + 1) begin
                branch_target_buffer[i] <= 32'b00;
            end
        end else if (EX_is_branch_inst & ~EX_return) begin
            // we do not update BTB for:
            //      1. instructions that are neither jumps nor branches
            //      2. returns (as the branch target for them are determined solely by RAS), thus saving up BTB entries for other instructions
            branch_target_buffer[EX_pc[2+:PREDICTOR_DEPTH_LOG]] <= EX_alu_result;
        end
    end

    // Latch the branch target previously used in prediction, to be compared in EX stage with the actual target.
    // Compared with using latched prediction index to reproduce the branch target from the BTH,
    //      latching the branch target directly eliminates the need to index into BTB, thus easing timing pressure.
    always @(posedge clk) begin
        if (reset) begin
            branch_target_prev_1 <= 32'h0;
            branch_target_prev_2 <= 32'h0;
        end else if (~stall) begin
            branch_target_prev_1 <= branch_target;
            branch_target_prev_2 <= branch_target_prev_1;
        end
    end

    ring #(
        .BIT_WIDTH      (32),
        .DEPTH          (8)
    ) RAS (
        .clk            (clk),
        .reset          (reset),
        .op             (RAS_op),
        .data_in        (RAS_in),
        .data_out       (RAS_out)
    );

    always @(posedge clk) begin
        if (reset) begin
            ID_branch_predict <= 1'b0;
            EX_branch_predict <= 1'b0;
        end else if (~stall) begin
            ID_branch_predict <= branch_predict;
            EX_branch_predict <= ID_branch_predict;
        end
    end
    
    assign branch_predict       = (IF_jal | IF_jalr) ? 1'b1 : 
                                                IF_B ? (prediction_table[IF_prediction_index] >= WEAK_TAKEN) : 
                                                       1'b0;

    assign branch_target        = IF_return ? RAS_out : branch_target_buffer[IF_pc[2+:PREDICTOR_DEPTH_LOG]];

    assign EX_false_direction   = EX_is_branch_inst ? (EX_branch_predict != EX_pc_sel) : 1'b0;

    assign EX_false_target      = EX_is_branch_inst & EX_branch_predict & (ID_return ? (EX_RAS_out != EX_alu_result) : 
                                                                                       (branch_target_prev_2 != EX_alu_result));
                                                                             
    assign EX_branch_flush      = EX_false_direction | (EX_false_target & EX_branch_predict);  

endmodule
