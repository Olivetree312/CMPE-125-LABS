`timescale 1ns/1ps

module tb;

  // DUT inputs
  reg  [3:0] A;
  reg  [3:0] B;
  reg        Cin;

  // DUT outputs
  wire [3:0] S;
  wire       Co;
  wire       PG;
  wire       GG;
  wire [3:0] G;
  wire [3:0] P;
  wire [4:0] C;

  // Instantiate DUT
  CLA4 dut (
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

  integer ai, bi, ci;
  reg [4:0] expected;
  integer errors;

  initial begin
    errors = 0;

    $display(" A    B   Cin | Co  S  | expected | PG GG | C");
    $display("-------------------------------------------------------");

    for (ai = 0; ai < 16; ai = ai + 1) begin
      for (bi = 0; bi < 16; bi = bi + 1) begin
        for (ci = 0; ci < 2; ci = ci + 1) begin
          A   = ai[3:0];
          B   = bi[3:0];
          Cin = ci[0];

          #1; // allow combinational logic to settle

          expected = A + B + Cin;

          // sum/carry correctness
          if ({Co, S} !== expected) begin
            errors = errors + 1;
            $display("FAIL: A=%h B=%h Cin=%b -> CoS=%b_%h expected=%b_%h  PG=%b GG=%b  C=%b",
                     A, B, Cin, Co, S, expected[4], expected[3:0], PG, GG, C);
          end
          else begin
            // print passes
            // $display("PASS: A=%h B=%h Cin=%b -> CoS=%b_%h expected=%b_%h  PG=%b GG=%b  C=%b",
            //          A, B, Cin, Co, S, expected[4], expected[3:0], PG, GG, C);
          end

          // C[0] should always equal Cin
          if (C[0] !== Cin) begin
            errors = errors + 1;
            $display("FAIL(C0): A=%h B=%h Cin=%b -> C[0]=%b", A, B, Cin, C[0]);
          end
          // Co should always equal C[4]
          if (Co !== C[4]) begin
            errors = errors + 1;
            $display("FAIL(Co): A=%h B=%h Cin=%b -> Co=%b C[4]=%b", A, B, Cin, Co, C[4]);
          end

        end
      end
    end

    if (errors == 0) begin
      $display("All tests PASSED.");
    end else begin
      $display("Tests finished with %0d error(s).", errors);
    end

    $finish;
  end

endmodule