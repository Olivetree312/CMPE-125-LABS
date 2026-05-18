`timescale 1ns/1ps

module tb2c; 
  reg clk=0;
  wire Q;
  
  t_using_jk dut(
    .clk(clk), .Q(Q)
  );

  always #5 clk = ~clk; //5ns low, 5ns high
  integer i;
  initial begin
    $dumpfile("wave2c.vcd");
    $dumpvars(0, tb2c);
    $monitor("t=%0t | Q=%b", $time, Q);
    for(i=0; i<4; i=i+1) begin
     @(posedge clk);
    end
    $finish;
  end
endmodule 
