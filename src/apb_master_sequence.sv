class apb_master_sequence extends uvm_sequence#(apb_master_sequence_item);

	//------------------------------------------------------//
	// registering apb_master_sequence object to the factory//  
	//------------------------------------------------------//

	`uvm_object_utils(apb_master_sequence)

	//------------------------------------------------------//
	//   Creating a new constructor for apb_master_sequence//  
	//------------------------------------------------------//

	function new(string name = "apb_master_sequence");
		super.new(name);
	endfunction

	//------------------------------------------------------//
	//  Task to generate, randomize, and send ALU sequence  //
	//         items repeatedly until completion            //  
	//------------------------------------------------------//

	task body();
		repeat(`trans)begin
			req = apb_master_sequence_item::type_id::create("req");
			wait_for_grant();
			void'(req.randomize());
			send_request(req);
			wait_for_item_done();
		end
	endtask
endclass

//------------------------------------------------------//
//                   Preset sequence                    //  
//------------------------------------------------------//

class presetn extends uvm_sequence#(apb_master_sequence_item);
	`uvm_object_utils(presetn)

	function new(string name = "presetn");
		super.new(name);
	endfunction

	task body();
		`uvm_do_with(req,{ req.PRESETN == 0 ; })
	endtask
endclass 


//------------------------------------------------------//
//               write transfer sequence                //  
//------------------------------------------------------//

class write_transfer extends uvm_sequence#(apb_master_sequence_item);
	`uvm_object_utils(write_transfer)

	function new(string name = "write_transfer");
		super.new(name);
	endfunction

	task body();
	  
			`uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 1;
				 req.PSTRB == 0;
				 req.PADDR == 23;
				}
			)
    
		 `uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 1;
				 req.PSTRB == 0;
				 req.PADDR == 63;
				}
			)
    	
		`uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 1;
				 req.PSTRB == 0;
				 req.PADDR == 50;
				}
			)
    
	endtask
endclass 

//------------------------------------------------------//
//               read transfer sequence                //  
//------------------------------------------------------//

class read_transfer extends uvm_sequence#(apb_master_sequence_item);
	`uvm_object_utils(read_transfer)

	function new(string name = "read_transfer");
		super.new(name);
	endfunction

	task body();

			`uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 0;
				 req.PADDR == 23;
				}
			)
   
			`uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 0;
				 req.PADDR == 63;
				}
			)
   
			`uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 0;
				 req.PADDR == 50;
				}
			)
   
	endtask
endclass 

//------------------------------------------------------//
//          write_read back to back sequence            //  
//------------------------------------------------------//

class write_read_transfer extends uvm_sequence#(apb_master_sequence_item);
	`uvm_object_utils(write_read_transfer)

	function new(string name = "write_read_transfer");
		super.new(name);
	endfunction

	task body();

		bit [ `ADDR_WIDTH - 1 : 0 ] temp_addr;
		
		repeat(`trans) begin
				
			`uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 1;
				 req.PSTRB == 0;
				 req.PADDR inside {[0:63]};
				}
			)

			temp_addr = req.PADDR;

		  `uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 0;
				 req.PADDR == temp_addr;
				}
			)
    
		end
	endtask
endclass 


//------------------------------------------------------//
//  mid_reset transfer both write and read sequence     //  
//------------------------------------------------------//

class mid_reset extends uvm_sequence#(apb_master_sequence_item);
	`uvm_object_utils(mid_reset)

	function new(string name = "mid_reset");
		super.new(name);
	endfunction

	task body();
		
		repeat(`trans - 3 )  begin
     `uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 1;
				 req.PSTRB == 0;
				 req.PADDR inside {[0:63]};
				}
			)
		end
   
		`uvm_do_with( req , { req.PRESETN == 0; } )
  	
		repeat(`trans - 3 )  begin
     `uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 1;
				 req.PSTRB == 0;
				 req.PADDR inside {[0:63]};
				}
			)
		end

		`uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 0;
				 req.PADDR == 4 ;
				}
			)
		
		`uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 0;
				 req.PADDR == 56 ;
				}
			)
		
		`uvm_do_with( req , { req.PRESETN == 0; } )

		`uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 0;
				 req.PADDR == 4 ;
				}
			)

		`uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 0;
				 req.PADDR == 58 ;
				}
			)
		
	endtask
endclass 

//------------------------------------------------------//
//               slave error sequence                   //  
//------------------------------------------------------//

class slave_error extends uvm_sequence#(apb_master_sequence_item);
	`uvm_object_utils(slave_error)

	function new(string name = "slave_error");
		super.new(name);
	endfunction

	task body();
		`uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 1;
				 req.PSTRB == 0;
				 req.PADDR inside {[192:255]} ;
				}
			)
	endtask
endclass 

