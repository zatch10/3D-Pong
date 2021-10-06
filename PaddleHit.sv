module  PaddleHit ( input [9:0] BallX, BallY, DrawX, DrawY, Ball_size, paddleX, paddleY,
							  input bg_out, w_out, frame_clk, hit, cursor_on, cur_lvl,
							  input [1:0] paddle_out,
                       output logic [7:0]  Red, Green, Blue );