package SPI_agent_pkg;
	import uvm_pkg::*;
	import my_sequencer_pkg::*;
	import SPI_driver_pkg::*;
	import SPI_monitor_pkg::*;
	import SPI_seq_item_pkg::*;
	import pkg::*;
	
	`include "uvm_macros.svh"

	class SPI_agent extends  uvm_agent;
		`uvm_component_utils(SPI_agent)
		MySequencer sqr;
		SPI_driver drv;
		SPI_monitor mon;
		SPI_config_obj SPI_cfg;
		uvm_analysis_port #(SPI_seq_item) agt_ap;
		function new(string name = "SPI_agent",uvm_component parent = null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			uvm_config_db#(SPI_config_obj)::get(this, "", "SPI_IF1",SPI_cfg);
			sqr = MySequencer::type_id::create("sqr",this);
			drv = SPI_driver::type_id::create("drv",this);
			mon = SPI_monitor::type_id::create("mon",this);
			agt_ap = new("agt_ap",this);
		endfunction

		function void connect_phase(uvm_phase phase);
			drv.SPI_driver_vif = SPI_cfg.SPI_config_vif;
			mon.SPI_monitor_vif = SPI_cfg.SPI_config_vif;
			drv.seq_item_port.connect(sqr.seq_item_export);
			mon.mon_ap.connect(agt_ap);
		endfunction
	endclass
endpackage