// Top-Level Module
module simon_says_top (
    input logic clk,             // Clock signal
    input logic rst,             // Reset signal
    input logic btn[3:0],        // Button inputs
    output logic led[3:0],       // LED outputs
    output logic sound           // Sound output
);

    logic [15:0] ticks_per_ms = 50; // Clock ticks per millisecond

    simon_game game_inst (
        .clk(clk),
        .rst(rst),
        .ticks_per_ms(ticks_per_ms),
        .btn_inputs(btn),
        .led_outputs(led),
        .sound_output(sound)
    );

endmodule