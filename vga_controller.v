module vga_controller (
    input wire clk,           // 100 MHz clock
    input wire reset,         // Reset signal
    output reg [9:0] h_count, // Horizontal counter
    output reg [9:0] v_count, // Vertical counter
    output reg h_sync,        // Horizontal sync
    output reg v_sync,        // Vertical sync
    output reg video_on,      // Video on/off signal
    output wire [9:0] x_pos,  // Current pixel X position
    output wire [9:0] y_pos   // Current pixel Y position
);

    // Timing constants for 640x480 @ 60Hz
    parameter H_DISPLAY = 640;
    parameter H_FRONT_PORCH = 16;
    parameter H_SYNC_PULSE = 96;
    parameter H_BACK_PORCH = 48;
    parameter H_TOTAL = H_DISPLAY + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;

    parameter V_DISPLAY = 480;
    parameter V_FRONT_PORCH = 10;
    parameter V_SYNC_PULSE = 2;
    parameter V_BACK_PORCH = 33;
    parameter V_TOTAL = V_DISPLAY + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;

    // Counter logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            h_count <= 0;
            v_count <= 0;
        end else begin
            if (h_count == H_TOTAL - 1) begin
                h_count <= 0;
                if (v_count == V_TOTAL - 1)
                    v_count <= 0;
                else
                    v_count <= v_count + 1;
            end else begin
                h_count <= h_count + 1;
            end
        end
    end

    // Sync signal generation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            h_sync <= 1'b1;
            v_sync <= 1'b1;
        end else begin
            h_sync <= (h_count < (H_DISPLAY + H_FRONT_PORCH) || 
                       h_count >= (H_TOTAL - H_BACK_PORCH)) ? 1'b1 : 1'b0;
            v_sync <= (v_count < (V_DISPLAY + V_FRONT_PORCH) || 
                       v_count >= (V_TOTAL - V_BACK_PORCH)) ? 1'b1 : 1'b0;
        end
    end

    // Video on/off signal
    always @(posedge clk or posedge reset) begin
        if (reset)
            video_on <= 1'b0;
        else
            video_on <= (h_count < H_DISPLAY) && (v_count < V_DISPLAY);
    end

    // Current pixel position
    assign x_pos = (h_count < H_DISPLAY) ? h_count : 10'd0;
    assign y_pos = (v_count < V_DISPLAY) ? v_count : 10'd0;

endmodule
