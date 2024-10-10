`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2023 02:00:47 AM
// Design Name: 
// Module Name: tlc_fsm
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



module tlc_fsm(
    output reg [2:0] state, // output for debugging
    output reg RstCount, // use an always block
    output reg [1:0] highwaySignal, farmSignal,
    input wire [30:0] Count, // use n computed earlier
    input wire Clk, Rst // clock and reset
    
);
    
    /* declare different states */
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;

    parameter red = 2'b01,green = 2'b11, yellow = 2'b10;
    
    reg [2:0] nextState;

    always@ (state or Count)
        case (state)
            // state 0
            S0: begin
                highwaySignal = red; // results of state 0
                farmSignal = red;
                if (Count == 50000000 || (Rst ==1) ) // if we reached 1 second
                begin
                    
                    RstCount = 1;
                    nextState = S1; //transition to S1
                end
                
                else
                begin
                   
                    RstCount = 0;
                    nextState = S0;
                end
            end
            
            // state 1
            S1: begin
                highwaySignal = green; //gets assigned accordingyl to state 1 outputs
                farmSignal = red;  
                if (Count >= 1500000000)	// ifcount is 30 seconds it will begin
                begin
                         
                    RstCount = 1;
                    nextState = S2; //S2 is next
                end
                
                else
                begin
                    
                    RstCount = 0;
                    nextState = S1;
                end
                
            end
            
           // state 2
           S2: begin
                highwaySignal = yellow; //gets assigned accordingyl to state 1 outputs
                farmSignal = red;
                if(Count == 150000000)	 // if reached 3 seconds
                begin
                      
                    RstCount = 1;
                    nextState = S3; //transition to S3
                end
                else
                begin
             
                    RstCount = 0;
                    nextState = S2;
                end
            end
            
            //state 3
            S3: begin
                highwaySignal = red; //results of state 3
                farmSignal = red;  
                if(Count == 50000000)	//if reached 1 second
                begin
                    
                    RstCount = 1;
                    nextState = S4; //transition to S4
                end
                else
                begin
                   
                    RstCount = 0;
                    nextState = S3;
                end
            end
            
            //state 4
            S4: begin
                highwaySignal = red; //results of S4
                farmSignal = green;  
                if (Count >= 750000000)//if reached 15 seconds
                begin
                   
                    RstCount = 1;
                    nextState = S5; //transition to S5
                end
                else
                begin
                    
                    RstCount = 0;
                    nextState = S4;
                end
            end
            
            //state 5
            S5: begin
                highwaySignal = red; //results of S5
                farmSignal = yellow;  
                if(Count == 150000000)	//if reached 3 seconds
                begin
                    
                    RstCount = 1;
                    nextState = S0; //transition to S0
                end
                else
                begin
                   
                    RstCount = 0;
                    nextState = S5;
                end
            end
        endcase

    always@ (posedge Clk)
        if(Rst)
            state <= S0;
        else
            state <= nextState;
         
endmodule //designate e