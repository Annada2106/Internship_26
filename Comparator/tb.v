`timescale 1ns / 1ps

module comp(
    input a,b,c,d,e,f,g,h,
    output H,L,E
    );
    assign H=({a,b,c,d}>{e,f,g,h})?1:0;
    assign E=({a,b,c,d}=={e,f,g,h})?1:0;
    assign L=({a,b,c,d}<{e,f,g,h})?1:0;  
endmodule
