class apb_master_test extends uvm_test;

	// registering apb_master_test with the fatcory
	`uvm_component_utils(apb_master_test)

	// handle declaration for apb_master_environment and apb_master_test
	apb_master_environment apb_master_env;
	apb_master_sequence seq;
  apb_master_report_server srv;
	//------------------------------------------------------//
	//    Creating a new constructor for apb_master_test    //  
	//------------------------------------------------------//

	function new(string name = "apb_master_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	//------------------------------------------------------//
	//  building components for apb_master_environment      //
	//  and object for apb_master_sequence                  //  
	//------------------------------------------------------//

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		apb_master_env = apb_master_environment::type_id::create("apb_master_environment", this);
		seq = apb_master_sequence::type_id::create("apb_master_seq");
		srv = new();
		uvm_report_server::set_server(srv);
	endfunction : build_phase

	//------------------------------------------------------//
	//       Printing the ALU architecture toptoplogy       //  
	//------------------------------------------------------//

	function void end_of_elaboration();
		uvm_top.print_topology();
	endfunction

	//------------------------------------------------------//
	//             running the test sequence                //  
	//------------------------------------------------------//

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq.start(apb_master_env.apb_master_active_agt.apb_master_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//                    presetn test                      //  
//------------------------------------------------------//

class presetn_test extends apb_master_test;

	`uvm_component_utils( presetn_test)
	presetn seq0;

	function new(string name = " presetn_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq0 = presetn ::type_id::create("apb_master_seq0");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq0.start(apb_master_env.apb_master_active_agt.apb_master_active_seqr);
		phase.drop_objection(this);
	endtask
endclass


//------------------------------------------------------//
//              write transfer test                     //  
//------------------------------------------------------//

class write_transfer_test extends apb_master_test;

	`uvm_component_utils( write_transfer_test)
	 write_transfer seq1;

	function new(string name = "write_transfer_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq1 = write_transfer ::type_id::create("write_transfer_seq1");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq1.start(apb_master_env.apb_master_active_agt.apb_master_active_seqr);
		phase.drop_objection(this);
	endtask
endclass


//------------------------------------------------------//
//               read transfer test                     //  
//------------------------------------------------------//

class read_transfer_test extends apb_master_test;

	`uvm_component_utils( read_transfer_test)
	 read_transfer seq2;

	function new(string name = "read_transfer_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq2 = read_transfer ::type_id::create("read_transfer_seq2");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq2.start(apb_master_env.apb_master_active_agt.apb_master_active_seqr);
		phase.drop_objection(this);
	endtask
endclass



//------------------------------------------------------//
//     write_read_transfer back to back test            //  
//------------------------------------------------------//

class write_read_transfer_test extends apb_master_test;

	`uvm_component_utils( write_read_transfer_test)
	 write_read_transfer seq3;

	function new(string name = " write_read_transfer_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq3 = write_read_transfer::type_id::create("write_read_transfer_seq3");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq3.start(apb_master_env.apb_master_active_agt.apb_master_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//            		 mid reset test                       //  
//------------------------------------------------------//

class mid_reset_test extends apb_master_test;

	`uvm_component_utils(mid_reset_test)
	 mid_reset seq4;

	function new(string name = "mid_reset_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq4 = mid_reset::type_id::create("apb_master_mid_reset_seq4");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq4.start(apb_master_env.apb_master_active_agt.apb_master_active_seqr);
		phase.drop_objection(this);
	endtask
endclass


//------------------------------------------------------//
//                 slave error test                     //  
//------------------------------------------------------//

class slave_error_test extends apb_master_test;
	`uvm_component_utils( slave_error_test)
   slave_error seq5;
	function new(string name = " slave_error_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq5 = slave_error ::type_id::create("apb_master_slave_error_seq5");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq5.start(apb_master_env.apb_master_active_agt.apb_master_active_seqr);
		phase.drop_objection(this);
	endtask
endclass


//------------------------------------------------------//
//               write_Read strobe test                 //  
//------------------------------------------------------//

class write_read_strobe_test extends apb_master_test;

	`uvm_component_utils( write_read_strobe_test)
	 strobe_write_read seq6;

	function new(string name = " write_read_strobe_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq6 = strobe_write_read::type_id::create("apb_master_write_read_strobe");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq6.start(apb_master_env.apb_master_active_agt.apb_master_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//           idle state check test                      //  
//------------------------------------------------------//

class idle_state_check_test extends apb_master_test;

	`uvm_component_utils( idle_state_check_test)
	 idle_state_check seq7;

	function new(string name = " idle_state_check_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq7 = idle_state_check::type_id::create("apb_master_idle_state_check");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq7.start(apb_master_env.apb_master_active_agt.apb_master_active_seqr);
		phase.drop_objection(this);
	endtask
endclass


//------------------------------------------------------//
//           apb_master regression sequence test        //  
//------------------------------------------------------//

class apb_master_regression_test extends apb_master_test;

	`uvm_component_utils(apb_master_regression_test)
	apb_master_regression reg_test;

	function new(string name = "apb_master_regression_test", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		reg_test = apb_master_regression::type_id::create("apb_master_reg_test");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		reg_test.start(apb_master_env.apb_master_active_agt.apb_master_active_seqr);
		phase.drop_objection(this);
	endtask
endclass


