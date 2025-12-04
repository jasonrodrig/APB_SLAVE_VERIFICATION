/*
interface apb_master_assertions(PCLK,PRESETN,PSELX,PWRITE,PENABLE,PADDR,PWDATA,PRDATA,PREADY,PSLVERR,PSTRB);
	input PCLK;
	input PRESETN;
	input PSELX;
	input [`DATA_WIDTH - 1 : 0] PWDATA;
	input [`DATA_WIDTH - 1 : 0] PRDATA;
	input PWRITE;
	input PENABLE;
	input [ ( `DATA_WIDTH / 8 ) - 1 : 0 ] PSTRB;
	input [ `ADDR_WIDTH - 1 : 0 ] PADDR;
	input PREADY;
	input PSLVERR;

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

endinterface
*/

interface apb_master_assertions(
    input  PCLK,
    input  PRESETN,
    input  PSELX,
    input  PWRITE,
    input  PENABLE,
    input  [`ADDR_WIDTH  - 1 : 0] PADDR,
    input  [`DATA_WIDTH  - 1 : 0] PWDATA,
    input  [`DATA_WIDTH  - 1 : 0] PRDATA,
    input  [(`DATA_WIDTH/8)-1 : 0] PSTRB,
    input  PREADY,
    input  PSLVERR
);

    // ------------------------------------------------------------
    // PROPERTY 1 : RESET CHECK
    // ------------------------------------------------------------
    property p_reset;
        @(posedge PCLK)
        (!PRESETN) |-> (PREADY == 0 && PRDATA == 0 && PSLVERR == 0);
    endproperty
    
    assert property(p_reset)
    else $error("RESET CHECK FAILED! PREADY=%0b PSLVERR=%0b PRDATA=%0h",
                PREADY, PSLVERR, PRDATA);


    // ------------------------------------------------------------
    // PROPERTY 2 : UNKNOWN SIGNAL CHECK
    // ------------------------------------------------------------
    property p_unknown;
        @(posedge PCLK)
        !$isunknown({
            PRESETN, PSELX, PWRITE, PENABLE,
            PADDR,   PWDATA, PRDATA, 
            PSTRB,   PREADY, PSLVERR
        });
    endproperty

    assert property(p_unknown)
    else $error("UNKNOWN SIGNAL DETECTED!");


    // ---------------------------------------------------------------------
    // PROPERTY 3 : DATA VALID CHECK (READ)
    // When read Transfer happens in access phase → PRDATA must be valid
    // ---------------------------------------------------------------------
    property p_read_valid;
        @(posedge PCLK) disable iff (!PRESETN)
        !(PSELX && !PWRITE && PENABLE) |-> !$isunknown(PRDATA);
    endproperty

    assert property(p_read_valid)
    else $error("READ DATA INVALID! PRDATA=%0d", PRDATA);


    // ------------------------------------------------------------
    // PROPERTY 4 : STABILITY OF READ SIGNALS 
    // PADDR must remain stable between setup and access
    // ------------------------------------------------------------
    property p_read_stability;
        @(posedge PCLK) disable iff (!PRESETN)
       ##11 (PSELX && !PWRITE && !PENABLE)
				|=>  (PSELX && !PWRITE && PENABLE && $stable(PADDR))[*3];
    endproperty

    assert property(p_read_stability)
    else $error("READ STABILITY VIOLATION! PADDR changed");


    // ------------------------------------------------------------
    // PROPERTY 5 : STABILITY OF WRITE OPERATION
    // PADDR & PWDATA must remain stable between setup and access
    // ------------------------------------------------------------
    property p_write_stability;
        @(posedge PCLK) disable iff (!PRESETN ) // || PSTRB != 0)
        (PSELX && PWRITE && !PENABLE && PSTRB )
            |-> ##1 (PSELX && PWRITE && PENABLE && PSTRB &&
                     $stable(PADDR) && $stable(PWDATA))[*3];
    endproperty

    assert property(p_write_stability)
    else $error("WRITE STABILITY FAILED: PADDR/PWDATA changed!");


    // ------------------------------------------------------------
    // PROPERTY 6 : SLAVE ERROR CHECK
    // Address out of memory range → PSLVERR must be high
    // ------------------------------------------------------------
    property p_slave_error;
        @(posedge PCLK) disable iff (!PRESETN)
        ( PADDR inside {[192:255]}) |-> ##1 PSLVERR;
    endproperty

    assert property(p_slave_error)
    else $error("SLAVE ERROR NOT ASSERTED FOR OUT OF RANGE ADDRESS!");

		// ------------------------------------------------------------
    // PROPERTY 7 : IDLE STATE CHECK
    // when pselx is 0 then it goes to idle state
    // ------------------------------------------------------------
    property p_idle_state;
        @(posedge PCLK) disable iff (!PRESETN)
				( !PSELX && PWRITE ) || ( !PSELX && !PWRITE ) |-> ( PENABLE == 0 && PREADY == 0 && PRDATA == 0 && PSLVERR == 0 ) |-> !PSELX;
    endproperty

    assert property(p_idle_state)
    else $error(" IDLE STATE FAILED WHEN PSELX IS 0");
 
		// ----------------------------------------------------------------
    // PROPERTY 8 : PSTRB CHECK
    // when pwrite is 1 then pstrb should select only single byte_lane
    // ----------------------------------------------------------------
  
    property p_pstrb_one_hot;
    @(posedge PCLK) disable iff(!PRESETN || !PSTRB)
    (PSELX && PENABLE && PWRITE) |-> $onehot(PSTRB);
    endproperty

     assert property(p_pstrb_one_hot)
     else $error("Illegal PSTRB pattern – expected one-hot");

endinterface

	
