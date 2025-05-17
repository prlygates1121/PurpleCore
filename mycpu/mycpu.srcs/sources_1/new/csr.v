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

    input [31:0] w_mstatus,
    input [31:0] w_mie,
    input [31:0] w_mtvec,
    input [31:0] w_mepc,
    input [31:0] w_mcause,
    input [31:0] w_mtval,
    input [31:0] w_mip,

    output [31:0] r_mstatus,
    output [31:0] r_mie,
    output [31:0] r_mtvec,
    output [31:0] r_mepc,
    output [31:0] r_mcause,
    output [31:0] r_mtval,
    output [31:0] r_mip
    );

    reg [31:0] mstatus;
    reg [31:0] mie;
    reg [31:0] mtvec;
    reg [31:0] mepc;
    reg [31:0] mcause;
    reg [31:0] mtval;
    reg [31:0] mip;

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
        end else begin
            if (w_mstatus != `CSR_NO_WRITE) mstatus <= w_mstatus;
            if (w_mie     != `CSR_NO_WRITE) mie     <= w_mie    ;
            if (w_mtvec   != `CSR_NO_WRITE) mtvec   <= w_mtvec  ;
            if (w_mepc    != `CSR_NO_WRITE) mepc    <= w_mepc   ;
            if (w_mcause  != `CSR_NO_WRITE) mcause  <= w_mcause ;
            if (w_mtval   != `CSR_NO_WRITE) mtval   <= w_mtval  ;
            if (w_mip     != `CSR_NO_WRITE) mip     <= w_mip    ;
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
            default:    csr_r_data = 32'h0;
        endcase
    end

    assign r_mstatus = mstatus;
    assign r_mie     = mie;
    assign r_mtvec   = mtvec;
    assign r_mepc    = mepc;
    assign r_mcause  = mcause;
    assign r_mtval   = mtval;
    assign r_mip     = mip;
endmodule
