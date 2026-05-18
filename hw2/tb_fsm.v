`timescale 1ns/1ps

module tb_fsm;

  reg  clk = 0;
  reg  [1:0] ab=0;
  wire Z;

  // Instantiate DUT
  fsm dut (
    .clk(clk),
    .A(ab[0]),
    .B(ab[1]),
    .Z(Z)
  );

  reg prevA=0; //assuming initial An-1 = 0
  // 10ns period clock
  always #5 clk = ~clk;
  //store prevA at posedge
  always @(posedge clk) begin
        prevA <=ab[0];
      end
  integer i;
  initial begin
    $dumpfile("wave4.vcd");
    $dumpvars(0, tb_fsm);
    $monitor("t=%0t | AB=%b | prevA=%b | Z=%b", $time, ab, prevA, Z);
    for(i=0; i<8; i=i+1) begin
      @(negedge clk);
      ab <= i; //updates ab at neg edge
    end

    //what does this do, why are there two posedges?
    @(posedge clk);
    #1
    $finish;
  end

endmodule