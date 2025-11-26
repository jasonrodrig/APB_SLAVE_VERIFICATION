class apb_master_sequencer extends uvm_sequencer#(apb_master_sequence_item);
	//------------------------------------------------------//
	// Registering the apb_master_sequencer componenet to factory  //  
	//------------------------------------------------------//

	`uvm_component_utils(apb_master_sequencer)

	//------------------------------------------------------//
	//    Creating a new constructor for apb_master_driver         //  
	//------------------------------------------------------//

	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction

endclass
