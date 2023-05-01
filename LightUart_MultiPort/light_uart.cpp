
/*
 *
 * Created by bill.zhang in 2023;
 *
 */



#include "light_uart.h"



char *LightUart::GetVersion()
{
  memset(this->version,0,32);
  sprintf(this->version,"0.0.1");
  return this->version;
}


void LightUart::InitAll()
{
  //this->offset=0;
  //this->res=0;
  this->c=0;

  memset(this->uartfifo_buffer,0,256);
  memset(this->uartfifo_tx_buffer,0,256);
  memset(this->tempuartlogfilename,0,256);


}



