/*
 *Create by Bill.Zhang in 2023;
 */




#include "Testbench.h"

int sc_main(int argc, char *argv[])
{
    TbxSyscManager *tbx = new TbxSyscManager("inst", argc, argv);
    test inst("Test");

    sc_start();
    printf("----> Exit!\n");
    return 0;
}


void test::test_function()
{
    printf("Inside Addr Map Setting \n");
     
}


void test::tcp_server_thread()
{
  int client_fd[100]={0};
  int server_sock_fd;
  struct sockaddr_in server_addr, client_addr;
  memset(&server_addr,0,sizeof(server_addr));
  server_addr.sin_family=AF_INET;
  server_addr.sin_port=htons(9999);
  server_addr.sin_addr.s_addr=INADDR_ANY;
  server_sock_fd=socket(AF_INET,SOCK_STREAM,0);
  if(server_sock_fd<0)
  {
    printf("error:%s\n",strerror(errno));
    return;
  }

  int option=1;
  setsockopt(server_sock_fd,SOL_SOCKET,SO_REUSEADDR,(char *)&option,sizeof(option));
  struct linger li;
  li.l_onoff=1;
  li.l_linger=1;
  setsockopt(server_sock_fd,SOL_SOCKET,SO_LINGER,(char *)&li,sizeof(li));

  if(bind(server_sock_fd,(struct sockaddr *)&server_addr,sizeof(server_addr))<0)
  {
    printf("error:%s\n",strerror(errno));
    return;
  }

  if(listen(server_sock_fd,10)<0)
  {
    printf("error:%s\n",strerror(errno));
    return;
  }
  //printf("----run here----\n");

  int flags=fcntl(server_sock_fd,F_GETFL,0);
  fcntl(server_sock_fd,F_SETFL,flags|O_NONBLOCK);

  //fd_set server_fd_set;
  //printf("----run here----\n");


  for(;;)
  {
    socklen_t len;
    len=sizeof(client_addr);
    client_fd[0]=accept(server_sock_fd,(struct sockaddr *)&client_addr,&len);

    if(client_fd[0]<0)
    {
      if(errno==EAGAIN || errno== EWOULDBLOCK)
      {
        wait(1,SC_US);
        
        continue;
      }
      else
      {
        printf("call accept error\n");
        //break;
      }
    }
  
    char szlp[17];
    bzero(szlp,17);
    inet_ntop(AF_INET,&client_addr.sin_addr,szlp,16);
    printf("from client IP:%s,Port:%d\n",szlp,ntohs(client_addr.sin_port));
    char buf[256];
    time_t t;
    time(&t);
    int datalen=sprintf(buf,"Server:%u\n",(unsigned int)t);
    send(client_fd[0],buf,datalen,0);
    close(client_fd[0]);
    
    dm_clock_suspend();
    //dm_reg_force();
    //unsigned nOpType = 3;
    //dm_reg_setvalue("top.rst_n",&nOpType,1);
    //dm_reg_getvalue();

    //dm_memory_download_file_v3 ("arg1.pat", "top.xrtl.mem1");

    dm_clock_resume();

    dm_clock_suspend();
    dm_upload("./test.wave", 0, NULL, 0, 0, 0, 0);
    dm_clock_resume();

    //dm_reinitialize(true);
    //dm_init();
    //dm_memory_download_file_v3 ("arg1.pat", "top.xrtl.mem1");
    char *emuName = new char[100];  
    //dm_Init(0, NULL);
    //dm_connect(emuName);
    dm_clock_suspend();
    dm_trace_on();
    dm_clock_resume();
    //dm_run();

  
    wait(10,SC_US);
  }

}


void test::tcp_data_process_thread()
{
  for(;;)
  {
    wait(1000,SC_MS);
  }


}


//=========================================================================//
// This Thread will send two nb write Txn and then two nb Read Txn and     //
// print the Responses received.                                           //
//=========================================================================//
void test:: main_thread()
{
    test_function();

    //padder_transactor=new adder_transactor();
    //padder_transactor->TestPrint();


    //sc_stop();

}



