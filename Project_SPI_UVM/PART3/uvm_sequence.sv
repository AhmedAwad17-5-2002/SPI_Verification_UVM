package ram_seq_item_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	parameter MEM_DEPTH=256;
parameter ADDR_SIZE=8;
	class ram_seq_item extends uvm_sequence_item;
		`uvm_object_utils(ram_seq_item)
		//-> properties
		rand bit rx_valid;
		rand bit [9:0] din;
    logic tx_valid;
 		logic [ADDR_SIZE-1:0] dout; 
 		logic [ADDR_SIZE-1:0] write_address, read_address; 
 		bit WRITE_SIG,READ_SIG;
 		rand bit WRITE,READ;


// -> Constraints 
constraint RX_VALID { rx_valid dist {0:=20 , 1:=80}; }
constraint Din { 
if(WRITE)
	{
if(WRITE_SIG==1)
            din[9:8]==2'b01;
               else
               	din[9:8]==2'b00;
               }
               
               else if(READ)
               {
                 if(READ_SIG==0)
               din[9:8]==2'b10;
                else 
               din[9:8]==2'b11; 
                }

                }

constraint write_only { 
if(WRITE_SIG==1)
din[9:8]==2'b01;
else
din[9:8]==2'b00;
}
	


constraint read_only {
	
if(READ_SIG==0)
 
 din[9:8]==2'b10;
else
din[9:8]==2'b11;


}
 		

		function new(string name = "ram_seq_item");
			super.new(name);
		endfunction

		function string convert2string();
			return $sformatf("%s rx_valid=0b%0b,din = 0b%0b,tx_valid = 0b%0b, dout= 0b%0b",super.convert2string(),rx_valid,din,tx_valid,dout);
		endfunction

		function string convert2string_stimulus();
return $sformatf("rx_valid=0b%0b,din = 0b%0b,tx_valid = 0b%0b, dout= 0b%0b",rx_valid,din,tx_valid,dout);
		endfunction
	endclass
endpackage