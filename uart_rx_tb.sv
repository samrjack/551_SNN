/*******************************************************************************
* UART_RX_TB
* 
* Authors: Samuel Jackson (srjackson), Colton Bushey (bushey),
*          Ian Deng (hdeng27), Zuoyi Li (zli482)
*******************************************************************************/
module uart_rx_tb();

  reg rx, clk, rst_n;
  wire rx_rdy;
  wire [7:0] rx_data;
  reg [7:0] ex_data;
  reg [3:0] counter;

  uart_rx iDUT(.rx(rx), .clk(clk), .rst_n(rst_n), .rx_rdy(rx_rdy), .rx_data(rx_data));  

  // Task submits a 10 bit signal and checks for expected outputs
  task submit_data;
    input [9:0] data; 

    // send data out and make sure no premature output is given
    fork
      // Transmit data on rx line.
      begin : submit
        for(counter = 4'd0; counter < 4'd10; counter = counter + 1) begin
          rx = data[counter];
          repeat(12'hA2D) @(posedge clk);
        end
        disable submit_stopper;
      end

      // Make sure RX_ready isn't asserted while still transmitting data
      begin : submit_stopper
        @(posedge rx_rdy)
        $error("ERROR :: RX_READY signal asserted before ready. UART signal: %h\n", data);
        $stop;
      end
    join

    rx = 1;

    // Check for proper output
    fork
      begin : wait_rx_ready
        @(posedge rx_rdy);
        disable timeout_rx_ready;
        if(data[0] == 1'h0 && data[9] == 1'h1) begin
          if(rx_data == ex_data)
            $display("PASSED :: Expected: %h\tRecieved: %h\n", ex_data, rx_data);
          else begin
            $display("ERROR :: Incorrect value recieved. Expected: %h\tRecieved: %h\n", ex_data, rx_data);
            $stop;
          end
        end 
        else begin
          $display("ERROR :: RX_READY signal asserted for invalid UART signal: %h\n", data);
          $stop;
        end
      end
       
      begin : timeout_rx_ready
        repeat(100) @(posedge clk);
        disable wait_rx_ready;
        if(data[0] == 1'h0 && data[9] == 1'h1) begin
          $display("ERROR :: RX_READY not asserted after a valid UART signal was sent. signal: %h\n", data);
          $stop;
        end
        else begin
          $display ("PASSED :: RX_READY not asserted for invalid UART signal.\n");
        end
      end
    join
  endtask

  // Task to properly set up tests
  task initialize;
    clk = 0;
    rx = 1;
    rst_n = 0;

    @(posedge clk);

    rst_n = 1;
  endtask;

  // Main control block
  initial begin
    initialize();

    // Test symetric data
    ex_data = 8'hA5;
    submit_data({1'b1, ex_data, 1'b0});
    repeat(12'hA2D) @(posedge clk);

    ex_data = 8'hE7;
    submit_data({1'b1, ex_data, 1'b0});
    repeat(12'hA2D) @(posedge clk);

    // Test asymetric data
    ex_data = 8'h24;
    submit_data({1'b1, ex_data, 1'b0});
    repeat(12'hA2D) @(posedge clk);

    ex_data = 8'h01;
    submit_data({1'b1, ex_data, 1'b0});
    repeat(12'hA2D) @(posedge clk);

    repeat(12'hA2D >> 2) @(posedge clk);
    $stop;
  end
  
  always
    #5 clk = ~clk;

endmodule

