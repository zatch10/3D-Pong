//-------------------------------------------------------------------------
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 62                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module final_project (

      ///////// Clocks /////////
      input     MAX10_CLK1_50, 

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);




logic Reset_h, vssig, blank, sync, VGA_Clk;


//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_5, hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [7:0] key0, key1;
	logic [1:0] signs;
	logic [1:0] hundreds;
	logic [9:0] drawxsig, drawysig, ballxsig, ballysig, ballsizesig;
	logic [7:0] Red, Blue, Green;
	logic [7:0] keycode;

//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	//HEX drivers to convert numbers to HEX output
	HexDriver hex_driver5 (hex_num_5, HEX5[6:0]);
	assign HEX5[7] = 1'b1;
	
	HexDriver hex_driver4 (hex_num_4, HEX4[6:0]);
	assign HEX4[7] = 1'b1;
	
	HexDriver hex_driver3 (hex_num_3, HEX3[6:0]);
	assign HEX3[7] = 1'b1;
	
	HexDriver hex_driver1 (hex_num_1, HEX1[6:0]);
	assign HEX1[7] = 1'b1;
	
	HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
	assign HEX0[7] = 1'b1;
	
	//fill in the hundreds digit as well as the negative sign
	//assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	
	
	//Assign one button to reset
	assign {Reset_h}=~ (KEY[0]);

	//Our A/D converter is only 12 bit
	assign VGA_R = blank ? Red[7:4] : 'b0;
	assign VGA_B = blank ? Blue[7:4] : 'b0;
	assign VGA_G = blank ? Green[7:4] : 'b0;
	
	
	lab62_soc u0 (
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		//.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
		.hex_digits_export({key0, key1}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode_export(keycode)
		
	 );


//instantiate a vga_controller, ball, and color_mapper here with the ports.

logic [9:0] pos_x, pos_y, pos_z, vel_x, vel_y, vel_z, paddleX, paddleY;
logic hit, cursor_on, bg_out, cur_lvl, w_out, miss;
logic [1:0] paddle_out;
logic [7:0] score, total_score, lvl_num;
logic show_home_screen, pause;

assign hex_num_5 = lvl_num[3:0];
assign hex_num_4 = total_score[7:4];
assign hex_num_3 = total_score[3:0];
assign hex_num_1 = score[7:4];
assign hex_num_0 = score[3:0];
assign cur_lvl = ~show_home_screen;
	 

//room ( input Reset, frame_clk,
//					input [9:0] pos_x, pos_y, pos_z,
//               output logic [9:0]  center_x, center_y, size);

room threetotwo (.*, .Reset(Reset_h), .frame_clk(VGA_VS),
						.center_x(ballxsig), .center_y(ballysig), .size(ballsizesig));

//module collision (
//	input level_rst, frame_clk,
//	input logic [9:0] pos_x, pos_y, pos_z, paddleX, paddleY,
//	output logic [9:0] vel_x, vel_y, vel_z,
//	output logic hit, miss
//);

collision col (.*, .level_rst(Reset_h), .frame_clk(VGA_VS));
//module projectile (
//	 input level_rst, frame_clk,
//	 input logic [9:0] vel_x, vel_y, vel_z,
//	 output logic [9:0] pos_x, pos_y, pos_z
//);
projectile proj (.*, .level_rst(Reset_h), .frame_clk(VGA_VS));
//module cursor( input Reset, frame_clk,
//					input [9:0] pos_z, DrawX, DrawY,
//               output logic cursor_on);
cursor layer(.*, .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(drawxsig), .DrawY(drawysig));

//module control (	input Clk, Reset, input [7:0] keycode, 
//						output logic cur_lvl);
//control state_machine ( .*, .Clk(MAX10_CLK1_50), .Reset(Reset_h));

//module level_controller (
//	input logic frame_clk,
//	input logic game_rst,
//	input int score,
//	input logic [7:0] keycode,
//	input logic miss,				//  Notifies of a miss but only needed for ending level 4 
//	output logic level_rst,
//	output logic show_home_screen,
//	output int total_score
//);

level_controller lc(.*, .level_rst(), .frame_clk(VGA_VS), .game_rst(Reset_h), .keycode(key0));

		
frameRAM fr (.data_In(), .write_address((drawysig * 640) + drawxsig), .read_address((drawysig * 640) + drawxsig), .we(1'b0), .Clk(MAX10_CLK1_50), .data_Out(bg_out));

welcomeRAM wr (.data_In(), .write_address((drawysig * 640) + drawxsig), .read_address((drawysig * 640) + drawxsig), .we(1'b0), .Clk(MAX10_CLK1_50), .data_Out(w_out));

paddleRAM pr (.data_In(), .write_address(), .read_address(((drawysig - paddleY) * 200) + (drawxsig - paddleX)), .we(1'b0), .Clk(MAX10_CLK1_50), .data_Out(paddle_out));

//module  paddleMovement ( input Reset, frame_clk,
//					input [7:0] keycode,
//               output [9:0]  paddleX, paddleY);

paddleMovement paddleLogic (.*, .Reset(Reset_h), .frame_clk(VGA_VS));

vga_controller vc (.*, .Clk(MAX10_CLK1_50), .Reset(Reset_h), .hs(VGA_HS), .vs(VGA_VS), .pixel_clk(VGA_Clk), .blank(blank), .DrawX(drawxsig), .DrawY(drawysig));
					
//ball b (.*, .Reset(Reset_h), .frame_clk(VGA_VS), .BallX(ballxsig), .BallY(ballysig), .BallS(ballsizesig));
							  
color_mapper cm (.*, .frame_clk(VGA_VS), .BallX(ballxsig), .BallY(ballysig), .DrawX(drawxsig), .DrawY(drawysig), .Ball_size(ballsizesig));

endmodule
