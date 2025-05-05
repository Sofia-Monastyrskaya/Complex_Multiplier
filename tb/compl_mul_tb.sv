`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2025 16:57:39
// Design Name: 
// Module Name: compl_mul_tb
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


module compl_mul_tb;

/// Parameters
    localparam CLK_PERIOD = 10; // 10 ns = 100 MHz clock

    // Signals
    logic clk_i;
    logic srst_i;
    logic signed [17:0] data_a_i_i;
    logic signed [17:0] data_a_q_i;
    logic signed [17:0] data_b_i_i;
    logic signed [17:0] data_b_q_i;
    logic [36:0] data_i_o;
    logic [36:0] data_q_o;

    // Instantiate DUT
    compl_mul dut (
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
    initial begin
        clk_i = 0;
        forever #(CLK_PERIOD/2) clk_i = ~clk_i;
    end

    // Test procedure
    initial begin
        // Initialize inputs
        srst_i = 1;
        data_a_i_i = 0;
        data_a_q_i = 0;
        data_b_i_i = 0;
        data_b_q_i = 0;

        // Apply reset
        #(CLK_PERIOD*2);
        srst_i = 0;
        #(CLK_PERIOD);

        // Test case 1: Simple multiplication (1+0j)*(1+0j) = (1+0j)
        data_a_i_i = 18'sh00001; // 1.0
        data_a_q_i = 18'sh00000; // 0.0
        data_b_i_i = 18'sh00001; // 1.0
        data_b_q_i = 18'sh00000; // 0.0
        #(CLK_PERIOD);
        $display("Test 1: (1+0j)*(1+0j) = (%d+%dj)", $signed(data_i_o), $signed(data_q_o));

        // Test case 2: (1+1j)*(1+1j) = (0+2j)
        data_a_i_i = 18'sh00001; // 1.0
        data_a_q_i = 18'sh00001; // 1.0
        data_b_i_i = 18'sh00001; // 1.0
        data_b_q_i = 18'sh00001; // 1.0
        #(CLK_PERIOD);
        $display("Test 2: (1+1j)*(1+1j) = (%d+%dj)", $signed(data_i_o), $signed(data_q_o));

        // Test case 3: (2-3j)*(4+5j) = (23-2j)
        data_a_i_i = 18'sh00002; // 2.0
        data_a_q_i = -18'sh00003; // -3.0
        data_b_i_i = 18'sh00004; // 4.0
        data_b_q_i = 18'sh00005; // 5.0
        #(CLK_PERIOD);
        $display("Test 3: (2-3j)*(4+5j) = (%d+%dj)", $signed(data_i_o), $signed(data_q_o));

        // Test case 4: Large numbers
        data_a_i_i = 18'sh1FFFF; // Max positive (131071)
        data_a_q_i = -18'sh20000; // Min negative (-131072)
        data_b_i_i = 18'sh10000; // 65536
        data_b_q_i = -18'sh08000; // -32768
        #(CLK_PERIOD);
        $display("Test 4: Large numbers = (%d+%dj)", $signed(data_i_o), $signed(data_q_o));

        // Test case 5: Random values
        data_a_i_i = 18'sd12345;
        data_a_q_i = -18'sd6789;
        data_b_i_i = -18'sd2468;
        data_b_q_i = 18'sd1357;
        #(CLK_PERIOD);
        $display("Test 5: Random values = (%d+%dj)", $signed(data_i_o), $signed(data_q_o));

        // Finish simulation
        #(CLK_PERIOD*2);
        $display("Simulation completed");
        $finish;
    end

    // Monitoring
    always @(posedge clk_i) begin
        $strobe("At time %0t: A = (%d + %dj), B = (%d + %dj) => Result = (%d + %dj)",
            $time,
            $signed(data_a_i_i), $signed(data_a_q_i),
            $signed(data_b_i_i), $signed(data_b_q_i),
            $signed(data_i_o), $signed(data_q_o));
    end
    


endmodule
