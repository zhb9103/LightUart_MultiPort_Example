

#ifndef __ADDER_TRANSACTOR_H__
/*
  Created by Bill.Zhang in 2023;
*/

#define __ADDER_TRANSACTOR_H__

#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include <iostream>




extern "C"
{
  void AdderGetVersion();
  
}


class BillTestClass;

class adder_transactor
{

private:



public:
  BillTestClass* pBillTestClass;


public:
  static adder_transactor* GetInstance();
  static adder_transactor* m_pInstance;
  void TestPrint();

};



#endif



