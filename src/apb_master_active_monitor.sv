class apb_master_active_monitor extends uvm_monitor;

	// declaring interface handle for active monitor
  virtual apb_master_interface.MONITOR vif;

	// declaring the analysis port for active monitor
	uvm_analysis_port#(apb_master_sequence_item) active_mon_port;

	// declaring the apb_master_sequence_item class handle
	apb_master_sequence_item seq;

	// registering the apb_master_active_monitor component to the factory
	`uvm_component_utils(apb_master_active_monitor)

	//----------------------------------------------------------//
	// Creating a new constructor for apb_master_active_monitor //  
	//----------------------------------------------------------//

	function new (string name = "apb_master_active_monitor", uvm_component parent);
		super.new(name, parent);
		active_mon_port = new("active_mon_port", this);
	endfunction

	//------------------------------------------------------//
	// building config_db in the apb_master_active_monitor  //  
	//------------------------------------------------------//

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = apb_master_sequence_item::type_id::create("apb_master_seq");
		if(!uvm_config_db#(virtual apb_master_interface)::get(this, "", "vif", vif))
			`uvm_fatal("NOVIF",{"virtual interface must be set for: APB MONITOR INTERFACE ",get_full_name(),".vif"});
	endfunction

	//------------------------------------------------------//
	//    capturing the input signals from the interface    //  
	//------------------------------------------------------//

	task run_phase(uvm_phase phase);
		repeat(3)@(vif.apb_master_monitor_cb);
		forever begin
			repeat(1)@(vif.apb_master_monitor_cb);
			seq.PRESETN = vif.apb_master_monitor_cb.PRESETN;
    	seq.PSELX   = vif.apb_master_monitor_cb.PRESETN;
    	seq.PWRITE  = vif.apb_master_monitor_cb.PRESETN;
    	seq.PENABLE = vif.apb_master_monitor_cb.PRESETN;
	    seq.PADDR   = vif.apb_master_monitor_cb.PRESETN;
  	  seq.PWDATA  = vif.apb_master_monitor_cb.PRESETN;
//    seq.PSTRB   = vif.apb_master_monitor_cb.PSTRB; 
      active_mon_port.write(seq); 
		end
	endtask
endclass

