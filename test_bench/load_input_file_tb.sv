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

  load_input_file iDUT(.clk(clk)
                     , .rst_n(rst_n)
                     , .q(q)
                     , .trigger(trigger)
                     , .data(data)
                     , .addr(addr)
                     , .ready(ready));


  task initialize;
    addr = 10'h0;
    clk = 1'b0;
    rst_n = 1'b0;
    trigger = 1'b0;
    data = 8'h00;
    sent_data = 8'h0;
    @(posedge clk);
    rst_n = 1'b1; // Initial trigger of reset
  endtask

  // By taking in a byte of data and transimitting it many times, should be
  // able to fill up the ram and then check it. Although random non-repeating
  // bytes would be best, this test is magnitudes easier and should highly
  // corrolate with actual functionality and will catch most bugs.
  task transmit;
    input [7:0] data_test;
    begin: TRANSMIT_TASK
      begin: LOAD_LOOP
        // Sends too many packets to check that ready is asserted at the
        // appropriate point.
        for(addr = 10'h0; addr < 10'd100; addr++) begin
          fork
            begin: LOAD_DATA   // Increment through all addresses, toggling trigger until "ready" received
              data = data_test;
              trigger = 1'b1;
              @(posedge clk);
              trigger = 1'b0;
              data = 8'h00;
              repeat(50) @(posedge(clk)); // Should be one baud cycle, but 50 should allow for pleanty of time.
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

      if(ready != 1) begin // Ready flag fails to assert after all data sent
        $display("ERROR :: All data sent but READY never asserted.\n");
        $stop;
      end

      addr = 10'h0; // Reseted to prevent unknown values in the tb.

      // Check that the correct address is passed
      data = data_test;      
      for(addr = 10'h0; addr < 10'd784; addr++) begin: CHECK_DATA_LOOP // Increment through all 784 address positions
        @(posedge clk);
        @(negedge clk); // Give q's non-blocking assignment time to propogate through due to nonblocking assignments
        if(q != data[0]) begin // Checks if data and q aren't the same and displays error as such
          $display("ERROR :: Values not matching. Addr = %d\tq = %d\tdata[0] = %d.\n", addr, q, data[0]);
          $stop;
        end
        data = {data[0], data[7:1]}; // Shifting of data to the front
      end

      // End data check for loop
      $display("PASSED :: Data %b correctly sent.\n", data_test);
    end // End of task block
  endtask

  //Main logic block
  initial begin
    initialize();
    // Testing of different transmitted files      
    transmit(8'hFF);
    repeat(300) @(posedge clk);
    
    transmit(8'h00);
    repeat(300) @(posedge clk);

    transmit(8'b10011001);
    repeat(300) @(posedge clk);

    transmit(8'b11000011);
    repeat(300) @(posedge clk);

    transmit(8'b10010011);
    repeat(300) @(posedge clk);

    $stop;
  end

  //Clock
  always 
    #5 clk = ~clk;

endmodule

