/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  paddleRAM
(
		input [1:0] data_In,
		input [18:0] write_address, read_address,
		input we, Clk,

		output logic [1:0] data_Out
);

// mem has width of 1 bit and a total of 400 addresses
logic [1:0] mem [0:30000];

initial
begin
	 $readmemh("sprites/paddle_stripes.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule
