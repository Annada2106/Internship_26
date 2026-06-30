`timescale 1ns / 1ps

module mux2x1(
    input a,b,s0,
    output y
    );
    assign y=s0?b:a;
endmodule

module mux4x1(
    input i0,i1,i2,i3,S0,S1,
    output Y
    );
    wire n1,n2;
    mux2x1 m1(i0,i1,S0,n1);
    mux2x1 m2(i2,i3,S0,n2);
    mux2x1 m3(n1,n2,S1,Y);
endmodule