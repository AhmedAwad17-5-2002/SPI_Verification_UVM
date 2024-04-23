package ram_test_pkg;
import uvm_pkg::*;	
 import ram_env_pkg::*;
 import ram_config_pkg::*;
 import ram_main_seq_pkg::*;
 import ram_reset_seq_pkg::*;
import ram_write_seq_pkg::*;
import ram_read_seq_pkg::*;


 
 `include "uvm_macros.svh"
class ram_test extends uvm_test;
	`uvm_component_utils(ram_test)
	ram_env env;
	ram_config_obj ram_config_obj_test;
	ram_main_sequence main_seq;
	ram_reset_sequence reset_seq;
	ram_write_sequence write_seq;
	ram_read_sequence read_seq;
	virtual ram_if ram_vif;



	function new(string name="ram_test",uvm_component parent =null);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase (phase);
		main_seq=ram_main_sequence::type_id:: create("main_seq",this);
		reset_seq=ram_reset_sequence ::type_id:: create("reset_seq",this);
		write_seq=ram_write_sequence::type_id:: create("write_seq",this);
		read_seq=ram_read_sequence ::type_id:: create("read_seq",this);
		env=ram_env::type_id:: create("env",this);
		ram_config_obj_test=ram_config_obj::type_id:: create("ram_config_obj_test",this);

		uvm_config_db#(virtual ram_if)::get(this, "", "ram_IF",ram_config_obj_test.ram_config_vif);

        uvm_config_db#(ram_config_obj)::set(this, "*", "ram_IF1",ram_config_obj_test);
	endfunction


	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		`uvm_info("run_phase","reset_asserted",UVM_LOW)
		reset_seq.start(env.agt.sqr);
    `uvm_info("run_phase","reset_desserted",UVM_LOW)

   `uvm_info("run_phase","write_only_asserted",UVM_LOW)
    write_seq.start(env.agt.sqr);
    `uvm_info("run_phase","write_only_desserted",UVM_LOW)

`uvm_info("run_phase","read_only_asserted",UVM_LOW)
 read_seq.start(env.agt.sqr);
 `uvm_info("run_phase","read_only_desserted",UVM_LOW)
 `uvm_info("run_phase","read_and_write_asserted",UVM_LOW)
 main_seq.start(env.agt.sqr);
 `uvm_info("run_phase","read_and_write_desserted",UVM_LOW)

    	phase.drop_objection(this);


	endtask
endclass

endpackage