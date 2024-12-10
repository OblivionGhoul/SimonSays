module memory_fsm(
		input logic clk, button, reset, mode, // 0: Read, 1: Write
		output logic fifo_full, fifo_empty,
		output logic [4:0]r_ptr,
		output logic [4:0]w_ptr,
		output logic w_en, r_en
	); 
	
	logic [4:0]temp_r = 5'b00000;
	logic [4:0]temp_w = 5'b00000;
	logic tw_en = 1'b0;
	logic tr_en = 1'b0;
	
	typedef enum logic [1:0] {idle, read, write} statetype;
	statetype presentState = idle, nextState;
	
	always_ff @(posedge clk)
	begin
		presentState <= nextState;
	end
	
	always_comb
	begin
		case(presentState)
			idle: 
				if((mode == 1'b0)&&(fifo_empty == 1'b0)&&(button == 1'b1))
					nextState <= read;
					
				else if((mode == 1'b1)&&(fifo_full == 1'b0)&&(button == 1'b1))
					nextState <= write;
					
				else
					nextState <= idle;
					
			read:
					nextState <= idle;
				
			write:
					nextState <= idle;
					
			default:
					nextState <= idle;
		endcase
	end
	
	always_ff @(posedge clk)
	begin
		if(reset == 1'b1) begin
			temp_r <= 5'b00000;
			temp_w <= 5'b00000;
		end
		
		else
			case(presentState)
				idle: begin
					temp_r <= temp_r;
					temp_w <= temp_w;
					tw_en <= 1'b0;
					tr_en <= 1'b0;
				end
				
				read: begin
					temp_r <= temp_r + 5'b00001;
					tw_en <= 1'b0;
					tr_en <= 1'b1;
				end 
				
				write: begin
					temp_w <= temp_w + 5'b00001;
					tw_en <= 1'b1;
					tr_en <= 1'b0;
				end
				
				default: begin
					temp_r <= temp_r;
					temp_w <= temp_w;
					tw_en <= tw_en;
					tr_en <= tr_en;
				end
			endcase
	end
	
	always_comb 
	begin
		r_ptr <= temp_r;
		w_ptr <= temp_w;
		r_en <= tr_en;
		w_en <= tw_en;
		
		fifo_empty <= (r_ptr == w_ptr);
		fifo_full <= ((r_ptr[4] != w_ptr[4]) && (r_ptr[3:0] == w_ptr[3:0]));
	end

endmodule