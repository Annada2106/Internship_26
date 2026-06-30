`timescale 1ns / 1ps

module rtc_tb;

    reg clk;
    reg reset;
    reg snooze;

    wire [5:0] hour_out;
    wire [5:0] min_out;
    wire [5:0] sec_out;
    wire buzzer;

    rtc uut (
        .clk(clk),
        .reset(reset),
        .snooze(snooze),
        .hour_out(hour_out),
        .min_out(min_out),
        .sec_out(sec_out),
        .buzzer(buzzer)
    );

    // 100 MHz clock
    initial
    begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus
    initial
    begin
        reset = 1;
        snooze = 0;

        #20;
        reset = 0;

        // Press snooze once
        #100;
        snooze = 1;

        #10;
        snooze = 0;

        #2000000000;
        $finish;
    end

    initial
    begin
        $monitor("Time=%0d:%0d:%0d Alarm=%0d:%0d:%0d Buzzer=%b",
                 hour_out,min_out,sec_out,
                 uut.hour_in,uut.min_in,uut.sec_in,
                 buzzer);
    end

endmodule