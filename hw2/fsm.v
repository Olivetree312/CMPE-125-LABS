`timescale 1ns / 1ps
module fsm (
    input  wire clk,
    input  wire A,
    input  wire B,
    output wire Z
);
    reg S;

    //D-FF = state register: store An-1
    always @(posedge clk) begin
        //at edge, RHS A is evaluated, state update is only SCHEDULED
        //S will not change immediately because NONBLOCKING ASSINGMENT
        S <= A;
    end
    //output logic (verilog is concurrent, not sequential)
    //Z equation still uses the old S
    assign Z = (~B * (A * S)) | (B * (A + S));

endmodule
