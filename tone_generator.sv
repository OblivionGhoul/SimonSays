// Module for tone generation
module tone_generator (
    input logic clk,
    input logic rst,
    input logic [15:0] ticks_per_ms,
    input logic [9:0] frequency,    // Frequency for the tone
    output logic sound              // Sound output
);
    logic [31:0] tick_counter;
    logic [31:0] ticks_per_second = ticks_per_ms * 1000;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            tick_counter <= 0;
            sound <= 0;
        end else if (frequency == 0) begin
            sound <= 0;
        end else begin
            tick_counter <= tick_counter + frequency;
            if (tick_counter >= (ticks_per_second >> 1)) begin
                sound <= ~sound;
                tick_counter <= tick_counter + frequency - (ticks_per_second >> 1);
            end
        end
    end
endmodule