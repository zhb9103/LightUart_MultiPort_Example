/*
 *Create by Bill.Zhang in 2023;
 */




#include "errno.h"
#include "sys/socket.h"
#include "unistd.h"
#include "fcntl.h"
#include "arpa/inet.h"
#include "netinet/in.h"
#include <systemc.h>
#include <iostream>
#include <stdio.h>
#include "svdpi.h"
#include <list>
#include <map>
#include "string.h"
#include <cstring>
#include "tbxcmanager.hxx"
#include "TclClientLib_C.h"
#include <stdlib.h>
#include "csReturnCodes.h"



using namespace std;


#ifndef MTI_SYSTEMC
//#include "tbxbindings.h"
#include "tbxsyscmanager.hxx"
#endif

//#include "adderTransactor.h"


class test : public sc_module
{
    private:
    SC_HAS_PROCESS(test);



    public:
    
    ///adder_transactor* padder_transactor;
     
    test(sc_module_name name) :sc_module(name)
    {

      printf("Testbench\n");


      SC_THREAD(main_thread);
      SC_THREAD(tcp_server_thread);
      SC_THREAD(tcp_data_process_thread);


    }

    void start_of_simulation()
    {
      printf("start of simulation \n");
    }
    
    void test_function();
    void main_thread();
    void tcp_server_thread();
    void tcp_data_process_thread();

};




