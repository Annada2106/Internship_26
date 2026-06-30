`timescale 1ns / 1ps

module rtc(
    input            clk,
    input            reset,
    input            snooze,
    output reg [5:0] hour_out,
    output reg [5:0] min_out,
    output reg [5:0] sec_out,
    output reg       buzzer
);

    // =========================================================================
    // Internal registers
    // =========================================================================
    reg [25:0] count;
    reg        slow_clk;

    reg [5:0]  hour_in;
    reg [5:0]  min_in;
    reg [5:0]  sec_in;
    
    
    // =========================================================================
    // Clock Divider  —  100 MHz → 1 Hz
    // slow_clk toggles every 0.5 s (50_000_000 cycles at 100 MHz)
    // =========================================================================
    always @(posedge clk or posedge reset)
    begin
        if (reset)
        begin
            count    <= 26'd0;
            slow_clk <= 1'b0;
        end
        else if (count == 26'd49_999_999)
        begin
            count    <= 26'd0;
            slow_clk <= ~slow_clk;
        end
        else
            count <= count + 26'd1;
    end

    // =========================================================================
    // RTC Counter  —  hh : mm : ss  (24-hour)
    // =========================================================================
    always @(posedge slow_clk or posedge reset)
    begin
        if (reset)
        begin
            sec_out  <= 6'd0;
            min_out  <= 6'd0;
            hour_out <= 6'd0;
            hour_in  <= 6'd0;
            min_in   <= 6'd0;
            sec_in   <= 6'd5;
        end
        else
        begin
            if (sec_out == 6'd59)
            begin
                sec_out <= 6'd0;
                if (min_out == 6'd59)
                begin
                    min_out <= 6'd0;
                    if (hour_out == 6'd23)
                        hour_out <= 6'd0;
                    else
                        hour_out <= hour_out + 6'd1;
                end
                else
                    min_out <= min_out + 6'd1;
            end
            else
                sec_out <= sec_out + 6'd1;
        end
    end

    // =========================================================================
    // Snooze Logic  —  advance alarm time by +2 minutes
    // =========================================================================
    always @(posedge snooze)
    begin
        if (min_in == 6'd58)
        begin
            if (hour_in == 6'd23)
            begin
                hour_in <= 6'd0;
                min_in  <= 6'd0;
            end
            else
            begin
                hour_in <= hour_in + 6'd1;  // FIX: now inside begin-end
                min_in  <= 6'd0;            // was outside else — now paired
            end
        end
        else if (min_in == 6'd59)
        begin
            if (hour_in == 6'd23)
            begin
                hour_in <= 6'd0;
                min_in  <= 6'd1;
            end
            else
            begin
                hour_in <= hour_in + 6'd1;  // FIX: same as above
                min_in  <= 6'd1;
            end
        end
        else
            min_in <= min_in + 6'd2;
    end

    // =========================================================================
    // Buzzer Comparator  —  fires when current time == alarm time
    // =========================================================================
    always @(*)
    begin
        if ((hour_in == hour_out) && (min_in == min_out) && (sec_in == sec_out))
            buzzer <= 1'b1;
        else
            buzzer <= 1'b0;
    end

endmodule