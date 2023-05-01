
/*
  Created by Bill.Zhang in 2023;
*/

module adder(clk,rst_n,a,b,c);

  // import the dpi-c function;
  import "DPI-C" context function void dpi_import_function();
  // export the dpi-c function;
  export "DPI-C" task dpi_export_function;

  input wire[3:0] a,b;
  output reg[7:0] c;

  input clk,rst_n;

  always@(posedge clk or negedge rst_n) begin

  if(rst_n==1'b0)
    c<=8'b0;
  else
    c<=a+b;

  end

  task dpi_export_function(input int test_clk);
    @(posedge clk)
    begin
      $display("export func.\n");
  
    end
  endtask



endmodule



