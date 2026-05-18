module seven_segment_display(
//led0123 corresponds to D bus for visibility/ convenience
//Sg = seg[6]...Sa = seg[0]
//use input wire because, module is not the one driving it
    input wire [3:0]sw,
    output wire [3:0]led,
    output wire[6:0]seg
);

assign led = sw;
assign seg[6] = (~sw[3]&~sw[2]&~sw[1]) | (~sw[3]&sw[2]&sw[1]&sw[0]);
assign seg[5] = (~sw[3]&sw[1]&sw[0]) | (sw[3]&sw[2]&~sw[1]) | 
(~sw[3]&~sw[2]&sw[0])|(~sw[3]&~sw[2]&sw[1]);
assign seg[4] = (~sw[3]&sw[0])|(~sw[2]&~sw[1]&sw[0])|
(~sw[3]&sw[2]&~sw[1]);
assign seg[3] = (sw[2]&sw[1]&sw[0])|(~sw[2]&~sw[1]&sw[0])|
(sw[3]&~sw[2]&sw[1]&~sw[0])|(~sw[3]&sw[2]&~sw[1]&~sw[0]);
assign seg[2] = (sw[3]&sw[2]&sw[1])|(sw[3]&sw[2]&~sw[0])|
(~sw[3]&~sw[2]&sw[1]&~sw[0]);
assign seg[1] = (sw[3]&sw[1]&sw[0])|(sw[2]&sw[1]&~sw[0])|(sw[3]&sw[2]&~sw[0])|
(~sw[3]&sw[2]&~sw[1]&sw[0]);
assign seg[0] = (sw[3]&sw[2]&~sw[1])|(sw[2]&~sw[1]&~sw[0])|
(sw[3]&~sw[2]&sw[1]&sw[0])|(~sw[3]&~sw[2]&~sw[1]&sw[0]);    

endmodule
