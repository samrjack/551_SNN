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
  wire [9:0] addr;
  wire [3:0] digit;
  wire done;
  
  // Variables used for testing
  reg pixel;
  reg [639:0] err_str;
  reg [1023:0] file_line;
  string filename;
  
  wire [9:0] addr0, addr1, addr2, addr3, addr4, addr5, addr6, addr7, addr8, addr9;

  reg data;
  reg we;
  integer addr_select;
  
  assign addr = addr_select == 0 ? addr0 :
                addr_select == 1 ? addr1 :
                addr_select == 2 ? addr2 :
                addr_select == 3 ? addr3 :
                addr_select == 4 ? addr4 :
                addr_select == 5 ? addr5 :
                addr_select == 6 ? addr6 :
                addr_select == 7 ? addr7 :
                addr_select == 8 ? addr8 :
                                   addr9 ;



  snn_core iDUT(.clk(clk)
              , .rst_n(rst_n)
              , .q_input(q_input[addr_select])
              , .start(start)
              , .done(done)
              , .addr_input_unit(addr)
              , .digit(digit));


    ram #(.DATA_WIDTH(1)
        , .ADDR_WIDTH(10)
        , .INIT_FILE("input_samples/ram_input_contents_sample_0.txt"))
        number_input0(.data(data)
                    , .addr(addr0)
                    , .we(we)
                    , .clk(clk)
                    , .q(q_input[0]));
                    
    ram #(.DATA_WIDTH(1)
        , .ADDR_WIDTH(10)
        , .INIT_FILE("input_samples/ram_input_contents_sample_1.txt"))
        number_input1(.data(data)
                    , .addr(addr1)
                    , .we(we)
                    , .clk(clk)
                    , .q(q_input[1]));

    ram #(.DATA_WIDTH(1)
        , .ADDR_WIDTH(10)
        , .INIT_FILE("input_samples/ram_input_contents_sample_2.txt"))
        number_input2(.data(data)
                    , .addr(addr2)
                    , .we(we)
                    , .clk(clk)
                    , .q(q_input[2]));
   
    ram #(.DATA_WIDTH(1)
        , .ADDR_WIDTH(10 )
        , .INIT_FILE("input_samples/ram_input_contents_sample_3.txt"))
        number_input3(.data(data)
                    , .addr(addr3)
                    , .we(we)
                    , .clk(clk)
                    , .q(q_input[3]));
   
    ram #(.DATA_WIDTH(1)
        , .ADDR_WIDTH(10 )
        , .INIT_FILE("input_samples/ram_input_contents_sample_4.txt"))
        number_input4(.data(data)
                    , .addr(addr4)
                    , .we(we)
                    , .clk(clk)
                    , .q(q_input[4]));
   
    ram #(.DATA_WIDTH(1)
        , .ADDR_WIDTH(10)
        , .INIT_FILE("input_samples/ram_input_contents_sample_5.txt"))
        number_input5(.data(data)
                    , .addr(addr5)
                    , .we(we)
                    , .clk(clk)
                    , .q (q_input[5]));

    ram #(.DATA_WIDTH(1)
        , .ADDR_WIDTH(10 )
        , .INIT_FILE("input_samples/ram_input_contents_sample_6.txt"))
        number_input6(.data(data)
                    , .addr(addr6)
                    , .we(we)
                    , .clk(clk)
                    , .q(q_input[6]));

    ram #(.DATA_WIDTH(1)
        , .ADDR_WIDTH(10)
        , .INIT_FILE("input_samples/ram_input_contents_sample_7.txt"))
        number_input7(.data(data)
                    , .addr(addr7)
                    , .we(we)
                    , .clk(clk)
                    , .q (q_input[7]));

    ram #(.DATA_WIDTH(1)
        , .ADDR_WIDTH(10)
        , .INIT_FILE("input_samples/ram_input_contents_sample_8.txt"))
        number_input8(.data(data)
                    , .addr(addr8)
                    , .we(we)
                    , .clk(clk)
                    , .q(q_input[8]));

    ram #(.DATA_WIDTH(1)
        , .ADDR_WIDTH(10 )
        , .INIT_FILE("input_samples/ram_input_contents_sample_9.txt"))
        number_input9(.data(data)
                    , .addr(addr9)
                    , .we(we)
                    , .clk(clk)
                    , .q(q_input[9]));
    

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
      
      fork 
        begin: NORMAL_CASE
          @(posedge done);
          if(digit == addr_select)
            $display("Passed test #%d.\n", addr_select);
          else
            $display("Failed Test #%d: output %d.\n", addr_select, digit);
          disable TIMEOUT;
        end

        begin: TIMEOUT
          repeat(60000) @(posedge clk);
          $display("FAILED :: Test timeout for test #%d.", addr_select);
          $stop;
        end
      join
    end
    $stop;
  end 
  
  
  always
    #5 clk = ~clk;

endmodule
