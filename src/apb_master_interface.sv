interface apb_master_interface(input bit PCLK);

	// APB_MASTER input signals
	bit PRESETN, PSELX , PENABLE , PWRITE;
	bit [`DATA_WIDTH - 1 :0] PWDATA ; 
	bit [`ADDR_WIDTH - 1 :0] PADDR;
  bit [(`DATA_WIDTH / 8 ) - 1 : 0 ] PSTRB;

	// APB_SLAVE output signals
	logic [ `DATA_WIDTH - 1 : 0] PRDATA ;
	logic PREADY , PSLVERR ;

	// Clocking block apb_master_driver_cb synchronizes DUT inputs
	clocking apb_master_driver_cb @(posedge PCLK);
		default input #0 output #0;
		input  PREADY;
		output PRESETN;
		output PSELX;
    output PWRITE;
    output PENABLE;
	  output PADDR;
  	output PWDATA;
  	output PSTRB;
	endclocking

	// Clocking block apb_master_monitor_cb synchronizes DUT inputs and outputs
	clocking apb_master_monitor_cb @(posedge PCLK);
		default input #0 output #0;
		input PRESETN;
		input PSELX;
		input PWRITE;
		input PENABLE;  
		input PADDR;
		input PWDATA;
  	input PSTRB;  
		input PREADY;
		input PRDATA;
		input PSLVERR; 
	endclocking

	// Modport driver and monitor decleration
	modport DRIVER(clocking apb_master_driver_cb);
	modport MONITOR(clocking apb_master_monitor_cb);

endinterface
