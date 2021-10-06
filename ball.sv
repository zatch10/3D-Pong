//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input Reset, frame_clk,
					input [7:0] keycode,
               output [9:0]  BallX, BallY, BallS );
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Z_Pos, Ball_Z_Motion, Ball_Size;
	 
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
	 parameter [9:0] Ball_Z_Center=65;  // Center position on the Z axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
	 parameter [9:0] Ball_Z_Min=20;       // Topmost point on the Z axis
    parameter [9:0] Ball_Z_Max=109;     // Bottommost point on the Z axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
	 parameter [9:0] Ball_Z_Step=1;      // Step size on the Z axis


    assign Ball_Size = 10;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Ball_Y_Motion <= 1; //Ball_Y_Step;
				Ball_X_Motion <= 1; //Ball_X_Step;
				Ball_Z_Motion <= 1; //Ball_Z_Step;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
				Ball_Z_Pos <= Ball_Z_Center;
        end
           
        else 
        begin 
				case (keycode)
					8'h04 : begin

								Ball_X_Motion <= -1;//A
								Ball_Y_Motion <= 0;
								Ball_Z_Motion <= 0;
							  end
					        
					8'h07 : begin
								
					        Ball_X_Motion <= 1;//D
							  Ball_Y_Motion <= 0;
							  Ball_Z_Motion <= 0;
							  end

							  
					8'h16 : begin

					        Ball_Y_Motion <= 1;//S
							  Ball_X_Motion <= 0;
							  Ball_Z_Motion <= 0;
							 end
							  
					8'h1A : begin
					        Ball_Y_Motion <= -1;//W
							  Ball_X_Motion <= 0;
							  Ball_Z_Motion <= 0;
							 end	  
					8'h08 : begin

								Ball_X_Motion <= 0;//E
								Ball_Y_Motion<= 0;
								Ball_Z_Motion <= -1;
							  end
					        
					8'h14 : begin
								
					        Ball_X_Motion <= 0;//Q
							  Ball_Y_Motion <= 0;
							  Ball_Z_Motion<= 1;
							  end
					default: begin
							  Ball_X_Motion <= Ball_X_Motion;//Q
							  Ball_Y_Motion <= Ball_Y_Motion;
							  Ball_Z_Motion<= Ball_Z_Motion;
					end
			   endcase
					
				 if ( (Ball_Y_Pos + Ball_Size) >= (Ball_Y_Center + ((210 * Ball_Z_Pos) >> 7)) )  // Ball is at the bottom edge, BOUNCE!
					  Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);  // 2's complement.
					  
				 if ( (Ball_Y_Pos - Ball_Size) <= (Ball_Y_Center - ((210 * Ball_Z_Pos) >> 7)) )  // Ball is at the top edge, BOUNCE!
					  Ball_Y_Motion <= Ball_Y_Step;
					  
				 if ( (Ball_X_Pos) >= (Ball_X_Center + ((320 * Ball_Z_Pos) >> 7)) )  // Ball is at the Right edge, BOUNCE!
					  Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);  // 2's complement.
					  
				 if ( (Ball_X_Pos) <= (Ball_X_Center - ((320 * Ball_Z_Pos) >> 7)) )  // Ball is at the Left edge, BOUNCE!
					  Ball_X_Motion <= Ball_X_Step;

				 if ( (Ball_Z_Pos) >= Ball_Z_Max )  // Ball is at the Right edge, BOUNCE!
					  Ball_Z_Motion <= (~ (Ball_Z_Step) + 1'b1);  // 2's complement.
					  
				 if ( (Ball_Z_Pos) <= Ball_Z_Min )  // Ball is at the Left edge, BOUNCE!
					  Ball_Z_Motion <= Ball_Z_Step;
				 
				 
				 
				 Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
				 Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
				 Ball_Z_Pos <= (Ball_Z_Pos + Ball_Z_Motion);
			
			
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Ball_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Ball_Y_pos.  Will the new value of Ball_Y_Motion be used,
          or the old?  How will this impact behavior of the ball during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
		end  
    end
       
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = 10 + (Ball_Z_Pos >> 4);
//	 assign BallS = 10;
    

endmodule
