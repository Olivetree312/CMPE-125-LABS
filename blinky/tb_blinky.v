`timescale 1ns / 1ps
module tb_blinky();
reg clk;
wire led;

blinky out(.clk(clk),.led(led));

initial begin
clk = 1'b0;
forever #5 clk = ~clk;
end

initial begin 
#350_000_000;
$finish;
end
endmodule
