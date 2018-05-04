/*******************************************************************************
* SNN_CORE_TB
* 
* Authors: Samuel Jackson (srjackson), Colton Bushey (bushey),
*          Ian Deng (hdeng27), Zuoyi Li (zli482)
*******************************************************************************/
module snn_core_tb2();

  // Variables used in DUTs
  reg clk, rst_n;
  reg start;
  wire q_input;
  logic [9:0] addr_input_unit;
  wire [3:0] digit;
  wire done;
  
  snn_core iDUT(.clk(clk)
              , .rst_n(rst_n)
              , .q_input(q_input)
              , .start(start)
              , .done(done)
              , .addr_input_unit(addr_input_unit)
              , .digit(digit));
  
 
	 rom_input_unit number_input(.addr(addr_input_unit), .clk(clk), .q(q_input)); 


  // Task to properly set up tests
  task initialize;
    clk = 0;
    rst_n = 0;
    start = 0;
    @(posedge clk);
    
    rst_n = 1;
  endtask;
  
  
  // hextoa stirng to int
  
  initial begin
    initialize();
   // for(addr_select = 0; addr_select < 10; addr_select++) begin
        
      start = 1'b1;
      @(posedge clk);
      start = 1'b0;
      
      @(posedge done);
     $display("digit = %d", digit);
        
		10 @(posedge clk);
   // end
    $stop;
  end 
  
  
  always
    #5 clk = ~clk;

endmodule

