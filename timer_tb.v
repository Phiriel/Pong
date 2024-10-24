`timescale 1ns / 1ps

module timer_tb;

    // Inputs
    reg clk;
    reg reset;
    reg timer_start;
    reg timer_tick;

    // Outputs
    wire timer_up;

    // Instantiate the Unit Under Test (UUT)
    timer uut (
        .clk(clk), 
        .reset(reset), 
        .timer_start(timer_start), 
        .timer_tick(timer_tick), 
        .timer_up(timer_up)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Test scenario
    initial begin
        // Initialize Inputs
        reset = 1;
        timer_start = 0;
        timer_tick = 0;

        // Wait for global reset
        #100;
        reset = 0;

        // Test case 1: Start timer and let it count down
        #10 timer_start = 1;
        #10 timer_start = 0;
        
        // Apply timer ticks
        repeat(130) begin
            #10 timer_tick = 1;
            #10 timer_tick = 0;
        end

        // Test case 2: Reset timer during countdown
        #50 reset = 1;
        #10 reset = 0;

        // Test case 3: Start timer again and interrupt with timer_start
        #10 timer_start = 1;
        #10 timer_start = 0;
        
        repeat(50) begin
            #10 timer_tick = 1;
            #10 timer_tick = 0;
        end

        #10 timer_start = 1;
        #10 timer_start = 0;

        repeat(130) begin
            #10 timer_tick = 1;
            #10 timer_tick = 0;
        end

        // End simulation
        #100 $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time=%t, reset=%b, start=%b, tick=%b, up=%b", 
                 $time, reset, timer_start, timer_tick, timer_up);
    end

endmodule
