`timescale 1ns/1ps
module alu_tb;
//testing w 32
    parameter N = 32;
    reg  [N-1:0] A;
    reg  [N-1:0] B;
    reg  [2:0]   F;
    wire [N-1:0] Y;
    wire         Cout;
    wire         OV;
    wire         ZF;
    reg  [N-1:0] expected_Y;
    reg          expected_Cout;
    reg          expected_OV;
    reg          expected_ZF;

    integer vecfile;
    integer r;
    integer testnum;
    integer errors;
    alu #(N) dut (
        .A(A),
        .B(B),
        .F(F),
        .Y(Y),
        .Cout(Cout),
        .OV(OV),
        .ZF(ZF)
    );
    initial begin
        errors  = 0;
        testnum = 0;
        A = 0;
        B = 0;
        F = 0;
        expected_Y = 0;
        expected_Cout = 0;
        expected_OV = 0;
        expected_ZF = 0;
        vecfile = $fopen("alu_vectors.txt", "r");
        if (vecfile == 0) begin
            $display("ERROR: could not open alu_vectors.txt");
            $stop;
        end
        // File format per line:
        // A B F expected_Y expected_Cout expected_OV expected_ZF
        while (!$feof(vecfile)) begin
            r = $fscanf(vecfile, "%h %h %b %h %b %b %b\n",
                        A, B, F, expected_Y, expected_Cout, expected_OV, expected_ZF);
            if (r == 7) begin
                testnum = testnum + 1;
                #10;
                if ((Y !== expected_Y) ||
                    (Cout !== expected_Cout) ||
                    (OV !== expected_OV) ||
                    (ZF !== expected_ZF)) begin

                    $display("FAIL [%0d]: A=%h B=%h F=%b | Y=%h Cout=%b OV=%b ZF=%b | expected Y=%h Cout=%b OV=%b ZF=%b",
                             testnum, A, B, F, Y, Cout, OV, ZF,
                             expected_Y, expected_Cout, expected_OV, expected_ZF);
                    errors = errors + 1;
                end
                else begin
                    $display("PASS [%0d]: A=%h B=%h F=%b | Y=%h Cout=%b OV=%b ZF=%b",
                             testnum, A, B, F, Y, Cout, OV, ZF);
                end
            end
        end
        $fclose(vecfile);
        if (errors == 0)
            $display("All vector tests PASSED.");
        else
            $display("Vector testing complete: %0d test(s) FAILED.", errors);
        $stop;
    end
endmodule