// predefined values
`define ADDR_SP_START 32'h0001FFFC
`define NOP 32'h00000013

// alu_sel [3:0]
`define ADD  4'd0
`define SUB  4'd1
`define XOR  4'd2
`define OR   4'd3
`define AND  4'd4
`define SLL  4'd5
`define SRL  4'd6
`define SRA  4'd7
`define SLT  4'd8
`define SLTU 4'd9
`define MUL  4'd10
`define MULH 4'd11
`define MULU 4'd12
`define BSEL 4'd13

// imm_sel [2:0]
`define IMM_I_SHIFT 3'h0
`define IMM_I       3'h1
`define IMM_S       3'h2
`define IMM_B       3'h3
`define IMM_U       3'h4
`define IMM_J       3'h5

// branch_type [2:0]
`define BEQ 3'h0
`define BNE 3'h1
`define BLT 3'h4
`define BGE 3'h5
`define BLTU 3'h6
`define BGEU 3'h7
`define NO_BRANCH 3'h2