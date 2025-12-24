`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2025 20:37:45
// Design Name: 
// Module Name: Master_SM
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


module Master_SM(
    input CLK,
    input RESET,
    input BTNU,
    input BTNR,
    input BTND,
    input BTNL,
    input WIN,
    input LOSE,
    output [1:0] MSM_state
    );
    
    reg [1:0] Curr_state;
    reg [1:0] Next_state;
    
    assign MSM_state = Curr_state;
    
    //Set initial state
    always@(posedge CLK or posedge RESET) begin
        if (RESET)
            Curr_state <= 2'b00;
        else
            Curr_state <= Next_state;
    end
    
    always@(Curr_state or BTNU or BTNR or BTND or BTNL or WIN or LOSE) begin
        case(Curr_state)
            
            //IDLE
            2'b00 : begin
                if(BTNU || BTNR || BTND || BTNL)
                    Next_state <= 2'b01;
                else
                    Next_state <= Curr_state;
            end
            
            //PLAY
            2'b01 : begin
                if(WIN == 1)
                    Next_state <= 2'b10;
                else if(LOSE == 1)
                    Next_state <= 2'b00;
                else
                    Next_state <= Curr_state;
            end
            
            //WIN
            2'b10 :
                Next_state <= Curr_state;
                
            default :
                Next_state <= Curr_state;
                
        endcase
    end  
            
endmodule
