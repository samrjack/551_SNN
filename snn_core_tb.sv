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
  wire q_input;
  logic [9:0] addr_input_unit;
  wire [3:0] digit;
  wire done;
  
  // Variables used for testing
  integer i, j, file_handle, num_matches;
  reg pixel;
  reg [639:0] err_str;
  reg [1023:0] file_line;
  string filename;
  
  reg data;
  reg we;
  
  
  
  snn_core iDUT(.clk(clk), .rst_n(rst_n), .q_input(q_input), .start(start), .done(done), .addr_input_unit(addr_input_unit), .digit(digit));
  
  // COLTON, place in proper parameters later.
  ram number_input(.data(data), .addr(addr_input_unit), .we(we), .clk(clk), .q(q_input));
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
    for(i = 0; i < 10; i++) begin
      $sformat(filename, "input_samples/ram_input_contents_sample_%d.txt", i);
      file_handle = $fopen(filename,"r");
      error = $ferror(file_handle,err_str);
      if(error == 0) begin
        num_matches = 0;
        
        // Moves file pointer forward 32 lines to get past the picture.
        for(j = 0; j < 32; j++) begin
          $fgets(file_line, 1024, file_handle);
        end
        
        for(j = 0; j < 28*28; j++) begin
          $fscanf(file_handle, "%b\n", pixel);
          addr_input_unit = j;
          data = pixel;
          @(posedge clk);
        end
        
        start = 1'b1;
        @(posedge clk);
        start = 1'b0;
        
        @(posedge done);
        if(digit == j)
          $display("Passed test\n");
        else
          $display("Failed Test\n");
        
      end else begin
        $display("Error reading file\n");
      end
        
    end
    $stop;
  end 
  
  
  always
    #5 clk = ~clk;

endmodule