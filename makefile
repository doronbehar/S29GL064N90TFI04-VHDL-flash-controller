SETTINGS_FILE="settings.tcl"
# project-name
PROJECT=flash_controller
# device selected for programming
DEVICE=$(shell awk '$$1 == "set_global_assignment" && $$2 == "-name" && $$3 == "DEVICE" {print $$4}' ${SETTINGS_FILE})
# family of the device
FAMILY=$(shell awk '$$1 == "set_global_assignment" && $$2 == "-name" && $$3 == "FAMILY" {for(i = 4; i <= NF; i++) {printf $$i" "}; printf "\n"}' ${SETTINGS_FILE})
# custom FLAGS - mainly for setting the 64 bit flag or not:
FLAGS=--64bit
all: compile program
compile:
	quartus_sh ${FLAGS} --flow compile ${PROJECT}
project:
	quartus_sh ${FLAGS} --tcl_eval project_new -f ${FAMILY} -overwrite -p ${DEVICE} ${PROJECT}
program:
	quartus_pgm ${FLAGS} -c USB-Blaster ${PROJECT}.cdf
RTL:
	qnui ${FLAGS} ${PROJECT}
symbol:
	quartus_map ${FLAGS} ${PROJECT} --generate_symbol=${d}
analysis:
	quartus_map ${FLAGS} ${PROJECT}
