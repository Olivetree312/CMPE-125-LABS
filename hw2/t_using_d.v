`timescale 1ns / 1ps
//dFF has input clk, output Q+ = D
//tFF has input clk, output Q+ = ~Q
module t_using_d(
    input wire clk,
    //Q is reg since driven by always in DUT
    output reg Q
);
//executes once, initializes Q to 0 to prevent X
initial Q = 0;
wire D = ~Q;
always @(posedge clk) begin
    Q <= D;
end
endmodule