/*
//------------------------------------------------------//
//      single operand arithmatic error sequence        //  
//------------------------------------------------------//

class single_operand_arithmatic_error extends uvm_sequence#(apb_master_sequence_item);
	`uvm_object_utils(single_operand_arithmatic_error)

	function new(string name = "single_operand_arithmatic_error");
		super.new(name);
	endfunction

	task body();
		repeat(`no_of_items) begin
			`uvm_do_with( 
				req,
				{ 
					req.rst == 0;
					req.ce == 1;
					req.mode == 1;
					req.inp_valid inside { 0 , 3 };
					req.cmd inside {[4:7]};
				}
			)
		end
	endtask
endclass 

//------------------------------------------------------//
//      single operand logical error sequence           //  
//------------------------------------------------------//

class single_operand_logical_error extends uvm_sequence#(apb_master_sequence_item);
	`uvm_object_utils(single_operand_logical_error)

	function new(string name = "single_operand_logical_error");
		super.new(name);
	endfunction

	task body();
		repeat(`no_of_items) begin
			`uvm_do_with( 
				req,
				{ 
					req.rst == 0;
					req.ce == 1;
					req.mode == 0;
					req.inp_valid inside { 0 , 3 };
					req.cmd inside {[6:11]};
				}
			)
		end
	endtask
endclass 

//------------------------------------------------------//
//      two operand arithmatic error sequence           //  
//------------------------------------------------------//

class two_operand_arithmatic_error extends uvm_sequence#(apb_master_sequence_item);
	`uvm_object_utils(two_operand_arithmatic_error)

	function new(string name = "two_operand_arithmatic_error");
		super.new(name);
	endfunction

	task body();
		repeat(`no_of_items) begin
			`uvm_do_with( 
				req,
				{ 
					req.rst == 0;
					req.ce == 1;
					req.mode == 1;
					req.inp_valid == 0;
					req.cmd inside {[0:3],[8:10]};
				}
			)
		end
	endtask
endclass

//------------------------------------------------------//
//       two operand logical error sequence             //  
//------------------------------------------------------//

class two_operand_logical_error extends uvm_sequence#(apb_master_sequence_item);
	`uvm_object_utils(two_operand_logical_error)

	function new(string name = "two_operand_logical_error");
		super.new(name);
	endfunction

	task body();
		repeat(`no_of_items) begin
			`uvm_do_with( 
				req,
				{ 
					req.rst == 0;
					req.ce == 1;
					req.mode == 0;
					req.inp_valid == 0;
					req.cmd inside {[0:5],[12:13]};
				}
			)
		end
	endtask
endclass

//------------------------------------------------------//
//            rotate right error sequence               //  
//------------------------------------------------------//

class rotate_right_error extends uvm_sequence#(apb_master_sequence_item);
	`uvm_object_utils(rotate_right_error)

	function new(string name = "rotate_right_error");
		super.new(name);
	endfunction

	task body();
		repeat(`no_of_items) begin
			`uvm_do_with( 
				req,
				{ 
					req.rst == 0;
					req.ce == 1;
					req.mode == 0;
					req.inp_valid == 3;
					req.cmd == 13;
					req.opa == 1 ;
					req.opb inside {[8:255]};
				}
			)
		end
	endtask
endclass 

//------------------------------------------------------//
//            rotate left error sequence                //  
//------------------------------------------------------//

class rotate_left_error extends uvm_sequence#(apb_master_sequence_item);
	`uvm_object_utils(rotate_left_error)

	function new(string name = "rotate_left_error");
		super.new(name);
	endfunction

	task body();
		repeat(`no_of_items) begin
			`uvm_do_with( 
				req,
				{ 
					req.rst == 0;
					req.ce == 1;
					req.mode == 0;
					req.inp_valid == 3;
					req.cmd == 12;
					req.opa == 1 ;
					req.opb inside {[8:255]};
				}
			)
		end
	endtask
endclass 

//------------------------------------------------------//
//         16 clock cycle arithmatic sequence           //  
//------------------------------------------------------//

class cycle_16_arithmatic extends uvm_sequence#(apb_master_sequence_item);
	`uvm_object_utils(cycle_16_arithmatic)

	function new(string name = "cycle_16_arithmatic");
		super.new(name);
	endfunction

	task body();
		repeat(`no_of_items) begin
			`uvm_do_with( 
				req,
				{ 
					req.rst == 0;
					req.ce == 1;
					req.mode == 1;
					req.inp_valid inside {[1:2]};
					req.cmd inside {[0:3],[8:10]};
				}
			)
		end
	endtask
endclass 

//------------------------------------------------------//
//         16 clock cycle logical sequence              //  
//------------------------------------------------------//

class cycle_16_logical extends uvm_sequence#(apb_master_sequence_item);
	`uvm_object_utils(cycle_16_logical)

	function new(string name = "cycle_16_logical");
		super.new(name);
	endfunction

	task body();
		repeat(`no_of_items) begin
			`uvm_do_with( 
				req,
				{ 
					req.rst == 0;
					req.ce == 1;
					req.mode == 0;
					req.inp_valid inside {[1:2]};
					req.cmd inside {[0:5],[12:13]};
				}
			)
		end
	endtask
endclass 

//------------------------------------------------------//
//           comparsion for opa > opb, opa < opb        //
//                  and opa = opb sequence              //  
//------------------------------------------------------//

class comparison extends uvm_sequence#(apb_master_sequence_item);
	`uvm_object_utils(comparison)

	function new(string name = "comparison");
		super.new(name);
	endfunction

	task body();
		repeat(`no_of_items)begin 
			`uvm_do_with( 
				req,
				{ 
					req.rst == 0;
					req.ce == 1;
					req.mode == 1;
					req.inp_valid == 3;
					req.cmd == 8;
					req.opa == req.opb;
				}
			)
			`uvm_do_with( 
				req,
				{ 
					req.rst == 0;
					req.ce == 1;
					req.mode == 1;
					req.inp_valid == 3;
					req.cmd == 8;
					req.opa > req.opb;
				}
			)
			`uvm_do_with( 
				req,
				{ 
					req.rst == 0;
					req.ce == 1;
					req.mode == 1;
					req.inp_valid == 3;
					req.cmd == 8;
					req.opa < req.opb;
				}
			)
		end
	endtask
endclass 


//------------------------------------------------------//
// invlaid cmd check for arithmatic and logical sequence//  
//------------------------------------------------------//

class invalid_cmd extends uvm_sequence#(apb_master_sequence_item);
	`uvm_object_utils(invalid_cmd)

	function new(string name = "invalid_cmd");
		super.new(name);
	endfunction

	task body();
		`uvm_do_with( 
			req,
			{ 
				req.rst == 0;
				req.ce == 1;
				req.mode == 1;
				req.inp_valid == 3;
				req.cmd == 15;
			}
		)
		`uvm_do_with( 
			req,
			{ 
				req.rst == 0;
				req.ce == 1;
				req.mode == 0;
				req.inp_valid == 3;
				req.cmd == 15;
			}
		)		
	endtask
endclass 

//------------------------------------------------------//
//      16 clock cycle arithmatic error sequence        //  
//------------------------------------------------------//

class cycle_16_arithmatic_error extends uvm_sequence#(apb_master_sequence_item);
	`uvm_object_utils(cycle_16_arithmatic_error)

	function new(string name = "cycle_16_arithmatic_error");
		super.new(name);
	endfunction

	task body();
		repeat(`no_of_items) begin
			`uvm_do_with( 
				req,
				{ 
					req.rst == 0;
					req.ce == 1;
					req.mode == 1;
					req.inp_valid dist{ 1:= 100, 2:= 50, 3:= 1 };
					req.cmd inside {[0:3],[8:10]};
				}
			)
		end
	endtask
endclass 

//------------------------------------------------------//
//         16 clock cycle logical error sequence        //  
//------------------------------------------------------//

class cycle_16_logical_error extends uvm_sequence#(apb_master_sequence_item);
	`uvm_object_utils(cycle_16_logical_error)

	function new(string name = "cycle_16_logical_error");
		super.new(name);
	endfunction

	task body();
		repeat(`no_of_items) begin
			`uvm_do_with( 
				req,
				{ 
					req.rst == 0;
					req.ce == 1;
					req.mode == 0;
					req.inp_valid dist{ 1:= 100, 2:= 50, 3:= 1 };
					req.cmd inside {[0:5],[12:13]};
				}
			)
		end
	endtask
endclass 
*/

