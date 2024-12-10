module sevenSeg(
	input logic [5:0] result_data,
	output logic [6:0] high_digit_display,
	output logic [6:0] low_digit_display
);

	logic [3:0] tens_digit;
	logic [3:0] units_digit;

	always_comb begin
		tens_digit = result_data / 10;
		units_digit = result_data % 10;

		high_digit_display = 7'b1111111;
		low_digit_display = 7'b1111111;

		case (tens_digit)
			4'd0: high_digit_display = 7'b1000000;//0
			4'd1: high_digit_display = 7'b1111001;//1
			4'd2: high_digit_display = 7'b0100100;//2
			4'd3: high_digit_display = 7'b0110000;//3
			4'd4: high_digit_display = 7'b0011001;//4
			4'd5: high_digit_display = 7'b0010010;//5
			4'd6: high_digit_display = 7'b0000010;//6
			4'd7: high_digit_display = 7'b1111000;//7
			4'd8: high_digit_display = 7'b0000000;//8
			4'd9: high_digit_display = 7'b0010000;//9
			default: high_digit_display = 7'b1111111;
		endcase

		case (units_digit)
			4'd0: low_digit_display = 7'b1000000;//0
			4'd1: low_digit_display = 7'b1111001;//1
			4'd2: low_digit_display = 7'b0100100;//2
			4'd3: low_digit_display = 7'b0110000;//3
			4'd4: low_digit_display = 7'b0011001;//4
			4'd5: low_digit_display = 7'b0010010;//5
			4'd6: low_digit_display = 7'b0000010;//6
			4'd7: low_digit_display = 7'b1111000;//7
			4'd8: low_digit_display = 7'b0000000;//8
			4'd9: low_digit_display = 7'b0010000;//9
			default: low_digit_display = 7'b1111111;
		endcase
	end

endmodule
