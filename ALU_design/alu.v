//board uses N=4
module alu_wrapper (
    input  wire       clk,
    input  wire [10:0] sw,
    output reg  [6:0] seg,
    output reg  [3:0] an
);
    wire [3:0] Y;
    wire Cout, OV, ZF;
    alu #(4) dut (
        .A(sw[7:4]),
        .B(sw[3:0]),
        .F(sw[10:8]),
        .Y(Y),
        .Cout(Cout),
        .OV(OV),
        .ZF(ZF)
    );
    reg [1:0] sel = 2'b00;
    reg [15:0] refresh_counter = 16'd0;
    reg [3:0] digit;
    // refresh counter for multiplexing
    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
        sel <= refresh_counter[15:14];
    end
    // choose which digit is active
    always @(*) begin
        case (sel)
            2'b00: begin
                an = 4'b1110; // an0 active
                digit = Y; // show Y in hex
            end
            2'b01: begin
                an = 4'b1101;  // an1 active
                digit = {3'b000, Cout};
            end
            2'b10: begin
                an = 4'b1011;  // an2 active
                digit = {3'b000, OV};
            end
            2'b11: begin
                an = 4'b0111; // an3 active
                digit = {3'b000, ZF};
            end
            default: begin
                an = 4'b1111;
                digit = 4'b0000;
            end
        endcase
    end
    // hex to 7-segment decoder (active low)
    always @(*) begin
        case (digit)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            4'hA: seg = 7'b0001000;
            4'hB: seg = 7'b0000011;
            4'hC: seg = 7'b1000110;
            4'hD: seg = 7'b0100001;
            4'hE: seg = 7'b0000110;
            4'hF: seg = 7'b0001110;
            default: seg = 7'b1111111;
        endcase
    end
endmodule

module alu #(parameter N = 32) (
    input  wire [N-1:0] A,
    input  wire [N-1:0] B,
    input  wire [2:0]   F,
    output reg  [N-1:0] Y,
    output wire Cout,
    output wire OV,
    output wire ZF
);
    wire [N-1:0] BB;
    wire [N-1:0] and_out;
    wire [N-1:0] or_out;
    wire [N:0]   S; // N+1 bits so we can keep Cout
    // f2 selects BB
    assign BB = (F[2]) ? ~B : B;
    // Parallel logic paths
    assign and_out = A & BB;
    assign or_out  = A | BB;
    // add
    assign S = A + BB + F[2];
    // final output select
    always @(*) begin
        case (F[1:0])
            2'b00: Y = and_out;
            2'b01: Y = or_out;
            2'b10: Y = S[N-1:0];
            2'b11: Y = {{N-1{1'b0}}, S[N-1]};
            default: Y = {N{1'b0}};
        endcase
    end
    // Cout
    assign Cout = S[N];
    // overflow 
    assign OV = (~(A[N-1] ^ BB[N-1])) & (A[N-1] ^ S[N-1]);
    // ZF
    assign ZF = ~|Y;
endmodule