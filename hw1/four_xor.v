`timescale 1ns / 1ps

module four_xor(
    input [3:0]a,
    output y
);
     
   assign y = ^a;
    
endmodule
