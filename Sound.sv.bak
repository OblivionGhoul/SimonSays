module Sound (
    input  logic        clk,        // Clock signal
    input  logic        rst,        // Reset signal
    input  logic [3:0]  led_color,  // Each bit represents a color state (Red, Blue, Green, Yellow)
    output logic        sound,      // Sound output signal
    output logic [9:0]  frequency   // Sound frequency output
);

    // Define frequency mapping for each color
    localparam logic [9:0] COLOR_TONES [3:0] = {
        10'd440, // Red corresponds to tone A (440Hz)
        10'd494, // Blue corresponds to tone B (494Hz)
        10'd523, // Green corresponds to tone C (523Hz)
        10'd587  // Yellow corresponds to tone D (587Hz)
    };

    // Intermediate register for selected frequency
    logic [9:0] selected_frequency;

    always_comb begin
        // Initialize outputs
        selected_frequency = 10'd0; // Default frequency is 0 (no sound)
        sound = 0; // Default sound is off

        // Select frequency based on the active LED color
        case (led_color)
            4'b0001: begin
                selected_frequency = COLOR_TONES[0]; // Red
                sound = 1; // Enable sound
            end
            4'b0010: begin
                selected_frequency = COLOR_TONES[1]; // Blue
                sound = 1; // Enable sound
            end
            4'b0100: begin
                selected_frequency = COLOR_TONES[2]; // Green
                sound = 1; // Enable sound
            end
            4'b1000: begin
                selected_frequency = COLOR_TONES[3]; // Yellow
                sound = 1; // Enable sound
            end
            default: begin
                selected_frequency = 10'd0; // No color active, no sound
                sound = 0; // Disable sound
            end
        endcase
    end

    // Assign selected frequency to output
    assign frequency = selected_frequency;

endmodule
