`timescale 1ns/1ps
module tb;
reg [3:0] sw;
wire [3:0] led;
wire[6:0] seg;

seven_segment_display dut(
.sw(sw), 
.led(led),
.seg(seg)
);

integer i;
initial begin

$monitor("Time=%0t | sw=%b led=%b -> seg=%b",
            $time, sw, led, seg);
for(i=0; i<16; i=i+1)begin
    sw=i;
    #10;
end

$finish;
end

endmodule