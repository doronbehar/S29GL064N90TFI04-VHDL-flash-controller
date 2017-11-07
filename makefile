# project-name
PROJECT=flash_controller
# device selected for programming
DEV=EP4CE115F29C7
# family of the device
F="Cyclone IV E"
# custom FLAGS - mainly for setting the 64 bit flag or not:
FLAGS=--64bit
all: compile program
compile:
	quartus_sh ${FLAGS} --flow compile ${PROJECT}
project:
	quartus_sh ${FLAGS} --tcl_eval project_new -f ${F} -overwrite -p ${DEV} ${PROJECT}
program:
	quartus_pgm ${FLAGS} -c USB-Blaster ${PROJECT}.cdf
RTL:
	qnui ${FLAGS} ${PROJECT}
symbol:
	quartus_map ${FLAGS} ${PROJECT} --generate_symbol=${d}
analysis:
	quartus_map ${FLAGS} ${PROJECT}
