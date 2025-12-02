class apb_master_driver extends uvm_driver#(apb_master_sequence_item);

	// declaring interface handle
	virtual apb_master_interface.DRIVER vif;

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

	//-------------------------------------------------------//
	// Driver code for all 3 states | IDLE -> SETUP -> ACCESS//  
	//-------------------------------------------------------//

	task apb_master_driver_code();
		if( !req.PRESETN || !req.PSELX ) 
			idle_state();
		else begin
			setup_state();
			access_state();
		end
	endtask

	//------------------------------------------------------//
	//           Driver code for idle state                 //  
	//------------------------------------------------------//

	task idle_state();
		repeat(1) @(vif.apb_master_driver_cb);
		vif.apb_master_driver_cb.PSELX   <= req.PSELX; 
		vif.apb_master_driver_cb.PRESETN <= req.PRESETN; 
		vif.apb_master_driver_cb.PENABLE <= 'b0;
		// `uvm_info( "Driver" , $sformatf( " PRESETN = %0B | PSELX = %0B | PWRITE = %0B | PENABLE = %0B  ", req.PRESETN , req.PSELX , req.PWRITE , req.PENABLE ) , UVM_NONE )
		// `uvm_info( "Driver" , $sformatf(" data strored at slave[%d] = %d " , req.PADDR, req.PWDATA ) , UVM_NONE )


	endtask

	//------------------------------------------------------//
	//           Driver code for setup state                //  
	//------------------------------------------------------//

	task setup_state();
		@(vif.apb_master_driver_cb);
		vif.apb_master_driver_cb.PSELX   <=  req.PSELX; 
		vif.apb_master_driver_cb.PRESETN <=  req.PRESETN; 
		vif.apb_master_driver_cb.PENABLE <= 'b0;
		vif.apb_master_driver_cb.PADDR   <=  req.PADDR;
		vif.apb_master_driver_cb.PWRITE  <=  req.PWRITE;
		vif.apb_master_driver_cb.PWDATA  <=  req.PWDATA;
		// `uvm_info( "Driver" ,
		//				$sformatf( " PRESETN = %0B | PSELX = %0B | PWRITE = %0B | PENABLE = %0B ",
		//                        req.PRESETN , req.PSELX , req.PWRITE , req.PENABLE ),  UVM_NONE )
		//`uvm_info( "Driver" , $sformatf("data strored at slave[%d] = %d " , req.PADDR, req.PWDATA ) , UVM_NONE )
	endtask

	//------------------------------------------------------//
	//           Driver code for access state               //  
	//------------------------------------------------------//

	task access_state();
		@(vif.apb_master_driver_cb);
		vif.apb_master_driver_cb.PENABLE <= 'b1;
		wait_state_detection();
		// `uvm_info( "Driver" ,
		//			$sformatf( " PRESETN = %0B | PSELX = %0B | PWRITE = %0B | PENABLE = %0B ",
		//                       req.PRESETN , req.PSELX , req.PWRITE , req.PENABLE ),  UVM_NONE )
		//`uvm_info( "Driver" , $sformatf("data strored at slave[%d] = %d " , req.PADDR, req.PWDATA ) , UVM_NONE )

		vif.apb_master_driver_cb.PSELX <= 0;
		vif.apb_master_driver_cb.PENABLE <= 0;
	endtask

	//------------------------------------------------------//
	//     Driver code for wait state when pready = 0       //  
	//------------------------------------------------------//

	task wait_state_detection();
		while (!vif.apb_master_driver_cb.PREADY)
			@(vif.apb_master_driver_cb);
		@(vif.apb_master_driver_cb);
	endtask

endclass
