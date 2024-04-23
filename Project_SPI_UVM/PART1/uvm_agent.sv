package ram_agent_pkg;
import uvm_pkg::*;
import ram_config_pkg::*;
import ram_driver_pkg::*;
import my_sequencer_pkg::*;
import ram_monitor_pkg::*;
import ram_seq_item_pkg::*;

`include "uvm_macros.svh"
class ram_agent extends uvm_agent;
 `uvm_component_utils(ram_agent)
 MySequencer sqr;
 ram_config_obj ram_cfg;
 uvm_analysis_port#(ram_seq_item) agt_ap;
 ram_driver drv;
 ram_monitor mon;

function new(string name ="ram_agent",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_config_db #(ram_config_obj)::get(this,"","ram_IF1",ram_cfg);
sqr= MySequencer::type_id::create("sqr",this);
drv= ram_driver::type_id::create("drv",this);
mon= ram_monitor::type_id::create("mon",this);
agt_ap=new("agt_ap",this);
endfunction

function void connect_phase(uvm_phase phase);
	drv.ram_driver_vif=ram_cfg.ram_config_vif;
	mon.ram_vif=ram_cfg.ram_config_vif;
	drv.seq_item_port.connect(sqr.seq_item_export);
	mon.mon_ap.connect(agt_ap);
endfunction 
endclass
endpackage 
