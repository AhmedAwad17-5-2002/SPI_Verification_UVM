package SPI_seq_item_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class SPI_seq_item extends uvm_sequence_item;
		`uvm_object_utils(SPI_seq_item)
		rand logic SS_n,rst_n,MOSI;
	   // logic  WRITE_ADD  = 1;
	    //logic READ_ADD = 1;
		rand logic [12:0] din;
		logic MISO,MISO_G;
		function new(string name = "SPI_seq_item");
			super.new(name);
		endfunction

		function string convert2string();
			return $sformatf("%s rst_n = 0b%0b,MOSI = 0b%0b,SS_n = 0b%0b,MISO = 0b%0b",super.convert2string(),rst_n,MOSI,SS_n,MISO);
		endfunction

		function string convert2string_stimulus();
		return $sformatf("rst_n = 0b%0b,MOSI = 0b%0b,SS_n = 0b%0b",rst_n,MOSI,SS_n);
		endfunction

		constraint c1 {
			rst_n dist {1:=98,0:=2};
		}
		constraint c2 {
			SS_n dist {1:=98,0:=2};
		}
		constraint c3 {
			SS_n dist {0:=98,1:=2};
		}
		constraint c4 {
			din[11:8] == 4'b0000;
		}
		constraint c5 {
			din[11:8] == 4'b0001;
		}
		constraint c6 {
			din[11:8] == 4'b1111;
		}
		constraint c7 {
			din[11:8] == 4'b1110;
		}
		/*constraint c5 {
		if(WRITE_SIG==0)
			MOSI dist {1:=50,0:=50};
		if(WRITE_SIG == 1)
			MOSI == 0;
		}
		constraint c4 {

			if(cs==WRITE && WRITE_SIG==0) 
				din[9:8]==2'b00;
			else if(cs==WRITE && WRITE_SIG==1) {
				din[9]==0;
				din[8]==1;
			}
			else if(cs==READ_ADD) {
				din[9]==1;
				din[8]==0;
			}
			else if(cs==READ_DATA) {
				din[9]==1;
				din[8]==1;
			}
		}*/
		/*constraint c4 {
		if(SS_n == 0){
		if(WRITE_ADD && READ_ADD)
			din[11:8] dist {4'b0000:=50,4'b1110:=50};
		else if(WRITE_ADD)
			din[11:8] dist {4'b0111:=100};
		else
			din[11:8] dist {4'b0001:=100};
		}
		}*/
	endclass
endpackage