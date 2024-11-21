module a_assert_s_deassert(
		input logic clk,
		input logic key,
		output logic key_sync 
	);

	logic intKey;
	logic res;

	always_ff @(posedge clk or negedge key) begin
		if (!key) begin
			intKey <= 1'b0; // Asynchronous assert
			res <= 1'b0;
		end else begin
			intKey <= 1'b1; // Synchronized deassert
			res <= intKey;
		end
	end
	
	assign key_sync = ~res;

endmodule