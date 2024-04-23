module RAM_assertions (din, dout ,rx_valid, tx_valid , clk, rst_n,write_address,read_address);
parameter MEM_DEPTH=256;
parameter ADDR_SIZE=8;
input clk, rst_n, rx_valid;
input [9:0] din;
input tx_valid;
input [ADDR_SIZE-1:0] dout; 
input [ADDR_SIZE-1:0] write_address, read_address;
 


property prop_1;
@(posedge clk) disable iff(!rst_n) (din[9:8]==2'b00 &&rx_valid)|=> write_address==$past(din[7:0]);  
endproperty
	
property prop_2;
@(posedge clk) disable iff(!rst_n) (din[9:8]==2'b10 && rx_valid) |=>read_address==$past(din[7:0]);
	endproperty

property prop_3;
		@(posedge clk) disable iff(!rst_n) (din[9:8]==2'b11 && rx_valid) |=>  (tx_valid==1);
	endproperty	


	always_comb
begin
if(!rst_n)
assert final(dout==0);
end

sv_prop1:assert property(prop_1);
sv_prop2:assert property(prop_2);
sv_prop3:assert property(prop_3);

cvr_prop1:cover property(prop_1);
cvr_prop2:cover property(prop_2);
cvr_prop3:cover property(prop_3);
endmodule

