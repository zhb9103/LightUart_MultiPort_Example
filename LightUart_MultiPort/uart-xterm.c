
// modified for supporting multi ports, by Bill.Zhang, in 2022-12-28;


#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include "string.h"
#include <pthread.h>
#include "light_uart.h"
#include "queue_obj.h"

#define LIGHT_UART_MULTI_PORT_VERSION "1.0.1"


#define UART_DATA_PROCESS_BUFFER_LENGTH 1024*10

static int rxfd,txfd;
LightUart *pLightUartObj; 
char uart_data_process_buffer[UART_DATA_PROCESS_BUFFER_LENGTH];
unsigned int uart_data_process_buffer_i;
pthread_t thread_uart_data_process;
void *uart_data_process(void *args);

QUEUE_OBJ QUEUE_OBJ_APP;

void *capture_keystrokes(void *context) 
{
  do 
  {
    char c;
    // stdin;
    read(0, &c, 1);
       
    if (c != '\r') 
    {
      //write(txfd, &c, 1);
      
      uart_data_process_buffer[uart_data_process_buffer_i]=c;
      uart_data_process_buffer_i++;
    }
    if(c == 0x08)
    {       
      if(uart_data_process_buffer_i>0)
      {
        uart_data_process_buffer_i--;
      }
    }
    if((c == 0x0d)||(c==0x0a))
    {
      // move data from queue to buffer;
      if(uart_data_process_buffer_i>0)
      {
        for(int uart_data_i=0;uart_data_i<uart_data_process_buffer_i-1;uart_data_i++)
        {
          QUEUE_OBJ_APP.EnQueue(uart_data_process_buffer[uart_data_i]);
        }
        memset(uart_data_process_buffer,0,UART_DATA_PROCESS_BUFFER_LENGTH);
        uart_data_process_buffer_i=0;
      }
    }
  } while (1);
  return NULL;
}

void *uart_data_process(void *args)
{
  char send_char; 
  //write(txfd, &c, 1);
  for(;;)
  {
    if(QUEUE_OBJ_APP.QueueLength()>0)
    {
      send_char=QUEUE_OBJ_APP.DeQueue();
      write(txfd,&send_char,1);
      fputc(send_char,pLightUartObj->uartlog);
    }
    else
    {
      usleep(10000);// 10ms scan once;
    }
  }
}


int main(int argc, char *argv[]) 
{
  pthread_t tid;

  memset(uart_data_process_buffer,0,UART_DATA_PROCESS_BUFFER_LENGTH);
  uart_data_process_buffer_i=0;
  QUEUE_OBJ_APP.InitQueue();

  pLightUartObj=new LightUart();
  char *tempVersion=pLightUartObj->GetVersion();
  printf("Ver:%s\n",tempVersion);
  pLightUartObj->InitAll();


  if(argc!=3)
  {

    perror("parameter error!");

    return -1;
  }


  sprintf(pLightUartObj->uartfifo_buffer,"./uart_fifo/uartfifo_%s",argv[1]);
  sprintf(pLightUartObj->uartfifo_tx_buffer,"./uart_fifo/uartfifo-tx_%s",argv[1]);

  //system("/bin/stty raw -echo");
  system("/bin/stty sane ignbrk intr ^k eof ^@");


  if (0 > (rxfd = open (pLightUartObj->uartfifo_buffer, O_RDONLY))) 
  {
    perror("open(./uart_fifo/uartfifo)");
    return -1;
  }
  if (0 > (txfd = open (pLightUartObj->uartfifo_tx_buffer, O_WRONLY))) 
  {
    perror("open(./uart_fifo/uartfifo-tx)");
    return -1;
  }

 
  pthread_create(&tid, NULL, &capture_keystrokes, NULL);

  pthread_create(&thread_uart_data_process, NULL, &uart_data_process, NULL);


  sprintf(pLightUartObj->tempuartlogfilename,"./%s.log",argv[2]);

  pLightUartObj->uartlog = fopen(pLightUartObj->tempuartlogfilename,"w+");


  while (read(rxfd,&pLightUartObj->c,1) == 1) 
  {
    write(1,&pLightUartObj->c,1);
    if ((pLightUartObj->c != '\r')  && ( (int) pLightUartObj->c != 0)) 
    {
      fputc(pLightUartObj->c,pLightUartObj->uartlog);
      fflush(pLightUartObj->uartlog);
    }
  }
  fclose(pLightUartObj->uartlog);

  return 0;
}




