`timescale 1ns/1ps

module tb2; 
  reg [2:0] a;
  
  wire y; 
  minority dut (.a(a[0]), .b(a[1]), .c(a[2]), .y(y));
  integer i;
 
  initial begin

    $dumpfile("wave2.vcd");

    $dumpvars(0, tb2);

    $monitor("t=%0t | a=%0b | b=%b | c=%b-> y=%0b", $time, a[0], a[1], a[2], y);

    for(i=0; i<8; i=i+1) begin
      a=i;
      #10;
    end
    $finish;
  end
endmodule 
