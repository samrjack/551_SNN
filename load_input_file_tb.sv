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
    begin: TRANSMIT_TASK
      for(i = 0; i < 98; i = i + 1) begin: LOAD_LOOP
        // TODO Comment here
        fork
          begin: LOAD_DATA
            data = data_test;
            trigger = 1;
            @(posedge clk);
            trigger = 0;
            data = 8'h00;
            repeat(50) @(posedge(clk));
            disable READY_CHECK;
          end

          begin: READY_CHECK
            if(ready == 1) begin
              $display("ERROR :: READY asserted in middle of transmittion.\n");
              $stop;
            end

            @(posedge ready)
            
            if(i != 97) begin
              $display("ERROR :: READY asserted too early.\n");
              $stop;
            end

            $display("PASSED :: Loaded all data.\n");
            disable LOAD_DATA;
            disable LOAD_LOOP;
   
        end // For loop end

      if(ready != 1) begin
        $display("ERROR :: All data sent but READY never asserted.\n");
        $stop;
      end

      // Check that the correct address is passed
      
      data = data_test;      
      for(addr = 0; addr < 10'd784; addr = addr + 1) begin: CHECK_DATA_LOOP
        @(posedge clk);
        if(q != data[0]) begin
          $display("ERROR :: Values not matching. Addr = %d\tq = %d\tdata[0] = %d.\n", addr, q, data[0]);
          $stop;
        end
        data = {data[0], data[7:1]};
      end

    join
 // End data check for loop

      $display("PASSED :: Data  correctly sent.\n");
     end
     // End of task block
  end
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

