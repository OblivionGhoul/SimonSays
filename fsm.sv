module fsm (
    input  logic        clk,
    input  logic        rst,
    input  logic [3:0]  btn,
    input  logic [1:0]  random_seq,
    output logic [3:0]  led,
    output logic        sound,
    output logic [9:0]  frequency,  // New output to control tone frequency
    output logic        start_round,
    output logic        display_loss,
    input  logic        correct_input,
    input  logic        end_of_sequence
);

    typedef enum logic [2:0] {
        STATE_POWER_ON,
        STATE_INIT,
        STATE_PLAY_SEQUENCE,
        STATE_WAIT_INPUT,
        STATE_VALIDATE_INPUT,
        STATE_NEXT_ROUND,
        STATE_GAME_OVER
    } state_t;

    state_t state, next_state;
    logic [4:0] seq_length;
    logic [4:0] seq_counter;

    // Game tone frequencies
    logic [9:0] GAME_TONES [3:0];
    assign GAME_TONES[0] = 196;  // G3
    assign GAME_TONES[1] = 262;  // C4
    assign GAME_TONES[2] = 330;  // E4
    assign GAME_TONES[3] = 784;  // G5

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state       <= STATE_POWER_ON;
            seq_length  <= 0;
            seq_counter <= 0;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        // Default outputs
        start_round  = 0;
        display_loss = 0;
        frequency    = 0;
        led          = 4'b0000;
        next_state   = state;

        case (state)
            STATE_POWER_ON: begin
                led = 4'b1111;
                if (btn != 4'b0000) next_state = STATE_INIT;
            end

            STATE_INIT: begin
                seq_length = 1;
                start_round = 1;
                next_state = STATE_PLAY_SEQUENCE;
            end

            STATE_PLAY_SEQUENCE: begin
                led[random_seq] = 1;
                frequency = GAME_TONES[random_seq]; // Assign frequency to current tone
                if (end_of_sequence) next_state = STATE_WAIT_INPUT;
            end

            STATE_WAIT_INPUT: begin
                if (btn != 4'b0000) next_state = STATE_VALIDATE_INPUT;
            end

            STATE_VALIDATE_INPUT: begin
                frequency = GAME_TONES[btn]; // Emit tone for user input
                if (correct_input) begin
                    if (seq_counter == seq_length - 1) 
                        next_state = STATE_NEXT_ROUND;
                    else 
                        next_state = STATE_WAIT_INPUT;
                end else begin
                    next_state = STATE_GAME_OVER;
                end
            end

            STATE_NEXT_ROUND: begin
                seq_length = seq_length + 1;
                start_round = 1;
                next_state = STATE_PLAY_SEQUENCE;
            end

            STATE_GAME_OVER: begin
                display_loss = 1;
                frequency = 0; // Silence during game over
                if (btn != 4'b0000) next_state = STATE_POWER_ON;
            end
        endcase
    end

endmodule
