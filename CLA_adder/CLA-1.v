`timescale 1ns / 1ps
//BOARD WRAPPER
module CLA_basys3_top(
    input wire [15:0]sw,
    output wire [15:0]led
    );
    
    //inputs on the leftmost switches, leds displaying outputs
    wire [3:0] A = sw[15:12];
    wire [3:0] B = sw[11:8];
    wire Cin = sw[7];
    //internal wires
    wire[3:0]S;
    wire Co, PG, GG;
    wire [3:0] G, P;
    wire [4:0]C; //Cin = C[0], Co = C[4]
    
    CLA4 dut(
        .A(A),
        .B(B),
        .Cin(Cin),
        .S(S),
        .Co(Co),
        .PG(PG),
        .GG(GG),
        .G(G),
        .P(P),
        .C(C)
        );
   assign led[4:0] = {Co, S};
   assign led[6] = PG;
   assign led[7] = GG;
   //make sure other LEDs off
   assign led[15:8] = 8'b0;
endmodule

//GPS FUll Adder Blocks
module GPSFullAdder(
    input wire Ai,
    input wire Bi,
    input wire Ci,
    output wire Gi,
    output wire Pi,
    output wire Si
);
    assign Gi = Ai & Bi;
    assign Pi = Ai ^ Bi;
    assign Si = Pi ^ Ci;
endmodule

//Carry logic applied to all blocks
module CLALogic(
    input wire [3:0] G,
    input wire[3:0] P,
    input wire Cin,
    output wire [4:0] C, 
    output wire Co,
    output wire PG,
    output wire GG
);
    //Cout = GG + (PG* Cin)
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0]&C[0]);
    assign C[2] = G[1] | (P[1]&G[0]) | (P[1]&P[0]&C[0]);
    assign C[3] = G[2] | (P[2]&G[1]) | (P[2]&P[1]&G[0]) | (P[2]&P[1]&P[0]&C[0]);
    assign C[4] = G[3] | (P[3]&G[2]) | (P[3]&P[2]&G[1]) | (P[3]&P[2]&P[1]&G[0])
                    | (P[3]&P[2]&P[1]&P[0]&C[0]);
    assign Co = C[4];
    //total group propagate & generate
    //pg: 4-bit block only propagates incoming carry if ALL individual bits do
    assign PG = P[3] & P[2] & P[1] & P[0];
    //gg: group carry generated if highest bit generates
    // or lower bit generates & higher bits propagate
    assign GG = G[3] | (P[3]&G[2]) | (P[3]&P[2]&G[1]) | (P[3]&P[2]&P[1]&G[0]);     

endmodule

//4-bit CLA adder block
module CLA4(
    input wire [3:0]A,
    input wire [3:0]B,
    input wire Cin,
    output wire [3:0]S,
    output wire Co,
    output wire PG,
    output wire GG,
    output wire [3:0] G,
    output wire [3:0] P,
    output wire [4:0] C
);
    CLALogic cla_logic(
        .G(G),
        .P(P),
        .Cin(Cin),
        .C(C),
        .Co(Co),
        .PG(PG),
        .GG(GG)
    );
    GPSFullAdder fa0(.Ai(A[0]), .Bi(B[0]), .Ci(C[0]), .Gi(G[0]), .Pi(P[0]), .Si(S[0]));
    GPSFullAdder fa1(.Ai(A[1]), .Bi(B[1]), .Ci(C[1]), .Gi(G[1]), .Pi(P[1]), .Si(S[1]));
    GPSFullAdder fa2(.Ai(A[2]), .Bi(B[2]), .Ci(C[2]), .Gi(G[2]), .Pi(P[2]), .Si(S[2]));
    GPSFullAdder fa3(.Ai(A[3]), .Bi(B[3]), .Ci(C[3]), .Gi(G[3]), .Pi(P[3]), .Si(S[3]));
            
endmodule