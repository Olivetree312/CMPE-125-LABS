`timescale 1ns / 1ps
module xor_gate(
    input [1:0] sw,
    output led
);
assign led = sw[0] ^ sw[1];
endmodule
