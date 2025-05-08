`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2025 04:54:05 PM
// Design Name: 
// Module Name: csr
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


module csr(
    input clk,
    input reset,
    input csr_w_en,
    input [31:0] csr_w_data,
    input [11:0] csr_w_addr,
    input [11:0] csr_r_addr,
    output reg [31:0] csr_r_data,

    output reg [31:0] mstatus,
    output reg [31:0] mie,
    output reg [31:0] mtvec,
    output reg [31:0] mepc,
    output reg [31:0] mcause,
    output reg [31:0] mtval,
    output reg [31:0] mip
    );

    always @(negedge clk) begin
        if (reset) begin
            mstatus <= 32'h0;
            mie     <= 32'h0;
            mtvec   <= 32'h0;
            mepc    <= 32'h0;
            mcause  <= 32'h0;
            mtval   <= 32'h0;
            mip     <= 32'h0;
        end else if (csr_w_en) begin
            case (csr_w_addr)
                `MSTATUS:   mstatus <= csr_w_data;
                `MIE    :   mie     <= csr_w_data;
                `MTVEC  :   mtvec   <= csr_w_data;
                `MEPC   :   mepc    <= csr_w_data;
                `MCAUSE :   mcause  <= csr_w_data;
                `MTVAL  :   mtval   <= csr_w_data;
                `MIP    :   mip     <= csr_w_data;
            endcase
        end
    end

    always @(*) begin
        case (csr_r_addr)
            `MSTATUS:   csr_r_data = mstatus;
            `MIE    :   csr_r_data = mie    ;
            `MTVEC  :   csr_r_data = mtvec  ;
            `MEPC   :   csr_r_data = mepc   ;
            `MCAUSE :   csr_r_data = mcause ;
            `MTVAL  :   csr_r_data = mtval  ;
            `MIP    :   csr_r_data = mip    ;
        endcase
    end
endmodule
