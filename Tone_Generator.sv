module Tone_Generator (
		input  logic        clk,
		input  logic        rst,
		input  logic [9:0]  frequency,
		output logic        sound
	);

    logic [31:0] tick_counter;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            tick_counter <= 0;
            sound <= 0;
        end else if (frequency == 0) begin
            sound <= 0;
        end else begin
            tick_counter <= tick_counter + frequency;
            if (tick_counter >= 500000) begin
                sound <= ~sound;
                tick_counter <= tick_counter - 500000;
            end
        end
    end

endmodule
