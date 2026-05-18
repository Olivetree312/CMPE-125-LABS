`timescale 1ns/1ps
module tb;
reg A, B, Cin;
wire Sum, Cout;

adder out(.A(A), .B(B),.Cin(Cin), .Cout(Cout), .Sum(Sum));

initial begin
A=0; B=0; Cin=0;

$monitor("Time=%0t | A=%b B=%b Cin=%b | Cout=%b Sum=%b",
            $time, A, B, Cin, Cout, Sum);

#10 A=0; B=0; Cin=0;
#10 A=0; B=0; Cin=1;
#10 A=0; B=1; Cin=0;
#10 A=0; B=1; Cin=1;
#10 A=1; B=0; Cin=0;
#10 A=1; B=0; Cin=1;
#10 A=1; B=1; Cin=0;
#10 A=1; B=1; Cin=1;

#20 $finish;
end

endmodule