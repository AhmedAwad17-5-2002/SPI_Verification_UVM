import uvm_pkg::*;
import ram_test_pkg::*;
`include "uvm_macros.svh"
module top ();
	bit clk;
	initial
	begin
		clk=0;
		forever
		#1 clk=~clk;
	end

	ram_if R1(clk);
	SPI_RAM A(R1.din, R1.dout ,R1.rx_valid, R1.tx_valid , clk, R1.rst_n);
	bind SPI_RAM RAM_assertions ASSERTION (R1.din, R1.dout ,R1.rx_valid, R1.tx_valid ,clk, R1.rst_n,A.write_address,A.read_address);
initial
begin
	uvm_config_db#(virtual ram_if)::set(null, "uvm_test_top", "ram_IF",R1);

	run_test("ram_test");
end

endmodule 
