`timescale 1ns / 1ps

module Target_generator(
    input CLK,
    input RESET,
    input TARGET_REACHED,
    output reg [7:0] Target_ADDRH,
    output reg [6:0] Target_ADDRV
    );
    
    reg [7:0] LFSR_H;
    reg [6:0] LFSR_V;
    
    wire input_H = (LFSR_H[3] ~^ (LFSR_H[4] ~^ (LFSR_H[5] ~^ LFSR_H[7])));
    wire input_V = LFSR_V[6] ~^ LFSR_V[5];
    
    initial begin
        LFSR_H = 8'b00000000;
        LFSR_V = 7'b0000000;
        Target_ADDRH = 80;
        Target_ADDRV = 60;
    end
    
    always@(posedge CLK) begin
        if(RESET)
            LFSR_H <= 8'b00000000;
        else begin
            LFSR_H[7:1] <= LFSR_H[6:0];
            LFSR_H[0] <= input_H;
        end
    end
    
    always@(posedge CLK) begin
        if(RESET)
            LFSR_V <= 7'b0000000;
        else begin
            LFSR_V[6:1] <= LFSR_V[5:0];
            LFSR_V[0] <= input_V;
        end
    end

    
    always@(posedge CLK) begin
        if(TARGET_REACHED) begin
            if(LFSR_H < 159)
                Target_ADDRH <= LFSR_H;
            else
                Target_ADDRH <= 80;
       end
       else if(RESET)
            Target_ADDRH <= 80;
    end
    
    always@(posedge CLK) begin
        if(TARGET_REACHED) begin
            if(LFSR_V < 119)
                Target_ADDRV <= LFSR_V;
            else
                Target_ADDRV <= 60;
       end
       else if(RESET)
            Target_ADDRV <= 60;
    end

    
endmodule
