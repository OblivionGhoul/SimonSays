module fsm (
    input  logic clk,
    input  logic rst,
    input  logic [15:0] ticks_per_milli,
    input  logic [3:0] btn,
    output logic [3:0] led,
    output logic sound
);

    localparam MAX_GAME_LEN = 32;

    // Game tones for different levels
    logic [9:0] GAME_TONES[3:0] = '{196, 262, 330, 784};  // G3, C4, E4, G5
    logic [9:0] SUCCESS_TONES[6:0] = '{330, 392, 659, 523, 587, 784, 0};  // E4, G4, E5, C5, D5, G5, silence
    logic [9:0] GAMEOVER_TONES[3:0] = '{622, 587, 554, 523};  // D#5, D5, C#5, C5

    // States
    localparam StatePowerOn = 0;
    localparam StateInit = 1;
    localparam StatePlay = 2;
    localparam StatePlayWait = 3;
    localparam StateUserWait = 4;
    localparam StateUserInput = 5;
    localparam StateNextLevel = 6;
    localparam StateGameOver = 7;

    // Internal signals
    logic [4:0] seq_counter;
    logic [4:0] seq_length;
    logic [1:0] seq[MAX_GAME_LEN-1:0];
    logic [2:0] state;
    logic [15:0] tick_counter;
    logic [9:0] millis_counter;
    logic [2:0] tone_sequence_counter;
    logic [9:0] sound_freq;
    logic [1:0] next_random;
    logic [1:0] user_input;

    // Instance of play module for tone generation
    Tone_Generator play1 (
        .clk(clk),
        .rst(rst),
        .ticks_per_milli(ticks_per_milli),
        .freq(sound_freq),
        .sound(sound)
    );

    always_ff @(posedge clk) begin
        if (rst) begin
            seq_length <= 0;
            seq_counter <= 0;
            tick_counter <= 0;
            millis_counter <= 0;
            sound_freq <= 0;
            next_random <= 0;
            state <= StatePowerOn;
            seq[0] <= 0;
            led <= 4'b0000;
        end else begin
            tick_counter <= tick_counter + 1;
            next_random <= next_random + 1;

            if (tick_counter == ticks_per_milli) begin
                tick_counter <= 0;
                millis_counter <= millis_counter + 1;
            end

            case (state)
                StatePowerOn: begin
                    led <= 4'b1111;
                    led[millis_counter[9:8]] <= 1'b0;
                    if (btn != 0) begin
                        state <= StateInit;
                        led <= 4'b0000;
                        millis_counter <= 0;
                    end
                end
                StateInit: begin
                    seq[0] <= next_random;
                    seq_length <= 1;
                    seq_counter <= 0;
                    tone_sequence_counter <= 0;
                    if (millis_counter == 500) begin
                        state <= StatePlay;
                    end
                end
                StatePlay: begin
                    led <= 0;
                    led[seq[seq_counter]] <= 1'b1;
                    sound_freq <= GAME_TONES[seq[seq_counter]];
                    millis_counter <= 0;
                    state <= StatePlayWait;
                end
                StatePlayWait: begin
                    if (millis_counter == 300) begin
                        led <= 0;
                        sound_freq <= 0;
                    end
                    if (millis_counter == 400) begin
                        if (seq_counter + 1 == seq_length) begin
                            state <= StateUserWait;
                            millis_counter <= 0;
                            seq_counter <= 0;
                        end else begin
                            seq_counter <= seq_counter + 1;
                            state <= StatePlay;
                        end
                    end
                end
                StateUserWait: begin
                    led <= 0;
                    millis_counter <= 0;
                    if (btn != 0) begin
                        state <= StateUserInput;
                        case (btn)
                            4'b0001: user_input <= 0;
                            4'b0010: user_input <= 1;
                            4'b0100: user_input <= 2;
                            4'b1000: user_input <= 3;
                            default: state <= StateUserWait;
                        endcase
                    end
                end
                StateUserInput: begin
                    led <= 0;
                    led[user_input] <= 1'b1;
                    sound_freq <= GAME_TONES[user_input];
                    if (millis_counter == 300) begin
                        sound_freq <= 0;
                        if (user_input == seq[seq_counter]) begin
                            if (seq_counter + 1 == seq_length) begin
                                millis_counter <= 0;
                                seq[seq_length] <= next_random;
                                seq_length <= seq_length + 1;
                                state <= StateNextLevel;
                            end else begin
                                seq_counter <= seq_counter + 1;
                                state <= StateUserWait;
                            end
                        end else begin
                            millis_counter <= 0;
                            state <= StateGameOver;
                        end
                    end
                end
                StateNextLevel: begin
                    led <= 0;
                    if (millis_counter == 150) begin
                        if (tone_sequence_counter < 7) begin
                            sound_freq <= SUCCESS_TONES[tone_sequence_counter];
                        end else begin
                            sound_freq <= 0;
                            tone_sequence_counter <= 0;
                            seq_counter <= 0;
                            state <= StatePlay;
                        end
                        tone_sequence_counter <= tone_sequence_counter + 1;
                        millis_counter <= 0;
                    end
                end
                StateGameOver: begin
                    led <= millis_counter[7] ? 4'b1111 : 4'b0000;

                    if (tone_sequence_counter == 4) begin
                        sound_freq <= GAMEOVER_TONES[3] - 16 + millis_counter[4:0];
                        if (millis_counter == 1000) begin
                            tone_sequence_counter <= 7;
                            sound_freq <= 0;
                        end
                    end else if (millis_counter == 300) begin
                        if (tone_sequence_counter < 4) begin
                            sound_freq <= GAMEOVER_TONES[tone_sequence_counter[1:0]];
                            tone_sequence_counter <= tone_sequence_counter + 1;
                        end
                        millis_counter <= 0;
                    end

                    if (btn != 0) begin
                        led <= 4'b0000;
                        sound_freq <= 0;
                        millis_counter <= 0;
                        state <= StateInit;
                    end
                end
            endcase
        end
    end

endmodule
