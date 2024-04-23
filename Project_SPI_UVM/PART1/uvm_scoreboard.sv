package ram_scoreboard_pkg;
	import uvm_pkg::*;
	import ram_seq_item_pkg::*;
	

	`include "uvm_macros.svh"

	class ram_scoreboard extends uvm_scoreboard;
		`uvm_component_utils(ram_scoreboard)
		uvm_analysis_export #(ram_seq_item) sb_export;
		uvm_tlm_analysis_fifo #(ram_seq_item) sb_fifo;
		ram_seq_item seq_item_sb;
		logic [ADDR_SIZE-1:0] dout_ref;
		logic tx_valid_ref;
		logic [ADDR_SIZE-1:0] write_address,read_address;
		logic  [ADDR_SIZE-1:0] mem[MEM_DEPTH-1:0];
		
		int error_count = 0;
		int correct_count = 0;

		function new(string name = "ram_scoreboard",uvm_component parent = null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sb_export=new("sb_export",this);
		sb_fifo=new("sb_fifo",this);

		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			sb_export.connect(sb_fifo.analysis_export);
		endfunction 

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever
			begin
			sb_fifo.get(seq_item_sb);
			ref_model(seq_item_sb);
			if(seq_item_sb.dout != dout_ref || seq_item_sb.tx_valid != tx_valid_ref )
				begin
			`uvm_error("run_phase",$sformatf("Comparison failed, transaction received by the DUT:%s while the refrence dout:0b%0b,tx_valid:0b%0b",seq_item_sb.convert2string(),dout_ref,tx_valid_ref));
					error_count++;

			end	
				else
				begin
				`uvm_info("run_phase",$sformatf("correct out: %s",seq_item_sb.convert2string()),UVM_HIGH);
					correct_count++;
				end
			end
			
		endtask

task ref_model(ram_seq_item seq_item_chk);

		  	if (~seq_item_chk.rst_n) begin
		dout_ref=0;
		tx_valid_ref=0;
	end
	else if (seq_item_chk.rx_valid) begin
		case ( seq_item_chk.din [9:8])
		  2'b00: begin
		    write_address= seq_item_chk.din[ADDR_SIZE-1:0];
		    tx_valid_ref = 0;
          end 
		  2'b01: begin
		    mem[write_address] = seq_item_chk.din [ADDR_SIZE-1:0]; 
		    tx_valid_ref = 0;
          end
		  2'b10: begin
		    read_address= seq_item_chk.din [ADDR_SIZE-1:0];
		    tx_valid_ref = 0;
          end
		  2'b11: begin
		    dout_ref= mem[read_address];
		    tx_valid_ref=1;
          end


		endcase        
			end
		endtask
		function void report_phase(uvm_phase phase);
			super.report_phase(phase);
			`uvm_info("report_phase",$sformatf("Total successful transactions:%0d",correct_count),UVM_MEDIUM);
			`uvm_info("report_phase",$sformatf("Total failed transactions:%0d",error_count),UVM_MEDIUM);
		endfunction

	endclass
endpackage
