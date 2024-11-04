`timescale 1ns / 1ps

module font_tb;

    // Inputs
    reg clk;
    reg [7:0] ascii_code;
    reg [2:0] row;

    // Output
    wire [4:0] font_data;

    // Declare the loop variable outside of the initial block
    integer col;

    // Instantiate the font module
    font uut (
        .clk(clk),
        .ascii_code(ascii_code),
        .row(row),
        .font_data(font_data)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        ascii_code = 8'h41; // ASCII code for 'A'
        row = 6;            // Start with the last row (to display from top to bottom)

        $display("Character: A (ASCII: %h)", ascii_code);
        $display("Font Representation:");

        // Test all rows for the character 'A'
        repeat (7) begin
            #10; // Wait for 10 ns to observe the output

            // Display the font row visually
            $write("Row %d: ", 6 - row);
            for (col = 0; col < 5; col = col + 1) begin
                if (font_data[col] == 1)
                    $write("*"); // Pixel is on
                else
                    $write(" "); // Pixel is off
            end
            $write("\n");

            row = row - 1; // Decrement the row index to move from top to bottom
        end

        // End simulation
        #10 $stop;
    end

endmodule