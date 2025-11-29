class apb_master_passive_monitor extends uvm_monitor;

	// declaring interface handle for passive monitor
	virtual apb_master_interface.MONITOR vif;

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

	//--------------------------------------------------------//
	// capturing the output signals from the interface during //
	//			the transistion from IDLE-> SETUP -> ACCESS       //  
	//--------------------------------------------------------//

	task run_phase(uvm_phase phase);
		repeat(3) @(vif.apb_master_monitor_cb);
		forever begin
			//	repeat(1) @(vif.apb_master_monitor_cb);
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
	//   capturing the output signals from the interface in idle state   //  
	//-------------------------------------------------------------------//

	task idle_state();
		repeat(1)@(vif.apb_master_monitor_cb);
		seq.PREADY  = vif.apb_master_monitor_cb.PREADY;
		seq.PRDATA  = vif.apb_master_monitor_cb.PRDATA;
		seq.PSLVERR = vif.apb_master_monitor_cb.PSLVERR;
		passive_mon_port.write(seq); 
	endtask		

	//-------------------------------------------------------------------//
	//   capturing the output signals from the interface in setup state  //  
	//-------------------------------------------------------------------//

	task setup_state();
		repeat(1)@(vif.apb_master_monitor_cb);
	endtask

	//-------------------------------------------------------------------//
	//   capturing the output signals from the interface in access state //  
	//-------------------------------------------------------------------//

	task access_state();
		// not sure where to place the output either before or after 
		// once the design ccode is shared , need to do trail and error

		seq.PREADY  = vif.apb_master_monitor_cb.PREADY;
		seq.PRDATA  = vif.apb_master_monitor_cb.PRDATA;
		seq.PSLVERR = vif.apb_master_monitor_cb.PSLVERR; 

		while(!vif.apb_master_monitor_cb.PREADY)
		begin
			repeat(1)@(vif.apb_master_monitor_cb);
		end

		// not sure when to send the signals to the scoreboard
		// yet to confirm once design is sent
		repeat(1)@(vif.apb_master_monitor_cb);
		passive_mon_port.write(seq); 
		//repeat(1)@(vif.apb_master_monitor_cb);
	endtask

endclass
