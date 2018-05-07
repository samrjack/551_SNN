/*********************************************************************
* SNN_CORE module - 
*                                                                    
* Authors: Samuel Jackson (srjackson), Colton Bushey (bushey),
*          Ian Deng (hdeng27), Zuoyi Li (zli482)
* 
* INPUTS:
*   start   - Trigger to run SNN.
*   q_input - Input snn layer value at outputed address.
*   clk     - System timing clock. Assumed to run at 50MHz.
*   rst_n   - ASYNCHRONOUS active-low reset.
*
* OUPTUTS:
*   addr_input_unit - Accumulated value of inputs.
*   digit           - The guessed digit.
*   done            - Signal indicating completion of calculations.
*   
*********************************************************************/
module snn_core(clk, rst_n, start, q_input, addr_input_unit, digit, done);

  input start, q_input, clk, rst_n;
  output reg [9:0] addr_input_unit;
  output reg [3:0] digit;
  output reg done;

  reg comp;  // Compare new digits
  reg layer; // Layer being processed with MAC. 0 = input layer; 1 = hidden layer.
  reg we_h, we_o; // Hidden layer write enable; output layer write enable 
  reg doCnt_784, doCnt_32, doCnt_10;      // ?
  reg clr_784, clr_32, clr_10, clr_mac_n, clr_comp; // Clear signals

  reg  [3:0]   addr_o_u; // Address of output unit
  reg  [4:0]   addr_h_u; // Address of hidden unit
  wire [10:0] act_input; // Input to activation function

 reg [3:0] nxt_digit;
 reg [7:0] nxt_val, val;         //// COMP ////"???????" -Sam

  wire [7:0] mac_in1, mac_in2;   // Inputs to MAC madule.
  wire [7:0] w_h, w_o;           // Weight for hidden unit; Weight for output unit.
  wire [7:0] q_hidden, q_output; // RAM q outputs. Hidden layer; output layer.
  wire [7:0] f_act_o;            // Activation function return value.
  wire [7:0] q_input_l;          // long q_input value.
  wire [8:0] addr_w_o;           // Address of output layer weights.
  wire [14:0] addr_w_h;          // Address of hidden layer weights.
  wire [25:0] mac_res;           // Cumulative result of MAC.

  /* States:
   * IDLE - 
   * MAC_HIDDEN_0 -
   * MAC_HIDDEN_1 -
   * MAC_HIDDEN_2 -
   * MAC_HIDDEN_3 -
   * MAC_OUT_0 -
   * MAC_OUT_1 -
   * MAC_OUT_2 -
   * MAC_OUT_3 -
   * WUJIAN - 
   * DONE -
   */
  typedef enum reg[3:0] {IDLE, MAC_HIDDEN_0, MAC_HIDDEN_1, MAC_HIDDEN_2 
                        ,MAC_HIDDEN_3, MAC_OUT_0, MAC_OUT_1, MAC_OUT_2, MAC_OUT_3, WUJIAN, DONE} state_t;
  state_t state, nxt_state;

  localparam ACT_MIN    = 11'b000_0000_0000; // Rectified ram result + 1024
  localparam ACT_MAX    = 11'b111_1111_1111; // Rectified ram result + 1024
  localparam ACT_OFFSET = 11'b100_0000_0000; // Offset added to values given to act func
  localparam HIDDEN = 10'h310 - 10'h001; // 784 - 1
  

  // Instantiate MAC
  // one input to MAC is the {Q_INPUT} OR {ram_hidden(RESULT FROM FIRST ROUND)}
  // the other is decided by a mux 
  mac MAC(.in1(mac_in1), .in2(mac_in2), .clk(clk), .rst_n(rst_n), .clr_n(clr_mac_n), .acc(mac_res));
 
  // Instantiate ROMS (READ ONLY)
  rom #(.DATA_WIDTH(8)
      , .ADDR_WIDTH(15)
      , .INIT_FILE("mem_init_files/rom_hidden_weight_contents.txt"))
      rom_hidden_weight(.addr(addr_w_h), .clk(clk), .q(w_h));

  rom #(.DATA_WIDTH(8)
      , .ADDR_WIDTH(9)
      , .INIT_FILE("mem_init_files/rom_output_weight_contents.txt"))
      rom_output_weight(.addr(addr_w_o), .clk(clk), .q(w_o));

  rom #(.DATA_WIDTH(8)
      , .ADDR_WIDTH(11)
      , .INIT_FILE("mem_init_files/rom_act_func_lut_contents.txt"))
      rom_act_func_lut(.addr(act_input), .clk(clk), .q(f_act_o));

  // Instantiate RAM     
  ram #(.DATA_WIDTH(8)
      , .ADDR_WIDTH(5)
      , .INIT_FILE("mem_init_files/ram_hidden_contents.txt"))
      ram_hidden_unit(.data(f_act_o), .addr(addr_h_u), .we(we_h), .clk(clk), .q(q_hidden));
 
      
  ram #(.DATA_WIDTH(8)
      , .ADDR_WIDTH(4)
      , .INIT_FILE("mem_init_files/ram_output_contents.txt"))
      ram_output_unit(.data(f_act_o), .addr(addr_o_u), .we(we_o), .clk(clk), .q(q_output));
 
  assign q_input_l = {1'b0,{7{q_input}}}; // Extend q_input 
  assign mac_in2   = (layer)? w_o : w_h; 
  assign mac_in1   = (layer)? q_hidden : q_input_l; 

  // To calculate act_input, take rect(mac) + 1024.
  // 1024 already added to saturation cases.
  assign act_input = (!mac_res[25] &&  |mac_res[24:17] ) ? ACT_MAX :
                     ( mac_res[25] && ~&mac_res[24:17] ) ? ACT_MIN :
                       mac_res[17:7] + ACT_OFFSET;

  // TODO Verify functionality
  // addr_hidden_weight[14:0] = {addr_h_u[4:0], cnt_input[9:0]}
  assign addr_w_h = {addr_h_u, addr_input_unit}; 

  // addr_w_o[8:0]  = {addr_o_u[3:0], addr_h_u[4:0]};
  assign addr_w_o = {addr_o_u, addr_h_u}; 
 

 
  //TODO Can we remove doCnt? I can't tell if it's redundent or not
  //  Counter(ADDR) Logic 784  
  always_ff @(posedge clk, negedge rst_n) begin 
    if (!rst_n)
      addr_input_unit <= 10'h0;
    else if (clr_784)
      addr_input_unit <= 10'h0;
    else if (doCnt_784)
      addr_input_unit <= addr_input_unit + 1;
  end     
  
  // Counter Logic 32       
  always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n)
      addr_h_u <= 10'h0;
    else if (clr_32)
      addr_h_u <= 10'h0;
    else if (doCnt_32)
      addr_h_u <= addr_h_u + 1;
  end

  // Counter Logic 10      
  always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n)
      addr_o_u <= 4'h0;
    else if (clr_10)
      addr_o_u <= 4'h0;
    else if (doCnt_10)
      addr_o_u <= addr_o_u + 1;
  end
 
  // Calculate output value using max of output layer
  always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
      digit <= 4'h0;
      nxt_digit <= 4'h0;
      val <= 8'h0;
      nxt_val <= 8'h0;
    end else if(we_o || comp) begin
      nxt_digit <= addr_o_u;
      nxt_val <= f_act_o; // q_output
      if(nxt_val > val) begin
        digit <= nxt_digit;
        val <= nxt_val;
      end
    end else if(clr_comp) begin //0503
      digit <= 4'h0;
      nxt_digit <= 4'h0;
      val <= 8'h0;
      nxt_val <= 8'h0;
    end
  end


  // State transition.
  always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n)
      state <= IDLE;
    else
      state <= nxt_state;
  end   
  
  always_comb begin
    // INITIALIZE DEFAULT         
    nxt_state = IDLE;
    clr_mac_n = 1'b1; // Do NOT clear MAC
    clr_784   = 1'b0; // Do clear addr_input_unit  addr_input_unit = 10'h0; // determines q_input_l [from user]
    clr_32    = 1'b0; // Initialize addr
    clr_10    = 1'b0;
    doCnt_784 = 1'b0; 
    doCnt_32  = 1'b0;
    doCnt_10  = 1'b0;
    done      = 1'b0; 
    layer     = 1'b0;  
    we_h      = 1'b0;    
    we_o      = 1'b0;
    comp      = 1'b0;
    clr_comp  = 1'b0; // 0503

    case(state)
      IDLE: begin
        clr_comp   = 1'b1; // 0503
        clr_10     = 1'b1;
        clr_784    = 1'b1;
        clr_32     = 1'b1;
        clr_mac_n  = 1'b0;
        if(start) begin
          nxt_state = MAC_HIDDEN_0;
        end
      end
      
      MAC_HIDDEN_0: begin   // Do the Multi and Acc 784 times 
        clr_784 = 1'b0;    
        doCnt_784 = 1'b1;    // Increment both addrs for input and hidden weight next clk edge
        nxt_state = MAC_HIDDEN_0;
        if (addr_input_unit == HIDDEN) begin// if addr == d783
          nxt_state = MAC_HIDDEN_1;   
          clr_784 = 1'b1;
        end
      end
      
      MAC_HIDDEN_1: begin // Wait one cycle for the 784th mac res to be accumulated
        we_h = 1'b1;
        nxt_state = MAC_HIDDEN_2;   // Next State  ACT Func Output VALID
      end

      MAC_HIDDEN_2: begin //LUT output would be valid next state
        nxt_state = MAC_HIDDEN_3;
      end
      
      MAC_HIDDEN_3: begin 
        doCnt_32 = 1'b1; 
        clr_mac_n = 1'b0; 
        if (addr_h_u == 5'h1f) begin // hidden unit addr = 31 of [0:31]
          clr_32 = 1'b1; 
          layer = 1'b1; 
          nxt_state = MAC_OUT_0; 

        end else 
          nxt_state = MAC_HIDDEN_0; 
      end

      // For output part:
      // Need to: layer = 1
      MAC_OUT_0: begin 
        doCnt_32 = 1'b1; 
        layer    = 1'b1; 
        if (addr_h_u == 5'h0)
          clr_mac_n = 1'b0;

        if (addr_h_u == 5'h1f) begin 
          nxt_state = MAC_OUT_1;
          clr_32 = 1'b1;
        end else 
          nxt_state = MAC_OUT_0;
      end
      
      MAC_OUT_1: begin 
        layer = 1'b1;
        nxt_state = MAC_OUT_2;
      end
      
      MAC_OUT_2: begin 
        layer = 1'b1;
        nxt_state = MAC_OUT_3;
      end
      
      MAC_OUT_3: begin 
        layer = 1'b1;
        we_o  = 1'b1;
        comp = 1;
        clr_mac_n = 1'b0;
        if (addr_o_u == 4'h9)
          nxt_state = WUJIAN;
        else begin
          doCnt_10 = 1'b1;  // 0503
          nxt_state = MAC_OUT_0;
        end
      end
      
      WUJIAN: begin
        clr_mac_n = 1'b0; //0503
        clr_10    = 1'b1; //0503
        comp = 1;
        nxt_state = DONE;
      end
      
      DONE: begin
        clr_mac_n = 1'b0; //0503
        comp = 1'b1;   
        done = 1'b1;
      end
      
      default: begin
        clr_comp   = 1'b1; // 0503
        clr_10     = 1'b1;
        clr_784    = 1'b1;
        clr_32     = 1'b1;
        clr_mac_n  = 1'b0;
        if(start) begin
          nxt_state = MAC_HIDDEN_0;
        end
      end
    endcase
  end
endmodule
