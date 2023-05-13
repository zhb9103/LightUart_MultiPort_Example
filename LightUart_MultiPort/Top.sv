//============================================================================
// @(#) $Id: Top.sv 896 2012-11-26 23:22:28Z jstickle $
//============================================================================

   //_______________________
  // Mentor Graphics, Corp. \_________________________________________________
 //                                                                         //
//   (C) Copyright, Mentor Graphics, Corp. 2003-2012                        //
//   All Rights Reserved                                                    //
//                                                                          //
//    Licensed under the Apache License, Version 2.0 (the                   //
//    "License"); you may not use this file except in                       //
//    compliance with the License.  You may obtain a copy of                //
//    the License at                                                        //
//                                                                          //
//        http://www.apache.org/licenses/LICENSE-2.0                        //
//                                                                          //
//    Unless required by applicable law or agreed to in                     //
//    writing, software distributed under the License is                    //
//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR                //
//    CONDITIONS OF ANY KIND, either express or implied.  See               //
//    the License for the specific language governing                      //
//    permissions and limitations under the License.                      //
//-----------------------------------------------------------------------//

//============================================================================
// module Top                                               -- johnS 10-3-2011
//
// The Top module is the top level netlist which connects the transactors
// and DUT together.
//============================================================================

//============================================================================
//Has been modefied by Qing on 8-7-2013
//
//============================================================================

`timescale 1ns/1ns

module Top (); // {

    localparam CLOCK_HALF_PERIOD_10M = 50; // For 10 MHz clock
    localparam CLOCK_HALF_PERIOD_12M = 41; // For 12 MHz clock

    localparam NUM_RESET_CYCLES =  100;

    // Give DCE a different clock than transactor to prove UART character
    // transmission can function correctly nonetheless as long as the
    // baud rates match.
    reg clock10M, clock12M;
    reg reset;

    wire txd0, rxd0;
    wire rts0, cts0;

    wire txd1, rxd1;
    wire rts1, cts1;


    // tbx clkgen
    initial begin
        clock10M = 0;
        #CLOCK_HALF_PERIOD_10M;
        forever #CLOCK_HALF_PERIOD_10M clock10M = ~clock10M;
    end

    // tbx clkgen
    initial begin
        clock12M = 0;
        #CLOCK_HALF_PERIOD_12M;
        forever #CLOCK_HALF_PERIOD_12M clock12M = ~clock12M;
    end

    // Reset generator
    // tbx clkgen
    initial begin
        reset = 1;
        #(CLOCK_HALF_PERIOD_10M*20);
        reset = 0;
    end

    
//    import "DPI-C" function void getbuf(output bit [319:0] stream,
//                                        output int count, output bit eom);
//
////
//// XRTL FSM that fetches the byte stream from HVL applies to the DUT
//// one each clock. It stops once it receives eom.
////
//
//    wire clock = clock10M;
//    bit eom = 0;
//    int remaining = 0;
//    bit [319:0] stream;
//    bit [7:0] inbyte;
//    always @(posedge clock) begin
//      if(reset)
//          inbyte <= 8'hff;
//      else begin
//          if(remaining==0 && eom==0)
//              getbuf(stream, remaining, eom);
//          if(remaining > 0) begin
//            inbyte <= stream[7:0];
//            stream = stream >> 8;
//            remaining--;
//          end
//      end
//    end



    //---------------------------------------------------------------------
    // Uart transactor cross-coupled to DCE loopback module.
    //
    // Note: Transactor here intentionally shows mismatching baud rate
    // to the DCE to demonstrate that the testbench can override the default
    // baud rate on the transactor to match the DCE.
    wire[31:0] DBR0, DBR1;
    assign DBR0 = dceLoopback0.DBR;
    assign DBR1 = dceLoopback1.DBR;

    // OBJ_NAME max length is limited 40 bytes by Bill.Zhang;
    //LightUartTransactor #(.OBJ_INDEX(0),.OBJ_NAME("light_uart0")) uartTransactor0  (clock10M, cts0, rts0, rxd0, txd0 ,DBR0);

    // terminal type(TERM_TYPE):
    // 0: user operate directly;
    // 1: xterm;
    // 2: tcp server;
    //LightUartTransactor #(.OBJ_INDEX(0),.TERM_TYPE(0),.OBJ_NAME("Uart0")) uartTransactor0  (clock10M, cts0, rts0, rxd0, txd0 ,DBR0);
    //LightUartTransactor #(.OBJ_INDEX(1),.TERM_TYPE(1),.OBJ_NAME("Uart1")) uartTransactor1  (clock10M, cts1, rts1, rxd1, txd1 ,DBR1);
    LightUartTransactor uartTransactor0  (clock10M, cts0, rts0, rxd0, txd0 ,DBR0);
    LightUartTransactor #(.TERM_TYPE(1)) uartTransactor1  (clock10M, cts1, rts1, rxd1, txd1 ,DBR1);


    DceLoopback dceLoopback0 (clock10M, reset, rts0, cts0, txd0, rxd0);
    DceLoopback dceLoopback1 (clock10M, reset, rts1, cts1, txd1, rxd1);


    //---------------------------------------------------------------------
    // xFSDB probe

endmodule // }
