//TB_LANG = OSCI_SYSTEMC

MODE?=veloce



//SYS_GCC = gnu53
QUESTA_MVC_CORE_OSCLIB = linux64_el30_$(SYS_GCC)


compile: 
	vellib work
	velmap work ./work
	velanalyze -f vel_filelist.f 
	velcomp -top work.dut_wrapper



all: compile



build_hvl:
	###velhvl -64bit_runtime -cfiles "Testbench.cxx ./LightUart_MultiPort/dpi.c" -cflags "-I$(QUESTA_MVC_SYSTEMC_HOME)/include" -ldflags "adderTransactor.a -Wl,--whole-archive -Wl,-no-whole-archive"
	###velhvl -64bit_runtime -cfiles "Testbench.cxx ./LightUart_MultiPort/dpi.c" -cflags "-I$(VELOCE_HOME)/include -I$(VELOCE_HOME)/runtime/include -I$(VELOCE_HOME)/runtime/Tcl -I$(VELOCE_HOME)/DiamondTAPID/V2 -I$(QUESTA_MVC_SYSTEMC_HOME)/include" -ldflags "-lX11 -lm -lrt -lXt -lICE -lSM  $(VELOCE_HOME)/lib/amd64.linux.gcc530/libtclclient.so -Wl,--whole-archive -Wl,-no-whole-archive"
	velhvl -64bit_runtime -cfiles "Testbench.cxx ./LightUart_MultiPort/dpi.c" -cflags "-I$(VELOCE_HOME)/include -I$(VELOCE_HOME)/runtime/include -I$(VELOCE_HOME)/runtime/Tcl -I$(VELOCE_HOME)/DiamondTAPID/V2 -I$(QUESTA_MVC_SYSTEMC_HOME)/include" -ldflags "-lX11 -lm -lrt -lXt -lICE -lSM -Wl,--whole-archive -Wl,-no-whole-archive"


build_lib:
	$(CC) -c -fpic adderTransactor.cpp -I /veloce/Questa_2019.02/questasim/include
	ar rcs adderTransactor.a adderTransactor.o



run:
	echo $$LD_LIBRARY_PATH
	export LD_LIBRARY_PATH=$(QUESTA_MVC_SYSTEMC_HOME)/lib/$(QUESTA_MVC_CORE_OSCLIB):$$LD_LIBRARY_PATH; 
	velrun -64bit -cppinstall 5.3.0 -do run.do


clean:
	rm -rf work tbxbindings.h veloce.log veloce.med veloce.wave veloce.map adderTransactor.o veloce.*.tar.gz *.log

