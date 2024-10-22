`timescale 1ns / 1ps

module vga_controller_tb;

    // Testbench signals
    reg clk;
    reg reset;
    wire [9:0] h_count;
    wire [9:0] v_count;
    wire h_sync;
    wire v_sync;
    wire video_on;
    wire [9:0] x_pos;
    wire [9:0] y_pos;

    // Instantiate the VGA Controller
    vga_controller uut (
        .clk(clk),
        .reset(reset),
        .h_count(h_count),
        .v_count(v_count),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .video_on(video_on),
        .x_pos(x_pos),
        .y_pos(y_pos)
    );

    // Clock generation
    always begin
        clk = 0;
        #5;  // 5 ns high
        clk = 1;
        #5;  // 5 ns low
    end

    // Test sequence
    initial begin
        // Initialize inputs
        reset = 1;

        // Apply reset
        #100;
        reset = 0;

        // Run for a few frames
        #16800000;  // Run for about 2 frames (16.8 ms)

        // End simulation
        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t, h_count=%0d, v_count=%0d, h_sync=%b, v_sync=%b, video_on=%b, x_pos=%0d, y_pos=%0d",
                 $time, h_count, v_count, h_sync, v_sync, video_on, x_pos, y_pos);
    end

endmodule
