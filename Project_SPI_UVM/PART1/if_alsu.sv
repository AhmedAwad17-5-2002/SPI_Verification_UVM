interface ram_if (clk);
	parameter MEM_DEPTH=256;
	parameter ADDR_SIZE=8;	
	input clk;	
	logic  rst_n, rx_valid;
	logic [9:0] din;
 	logic tx_valid;
	logic [ADDR_SIZE-1:0] dout;
endinterface
