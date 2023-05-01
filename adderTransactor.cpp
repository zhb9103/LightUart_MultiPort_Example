/*
  Created by Bill.Zhang in 2023;
*/



#include "adderTransactor.h"
#include "svdpi.h"

// ------------------------------ dpi apis ------------------------------------------------

void dpi_import_function()
{
  printf("import func.\n");
}

extern "C" void dpi_export_function(int test_clk);

// ------------------------------ transactor apis -----------------------------------------

void AdderGetVersion()
{
  printf("Ver:1.0.0\n");
}


class BillTestClass
{
private:



public:
  void TestPrint();


};

void BillTestClass::TestPrint()
{
  printf("BillTestClass.\n");

  svSetScope (svGetScopeFromName ("dut_wrapper.inst"));
  dpi_export_function(10);

}


adder_transactor* adder_transactor::m_pInstance=0;

adder_transactor* adder_transactor::GetInstance()
{
  m_pInstance=new adder_transactor();
  return m_pInstance;
}

void adder_transactor::TestPrint()
{
  pBillTestClass=new BillTestClass();
  pBillTestClass->TestPrint();
  delete pBillTestClass;
 
}



