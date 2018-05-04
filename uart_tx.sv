/*******************************************************************************
* UART_TX module - Sends UART packet.
*
* Authors: Samuel Jackson (srjackson), Colton Bushey (bushey),
*          Ian Deng (hdeng27), Zuoyi Li (zli482)
*          
* 
* INPUTS:
*   tx_start - Signal to start sending data over tx.
*   tx_data  - Data to send over tx. can change after tx_start goes low.
*   clk      - System timing clock. Assumed to run at 50MH.
*   rst_n    - ASYNCHRONOUS active-low reset.
*
* OUTPUTS:
*   tx       - Line to send UART packet over.
*   tx_rdy   - High when avaliable to send new packet.
*******************************************************************************/

module uart_tx(tx_start, tx_data, clk, rst_n, tx_rdy, tx);
  input tx_start, clk, rst_n;
  input [7:0] tx_data;  // Data to be sent through width 1 tx channel
  output tx_rdy, tx;    
  
  // Reg for inside always_comb
  reg [11:0] bd_cnt;
  reg [9:0] saved_data;
  reg [3:0] tx_cnt;     // Count 10 bit of data sent in total (data and start end
  reg transmit;            // To signify transmitfering a bit of data
  reg clr_bd, clr_tx;   // To reset the counters
  reg tx_rdy;
  wire full_bd, tx_full;

  /* State description:
   *   IDLE: not transmitmitting data
   *   TX: transmitmitting data
   */
  typedef enum reg {IDLE, TX} state_t;
  state_t state, nxt_state;

  // Default baud time : 19200 bits/sec 
  localparam BAUD_TIME = 12'hA2C;  //2604 A2C
  localparam NUM_BITS_TO_SEND = 4'hA; // sending a total of 10 bits.

  // Minus 1 so that full_bd is high on full cycle, not following cycle
  assign full_bd = (bd_cnt == BAUD_TIME - 1);
  assign tx_full = (tx_cnt == NUM_BITS_TO_SEND - 1);

  assign tx = (state == IDLE ? 1'b1 : saved_data[0]);

  // BAUD COUNTER FOR BAUD
  always_ff @(posedge clk, negedge rst_n) 
    if (!rst_n) 
      bd_cnt <= 12'b0;
    else 
      if (clr_bd)
       bd_cnt <= 12'b0;
     else 
       bd_cnt <= bd_cnt + 12'h1;

  //LOAD Saved Data
  always_ff @(posedge clk, negedge rst_n)
    if(!rst_n)
      saved_data <= 10'hxx;
    else 
      if (tx_start && state == IDLE)
        saved_data <= {1'h1, tx_data, 1'h0};
      else if (transmit)
        saved_data <= {1'bx, saved_data[9:1]};

  // TX Counter And Tx Shift
  always_ff @(posedge clk, negedge rst_n) 
    if (!rst_n)
      tx_cnt <= 4'b0; 
    else 
      if (clr_tx)
        tx_cnt <= 4'b0;
      else if (transmit)
        tx_cnt <= tx_cnt + 4'h1;

  // FSM LOGIC
  always_ff @(posedge clk, negedge rst_n)
    if (!rst_n)
      state <= IDLE;
    else
      state <= nxt_state;

  // State Transition Logic
  always_comb begin
    // DEFAULT SIGNALS
    nxt_state = IDLE;
    clr_bd = 1'b1;  // keep counter at 0
    clr_tx = 1'b1;  // not count while default
    transmit = 1'b0;
    tx_rdy = 1'b1;
    
    case(state)
      IDLE: begin
        if(tx_start) begin
          clr_bd = 1'b0;
          nxt_state = TX;
        end
      end
      
      TX: begin
        clr_tx = 1'b0;
        tx_rdy = 1'b0;
        clr_bd = 1'b0;
        nxt_state = TX;
        if(full_bd) begin
          clr_bd = 1;
          transmit = 1'b1;
          if(tx_full) begin 
            nxt_state = IDLE;
            transmit = 1'b0;
          end 
        end 
      end  
    endcase
  end

endmodule
