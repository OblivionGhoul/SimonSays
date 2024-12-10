module memory(
		input logic[5:0] data_In,  // 6 bits per location
		input logic[4:0] w_ptr,     // 5 bits for 30 locations
		input logic[4:0] r_ptr,     // 5 bits for 30 locations
		input logic w_en, r_en, clk,
		output logic[5:0] data_Out  // 6 bits per location
	);		

	logic [1:0] mem [29:0];  // 30 locations with 2 bits each

	always_ff@(negedge clk) begin
		if (w_en)
			mem[w_ptr] <= data_In;

		if (r_en)
			data_Out <= mem[r_ptr];
	end
	
endmodule