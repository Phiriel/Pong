module top (
    input wire clk,             // System clock
    input wire reset,           // Global reset
    input wire [1:0] btn_right, // Buttons for right paddle
    input wire [1:0] btn_left,  // Buttons for left paddle
    output wire h_sync,         // Horizontal sync for VGA
    output wire v_sync,         // Vertical sync for VGA
    output wire video_on,       // VGA video signal enable
    output wire [11:0] rgb      // RGB color output for VGA
);

    // Internal signals
    wire [9:0] x_pos, y_pos;
    wire graph_on;
    wire hit, miss;
    wire timer_up;
    wire [3:0] score_left, score_right;
    wire game_over;
    reg gra_still;

    // Instantiate VGA Controller
    vga_controller vga_inst (
        .clk(clk),
        .reset(reset),
        .h_count(x_pos),
        .v_count(y_pos),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .video_on(video_on)
    );

    // Instantiate Pong Graphics Module
    pong_graph pong_graph_inst (
        .clk(clk),
        .reset(reset),
        .btn_right(btn_right),
        .btn_left(btn_left),
        .gra_still(gra_still),
        .video_on(video_on),
        .x(x_pos),
        .y(y_pos),
        .graph_on(graph_on),
        .hit(hit),
        .miss(miss),
        .graph_rgb(rgb)
    );

    // Instantiate Timer Module
    timer timer_inst (
        .clk(clk),
        .reset(reset),
        .timer_start(game_over),
        .timer_tick(timer_up),
        .timer_up(timer_up)
    );

    // Instantiate Font Module
    fonts font_inst (
        .digit(score_left),      // Use score_left or score_right for display
        .row(y_pos[2:0]),        // Map y_pos to the row index (3 LSBs)
        .col(x_pos[2:0]),        // Map x_pos to the column index (3 LSBs)
        .font_pixel(font_pixel)  // Output pixel value
    );

    // Instantiate Score Logic Module
    score_logic score_logic_inst (
        .clk(clk),
        .reset(reset),
        .hit_left(hit),              // Connect hits to score logic
        .hit_right(hit),             // Reuse hit for both paddles if needed
        .miss_left(miss),            // Miss detection for left paddle
        .miss_right(miss),           // Miss detection for right paddle
        .score_left(score_left),
        .score_right(score_right),
        .game_over(game_over)
    );

    // Logic to control game state
    always @(posedge clk or posedge reset) begin
        if (reset)
            gra_still <= 1'b0;
        else if (game_over)
            gra_still <= 1'b1; // Freeze game when game over
        else
            gra_still <= 1'b0;
    end

endmodule
