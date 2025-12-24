`timescale 1ns / 1ps

module Timer(
    input CLK,
    input RESET,
    input [1:0] MSM_state_in,
    input [3:0] ScoreCount_Ones,
    input [3:0] ScoreCount_Tens,
    output [3:0] SEG_SELECT,
    output [7:0] DEC_OUT,
    output reg LOSE
    );
    
    wire [3:0] OnesCount;
    wire [3:0] TensCount;   

    wire Bit27TrigOut;
    wire Bit17TrigOut;
    
    wire [1:0] StrobeCount;
    
    reg MSM_state;
    wire OnesCount_TrigOut;

    //Creating an Enable from MSM_state_in
    always@(posedge CLK) begin
        if(MSM_state_in == 2'b01)
            MSM_state <= 1;
        else 
            MSM_state <= 0;
    end
    
    wire TrigEn;    
    assign TrigEn = Bit27TrigOut && MSM_state;

    
    //Generic counter with 100MHz frequency
    Generic_counter #   (.COUNTER_WIDTH(27),
                         .COUNTER_MAX(99999999)
                         )
                         Bit27Counter (
                         .CLK(CLK),
                         .RESET(RESET),
                         .ENABLE(1'b1),
                         .TRIG_OUT(Bit27TrigOut)
                         );
    
    //Generic counter with 1MHz frequency                     
    Generic_counter #   (.COUNTER_WIDTH(17),
                         .COUNTER_MAX(99999)
                         )
                         Bit17Counter (
                         .CLK(CLK),
                         .RESET(RESET),
                         .ENABLE(1'b1),
                         .TRIG_OUT(Bit17TrigOut)
                         );                         
    
    //Generic counter that counts down seconds in ones
    Negative_counter #   (.COUNTER_WIDTH(4),
                         .COUNTER_MAX(9)
                         )
                         Ones_count (
                         .CLK(CLK),
                         .RESET(RESET),
                         .ENABLE(TrigEn),
                         .MSM_State(MSM_state_in),
                         .TRIG_OUT(OnesCount_TrigOut),
                         .COUNT(OnesCount)
                          );
    
    //Generic counter that counts down seconds in tens
    Negative_counter #   (.COUNTER_WIDTH(2),
                         .COUNTER_MAX(2)
                         )
                         Tens_count (
                         .CLK(CLK),
                         .RESET(RESET),
                         .ENABLE(OnesCount_TrigOut),
                         .MSM_State(MSM_state_in),
                         .COUNT(TensCount)
                          );
    
    //Generic counter to control strobe frequency of seven segment display                     
    Generic_counter #   (.COUNTER_WIDTH(2),
                         .COUNTER_MAX(3)
                         )
                         StrobeCounter (
                         .CLK(CLK),
                         .ENABLE(Bit17TrigOut),
                         .COUNT(StrobeCount)
                          );


    
    wire [4:0] SCOAndDOT0;
    wire [4:0] SCTAndDOT1;   
    wire [4:0] OCAndDOT2;   
    wire [4:0] TCAndDOT3;   
    
    wire [4:0] MuxOut;
    

    assign SCOAndDOT0 = {1'b0, ScoreCount_Ones};
    assign SCTAndDOT1 = {1'b0, ScoreCount_Tens};  
    assign OCAndDOT2  = {1'b0, OnesCount};  
    assign TCAndDOT3  = {1'b0, TensCount};                                       
    
    //Multiplexer to ensure each display segment is displaying correct output         
    Multiplexer_4way Mux4(
            .CONTROL(StrobeCount),
            .IN0(SCOAndDOT0),
            .IN1(SCTAndDOT1),
            .IN2(OCAndDOT2),
            .IN3(TCAndDOT3),
            .OUT(MuxOut)
            );
    
    //Specifies which parts of the display should be lit to diplay which number                
    Seg7Display Seg7(
            .SEG_SELECT_IN(StrobeCount),
            .BIN_IN(MuxOut[3:0]),
            .DOT_IN(MuxOut[4]),
            .SEG_SELECT_OUT(SEG_SELECT),
            .HEX_OUT(DEC_OUT)
            );

    //If 30 second contdown hits 0, output LOSE is set to 1
    always@(posedge CLK) begin
        if (TensCount == 0) begin
            if(OnesCount == 0)
                LOSE <= 1;
        end
        else
            LOSE <= 0;
    end              

    
endmodule
