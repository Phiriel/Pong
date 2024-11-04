`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2024 02:46:52 PM
// Design Name: 
// Module Name: pong_graphics
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pong_graph(
    input clk,  
    input reset,    
    input [1:0] btn_right, // button for right
    input [1:0] btn_left,  // button for left    
    input gra_still,        // still graphics - newgame, game over states
    input video_on,
    input [9:0] x,
    input [9:0] y,
    output graph_on,
    output reg hit, miss,   // ball hit or miss
    output reg [11:0] graph_rgb
    );
    
    // maximum x, y values in display area
    parameter X_MAX = 639;
    parameter Y_MAX = 479;
    
    // create 60Hz refresh tick
    wire refresh_tick;
    assign refresh_tick = (y == 481) && (x == 0); // start of vsync(vertical retrace)
    
    
    // wall boundaries
    // Top and bottom wall
    // TOP wall boundaries
    parameter T_WALL_T = 64;    
    parameter T_WALL_B = 71;    // 8 pixels wide
    // BOTTOM wall boundaries
    parameter B_WALL_T = 472;    
    parameter B_WALL_B = 479;    // 8 pixels wide
    
    
    
    // PADDLE parameters
    // paddle horizontal boundaries
    parameter X_PAD_LEFT_L = 32; //Left paddle position
    parameter X_PAD_LEFT_R = 35; // 4 pixels wide
    parameter X_PAD_RIGHT_L = 600; //right paddle position
    parameter X_PAD_RIGHT_R = 603; // 4 pixels wide
    parameter PAD_HEIGHT = 72;
    wire [9:0] y_pad_left_t, y_pad_left_b;
    wire [9:0] y_pad_right_t, y_pad_right_b;
    reg [9:0] y_pad_left_reg = 204;  // Left paddle starting position
    reg [9:0] y_pad_right_reg = 204; // Right paddle starting position
    reg [9:0] y_pad_left_next;
    reg [9:0] y_pad_right_next;
    parameter PAD_VELOCITY = 3;
    
     // Ball parameters
    parameter BALL_SIZE = 8;
    wire [9:0] x_ball_l, x_ball_r;
    wire [9:0] y_ball_t, y_ball_b;
    reg [9:0] y_ball_reg, x_ball_reg;
    wire [9:0] y_ball_next, x_ball_next;
    reg [9:0] x_delta_reg, x_delta_next;
    reg [9:0] y_delta_reg, y_delta_next;
    parameter BALL_VELOCITY_POS = 2;
    parameter BALL_VELOCITY_NEG = -2;
    wire [2:0] rom_addr, rom_col;
    reg [7:0] rom_data;
    wire rom_bit;
    
     // Clock Gating for Power Optimization
    wire clk_gated;
    wire enable_game_logic = video_on & ~gra_still;

    
    // ball rom
    always @*
        case(rom_addr)
            3'b000 :    rom_data = 8'b00111100; //   ****  
            3'b001 :    rom_data = 8'b01111110; //  ******
            3'b010 :    rom_data = 8'b11111111; // ********
            3'b011 :    rom_data = 8'b11111111; // ********
            3'b100 :    rom_data = 8'b11111111; // ********
            3'b101 :    rom_data = 8'b11111111; // ********
            3'b110 :    rom_data = 8'b01111110; //  ******
            3'b111 :    rom_data = 8'b00111100; //   ****
        endcase
    
    
    // OBJECT STATUS SIGNALS
    wire t_wall_on, b_wall_on, pad_left_on, pad_right_on, sq_ball_on, ball_on;
    wire [11:0] wall_rgb, pad_rgb, ball_rgb, bg_rgb;
    
    
    // pixel within wall boundaries
    assign t_wall_on = (T_WALL_T <= y) && (y <= T_WALL_B);
    assign b_wall_on = (B_WALL_T <= y) && (y <= B_WALL_B);
    
    
    // assign object colors
    assign wall_rgb   = 12'hd98c8c;    // brown walls
    assign pad_rgb    = 12'hd98c8c;    // brown paddle
    assign ball_rgb   = 12'hffff00;    // yellow ball
    assign bg_rgb     = 12'h808080;    // black background
    
    
    // paddle 
    assign y_pad_left_t = y_pad_left_reg;
    assign y_pad_left_b = y_pad_left_t + PAD_HEIGHT - 1;
    assign y_pad_right_t = y_pad_right_reg;
    assign y_pad_right_b = y_pad_right_t + PAD_HEIGHT - 1;
    assign pad_left_on = (X_PAD_LEFT_L <= x) && (x <= X_PAD_LEFT_R) && (y_pad_left_t <= y) && (y <= y_pad_left_b);
    assign pad_right_on = (X_PAD_RIGHT_L <= x) && (x <= X_PAD_RIGHT_R) && (y_pad_right_t <= y) && (y <= y_pad_right_b);
       
                    
    // Paddle Control
    always @* begin
        y_pad_left_next = y_pad_left_reg;
        y_pad_right_next = y_pad_right_reg;
        
        if (refresh_tick) begin
            // Left paddle movement
            if (btn_left[1] && (y_pad_left_b < (B_WALL_T - 1 - PAD_VELOCITY)))
                y_pad_left_next = y_pad_left_reg + PAD_VELOCITY;
            else if (btn_left[0] && (y_pad_left_t > (T_WALL_B + PAD_VELOCITY)))
                y_pad_left_next = y_pad_left_reg - PAD_VELOCITY;
            
            // Right paddle movement
            if (btn_right[1] && (y_pad_right_b < (B_WALL_T - 1 - PAD_VELOCITY)))
                y_pad_right_next = y_pad_right_reg + PAD_VELOCITY;
            else if (btn_right[0] && (y_pad_right_t > (T_WALL_B + PAD_VELOCITY)))
                y_pad_right_next = y_pad_right_reg - PAD_VELOCITY;
        end
    end
    
    
    // rom data square boundaries
    assign x_ball_l = x_ball_reg;
    assign y_ball_t = y_ball_reg;
    assign x_ball_r = x_ball_l + BALL_SIZE - 1;
    assign y_ball_b = y_ball_t + BALL_SIZE - 1;
    // pixel within rom square boundaries
    assign sq_ball_on = (x_ball_l <= x) && (x <= x_ball_r) &&
                        (y_ball_t <= y) && (y <= y_ball_b);
    // map current pixel location to rom addr/col
    assign rom_addr = y[2:0] - y_ball_t[2:0];   // 3-bit address
    assign rom_col = x[2:0] - x_ball_l[2:0];    // 3-bit column index
    assign rom_bit = rom_data[rom_col];         // 1-bit signal rom data by column
    // pixel within round ball
    assign ball_on = sq_ball_on & rom_bit;      // within square boundaries AND rom data bit == 1
 
  
    // new ball position
    assign x_ball_next = (gra_still) ? X_MAX / 2 :
                         (refresh_tick) ? x_ball_reg + x_delta_reg : x_ball_reg;
    assign y_ball_next = (gra_still) ? Y_MAX / 2 :
                         (refresh_tick) ? y_ball_reg + y_delta_reg : y_ball_reg;
    
    // change ball direction after collision
    always @* begin
        hit = 1'b0;
        miss = 1'b0;
        x_delta_next = x_delta_reg;
        y_delta_next = y_delta_reg;

        if (gra_still) begin
            x_delta_next = BALL_VELOCITY_NEG;
            y_delta_next = BALL_VELOCITY_POS;
        end else if (y_ball_t < T_WALL_B) begin
            y_delta_next = BALL_VELOCITY_POS;
        end else if (y_ball_b > B_WALL_T) begin
            y_delta_next = BALL_VELOCITY_NEG;
        end else if ((X_PAD_LEFT_L <= x_ball_l) && (x_ball_l <= X_PAD_LEFT_R) && (y_pad_left_t <= y_ball_b) && (y_ball_t <= y_pad_left_b)) begin
            x_delta_next = BALL_VELOCITY_POS;
            hit = 1'b1;
        end else if ((X_PAD_RIGHT_L <= x_ball_r) && (x_ball_r <= X_PAD_RIGHT_R) && (y_pad_right_t <= y_ball_b) && (y_ball_t <= y_pad_right_b)) begin
            x_delta_next = BALL_VELOCITY_NEG;
            hit = 1'b1;
        end else if (x_ball_r > X_MAX || x_ball_l < 0) begin
            miss = 1'b1;
        end
    end                    
    
    // output status signal for graphics 
    assign graph_on = t_wall_on | b_wall_on | pad_left_on | pad_right_on | ball_on;
    
    
    // rgb multiplexing circuit
    always @*
        if(~video_on)
            graph_rgb = 12'h000;      // no value, blank
        else
            if(t_wall_on | b_wall_on)
                graph_rgb = wall_rgb;     // wall color
            else if(pad_left_on || pad_right_on)
                graph_rgb = pad_rgb;      // paddle color
            else if(ball_on)
                graph_rgb = ball_rgb;     // ball color
            else
                graph_rgb = bg_rgb;       // background
       

    
endmodule
