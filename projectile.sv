module projectile (
	 input level_rst, frame_clk, pause,
	 input logic [9:0] vel_x, vel_y, vel_z,
	 output logic [9:0] pos_x, pos_y, pos_z
);

always_ff @ (posedge level_rst or posedge frame_clk ) begin
	if (level_rst) begin
		pos_x <= 320;
		pos_y <= 240;
		pos_z <= 64;
	end
	else if (pause) begin
		pos_x <= 320;
		pos_y <= 240;
		pos_z <= 64;
	end
	else begin
		pos_x <= pos_x + vel_x;
		pos_y <= pos_y + vel_y;
		pos_z <= pos_z + vel_z;
	end
end
endmodule