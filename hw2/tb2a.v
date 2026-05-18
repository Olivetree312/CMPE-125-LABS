`timescale 1ns/1ps

module tb2a; 
  reg clk=0;
  reg [1:0]jk;
  wire Q;
  
  jk_using_d dut(
    .clk(clk), .J(jk[0]), .K(jk[1]), .Q(Q)
  );

  always #5 clk = ~clk; //5ns low, 5ns high
  integer i;
  initial begin
    $dumpfile("wave2a.vcd");
    $dumpvars(0, tb2a);
    $monitor("t=%0t | JK=%b | Q=%b", $time, jk, Q);
    for(i=0; i<4; i=i+1) begin
      //need to assign jk before clk edge or else X
      jk=i;
     @(posedge clk);
    end
    $finish;
  end
endmodule 
