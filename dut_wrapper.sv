/*
 *Create by Bill.Zhang in 2023;
 */





module dut_wrapper();


  reg clock10M;
  reg reset;

  wire txd0, rxd0;
  wire rts0, cts0;

  wire txd1, rxd1;
  wire rts1, cts1;

  wire[31:0] DBR0, DBR1;
  assign DBR0 = dceLoopback0.DBR;
  assign DBR1 = dceLoopback1.DBR;
 
  // OBJ_NAME max length is limited 40 bytes by Bill.Zhang;
  //LightUartTransactor #(.OBJ_INDEX(0),.OBJ_NAME("light_uart0")) uartTransactor0  (clock10M, cts0, rts0, rxd0, txd0 ,DBR0);
 
  // terminal type(TERM_TYPE):
  // 0: user operate directly;
  // 1: xterm;
  // 2: tcp server;
  LightUartTransactor #(.OBJ_INDEX(0),.TERM_TYPE(2),.OBJ_NAME("")) uartTransactor0  (clock10M, cts0, rts0, rxd0, txd0 ,DBR0);
  LightUartTransactor #(.OBJ_INDEX(1),.TERM_TYPE(1),.OBJ_NAME("light_uart1")) uartTransactor1  (clock10M, cts1, rts1, rxd1, txd1 ,DBR1);
 
 
 
  DceLoopback dceLoopback0 (clock10M, reset, rts0, cts0, txd0, rxd0);
  DceLoopback dceLoopback1 (clock10M, reset, rts1, cts1, txd1, rxd1);





endmodule

