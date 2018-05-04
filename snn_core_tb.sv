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
  wire [9:0] addr;
  wire [3:0] digit;
  wire done;
  
  // Variables used for testing
  wire q1, q2, q3, q4, q5, q6, q7, q8, q9, q0;

  reg data;
  reg we;
  reg[4:0] data_select;
  
  assign q_input = data_select == 0 ? q0 :
                   data_select == 1 ? q1 :
                   data_select == 2 ? q2 :
                   data_select == 3 ? q3 :
                   data_select == 4 ? q4 :
                   data_select == 5 ? q5 :
                   data_select == 6 ? q6 :
                   data_select == 7 ? q7 :
                   data_select == 8 ? q8 :
                                      q9 ;

  snn_core iDUT(.clk(clk)
              , .rst_n(rst_n)
              , .q_input(q_input)
              , .start(start)
              , .done(done)
              , .addr_input_unit(addr)
              , .digit(digit));


    ram #(.DATA_WIDTH(1)
        , .ADDR_WIDTH(10)
        , .INIT_FILE("input_samples/ram_input_contents_sample_0.txt"))
        number_input0(.data(data)
                    , .addr(addr)
                    , .we(we)
                    , .clk(clk)
                    , .q(q0));
                    
    ram #(.DATA_WIDTH(1)
        , .ADDR_WIDTH(10)
        , .INIT_FILE("input_samples/ram_input_contents_sample_1.txt"))
        number_input1(.data(data)
                    , .addr(addr)
                    , .we(we)
                    , .clk(clk)
                    , .q(q1));

    ram #(.DATA_WIDTH(1)
        , .ADDR_WIDTH(10)
        , .INIT_FILE("input_samples/ram_input_contents_sample_2.txt"))
        number_input2(.data(data)
                    , .addr(addr)
                    , .we(we)
                    , .clk(clk)
                    , .q(q2));
   
    ram #(.DATA_WIDTH(1)
        , .ADDR_WIDTH(10)
        , .INIT_FILE("input_samples/ram_input_contents_sample_3.txt"))
        number_input3(.data(data)
                    , .addr(addr)
                    , .we(we)
                    , .clk(clk)
                    , .q(q3));
   
    ram #(.DATA_WIDTH(1)
        , .ADDR_WIDTH(10)
        , .INIT_FILE("input_samples/ram_input_contents_sample_4.txt"))
        number_input4(.data(data)
                    , .addr(addr)
                    , .we(we)
                    , .clk(clk)
                    , .q(q4));
   
    ram #(.DATA_WIDTH(1)
        , .ADDR_WIDTH(10)
        , .INIT_FILE("input_samples/ram_input_contents_sample_5.txt"))
        number_input5(.data(data)
                    , .addr(addr)
                    , .we(we)
                    , .clk(clk)
                    , .q (q5));

    ram #(.DATA_WIDTH(1)
        , .ADDR_WIDTH(10)
        , .INIT_FILE("input_samples/ram_input_contents_sample_6.txt"))
        number_input6(.data(data)
                    , .addr(addr)
                    , .we(we)
                    , .clk(clk)
                    , .q(q6));

    ram #(.DATA_WIDTH(1)
        , .ADDR_WIDTH(10)
        , .INIT_FILE("input_samples/ram_input_contents_sample_7.txt"))
        number_input7(.data(data)
                    , .addr(addr)
                    , .we(we)
                    , .clk(clk)
                    , .q (q7));

    ram #(.DATA_WIDTH(1)
        , .ADDR_WIDTH(10)
        , .INIT_FILE("input_samples/ram_input_contents_sample_8.txt"))
        number_input8(.data(data)
                    , .addr(addr)
                    , .we(we)
                    , .clk(clk)
                    , .q(q8));

    ram #(.DATA_WIDTH(1)
        , .ADDR_WIDTH(10)
        , .INIT_FILE("input_samples/ram_input_contents_sample_9.txt"))
        number_input9(.data(data)
                    , .addr(addr)
                    , .we(we)
                    , .clk(clk)
                    , .q(q9));
    

  // Task to properly set up tests
  task initialize;
    clk = 0;
    rst_n = 0;
    start = 0;
    we = 0;
    data = 0;
    @(posedge clk);
    
    rst_n = 1;
  endtask;
  
  
  // hextoa stirng to int
  
  initial begin
    initialize();
    for(data_select = 0; data_select < 10; data_select++) begin
        
      start = 1'b1;
      @(posedge clk);
      start = 1'b0;
      
      fork 
        begin: NORMAL_CASE
          @(posedge done);
          $display("Value recieved. Input: %h\tReturned: %h\n", data_select, digit);
          disable TIMEOUT;
        end

        begin: TIMEOUT
          repeat(60000) @(posedge clk);
          $display("FAILED :: Test timeout for test #%d.", data_select);
          $stop;
        end
      join
    end
    $stop;
  end 
  
  
  always
    #5 clk = ~clk;

endmodule
