`timescale 1ns / 1ps

module siso_tb;

reg clk;
reg reset;
reg a;
wire [3:0] y;

siso uut (
    .clk(clk),
    .reset(reset),
    .a(a),
    .y(y)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    reset = 1;
    a = 0;
    #20;
    reset = 0;

    #1000000000 a = 1;
    #1000000000 a = 0;
    #1000000000 a = 1;
    #1000000000 a = 1;
    #1000000000 a = 0;
    #1000000000;

    $finish;
end

endmodule