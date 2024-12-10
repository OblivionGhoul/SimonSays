module tb_memory();

	// Inputs
	logic[5:0] data_Input;
	logic[4:0] write_ptr;
	logic[4:0] read_ptr;
	logic write_enable, read_enable;
	logic clk = 1'b0;
	
	// Outputs
	logic [5:0] data_Output;
	
	// Connect to Memory
	memory inst_Mem(.clk(clk), .data_In(data_Input), .w_ptr(write_ptr), .r_ptr(read_ptr), .w_en(write_enable), .r_en(read_enable), .data_Out(data_Output));
	
	// Clock generation
	always #50 clk <= ~clk;
	
	// Read task
	task Mem_Read(input logic [4:0] r_ptr_in, input logic r_en_in, input logic [5:0] expected_data_out);
		@(negedge clk)
		read_ptr <= r_ptr_in;
		read_enable <= r_en_in;
		
		@(posedge clk)
		@(posedge clk)
		#1 assert(expected_data_out == data_Output) // Read operation verification
			$display("Read operation successful. Time: %t, expected read_ptr = %b, read_ptr = %b, expected read_en = %b, read_en = %b, expected data_out = %b, data_out = %b", $time, read_ptr, r_ptr_in, read_enable, r_en_in, data_Output, expected_data_out);
		else // Read operation failure
			$display("Read operation failed. Time: %t, expected read_ptr = %b, read_ptr = %b, expected read_en = %b, read_en = %b, expected data_out = %b, data_out = %b", $time, read_ptr, r_ptr_in, read_enable, r_en_in, data_Output, expected_data_out);
		
	endtask
	
	// Write task
	task Mem_Write(input logic [4:0] w_ptr_in, input logic w_en_in, input logic [5:0] data_in);
		@(negedge clk)
		write_ptr <= w_ptr_in;
		write_enable <= w_en_in;
		data_Input <= data_in;
		
		@(posedge clk)
		if(write_enable == 1'b1) // Write enabled
			#1 $display("Writing data. Time: %t, data_Input = %b, write_ptr = %b, write_enable = %b", $time, data_in, w_ptr_in, w_en_in);
		else // Write disabled 
			#1 $display("Data not written. Time: %t, data_Input = %b, write_ptr = %b, write_enable = %b", $time, data_in, w_ptr_in, w_en_in);
	endtask
	
	initial 
	begin
		// Write: write_ptr, write_enable, data_Input
		Mem_Write(5'd0, 1'b1, 6'd0);
		Mem_Write(5'd1, 1'b1, 6'd1);
		Mem_Write(5'd2, 1'b1, 6'd2);
		Mem_Write(5'd3, 1'b1, 6'd3);
		
		// Read: read_ptr, read_enable, data_Output
		Mem_Read(5'd0, 1'b1, 6'd0);
		Mem_Read(5'd1, 1'b1, 6'd1);
		Mem_Read(5'd2, 1'b1, 6'd2);
		Mem_Read(5'd3, 1'b1, 6'd3);

	end
endmodule
