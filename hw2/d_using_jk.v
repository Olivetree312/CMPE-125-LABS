`timescale 1ns / 1ps
//for JK: Q+ = (J & ~Q) | (~K & Q)
//for D: Q+ = D
module d_using_jk(
    input wire clk,
    input wire D,
    output reg Q
);
//executes once, initializes Q to 0 to prevent X
initial Q = 0;
wire J = D;
wire K = ~D;
always @(posedge clk) begin
    Q <= (J & ~Q) | (~K & Q);
end
endmodule
