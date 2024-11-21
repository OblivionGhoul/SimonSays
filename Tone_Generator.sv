module Tone_Generator (
    input  logic clk,
    input  logic rst,
    input  logic [15:0] ticks_per_milli,
    input  logic [9:0] freq,
    output logic sound
);

    logic [31:0] tick_counter;
    logic [31:0] ticks_per_second;

    always_ff @(posedge clk) begin
        if (rst) begin
            tick_counter <= 0;
            sound <= 0;
        end else if (freq == 0) begin
            sound <= 0;
        end else begin
            tick_counter <= tick_counter + freq;
            if (tick_counter >= (ticks_per_second >> 1)) begin
                sound <= ~sound;
                tick_counter <= tick_counter + freq - (ticks_per_second >> 1);
            end
        end
    end

    assign ticks_per_second = ticks_per_milli * 1000;

endmodule
