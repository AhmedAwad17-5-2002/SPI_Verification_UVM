package ram_reset_seq_pkg;
	import ram_seq_item_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class ram_reset_sequence extends  uvm_sequence #(ram_seq_item);
		`uvm_object_utils(ram_reset_sequence)
		ram_seq_item seq_item;

		function new(string name = "ram_reset_sequence");
			super.new(name);
		endfunction

		task body;
			seq_item = ram_seq_item::type_id::create("seq_item");
			
			repeat(5)
			begin
			start_item(seq_item);
			seq_item.rst_n = 0;
			seq_item.din = 0;
			seq_item.rx_valid = 0;
			finish_item(seq_item);
		end
		endtask
	endclass
endpackage