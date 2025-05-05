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
   input logic signed [17:0]data_a_i_i,  // �������� �����
   input logic signed [17:0]data_a_q_i,  // ������ �����
   input logic signed [17:0]data_b_i_i,  // �������� �����
   input logic signed [17:0]data_b_q_i,  // ������ �����
   output  logic signed  [36:0]data_i_o,   // �������� ����� ����������
   output  logic signed [36:0]data_q_o    // ������ ����� ����������
   );
   
   //18 ��� ������� ������
   //36 ��� �������� ������ ����� �������� ���������, ��� ��� ������� ��������� ��������� �����������
   //36+1=37 ��� �������� ������ ����� �������� ��������(���������), ��� ��� ��� �������� ����������� ����������� �� 1 ���
   //������ ����� ���������� ����������� ��� �������� � ��������� �� �����������, �� ����� ������
   
   
   logic signed [35:0] prod_ii_c, prod_iq_c, prod_qi_c, prod_qq_c;
   
   
   assign prod_ii_c = data_a_i_i * data_b_i_i;
   assign prod_qq_c = data_a_q_i * data_b_q_i;
   assign prod_iq_c= data_a_i_i * data_b_q_i;
   assign prod_qi_c= data_a_q_i * data_b_i_i;
   
   always_ff@(posedge clk_i) begin
       if(srst_i)begin
           data_i_o<=0;
           data_q_o<=0;
       end
       else begin
           data_i_o<=prod_ii_c-prod_qq_c;
           data_q_o<=prod_iq_c+prod_qi_c;
       end
   end
   
endmodule
