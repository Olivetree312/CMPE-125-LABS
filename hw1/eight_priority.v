`timescale 1ns / 1ps

module eight_priority(
    input [7:0]a,
    output reg [2:0]y
);
     
always @(*) begin
    if (a[7])       y = 3'b111;
    else if (a[6])  y = 3'b110;
    else if (a[5])  y = 3'b101;
    else if (a[4])  y = 3'b100;
    else if (a[3])  y = 3'b011;
    else if (a[2])  y = 3'b010;
    else if (a[1])  y = 3'b001;
    else if (a[0])  y = 3'b000;
    else            y = 3'bx; // don't care if no input high
end
endmodule
