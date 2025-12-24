`timescale 1ns / 1ps

module Negative_counter(
        CLK,
        RESET,
        ENABLE,
        MSM_State,
        TRIG_OUT,
        COUNT
);

    //Parameters to control variability of each module
    parameter COUNTER_WIDTH = 4;
    parameter COUNTER_MAX = 9;
    
    input   CLK;
    input   RESET;
    input   ENABLE;
    input   MSM_State;
    output  TRIG_OUT;
    output  [COUNTER_WIDTH-1:0] COUNT;
    
    //Registers that hold the current count value and trigger out between clock cycles
    reg [COUNTER_WIDTH-1:0] count_value;
    reg Trigger_out;

    //Sychronous logic for value of count_value (counts down instead of up)
    always@(posedge CLK) begin
        if(RESET || MSM_State == 2'b00)
            count_value <= COUNTER_MAX;
        else begin
            if(ENABLE) begin
                if(count_value == 0)
                    count_value <= COUNTER_MAX;
                else
                    count_value <= count_value - 1;
            end
        end
    end

    //Sychronous logic for value of Trigger_out    
    always@(posedge CLK) begin
        if(RESET)
            Trigger_out <= 0;
        else begin
            if(ENABLE && (count_value == 0)) 
                Trigger_out <= 1;
            else
                Trigger_out <= 0;
        end
    end

    assign COUNT    = count_value;
    assign TRIG_OUT = Trigger_out;


endmodule
