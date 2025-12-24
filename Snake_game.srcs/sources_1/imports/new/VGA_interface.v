`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.10.2025 15:30:27
// Design Name: 
// Module Name: Colour_the_world
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


module VGA_interface(
    input CLK,
    input [11:0] COLOUR_IN,
    output reg [9:0] ADDRH,
    output reg [8:0] ADDRV,
    output reg [11:0] COLOUR_OUT,
    output reg HS,
    output reg VS
    );
    
    //Setting the vertical display size
    parameter VertTimeToPulseWidthEnd   = 10'd2;
    parameter VertTimeToBackPorchEnd    = 10'd31;
    parameter VertTimeToDisplayTimeEnd  = 10'd511;
    parameter VertTimeToFrontPorchEnd   = 10'd521;
    
    //Setting the horizontal display size
    parameter HorzTimeToPulseWidthEnd   = 10'd96;
    parameter HorzTimeToBackPorchEnd    = 10'd144;
    parameter HorzTimeToDisplayTimeEnd  = 10'd784;
    parameter HorzTimeToFrontPorchEnd   = 10'd800;    
    
    wire [9:0] HorzCount;
    wire [9:0] VertCount;   
    wire HorzCounterTrigOut;
    
    //Generic Counter to count pixels horizontally
    Generic_counter #   (.COUNTER_WIDTH(10),
                         .COUNTER_MAX(799)
                         )
                         HorzCounter (
                        .CLK(CLK),
                        .RESET(1'b0),
                        .ENABLE(1'b1),
                        .TRIG_OUT(HorzCounterTrigOut),
                        .COUNT(HorzCount)
                        );
    
    //Generic Counter to count pixels vertically                    
    Generic_counter #   (.COUNTER_WIDTH(10),
                         .COUNTER_MAX(520)
                         )
                         VertCounter (
                        .CLK(CLK),
                        .RESET(1'b0),
                        .ENABLE(HorzCounterTrigOut),
                        .COUNT(VertCount)
                        );   
                        
                
    //Establish where there should be a horizontal output                    
    always@(posedge CLK) begin
        if (HorzCount < HorzTimeToPulseWidthEnd)
            HS <= 0;
        else
            HS <= 1;
    end
    
    //Establish where there should be a vertical output   
    always@(posedge CLK) begin
        if (VertCount < VertTimeToPulseWidthEnd)
            VS <= 0;
        else
            VS <= 1;
    end
    
    //Create ranges for when the display is (within determined aspect ratio)
    wire HorzRange;
    wire VertRange;
    assign HorzRange = ((HorzCount >= HorzTimeToBackPorchEnd) && (HorzCount <= HorzTimeToDisplayTimeEnd));      
    assign VertRange = ((VertCount >= VertTimeToBackPorchEnd) && (VertCount <= VertTimeToDisplayTimeEnd));     

    //Declare when there should be colour outputting
    always@(posedge CLK) begin
        if (HorzRange && VertRange)
            COLOUR_OUT <= COLOUR_IN;
        else
            COLOUR_OUT <= 12'd0;
    end
    
    //Declare outputs
    always@(posedge CLK) begin
        if (HorzRange)
            ADDRH <= HorzCount - HorzTimeToBackPorchEnd + 2;
       else
            ADDRH <= 0;
        if (VertRange)
            ADDRV <= VertCount - VertTimeToBackPorchEnd + 1;
        else
            ADDRV <= 0;
    end
               
endmodule