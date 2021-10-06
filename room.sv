module  room ( input Reset, frame_clk,
					input [9:0] pos_x, pos_y, pos_z,
               output logic [9:0]  center_x, center_y, size);
//	assign center_x = pos_x;	// Need to change these two lines because the x and y co-ordinates will be different
//	assign center_y = pos_y;	// At different z co-ordinates
	
	always_ff @ (posedge Reset or negedge frame_clk ) begin
	   if(Reset) begin
			center_x <= 320;
			center_y <= 240;
			size <= 8;
		end
		else begin
			center_x <= 160 + (((pos_z + 128) * pos_x) >> 8) - ((160 * pos_z) >> 7);
			center_y <= 120 + (((pos_z + 128) * pos_y) >> 8) - ((120 * pos_z) >> 7);
			size <= ((pos_z + 128) >> 3);
		end
	end
//	assign center_x = 160 + (((pos_z + 128) * pos_x) >> 8) - ((160 * pos_z) >> 7);
//	assign center_y = 120 + (((pos_z + 128) * pos_y) >> 8) - ((120 * pos_z) >> 7);
//	
////	assign size = ((pos_z + 128) >> 4);
//	assign size = 8;
endmodule
