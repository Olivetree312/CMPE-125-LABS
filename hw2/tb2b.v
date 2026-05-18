`timescale 1ns/1ps

module tb2b; 
  reg clk=0;
  reg D;
  wire Q;
  
  d_using_jk dut(
    .clk(clk), .D(D), .Q(Q)
  );

  always #5 clk = ~clk; //5ns low, 5ns high
  integer i;
  initial D=0;
  initial begin
    $dumpfile("wave2b.vcd");
    $dumpvars(0, tb2b);
    $monitor("t=%0t | D=%b | Q=%b", $time, D, Q);
    for(i=0; i<4; i=i+1) begin
     @(posedge clk);
     //need to guarantee D stable before posedge
    #2 D <= i%2;
    end
    $finish;
  end
endmodule 
