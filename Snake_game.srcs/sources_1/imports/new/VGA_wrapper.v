`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2025 14:23:56
// Design Name: 
// Module Name: VGA_wrapper
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


module VGA_wrapper(
    input  CLK,  
    input  RESET,  
    input  [1:0] MSM_State,
    input  [11:0] Colour_IN,
    output [11:0] COLOUR_OUT,
    output [9:0] ADDRH_OUT,    
    output [8:0] ADDRV_OUT,
    output HS,
    output VS
    );
    
    //Decrease the clock signal to 25MHz
    reg [1:0] CLK_counter = 0;
    wire CLK25MHz;
    
    always@(posedge CLK) 
        CLK_counter <= CLK_counter + 1;
    
    assign CLK25MHz = CLK_counter[1];
 
    
    wire [11:0] Colour_to_interface;
    wire [9:0] X;
    wire [8:0] Y;
    
    //Frame connections
    VGA_frame VGAFrame(
        .RESET(RESET),
        .CLK(CLK25MHz),
        .MSM_State(MSM_State),
        .ADDRH(X),
        .ADDRV(Y),
        .Colour_IN(Colour_IN),
        .COLOUR(Colour_to_interface)
        );
    
    //Interface connections            
    VGA_interface VGAInterface(
        .CLK(CLK25MHz),
        .COLOUR_IN(Colour_to_interface),
        .COLOUR_OUT(COLOUR_OUT),
        .ADDRH(X),
        .ADDRV(Y),
        .HS(HS),
        .VS(VS)
        );
        
    assign ADDRH_OUT = X;
    assign ADDRV_OUT = Y;
    
endmodule
