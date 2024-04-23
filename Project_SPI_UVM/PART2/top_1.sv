import SPI_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
module top();
	bit clk;

	initial begin
		forever
		#1 clk = ~clk;
	end

	SPI_if SPIif(clk);
	SPI_Wrapper DUT(SPIif.MISO, SPIif.MOSI,SPIif.SS_n,SPIif.rst_n,clk);
	Master GOLDEN(SPIif.SS_n,SPIif.MOSI,SPIif.MISO_G,SPIif.clk,rst_n);
	initial begin
		uvm_config_db#(virtual SPI_if)::set(null, "uvm_test_top", "SPI_IF",SPIif);
		run_test("SPI_test");
	end

endmodule : top