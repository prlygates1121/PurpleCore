`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2025 02:07:39 PM
// Design Name: 
// Module Name: alu
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
`include "params.v"

module alu(
    input [31:0] src1,
    input [31:0] src2,
    input [3:0] op_sel,
    output reg [31:0] result
    );

    wire [63:0] product_ss;
    wire [31:0] product_hsu, product_huu;

    always @(*) begin
        case (op_sel)
            `ADD:       result = (src1 + src2);
            `SUB:       result = (src1 - src2);
            `XOR:       result = (src1 ^ src2);
            `OR:        result = (src1 | src2);
            `AND:       result = (src1 & src2);
            `SLL:       result = (src1 << src2);
            `SRL:       result = (src1 >> src2);
            `SRA:       result = ($signed(src1) >>> src2);
            `SLT:       result = ($signed(src1) < $signed(src2));
            `SLTU:      result = (src1 < src2);
            `MUL:       result = product_ss[31:0];
            `MULH:      result = product_ss[63:32];
            `MULSU:     result = product_hsu;
            `MULU:      result = product_huu;
            `BSEL:      result = (src2);
            default:    result = 32'h0;
        endcase
    end

    mult_s_s mult_s_s_0(
        .A(src1),
        .B(src2),
        .P(product_ss)
    );

    mult_s_u mult_s_u_0(
        .A(src1),
        .B(src2),
        .P(product_hsu)
    );

    mult_u_u mult_u_u_0(
        .A(src1),
        .B(src2),
        .P(product_huu)
    );

endmodule