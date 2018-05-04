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
  
  // Variables used for testing
  wire q, ready;

  reg [9:0] addr;

  localparam BAUD = 12'hA2D;
  load_input_file iDUT(.clk(clk)
                     , .rst_n(rst_n)
                     , .q(q)
                     , .trigger(trigger)
                     , .data(data)
                     , .addr(addr)
                     , .ready(ready));


  task initialize;
    addr = 0;
    clk = 0;
    rst_n = 0;
    trigger = 0;
    data = 8'h00;
    sent_data = 0;
    @(posedge clk);
    rst_n = 1; // Initial trigger of reset
  endtask

  task transmit;
    input [7:0] data_test;
    begin: TRANSMIT_TASK
      begin: LOAD_LOOP
        for(addr = 0; addr < 100; addr++) begin
          fork
            begin: LOAD_DATA   // Increment through all addresses, toggling trigger until "ready" received
              data = data_test;
              trigger = 1;
              @(posedge clk);
              trigger = 0;
              data = 8'h00;
              repeat(50) @(posedge(clk));
              disable READY_CHECK;
            end

            begin: READY_CHECK
              if(ready == 1) begin  // Premature ready flag
                $display("ERROR :: READY asserted in middle of transmission at #%d.\n", addr);
                $stop;
              end

              @(posedge ready)
              
              if(addr != 97) begin // Ready flag at incorrect time
                $display("ERROR :: READY asserted at time %d.\n", addr);
                $stop;
              end

              $display("PASSED :: Loaded all data.\n"); // Success condition
              disable LOAD_DATA;
              disable LOAD_LOOP;
            end
          join
    
        end // For loop end
      end // For loop break point

      if(ready != 1) begin      // Ready flag fails to assert after all data sent
        $display("ERROR :: All data sent but READY never asserted.\n");
        $stop;
      end

      addr = 0;

      // Check that the correct address is passed
      data = data_test;      
      for(addr = 0; addr < 10'd784; addr++) begin: CHECK_DATA_LOOP // Increment through all 784 address positions
        @(posedge clk);
        #1; // Give q's non-blocking assignment time to propogate through
        if(q != data[0]) begin // Checks if data and q aren't the same and displays error as such
          $display("ERROR :: Values not matching. Addr = %d\tq = %d\tdata[0] = %d.\n", addr, q, data[0]);
          $stop;
        end
        data = {data[0], data[7:1]}; // Shifting of data to the front
      end

      // End data check for loop
      $display("PASSED :: Data  correctly sent.\n");
    end // End of task block
  endtask

  //Main logic block
  initial begin
    initialize();
    // Testing of different transmitted files      
    transmit(8'hFF);
    repeat(BAUD) @(posedge clk);
    
    transmit(8'h00);
    repeat(BAUD) @(posedge clk);

    transmit(8'b10011001);
    repeat(BAUD) @(posedge clk);

    transmit(8'b11000011);
    repeat(BAUD) @(posedge clk);

    transmit(8'b10010011);
    repeat(BAUD) @(posedge clk);

    $stop;
  end

  //Clock
  always 
    #5 clk = ~clk;

endmodule

