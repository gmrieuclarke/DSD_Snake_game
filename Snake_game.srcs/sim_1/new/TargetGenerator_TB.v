`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.11.2025 15:25:15
// Design Name: 
// Module Name: TargetGenerator_TB
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


module TargetGenerator_TB(
    );

    reg CLK;
    reg RESET;
    reg TARGET_REACHED;
    wire [7:0] Target_ADDRH;
    wire [6:0] Target_ADDRV;
    
    Target_generator uut(
        .CLK(CLK),
        .RESET(RESET),
        .TARGET_REACHED(TARGET_REACHED),
        .Target_ADDRH(Target_ADDRH),
        .Target_ADDRV(Target_ADDRV)
    );
    
    initial begin
        CLK = 0;
        forever #50 CLK = ~CLK;
    end
    
    initial begin
        RESET = 0;
        TARGET_REACHED = 0;
        #125 TARGET_REACHED = 1;
        forever #50 TARGET_REACHED = ~TARGET_REACHED;
    end
    
    
endmodule
