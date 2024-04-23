package SPI_coverage_pkg;
	import uvm_pkg::*;
	import SPI_seq_item_pkg::*;
	
	`include "uvm_macros.svh"

	class SPI_coverage extends  uvm_component;
		`uvm_component_utils(SPI_coverage)
		uvm_analysis_export #(SPI_seq_item) cov_export;
		uvm_tlm_analysis_fifo #(SPI_seq_item) cov_fifo;
		SPI_seq_item seq_item_cov;

		covergroup cg();
			MISO_coverage:coverpoint seq_item_cov.MISO{
			bins ZERO = {0};
			bins ONE  = {1};
			bins WRITE_adderss = (0 => 0 => 0);
			bins WRITE_data = (0 => 0 => 1);
			bins READ_adderss = (1 => 1 => 0);
			bins READ_data = (1 => 1 => 1);
			}
			SS_n_coverage:coverpoint seq_item_cov.SS_n{
			bins ZERO = {0};
			bins ONE  = {1};
			bins ONE_to_ZERO = (1 => 0);
			bins ZERO_to_ONE  = (0 => 1);
			}
			rst_n_coverage:coverpoint seq_item_cov.rst_n{
			bins ZERO = {0};
			bins ONE  = {1};
			}
			MOSI_coverage:coverpoint seq_item_cov.MOSI{
			bins ZERO = {0};
			bins ONE  = {1};
			}
			cross_1:cross SS_n_coverage,rst_n_coverage {
			bins bin1 = binsof(SS_n_coverage.ONE) && binsof(rst_n_coverage.ZERO);
			bins bin2 = binsof(SS_n_coverage.ONE_to_ZERO) && binsof(rst_n_coverage.ZERO);
			bins bin3 = binsof(SS_n_coverage.ONE_to_ZERO) && binsof(rst_n_coverage.ONE);
			option.cross_auto_bin_max = 0;
			}
			cross_2:cross MISO_coverage,SS_n_coverage{
			bins bin1 = binsof(MISO_coverage.WRITE_adderss) && binsof(SS_n_coverage.ZERO);
			bins bin2 = binsof(MISO_coverage.WRITE_data) && binsof(SS_n_coverage.ZERO);
			bins bin3 = binsof(MISO_coverage.READ_adderss) && binsof(SS_n_coverage.ZERO);
			bins bin4 = binsof(MISO_coverage.READ_data) && binsof(SS_n_coverage.ZERO);
			option.cross_auto_bin_max = 0;
			}
		endgroup

		function new(string name = "SPI_coverage",uvm_component parent = null);
			super.new(name,parent);
			cg = new();
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			cov_export = new("cov_export",this);
			cov_fifo = new("cov_fifo",this);
		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			cov_export.connect(cov_fifo.analysis_export);
		endfunction

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				cov_fifo.get(seq_item_cov);
				cg.sample();
			end
		endtask
	endclass
endpackage