//---------------------------------------------------------//
// apb_master regression sequence for all 17 sequence test //  
//---------------------------------------------------------//

class apb_master_regression extends uvm_sequence#(apb_master_sequence_item);
	`uvm_object_utils(apb_master_regression)

	  presetn                   seq0;
    write_transfer            seq1;
    read_transfer             seq2;
		write_read_transfer       seq3;
  	mid_reset                 seq4;
    slave_error               seq5;
/*	
	single_operand_logical_error    seq6;
	two_operand_arithmatic_error    seq7;
	two_operand_logical_error       seq8;

	rotate_right_error  seq9;
	rotate_left_error   seq10;
	cycle_16_arithmatic seq11;
	cycle_16_logical    seq12;

	comparison                seq13;
	invalid_cmd               seq14;
	cycle_16_arithmatic_error seq15;
	cycle_16_logical_error    seq16;
*/
	function new(string name = "apb_master_regression");
		super.new(name);
	endfunction

	task body();
    `uvm_do(seq0)
  	`uvm_do(seq1)
    `uvm_do(seq2)
    `uvm_do(seq3) 
    `uvm_do(seq4)
    `uvm_do(seq5)         
/*	`uvm_do(seq4)
		`uvm_do(seq5)
		`uvm_do(seq6)
		`uvm_do(seq7)         
		`uvm_do(seq8) 
		`uvm_do(seq9)         
		`uvm_do(seq10)
		`uvm_do(seq11)         
		`uvm_do(seq12)
		`uvm_do(seq13)
		`uvm_do(seq14)
		`uvm_do(seq15)
		`uvm_do(seq16)
*/	endtask
endclass
