module ram_single(q, a, d, we, clk);
output[7:0] q; //data at memory loc
input [7:0] d; //input data
input [6:0] a; //address
input we, clk;
reg [7:0] mem [127:0];
always @(posedge clk) begin
if (we)
mem[a] <= d;
end
assign q = mem[a];
endmodule




module ram_dual(q1, q2, a1, a2, d1, d2, we1, we2, clk1, clk2);
output[7:0] q1, q2;
input [7:0] d1, d2;
input [6:0] a1, a2;
input we1, we2, clk1, clk2;
reg [7:0] mem [127:0];
always @(posedge clk1) begin
if (we1)
mem[a1] <= d1;
end
assign q1 = mem[a1];


always @(posedge clk2) begin
if (we2)
mem[a2] <= d2;
end
assign q2 = mem[a2];
endmodule


module ram_dual_true(q1, q2, a1, a2, d1, d2, we1, we2, clk);
output[7:0] q1, q2;
input [7:0] d1, d2;
input [6:0] a1, a2;
input we1, we2, clk;
reg [7:0] mem [127:0];
always @(posedge clk) begin
if (we1)
mem[a1] <= d1;
if (we2)
mem[a2] <= d2;
end
assign q1 = mem[a1];
assign q2 = mem[a2];
endmodule
