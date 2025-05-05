`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2025 19:12:45
// Design Name: 
// Module Name: compl_mul
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


module compl_mul(
   input logic clk_i, 
   input logic srst_i,
   input logic signed [17:0]data_a_i_i,  // реальная часть
   input logic signed [17:0]data_a_q_i,  // мнимая часть
   input logic signed [17:0]data_b_i_i,  // реальная часть
   input logic signed [17:0]data_b_q_i,  // мнимая часть
   output  logic signed  [36:0]data_i_o,   // реальная часть результата
   output  logic signed [36:0]data_q_o    // мнимая часть результата
   );
   
   //18 бит входных данных
   //36 бит выходных данных после операции умножения, так как опреция умножения удваивает разрядность
   //36+1=37 бит выходных данных после операции сложения(вычитания), так как эта операция увеличивает разрядность на 1 бит
   //однако часто увеличение разрядности при сложении и вычитании не учитывается, но здесь учтено
   
   
   
   logic signed [35:0] prod_ii, prod_iq, prod_qi, prod_qq;
   
   
   assign prod_ii = data_a_i_i * data_b_i_i;
   assign prod_qq = data_a_q_i * data_b_q_i;
   assign prod_iq = data_a_i_i * data_b_q_i;
   assign prod_qi = data_a_q_i * data_b_i_i;
   
   always_ff@(posedge clk_i) begin
       if(srst_i)begin
           data_i_o<=0;
           data_q_o<=0;
       end
       else begin
           data_i_o<=prod_ii-prod_qq;
           data_q_o<=prod_iq+prod_qi;
       end
   end
   
endmodule
