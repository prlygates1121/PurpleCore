// `define SIMULATION
`define BRANCH_PREDICT_ENA

`define ADDR_SP_START           32'h0000_BFFC
`define ADDR_MMIO_BASE          32'h8000_0000
`define ADDR_MMIO_SYS_INFO      32'h0000_0000
`define ADDR_MMIO_ASCII         32'h0010_0000
`define ADDR_MMIO_LED           32'h0020_0000
`define ADDR_MMIO_SW            32'h0030_0000
`define ADDR_MMIO_VGA           32'h0040_0000
`define ADDR_MMIO_KEYBOARD      32'h0050_0000
`define ADDR_MMIO_BUTTON        32'h0060_0000
`define ADDR_MMIO_SEG_DISPLAY   32'h0070_0000
`define ADDR_MMIO_UART          32'h0080_0000

// Frequencies
`define CLK_100_FREQ            32'd100_000_000
`define CLK_MAIN_FREQ           32'd40_000_000
`ifdef SIMULATION
    `define UART_FREQ               32'd2_000_000
`else
    `define UART_FREQ               32'd460800
`endif

// Instruction parameters
`define NOP                     32'h00000013

// alu_sel [3:0]
`define ADD                     4'd0
`define SUB                     4'd1
`define XOR                     4'd2
`define OR                      4'd3
`define AND                     4'd4
`define SLL                     4'd5
`define SRL                     4'd6
`define SRA                     4'd7
`define SLT                     4'd8
`define SLTU                    4'd9
`define MUL                     4'd10
`define MULH                    4'd11
`define MULU                    4'd12
`define BSEL                    4'd13

// imm_sel [2:0]
`define IMM_I_SHIFT             3'h0
`define IMM_I                   3'h1
`define IMM_S                   3'h2
`define IMM_B                   3'h3
`define IMM_U                   3'h4
`define IMM_J                   3'h5
`define NO_IMM                  3'h6

// branch_type [2:0]
`define BEQ                     3'h0
`define BNE                     3'h1
`define BLT                     3'h4
`define BGE                     3'h5
`define BLTU                    3'h6
`define BGEU                    3'h7
`define NO_BRANCH               3'h2

// store_width [1:0]
`define STORE_BYTE              2'h0
`define STORE_HALF              2'h1
`define STORE_WORD              2'h2
`define NO_STORE                2'h3

// load_width [2:0]
`define LOAD_BYTE               3'h0
`define LOAD_HALF               3'h1
`define LOAD_WORD               3'h2
`define LOAD_BYTE_UN            3'h4
`define LOAD_HALF_UN            3'h5
`define NO_LOAD                 3'h3

// reg_w_data_sel [1:0]
`define REG_W_DATA_ALU          2'h0
`define REG_W_DATA_MEM          2'h1
`define REG_W_DATA_PC           2'h2
`define NO_REG_W_DATA           2'h3

// alu_src1_sel
`define ALU_SRC1_PC             1'b0
`define ALU_SRC1_RS1            1'b1

// alu_src2_sel
`define ALU_SRC2_IMM            1'b0
`define ALU_SRC2_RS2            1'b1

// forward_rs1_sel [1:0]
`define FORWARD_RS1_PREV        2'b01
`define FORWARD_RS1_PREV_PREV   2'b10
`define FORWARD_RS1_NONE        2'b00

// forward_rs2_sel [1:0]
`define FORWARD_RS2_PREV        2'b01
`define FORWARD_RS2_PREV_PREV   2'b10
`define FORWARD_RS2_NONE        2'b00

// ring buffer operation [1:0]
`define RING_PUSH               2'h0
`define RING_POP                2'h1
// `define RING_POP_AND_PUSH       2'h2
`define RING_CANCEL_POP         2'h2
`define RING_NOOP               2'h3

