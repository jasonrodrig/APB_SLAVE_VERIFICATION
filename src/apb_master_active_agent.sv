class apb_master_active_agent extends uvm_agent;
	
	// declaring the handles for apb_master_driver , apb_master_sequencer , apb_master_active_monitor
	apb_master_driver          apb_master_active_driv;
	apb_master_sequencer       apb_master_active_seqr;
	apb_master_active_monitor  apb_master_active_mon;

	// registering the apb_master_active_agent component to the factory
	`uvm_component_utils(apb_master_active_agent)

	//--------------------------------------------------------//
	// Creating a new constructor for apb_master_active_agent //  
	//--------------------------------------------------------//

	function new (string name = "apb_master_active_agent", uvm_component parent);
		super.new(name, parent);
	endfunction 

	//------------------------------------------------------//
	// building apb_master_driver, apb_master_sequencer and //
	//            apb_master_active_monitor component       //  
	//------------------------------------------------------//

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(get_is_active() == UVM_ACTIVE) begin
			apb_master_active_driv = apb_master_driver::type_id::create("apb_master_active_driv", this);
			apb_master_active_seqr = apb_master_sequencer::type_id::create("apb_master_active_seqr", this);
		end
		  apb_master_active_mon = apb_master_active_monitor::type_id::create("apb_master_active_mon", this);
	endfunction

  //------------------------------------------------------//
	//   Connecting 2 component between apb_master_driver   //
	//            and apb_master_sequencer                  //  
	//------------------------------------------------------//

	function void connect_phase(uvm_phase phase);
		if(get_is_active() == UVM_ACTIVE) begin
			apb_master_active_driv.seq_item_port.connect(apb_master_active_seqr.seq_item_export);
		end
	endfunction
endclass  
