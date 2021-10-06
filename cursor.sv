module cursor( input Reset, frame_clk,
					input [9:0] pos_z, DrawX, DrawY,
               output logic cursor_on);

		always_comb begin
			if((DrawX >= (160 - ((160 * pos_z) >> 7))) && (DrawY >= (120 - ((120 * pos_z) >> 7))) && (DrawX < (160 + (((pos_z + 128) * 5) >> 1) - ((160 * pos_z) >> 7))) && (DrawY < (120 + (((pos_z + 128) * 15) >> 3) - ((120 * pos_z) >> 7))))
			begin
				cursor_on = 1'b1;
			end
			else begin
				cursor_on = 1'b0;
			end
		end
					
endmodule