// buttons
`define BT_UP                   3'h0
`define BT_DOWN                 3'h1
`define BT_LEFT                 3'h2
`define BT_RIGHT                3'h3
`define BT_CENTER               3'h4

// VGA parameters

// Horizontal
// Active:          0 --------- 639 (640)
// Front Porch:     640 ------- 655 (16)
// Sync:            656 ------- 751 (96)
// Back Porch:      752 ------- 799 (48)
`define H_ACTIVE_END            639
`define H_SYNC_START            `H_ACTIVE_END + 17
`define H_SYNC_END              `H_SYNC_START + 95
`define H_END                   799

// Vertical
`define V_ACTIVE_END            479
`define V_SYNC_START            `V_ACTIVE_END + 11
`define V_SYNC_END              `V_SYNC_START + 1
`define V_END                   524

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

// ascii character index
`define SPACE                   8'd0
`define EXCLAMATION             8'd1
`define QUOTE                   8'd2
`define HASH                    8'd3
`define DOLLAR                  8'd4
`define PERCENT                 8'd5
`define AMPERSAND               8'd6
`define APOSTROPHE              8'd7
`define L_PARENTHESIS           8'd8
`define R_PARENTHESIS           8'd9
`define ASTERISK                8'd10
`define PLUS                    8'd11
`define COMMA                   8'd12
`define HYPHEN                  8'd13
`define PERIOD                  8'd14
`define SLASH                   8'd15
`define ZERO                    8'd16
`define ONE                     8'd17
`define TWO                     8'd18
`define THREE                   8'd19
`define FOUR                    8'd20
`define FIVE                    8'd21
`define SIX                     8'd22
`define SEVEN                   8'd23
`define EIGHT                   8'd24
`define NINE                    8'd25
`define COLON                   8'd26
`define SEMICOLON               8'd27
`define LESS                    8'd28
`define EQUAL                   8'd29
`define GREATER                 8'd30
`define QUESTION                8'd31
`define AT                      8'd32
`define A                       8'd33
`define B                       8'd34
`define C                       8'd35
`define D                       8'd36
`define E                       8'd37
`define F                       8'd38
`define G                       8'd39
`define H                       8'd40
`define I                       8'd41
`define J                       8'd42
`define K                       8'd43
`define L                       8'd44
`define M                       8'd45
`define N                       8'd46
`define O                       8'd47
`define P                       8'd48
`define Q                       8'd49
`define R                       8'd50
`define S                       8'd51
`define T                       8'd52
`define U                       8'd53
`define V                       8'd54
`define W                       8'd55
`define X                       8'd56
`define Y                       8'd57
`define Z                       8'd58
`define L_BRACKET               8'd59
`define BACKSLASH               8'd60
`define R_BRACKET               8'd61
`define CARET                   8'd62
`define UNDERSCORE              8'd63
`define BACKTICK                8'd64
`define a                       8'd65
`define b                       8'd66
`define c                       8'd67
`define d                       8'd68
`define e                       8'd69
`define f                       8'd70
`define g                       8'd71
`define h                       8'd72
`define i                       8'd73
`define j                       8'd74
`define k                       8'd75
`define l                       8'd76
`define m                       8'd77
`define n                       8'd78
`define o                       8'd79
`define p                       8'd80
`define q                       8'd81
`define r                       8'd82
`define s                       8'd83
`define t                       8'd84
`define u                       8'd85
`define v                       8'd86
`define w                       8'd87
`define x                       8'd88
`define y                       8'd89
`define z                       8'd90
`define L_BRACE                 8'd91
`define PIPE                    8'd92
`define R_BRACE                 8'd93
`define TILDE                   8'd94
`define DELETE                  8'd95
`define CAPS                    8'd96
`define BACKSPACE               8'd97

// keyboard scan codes
`define NONE_SCAN               8'hFF
`define BREAK_SCAN              8'hF0
`define A_SCAN	                8'h1C
`define B_SCAN	                8'h32
`define C_SCAN	                8'h21
`define D_SCAN	                8'h23
`define E_SCAN	                8'h24
`define F_SCAN	                8'h2B
`define G_SCAN	                8'h34
`define H_SCAN	                8'h33
`define I_SCAN	                8'h43
`define J_SCAN	                8'h3B
`define K_SCAN	                8'h42
`define L_SCAN	                8'h4B
`define M_SCAN	                8'h3A
`define N_SCAN	                8'h31
`define O_SCAN	                8'h44
`define P_SCAN	                8'h4D
`define Q_SCAN	                8'h15
`define R_SCAN	                8'h2D
`define S_SCAN	                8'h1B
`define T_SCAN	                8'h2C
`define U_SCAN	                8'h3C
`define V_SCAN	                8'h2A
`define W_SCAN	                8'h1D
`define X_SCAN	                8'h22
`define Y_SCAN	                8'h35
`define Z_SCAN	                8'h1A
`define ZERO_SCAN	            8'h45
`define ONE_SCAN	            8'h16
`define TWO_SCAN	            8'h1E
`define THREE_SCAN	            8'h26
`define FOUR_SCAN	            8'h25
`define FIVE_SCAN	            8'h2E
`define SIX_SCAN	            8'h36
`define SEVEN_SCAN	            8'h3D
`define EIGHT_SCAN	            8'h3E
`define NINE_SCAN	            8'h46
// `define `_scan	8'h0E
// `define -_scan	8'h4E
// `define =_scan	8'h55
// `define \_scan	8'h5D
`define BKSP_SCAN	            8'h66	 
`define SPACE_SCAN	            8'h29	 
`define TAB_SCAN	            8'h0D	 
`define CAPS_SCAN	            8'h14	 
`define L_SHFT_SCAN	            8'h12	 
// `define L_CTRL_SCAN	            8'h14	 
// `define L_GUI	E0,1F
`define L_ALT_SCAN	            8'h11	 
`define R_SHFT_SCAN	            8'h59	 
// `define R_CTRL	E0,14
// `define R_GUI	E0,27
`define L_BRACKET_SCAN          8'h54
`define R_BRACKET_SCAN          8'h5B
`define SEMICOLON_SCAN          8'h4C
`define APOSTROPHE_SCAN         8'h52
`define COMMA_SCAN              8'h41
`define PERIOD_SCAN             8'h49
`define BACKSLASH_SCAN          8'h4A
