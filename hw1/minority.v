`timescale 1ns / 1ps

module minority(
    input a,
    input b, 
    input c,
    output y
);
     
   assign y = a ^ b ^ c;
    
endmodule
