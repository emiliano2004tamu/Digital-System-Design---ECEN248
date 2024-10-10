`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2023 02:58:13 AM
// Design Name: 
// Module Name: tlc_controller
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

module tlc_controller_verl(
    output wire [1:0] highwaySignal, farmSignal, //connected to LEDs
    /*Let's output state for debugging!*/
    output wire [3:0] JB,
    input wire Clk,
    /*the buttons provide input to our top level circuit*/
    input wire Rst //use as reset
);

//intermediate nets
wire RstSync;
wire RstCount;
reg [30:0] Count;

assign JB[3] = RstCount;

/*synchronize button inputs*/
synchronizer syncRst(RstSync, Rst, Clk);


//instantiate FSM
tlc_fsm FSM(
    .state(JB[2:0]), 
    .RstCount(RstCount),      
    .highwaySignal(highwaySignal),
    .farmSignal(farmSignal),
    .Count(Count),
    .Clk(Clk),  
    .Rst(RstSync)
);

//describe counter with a syncrhonous reset 
always @(posedge Clk)
  if (RstCount)
    Count <= 0; // Reset the counter if RstCount 
  else
  begin
  if(Count < 1500000000)
    Count <= Count + 1; // Increase if count is still less than 1500000000
  end
endmodule