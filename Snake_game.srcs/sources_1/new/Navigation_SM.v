`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2025 20:54:49
// Design Name: 
// Module Name: Navigation_SM
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


module Navigation_SM(
    input RESET,
    input CLK,
    input BTNU,
    input BTNR,
    input BTND,
    input BTNL,
    output [1:0] NSM_direction
    );

    reg [1:0] Curr_state;
    reg [1:0] Next_state;
    
    assign NSM_direction = Curr_state;
    
    //Set initial state
    always@(posedge CLK or posedge RESET) begin
        if (RESET)
            Curr_state <= 2'b00;
        else
            Curr_state <= Next_state;
    end
    
    always@(Curr_state or BTNU or BTNR or BTND or BTNL) begin
        case(Curr_state)
            
            //Down
            2'b00 : begin
                if(BTNR)
                    Next_state <= 2'b01;
                else if(BTNL)
                    Next_state <= 2'b11;
                else
                    Next_state <= Curr_state;
            end
            
            
            //Right
            2'b01 : begin
                if(BTND)
                    Next_state <= 2'b00;
                else if(BTNU)
                    Next_state <= 2'b10;
                else
                    Next_state <= Curr_state;
            end
            
            
            //Up
            2'b10 : begin
                if(BTNR)
                    Next_state <= 2'b01;
                else if(BTNL)
                    Next_state <= 2'b11;
                else
                    Next_state <= Curr_state;
            end
                 
            //Left        
            2'b11 : begin
                if(BTND)
                    Next_state <= 2'b00;
                else if(BTNU)
                    Next_state <= 2'b10;
                else
                    Next_state <= Curr_state;
            end
                
            default :
                Next_state <= Curr_state;
                
        endcase
    end  
            
endmodule

