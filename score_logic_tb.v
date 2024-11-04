`timescale 1ns / 1ps

module Score_logic_tb;

    // Inputs
    reg clk;
    reg reset;
    reg hit_left;
    reg hit_right;
    reg miss_left;
    reg miss_right;

    // Outputs
    wire [3:0] score_left;
    wire [3:0] score_right;
    wire game_over;

    // Instantiate the Score_logic module
    Score_logic uut (
        .clk(clk),
        .reset(reset),
        .hit_left(hit_left),
        .hit_right(hit_right),
        .miss_left(miss_left),
        .miss_right(miss_right),
        .score_left(score_left),
        .score_right(score_right),
        .game_over(game_over)
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
        hit_left = 0;
        hit_right = 0;
        miss_left = 0;
        miss_right = 0;

        // Apply reset
        #10;
        reset = 0;

        // Simulate scoring events to reach game over
        #10 miss_left = 1;  // Right player scores: score_right = 1
        #10 miss_left = 0;
        #10 miss_left = 1;  // Right player scores: score_right = 2
        #10 miss_left = 0;
        #10 miss_left = 1;  // Right player scores: score_right = 3
        #10 miss_left = 0;
        #10 miss_left = 1;  // Right player scores: score_right = 4
        #10 miss_left = 0;
        #10 miss_left = 1;  // Right player scores: score_right = 5
        #10 miss_left = 0;
        #10 miss_left = 1;  // Right player scores: score_right = 6
        #10 miss_left = 0;
        #10 miss_left = 1;  // Right player scores: score_right = 7
        #10 miss_left = 0;
        #10 miss_left = 1;  // Right player scores: score_right = 8
        #10 miss_left = 0;
        #10 miss_left = 1;  // Right player scores: score_right = 9
        #10 miss_left = 0;
        #10 miss_left = 1;  // Right player scores: score_right = 10 (Game over)
        #10 miss_left = 0;

        // Check game over status
        #20;
        
        // Apply reset to check reset behavior
        reset = 1;
        #10 reset = 0;

        // End simulation
        #100 $stop;
    end

endmodule