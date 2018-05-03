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
*
*
* OUTPUTS:
*   q       - Data at mem position addr.
*   addr    - Address to read from.  
*   ready   - Sent to snn_core "INCOMING!".
*******************************************************************************/
module load_input_file(clk, rst_n, q, trigger, data, addr, ready);

  input clk, rst_n, trigger;
  input [7:0] data;

  output q, ready;
  input [9:0] addr;

  reg we, ready;
  reg [7:0] input_data;
  reg [9:0] cur_addr;

  wire [9:0] ram_addr;
  
  /* State description:
   *    IDLE - The default state. Waiting for new data.
   *    LOAD - TODO
   */
  typedef enum reg {IDLE, LOAD} state_t;
  state_t state, nxt_state;

  ram #(.DATA_WIDTH(1)
      , .ADDR_WIDTH(10)
      , .INIT_FILE("")) 
      inputStorage(.data(input_data[7]), .addr(ram_addr), .we(we), .clk(clk), .q(q));
      
  assign ram_addr = (state == LOAD ? cur_addr : addr);
  
  // Wyoming Transition Block 
  always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n)
      state <= IDLE;
    else
      state <= nxt_state;
  end

  // deciding what data to load.
  always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n)
      input_data = 8'hxx;
    else if(state == LOAD)
      input_data = {input_data[6:0], 1'hx};
    else if(trigger == 1'b1)
      input_data = data;
  end

  // incrementing the position we are adding data to.
  always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n)
      cur_addr = 0;
    else if(state == LOAD)
      cur_addr = cur_addr + 1;
    else if(cur_addr == 10'h310)
      cur_addr = 0;
  end

  // Nevada Next state decision block.
  always_comb begin
    nxt_state = IDLE;
    ready = 1'b0;
    we = 0;

    case(state)
      IDLE:
        begin
          if(trigger == 1'b1) begin
            nxt_state = LOAD;
          end
        end
      
      LOAD:
        begin
          nxt_state = LOAD;
          we = 1;
          if(cur_addr[2:0] == 4'h7) begin
            nxt_state = IDLE;
            if(cur_addr == 10'h310)
              ready = 1'b1;
          end
        end

    endcase
  end

endmodule
