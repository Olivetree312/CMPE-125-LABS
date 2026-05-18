`timescale 1ns / 1ps

module tb_vending;

    reg clk;
    reg [2:0] sw;
    wire [6:0] seg;
    wire [3:0] an;

    reg [15:0] testvectors [0:31];
    reg [15:0] tv;
    integer i;

    reg exp_dispense;
    reg exp_rn;
    reg exp_rd;
    reg exp_r2d;

    vending dut (
        .clk(clk),
        .sw(sw),
        .seg(seg),
        .an(an)
    );

    always #5 clk = ~clk;

task apply_coin;
    input [2:0] coin;
    begin
        @(negedge clk);
        sw = coin;

        @(posedge clk);

        @(negedge clk);
        sw = 3'b000;

        @(posedge clk);
        #1;
    end
endtask

    initial begin : done_tests
        clk = 0;
        sw  = 3'b000;

        $readmemb("test_vector.tv", testvectors);

        @(posedge clk);
        @(posedge clk);

        for (i = 0; i < 32; i = i + 1) begin
            tv = testvectors[i];

            if (tv === 16'bxxxxxxxxxxxxxxxx) begin
                $display("End of test vectors at index %0d", i);
                disable done_tests;
            end

            exp_dispense = tv[12];
            exp_rn       = tv[11];
            exp_rd       = tv[10];
            exp_r2d      = tv[9];

            apply_coin(tv[15:13]);
            #1

            if (dut.disp_latched !== exp_dispense ||
                dut.rn_latched   !== exp_rn ||
                dut.rd_latched   !== exp_rd ||
                dut.r2d_latched  !== exp_r2d) begin
                $display("ERROR at vector %0d", i);
                $display("coin=%b expected D=%b RN=%b RD=%b R2D=%b",
                         tv[15:13], exp_dispense, exp_rn, exp_rd, exp_r2d);
                $display("got           D=%b RN=%b RD=%b R2D=%b",
                         dut.disp_latched, dut.rn_latched, dut.rd_latched, dut.r2d_latched);
            end
            else begin
                $display("OK vector %0d", i);
            end
        end

        $display("Simulation finished.");
        $stop;
    end

endmodule