package SPI_test_pkg;
	import SPI_env_pkg::*;
	import ram_env_pkg::*;
	import ram_config_pkg::*;
	import pkg::*;
	import SPI_reset_seq_pkg::*;
	import SPI_main_seq_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class SPI_test extends  uvm_test;
		`uvm_component_utils(SPI_test)

		SPI_env env_SPI;
		SPI_config_obj SPI_config_obj_test; 
		ram_env env_ram;
		ram_config_obj ram_config_obj_test;
		virtual SPI_if  SPI_test_vif;
		SPI_main_sequence main_seq;
		SPI_reset_sequence reset_seq;

		function new(string name = "SPI_test", uvm_component parent = null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			env_SPI = SPI_env::type_id::create("env_SPI",this);
			SPI_config_obj_test = SPI_config_obj::type_id::create("SPI_config_obj_test",this);
			main_seq = SPI_main_sequence::type_id::create("main_seq",this);
			reset_seq = SPI_reset_sequence::type_id::create("reset_seq",this);
			env_ram = ram_env::type_id::create("env_ram",this);
			ram_config_obj_test = ram_config_obj::type_id::create("ram_config_obj_test",this);
			SPI_config_obj_test.active = UVM_ACTIVE;
			uvm_config_db#(virtual SPI_if)::get(this, "", "SPI_IF",SPI_config_obj_test.SPI_config_vif);
			uvm_config_db#(SPI_config_obj)::set(this, "*", "SPI_IF1",SPI_config_obj_test);
			ram_config_obj_test.active = UVM_PASSIVE;
			uvm_config_db#(virtual ram_if)::get(this, "", "RAM_IF",ram_config_obj_test.ram_config_vif);
			uvm_config_db#(ram_config_obj)::set(this, "*", "RAM_IF1",ram_config_obj_test);
			endfunction

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			phase.raise_objection(this);
			`uvm_info("run_phase","reset_asserted",UVM_LOW)
			reset_seq.start(env_SPI.agt.sqr);
			`uvm_info("run_phase","reset_deasserted",UVM_LOW)

			`uvm_info("run_phase","stimulus generation started",UVM_LOW)
			main_seq.start(env_SPI.agt.sqr);
			`uvm_info("run_phase","stimulus generation ended",UVM_LOW)
			phase.drop_objection(this);
		endtask : run_phase
	endclass
	
endpackage
