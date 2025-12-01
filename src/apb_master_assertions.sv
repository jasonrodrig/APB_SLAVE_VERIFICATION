interface apb_master_assertions(PCLK,PRESETN,PSELX,PWRITE,PENABLE,PADDR,PWDATA,PRDATA,PREADY,PSLVERR,PSTRB);
	input PCLK;
	input PRESETN;
	input PSELX;
	input [`DATA_WIDTH - 1 : 0] PWDATA;
	input [`DATA_WIDTH - 1 : 0] PRDATA;
	input PWRITE;
	input PENABLE;
	input [ 4 - 1 : 0 ] PSTRB;
	input [ `ADDR_WIDTH - 1 : 0 ] PADDR;
	input PREADY;
	input PSLVERR;
/*
	// PROPERTY 1 -> RESET CHECK 
	property p1;
		@(posedge PCLK) ##2 (!PRESETN) |-> ( PREADY == 0 && PRDATA == 0 && PSLVERR == 0 );
	endproperty

	assert property(p1)
	else $error("presetn failed : PREADY = %0B | PSLVERR = %0B | PRDATA = %0B " , PREADY , PSLVERR , PRDATA );


	// PROPERTY 2 -> UNKNOWN SIGNAL CHECK 
	property p2;
		@(posedge PCLK) ##1 !$isunknown( PRESETN || PSELX || PWDATA || PRDATA || PWRITE || PENABLE || PSTRB || PADDR || PREADY || PSLVERR );
	endproperty

	assert property(p2)
	else $error("unknown signals failed : PRESETN = %0b | PSELX = %0b | PWDATA = %0d | PRDATA = %0d | PWRITE = %0b | PENABLE = %0b | PSTRB = %0d |PADDR = %0d | PREADY = %0b | PSLVERR = %0b" , PRESETN , PSELX , PWDATA , PRDATA , PWRITE , PENABLE , PSTRB , PADDR , PREADY , PSLVERR  );


	// PROPERTY 3 -> DATA VALID CHECK 
	property p3;
		@(posedge PCLK) disable iff( !PRESETN ) 
		( PSELX && !PWRITE && PENABLE ) |-> PRDATA;
	endproperty

	assert property(p3)
	else $error("data vaild failed : PRESETN = %0b | PSELX = %0b | PWRITE = %0b | PENABLE = %0b |  PRDATA = %0d " , PRESETN , PSELX , PWRITE ,
		PENABLE , PRDATA );


	// PROPERTY 4 -> STABILITY READ OPERATION CHECK 
	property p4;
		@(posedge PCLK) disable iff( !PRESETN ) 
		( PSELX && !PWRITE && !PENABLE) |-> PADDR |=> ( PSELX && !PWRITE && PENABLE ) |-> PRDATA |-> PADDR;
	endproperty

	assert property(p4)
	else $error("stability read operation failed : PSELX = %0b | PWRITE = %0b | PENABLE = %0b | PADDR = %0b | PRDATA = %0d " , PSELX , PWRITE ,
		PENABLE , PADDR , PRDATA );


	// PROPERTY 5 -> STABILITY WRITE OPERATION CHECK 
	property p5;
		@(posedge PCLK) disable iff( !PRESETN ) 
		( PSELX && !PWRITE && !PENABLE) |-> PADDR |-> PWDATA |=> ( PSELX && !PWRITE && PENABLE ) |-> PWDATA |-> PADDR;
	endproperty

	assert property(p5)
	else $error("stability write operation failed : PSELX = %0b | PWRITE = %0b | PENABLE = %0b | PADDR = %0b | PWDATA = %0d " , PSELX , PWRITE ,
		PENABLE , PADDR , PWDATA );


	// PROPERTY 6 -> SLAVE ERROR CHECK 
	property p6;
		@(posedge PCLK) disable iff( !PRESETN ) 
		( PADDR > ( ( 2 ** `DATA_WIDTH ) - 1 ) ) |-> ( PSLVERR || PRDATA == 'bx ) ;
	endproperty

	assert property(p6)
	else $error("slave error failed : PADDR = %0b | PSLVERR = %0b | PRDATA = %0d " , PADDR , PSLVERR , PRDATA );

*/
endinterface
