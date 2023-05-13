//==========================================================================//Originally created by johnS
//Has been modefied by Sun on 11-26-2014
//This one is not a general model, but only for Hisilicon
//============================================================================

`timescale 1ns/1ns
module LightUartTransactor
(
	input 		clk,
	input 		cts,	
	output reg 	rts,
	input 		rxd,
	output reg	txd,
	input[31:0]     DBR
);

int OBJ_INDEX=0;
parameter TERM_TYPE=1;

localparam CHARACTER_WIDTH = 8;

localparam POLLING_INTERVAL =117;
localparam RTS_VALUE = 0;

bit[CHARACTER_WIDTH+3:0] 	txBuffer;
bit[15:0] 			clocksPerBit = 100;
//bit[31:0] 			baudRate;
bit[31:0] 			pollingInterval;
bit 				txLock;//Lock the xterm_transmit_chars process

byte 				rxData;
byte 				txData;
byte 				txData_c;
byte				i;
event 				initiateTransmit;
//Register configuration
initial begin
  txBuffer = 0;
  pollingInterval = POLLING_INTERVAL;
  txd = 1;
  txData = 0;
  rts = RTS_VALUE;
  txLock = 0;
end

always@(posedge clk)begin
	clocksPerBit = DBR<<4;;
end

export "DPI-C" function setPollingInterval;
function void setPollingInterval(int newPollingInterval);
	pollingInterval = newPollingInterval;
endfunction

export "DPI-C" function setRts;
function void setRts(bit newRts);
	rts = newRts;
endfunction

export "DPI-C" function getClocksPerBit;
function int unsigned getClocksPerBit();
	return clocksPerBit;
endfunction

export "DPI-C" function getPollingInterval;
function int unsigned getPollingInterval();
	return pollingInterval;
endfunction 

export "DPI-C" function getRts;
function int unsigned getRts();
	return rts;
endfunction
event finishEvent;
export "DPI-C" task tbenchTerminate;
task tbenchTerminate();
	-> finishEvent;
endtask//--------------\
		     // The tbenchTerminate function get the finish signal from c side,and pass it to the transactor through finishEvent
always begin//---------/
	@(posedge clk);
	@finishEvent;
	@(posedge clk);
	$finish;
end
event txFlag;
export "DPI-C" function putTx;
function void putTx(byte newTxData);
	txBuffer = {1'b1,1'b1,1'b1,newTxData,1'b0};
	txData = newTxData;
	txLock = 1; 
	->txFlag;	
endfunction//-------\
                   // The putTx function get the data from c side, and trigger the tx event  
always begin//------/
	@ txFlag;
	@ (posedge clk);
	repeat(pollingInterval-1)@(posedge clk);
	txd = txBuffer[0];
	repeat(clocksPerBit) @(posedge clk);
	repeat(CHARACTER_WIDTH+3) begin
		txBuffer = txBuffer>>1;
		txd = txBuffer[0];
		repeat(clocksPerBit) @(posedge clk);
	end	
	txLock = 0;
end

//-------------------------------------------------
    import "DPI-C" function void getbuf(int obj_index, output bit [319:0] stream,
                                        output int count, output bit eom);

//
// XRTL FSM that fetches the byte stream from HVL applies to the DUT
// one each clock. It stops once it receives eom.
//

    
//    always @ (posedge clk) begin
//      if (filedone == 0 && tx_done) begin 
//         cnt = $fread(var1,fd);
//         if (cnt == 0) begin
//           filedone = 1;
//           $display("Binary file transfer completed @time %t", $time);
//         end
//         else begin
//           var1_d = var1;
//           $display("cnt = %d, var1=%h", cnt, var1);
//         end
//         repeat(10*clocksPerBit)@(posedge clk);
//      end
//    end

enum {IDLE, LOAD, LOAD_DONE, TRANSFER} State;
integer cnt;
//integer fd;
bit [7:0] var1;
//bit filedone;
bit tx_done;
bit reset;

initial begin
  reset = 1;
  //filedone = 0;
  //fd = $fopen("datafile", "rb");
  @ (posedge clk);
  repeat(1000)@(posedge clk);
  reset = 0;
  @ (posedge clk);
  //wait (filedone==1);
  @ (posedge clk);
  repeat(100)@(posedge clk);
  
  // $finish;
end

always @(posedge clk) begin
if (reset) begin
    cnt = 0;
    var1 = 0;
    //filedone = 0;
    tx_done = 1;
end
else begin
    case (State)
      //IDLE: 
            //if (filedone == 0) State = LOAD;
            //else State 	= IDLE;
      LOAD: 
      begin 
            //cnt 	= $fread(var1, fd); 
            State 	= LOAD_DONE;
      end
      LOAD_DONE:
      begin 
         if (cnt == 0) begin
            //filedone = 1;
            $display("Binary file transfer completed @time %t", $time);
            State = IDLE;
         end
         else begin
//            $display("cnt = %d, var1=%h", cnt, var1);
            //filedone = 0;
            State = TRANSFER;
         end
      end
      
      TRANSFER:
      begin
            txBuffer =  {1'b1,1'b1,1'b1,var1[7:0],1'b0};
            txLock = 1;
            ->txFlag;
            while(txLock) @(posedge clk);
            cnt = 0;
            repeat(10*clocksPerBit)@(posedge clk);
            State = IDLE;
      end
      default: State = IDLE;
    endcase
end
end

//always @(posedge clk) begin
//end
//always @ (posedge clk) begin
//  if (cnt != 0 && filedone ==0) begin
//    tx_done = 0;
//    txData = var1_d;
//    txBuffer = {1'b1,1'b1,1'b1,var1_d[7:0],1'b0};
//    txLock = 1;
//    ->txFlag;
//    while(txLock) @(posedge clk);
//    cnt = 0;
//    repeat(10*clocksPerBit)@(posedge clk);
//    tx_done = 1;
//  end
//end
//    bit eom = 0;
//    int remaining = 0;
//    bit [319:0] stream;
//    bit [7:0] inbyte;
//    always @(posedge clk) begin
//          if(remaining==0 && eom==0)
//              getbuf(OBJ_INDEX, stream, remaining, eom);
//          if(remaining > 0) begin
//            inbyte = stream[7:0];
//            remaining--;
//	    txBuffer = {1'b1,1'b1,1'b1,stream[7:0],1'b0};
//            txData = stream[7:0];
//            stream = stream >> 8;
//            txLock = 1; 
//            ->txFlag;	
//	    while(txLock) @(posedge clk);
//	    repeat(10*clocksPerBit)@(posedge clk);
//          end
//          
//    end


//------------------------------------------------
//Import "DPI-C" declareration

import "DPI-C" context function void sendRxToXterm(int obj_index, byte rxData);
import "DPI-C" context function int xterm_init(int term_type);
import "DPI-C" context function byte xterm_transmit_chars(int obj_index);


//import "DPI-C" context function void billTestIf(int index);

//------------------------------------------------
bit[399:0] device_name;
string temp_device_name;
//--------------------------------------------------
//This FSM is free-running 
initial begin
        int temp_int;
	@(posedge clk);
        OBJ_INDEX=xterm_init(TERM_TYPE);
        //$display("hi %s!",temp_device_name);
 	while(1)//not EOT
		@(posedge clk);
end

//----------------------------------------------------
//Receive FSM
initial begin
	@(posedge clk);
	rxData = 0;
	forever begin
		@(posedge clk);
		while(rxd!=0) @(posedge clk);
		repeat(clocksPerBit+clocksPerBit/2) @(posedge clk);
		rxData[0] = rxd;
		for(i = 1;i<CHARACTER_WIDTH;i++)begin
			repeat(clocksPerBit)@(posedge clk);
			rxData[i] = rxd;
		end
 		sendRxToXterm(OBJ_INDEX,rxData);

		//$display("sendRxToXterm:%d,%c\n",OBJ_INDEX,rxData);

		repeat(clocksPerBit)@(posedge clk);		
	end
end
initial begin
        txBuffer = 12'hfff;
	@(posedge clk);
        //wait (filedone == 1);
	@(posedge clk);
	forever begin
	    @(posedge clk);
		txData_c = xterm_transmit_chars(OBJ_INDEX);
		
		if(txData_c>0) begin

		   //$display("xterm_transmit_chars:%d,%c\n",OBJ_INDEX,txData_c);

		   txBuffer={1'b1,1'b1,1'b1,txData_c,1'b0};
		   txData = txData_c;
		   txLock = 1;
		   ->txFlag;
                end
	    while(txLock) @(posedge clk);
	    repeat(50*clocksPerBit)@(posedge clk);
	end
end


endmodule


