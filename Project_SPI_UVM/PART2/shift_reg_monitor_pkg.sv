package SPI_monitor_pkg;
	import uvm_pkg::*;
	import SPI_seq_item_pkg::*;
	
	`include "uvm_macros.svh"

	class SPI_monitor extends  uvm_monitor;
		`uvm_component_utils(SPI_monitor)
		virtual SPI_if SPI_monitor_vif;
		SPI_seq_item rsp_seq_item;
		uvm_analysis_port #(SPI_seq_item) mon_ap;
		function new(string name = "SPI_monitor",uvm_component parent = null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			mon_ap = new("mon_ap",this);
		endfunction

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				rsp_seq_item = SPI_seq_item::type_id::create("rsp_seq_item");
				@(negedge SPI_monitor_vif.clk);
				rsp_seq_item.MOSI = SPI_monitor_vif.MOSI;
				rsp_seq_item.SS_n = SPI_monitor_vif.SS_n;
				rsp_seq_item.rst_n = SPI_monitor_vif.rst_n;
				rsp_seq_item.MISO = SPI_monitor_vif.MISO;
				mon_ap.write(rsp_seq_item);
				`uvm_info("run_phase",rsp_seq_item.convert2string(),UVM_HIGH);
			end
		endtask
	endclass
endpackage