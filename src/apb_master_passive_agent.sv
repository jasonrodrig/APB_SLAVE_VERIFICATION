class apb_master_passive_agent extends uvm_agent;
  // declaring the handle for apb_master_passive_monitor
  apb_master_passive_monitor apb_master_passive_mon;

	// registering the apb_master_passive_agent component to the factory	
	`uvm_component_utils(apb_master_passive_agent)

	//------------------------------------------------------//
	//  Creating a new constructor for apb_master_passive_agent    //  
	//------------------------------------------------------//

	function new(string name = "apb_master_passive_agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction 

	//------------------------------------------------------//
	//   building apb_master_passive_monitor component      //  
	//------------------------------------------------------//

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(get_is_active() == UVM_PASSIVE) begin	
			apb_master_passive_mon = apb_master_passive_monitor::type_id::create("apb_master_passive_mon", this);
		end
	endfunction
endclass  
