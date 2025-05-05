`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2025 12:54:36
// Design Name: 
// Module Name: compl_mul_round
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


module compl_mul_round(
    input logic clk_i, 
    input logic srst_i,
    input logic signed [17:0]data_a_i_i,  // реальная часть
    input logic signed [17:0]data_a_q_i,  // мнимая часть
    input logic signed [17:0]data_b_i_i,  // реальная часть
    input logic signed [17:0]data_b_q_i,  // мнимая часть
    output  logic signed  [18:0]data_i_o,   // реальная часть результата
    output  logic signed [18:0]data_q_o    // мнимая часть результата
    );
    
    
    logic [33:0] prod_ii, prod_iq, prod_qi, prod_qq;//17+17 бит для умножения
    logic       prod_ii_sign,prod_iq_sign,prod_qi_sign,prod_qq_sign;//биты для хранения знака после умножения
    
    logic [35:0]prod_ii_c, prod_iq_c, prod_qi_c,prod_qq_c;
    logic [34:0] result_i_c, result_q_c;
   
    logic [34:0] result_i, result_q;
    logic [18:0] rounded_i, rounded_q;
    
    assign prod_ii = data_a_i_i[16:0]*data_b_i_i[16:0];
    assign prod_iq = data_a_i_i[16:0]*data_b_q_i[16:0];
    assign prod_qi = data_a_q_i[16:0]*data_b_i_i[16:0];
    assign prod_qq = data_a_q_i[16:0]*data_b_q_i[16:0];
    
    //для учета знака
    assign prod_ii_sign = data_a_i_i[17] ^ data_b_i_i[17];
    assign prod_iq_sign = data_a_i_i[17] ^ data_b_q_i[17];
    assign prod_qi_sign = data_a_q_i[17] ^ data_b_i_i[17];
    assign prod_qq_sign = ~(data_a_q_i[17] ^ data_b_q_i[17]);//инвертировано, потому что в формуле prod_qq знак "-"
      
    //перевод в дополнительный код
    assign prod_ii_c = prod_ii_sign?{prod_ii_sign, ~prod_ii}+1:{prod_ii_sign, prod_ii};
    assign prod_iq_c = prod_iq_sign?{prod_iq_sign, ~prod_iq}+1:{prod_iq_sign, prod_iq};
    assign prod_qi_c = prod_qi_sign?{prod_qi_sign, ~prod_qi}+1:{prod_qi_sign, prod_qi};
    assign prod_qq_c = prod_qq_sign?{prod_qq_sign, ~prod_qq}+1:{prod_qq_sign, prod_qq};
    
    assign result_i_c = prod_ii_c + prod_qq_c;
    assign result_q_c = prod_iq_c + prod_qi_c;
    
    //перевод в основной код
    assign result_i = result_i_c[34]?{result_i_c[34], ~(result_i_c[33:0]-1)}:result_i_c;
    assign result_q = result_q_c[34]?{result_q_c[34], ~(result_q_c[33:0]-1)}:result_q_c;
        
    //округление 
    always_comb begin
        if(result_i[15:0] !=0) begin
            
            rounded_i=result_i[34:16]+1;
        end
        else begin
            
            rounded_i=result_i[34:16];
        end
    end
    
    //округление
    always_comb begin
        if(result_q[15:0] !=0) begin
            
            rounded_q=result_q[34:16]+1;
        end
        else begin
            
            rounded_q=result_q[34:16];
        end
    end


    always_ff@(posedge clk_i) begin
        if(srst_i)begin
            data_i_o<=0;
            data_q_o<=0;
        end
        else begin
            data_i_o<=rounded_i;
            data_q_o<=rounded_q;
        end
    end
    
endmodule
