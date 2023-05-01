
/*
 *
 * Created by bill.zhang in 2023;
 *
 */

#ifndef __LIGHT_UART_H__
#define __LIGHT_UART_H__

#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include <iostream>


class LightUart
{

private:
  char version[32];


public:
  char c;
  char uartfifo_buffer[256];
  char uartfifo_tx_buffer[256];
  char tempuartlogfilename[256];


  FILE *uartlog;

public:
  char *GetVersion();
  void InitAll();


};


#endif

