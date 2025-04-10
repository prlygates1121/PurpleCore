`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 09:31:33 PM
// Design Name: 
// Module Name: keyboard_tb
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


module keyboard_tb(

    );
    reg clk;
    reg reset;
    reg ps2_clk;
    reg ps2_data;
    wire debug_shift;
    wire [7:0] debug_scan_code;
    wire [7:0] key_code;
    keyboard u_keyboard (
        .debug_shift        (debug_shift),
        .debug_scan_code    (debug_scan_code),
        .clk                (clk),
        .reset              (reset),
        .ps2_clk            (ps2_clk),
        .ps2_data           (ps2_data),
        .key_code           (key_code)
    );
    
    // Clock generation (100MHz typical FPGA clock)
    always #5 clk = ~clk;
    
    // PS2 clock generation (approx 10-16.7 kHz)
    reg ps2_clk_en;
    always @(posedge clk) begin
        if (ps2_clk_en)
            ps2_clk <= #500 ~ps2_clk;
    end
    
    // Task to send a PS2 scancode
    task send_scancode;
        input [7:0] code;
        integer i;
        reg parity;
        begin
            parity = 1'b1;  // Odd parity
            
            // Start bit (always 0)
            ps2_data = 1'b0;
            @(negedge ps2_clk);
            
            // 8 data bits, LSB first
            for (i = 0; i < 8; i = i + 1) begin
                ps2_data = code[i];
                parity = parity ^ code[i];
                @(negedge ps2_clk);
            end
            
            // Parity bit (odd parity)
            ps2_data = parity;
            @(negedge ps2_clk);
            
            // Stop bit (always 1)
            ps2_data = 1'b1;
            @(negedge ps2_clk);
            
            // Idle state
            #1000;
        end
    endtask
    
    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        ps2_clk = 1;
        ps2_data = 1;
        ps2_clk_en = 0;
        
        // Reset sequence
        #100 reset = 0;
        #100 reset = 1;
        #100 reset = 0;
        
        // Wait for system to stabilize
        #1000;
        
        // Enable PS2 clock
        ps2_clk_en = 1;
        #1000;
        
        // Test key press and release sequences
        
        // Press 'A' (scan code 0x1C)
        send_scancode(8'h1C);
        
        // Release 'A' (0xF0 followed by 0x1C)
        send_scancode(8'hF0);
        send_scancode(8'h1C);
        
        // Press and release numeric key '1' (scan code 0x16)
        send_scancode(8'h16);
        send_scancode(8'hF0);
        send_scancode(8'h16);
        
        // Press Shift (scan code 0x12)
        send_scancode(8'h12);
        
        // Press 'A' while Shift is down (should produce capital A)
        send_scancode(8'h1C);
        
        // Release 'A'
        send_scancode(8'hF0);
        send_scancode(8'h1C);
        
        // Release Shift
        send_scancode(8'hF0);
        send_scancode(8'h12);
        
        // Finish simulation
        ps2_clk_en = 0;
        #5000;
        $display("Keyboard test completed");
        $finish;
    end
    
    // Monitor outputs
    initial begin
        $monitor("Time=%0t, key_code=%h, debug_shift=%b, debug_scan_code=%h", 
                 $time, key_code, debug_shift, debug_scan_code);
    end
endmodule
