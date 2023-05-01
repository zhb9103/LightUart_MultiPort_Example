/*
 File Name       : tbxbindings.h

 This is a machine-generated file. Please do not edit.
*/

#ifndef _tbxbindings_h_
#define _tbxbindings_h_

#include <svdpi.h>
#include "vpi_user.h"
#ifdef __cplusplus
void tbx_perform_release_impl(const char* file, int line, const char* signal_name);
#define tbx_perform_release(signal_name) tbx_perform_release_impl(__FILE__,__LINE__,signal_name)
void tbx_perform_set_impl(const char* file, int line, const char* signal_name, svBitVecVal* signal_value);
#define tbx_perform_set(signal_name,signal_value) tbx_perform_set_impl(__FILE__,__LINE__,signal_name,signal_value)
void tbx_perform_force_impl(const char* file, int line, const char* signal_name, svBitVecVal* signal_value);
#define tbx_perform_force(signal_name,signal_value) tbx_perform_force_impl(__FILE__,__LINE__,signal_name,signal_value)
void tbx_perform_get_impl(const char* file, int line, const char* signal_name, svBitVecVal* &signal_value, int& size);
#define tbx_perform_get(signal_name,signal_value,size) tbx_perform_get_impl(__FILE__,__LINE__,signal_name,signal_value,size)

extern "C" {
#endif
void aowc_get_exec_time(vpiHandle obj, s_vpi_time *time_p);
int tbx_int_it_chk_config ();

//----------------------------------------------------
// Module: LightUartTransactor

// TCT: export setPollingInterval=setPollingInterval

void
setPollingInterval(
    int newPollingInterval);

// TCT: export setRts=setRts

void
setRts(
    svBit newRts);

// TCT: export getClocksPerBit=getClocksPerBit

 unsigned int
getClocksPerBit();

// TCT: export getPollingInterval=getPollingInterval

 unsigned int
getPollingInterval();

// TCT: export getRts=getRts

 unsigned int
getRts();

// TCT: export tbenchTerminate=tbenchTerminate

int
tbenchTerminate();

// TCT: export putTx=putTx

void
putTx(
    char newTxData);

//----------------------------------------------------
// Module: LightUartTransactor

//----------------------------------------------------
// Module: LightUartTransactor

// HDL-to-C function call: import getbuf=getbuf

extern void
getbuf(
    int obj_index,
    svBitVecVal* stream,
    int* count,
    svBit* eom);

// HDL-to-C function call: import sendRxToXterm=sendRxToXterm

extern void
sendRxToXterm(
    int obj_index,
    char rxData);

// HDL-to-C function call: import xterm_init=xterm_init

extern void
xterm_init(
    int obj_index,
    int term_type,
    const svBitVecVal* obj_name,
    int byte_count);

// HDL-to-C function call: import xterm_transmit_chars=xterm_transmit_chars

extern char
xterm_transmit_chars(
    int obj_index);

// HDL-to-C function call: import billTestIf=billTestIf

extern void
billTestIf(
    int index);

//----------------------------------------------------
// Module: LightUartTransactor


#ifdef __cplusplus
}
#endif

#endif
