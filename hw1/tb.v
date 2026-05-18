`timescale 1ns/1ps

module tb; //module header -> needs ; after
  //"registers" represent storage elements in hardware, can be assigned values
  reg [3:0] a;
  //cannot assign to wire inside 'always' block, which is used to describe continuous behavior of hardware
  //procedural block 'always'= infinite loop that executes sequential statements if triggered
  wire y; //representing physical connection in hardware
  //dut = "design under test"
  four_xor dut (.a(a), .y(y));
  integer i;
  //initial blocks execute only once at beginning t=0
  initial begin
    // dump into VCD file BEFORE any time passes
    $dumpfile("wave.vcd");
    //dumvars(level, scope) -> 0 = all var in & below scope
    $dumpvars(0, tb);
    //$display prints when explicitly called, BUT monitor prints when VARS CHANGE
    $monitor("t=%0t | a=%0b -> y=%0b", $time, a, y);

    for(i=0; i<16; i=i+1) begin
      a=i;
      #10;
    end
    $finish;
  end
endmodule //keyword to terminate module
