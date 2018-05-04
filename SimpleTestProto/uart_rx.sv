/*******************************************************************************
* UART_RX module - Recieves UART packet.
*
* Authors: Samuel Jackson (srjackson), Colton Bushey (bushey),
*          Ian Deng (hdeng27), Zuoyi Li (zli482)
* 
* INPUTS:
*   rx      - Input bit stream. Should be connected to a UART compliant
*             signal.
*   clk     - System clock. Assumed to run at 50MH.
*   rst_n   - ASYNCHRONOUS active-low reset. 
*
* OUTPUTS:
*   rx_rdy  - Goes high when rx_data holds a recieved byte.
*   rx_data - 8-bit data packet recieved over rx line.
*******************************************************************************/
module uart_rx(rx, clk, rst_n, rx_rdy, rx_data);

  input rx, clk, rst_n;
  output rx_rdy;
  output [7:0] rx_data;

  /* State description:
   *    IDLE  - The default state. Waiting for new data.
   *    CHECK - Checking for valid start bit. Measures middle of start bit for
   *                low bit.
   *    REC   - Recording input data from rx line.
   *    END   - Delays until end of end bit then returns to IDLE.
   */
  typedef enum reg[1:0]{IDLE,CHECK, REC, END} state_t;
  state_t state, nxt_state;

  // Default baud time - 19200 bits/sec 
  localparam BAUD_TIME = 12'hA2D;

  wire half, full;

  reg        rx_rdy;            
  reg        all_data_recieved; // Signals when last bit (stop bit) is being read
  reg        baud_clr;          // Clears baud counter
  reg        shift_clr;         // Clears shift counter
  reg  [2:0] shift_count;       // Counts number of data bits read from rx
  reg  [7:0] rx_data;
  reg [11:0] baud_counter;      // Counter for clock cycles to be compared to
                                //   baud timer values

  // Assign statements
  // Minus 1 since it is starting from 0.
  assign full = (baud_counter == BAUD_TIME - 1);
  assign half = (baud_counter == BAUD_TIME - 1 >> 1);

  // Next State transition block
  always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n)
      state <= IDLE;
    else
      state <= nxt_state;
  end

  // Next State transition block
  always_comb begin
    nxt_state = IDLE;
    rx_rdy = 1'b0;
    baud_clr = 1'b0;
    shift_clr = 1'b1;

    case(state)
      IDLE:
        begin
          baud_clr = 1'b1;
          if(rx == 0) begin
            nxt_state = CHECK;
            baud_clr = 1'b0;
          end
        end

      CHECK:
        begin
          nxt_state = CHECK;
          if(half) begin
            baud_clr = 1'b1;
            if(rx == 1'b0)
              nxt_state = REC;
            else
              nxt_state = IDLE;
          end
        end

      REC:
        begin
          nxt_state = REC;
          shift_clr = 1'b0;
          if(full) begin
            baud_clr = 1'b1;
            if(all_data_recieved) begin
              shift_clr = 1'b1;
              if(rx == 1'b1)
                nxt_state = END;
              else
                nxt_state = IDLE;
            end
          end
        end

      END: 
        begin
          nxt_state = END;
          if(half) begin
            rx_rdy = 1'b1;
            baud_clr = 1'b1;
            nxt_state = IDLE;
          end 
        end

    endcase
  end

  // Move data into shift reg
  always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
      rx_data <= 8'h00;
    end else 
      if(full && state == REC && !all_data_recieved) begin
        rx_data <= {rx, rx_data[7:1]};
    end
  end

  // Update shift count
  always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
      shift_count <= 3'h0;
      all_data_recieved <= 1'h0;
    end else begin
      if(shift_clr) begin
        shift_count <= 3'h0;
        all_data_recieved <= 1'h0;
      end else if(full) begin
        {all_data_recieved,shift_count} <= shift_count + 3'h1;
      end
    end
  end

  // Baud Rate Counter
  always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n)
      baud_counter <= 12'h000;
    else 
      if(baud_clr)
        baud_counter <= 12'h000;
      else
        baud_counter <= baud_counter + 12'h001;
  end

endmodule

