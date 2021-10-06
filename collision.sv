module collision (
	input level_rst, frame_clk,
	input logic pause,
	input logic [9:0] pos_x, pos_y, pos_z, paddleX, paddleY,
	input logic [7:0] lvl_num,
	output logic [9:0] vel_x, vel_y, vel_z,
	output logic [7:0] score,
	output logic hit, miss
);
//	logic hit;
	always_ff @ (posedge level_rst or negedge frame_clk ) begin
		if (level_rst) begin
			vel_x <= (lvl_num == 4 || lvl_num == 3) ? 2 : 1;
			vel_y <= (lvl_num == 4 || lvl_num == 3) ? 2 : 1;
			vel_z <= (lvl_num == 4 || lvl_num == 3) ? 2 : 1;
			hit <= 0;
			miss <= 0;
			score <= 0;
		end
		else if (pause) begin
			vel_x <= (lvl_num == 4 || lvl_num == 3) ? 2 : 1;
			vel_y <= (lvl_num == 4 || lvl_num == 3) ? 2 : 1;
			vel_z <= (lvl_num == 4 || lvl_num == 3) ? 2 : 1;
			hit <= 0;
			miss <= 0;
			score <= 0;
		end
		else begin
			if(($signed(pos_x + vel_x) >= 640) || ($signed(pos_x + vel_x) < 0)) begin
				vel_x <= ~(vel_x) + 1;
				hit <= 1;
			end
			else begin
				vel_x <= vel_x;
				hit <= 0;
			end
			
			if(($signed(pos_y + vel_y) >= 480) || ($signed(pos_y + vel_y) < 0)) begin
				vel_y <= ~(vel_y) + 1;
				hit <= 1;
			end
			else begin
				vel_y <= vel_y;
				hit <= 0;
			end
			
			if(($signed(pos_z + vel_z) >= 128) || ($signed(pos_z + vel_z) < 0)) begin
				vel_z <= ~(vel_z) + 1;
				hit <= 1;
			end
			else begin
				vel_z <= vel_z;
				hit <= 0;
			end
			
			//local score keeping when ball hits back wall
			if($signed(pos_z + vel_z) < 0) begin
				score <= score + 1;
			end
			
			else begin
				score <= score;
			end
			
						
			//checking for paddle contact
			if(!(pos_x >= paddleX && pos_y >= paddleY && pos_x < (paddleX + 200) && pos_y < (paddleY + 150)) && ($signed(pos_z + vel_z) >= 128)) begin
				miss <= 1;
			end
			
			else begin
				miss <= 0;
			end

		end
	end

endmodule