`uvm_analysis_imp_decl(_active_mon_scb)
`uvm_analysis_imp_decl(_passive_mon_scb)

class apb_master_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(apb_master_scoreboard)

	uvm_analysis_imp_active_mon_scb #(apb_master_sequence_item, apb_master_scoreboard) active_scb_port;
	uvm_analysis_imp_passive_mon_scb #(apb_master_sequence_item, apb_master_scoreboard) passive_scb_port;

	apb_master_sequence_item active_mon_packet_q[$];
	apb_master_sequence_item passive_mon_packet_q[$];

	//memory declaration for slave1
	logic [ `DATA_WIDTH - 1 : 0 ] slave [ ( 2 ** `ADDR_WIDTH ) - 1 : 0 ];

	static int pass_count;
	static int fail_count;

	function new(string name = "apb_master_scoreboard", uvm_component parent);
		super.new(name,parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		active_scb_port = new("active_scb_port",this);
		passive_scb_port = new("passive_scb_port",this);
	endfunction: build_phase

	function void write_active_mon_scb(apb_master_sequence_item pkt);
		//`uvm_info("SCOREBOARD", "Received input packet ", UVM_MEDIUM)
		active_mon_packet_q.push_back(pkt);
	endfunction: write_active_mon_scb

	function void write_passive_mon_scb(apb_master_sequence_item pkt);
		//`uvm_info("SCOREBOARD", "Received output packet ", UVM_MEDIUM)
		passive_mon_packet_q.push_back(pkt);
	endfunction: write_passive_mon_scb

	function void extract_phase(uvm_phase phase);
		super.extract_phase(phase);
		`uvm_info("SCOREBOARD", $sformatf("TOTAL PASS : %0d", pass_count), UVM_NONE)
		`uvm_info("SCOREBOARD", $sformatf("TOTAL FAIL : %0d", fail_count), UVM_NONE)
		`uvm_info("SCOREBOARD", $sformatf("TOTAL CASES : %0d", fail_count + pass_count), UVM_NONE)
	endfunction: extract_phase

	virtual task run_phase(uvm_phase phase);
		apb_master_sequence_item act_item;
		apb_master_sequence_item pass_item;

		forever begin
			fork
				begin
					wait(active_mon_packet_q.size()>0);
					act_item  = active_mon_packet_q.pop_front();
				end
				begin
					wait(passive_mon_packet_q.size()>0);
					pass_item = passive_mon_packet_q.pop_front();
				end
			join
			compare( act_item , pass_item );
		end
	endtask: run_phase

	// comparision logic
	task compare(apb_master_sequence_item in , apb_master_sequence_item out );

		logic [ `DATA_WIDTH - 1 : 0 ] old_data ;
		logic [ `DATA_WIDTH - 1 : 0 ] new_data ;
		logic [ `DATA_WIDTH - 1 : 0 ] expected ;

		//IDLE STATE SIGNALS CHECK

		if( !in.PRESETN || !in.PSELX ) begin

			`uvm_info( "SCOREBOARD" ,
				$sformatf("PRESETN = %0B | PSELX = %0B | PREADY = %0B | PRDATA = %0D | PSLVERR = %0B ", 
					in.PRESETN , in.PSELX , out.PREADY , out.PRDATA , out.PSLVERR  ) , UVM_NONE ) 

			if(out.PRDATA == 'b0 && out.PSLVERR == 0 && out.PREADY == 0 ) 
			begin
				`uvm_info("SCOREBOARD", "---------------------------------------", UVM_NONE)
				`uvm_info("SCOREBOARD", "----           TEST PASS           ----", UVM_NONE)
				`uvm_info("SCOREBOARD", "---------------------------------------", UVM_NONE)
				pass_count++;
			end
			else begin
				`uvm_info("SCOREBOARD", "---------------------------------------", UVM_NONE)
				`uvm_info("SCOREBOARD", "----           TEST FAIL           ----", UVM_NONE)
				`uvm_info("SCOREBOARD", "---------------------------------------", UVM_NONE)
				fail_count++;
			end
		end

		// TRANSFER CHECK

		else begin

			//write operation

			if( in.PWRITE && in.PSELX && in.PENABLE && out.PREADY )
			begin

				old_data = slave[in.PADDR];

				`uvm_info( "SCOREBOARD", "WRITE TRANSFER",UVM_NONE)
				`uvm_info( "SCOREBOARD" ,
					$sformatf( " PRESETN = %0B | PSELX = %0B | PWRITE = %0B | PENABLE = %0B | PSTRB = %0D | PREADY = %0B | PRDATA = %0D | PSLVERR = %0B ",
						in.PRESETN , in.PSELX , in.PWRITE , in.PENABLE , in.PSTRB , out.PREADY , out.PRDATA , out.PSLVERR  ) , UVM_NONE )
				`uvm_info( "SCOREBOARD" , $sformatf("data strored at slave[%d] = %d " , in.PADDR, in.PWDATA ) , UVM_NONE )

				// pstrb = 0 then perform full word write transfer
				if(in.PSTRB == 0) 
				begin
					slave[in.PADDR] = in.PWDATA;
				end

				// pstrb = 1 then perform partial word write transfer
				else
				begin
					// pstrb write logic
					pstrb_write(in.PWDATA , in.PSTRB , old_data , new_data);
					slave[in.PADDR] = new_data;
					`uvm_info("SCOREBOARD", 
						$sformatf( " PSTRB WRITE: ADDR = %0D | PSTRB = %0D | OLD_DATA = %0D | NEW_DATA = %0D ", 
							in.PADDR , in.PSTRB , old_data , new_data ) , UVM_NONE )
				end
			end

			// read operation

			else if( !in.PWRITE && in.PSELX && in.PENABLE && out.PREADY )
			begin
				`uvm_info( "SCOREBOARD", "READ TRANSFER",UVM_NONE)
				`uvm_info( "SCOREBOARD" ,
					$sformatf( " PRESETN = %0B | PSELX = %0B | PWRITE = %0B | PENABLE = %0B | PSTRB = %0D | PREADY = %0B | PRDATA = %0D | PSLVERR = %0B ",
						in.PRESETN , in.PSELX , in.PWRITE , in.PENABLE , in.PSTRB , out.PREADY , out.PRDATA , out.PSLVERR  ) , UVM_NONE )
				`uvm_info( "SCOREBOARD" , $sformatf("data stored at slave[%d] = %d " , in.PADDR, out.PRDATA ) , UVM_NONE )


				if( out.PRDATA === slave[in.PADDR] && !out.PSLVERR)
				begin
					`uvm_info("SCOREBOARD", "---------------------------------------", UVM_NONE)
					`uvm_info("SCOREBOARD", "----           TEST PASS           ----", UVM_NONE)
					`uvm_info("SCOREBOARD", "---------------------------------------", UVM_NONE)
					pass_count++;
				end

				else begin
					`uvm_info("SCOREBOARD", "---------------------------------------", UVM_NONE)
					`uvm_info("SCOREBOARD", "----           TEST FAIL           ----", UVM_NONE)
					`uvm_info("SCOREBOARD", "---------------------------------------", UVM_NONE)
					fail_count++;
				end
			end

			//slave error check
	    if( in.PADDR > 192 )
			begin
				`uvm_info( "SCOREBOARD", "SLAVE ERROR CHECK",UVM_NONE)
				`uvm_info( "SCOREBOARD" ,
					$sformatf( " PRESETN = %0B | PSELX = %0B | PWRITE = %0B | PENABLE = %0B | PREADY = %0B | PRDATA = %0D | PSLVERR = %0B ",
						in.PRESETN , in.PSELX , in.PWRITE , in.PENABLE , out.PREADY , out.PRDATA , out.PSLVERR  ) , UVM_NONE )
				`uvm_info( "SCOREBOARD" , $sformatf("data stored at slave[%d] = %d " , in.PADDR, out.PRDATA ) , UVM_NONE )

				if(out.PSLVERR == 1 || out.PRDATA === 'bx )
				begin
					`uvm_info("SCOREBOARD", "---------------------------------------", UVM_NONE)
					`uvm_info("SCOREBOARD", "----           TEST PASS           ----", UVM_NONE)
					`uvm_info("SCOREBOARD", "---------------------------------------", UVM_NONE)
					pass_count++;
				end

				else begin
					`uvm_info("SCOREBOARD", "---------------------------------------", UVM_NONE)
					`uvm_info("SCOREBOARD", "----           TEST FAIL           ----", UVM_NONE)
					`uvm_info("SCOREBOARD", "---------------------------------------", UVM_NONE)
					fail_count++;
				end
			end
		end
	endtask

	// write pstrb operation 
	task pstrb_write(
		input logic [ `DATA_WIDTH - 1 : 0 ] pwdata,
		input bit   [ ( `DATA_WIDTH / 8 ) - 1 : 0 ] pstrb,
		input logic [ `DATA_WIDTH - 1 : 0 ] old_data,
		output logic [ `DATA_WIDTH - 1 : 0 ] new_data );

		new_data = old_data;

		for (int i = 0; i < 4; i++) begin
			if (pstrb[i]) begin
				new_data[i*8 +: 8] = pwdata[i*8 +: 8];
			end
		end
	endtask

endclass: apb_master_scoreboard
