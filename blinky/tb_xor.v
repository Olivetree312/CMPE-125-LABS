`timescale 1ns / 1ps
module tb_xor();
    reg [1:0] switch;
    wire led;
,`ok
xor_gate dut(.switch(switch),.led(led));

initial begin
 switch[0] = 0;

 switch[1] = 0;
 #10
 switch[1] = 1;
 #10 switch[0] = 1;
 switch[1] = 0;
 #10
 switch[1] = 1;
 #10
 $finish;
 end
endmodule
