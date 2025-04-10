`timescale 1ns / 1ps
`include "params.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2025 10:29:22 PM
// Design Name: 
// Module Name: keyboard
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


module keyboard(
    output debug_shift,
    output [7:0] debug_scan_code,

    input clk,
    input reset,
    input ps2_clk,
    input ps2_data,
    output reg [7:0] key_code
    );

    // WARNING: wider filter means greater resilience to key noise, but it also results in lower senitivity (cannot handle bursts of input)
    localparam FILTER_WIDTH = 5;

    // filters used to stablize the clock signal from keyboard
    reg [FILTER_WIDTH-1:0] ps2_clk_filter;
    wire [FILTER_WIDTH-1:0] ps2_clk_filter_next;

    // the stablized keyboard clock signal
    reg ps2_clk_val;
    wire ps2_clk_val_next;

    // indicates a negedge of keyboard clock signal
    wire ps2_negedge;

    // samples (shifts in) ps2_clk consecutively
    assign ps2_clk_filter_next = {ps2_clk, ps2_clk_filter_next[FILTER_WIDTH-1:1]};

    // changes only when ps2_clk_filter is all 1s or all 0s (consecutive high or low signals are sampled)
    assign ps2_clk_val_next = (&ps2_clk_filter) ? 1'b1 :
                                (~(|ps2_clk_filter)) ? 1'b0 :
                                ps2_clk_val;

    assign ps2_negedge = ps2_clk_val & ~ps2_clk_val_next;

    always @(posedge clk) begin
        if (reset) begin
            ps2_clk_filter <= 0;
            ps2_clk_val <= 1'b0;
        end else begin
            ps2_clk_filter <= ps2_clk_filter_next;
            ps2_clk_val <= ps2_clk_val_next;
        end
    end

    // FSM
    localparam IDLE = 1'b0, RX = 1'b1;
    reg state, next_state;

    reg [3:0] num;
    reg [3:0] num_next;

    reg [10:0] rx_buffer;
    reg [10:0] rx_buffer_next;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            num <= 4'b0;
            rx_buffer <= 11'b0;
        end else begin
            state <= next_state;
            num <= num_next;
            rx_buffer <= rx_buffer_next;
        end
    end

    reg done;
    always @(*) begin
        next_state = state;
        num_next = num;
        rx_buffer_next = rx_buffer;
        done = 1'b0;
        case (state)
            IDLE:
                // Transition to RX state on falling edge of ps2_clk
                // Initialize num to 10 (8 data bits + start + stop bits)
                if (ps2_negedge) begin
                    next_state = RX;
                    num_next = 4'd10;
                end
            RX: begin
                // Shift in data on falling edge of ps2_clk
                // Decrement num
                if (ps2_negedge) begin
                    rx_buffer_next = {ps2_data, rx_buffer_next[10:1]};
                    num_next = num - 1;
                end
                // If num is 0, transition to IDLE state and set done signal
                // done is asserted every time an 11-bit frame (8-bit data) is received
                if (num == 0) begin
                    next_state = IDLE;
                    done = 1'b1;
                end
            end
        endcase
    end

    reg [7:0] scan_code, scan_code_prev;
    reg break_now;
    reg caps;
    always @(posedge clk) begin
        if (reset) begin
            scan_code <= 8'b0;
            scan_code_prev <= 8'b0;
            break_now <= 1'b0;
            caps <= 1'b0;
        end else if (done) begin
            scan_code <= ((rx_buffer[8:1] == scan_code_prev) & break_now) ? `NONE_SCAN : rx_buffer[8:1];
            scan_code_prev <= scan_code;
            break_now <= (rx_buffer[8:1] == `BREAK_SCAN);
            caps <= ((rx_buffer[8:1] == `CAPS_SCAN) & break_now) ? ~caps : caps;
        end
    end
    assign debug_shift = caps;
    assign debug_scan_code = scan_code;

    always @(*) begin
        case (scan_code)
            `ZERO_SCAN	        : key_code <= caps ? `R_PARENTHESIS  : `ZERO ;
            `ONE_SCAN	        : key_code <= caps ? `EXCLAMATION    : `ONE  ;
            `TWO_SCAN	        : key_code <= caps ? `AT             : `TWO  ;
            `THREE_SCAN	        : key_code <= caps ? `HASH           : `THREE;
            `FOUR_SCAN	        : key_code <= caps ? `DOLLAR         : `FOUR ;
            `FIVE_SCAN	        : key_code <= caps ? `PERCENT        : `FIVE ;
            `SIX_SCAN	        : key_code <= caps ? `CARET          : `SIX  ;
            `SEVEN_SCAN	        : key_code <= caps ? `AMPERSAND      : `SEVEN;
            `EIGHT_SCAN	        : key_code <= caps ? `ASTERISK       : `EIGHT;
            `NINE_SCAN	        : key_code <= caps ? `L_PARENTHESIS  : `NINE ;
            `A_SCAN             : key_code <= caps ? `A              : `a;
            `B_SCAN             : key_code <= caps ? `B              : `b;
            `C_SCAN             : key_code <= caps ? `C              : `c;
            `D_SCAN             : key_code <= caps ? `D              : `d;
            `E_SCAN             : key_code <= caps ? `E              : `e;
            `F_SCAN             : key_code <= caps ? `F              : `f;
            `G_SCAN             : key_code <= caps ? `G              : `g;
            `H_SCAN             : key_code <= caps ? `H              : `h;
            `I_SCAN             : key_code <= caps ? `I              : `i;
            `J_SCAN             : key_code <= caps ? `J              : `j;
            `K_SCAN             : key_code <= caps ? `K              : `k;
            `L_SCAN             : key_code <= caps ? `L              : `l;
            `M_SCAN             : key_code <= caps ? `M              : `m;
            `N_SCAN             : key_code <= caps ? `N              : `n;
            `O_SCAN             : key_code <= caps ? `O              : `o;
            `P_SCAN             : key_code <= caps ? `P              : `p;
            `Q_SCAN             : key_code <= caps ? `Q              : `q;
            `R_SCAN             : key_code <= caps ? `R              : `r;
            `S_SCAN             : key_code <= caps ? `S              : `s;
            `T_SCAN             : key_code <= caps ? `T              : `t;
            `U_SCAN             : key_code <= caps ? `U              : `u;
            `V_SCAN             : key_code <= caps ? `V              : `v;
            `W_SCAN             : key_code <= caps ? `W              : `w;
            `X_SCAN             : key_code <= caps ? `X              : `x;
            `Y_SCAN             : key_code <= caps ? `Y              : `y;
            `Z_SCAN             : key_code <= caps ? `Z              : `z;
            `L_BRACKET_SCAN     : key_code <= caps ? `L_BRACE        : `L_BRACKET;
            `R_BRACKET_SCAN     : key_code <= caps ? `R_BRACE        : `R_BRACKET;
            `SEMICOLON_SCAN     : key_code <= caps ? `COLON          : `SEMICOLON;
            `APOSTROPHE_SCAN    : key_code <= caps ? `QUOTE          : `APOSTROPHE;
            `COMMA_SCAN         : key_code <= caps ? `LESS           : `COMMA;
            `PERIOD_SCAN        : key_code <= caps ? `GREATER        : `PERIOD;
            `BACKSLASH_SCAN     : key_code <= caps ? `QUESTION       : `BACKSLASH;
            `SPACE_SCAN         : key_code <= `SPACE;
            `CAPS_SCAN          : key_code <= `CAPS;
            default             : key_code <= `NONE_SCAN;
        endcase
    end

endmodule
