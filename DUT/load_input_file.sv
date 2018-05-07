/*******************************************************************************
* Load Input File module - 
*
* Authors: Samuel Jackson (srjackson), Colton Bushey (bushey),
*          Ian Deng (hdeng27), Zuoyi Li (zli482)
* 
* INPUTS:
*   trigger - Tells unit to add data to ram.   
*   clk     - System clock. Assumed to run at 50MHz.
*   rst_n   - ASYNCHRONOUS active-low reset. 
*   data    - Data to be added to ram.
*   addr    - RAM address to fetch  
*
* OUTPUTS:
*   q       - Data at mem position addr.
*   ready   - Signals end of data to send
*******************************************************************************/
module load_input_file(clk, rst_n, q, trigger, data, addr, ready);

  input clk, rst_n, trigger;
  input [7:0] data;
  input [9:0] addr;
 
  output q, ready;
  
  reg we, ready;
  reg [7:0] input_data;
  reg [9:0] cur_addr;

  wire [9:0] ram_addr;
  
  /* State description:
   *    IDLE - The default state. Waiting for new data.
   *    LOAD - Data has been given to load in.
   *    END_LOAD - If all bytes are loaded, turn on ready to end transfer
   */
  typedef enum reg [1:0] {IDLE, LOAD, END_LOAD} state_t;
  state_t state, nxt_state;

  ram #(.DATA_WIDTH(1)
      , .ADDR_WIDTH(10)
      , .INIT_FILE("")) 
      inputStorage(.data(input_data[0]), .addr(ram_addr), .we(we), .clk(clk), .q(q));
      
  assign ram_addr = (state == LOAD ? cur_addr : addr); // Determines control of RAM's address bus.
  
  // Default State Transition Block 
  always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n)
      state <= IDLE;
    else
      state <= nxt_state;
  end

  // Select data to load
  always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n)
      input_data <= 8'hxx;
    else if(state == LOAD)
      input_data <= {1'hx, input_data[7:1]}; // Shift data
    else if(trigger == 1'b1)
      input_data <= data;
  end

  // Increment to next position
  always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n)
      cur_addr <= 10'h0;
    else if(state == LOAD)
      cur_addr <= cur_addr + 10'h1; // Increment address when loading
    else if(cur_addr == 10'h310)   // Address 784 is the last address so reset to 0
      cur_addr <= 10'h0;
  end

  // State Decision Blocks
  always_comb begin
    nxt_state = IDLE;
    ready = 1'b0;
    we = 1'b0;

    case(state)
      IDLE: // default state
        begin
          if(trigger == 1'b1) begin
            nxt_state = LOAD; // Enable state LOAD iff trigger is high to load a byte
          end
        end
      
      LOAD:
        begin
          nxt_state = LOAD; 
          we = 1'b1;                      // Turn on write enable ot send a byte  
          if(cur_addr[2:0] == 4'h7) begin // Indicates start of new byte so Load is ended
            nxt_state = END_LOAD;
          end
        end
      
      END_LOAD:
        begin
          if(cur_addr == 10'h310) // Once all bytes have been transmitted, 
            ready = 1'b1;         // Display "ready" flag
        end
    endcase
  end
endmodule
