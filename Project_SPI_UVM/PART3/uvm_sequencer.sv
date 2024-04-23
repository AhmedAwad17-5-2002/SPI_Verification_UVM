package RAM_sequencer_pkg;
	import uvm_pkg::*;
	import ram_seq_item_pkg::*;
	`include "uvm_macros.svh"
	class MySequencer extends  uvm_sequencer #(ram_seq_item);
		`uvm_component_utils(MySequencer)
		function new(string name = "MySequencer",uvm_component parent = null);
			super.new(name,parent);
		endfunction
	endclass
endpackage
