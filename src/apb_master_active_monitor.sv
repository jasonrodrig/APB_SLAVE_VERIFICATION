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

	//--------------------------------------------------------//
	// capturing the input signals from the interface during  // 
	//     the transistion from IDLE -> SETUP -> ACSESS       //  
	//--------------------------------------------------------//

	task run_phase(uvm_phase phase);
		forever begin
			if( !vif.apb_master_monitor_cb.PSELX || !vif.apb_master_monitor_cb.PRESETN )
				idle_state();
			else if( vif.apb_master_monitor_cb.PSELX && !vif.apb_master_monitor_cb.PENABLE && vif.apb_master_monitor_cb.PRESETN ) 
			begin
				setup_state();
				access_state();
			end
		end
	endtask

	//-------------------------------------------------------------------//
	//    capturing the input signals from the interface in idle state   //  
	//-------------------------------------------------------------------//

	task idle_state();
		repeat(1)@(vif.apb_master_monitor_cb);
		seq.PRESETN = vif.apb_master_monitor_cb.PRESETN;
		seq.PSELX   = vif.apb_master_monitor_cb.PSELX;
		// `uvm_info( "ACTIVE_MON" ,
		//				     $sformatf( " PRESETN = %0B | PSELX = %0B | PWRITE = %0B | PENABLE = %0B | PREADY = %0B | PRDATA = %0D | PSLVERR = %0B ",
		//					   vif.apb_master_monitor_cb.PRESETN , vif.apb_master_monitor_cb.PSELX , vif.apb_master_monitor_cb.PWRITE , 
		//					   vif.apb_master_monitor_cb.PENABLE , vif.apb_master_monitor_cb.PREADY , vif.apb_master_monitor_cb.PRDATA , 
		//					   vif.apb_master_monitor_cb.PSLVERR  ) , UVM_NONE )
		// `uvm_info( "ACTIVE_MON" , $sformatf("data stored at slave[%d] = %d " , 
		//                           vif.apb_master_monitor_cb.PADDR, vif.apb_master_monitor_cb.PWDATA ) , UVM_NONE )
		active_mon_port.write(seq);
	endtask	

	//-------------------------------------------------------------------//
	//    capturing the input signals from the interface in setup state  //  
	//-------------------------------------------------------------------//

	task setup_state();
		repeat(1)@(vif.apb_master_monitor_cb);
		seq.PRESETN = vif.apb_master_monitor_cb.PRESETN;
		seq.PSELX   = vif.apb_master_monitor_cb.PSELX;
		seq.PWRITE  = vif.apb_master_monitor_cb.PWRITE;
		seq.PADDR   = vif.apb_master_monitor_cb.PADDR;
		seq.PWDATA  = vif.apb_master_monitor_cb.PWDATA;
		seq.PENABLE = vif.apb_master_monitor_cb.PENABLE;
		seq.PSTRB   = vif.apb_master_monitor_cb.PSTRB;
	endtask

	//-------------------------------------------------------------------//
	//    capturing the input signals from the interface in access state //  
	//-------------------------------------------------------------------//

	task access_state();
		seq.PRESETN = vif.apb_master_monitor_cb.PRESETN;
		seq.PSELX   = vif.apb_master_monitor_cb.PSELX;
		seq.PWRITE  = vif.apb_master_monitor_cb.PWRITE;
		seq.PADDR   = vif.apb_master_monitor_cb.PADDR;
		seq.PWDATA  = vif.apb_master_monitor_cb.PWDATA;
		seq.PENABLE = vif.apb_master_monitor_cb.PENABLE;
		seq.PSTRB   = vif.apb_master_monitor_cb.PSTRB;

		while(!vif.apb_master_monitor_cb.PREADY)
			@(vif.apb_master_monitor_cb);
		//`uvm_info( "ACTIVE_MON" ,
		//            $sformatf( " PRESETN = %0B | PSELX = %0B | PWRITE = %0B | PADDR = %0D | PENABLE = %0B | PREADY = %0B | PRDATA = %0D | 
		//            PSLVERR = %0B ", vif.apb_master_monitor_cb.PRESETN , vif.apb_master_monitor_cb.PSELX , vif.apb_master_monitor_cb.PWRITE ,
		//            vif.apb_master_monitor_cb.PADDR , vif.apb_master_monitor_cb.PENABLE , vif.apb_master_monitor_cb.PREADY , 
		//            vif.apb_master_monitor_cb.PRDATA , vif.apb_master_monitor_cb.PSLVERR  ) , UVM_NONE )
		// if( vif.apb_master_monitor_cb.PWRITE )
		// `uvm_info( "ACTIVE_MON" , 
		//             $sformatf("data stored at slave[%d] = %d " , vif.apb_master_monitor_cb.PADDR, vif.apb_master_monitor_cb.PWDATA ) , UVM_NONE )

		active_mon_port.write(seq); 
		repeat(2)@(vif.apb_master_monitor_cb);
	endtask

endclass
