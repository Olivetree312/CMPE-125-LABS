`timescale 1ns/1ps

module tb3; 
  reg clk=0;
  //Q is wire in tb, but reg in module 
  //(driven by always in DUT, driven by DUT in tb)
  wire [2:0]Q;
  
  mod_8_gray dut(.clk(clk), .Q(Q));

  always #5 clk = ~clk; //5ns low, 5ns high
  integer i;
  integer count;
  initial begin
    $dumpfile("wave3.vcd");
    $dumpvars(0, tb3);
    $monitor("t=%0t | gray#=%d | Q=%b", $time, count, Q);
    for(i=0; i<16; i=i+1) begin
      count=i%8;
      @(posedge clk);
    end
    $finish;
  end
endmodule 
