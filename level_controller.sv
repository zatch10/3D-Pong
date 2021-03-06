module level_controller (
	input logic frame_clk,
	input logic game_rst,
	input logic [7:0] score,
	input logic [7:0] keycode,
	input logic miss,				//  Notifies of a miss but only needed for ending level 4 
	output logic level_rst,
	output logic show_home_screen,
	output logic [7:0] total_score, lvl_num,
	output logic pause
);

logic enter;
logic clocked_miss;
//logic last_level_score;

assign enter = (keycode == 8'h40);


enum int {home_screen,
						 start_0,
						 level_0,
						 start_1,
						 level_1,
						 start_2,
						 level_2,
						 start_3,
						 level_3,
						 start_4,
						 level_4
					   } state, next_state;

						
assign total_score = (state == level_1) ? score : ((state == level_2) ? 5 + score : ((state == level_3) ? 10 + score : ((state == level_4) ? 17 + score : 0)));

always_ff @(posedge miss or posedge frame_clk or posedge game_rst) begin
	if(game_rst)
		clocked_miss <= 0;
	else
		clocked_miss <= miss;
end
						
always_comb begin : next_state_logic
	next_state = state;
	unique case (state)
		home_screen: begin
			if(enter)
				next_state = start_0;
			else
				next_state = home_screen;
		end
		start_0: begin
			next_state = level_0;
		end
		level_0: begin
			if(miss)
				next_state = home_screen;
			else if(score >= 1)
				next_state = start_1;
			else
				next_state = level_0;
		end
		start_1: begin
			if(enter)
				next_state = level_1;
			else
				next_state = start_1;
		end
		level_1: begin
			if(miss)
				next_state = home_screen;
			else if(score >= 5)
				next_state = start_2;
			else
				next_state = level_1;
		end
		start_2: begin
			if(enter)
				next_state = level_2;
			else
				next_state = start_2;
		end
		level_2: begin
			if(miss)
				next_state = home_screen;
			else if(score >= 5)
				next_state = start_3;
			else
				next_state = level_2;
		end
		start_3: begin
			if(enter)
				next_state = level_3;
			else
				next_state = start_3;
		end
		level_3: begin
			if(miss)
				next_state = home_screen;
			else if(score >= 7)
				next_state = start_4;
			else
				next_state = level_3;
		end
		start_4: begin
			if(enter)
				next_state = level_4;
			else
				next_state = start_4;
		end
		level_4: begin
			if(miss)
				next_state = home_screen;
			else
				next_state = level_4;
		end
		default: ;
	endcase
end						

always_comb begin : state_signals
	level_rst = 0;
	show_home_screen = 0;
	pause = 1;
	lvl_num = 0;
	unique case(state)
		home_screen: begin
			show_home_screen = 1;
		end
		start_0: begin
			level_rst = 1;
			lvl_num = 0;
		end
		level_0: begin
			pause = 0;
			lvl_num = 0;
		end
		start_1: begin
			level_rst = 1;
			lvl_num = 1;
		end
		level_1: begin
			pause = 0;
			lvl_num = 1;
		end
		start_2: begin
			level_rst = 1;
			lvl_num = 2;
		end
		level_2: begin
			pause = 0;
			lvl_num = 2;
		end
		start_3: begin
			level_rst = 1;
			lvl_num = 3;
		end
		level_3: begin
			pause = 0;
			lvl_num = 3;
		end
		start_4: begin
			level_rst = 1;
			lvl_num = 4;
		end
		level_4: begin
			pause = 0;
			lvl_num = 4;
		end
		default: ;
	endcase
end

always_ff @(posedge frame_clk) begin
	if(game_rst) begin
		state <= home_screen;
	end
	else begin
		state <= next_state;
	end
end

endmodule