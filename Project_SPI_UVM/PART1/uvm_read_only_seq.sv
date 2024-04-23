package ram_read_seq_pkg;
	import uvm_pkg::*;
	import ram_seq_item_pkg::*;
	`include "uvm_macros.svh"
	class ram_read_sequence extends  uvm_sequence #(ram_seq_item);
		`uvm_object_utils(ram_read_sequence)
		ram_seq_item seq_item;

		function new(string name = "ram_reset_sequence");
			super.new(name);
		endfunction
//->  read only sequence
		task body;
	seq_item = ram_seq_item::type_id::create("seq_item");
	seq_item.WRITE_SIG=0;
	seq_item.READ_SIG=0;
	seq_item.write_only.constraint_mode(0);
	seq_item.Din.constraint_mode(0);
			repeat(1000)
			begin
			start_item(seq_item);
	
assert(seq_item.randomize());
if(seq_item.din[9:8]==2'b10)
seq_item.READ_SIG=1;
else if(seq_item.din[9:8]==2'b11)
	seq_item.READ_SIG=0;
	finish_item(seq_item);
			end
		endtask
	endclass
endpackage

