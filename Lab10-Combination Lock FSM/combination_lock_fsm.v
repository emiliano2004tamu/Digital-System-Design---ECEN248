`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2023 08:13:05 AM
// Design Name: 
// Module Name: combination_lock_fsm
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


module combination_lock_fsm (
    output reg [2:0] state, //inputs and outputs being set as paramaters for the lock
    output wire [3:0] Lock,
    input wire Key1,
    input wire Key2,
    input wire [3:0] Password,
    input wire Reset,
    input wire Clk
    );

    parameter S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011; //bits for the states

reg [1:0] next_state; //next state being set

assign Lock = (state == S3) ? 4'b1111 : 4'b0000; //lock is set to state 4 and will light up all leds


    
always @(*) //will always start at any change
    begin
    state <= state; //state gets assigned basedon on next state on the second always block
    case (state) //
    S0: begin
        if (Key1 == 1'b1 && Password == 4'b1101) //if key1 and the buttons were pressed in order 1101 then it will go to state 1 
            next_state <= S1;
        else //else it will go the first state since it failed the first combination
            next_state <= S0;
    end

    S1: begin
    if (Key2 == 1'b1 && Password == 4'b0111) // for state 1 if key 2 and the buttons were pressed in order 0111 then it will go to state 2
        next_state <= S2;
    else //else if it is incorrect it will go to state 0 or if nothing is pressed then it will stay at state 1
    if (Key2 == 1'b1 && Password != 4'b0111)
        next_state <= S0;
    else
        next_state <= S1;
    end

    S2: begin //state 2
    if (Key1 == 1'b1 && Password == 4'b1001) //for state 2 if key 1 and password buttons were pressed in 1001 order, will go to state 3
        next_state <= S3;
    else
    if (Key1 == 1'b1 && Password != 4'b1001) //else it will go to state 0 if an incorrect password is pressed.
        next_state <= S0;
    else
        next_state <= S2;
    end
    
    
    S3: begin//if reset then it will go to state 0 else it will stay unlocked
    if (Reset)
        next_state <= S0;
    else
        next_state <= S3;
    end


    default: next_state <= S0; //default state
    
    endcase
    
    end
    
always @(posedge Clk) //when it hits the positive clock edge state will get assigned next state unless reset is pressed.
    begin
    if (Reset)
        state <= S0;
    else
        state <= next_state;
end
    

endmodule