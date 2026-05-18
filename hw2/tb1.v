`timescale 1ns/1ps

module tb1; 
  reg clk=0;
  //Q is wire in tb, but reg in module 
  //(driven by always in DUT, driven by DUT in tb)
  wire Q;
  
  t_using_d dut(.clk(clk), .Q(Q));

  always #5 clk = ~clk; //5ns low, 5ns high
  integer i;
  initial begin
    $dumpfile("wave1.vcd");
    $dumpvars(0, tb1);
    $monitor("t=%0t | Q=%b", $time, Q);
    for(i=0; i<8; i=i+1) begin
      @(posedge clk);
    end
    $finish;
  end
endmodule 
