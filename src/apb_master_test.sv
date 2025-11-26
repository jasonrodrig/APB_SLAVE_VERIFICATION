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

/*
//------------------------------------------------------//
//         single operand arithmatic test               //  
//------------------------------------------------------//

class single_operand_arithmatic_test extends apb_master_test;

	`uvm_component_utils( single_operand_arithmatic_test)
	single_operand_arithmatic seq1;

	function new(string name = " single_operand_arithmatic_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq1 = single_operand_arithmatic ::type_id::create("apb_master_seq1");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq1.start(apb_master_env.alu_active_agt.alu_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//         single operand logical test                  //  
//------------------------------------------------------//

class single_operand_logical_test extends apb_master_test;

	`uvm_component_utils( single_operand_logical_test)
	single_operand_logical seq2;

	function new(string name = " single_operand_logical_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq2 = single_operand_logical::type_id::create("apb_master_seq2");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq2.start(apb_master_env.alu_active_agt.alu_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//         two operand arithmatic test                  //  
//------------------------------------------------------//

class two_operand_arithmatic_test extends apb_master_test;

	`uvm_component_utils( two_operand_arithmatic_test)
	two_operand_arithmatic seq3;

	function new(string name = " two_operand_arithmatic_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq3 = two_operand_arithmatic ::type_id::create("apb_master_seq3");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq3.start(apb_master_env.alu_active_agt.alu_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//            two operand logical test                  //  
//------------------------------------------------------//

class two_operand_logical_test extends apb_master_test;

	`uvm_component_utils( two_operand_logical_test)
	two_operand_logical seq4;

	function new(string name = " two_operand_logical_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq4 = two_operand_logical::type_id::create("apb_master_seq4");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq4.start(apb_master_env.alu_active_agt.alu_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//      single operand arithmatic error test            //  
//------------------------------------------------------//

class single_operand_arithmatic_error_test extends apb_master_test;
	`uvm_component_utils( single_operand_arithmatic_error_test)
	single_operand_arithmatic_error seq5;
	function new(string name = " single_operand_arithmatic_error_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq5 = single_operand_arithmatic_error ::type_id::create("apb_master_seq5");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq5.start(apb_master_env.alu_active_agt.alu_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//      single operand logical error test               //  
//------------------------------------------------------//

class single_operand_logical_error_test extends apb_master_test;

	`uvm_component_utils( single_operand_logical_error_test)
	single_operand_logical_error seq6;

	function new(string name = " single_operand_logical_error_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq6 = single_operand_logical_error::type_id::create("apb_master_seq6");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq6.start(apb_master_env.alu_active_agt.alu_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//      two operand arithmatic error test               //  
//------------------------------------------------------//

class two_operand_arithmatic_error_test extends apb_master_test;

	`uvm_component_utils( two_operand_arithmatic_error_test)
	two_operand_arithmatic_error seq7;

	function new(string name = " two_operand_arithmatic_error_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq7 = two_operand_arithmatic_error ::type_id::create("apb_master_seq7");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq7.start(apb_master_env.alu_active_agt.alu_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//       two operand logical error test                 //  
//------------------------------------------------------//

class two_operand_logical_error_test extends apb_master_test;

	`uvm_component_utils( two_operand_logical_error_test)
	two_operand_logical_error seq8;

	function new(string name = " two_operand_logical_error_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq8 = two_operand_logical_error::type_id::create("apb_master_seq8");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq8.start(apb_master_env.alu_active_agt.alu_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//            rotate right error test                   //  
//------------------------------------------------------//

class rotate_right_error_test extends apb_master_test;

	`uvm_component_utils( rotate_right_error_test)
	rotate_right_error seq9;

	function new(string name = "rotate_right_error_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq9 = rotate_right_error::type_id::create("apb_master_seq9");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq9.start(apb_master_env.alu_active_agt.alu_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//            rotate left error test                    //  
//------------------------------------------------------//

class rotate_left_error_test extends apb_master_test;

	`uvm_component_utils( rotate_left_error_test)
	rotate_left_error seq10;

	function new(string name = "rotate_left_error_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq10 = rotate_left_error::type_id::create("apb_master_seq10");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq10.start(apb_master_env.alu_active_agt.alu_active_seqr);
		phase.drop_objection(this);  
	endtask
endclass

//------------------------------------------------------//
//         16 clock cycle arithmatic test               //  
//------------------------------------------------------//

class cycle_16_arithmatic_test extends apb_master_test;

	`uvm_component_utils( cycle_16_arithmatic_test)
	cycle_16_arithmatic seq11;

	function new(string name = "cycle_16_arithmatic_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq11 = cycle_16_arithmatic::type_id::create("apb_master_seq11");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq11.start(apb_master_env.alu_active_agt.alu_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//         16 clock cycle logical test                  //  
//------------------------------------------------------//

class cycle_16_logical_test extends apb_master_test;

	`uvm_component_utils( cycle_16_logical_test)
	cycle_16_logical seq12;

	function new(string name = "cycle_16_logical_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq12 = cycle_16_logical::type_id::create("apb_master_seq12");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq12.start(apb_master_env.alu_active_agt.alu_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//           comparsion test for opa > opb,             //
//             opa < opb and opa = opb                  //  
//------------------------------------------------------//

class comparison_test extends apb_master_test;

	`uvm_component_utils( comparison_test)
	comparison seq13;

	function new(string name = "comparison_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq13 = comparison::type_id::create("apb_master_seq13");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq13.start(apb_master_env.alu_active_agt.alu_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
// invlaid cmd test for arithmatic and logical operation//  
//------------------------------------------------------//

class invalid_cmd_test extends apb_master_test;

	`uvm_component_utils( invalid_cmd_test)
	invalid_cmd seq14;

	function new(string name = "invalid_cmd_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq14 = invalid_cmd::type_id::create("apb_master_seq14");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq14.start(apb_master_env.alu_active_agt.alu_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//      16 clock cycle arithmatic error test            //  
//------------------------------------------------------//

class cycle_16_arithmatic_error_test extends apb_master_test;

	`uvm_component_utils( cycle_16_arithmatic_error_test)
	cycle_16_arithmatic_error seq15;

	function new(string name = "cycle_16_arithmatic_error_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq15 = cycle_16_arithmatic_error::type_id::create("apb_master_seq15");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq15.start(apb_master_env.alu_active_agt.alu_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//         16 clock cycle logical error test            //  
//------------------------------------------------------//

class cycle_16_logical_error_test extends apb_master_test;

	`uvm_component_utils( cycle_16_logical_error_test)
	cycle_16_logical_error seq16;

	function new(string name = "cycle_16_logical_error_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq16 = cycle_16_logical_error::type_id::create("apb_master_seq16");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq16.start(apb_master_env.alu_active_agt.alu_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

*/

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


