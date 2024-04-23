interface ram_if ();
	parameter MEM_DEPTH=256;
	parameter ADDR_SIZE=8;		
	logic rx_valid;
	logic [9:0] din;
 	logic tx_valid;
	logic [ADDR_SIZE-1:0] dout;
endinterface
