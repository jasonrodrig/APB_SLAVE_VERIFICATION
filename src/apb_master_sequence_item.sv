class apb_master_sequence_item extends uvm_sequence_item;

	//------------------------------------------------------//
	//             randomized input signals                 //  
	//------------------------------------------------------//
	     logic PSELX   , PENABLE;
	rand logic PRESETN , PWRITE ;
	rand logic [`DATA_WIDTH - 1:0] PWDATA ;
	rand logic [`ADDR_WIDTH - 1:0] PADDR;
	//rand logic [ ( `DATA_WIDTH / 8 ) - 1 : 0 ] PSTRB;

	//------------------------------------------------------//
	//          non randomized output signals               //  
	//------------------------------------------------------//

	logic [`DATA_WIDTH - 1 :0] PRDATA ;
	logic PREADY, PSLVERR;

	//------------------------------------------------------//
	//         registering input signals and output         //
	//                signals to the factory                //  
	//------------------------------------------------------//

	`uvm_object_utils_begin(apb_master_sequence_item)
	`uvm_field_int(PRESETN,UVM_ALL_ON)
	`uvm_field_int(PSELX,UVM_ALL_ON)
	`uvm_field_int(PENABLE,UVM_ALL_ON)
	`uvm_field_int(PWRITE,UVM_ALL_ON)
	`uvm_field_int(PWDATA,UVM_ALL_ON)
	`uvm_field_int(PADDR,UVM_ALL_ON)
//	`uvm_field_int(PSTRB,UVM_ALL_ON)
	`uvm_field_int(PRDATA,UVM_ALL_ON)
	`uvm_field_int(PREADY,UVM_ALL_ON)
	`uvm_field_int(PSLVERR,UVM_ALL_ON)
	`uvm_object_utils_end

	//--------------------------------------------------------//
	//Creating a new constructor for apb_master_sequence_item //  
	//--------------------------------------------------------//

	function new(string name = "apb_master_sequence_item");
		super.new(name);
	endfunction

endclass
