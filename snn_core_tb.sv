/*******************************************************************************
* SNN_CORE_TB
* 
* Authors: Samuel Jackson (srjackson), Colton Bushey (bushey),
*          Ian Deng (hdeng27), Zuoyi Li (zli482)
*******************************************************************************/
module snn_core_tb();

  // Variables used in DUTs
  reg clk, rst_n;
  reg start;
  wire q_input[9:0];
  logic [9:0] addr_input_unit[9:0];
  wire [3:0] digit;
  wire done;
  
  // Variables used for testing
  reg pixel;
  reg [639:0] err_str;
  reg [1023:0] file_line;
  string filename;
  genvar i;
  
  reg data;
  reg we;
  integer addr_select;
  
  snn_core iDUT(.clk(clk)
              , .rst_n(rst_n)
              , .q_input(q_input[addr_select])
              , .start(start)
              , .done(done)
              , .addr_input_unit(addr_input_unit[addr_select])
              , .digit(digit));
  
  generate 
    for(i = 0; i < 10; i = i+1) begin: INPUT_RAM_INIT
      ram #(.DATA_WIDTH(1)
          , .ADDR_WIDTH(10)
          , .INIT_FILE($sformatf("input_samples/ram_input_contents_sample_%d.txt", i)))
          number_input(.data(data)
                     , .addr(addr_input_unit[i])
                     , .we(we)
                     , .clk(clk)
                     , .q(q_input[i]));
    end
  endgenerate

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
    for(addr_select = 0; addr_select < 10; addr_select++) begin
        
      start = 1'b1;
      @(posedge clk);
      start = 1'b0;
      
      @(posedge done);
      if(digit == addr_select)
        $display("Passed test\n");
      else
        $display("Failed Test\n");
        
    end
    $stop;
  end 
  
  
  always
    #5 clk = ~clk;

endmodule
