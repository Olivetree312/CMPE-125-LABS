`timescale 1ns / 1ps
//for JK: Q+ = (J & ~Q) | (~K & Q)
//for T: Q+ = ~Q --> J=1, K=1
module t_using_jk(
    input wire clk,
    output reg Q
);
//executes once, initializes Q to 0 to prevent X
initial Q = 0;
wire J = 1;
wire K = 1;
always @(posedge clk) begin
    Q <= (J & ~Q) | (~K & Q);
end
endmodule
