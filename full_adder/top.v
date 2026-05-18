module adder(
    //Cin = clk
    input wire A, B, Cin,
    output wire Sum, Cout
);

    wire axb, ab, aCin, bCin;
    assign axb = A ^ B;
    assign Cout = axb ^ Cin; 
    assign ab = A*B;
    assign aCin = A*Cin;
    assign bCin = B*Cin;
    assign Sum = ab + aCin + bCin; 

endmodule
