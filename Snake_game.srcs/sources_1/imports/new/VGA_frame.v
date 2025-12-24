`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2025 14:29:49
// Design Name: 
// Module Name: VGA_frame
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


module VGA_frame(
    input CLK,
    input RESET,
    input [1:0] MSM_State,
    input [9:0]  ADDRH,
    input [8:0]  ADDRV,
    input [11:0] Colour_IN,
    output [11:0] COLOUR
    );
    
    //assign output colour to be equal to input colour
    assign COLOUR = Colour_IN;
            
endmodule
