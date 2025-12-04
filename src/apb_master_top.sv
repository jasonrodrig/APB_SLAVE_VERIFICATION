
//`include "uvm_macros.svh"
`include "defines.sv"
`include "apb_slave_design.v"
`include "apb_master_interface.sv"
`include "apb_master_packages.sv"
`include "apb_master_assertions.sv"
import uvm_pkg::*;
import apb_master_pkg::*;

// Testbench Top module block 
module top;

	//clock generation
	bit PCLK = 0;
	always #5 PCLK = ~PCLK;

	// interface instantiation
	apb_master_interface vif(PCLK);

	// design instantiation
/*	apb_slave DUT(
		.clk(vif.PCLK),
		.rst_n(vif.PRESETN),
		.paddr(vif.PADDR),
		.psel(vif.PSELX),
		.penable(vif.PENABLE),
		.pwrite(vif.PWRITE),
		.pwdata(vif.PWDATA),
		.pstrb(vif.PSTRB),
		.pready(vif.PREADY),
		.prdata(vif.PRDATA),
		.pslverr(vif.PSLVERR)
	);
*/

	apb_slave DUT(
		.PCLK(vif.PCLK),
		.PRESETn(vif.PRESETN),
		.PADDR(vif.PADDR),
		.PSEL(vif.PSELX),
		.PENABLE(vif.PENABLE),
		.PWRITE(vif.PWRITE),
		.PWDATA(vif.PWDATA),
		.PSTRB(vif.PSTRB),
		.PREADY(vif.PREADY),
		.PRDATA(vif.PRDATA),
		.PSLVERR(vif.PSLVERR)
	);

	// instantiating assertion signals
	bind vif apb_master_assertions ASSERT(
		.PCLK(vif.PCLK),
		.PRESETN(vif.PRESETN),
		.PADDR(vif.PADDR),
		.PSELX(vif.PSELX),
		.PENABLE(vif.PENABLE),
		.PWRITE(vif.PWRITE),
		.PWDATA(vif.PWDATA),
  	.PSTRB(vif.PSTRB),
		.PREADY(vif.PREADY),
		.PRDATA(vif.PRDATA),
		.PSLVERR(vif.PSLVERR)
);

	// setting the config_db at the top module 
	initial begin 
		uvm_config_db#(virtual apb_master_interface)::set(null,"*","vif",vif);
		$dumpfile("dump.vcd");
		$dumpvars;
	end

	// initatiating apb_master_regresion_test 
	initial begin 
		//run_test("presetn_test");
	    run_test("apb_master_regression_test");
		#1000 $finish;
	end
endmodule
