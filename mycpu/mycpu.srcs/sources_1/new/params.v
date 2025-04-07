
`define ADDR_SP_START           32'h0000_BFFC
`define ADDR_MMIO_BASE          32'h8000_0000
`define ADDR_MMIO_SYS_INFO      32'h0000_0000
`define ADDR_MMIO_LED           32'h0010_0000
`define ADDR_MMIO_SW            32'h0020_0000
`define ADDR_MMIO_VGA           32'h0030_0000
`define ADDR_MMIO_ASCII         32'h0040_0000

// Instruction parameters
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

// VGA parameters

// Horizontal
// Active:          0 --------- 639 (640)
// Front Porch:     640 ------- 655 (16)
// Sync:            656 ------- 751 (96)
// Back Porch:      752 ------- 799 (48)
`define H_ACTIVE_END  639
`define H_SYNC_START  `H_ACTIVE_END + 17
`define H_SYNC_END    `H_SYNC_START + 95
`define H_END         799

// Vertical
`define V_ACTIVE_END  479
`define V_SYNC_START  `V_ACTIVE_END + 11
`define V_SYNC_END    `V_SYNC_START + 1
`define V_END         524

// VGA color codes
`define BLACK_CODE              4'b0000
`define WHITE_CODE              4'b0001
`define RED_CODE                4'b0010
`define ORANGE_CODE             4'b0011
`define YELLOW_CODE             4'b0100
`define LIGHT_GREEN_CODE        4'b0101
`define GREEN_CODE              4'b0110
`define SPRING_GREEN_CODE       4'b0111
`define CYAN_CODE               4'b1000
`define SKY_BLUE_CODE           4'b1001
`define BLUE_CODE               4'b1010
`define PURPLE_CODE             4'b1011
`define PINK_CODE               4'b1100
`define ROSE_CODE               4'b1101
`define SUPERNOVA_CODE          4'b1110
`define GRAY_CODE               4'b1111

// VGA color values
`define BLACK_VALUE             12'h000
`define WHITE_VALUE             12'hFFF
`define RED_VALUE               12'hF00
`define ORANGE_VALUE            12'hF80
`define YELLOW_VALUE            12'hFF0
`define LIGHT_GREEN_VALUE       12'h8F0
`define GREEN_VALUE             12'h0F0
`define SPRING_GREEN_VALUE      12'h0F8
`define CYAN_VALUE              12'h0FF
`define SKY_BLUE_VALUE          12'h08F
`define BLUE_VALUE              12'h00F
`define PURPLE_VALUE            12'h08F
`define PINK_VALUE              12'hF0F
`define ROSE_VALUE              12'hF08
`define SUPERNOVA_VALUE         12'hFC0
`define GRAY_VALUE              12'h888