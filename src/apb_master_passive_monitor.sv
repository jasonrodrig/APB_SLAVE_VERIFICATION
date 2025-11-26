class apb_master_passive_monitor extends uvm_monitor;

	// declaring interface handle for passive monitor
	virtual apb_master_interface vif;

	// declaring the analysis port for passive monitor
	uvm_analysis_port#(apb_master_sequence_item) passive_mon_port;

	// declaring the apb_master_sequence_item class handle
	apb_master_sequence_item seq;

	// registering the apb_master_passive_monitor component to the factory
	`uvm_component_utils(apb_master_passive_monitor)

	//-------------------------------------------------------------//
	//  Creating a new constructor for apb_master_passive_monitor  //  
	//-------------------------------------------------------------//

	function new (string name = "apb_master_passive_monitor", uvm_component parent);
		super.new(name, parent);
		passive_mon_port = new("passive_mon_port", this);
	endfunction

	//---------------------------------------------------------//
	//   building config_db in the apb_master_passive_monitor  //  
	//---------------------------------------------------------//

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
    seq = apb_master_sequence_item::type_id::create("apb_master_seq");
		if(!uvm_config_db#(virtual apb_master_interface)::get(this, "", "vif", vif))
			`uvm_fatal("NOVIF",{"virtual interface must be set for:APB_MASTER MONITOR INTERFACE ",get_full_name(),".vif"});
	endfunction

	//------------------------------------------------------//
	//    capturing the output signals from the interface   //  
	//------------------------------------------------------//

	task run_phase(uvm_phase phase);
		forever begin
			repeat(3) @(vif.apb_master_monitor_cb);
			 // MONITOR LOGIC PASSSIVE
      passive_mon_port.write(seq); 
		end
	endtask
endclass
