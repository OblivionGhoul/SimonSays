// Core Simon Says Game Module
module simon_game (
    input logic clk,
    input logic rst,
    input logic [15:0] ticks_per_ms,
    input logic [3:0] btn_inputs,   // Button inputs
    output logic [3:0] led_outputs, // LED outputs
    output logic sound_output       // Sound output
);

    // Parameters for game states
    typedef enum logic [2:0] {
        STATE_POWER_ON,
        STATE_INIT,
        STATE_PLAY,
        STATE_PLAY_WAIT,
        STATE_USER_WAIT,
        STATE_USER_INPUT,
        STATE_NEXT_LEVEL,
        STATE_GAME_OVER
    } game_state_t;

    // Game parameters
    localparam int MAX_SEQUENCE_LENGTH = 32;

    // Tone definitions
    logic [9:0] GAME_TONES[3:0] = {196, 262, 330, 784}; // Tones for buttons
    logic [9:0] SUCCESS_TONES[6:0] = {330, 392, 659, 523, 587, 784, 0}; // Success tones
    logic [9:0] GAMEOVER_TONES[3:0] = {622, 587, 554, 523}; // Game over tones

    // Game state variables
    game_state_t current_state;
    logic [4:0] sequence_counter, sequence_length;
    logic [1:0] sequence[MAX_SEQUENCE_LENGTH - 1:0]; // Random sequence storage
    logic [15:0] tick_counter;
    logic [9:0] millis_counter;
    logic [9:0] current_frequency;
    logic [1:0] next_random_value, user_input;
    logic [2:0] tone_sequence_counter;

    // Tone generation instance
    tone_generator tone_inst (
        .clk(clk),
        .rst(rst),
        .ticks_per_ms(ticks_per_ms),
        .frequency(current_frequency),
        .sound(sound_output)
    );

    // Main game logic
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset game state and variables
            current_state <= STATE_POWER_ON;
            sequence_length <= 0;
            sequence_counter <= 0;
            tick_counter <= 0;
            millis_counter <= 0;
            current_frequency <= 0;
            next_random_value <= 0;
            sequence[0] <= 0;
            led_outputs <= 4'b0000;
        end else begin
            tick_counter <= tick_counter + 1;
            next_random_value <= next_random_value + 1;

            if (tick_counter == ticks_per_ms) begin
                tick_counter <= 0;
                millis_counter <= millis_counter + 1;
            end

            case (current_state)
                STATE_POWER_ON: begin
                    led_outputs <= 4'b1111;
                    led_outputs[millis_counter[9:8]] <= 1'b0;
                    if (btn_inputs != 0) begin
                        current_state <= STATE_INIT;
                        led_outputs <= 4'b0000;
                        millis_counter <= 0;
                    end
                end
                STATE_INIT: begin
                    sequence[0] <= next_random_value;
                    sequence_length <= 1;
                    sequence_counter <= 0;
                    tone_sequence_counter <= 0;
                    if (millis_counter == 500) begin
                        current_state <= STATE_PLAY;
                    end
                end
                STATE_PLAY: begin
                    led_outputs <= 4'b0000;
                    led_outputs[sequence[sequence_counter]] <= 1'b1;
                    current_frequency <= GAME_TONES[sequence[sequence_counter]];
                    millis_counter <= 0;
                    current_state <= STATE_PLAY_WAIT;
                end
                STATE_PLAY_WAIT: begin
                    if (millis_counter == 300) begin
                        led_outputs <= 4'b0000;
                        current_frequency <= 0;
                    end
                    if (millis_counter == 400) begin
                        if (sequence_counter + 1 == sequence_length) begin
                            current_state <= STATE_USER_WAIT;
                            millis_counter <= 0;
                            sequence_counter <= 0;
                        end else begin
                            sequence_counter <= sequence_counter + 1;
                            current_state <= STATE_PLAY;
                        end
                    end
                end
                STATE_USER_WAIT: begin
                    led_outputs <= 4'b0000;
                    millis_counter <= 0;
                    if (btn_inputs != 0) begin
                        current_state <= STATE_USER_INPUT;
                        user_input = btn_inputs == 4'b0001 ? 2'b00 :
                                     btn_inputs == 4'b0010 ? 2'b01 :
                                     btn_inputs == 4'b0100 ? 2'b10 :
                                     btn_inputs == 4'b1000 ? 2'b11 : user_input;
                    end
                end
                STATE_USER_INPUT: begin
                    led_outputs[user_input] <= 1'b1;
                    current_frequency <= GAME_TONES[user_input];
                    if (millis_counter == 300) begin
                        current_frequency <= 0;
                        if (user_input == sequence[sequence_counter]) begin
                            if (sequence_counter + 1 == sequence_length) begin
                                millis_counter <= 0;
                                sequence[sequence_length] <= next_random_value;
                                sequence_length <= sequence_length + 1;
                                current_state <= STATE_NEXT_LEVEL;
                            end else begin
                                sequence_counter <= sequence_counter + 1;
                                current_state <= STATE_USER_WAIT;
                            end
                        end else begin
                            current_state <= STATE_GAME_OVER;
                        end
                    end
                end
                STATE_NEXT_LEVEL: begin
                    if (millis_counter == 150) begin
                        if (tone_sequence_counter < 7) begin
                            current_frequency <= SUCCESS_TONES[tone_sequence_counter];
                            tone_sequence_counter <= tone_sequence_counter + 1;
                        end else begin
                            tone_sequence_counter <= 0;
                            current_state <= STATE_PLAY;
                        end
                        millis_counter <= 0;
                    end
                end
                STATE_GAME_OVER: begin
                    led_outputs <= millis_counter[7] ? 4'b1111 : 4'b0000;
                    if (btn_inputs != 0) begin
                        current_state <= STATE_INIT;
                        led_outputs <= 4'b0000;
                    end
                end
            endcase
        end
    end
endmodule