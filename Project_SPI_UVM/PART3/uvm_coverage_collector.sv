package ram_coverage_collector_pkg ;
import ram_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh" 
class ram_coverage_collector extends  uvm_component;
	`uvm_component_utils(ram_coverage_collector)
uvm_analysis_export#(ram_seq_item)cov_export;
uvm_tlm_analysis_fifo#(ram_seq_item)cov_fifo;
ram_seq_item seq_item_cov;

covergroup RAM_cvr();

Dout:coverpoint seq_item_cov.dout;

Din:coverpoint seq_item_cov.din[9:8]{
bins Write_address= {2'b00};
bins Write_data={2'b01};
bins read_address={2'b10};
bins read_data={2'b11};

}
DATA_IN:coverpoint seq_item_cov.din;

TX:coverpoint seq_item_cov.tx_valid
{ 
 bins ZERO={0};
 bins ONE ={1};
}
RX:coverpoint seq_item_cov.rx_valid
{ 
 bins ZERO={0};
 bins ONE ={1};
}

/*w_address:coverpoint ram_seq_item.write_address;

R_address:coverpoint ram_seq_item.read_address;*/

cross_1 : cross TX, Din
{option.cross_auto_bin_max=0;
    bins tx_valid_din= binsof(Din.read_data) && binsof(TX.ONE); 
  }

// Cross_2:cross w_address,RX
// {option.cross_auto_bin_max=0;
//   bins RX_W_ADDRESS= binsof(W_address) && binsof(RX);

// }

/*Cross_3: R_address,RX
{option.cross_auto_bin_max=0;
  bins RX_W_ADDRESS= binsof(R_address) && binsof(RX);

}*/

Cross_3: cross DATA_IN,RX
{option.cross_auto_bin_max=0;
  bins RX_W_ADDRESS= binsof(DATA_IN) && binsof(RX.ONE);

}
  
endgroup 


function new(string name="ram_coverage",uvm_component parent=null);
	super.new(name,parent);
	RAM_cvr=new();
endfunction

function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			cov_export = new("cov_export",this);
			cov_fifo = new("cov_fifo",this);
		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			cov_export.connect(cov_fifo.analysis_export);
		endfunction

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				cov_fifo.get(seq_item_cov);
				RAM_cvr.sample();
			end
		endtask


endclass 
endpackage