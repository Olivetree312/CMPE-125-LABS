`timescale 1ns/1ps
// we[23] a[22:16] d[15:8] expected_q[7:0]
module tb_ram_single;
    reg         clk;
    reg         we;
    reg  [6:0]  a;
    reg  [7:0]  d;
    wire [7:0]  q;

    reg [23:0] testvectors [0:100];
    reg [23:0] current_vector;
    integer i, errors;
    reg [7:0] expected_q;
    ram_single dut (
        .q(q),
        .a(a),
        .d(d),
        .we(we),
        .clk(clk)
    );
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        we = 0;
        a  = 0;
        d  = 0;
        errors = 0;
        $readmemb("ram_single_vectors.tv", testvectors);
        $display("Starting tb_ram_single...");
        i = 0;
        while (testvectors[i] !== 24'bxxxxxxxxxxxxxxxxxxxxxxxx) begin
            current_vector = testvectors[i];
            we = current_vector[23];
            a = current_vector[22:16];
            d = current_vector[15:8];
            expected_q = current_vector[7:0];
            #2;
            if (we) begin
                @(posedge clk);
                #1;end 
            else begin
                #2;
            end
            if (q !== expected_q) begin
                $display("ERROR [single] vector=%0d we=%b a=%0d d=%h q=%h expected=%h",
                         i, we, a, d, q, expected_q);
                errors = errors + 1;
            end else begin
                $display("PASS  [single] vector=%0d we=%b a=%0d d=%h q=%h",
                         i, we, a, d, q);
            end
            i = i + 1;
            #3;
        end
        $display("tb_ram_single complete. Errors = %0d", errors);
        $finish;
    end
endmodule

//50 bits total
// we1[49] we2[48] selclk[47:46] a1[45:39] a2[38:32]
// d1[31:24] d2[23:16] expected_q1[15:8] expected_q2[7:0]
// selclk:
// 00 = no clock edge
// 01 = pulse clk1 only
// 10 = pulse clk2 only
// 11 = pulse clk1 then clk2
module tb_ram_dual;
    reg         clk1, clk2;
    reg         we1, we2;
    reg  [6:0]  a1, a2;
    reg  [7:0]  d1, d2;
    wire [7:0]  q1, q2;
    
    reg [49:0] testvectors [0:100];
    reg [49:0] current_vector;
    integer i, errors;
    reg [1:0] selclk;
    reg [7:0] expected_q1, expected_q2;
    ram_dual dut (
        .q1(q1), .q2(q2),
        .a1(a1), .a2(a2),
        .d1(d1), .d2(d2),
        .we1(we1), .we2(we2),
        .clk1(clk1), .clk2(clk2)
    );
    initial begin
        clk1 = 0;
        clk2 = 0;
        we1  = 0;
        we2  = 0;
        a1   = 0;
        a2   = 0;
        d1   = 0;
        d2   = 0;
        errors = 0;
        $readmemb("ram_dual_vectors.tv", testvectors);
        $display("Starting tb_ram_dual...");
        i = 0;
        while (testvectors[i] !== 50'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx) begin
            current_vector = testvectors[i];
            we1 = current_vector[49];
            we2 = current_vector[48];
            selclk = current_vector[47:46];
            a1 = current_vector[45:39];
            a2 = current_vector[38:32];
            d1 = current_vector[31:24];
            d2 = current_vector[23:16];
            expected_q1 = current_vector[15:8];
            expected_q2 = current_vector[7:0];
            #2;
            case (selclk)
                2'b00: begin
                    #2;
                end
                2'b01: begin
                    clk1 = 1; #1; clk1 = 0; #1;
                end
                2'b10: begin
                    clk2 = 1; #1; clk2 = 0; #1;
                end
                2'b11: begin
                    clk1 = 1; #1; clk1 = 0; #1;
                    clk2 = 1; #1; clk2 = 0; #1;
                end
            endcase
            #1;
            if ((q1 !== expected_q1) || (q2 !== expected_q2)) begin
                $display("ERROR [dual] vector=%0d we1=%b we2=%b selclk=%b a1=%0d a2=%0d d1=%h d2=%h q1=%h exp1=%h q2=%h exp2=%h",
                         i, we1, we2, selclk, a1, a2, d1, d2, q1, expected_q1, q2, expected_q2);
                errors = errors + 1;
            end else begin
                $display("PASS  [dual] vector=%0d q1=%h q2=%h",
                         i, q1, q2);
            end
            i = i + 1;
            #3;
        end
        $display("tb_ram_dual complete. Errors = %0d", errors);
        $finish;
    end
endmodule
//(48 bits total):
// we1[47] we2[46] a1[45:39] a2[38:32]
// d1[31:24] d2[23:16] expected_q1[15:8] expected_q2[7:0]
module tb_ram_dual_true;
    reg         clk;
    reg         we1, we2;
    reg  [6:0]  a1, a2;
    reg  [7:0]  d1, d2;
    wire [7:0]  q1, q2;
    
    reg [47:0] testvectors [0:100];
    reg [47:0] current_vector;
    integer i, errors;
    reg [7:0] expected_q1, expected_q2;
    ram_dual_true dut (
        .q1(q1), .q2(q2),
        .a1(a1), .a2(a2),
        .d1(d1), .d2(d2),
        .we1(we1), .we2(we2),
        .clk(clk)
    );
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        we1 = 0;
        we2 = 0;
        a1  = 0;
        a2  = 0;
        d1  = 0;
        d2  = 0;
        errors = 0;
        $readmemb("ram_dual_true_vectors.tv", testvectors);
        $display("Starting tb_ram_dual_true...");
        i = 0;
        while (testvectors[i] !== 48'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx) begin
            current_vector = testvectors[i];
            we1         = current_vector[47];
            we2         = current_vector[46];
            a1          = current_vector[45:39];
            a2          = current_vector[38:32];
            d1          = current_vector[31:24];
            d2          = current_vector[23:16];
            expected_q1 = current_vector[15:8];
            expected_q2 = current_vector[7:0];
            #2;
            if (we1 || we2) begin
                @(posedge clk);
                #1;
            end else begin
                #2;
            end
            if ((q1 !== expected_q1) || (q2 !== expected_q2)) begin
                $display("ERROR [dual_true] vector=%0d we1=%b we2=%b a1=%0d a2=%0d d1=%h d2=%h q1=%h exp1=%h q2=%h exp2=%h",
                         i, we1, we2, a1, a2, d1, d2, q1, expected_q1, q2, expected_q2);
                errors = errors + 1;
            end else begin
                $display("PASS  [dual_true] vector=%0d q1=%h q2=%h",
                         i, q1, q2);
            end
            i = i + 1;
            #3;
        end
        $display("tb_ram_dual_true complete. Errors = %0d", errors);
        $finish;
    end
endmodule