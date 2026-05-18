`timescale 1ns/1ps

module tb4; 
  reg [1:0] a;
  
  wire [3:0]y; 
  two_four_decoder dut (.a(a), .y(y));
  integer i;
 
  initial begin

    $dumpfile("wave4.vcd");

    $dumpvars(0, tb4);

    $monitor("t=%0t | a=%b-> y=%0b", $time, a, y);

    for(i=0; i<4; i=i+1) begin
      a=i;
      #10;
    end
    $finish;
  end
endmodule 
