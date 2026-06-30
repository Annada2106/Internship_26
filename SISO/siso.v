`timescale 1ns / 1ps

module siso(
    input clk,        // 100 MHz FPGA clock
    input reset,
    input a,        // Serial input
    output [3:0] y   // LEDs to observe shifting
);

reg [25:0] count;
reg slow_clk;
reg [3:0] shift_reg;

// Clock Divider
always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        count <= 0;
        slow_clk <= 0;
    end
    else if(count == 49_999_999)
    begin
        count <= 0;
        slow_clk <= ~slow_clk;
    end
    else
        count <= count + 1;
end

// SISO Shift Register
always @(posedge slow_clk or posedge reset)
begin
    if(reset)
        shift_reg <= 4'b0000;
    else
        shift_reg <= {shift_reg[2:0], a};
end
assign y    = shift_reg;   // Connect to LEDs
endmodule