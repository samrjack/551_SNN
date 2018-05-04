/*******************************************************************************
* UART_TX_TB
* 
* Authors: Samuel Jackson (srjackson), Colton Bushey (bushey)
*          Ian Deng (hdeng27), Zuoyi Li (zli482)
*******************************************************************************/
module uart_tx_tb();

  // Variable declaration
  wire tx_rdy, tx;
  reg clk, rst_n, tx_start;
  reg [7:0] tx_data;
  reg [9:0] sent_data;
  int i;

  localparam BAUD = 12'hA2D;

  /* Structural Verilog */
  uart_tx iDUT(.tx_start(tx_start), .tx_data(tx_data), .clk(clk), .rst_n(rst_n), .tx_rdy(tx_rdy), .tx(tx));

  /* Dataflow Verilog */


  /* Behavioral Verilog */
  // tasks
  task initialize;
    clk = 0;
    rst_n = 0;
    tx_start = 0;
    tx_data = 0;
    sent_data = 0;
    i = 0;
    @(posedge clk);
    rst_n = 1;
  endtask

  task transmit;
    input [7:0] data;
    begin
      tx_data = data;
      tx_start = 1;
      @(posedge clk);
      tx_start = 0;
      tx_data = 8'h00;
      @(posedge(clk));

      // Send signal with no tx_rdy
      fork
        begin: receive
          repeat(BAUD >> 1) @(posedge clk);
          for(i = 0; i < 9; i = i + 1) begin
            sent_data[i] = tx;
            repeat(BAUD) @(posedge clk);
          end
          sent_data[9] = tx;
          disable ready_check;
        end

        begin: ready_check
          if(tx_rdy == 1) begin
            $display("ERROR :: TX_RDY never deasserted before sending signal\n");
            $stop;
          end
          @(posedge tx_rdy);
          $display("ERROR :: TX_RDY asserted while still sending signal\n");
          $stop;
        end
      join

      // Make sure tx_rdy goes high
      fork
        begin: wait_for_tx_rdy
          @(posedge tx_rdy);
          disable tx_rdy_timeout;
        end

        begin: tx_rdy_timeout
          repeat(BAUD) @(posedge clk);
          $display("ERROR :: TX_RDY never asserted after signal fully sent\n");
          $stop;
        end
      join

      // Check that sent data is correct
      if(sent_data == {1'h1, data, 1'h0}) begin
        $display("PASSED :: Data correctly sent. Expected: %h\tReceived: %h\n", {1'h1, data, 1'h0}, sent_data);
      end else begin
        $display("ERROR :: Data incorrectly sent. Expected: %h\tReceived: %h\n", {1'h1, data, 1'h0}, sent_data);
        $stop;
      end
    end // End of task block
  endtask

  // Main logic block
  initial begin
    initialize();

    transmit(8'hFF);
    repeat(BAUD) @(posedge clk);

    transmit(8'h01);
    repeat(BAUD) @(posedge clk);

    transmit(8'hBE);
    repeat(BAUD) @(posedge clk);

    transmit(8'h3C);
    repeat(BAUD) @(posedge clk);

    $stop;
  end

  // Clock
  always
    #5 clk = ~clk;
endmodule
