QUESTA := /home/share/questa.csh
SHELL := /bin/csh

IGNORE:
	make clean
	make view
 
.ONESHELL:
 
all:
	source $(QUESTA) 
	make clean 
	make compile 
	make simulate
 
main:
	source $(QUESTA)
	make clean
	vlog -sv +acc +cover +fcover -l apb_master_top.log apb_master_top.sv
	vsim -vopt work.top -voptargs=+acc=npr -assertdebug -l simulation.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll coverage.ucdb; run -all; exit"
	vcover report -html coverage.ucdb -htmldir covReport -details
 
read:
	source $(QUESTA)
	vcover report -details coverage.ucdb

view:
	firefox ./covReport/index.html
 
compile:
	source $(QUESTA)
	vlog -sv apb_master_top.sv
 
simulate:
	vsim -c top +UVM_VERBOSITY=UVM_MEDIUM -do "run -all;exit"

log:
	less -R simulation.log

clean:
	rm -rf transcript work covReport/
	rm dump.vcd simulation.log apb_master_top.log coverage.ucdb 
	clear:
	clear
