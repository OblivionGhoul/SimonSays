module tb_memory_fsm();

	// Inputs
	logic clk = 1'b0;
	logic push_button, rst, operation_mode; // Mode: 0 for Read, 1 for Write
	
	// Outputs
	logic is_full, is_empty;
	logic [4:0]read_pointer; // 5 bits for 30 locations
	logic [4:0]write_pointer; // 5 bits for 30 locations
	logic write_active, read_active;

	// Clock generation
	always begin 
		#50; 
		clk = ~clk; 
	end
	
	// DUT instantiation
	memory_fsm fsm_inst(
		.clk(clk), 
		.button(push_button), 
		.reset(rst), 
		.mode(operation_mode), 
		.fifo_full(is_full), 
		.fifo_empty(is_empty), 
		.r_ptr(read_pointer), 
		.w_ptr(write_pointer), 
		.w_en(write_active), 
		.r_en(read_active)
	);
	
	// Read Task
	task read_test(input logic task_button, input logic task_reset, input logic task_mode, 
					input logic expected_empty, input logic [4:0]expected_pointer, input logic expected_read_active);
		@(negedge clk)
			push_button <= task_button;
			rst <= task_reset;
			operation_mode <= task_mode;
		 
		@(posedge clk)
			#10 if((expected_empty == is_empty) && (expected_pointer == read_pointer) && (expected_read_active == read_active))
				$display("PASS: READ at %0t. Button=%b Reset=%b Mode=%b Empty=%b Expected_Ptr=%b Read_Active=%b",
						 $time, push_button, rst, operation_mode, is_empty, read_pointer, read_active);
			else
				$display("FAIL: READ at %0t. Button=%b Reset=%b Mode=%b Empty=%b (Expected=%b) Ptr=%b (Expected=%b) Active=%b (Expected=%b)",
						 $time, push_button, rst, operation_mode, is_empty, expected_empty, read_pointer, expected_pointer, read_active, expected_read_active);
	endtask
	
	// Write Task
	task write_test(input logic task_button, input logic task_reset, input logic task_mode, 
					input logic expected_full, input logic [4:0]expected_pointer, input logic expected_write_active);
		@(negedge clk)
			push_button <= task_button;
			rst <= task_reset;
			operation_mode <= task_mode;
		 
		@(posedge clk)
			#10 if((expected_full == is_full) && (expected_pointer == write_pointer) && (expected_write_active == write_active))
				$display("PASS: WRITE at %0t. Button=%b Reset=%b Mode=%b Full=%b Expected_Ptr=%b Write_Active=%b",
						 $time, push_button, rst, operation_mode, is_full, write_pointer, write_active);
			else
				$display("FAIL: WRITE at %0t. Button=%b Reset=%b Mode=%b Full=%b (Expected=%b) Ptr=%b (Expected=%b) Active=%b (Expected=%b)",
						 $time, push_button, rst, operation_mode, is_full, expected_full, write_pointer, expected_pointer, write_active, expected_write_active);
	endtask
	
	// Test Sequences
	initial begin
		// Write Tests
		$display("WRITE TESTS");
		write_test(1'b0, 1'b0, 1'b1, 1'b0, 5'd0, 1'b0);
		write_test(1'b1, 1'b0, 1'b1, 1'b0, 5'd1, 1'b1);
		write_test(1'b1, 1'b0, 1'b1, 1'b0, 5'd2, 1'b1);
		write_test(1'b1, 1'b0, 1'b1, 1'b0, 5'd3, 1'b1);
		write_test(1'b1, 1'b1, 1'b1, 1'b0, 5'd0, 1'b0);
		write_test(1'b1, 1'b0, 1'b1, 1'b0, 5'd1, 1'b1);
		write_test(1'b1, 1'b0, 1'b1, 1'b1, 5'd29, 1'b1);

		// Read Tests
		$display("READ TESTS");
		read_test(1'b0, 1'b0, 1'b0, 1'b1, 5'd0, 1'b0);
		read_test(1'b1, 1'b0, 1'b0, 1'b0, 5'd1, 1'b1);
		read_test(1'b1, 1'b0, 1'b0, 1'b0, 5'd2, 1'b1);
		read_test(1'b1, 1'b1, 1'b0, 1'b1, 5'd0, 1'b0);
		read_test(1'b1, 1'b0, 1'b0, 1'b0, 5'd1, 1'b1);
		read_test(1'b1, 1'b0, 1'b0, 1'b1, 5'd29, 1'b0);
	end
endmodule
