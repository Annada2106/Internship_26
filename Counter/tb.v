`timescale 1ns / 1ps

module counter_with_clock_divider_tb;

reg clk;
reg reset;
wire [3:0] y;

counter_with_clock_divider uut (
    .clk(clk),
    .reset(reset),
    .y(y)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    reset = 1;
    #20;
    reset = 0;
    #1100000000;
    $finish;
end

endmodule