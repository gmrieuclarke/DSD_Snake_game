`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2025 20:33:16
// Design Name: 
// Module Name: MPX_wrapper
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


module Score_Counter(
    input CLK,
    input RESET,
    input TARGET_REACHED,
    output [3:0] ScoreCount_Ones,
    output [3:0] ScoreCount_Tens,
    output reg WIN
    );
    
    wire [3:0] OnesCount;
    wire [3:0] TensCount;   
    wire [1:0] StrobeCount;

    wire Bit17TrigOut;
    wire OnesCount_TrigOut;
    

    
    //Generic Counter with 100Hz frequency
    Generic_counter #   (.COUNTER_WIDTH(17),
                         .COUNTER_MAX(99999)
                         )
                         Bit17Counter (
                         .CLK(CLK),
                         .RESET(1'b0),
                         .ENABLE(1'b1),
                         .TRIG_OUT(Bit17TrigOut)
                         );
    
    
    //Generic Counter to count the score in ones
    Generic_counter #   (.COUNTER_WIDTH(4),
                         .COUNTER_MAX(9)
                         )
                         OnesCounter (
                         .CLK(CLK),
                         .RESET(RESET),
                         .ENABLE(TARGET_REACHED),
                         .TRIG_OUT(OnesCount_TrigOut),
                         .COUNT(OnesCount)
                          );


    //Generic Counter to count the score in tens
    Generic_counter #   (.COUNTER_WIDTH(4),
                         .COUNTER_MAX(1)
                         )
                         TensCounter (
                         .CLK(CLK),
                         .RESET(RESET),
                         .ENABLE(OnesCount_TrigOut),
                         .COUNT(TensCount)
                          );

      assign ScoreCount_Ones = OnesCount;
      assign ScoreCount_Tens = TensCount;                                               
                        
    
    //If the score reaches 4, an output WIN will equal 1, signifying the user has completed the game              
    always@(posedge CLK) begin
        if (OnesCount == 4)
            WIN <= 1;
        else 
            WIN <= 0;
    end

endmodule
