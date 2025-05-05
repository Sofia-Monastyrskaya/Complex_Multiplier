`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2025 00:43:40
// Design Name: 
// Module Name: test_2_tb
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


module compl_mul_round_tb;

    // Inputs
    logic clk_i;
    logic srst_i;
    logic signed [17:0] data_a_i_i;
    logic signed [17:0] data_a_q_i;
    logic signed [17:0] data_b_i_i;
    logic signed [17:0] data_b_q_i;
    
    // Outputs
    logic signed [18:0] data_i_o;
    logic signed [18:0] data_q_o;
    
    // Instantiate the Unit Under Test (UUT)
    compl_mul_round uut (
        .clk_i(clk_i),
        .srst_i(srst_i),
        .data_a_i_i(data_a_i_i),
        .data_a_q_i(data_a_q_i),
        .data_b_i_i(data_b_i_i),
        .data_b_q_i(data_b_q_i),
        .data_i_o(data_i_o),
        .data_q_o(data_q_o)
    );
    
    // Clock generation
    always begin
        #5 clk_i = ~clk_i;
    end
    
    // Test cases
    initial begin
        // Initialize Inputs
        clk_i = 0;
        srst_i = 1;
        data_a_i_i = 0;
        data_a_q_i = 0;
        data_b_i_i = 0;
        data_b_q_i = 0;
        
        // Wait for global reset
        #20;
        srst_i = 0;
        
        // Test Case 1: Simple positive numbers (1 + j1) * (1 + j1) = 0 + j2
        #10;
        data_a_i_i = 18'h00001; // 1.0
        data_a_q_i = 18'h00001; // j1.0
        data_b_i_i = 18'h10000; // 1.0
        data_b_q_i = 18'h10000; // j1.0
        #10;
        $display("Test 1: (1+j1)*(1+j1) = %d + j%d", data_i_o, data_q_o);
        
        // Test Case 2: Mixed signs (1 + j1) * (1 - j1) = 2 + j0
        #10;
        data_a_i_i = 18'h10000; // 1.0
        data_a_q_i = 18'h10000; // j1.0
        data_b_i_i = 18'h10000; // 1.0
        data_b_q_i = 18'h1FFFF; // -j1.0 (two's complement)
        #10;
        $display("Test 2: (1+j1)*(1-j1) = %d + j%d", data_i_o, data_q_o);
        
        // Test Case 3: Negative numbers (-1 - j1) * (-1 - j1) = 0 + j2
        #10;
        data_a_i_i = 18'h1FFFF; // -1.0
        data_a_q_i = 18'h1FFFF; // -j1.0
        data_b_i_i = 18'h1FFFF; // -1.0
        data_b_q_i = 18'h1FFFF; // -j1.0
        #10;
        $display("Test 3: (-1-j1)*(-1-j1) = %d + j%d", data_i_o, data_q_o);
        
        // Test Case 4: Fractional numbers (0.5 + j0.5) * (0.5 + j0.5) = 0 + j0.5
        #10;
        data_a_i_i = 18'h08000; // 0.5
        data_a_q_i = 18'h08000; // j0.5
        data_b_i_i = 18'h08000; // 0.5
        data_b_q_i = 18'h08000; // j0.5
        #10;
        $display("Test 4: (0.5+j0.5)*(0.5+j0.5) = %d + j%d", data_i_o, data_q_o);
        
        // Test Case 5: Rounding test (0.5 + j0) * (0.0000152587890625 + j0) 
        // Should round up to 1 in the output (0x8000 * 0x0001 = 0x8000, which when rounded becomes 0x00001)
        #10;
        data_a_i_i = 18'h08000; // 0.5
        data_a_q_i = 18'h00000; // j0
        data_b_i_i = 18'h00001; // ~0.000015
        data_b_q_i = 18'h00000; // j0
        #10;
        $display("Test 5: Rounding test = %d + j%d", data_i_o, data_q_o);
        
        // Test Case 6: Maximum values (to test overflow handling)
        #10;
        data_a_i_i = 18'h17FFF; // ~0.99997
        data_a_q_i = 18'h17FFF; // j~0.99997
        data_b_i_i = 18'h17FFF; // ~0.99997
        data_b_q_i = 18'h17FFF; // j~0.99997
        #10;
        $display("Test 6: Max values = %d + j%d", data_i_o, data_q_o);
        
        // Test Case 7: Reset test
        #10;
        srst_i = 1;
        #10;
        $display("Test 7: After reset = %d + j%d", data_i_o, data_q_o);
        srst_i = 0;
        
        #20;
        $finish;
    end
    
    // Monitor changes
    initial begin
        $monitor("At time %t: a=%d+j%d, b=%d+j%d => out=%d+j%d",
            $time, data_a_i_i, data_a_q_i, data_b_i_i, data_b_q_i, data_i_o, data_q_o);
    end

endmodule
