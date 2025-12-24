`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2025 14:17:13
// Design Name: 
// Module Name: Snake_Control
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


module Snake_Control(
    input CLK,
    input RESET,
    input [1:0] MSM_state,
    input [1:0] NSM_direction,
    input [9:0] ADDRH,
    input [8:0] ADDRV,
    input [7:0] Target_ADDRH,
    input [6:0] Target_ADDRV,
    input ACCELERATE,
    output reg [11:0] COLOUR_OUT,
    output reg TARGET_REACHED
    );
    
    //Registers for snake pixels 
    reg [7:0] SnakeState_X [0: SnakeLength-1];
    reg [6:0] SnakeState_Y [0: SnakeLength-1];
    
    reg Update_position;
    
    integer i;
    
    parameter SnakeLength = 15;
    parameter MaxX = 159;
    parameter MaxY = 119;
    
    parameter RED = 12'b000000001111;
    parameter BLUE = 12'b111100000000;
    parameter YELLOW = 12'b000011111111;
    parameter BLACK = 12'b000000000000;
    parameter WHITE = 12'hFFF;
    parameter GREEN = 12'h0F0;
    
    wire [22:0] FreqCounter;
    wire [22:0] AccelCounter;
  
    initial
        TARGET_REACHED <= 0;
    
    //Generic counter of 6MHz 
    Generic_counter #  (.COUNTER_WIDTH(23),
                        .COUNTER_MAX(5999999)
                       )
                       FreqCounter (
                       .CLK(CLK),
                       .RESET(RESET),
                       .ENABLE(1'b1),
                       .COUNT(FreqCounter)
                       );
                       
     //Generic counter of 3MHz                 
     Generic_counter #  (.COUNTER_WIDTH(23),
                         .COUNTER_MAX(2999999)
                        )
                        AccelCounter (
                        .CLK(CLK),
                        .RESET(RESET),
                        .ENABLE(1'b1),
                        .COUNT(AccelCounter)
                        );
        
        reg [22:0] Counter;
                        
        always@(posedge CLK) begin
            if (ACCELERATE)
                Counter <= AccelCounter;
            else 
                Counter <= FreqCounter;
        end
    
    always@(posedge CLK) begin
        case (MSM_state)
    
            //IDLE state display
            2'b00:  begin
                //When in IDLE display should be white
                COLOUR_OUT <= WHITE;
    
            end
                
            //PLAY state display (describing how game is played)
            2'b01: begin   
            
                //When snake head address corresponds to address from VGA module it is coloured yellow
                if(ADDRH[9:2] == SnakeState_X[0] && ADDRV[8:2] == SnakeState_Y[0])
                    COLOUR_OUT <= YELLOW;           

                //When target address corresponds to the address  from the VGA module it is coloured in red.        
                else if(ADDRH[9:2] == Target_ADDRH && ADDRV[8:2] == Target_ADDRV)
                    COLOUR_OUT <= RED;
            
                else 
                    COLOUR_OUT <= BLUE;

                //Loop counter to colour snake length                  
                for (i = 0; i < SnakeLength; i = i + 1) begin
                    if (ADDRH[9:2] == SnakeState_X[i] && ADDRV[8:2] == SnakeState_Y[i])
                        COLOUR_OUT <= YELLOW;
                end
            
            
                //When snake head address matches target address, TARGET_REACHED signal is generated
                if (SnakeState_X[0] == Target_ADDRH && SnakeState_Y[0] == Target_ADDRV && Update_position == 1)
                    TARGET_REACHED <= 1; 
                
                else
                    TARGET_REACHED <= 0;

            end 
            
            //WIN state display
            2'b10 : begin

                if(ADDRH < 640) begin
                    if(ADDRV < 120)
                        COLOUR_OUT <= GREEN;
                    else if (ADDRV >= 240 && ADDRV < 360)
                        COLOUR_OUT <= GREEN;
                    else
                        COLOUR_OUT <= WHITE;
                end
            end
            
        endcase     
    end    
    
    //Changing the positions of the ake registers
    //Shifting the SnakeState X and Y
    genvar PixNo;
    generate
        for (PixNo = 0; PixNo < SnakeLength-1; PixNo = PixNo+1)
        begin: PixShift
            always@(posedge CLK) begin
                if (RESET) begin
                    SnakeState_X[PixNo+1] <= 80;
                    SnakeState_Y[PixNo+1] <= 60;
                end
                else if (Counter == 0) begin
                    SnakeState_X[PixNo+1] <= SnakeState_X[PixNo];
                    SnakeState_Y[PixNo+1] <= SnakeState_Y[PixNo];
                    Update_position <= 1;
                
                end
                else
                    Update_position <= 0;
            end
        end
    endgenerate
    
    //Replace the top snake state with new one based on direction    
    always@(posedge CLK) begin
        //Set initial snake position
        if (RESET) begin
            SnakeState_X[0] <= 80;
            SnakeState_Y[0] <= 70;
        end
        else if (Counter == 0 && MSM_state == 2'b01) begin
            case (NSM_direction)
               
               //Down
                2'b00 : begin
                    if (SnakeState_Y[0] == MaxY)
                        SnakeState_Y[0] <= 0;
                    else
                        SnakeState_Y[0] <= SnakeState_Y[0] + 1;
                end
            
                //Right
                2'b01 : begin
                    if (SnakeState_X[0] == MaxX)
                        SnakeState_X[0] <= 0;
                    else
                        SnakeState_X[0] <= SnakeState_X[0] + 1;
                end
    
                //Up
                2'b10 : begin
                    if (SnakeState_Y[0] == 0)
                        SnakeState_Y[0] <= MaxY;
                    else
                        SnakeState_Y[0] <= SnakeState_Y[0] - 1;
                end

                //Left
                2'b11 : begin
                    if (SnakeState_X[0] == 0)
                        SnakeState_X[0] <= MaxX;
                    else
                        SnakeState_X[0] <= SnakeState_X[0] - 1;
                end
            endcase
        end
    end

    
endmodule
