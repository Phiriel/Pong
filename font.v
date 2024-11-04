module font (
    input wire clk,                 // Clock for synchronous ROM access
    input wire [7:0] ascii_code,    // ASCII code input
    input wire [2:0] row,           // Row index for 5x7 font pattern
    output reg [4:0] font_data      // 5-bit output for the row of the character
);

    // Array to store the 5x7 bit patterns for characters
    reg [34:0] character_array [0:18]; // 19 characters (0-9, G, A, M, E, O, V, R, S, T), each with 7 rows of 5 bits

    initial begin
        // Numbers 0-9
        character_array[0]  = 35'b00100_01010_10001_10001_10001_01010_00100; // '0'
        character_array[1]  = 35'b00100_01100_00100_00100_00100_00100_01110; // '1'
        character_array[2]  = 35'b01110_10001_00001_00010_00100_01000_11111; // '2'
        character_array[3]  = 35'b01110_10001_00001_00110_00001_10001_01110; // '3'
        character_array[4]  = 35'b00010_00110_01010_10010_11111_00010_00010; // '4'
        character_array[5]  = 35'b11111_10000_11110_00001_00001_10001_01110; // '5'
        character_array[6]  = 35'b00110_01000_10000_11110_10001_10001_01110; // '6'
        character_array[7]  = 35'b11111_00001_00010_00100_01000_01000_01000; // '7'
        character_array[8]  = 35'b01110_10001_10001_01110_10001_10001_01110; // '8'
        character_array[9]  = 35'b01110_10001_10001_01111_00001_10001_01110; // '9'
        
        // Letters for "GAME OVER" and "START"
        character_array[10] = 35'b01110_10001_10000_10111_10001_10001_01110; // 'G'
        character_array[11] = 35'b00100_01010_10001_11111_10001_10001_10001; // 'A'
        character_array[12] = 35'b10001_11011_10101_10001_10001_10001_10001; // 'M'
        character_array[13] = 35'b11111_10000_10000_11110_10000_10000_11111; // 'E'
        character_array[14] = 35'b01110_10001_10001_10001_10001_10001_01110; // 'O'
        character_array[15] = 35'b10001_10001_10001_01010_00100_00100_00100; // 'V'
        character_array[16] = 35'b11110_10001_10001_11110_10100_10010_10001; // 'R'
        character_array[17] = 35'b01110_10001_10000_01110_00001_10001_01110; // 'S'
        character_array[18] = 35'b11111_00100_00100_00100_00100_00100_00100; // 'T'
    end

    // Output the font data based on the ASCII code and row
    always @(posedge clk) begin
        case (ascii_code)
            8'h30: font_data <= character_array[0][row * 5 +: 5];  // '0'
            8'h31: font_data <= character_array[1][row * 5 +: 5];  // '1'
            8'h32: font_data <= character_array[2][row * 5 +: 5];  // '2'
            8'h33: font_data <= character_array[3][row * 5 +: 5];  // '3'
            8'h34: font_data <= character_array[4][row * 5 +: 5];  // '4'
            8'h35: font_data <= character_array[5][row * 5 +: 5];  // '5'
            8'h36: font_data <= character_array[6][row * 5 +: 5];  // '6'
            8'h37: font_data <= character_array[7][row * 5 +: 5];  // '7'
            8'h38: font_data <= character_array[8][row * 5 +: 5];  // '8'
            8'h39: font_data <= character_array[9][row * 5 +: 5];  // '9'
            8'h47: font_data <= character_array[10][row * 5 +: 5]; // 'G'
            8'h41: font_data <= character_array[11][row * 5 +: 5]; // 'A'
            8'h4D: font_data <= character_array[12][row * 5 +: 5]; // 'M'
            8'h45: font_data <= character_array[13][row * 5 +: 5]; // 'E'
            8'h4F: font_data <= character_array[14][row * 5 +: 5]; // 'O'
            8'h56: font_data <= character_array[15][row * 5 +: 5]; // 'V'
            8'h52: font_data <= character_array[16][row * 5 +: 5]; // 'R'
            8'h53: font_data <= character_array[17][row * 5 +: 5]; // 'S'
            8'h54: font_data <= character_array[18][row * 5 +: 5]; // 'T'
            default: font_data <= 5'b00000;                        // Default to blank
        endcase
    end

endmodule