`timescale 1ns / 1ps

module top_tb;

    // Inputs
    reg clk;
    reg reset;
    reg [1:0] btn_right;
    reg [1:0] btn_left;

    // Outputs
    wire h_sync;
    wire v_sync;
    wire video_on;
    wire [11:0] rgb;

    // Instantiate the top-level module
    top uut (
        .clk(clk),
        .reset(reset),
        .btn_right(btn_right),
        .btn_left(btn_left),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .video_on(video_on),
        .rgb(rgb)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        reset = 1;
        btn_right = 2'b00;
        btn_left = 2'b00;

        // Apply reset
        #20 reset = 0;

        // Simulate button presses for paddle movement
        #50 btn_right = 2'b10; // Move right paddle down
        #50 btn_right = 2'b01; // Move right paddle up
        #50 btn_right = 2'b00; // Stop right paddle
        #50 btn_left = 2'b10;  // Move left paddle down
        #50 btn_left = 2'b01;  // Move left paddle up
        #50 btn_left = 2'b00;  // Stop left paddle

        // Simulate some game activity
        #500;
        // Apply reset to observe reset behavior
        reset = 1;
        #20 reset = 0;

        // End simulation
        #1000 $stop;
    end

endmodule