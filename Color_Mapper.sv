//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        [9:0] BallX, BallY, DrawX, DrawY, Ball_size, paddleX, paddleY,
							  input bg_out, w_out, frame_clk, hit, cursor_on, cur_lvl,
							  input [1:0] paddle_out,
                       output logic [7:0]  Red, Green, Blue );
    
    logic ball_on, wall_on;
	  
    int DistX, DistY, Size;
	 assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;
	 
	 
//	 // For sprites
//	 logic mem [0:307199];
//
//    initial
//    begin
//         $readmemb("sprites/bg.txt", mem);
//    end
//	 //end sprites
	 
	 
	 function logic on_line(int x1, int y1, int x2, int y2, int x, int y);
		on_line = (x == (((x2 - x1) * (y - y1)) / (y2 - y1)) + x1);
	 endfunction
	  
    always_comb
    begin:Ball_on_proc
        if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) ) 
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
     end 
	  
//	 always_comb
//    begin:Wall_on_proc
//        if ( ((DrawY == 284 || DrawY == 196) && (DrawX >= 262) && (DrawX <= 378)) || ((DrawX == 262 || DrawX == 378) && (DrawY >= 196) && (DrawY <= 284))) 
//            wall_on = 1'b1;
////		  else if ((on_line(0, 0, 262, 196, DrawX, DrawY) || on_line(639, 0, 378, 196, DrawX, DrawY) || on_line(0, 479, 262, 284, DrawX, DrawY) || on_line(639, 479, 378, 284, DrawX, DrawY)) && !((DrawX >= 262) && (DrawX <= 378) && (DrawY >= 196) && (DrawY <= 284)))
////				wall_on = 1'b1;
//		  else 
//            wall_on = 1'b0;
//     end 
	  
	  
//	 always_comb
//    begin:cursor
//        if ( ((DrawY == 240 || DrawY == 196) && (DrawX >= 262) && (DrawX <= 378)) || ((DrawX == 262 || DrawX == 378) && (DrawY >= 196) && (DrawY <= 284))) 
//            cursor_on = 1'b1;
//		  else 
//            cursor_on = 1'b0;
//     end 
       
	 logic [7:0] ball_red, ball_blue, ball_green;
	 logic [1:0] state;
	 always_ff @ (posedge frame_clk ) begin
		  if(hit) begin
				state <= state + 1;
		  end
		  else begin
				state <= state;
		  end
	 end
	 
	 always_comb begin
	     unique case(state)
				2'b00 : begin
					ball_red = 8'hff;
					ball_blue = 8'h00;
					ball_green = 8'h00;
				end
				2'b01 : begin
					ball_red = 8'h00;
					ball_blue = 8'hff;
					ball_green = 8'h00;
				end
				2'b10 : begin
					ball_red = 8'h00;
					ball_blue = 8'h00;
					ball_green = 8'hff;
				end
				2'b11 : begin
					ball_red = 8'hff;
					ball_blue = 8'hff;
					ball_green = 8'h00;
				end
		  endcase
	 end
		 
    always_comb
    begin
	 case(cur_lvl)
		 1'b0: begin
				Red = w_out ? 8'hff : 8'h00; 
				Green = w_out ? 8'hff : 8'h00;
				Blue = w_out ? 8'hff : 8'h00;
		 end
		 
		 1'b1: begin
			 :RGB_Display
		//		  if (wall_on == 1'b1) begin
		//				Red = 8'hff;
		//            Green = 8'h00;
		//            Blue = 8'h00;
		//		  end
		//        else 
		//        begin 
		//				Red = 8'h00;
		//				Green = 8'h00;
		//				Blue = 8'hff;
						Red = bg_out ? 8'hff : 8'hff; 
						Green = bg_out ? 8'hff : 8'hd7;
		//          Blue = 8'h7f - DrawX[9:3];
						Blue = bg_out ? 8'hff : 8'h00;
		//        end
				  
				  if(cursor_on) begin
						Red = bg_out ? 8'hdd : 8'hdc;
						Green = bg_out ? 8'hff : 8'heb;
						Blue = bg_out ? 8'hee : 8'h7e;
				  end
				  
				  
				  if(DrawX >= paddleX && DrawY >= paddleY && DrawX < (paddleX + 200) && DrawY < (paddleY + 150) && paddle_out != 1) begin
						Red = (paddle_out == 0) ? 8'h8c : 8'h00; 
						Green = (paddle_out == 0) ? 8'h52 : 8'h00;
						Blue = (paddle_out == 0) ? 8'hff : 8'h00;
				  end
				  else begin
						if ((ball_on == 1'b1)) 
						  begin 
								Red = ball_red;
								Green = ball_green;
								Blue = ball_blue;
						  end
				  end
		 end
		 endcase
    end 
    
endmodule
