# project-name
P=FLASH-controller
# top-level-entity
TLE=FLASH_controller
# device selected for programming
DEV=EP4CE115F29C7
# family of the device
F="Cyclone IV E"
# custom FLAGS - mainly for setting the 64 bit flag or not:
FLAGS=--64bit
all: compile program
compile:
	quartus_sh ${FLAGS} --flow compile ${P}
project:
	quartus_sh ${FLAGS} --tcl_eval project_new -f ${F} -overwrite -p ${DEV} ${P}
program:
	quartus_pgm ${FLAGS} -c USB-Blaster ${P}.cdf
RTL:
	qnui ${FLAGS} ${P}
symbol:
	quartus_map ${FLAGS} ${P} --generate_symbol=${d}
analysis:
	quartus_map ${FLAGS} ${P}
