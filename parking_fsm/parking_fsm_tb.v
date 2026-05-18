`timescale 1ns/1ps
module parking_fsm_tb;
    reg clk;
    reg rst_n;
    reg entrance_sensor;
    reg exit_sensor;
    reg [3:0] pw;
    wire entrance_gate;
    wire exit_gate;
    parking_fsm dut (
        .clk(clk),
        .rst_n(rst_n),
        .entrance_sensor(entrance_sensor),
        .exit_sensor(exit_sensor),
        .pw(pw),
        .entrance_gate(entrance_gate),
        .exit_gate(exit_gate)
    );
    // clk 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    initial begin
        // dump wave
        $dumpfile("parking_fsm.vcd");
        $dumpvars(0, parking_fsm_tb);
        // init values
        rst_n = 0;
        entrance_sensor = 0;
        exit_sensor = 0;
        pw = 4'b0000;
        // reset
        #12;
        rst_n = 1;
        // Car arrives at entrance
        #10;
        entrance_sensor = 1;
        @(posedge clk);
        #1 pw = 4'b1010;   // correct pw already present
        // wait long enough for counter to reach 5
        repeat (6) @(posedge clk);
        // Entrance gate open
        #2;
        // car passes gate-> entrance sensor clears
        entrance_sensor = 0;
        repeat (2) @(posedge clk);
        // STEP 3: Car inside parking, now goes to exit
        #10;
        exit_sensor = 1;
        pw = 4'b0011;   // wrong pw first try
        // first wait period
        repeat (6) @(posedge clk);
        // STEP 4: First exit attempt fails, stay locked
        #10;
        @(posedge clk);
        #1 pw = 4'b1010;// second try correct
        // second wait period
        repeat (6) @(posedge clk);
        // STEP 5: Exit gate opens, car leaves
        #2;
        exit_sensor = 0;
        repeat (3) @(posedge clk);
        $finish;
    end
endmodule