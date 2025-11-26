class apb_master_environment extends uvm_env;

  // declaring handle for apb_master_active_agent, apb_master_passive_agent,
	// apb_master_scoreboard and apb_master_coverage
	apb_master_passive_agent apb_master_passive_agt;
	apb_master_active_agent  apb_master_active_agt;
	apb_master_scoreboard    apb_master_scb;
	apb_master_subscriber    apb_master_sub;

	// registering the apb_master_component to the factory
	`uvm_component_utils(apb_master_environment)

	//------------------------------------------------------//
	// Creating a new constructor for apb_master_environment//  
	//------------------------------------------------------//

	function new(string name = "apb_master_environment", uvm_component parent);
		super.new(name, parent);
	endfunction

	//------------------------------------------------------//
	//       building component for apb_master_active_agent //
	//  apb_master_passive_agent, apb_master_scoreboard and //
  //                apb_master_coverage                   //  
	//------------------------------------------------------//

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		apb_master_active_agt  = apb_master_active_agent::type_id::create("apb_master_active_agt", this);
		apb_master_passive_agt = apb_master_passive_agent::type_id::create("apb_master_passive_agt", this);
		apb_master_scb = apb_master_scoreboard::type_id::create("apb_master_scoreboard", this);
		apb_master_sub = apb_master_subscriber::type_id::create("apb_master_subscriber", this);
		set_config_int("apb_master_active_agt","is_active",UVM_ACTIVE);
		set_config_int("apb_master_passive_agt","is_active",UVM_PASSIVE);
	endfunction

	//---------------------------------------------------------//
	//            Connecting 2 component:                      //
	//  1 ) apb_master_active_monitor to apb_master_scoreboard //
	//  2 ) apb_master_active_monitor to apb_master_coverage   // 
	//  3 ) apb_master_passive_monitor to apb_master_scoreboard//
	//  4 ) apb_master_passive_monitor to apb_master_coverage  //
	//---------------------------------------------------------//

	function void connect_phase(uvm_phase phase);
		apb_master_active_agt.apb_master_active_mon.active_mon_port.connect(apb_master_scb.active_scb_port);
		apb_master_active_agt.apb_master_active_mon.active_mon_port.connect(apb_master_sub.cov_active_mon_port);
		apb_master_passive_agt.apb_master_passive_mon.passive_mon_port.connect(apb_master_scb.passive_scb_port);	
		apb_master_passive_agt.apb_master_passive_mon.passive_mon_port.connect(apb_master_sub.cov_passive_mon_port);
	endfunction
endclass


