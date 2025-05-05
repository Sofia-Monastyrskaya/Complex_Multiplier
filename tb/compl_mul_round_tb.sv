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
    compl_mul_round dut (
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
        
        // Test 1
        #10;
        data_a_i_i = 18'sh0_0001; 
        data_a_q_i = 18'sh0_0000; 
        data_b_i_i = 18'sh1_0000; 
        data_b_q_i = 18'sh0_0000; 
        #10;
        $display("Test 1: (-1-j1)*(-1-j1) = %d + j%d", data_i_o, data_q_o);
        
        // Test 2
        #10;
        data_a_i_i = 18'sh0_0001; 
        data_a_q_i = 18'sh0_0001; 
        data_b_i_i = 18'sh1_0000; 
        data_b_q_i = 18'sh1_0000; 
        #10;
        $display("Test 2: (-1-j1)*(-1-j1) = %d + j%d", data_i_o, data_q_o);
        
        // Test 3
        #10;
        data_a_i_i = 18'sh0_0018; 
        data_a_q_i = 18'sh0_0000; 
        data_b_i_i = 18'sh1_5000; 
        data_b_q_i = 18'sh0_0000; 
        #10;
        $display("Test 3: (-1-j1)*(-1-j1) = %d + j%d", data_i_o, data_q_o);
        
        // Test 4
        #10;
        data_a_i_i = 18'sh2_0018; 
        data_a_q_i = 18'sh0_0000; 
        data_b_i_i = 18'sh1_5000; 
        data_b_q_i = 18'sh0_0000; 
        #10;
        $display("Test 4: (0.5+j0.5)*(0.5+j0.5) = %d + j%d", data_i_o, data_q_o);
        
        // Test 5
        #10;
        data_a_i_i = 18'sh0_0018; 
        data_a_q_i = 18'sh0_0000; 
        data_b_i_i = 18'sh3_5000; 
        data_b_q_i = 18'sh0_0000; 
        #10;
        $display("Test 5: Rounding test = %d + j%d", data_i_o, data_q_o);
        
        // Test 6
        #10;
        data_a_i_i = 18'shF_FFFF; 
        data_a_q_i = 18'shA_AAAA; 
        data_b_i_i = 18'sh3_5000; 
        data_b_q_i = 18'sh1_8000; 
        #10;
        $display("Test 6: Max values = %d + j%d", data_i_o, data_q_o);

        // Test 7
        #10;
        data_a_i_i = 18'sh1_FFFF; 
        data_a_q_i = 18'sh0_0000; 
        data_b_i_i = 18'sh1_FFFF; 
        data_b_q_i = 18'sh0_0000; 
        #10;
        $display("Test 7: Max values = %d + j%d", data_i_o, data_q_o);
        
        // Test Case 8
        #10;
        srst_i = 1;
        #10;
        $display("Test 8: After reset = %d + j%d", data_i_o, data_q_o);
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
