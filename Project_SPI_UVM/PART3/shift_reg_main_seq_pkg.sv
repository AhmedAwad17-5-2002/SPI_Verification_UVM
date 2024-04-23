package SPI_main_seq_pkg;
	import uvm_pkg::*;
	import SPI_seq_item_pkg::*;
	`include "uvm_macros.svh"
	typedef enum logic [2:0] {IDLE=0,CHK=7,WRITE=4,READ_ADD=3,READ_DATA=1} e_CS;
	class SPI_main_sequence extends  uvm_sequence #(SPI_seq_item);
		`uvm_object_utils(SPI_main_sequence)
		SPI_seq_item seq_item;
		logic[12:0] din_r;
		bit WRITE_DATA,READ_DATA;
		bit WRITE = 1;
		int i = 11;
		function new(string name = "SPI_reset_sequence");
			super.new(name);
		endfunction

		task body;
			seq_item = SPI_seq_item::type_id::create("seq_item");
			repeat(200000) begin
			start_item(seq_item);
			if(i > -1) begin
				seq_item.c2.constraint_mode(0);
				seq_item.c3.constraint_mode(1);
			end
			else begin
				if (READ_DATA == 0 ) begin
					seq_item.c2.constraint_mode(1);
					seq_item.c3.constraint_mode(0);
				end
				else if (READ_DATA) begin
					seq_item.c2.constraint_mode(0);
					seq_item.c3.constraint_mode(1);
					if (i == -12) begin
					seq_item.c2.constraint_mode(1);
					seq_item.c3.constraint_mode(0);
					end
				end
			end
			if (i == -1) begin
				if (din_r[9:8] == 2'b00) begin
					WRITE_DATA = 1;
				end
				else if (din_r[9:8] == 2'b01) begin
					WRITE_DATA = 0;
					WRITE = ~ WRITE;
				end
				else if (din_r[9:8] == 2'b10) begin
					READ_DATA = 1;
				end
			end
			else if (seq_item.rst_n == 0) begin
				READ_DATA = 0;
				WRITE = ~WRITE;
			end
			else if (i==-12) begin
				if (din_r[9:8] == 2'b11) begin
					READ_DATA = 0;
					WRITE = ~ WRITE;
				end
			end
			if (!WRITE_DATA && WRITE) begin
				seq_item.c4.constraint_mode(1);
				seq_item.c5.constraint_mode(0);
				seq_item.c6.constraint_mode(0);
				seq_item.c7.constraint_mode(0);
			end
			else if (!READ_DATA && !WRITE) begin
				seq_item.c4.constraint_mode(0);
				seq_item.c5.constraint_mode(0);
				seq_item.c6.constraint_mode(0);
				seq_item.c7.constraint_mode(1);
			end
			else if (WRITE_DATA && WRITE) begin
				seq_item.c5.constraint_mode(1);
				seq_item.c4.constraint_mode(0);
				seq_item.c6.constraint_mode(0);
				seq_item.c7.constraint_mode(0);
			end
			else if (READ_DATA && !WRITE) begin
				seq_item.c6.constraint_mode(1);
				seq_item.c5.constraint_mode(0);
				seq_item.c4.constraint_mode(0);
				seq_item.c7.constraint_mode(0);
			end
			assert(seq_item.randomize());
			if (i==11) begin
				din_r = seq_item.din;
			end
			if (seq_item.SS_n) begin
				seq_item.MOSI = din_r[12];
				i = 11;
			end
			else begin
				seq_item.MOSI = din_r[i];
				if(i<=-1) begin
					seq_item.MOSI = din_r[0];
				end
				if (seq_item.rst_n) begin
					i = i-1;
				end
				else begin
					i = 11;
				end
			end
			finish_item(seq_item);
		end
		endtask
	endclass
endpackage




			/*seq_item.constraint_mode(0); 
            seq_item.rand_mode(1);
		    seq_item.din.rand_mode(0);
            seq_item.c5.constraint_mode(1);
            seq_item.c1.constraint_mode(1);
            seq_item.c3.constraint_mode(1);
			assert(seq_item.randomize());
			 if(SPI_driver_vif.dpm.cs!=IDLE && SPI_driver_vif.dpm.cs!=CHK) begin
				    seq_item.constraint_mode(0);
					seq_item.c4.constraint_mode(1);
					seq_item.rand_mode(0);
				    seq_item.din.rand_mode(1);
				    assert(seq_item.randomize());

				    for(int j=9;j>=0;j=j-1) begin
				    	seq_item.MOSI=seq_item.din[j];
				    	//@(negedge clk);
				    end
				    /*if(SPI_driver_vif.dpm.cs==READ_DATA) begin
				    	for (int i = 0; i < 9; i++) begin
				    		check_data();
				    	end
				    end
				    if(SPI_driver_vif.dpm.cs==WRITE)
				    	seq_item.WRITE_SIG= ~ seq_item.WRITE_SIG;
				    seq_item.constraint_mode(0);
				    seq_item.c2.constraint_mode(1);
				   	seq_item.SS_n.rand_mode(1);
				    assert(seq_item.randomize());
				    seq_item.SS_n = seq_item.SS_n;*/

				  /*  int i=12;
			repeat(10000) begin
			seq_item = SPI_seq_item::type_id::create("seq_item");
			start_item(seq_item);
			if(i > -1) begin
				seq_item.c2.constraint_mode(0);
				seq_item.c3.constraint_mode(1);
			end
			else begin
				seq_item.c2.constraint_mode(1);
				seq_item.c3.constraint_mode(0);
				i=12;
			end
			if (i<12) begin
				seq_item.c4.constraint_mode(0);
			end
			else begin
				seq_item.c4.constraint_mode(1);
			end
			assert(seq_item.randomize());
			if (i == 12) begin
				din_r = seq_item.din;
			end
			if(seq_item.SS_n == 0) begin
				if(i<=-1) begin
					seq_item.MOSI =din_r[0];
				end
				seq_item.MOSI = din_r[i];
				i=i-1;
				seq_item.din.rand_mode(0);
			end
				finish_item(seq_item);
		end*/