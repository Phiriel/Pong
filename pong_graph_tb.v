`timescale 1ns / 1ps

module pong_graph_tb;

    // Inputs
    reg clk;
    reg reset;
    reg [1:0] btn_right; // Right paddle control
    reg [1:0] btn_left;  // Left paddle control
    reg gra_still;
    reg video_on;
    reg [9:0] x;
    reg [9:0] y;

    // Outputs
    wire graph_on;
    wire hit;
    wire miss;
    wire [11:0] graph_rgb;

    // Instantiate the Unit Under Test (UUT)
    pong_graph uut (
        .clk(clk),  
        .reset(reset),    
        .btn_right(btn_right), 
        .btn_left(btn_left),  
        .gra_still(gra_still),       
        .video_on(video_on),
        .x(x),
        .y(y),
        .graph_on(graph_on),
        .hit(hit),
        .miss(miss),
        .graph_rgb(graph_rgb)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // Simulation control
    initial begin
        // Initialize inputs
        reset = 1;
        btn_right = 2'b00;
        btn_left = 2'b00;
        gra_still = 0;
        video_on = 1;
        x = 0;
        y = 0;

        // Apply reset
        #20 reset = 0;

        // Test paddle movement and ball dynamics
        // Move right paddle up
        #1000;
        btn_right = 2'b01; // Right paddle up
        #200;
        btn_right = 2'b00; // Stop movement

        // Move right paddle down
        #500;
        btn_right = 2'b10; // Right paddle down
        #200;
        btn_right = 2'b00; // Stop movement

        // Move left paddle up
        #1000;
        btn_left = 2'b01; // Left paddle up
        #200;
        btn_left = 2'b00; // Stop movement

        // Move left paddle down
        #500;
        btn_left = 2'b10; // Left paddle down
        #200;
        btn_left = 2'b00; // Stop movement

        // Simulate gra_still (pause game)
        #1000;
        gra_still = 1;
        #500;
        gra_still = 0;

        // Simulate video_on being turned off
        #1000;
        video_on = 0;
        #500;
        video_on = 1;

        // Run simulation for a while to observe behavior
        #10000;
        $stop;
    end

    // Simulate VGA scanning of the screen
    initial begin
        x = 0;
        y = 0;
        forever begin
            #1;
            x = x + 1;
            if (x > 639) begin
                x = 0;
                y = y + 1;
                if (y > 479) y = 0;
            end
        end
    end

    // Monitor key signals for debugging
    initial begin
        $monitor("Time = %0t, x = %d, y = %d, hit = %b, miss = %b, graph_on = %b, graph_rgb = %h", 
                 $time, x, y, hit, miss, graph_on, graph_rgb);
    end

endmodule
