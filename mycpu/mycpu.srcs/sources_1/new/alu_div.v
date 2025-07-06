`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/03/2025 10:43:51 PM
// Design Name: 
// Module Name: alu_div
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


module alu_div(
    input               clk,
    input [31:0]        src1,
    input [31:0]        src2,
    input [2:0]         op_sel,
    output reg [31:0]   result
    );

    wire [31:0] quotient_s, remainder_s;
    wire [31:0] quotient_u, remainder_u;

    always @(*) begin
        case (op_sel)
            `DIV:       result = quotient_s;
            `DIVU:      result = quotient_u;
            `REM:       result = remainder_s;
            `REMU:      result = remainder_u;
            default:    result = 32'h0;
        endcase
    end

    div_s div_s_0 (
        .aclk                           (clk),
        .s_axis_divisor_tvalid          (1'b1),
        .s_axis_divisor_tdata           (src2),
        .s_axis_dividend_tvalid         (1'b1),
        .s_axis_dividend_tdata          (src1),
        .m_axis_dout_tdata              ({quotient_s, remainder_s})
    );

endmodule
