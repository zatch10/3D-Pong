module  paddleMovement ( input Reset, frame_clk,
					input [7:0] key0, key1,
               output [9:0]  paddleX, paddleY);
			
	always_ff @ (posedge Reset or posedge frame_clk ) begin
		if (Reset)  // Asynchronous Reset
        begin 
				paddleX <= 220;
				paddleY <= 165;
        end
           
        else 
        begin 
				case (key0)
					8'h04 : begin
								if(key1 != 8'h07)
									paddleX <= (paddleX != 0 && paddleX != 1) ? paddleX - 2 : paddleX; // A
								if(key1 == 8'h22)
									paddleY <= (paddleY != 329 && paddleY != 328) ? paddleY + 2 : paddleY;
								if(key1 == 8'h26)
									paddleY <= (paddleY != 0 && paddleY != 1) ? paddleY - 2 : paddleY;
//								paddleY <= paddleY;
							  end
					        
					8'h07 : begin
								if(key1 != 8'h04)
									paddleX <= (paddleX != 439 && paddleX != 438) ? paddleX + 2 : paddleX; // D
								if(key1 == 8'h22)
									paddleY <= (paddleY != 329 && paddleY != 328) ? paddleY + 2 : paddleY;
								if(key1 == 8'h26)
									paddleY <= (paddleY != 0 && paddleY != 1) ? paddleY - 2 : paddleY;
//								paddleY <= paddleY;
							  end

							  
					8'h22 : begin

//					        paddleX <= paddleX; // S
								if(key1 != 8'h26)
									paddleY <= (paddleY != 329 && paddleY != 328) ? paddleY + 2 : paddleY;
								if(key1 == 8'h04)
									paddleX <= (paddleX != 0 && paddleX != 1) ? paddleX - 2 : paddleX;
								if(key1 == 8'h07)
									paddleX <= (paddleX != 439 && paddleX != 438) ? paddleX + 2 : paddleX;
							 end
							  
					8'h26 : begin
//					        paddleX <= paddleX; // W
								if(key1 != 8'h22)
									paddleY <= (paddleY != 0 && paddleY != 1) ? paddleY - 2 : paddleY;
								if(key1 == 8'h04)
									paddleX <= (paddleX != 0 && paddleX != 1) ? paddleX - 2 : paddleX;
								if(key1 == 8'h07)
									paddleX <= (paddleX != 439 && paddleX != 438) ? paddleX + 2 : paddleX;
							 end	
					default: begin
							  paddleX <= paddleX;
							  paddleY <= paddleY;
					end
				endcase
			end
	end
endmodule