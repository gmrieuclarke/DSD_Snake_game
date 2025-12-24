`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2025 16:12:31
// Design Name: 
// Module Name: Snake_Wrapper
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


module Snake_Wrapper(
    input CLK,
    input RESET,
    input BTNU,
    input BTNR,
    input BTND,
    input BTNL,
    input ACCELERATE,
    output [11:0] COLOUR_OUT,
    output HS,
    output VS,
    output [3:0] SEG_SELECT,
    output [7:0] HEX_OUT
    );
    
    wire TARGET_REACHED;
    wire [1:0] MSM_State;
    wire [9:0] ADDRH_OUT;
    wire [8:0] ADDRV_OUT;
    wire WIN;
    wire LOSE;
    wire [7:0] Target_ADDRH;
    wire [6:0] Target_ADDRV;
    wire [11:0] COLOUR_OUT_wire;
    wire [1:0] NSM_direction;
    wire [3:0] ScoreCount_Ones;
    wire [3:0] ScoreCount_Tens;
    
    //Score counter connections
    Score_Counter Score(
            .CLK(CLK),
            .RESET(RESET),
            .TARGET_REACHED(TARGET_REACHED),
            .ScoreCount_Ones(ScoreCount_Ones),
            .ScoreCount_Tens(ScoreCount_Tens),
            .WIN(WIN)
        );
        
    //VGA Display Connections
    VGA_wrapper VGA(
            .CLK(CLK),
            .RESET(RESET),
            .MSM_State(MSM_State),
            .Colour_IN(COLOUR_OUT_wire),
            .COLOUR_OUT(COLOUR_OUT),
            .ADDRH_OUT(ADDRH_OUT),
            .ADDRV_OUT(ADDRV_OUT),
            .HS(HS),
            .VS(VS)
        );
    
    //Snake Controller Connections
    Snake_Control Snake_Control(
            .CLK(CLK),
            .RESET(RESET),
            .MSM_state(MSM_State),
            .NSM_direction(NSM_direction),
            .ADDRH(ADDRH_OUT),
            .ADDRV(ADDRV_OUT),
            .Target_ADDRH(Target_ADDRH),
            .Target_ADDRV(Target_ADDRV),
            .ACCELERATE(ACCELERATE),
            .COLOUR_OUT(COLOUR_OUT_wire),
            .TARGET_REACHED(TARGET_REACHED)
        );
        
    //Master State Machine Connections
    Master_SM MSM(
            .CLK(CLK),
            .RESET(RESET),
            .BTNU(BTNU),
            .BTNR(BTNR),
            .BTND(BTND),
            .BTNL(BTNL),
            .WIN(WIN),
            .LOSE(LOSE),
            .MSM_state(MSM_State)
        );
        
    //Navigation State Machine Connections
    Navigation_SM NSM(
            .CLK(CLK),
            .RESET(RESET),
            .BTNU(BTNU),
            .BTNR(BTNR),
            .BTND(BTND),
            .BTNL(BTNL),
            .NSM_direction(NSM_direction)
        );
      
    //Target Generator Connections
    Target_generator TGen(
            .CLK(CLK),
            .RESET(RESET),
            .TARGET_REACHED(TARGET_REACHED),
            .Target_ADDRH(Target_ADDRH),
            .Target_ADDRV(Target_ADDRV)
        );
    
    //Timer Connections
    Timer Timer(
            .CLK(CLK),
            .RESET(RESET),
            .MSM_state_in(MSM_State),
            .ScoreCount_Ones(ScoreCount_Ones),
            .ScoreCount_Tens(ScoreCount_Tens),
            .SEG_SELECT(SEG_SELECT),
            .DEC_OUT(HEX_OUT),
            .LOSE(LOSE)
        );
        
    
endmodule
