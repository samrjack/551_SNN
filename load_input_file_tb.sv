/******************************************************************************* 
* LOAD_INPUT_FILE_TB
*
* Authors: Samuel Jackson (srjackson), Colton Bushey (bushey),
*          Ian Deng (hdeng27), Zuoyi Li (zli482)
************************************************************/
module load_input_file_tb();

  // Variables used in DUTs
  reg clk, rst_n, trigger;
  reg [7:0] data;
  reg [7:0] sent_data;
  int i;
  // Variables used for testing
  wire q, ready;

  wire [9:0] addr;

  localparam BAUD = 12'hA2D;
  load_input_file iDUT(.clk(clk)
                     , .rst_n(rst_n)
                     , .q(q)
                     , .trigger(trigger)
                     , .data(data)
                     , .addr(addr)
                     , .ready(ready));


  task initialize;
    clk = 0;
    rst_n = 0;
    trigger = 0;
    data = 8'h00;
    sent_data = 0;
    i = 0;
    @(posedge clk);
    rst_n = 1;
  endtask

  task transmit;
    input [7:0] data_test;
    begin
      data = data_test;
      trigger = 1;
      @(posedge clk);
      trigger = 0;
      data = 8'h00;
      @(posedge(clk));


      // Send signal with no trigger
      fork
        begin: receive
          repeat(BAUD >> 1) @(posedge clk);
          for(i = 0; i < 7; i = i + 1) begin
            sent_data[i] = addr;
            repeat(BAUD) @(posedge clk);
          end
          sent_data[7] = data[7];
          disable ready_check;
        end

        begin: ready_check
          if(trigger == 1) begin
            $display("ERROR :: TX_RDY never deasserted before sending signal\n");
            $stop;
          end
          @(posedge trigger);
          $display("ERROR :: TX_RDY asserted while still sending signal\n");
          $stop;
        end
      join
     
      // Make sure ready goes high
      fork
        begin: wait_for_ready
          @(posedge ready);
          disable ready_timeout;
        end
        
        begin: ready_timeout
          repeat(BAUD) @(posedge clk);
          $display("ERROR :: READY never asserted after signal fully sent\n");
          $stop;
        end
      join
      
      // Check that the correct address is passed
      
	

      // Check that the data transferred is correct
      if(sent_data == data) begin
       $display("PASSED :: Data  correctly sent. Expected: %h\tReceived: %h\n",  data, sent_data);
      end else begin
       $display("ERROR :: Data incorrectly sent. Expected: %h\tReceived: %h\n", {1'h1, data, 1'h0}, sent_data);
        $stop;
      end
    end // End of task block
  endtask

  //Main logic block
  initial begin
    initialize();

    transmit(8'hFF);
    repeat(BAUD) @(posedge clk);

    $stop;
  end

  //Clock
  always 
    #5 clk = ~clk;
  endmodule
