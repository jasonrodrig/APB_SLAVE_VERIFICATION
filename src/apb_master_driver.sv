class apb_master_driver extends uvm_driver#(apb_master_sequence_item);

	// declaring interface handle
	virtual apb_master_interface vif;

	// registering the apb_master_driver to the factory
	`uvm_component_utils(apb_master_driver)

	//------------------------------------------------------//
	//  Creating a new constructor for apb_master_driver    //  
	//------------------------------------------------------//

	function new (string name = "apb_master_driver", uvm_component parent);
		super.new(name, parent);
	endfunction : new

	//------------------------------------------------------//
	//   building config_db in the apb_master_driver        //  
	//------------------------------------------------------//

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual apb_master_interface)::get(this,"","vif", vif))
			`uvm_fatal("NO_VIF",{"virtual interface must be set for: APB_MASTER_DRIVER ",get_full_name(),".vif"});
	endfunction

	//------------------------------------------------------//
	//                Running the driver                    //  
	//------------------------------------------------------//

	task run_phase(uvm_phase phase);
		forever begin  
			seq_item_port.get_next_item(req);
			apb_master_driver_code();   
			seq_item_port.item_done();
		end
	endtask

	//------------------------------------------------------//
	//                   Driver code                        //  
	//------------------------------------------------------//

	task apb_master_driver_code();
	
  endtask

endclass
