`timescale 1ns / 1ps
//jk-FF has Q+ = JQ' + K'Q
//d-FF has Q+ = D, so make D = JQ' + K'Q
module jk_using_d(
    input wire clk,
    input wire J,
    input wire K,
    output reg Q
);
//executes once, initializes Q to 0 to prevent X
initial Q = 0;
wire D = (J & ~Q)+(~K & Q);
always @(posedge clk) begin
    Q <= D;
end
endmodule
