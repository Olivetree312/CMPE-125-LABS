`timescale 1ns/1ps

module tb3; 
  reg [7:0] a;
  
  wire [2:0]y; 
  eight_priority dut (.a(a), .y(y));
  integer i;
 
  initial begin

    $dumpfile("wave3.vcd");

    $dumpvars(0, tb3);

    $monitor("t=%0t | a=%b-> y=%0b", $time, a, y);

    for(i=0; i<256; i=i+1) begin
      a=i;
      #10;
    end
    $finish;
  end
endmodule 
