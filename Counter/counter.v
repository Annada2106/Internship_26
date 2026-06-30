`timescale 1ns / 1ps

module counter_with_clock_divider(
    input clk,          // 100 MHz clock
    input reset,
    output reg [3:0] y
);


reg [25:0] count;
reg slow_clk;

// Clock Divider
always @(posedge clk or posedge reset)
begin
    if (reset)
    begin
        count <= 0;
        slow_clk <= 0;
    end
    else if (count == 49_999_999)
    begin
        count <= 0;
        slow_clk <= ~slow_clk;
    end
    else
        count <= count + 1;
end

// 4-bit Counter
always @(posedge slow_clk or posedge reset)
begin
    if (reset)
        y <= 4'b0000;
    else
        y <= y + 1'b1;
end
endmodule