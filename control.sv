module control (	input Clk, Reset, input [7:0] keycode, 
						output logic cur_lvl);
						
		enum logic [2:0] {start, lvl_1} curr_state, next_state; // States
		// Assign 'next_state' based on 'state' and 'Execute'
		always_ff @ (posedge Clk or posedge Reset ) 
		begin
				if (Reset)
					curr_state = start; 
				else
					curr_state = next_state;
		end
		// Assign outputs based on ‘state’
		always_comb
		begin
		// Default to be self-looping 		
				next_state = curr_state; 
				
				unique case (curr_state)
						start : if (keycode)
								next_state = lvl_1;
		
				endcase
		end
		// Assign outputs based on ‘state’
		always_comb
		begin
				case (curr_state)
						start: 
							begin
									cur_lvl <= 1'b0;
							end
						lvl_1: 
							begin
									cur_lvl <= 1'b1;
							end
				endcase
		end
		
endmodule