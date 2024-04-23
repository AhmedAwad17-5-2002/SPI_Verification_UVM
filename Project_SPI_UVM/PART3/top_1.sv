import uvm_pkg::*;
import SPI_test_pkg::*;

`include "uvm_macros.svh"
module top();
	bit clk;

	initial begin
		forever
		#1 clk = ~clk;
	end

	SPI_if SPIif(clk);
	ram_if ramif();
	assign ramif.din = DUT.S.rx_data;
	assign ramif.dout = DUT.S.tx_data;
	assign ramif.rx_valid = DUT.S.rx_valid;
	assign ramif.tx_valid = DUT.S.tx_valid;
	//SPI_RAM1 RAM(din, dout ,rx_valid, tx_valid);
	SPI_Wrapper DUT(SPIif.MISO, SPIif.MOSI,SPIif.SS_n,SPIif.rst_n,clk);
	Master GOLDEN(SPIif.SS_n,SPIif.MOSI,SPIif.MISO_G,SPIif.clk,rst_n);
	initial begin
		uvm_config_db#(virtual SPI_if)::set(null, "uvm_test_top", "SPI_IF",SPIif);
		uvm_config_db#(virtual ram_if)::set(null, "uvm_test_top", "RAM_IF",ramif);
		run_test("SPI_test");
	end

endmodule : top