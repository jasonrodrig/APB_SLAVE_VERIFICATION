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
		`uvm_do_with(req,{ req.PRESETN == 0 ; req.PSELX == 0 ;})
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
     `uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 0;
				 req.PADDR inside {[192:255]} ;
				}
			)
	endtask
endclass 


//------------------------------------------------------//
//          strobe write and read sequence              //  
//------------------------------------------------------//

class strobe_write_read extends uvm_sequence#(apb_master_sequence_item);
	`uvm_object_utils(strobe_write_read)

	function new(string name = "strobe_write_read");
		super.new(name);
	endfunction

	task body();
		bit [`ADDR_WIDTH - 1 : 0 ] temp_addr; 
		repeat(`trans+10) begin
		`uvm_do_with( 	
		  req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 1;
				 req.PSTRB == 0;
				 req.PADDR inside {[0:191]};
				}
			)	
		
		temp_addr = req.PADDR;
			
		`uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 1;
				 req.PSTRB == 1;
				 req.PADDR == temp_addr;
				}
			)	
		  `uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 0;
				 req.PADDR == temp_addr;
				}
			)
    	`uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 1;
				 req.PSTRB == 2;
				 req.PADDR == temp_addr;
				}
			)	
		  `uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 0;
				 req.PADDR == temp_addr;
				}
			)
    	`uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 1;
				 req.PSTRB == 4;
				 req.PADDR == temp_addr;
				}
			)	
		  `uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 0;
				 req.PADDR == temp_addr;
				}
			)
    	`uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 1;
				 req.PSTRB == 8;
				 req.PADDR == temp_addr;
				}
			)	
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
//            idle state check sequence                 //  
//------------------------------------------------------//

class idle_state_check extends uvm_sequence#(apb_master_sequence_item);
	`uvm_object_utils(idle_state_check)

	function new(string name = "idle_state_check");
		super.new(name);
	endfunction

	task body();
		bit [ `ADDR_WIDTH - 1 : 0 ] temp_addr;
		`uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	0;
				 req.PWRITE == 1;
				 req.PSTRB == 0;
				 req.PADDR inside {[0:191]};
				}
			) 

		`uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 1;
				 req.PSTRB == 0;
				 req.PADDR inside {[0:191]};
				}
			) 

     temp_addr = req.PADDR;

     `uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	0;
				 req.PWRITE == 0; 
				 req.PADDR == temp_addr;
				}
			)
    
		`uvm_do_with( 
				req,
				{ 
				 req.PRESETN == 1;
				 req.PSELX ==	1;
				 req.PWRITE == 0; 
			   req.PADDR == temp_addr;
				}
			)

    endtask
endclass 


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
	  strobe_write_read         seq6;
    idle_state_check          seq7;
	function new(string name = "apb_master_regression");
		super.new(name);
	endfunction

	task body();
    `uvm_do(seq0)
		`uvm_do(seq7)
  	`uvm_do(seq1)
    `uvm_do(seq2)
    `uvm_do(seq3) 
    `uvm_do(seq4)
    `uvm_do(seq5)         
  	`uvm_do(seq6)
	endtask
endclass
