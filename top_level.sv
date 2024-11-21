module top_level (
    input  logic        CLK,
    input  logic        RST,
    input  logic [3:0]  BTN,
    output logic [3:0]  LED,
    output logic [6:0]  SEG_DISPLAY,
    output logic        SOUND
);

    logic [1:0] random_seq;
    logic       start_round, display_loss;
    logic       correct_input, end_of_sequence;

    // Instantiate Random Sequence Generator
    Random_Sequence_Generator rng (
        .clk(CLK),
        .rst(RST),
        .random_seq(random_seq)
    );

    // Instantiate FSM
    fsm fsm_inst (
        .clk(CLK),
        .rst(RST),
        .btn(BTN),
        .random_seq(random_seq),
        .led(LED),
        .sound(SOUND),
        .start_round(start_round),
        .display_loss(display_loss),
        .correct_input(correct_input),
        .end_of_sequence(end_of_sequence)
    );

    // Instantiate LED and 7-Segment Display Control
    LED_and_Display_Control led_disp_ctrl (
        .clk(CLK),
        .rst(RST),
        .seq_led(LED),
        .user_input(BTN),
        .display_loss(display_loss),
        .score(seq_length),
        .led(LED),
        .seg_display(SEG_DISPLAY)
    );

endmodule
