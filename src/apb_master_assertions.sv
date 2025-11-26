interface apb_master_assertions(PCLK,PRESETN,PSELX,PWRITE,PENABLE,PADDR,PWDATA,PSTRB,PRDATA,PREADY,PSLVERR);
  input PCLK;
	input PRESETN;
	input PSELX;
	input [`DATA_WIDTH - 1 : 0] PWDATA;
	input [`DATA_WIDTH - 1 : 0] PRDATA;
	input PWRITE;
  input PENABLE;
	input [ (`DATA_WIDTH ) / 8 - 1 : 0 ] PSTRB;
	input [ `ADDR_WIDTH - 1 : 0 ] PADDR;
	input PREADY;
	input PSLVERR;

endinterface
