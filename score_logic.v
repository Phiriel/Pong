module score_logic (
    input wire clk,
    input wire reset,
    input wire hit_left,        // Indicates successful hit by left paddle
    input wire hit_right,       // Indicates successful hit by right paddle
    input wire miss_left,       // Indicates left player missed the ball
    input wire miss_right,      // Indicates right player missed the ball
    output reg [3:0] score_left, // 4-bit score for left player
    output reg [3:0] score_right, // 4-bit score for right player
    output reg game_over         // Game over signal
);

    // Parameter for winning score
    parameter WINNING_SCORE = 4'b1010; // 10 points as the winning score

    // Score update logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            score_left <= 4'b0000;
            score_right <= 4'b0000;
            game_over <= 1'b0;
        end else begin
            // Increment scores on miss
            if (miss_left && !game_over)
                score_right <= score_right + 1;
            if (miss_right && !game_over)
                score_left <= score_left + 1;

            // Check for winning score
            if (score_left >= WINNING_SCORE || score_right >= WINNING_SCORE)
                game_over <= 1'b1;
        end
    end

endmodule