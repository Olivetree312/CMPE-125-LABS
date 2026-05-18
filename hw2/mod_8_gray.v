`timescale 1ns / 1ps
//matches highest bit significance of input to output val
module mod_8_gray(
    input clk,
    output reg [2:0]Q
);
initial Q=0;
reg [2:0]count=0;   
always @(posedge clk) begin
    count = (count+1)%8;
    Q[2] = count[2];
    Q[1] = count[2] ^ count[1];
    Q[0] = count[1] ^ count[0];
end
endmodule
