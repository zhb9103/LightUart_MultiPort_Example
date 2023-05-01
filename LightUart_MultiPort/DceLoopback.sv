// @(#) $Id: DceLoopback.sv 1059 2013-07-06 16:20:56Z jstickle $

//----------------------------------------------------------------------------
//   Mentor Graphics, Corp.
//
//   (C) Copyright, Mentor Graphics, Corp. 2003-2011
//   All Rights Reserved
//   Licensed Materials - Property of Mentor Graphics, Corp.
//
//   No part of this file may be reproduced, stored in a retrieval system,
//   or transmitted in any form or by any means --- electronic, mechanical,
//   photocopying, recording, or otherwise --- without prior written permission
//   of Mentor Graphics, Corp.
//
//   WARRANTY:
//   Use all material in this file at your own risk.  Mentor Graphics, Corp.
//   makes no claims about any material contained in this file.
//----------------------------------------------------------------------------

//============================================================================
// DceLoopback                                                 johnS 12-6-2011
//
// This simple loopback controller is a small module that acts as a
// DCE endpoint of a standard RS232 style UART connection.
//
// It receives data via the rxd input from the data terminal equipment (DTE)
// which is typically the XlUartTransactor itself.
//
// It simply collects that serial data into whole character, convects it
// from lower to upper case if it detects that the character is a lower case
// alphabet character (i.e. in the ASCII range decimal 97-122).
//
// And then it transmits data back to the DTE via the txd output.
//============================================================================

module DceLoopback (

        // -------------------------    -------------------------
        // Inputs                       Outputs
        input clock,
        input reset,
        input cts,
                                         output reg rts,
        input rxd,
                                         output txd );
             // pragma attribute DceLoopback partition_module_xrtl

      //  parameter DEFAULT_BAUD_RATE = 115200;
      //  parameter CLOCK_RATE = 10000000; // Hz
            // Tuned to emulator clock freq - ~1 MHz for most accurate
            // emulation of real baud rate (assuming 100% emulator concurrency,
            // and that a fastest clock running at full clock rate is
            // passed into this transactor).
            //
            // So for example 1 MHz / 115200 bits/sec = 8.68 clocks/bit to
            // sustain the nominal baud rate.
// {
    // ---------------------------------------------
    // Local params
    //

    localparam CHARACTER_WIDTH = 8;

    // ---------------------------------------------
    // Local variables
    //
 
    bit [15:0] transmitBuffer;
    bit [7:0] transmitCount;
    bit [15:0] clocksPerBit;
    bit [7:0] txData;
    bit [7:0] rxData;
    bit [31:0] DBR;
    bit [2:0]  trigger_flag;
    //bit [31:0] baudRate;

    //--------------------------------------------
    // Initialization
    
    initial begin
        rts <= 1;
        transmitBuffer <= {16{1'b1}}; 
            // txd is initialized to "marking state" (logic 1)
        DBR = 5;
        transmitCount <= 0;
    //    clocksPerBit <= DBR<<4;;

      //  baudRate <= DEFAULT_BAUD_RATE;
    end
    always@(posedge clock)begin
      clocksPerBit <= DBR<<4;
    end

    // Once the banner is transmitted, just go into loopback mode.
    assign txd = transmitBuffer[transmitCount];

    //--------------------------------------------
    // sendBanner()
    //

    task sendBanner( bit [128*CHARACTER_WIDTH-1:0] message, int length );
        int i;
        for( i=0; i<length; i++ ) begin // {
            txData = message[(length-i)*CHARACTER_WIDTH-1 -: CHARACTER_WIDTH];
            transmitBuffer <= { 1'b1, 1'b1, 1'b1, txData, 1'b0 };
                             //    ^     ^     ^             ^
                             //    |     |     |             |
                             //    |     |     |             +---- start bit
                             //    |     +-----+---- stop bits
                             //    +----- continuation of 1's for marking

            transmitCount <= 0;
            repeat( CHARACTER_WIDTH+3 ) begin
                // tbx repeat_with_non_zero_iteration
                repeat( clocksPerBit ) @(posedge clock);
                transmitCount <= transmitCount + 1;
            end
        end // }
    endtask

    //--------------------------------------------
    // catchACharacter()
    //
    // This small task monitors the serial rxd input and tries to catch
    // receive characters.
    //

    task catchACharacter;

        // Purge start bits
        while( rxd != 0 ) @(posedge clock);

        // tbx repeat_with_non_zero_iteration
        repeat( clocksPerBit + clocksPerBit / 2 ) @(posedge clock);

        rxData[0] = rxd;

        for( shortint unsigned i=1; i<CHARACTER_WIDTH; i++ ) begin
            // tbx repeat_with_non_zero_iteration
            repeat( clocksPerBit ) @(posedge clock);
            rxData[i] = rxd;
        end

        // Wait at least one stop bit interval before looking for start bit.
        // tbx repeat_with_non_zero_iteration
        repeat( clocksPerBit ) @(posedge clock);
    endtask

    //--------------------------------------------
    // Main FSM
    //
    // This simple FSM prints out a banner then just starts echoing back
    // captured characters.

    initial begin // {
        @(posedge clock);

        while( reset != 0 ) @( posedge clock );

        sendBanner( "DBR = 5 now ............\n", 27 );
	//repeat(1000) @(posedge clock);
        trigger_flag = trigger_flag | 3'b001;        
        sendBanner( "DBR = 10 now ...........\n", 27 );
	//repeat(1000) @(posedge clock);
	trigger_flag = trigger_flag | 3'b011;
        sendBanner( "DBR = 20 now ...........\n", 27 );
	//repeat(1000) @(posedge clock);
        trigger_flag = trigger_flag | 3'b111;
        sendBanner( "Type ^d to terminate ...\n", 27 );
        sendBanner( "\n", 1 );

        sendBanner( "> ", 2 );

        rts <= 0;

        forever begin // {
 
            catchACharacter();
            if( rxData >= 8'h61 && rxData <= 8'h7a )
              sendBanner( rxData - 8'h20, 1 );
            else if( rxData == 8'h3 ) // ^C forces newline
                sendBanner( "^C\n> ", 5 );
            else sendBanner( rxData, 1 );
            if( rxData == 8'ha || rxData == 8'hd )
                sendBanner( "> ", 2 );

            // tbx repeat_with_non_zero_iteration
            repeat( clocksPerBit ) @(posedge clock);
        end // } forever
    end // } initial
endmodule // }
