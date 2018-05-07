/*******************************************************************************
* SNN module - Uses a simple neural network to guess number represented by
*              input data. 
*
* Authors: Samuel Jackson (srjackson), Colton Bushey (bushey),
*          Ian Deng (hdeng27), Zuoyi Li (zli482)
* 
* INPUTS:
*   uart_rx   - Uart signal to transfer in data.
*   clk       - System clock. Assumed to run at 50MH.
*   sys_rst_n - ASYNCHRONOUS active-low reset. 
*
* OUTPUTS:
*   led       - Vector connected to board LEDs showing computation results.
*   uart_tx   - Uart output transmission line.
*******************************************************************************/

module SNN(clk, sys_rst_n, led, uart_tx, uart_rx);
		
	input clk;			        // 50MHz clock
	input sys_rst_n;			  // Unsynched reset from push button. Needs to be synchronized.
	output logic [7:0] led;	// Drives LEDs of DE0 nano board
	
	input uart_rx;
	output uart_tx;

  logic rst_n;				 	  // Synchronized active low reset
	
	logic uart_rx_ff, uart_rx_synch;

	/******************************************************
	Reset synchronizer
	******************************************************/
	rst_synch i_rst_synch(.clk(clk), .sys_rst_n(sys_rst_n), .rst_n(rst_n));
	
	/******************************************************
	UART
	******************************************************/
	
  // UART outputs
  wire rx_rdy;
  wire [7:0] uart_data;

  // Loader outputs
  wire [9:0] addr;
  wire ready, q;

  // Outputs from core
  wire done;
  wire [3:0] digit;

  // Transmitter outputs
  wire tx_ready;
  reg send_trans;
	
	// Double flop RX for meta-stability reasons
	always_ff @(posedge clk, negedge rst_n)
		if (!rst_n) begin
		uart_rx_ff <= 1'b1;
		uart_rx_synch <= 1'b1;
	end else begin
	  uart_rx_ff <= uart_rx;
	  uart_rx_synch <= uart_rx_ff;
	end
	
	
	// Instantiate UART_RX and UART_TX and connect them below
	// For UART_RX, use "uart_rx_synch", which is synchronized, not "uart_rx".

  uart_rx receiver(.clk(clk)
                 , .rst_n(rst_n)
                 , .rx_rdy(rx_rdy)
                 , .rx_data(uart_data)
                 , .rx(uart_rx_synch));

  load_input_file loader(.clk(clk)
                       , .rst_n(rst_n)
                       , .trigger(rx_rdy)
                       , .data(uart_data)
                       , .addr(addr)
                       , .ready(ready)
                       , .q(q));

  snn_core core(.clk(clk)
              , .rst_n(rst_n)
              , .start(ready)
              , .q_input(q)
              , .addr_input_unit(addr)
              , .digit(digit)
              , .done(done));

  uart_tx transmitter(.clk(clk)
                    , .rst_n(rst_n)
                    , .tx_start(send_trans)
                    , .tx_data(led + 8'h30)
                    , .tx_rdy(tx_ready)
                    , .tx(uart_tx));

	/******************************************************
	LED
	******************************************************/
  // assign led = done ? digit : led;
  always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n) 
      led <= 8'h0;
    else if(done)
      led <= {4'h0, digit};
  end

  always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n) 
      send_trans <= 1'b0;
    else
      send_trans <= done;
  end


endmodule
