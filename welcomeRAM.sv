/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  welcomeRAM
(
		input data_In,
		input [18:0] write_address, read_address,
		input we, Clk,

		output logic data_Out
);

// mem has width of 1 bit and a total of 400 addresses
logic mem [0:307199];

initial
begin
	 $readmemb("sprites/pong.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule
