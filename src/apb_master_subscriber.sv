`uvm_analysis_imp_decl(_active_mon_cg)
`uvm_analysis_imp_decl(_passive_mon_cg)

class apb_master_subscriber extends uvm_component;

	//registering apb_master_subscriber componenet with the factory
	`uvm_component_utils(apb_master_subscriber)

	// analysis import declearation for coverage
	uvm_analysis_imp_active_mon_cg#(apb_master_sequence_item, apb_master_subscriber) cov_active_mon_port;
	uvm_analysis_imp_passive_mon_cg#(apb_master_sequence_item, apb_master_subscriber) cov_passive_mon_port;

	// handle declaration for apb_master_sequence_item
	apb_master_sequence_item active_mon, passive_mon;

	// declaring overall coverage result variable for inputs and outputs 
	real active_mon_cov_results, passive_mon_cov_results;

	//------------------------------------------------------//
	//               input covergroup                       //  
	//------------------------------------------------------//

	covergroup input_coverage;
		option.per_instance = 1;
    presetn: coverpoint active_mon.PRESETN { bins b1[] = {0,1};}
		pselx  : coverpoint active_mon.PSELX   { bins b2[] = {0,1};}
    penable: coverpoint active_mon.PENABLE { bins b3   = { 1 };}
		pwrite : coverpoint active_mon.PWRITE  { bins b4[] = {0,1};}
	  addr : coverpoint active_mon.PADDR {
    bins low_range      = { [0 : (2**`ADDR_WIDTH)/4 - 1] };                      // 0–25%
    bins mid_range      = { [(2**`ADDR_WIDTH)/4 : (2**`ADDR_WIDTH)/2 - 1] };     // 25–50%
    bins high_range     = { [(2**`ADDR_WIDTH)/2 : (3*(2**`ADDR_WIDTH)/4) - 1] }; // 50–75%
    bins max_range      = { [(3*(2**`ADDR_WIDTH)/4) : (2**`ADDR_WIDTH - 1)] };   // 75–100%
    }
/*  pwdata : coverpoint active_mon.PWDATA iff(active_mon.PWRITE) {
    bins low_data      = { [0 : (2**`DATA_WIDTH)/4 - 1] };
    bins medium_data   = { [(2**`DATA_WIDTH)/4 : (2**`DATA_WIDTH)/2 - 1] };
    bins high_data     = { [(2**`DATA_WIDTH)/2 : (3*(2**`DATA_WIDTH)/4) - 1] };
    bins max_data      = { [(3*(2**`DATA_WIDTH)/4) : (2**`DATA_WIDTH - 1)] }; 
    }
*/
 		pstrb : coverpoint active_mon.PSTRB iff(active_mon.PWRITE){ 
			bins pstrb0 = { 4'b0001 };
    	bins pstrb1 = { 4'b0010 };
	  	bins pstrb2 = { 4'b0100 };
      bins pstrb3 = { 4'b1000 };
		}
	  
		byte0 : coverpoint active_mon.PWDATA[7:0] iff(active_mon.PWRITE && active_mon.PSTRB[0]){
			    bins low_byte1    = { [0   : 63] };     
			    bins mid_byte1    = { [64  : 127] };    
			    bins high_byte1   = { [128 : 191] };    
			    bins max_byte1    = { [192 : 255] }; 
		}
		byte1 : coverpoint active_mon.PWDATA[15:8]  iff(active_mon.PWRITE && active_mon.PSTRB[1]){
		      bins low_byte2    = { [0   : 63] };    
			    bins mid_byte2    = { [64  : 127] };    
			    bins high_byte2   = { [128 : 191] };    
			    bins max_byte2    = { [192 : 255] }; 
		}
		byte2 : coverpoint active_mon.PWDATA[23:16] iff(active_mon.PWRITE && active_mon.PSTRB[2]){
				  bins low_byte3    = { [0   : 63] };     
			    bins mid_byte3    = { [64  : 127] };
			    bins high_byte3   = { [128 : 191] };   
			    bins max_byte3    = { [192 : 255] }; 
		}
		byte3 : coverpoint active_mon.PWDATA[31:24] iff(active_mon.PWRITE && active_mon.PSTRB[3]){
					bins low_byte4    = { [0   : 63] };     
				  bins mid_byte4    = { [64  : 127] };    
			    bins high_byte4   = { [128 : 191] };    
			    bins max_byte4    = { [192 : 255] }; 
		}
			
    presetnxpslex:		cross presetn,pselx;
		presetnxpenable:  cross presetn,penable;
	  presetnxpwrite:   cross presetn,pwrite;
		pselxpenable:     cross pselx,penable;
		pwritexpselx:     cross pwrite,pselx;	
    pwritexpenable:   cross pwrite,penable;
	endgroup

	//------------------------------------------------------//
	//                 output covergroup                    //  
	//------------------------------------------------------//

	covergroup output_coverage;
		option.per_instance = 1;
    pready  : coverpoint passive_mon.PREADY  { bins b7[] = {0,1};}
		pslverr : coverpoint passive_mon.PSLVERR { bins b8[] = {0,1};}
    prdata : coverpoint passive_mon.PRDATA {
    bins low_data      = { [0 : (2**`DATA_WIDTH)/4 - 1] };
    bins medium_data   = { [(2**`DATA_WIDTH)/4 : (2**`DATA_WIDTH)/2 - 1] };
    bins high_data     = { [(2**`DATA_WIDTH)/2 : (3*(2**`DATA_WIDTH)/4) - 1] };
    bins max_data      = { [(3*(2**`DATA_WIDTH)/4) : (2**`DATA_WIDTH - 1)] }; 
    }
  endgroup

	//------------------------------------------------------//
	//   Creating New constructor for apb_master_subscriber //   
	//------------------------------------------------------//

	function new(string name = "apb_master_subscriber", uvm_component parent);
		super.new(name, parent);
		output_coverage = new();
		input_coverage  = new();
		cov_active_mon_port    = new("cov_active_mon_port", this);
		cov_passive_mon_port   = new("cov_passive_mon_port", this);
	endfunction

	//------------------------------------------------------//
	//      Captures the active monitor transaction and     //
	//            triggers input coverage sampling          //   
	//------------------------------------------------------//

	function void write_active_mon_cg(apb_master_sequence_item active_mon_seq);
		active_mon = active_mon_seq;
		input_coverage.sample();
	endfunction

	//------------------------------------------------------//
	//      Captures the passive monitor transaction and    //
	//            triggers output coverage sampling         //   
	//------------------------------------------------------//

	function void write_passive_mon_cg(apb_master_sequence_item passive_mon_seq);
		passive_mon = passive_mon_seq;
		output_coverage.sample();
	endfunction

	//------------------------------------------------------//
	//     extracting input and output coverage results     // 
	//------------------------------------------------------//

	function void extract_phase(uvm_phase phase);
		super.extract_phase(phase);
		active_mon_cov_results   = input_coverage.get_coverage();
		passive_mon_cov_results  = output_coverage.get_coverage();
	endfunction

	//------------------------------------------------------//
	//         display input coverage result and            //
	//             output coverage reesults                 //   
	//------------------------------------------------------//

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info(get_type_name, $sformatf("[ACTIVE_MONITOR] Coverage ------> %0.2f%%,", active_mon_cov_results), UVM_MEDIUM);
		`uvm_info(get_type_name, $sformatf("[PASSIVE_MONITOR] Coverage ------> %0.2f%%", passive_mon_cov_results), UVM_MEDIUM);
	endfunction
endclass
