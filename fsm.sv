module fsm (
    input  logic        clk,
    input  logic        rst,
    input  logic [3:0]  btn,
    input  logic [1:0]  random_seq,
    output logic [3:0]  led,
    output logic        sound,
    output logic [9:0]  frequency,
    output logic        start_round,
    output logic        display_loss,
    output logic        mem_write,
    output logic [4:0]  mem_addr,
    input  logic [1:0]  mem_data
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
    logic [1:0] player_input;

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
        start_round  = 0;
        display_loss = 0;
        mem_write    = 0;
        mem_addr     = 0;
        frequency    = 0;
        led          = 4'b0000;
        next_state   = state;

        case (state)
            STATE_POWER_ON: begin
                led = 4'b1111;
                if (btn != 4'b0000) next_state = STATE_INIT;
            end

            STATE_INIT: begin
                mem_write   = 1;
                mem_addr    = 0;
                start_round = 1;
                seq_length  = 1;
                next_state  = STATE_PLAY_SEQUENCE;
            end

            STATE_PLAY_SEQUENCE: begin
                mem_addr = seq_counter;
                led[mem_data] = 1;
                frequency = GAME_TONES[mem_data];
                if (seq_counter == seq_length - 1) 
                    next_state = STATE_WAIT_INPUT;
                else 
                    seq_counter = seq_counter + 1;
            end

            STATE_WAIT_INPUT: begin
                if (btn != 4'b0000) begin
                    case (btn)
                        4'b0001: player_input = 0;
                        4'b0010: player_input = 1;
                        4'b0100: player_input = 2;
                        4'b1000: player_input = 3;
                        default: player_input = 0;
                    endcase
                    next_state = STATE_VALIDATE_INPUT;
                end
            end

            STATE_VALIDATE_INPUT: begin
                mem_addr = seq_counter;
                if (player_input == mem_data) begin
                    if (seq_counter == seq_length - 1) 
                        next_state = STATE_NEXT_ROUND;
                    else 
                        seq_counter = seq_counter + 1;
                end else begin
                    next_state = STATE_GAME_OVER;
                end
            end

            STATE_NEXT_ROUND: begin
                mem_write  = 1;
                mem_addr   = seq_length;
                seq_length = seq_length + 1;
                seq_counter = 0;
                next_state = STATE_PLAY_SEQUENCE;
            end

            STATE_GAME_OVER: begin
                display_loss = 1;
                if (btn != 4'b0000) next_state = STATE_POWER_ON;
            end
        endcase
    end

endmodule
