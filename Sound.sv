module Sound (
    input  logic        clk,        // Clock signal
    input  logic        rst,        // Reset signal
    input  logic [3:0]  led_color,  // Each bit represents a color state (Red, Blue, Green, Yellow)
    output logic        sound,      // Sound output signal
    output logic [9:0]  frequency   // Sound frequency output
);

    // Define frequency mapping for each color as constants
    localparam logic [9:0] RED_FREQ    = 10'd440; // Red corresponds to tone A (440Hz)
    localparam logic [9:0] BLUE_FREQ   = 10'd494; // Blue corresponds to tone B (494Hz)
    localparam logic [9:0] GREEN_FREQ  = 10'd523; // Green corresponds to tone C (523Hz)
    localparam logic [9:0] YELLOW_FREQ = 10'd587; // Yellow corresponds to tone D (587Hz)

    // Intermediate register for selected frequency
    logic [9:0] selected_frequency;

    always_comb begin
        // Default outputs
        selected_frequency = 10'd0;
        sound = 0;

        // Prioritize LED color for frequency selection
        if (led_color[0]) begin
            selected_frequency = RED_FREQ; // Red
            sound = 1;
        end else if (led_color[1]) begin
            selected_frequency = BLUE_FREQ; // Blue
            sound = 1;
        end else if (led_color[2]) begin
            selected_frequency = GREEN_FREQ; // Green
            sound = 1;
        end else if (led_color[3]) begin
            selected_frequency = YELLOW_FREQ; // Yellow
            sound = 1;
        end else begin
            selected_frequency = 10'd0; // No color active
            sound = 0;
        end
    end

    // Assign selected frequency to output
    assign frequency = selected_frequency;

endmodule
