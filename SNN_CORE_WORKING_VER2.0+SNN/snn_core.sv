module snn_core(clk, rst_n, start, q_input, addr_input_unit, digit, done);

  input clk, rst_n, start, q_input;
  output reg [9:0] addr_input_unit;
  output reg [3:0] digit;
  output reg done;

  reg clr_784, clr_32, clr_10, doCnt_784, doCnt_32, comp, doCnt_10
      , clr_mac_n, stage, layer, we_h, we_o;            // Modified in always@
  reg [4:0]   addr_h_u;
  reg [3:0]   addr_o_u;
  reg [7:0] nxt_val, val;         //// COMP
  reg [4:0] nxt_digit;
  
  wire [10:0] act_input, rect;
  wire [7:0] in1, in2, w_h, w_o, q_output, q_hidden, q_input_l, f_act_o;
  wire  of, uf;
  wire [25:0] mac_res;
  wire [14:0] addr_w_h;
  wire [8:0]  addr_w_o;

  typedef enum reg[3:0] {IDLE, MAC_HIDDEN_0, MAC_HIDDEN_1, MAC_HIDDEN_2, MAC_HIDDEN_3
                             , MAC_OUT_0, MAC_OUT_1, MAC_OUT_2, MAC_OUT_3, WUJIAN, DONE} state_t;
  state_t state, nxt_state;
  localparam hidden = 10'h30f; // 783
  
  // Instantiate MAC
  mac MAC(.in1(in1), .in2(in2), .clk(clk), .rst_n(rst_n), .clr_n(clr_mac_n), .acc(mac_res));
 
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
      ram_op_uni(.data(f_act_o), .addr(addr_o_u), .we(we_o), .clk(clk), .q(q_output));
 
  // DATA FLOW  'b' of mac
  assign of = !mac_res[25] && |mac_res[24:17];
  assign uf =  mac_res[25] && ~&mac_res[24:17];
  assign rect = mac_res[17:7] + 11'h400;
  
  assign q_input_l = {1'b0,{7{q_input}}};      // {8{q_input}};   // Extend q_input
  assign in2 = (stage)? w_o : w_h;             // stage = 0, weight = w_h, as B input of MAC
  assign in1 = (layer)? q_hidden : q_input_l;  //layer = 0, q_input as A input of MAC
  assign act_input = (of) ? 11'h7ff :          // h) 3ff+400
                     (uf) ? 11'h0   : rect;    //11'h400 + 11'h400 : ADDR need to be >= 0
					 
  assign addr_w_h = {addr_h_u, addr_input_unit}; //addr_hidden_weight[14:0] = {addr_h_u[4:0], cnt_input[9:0]}
  assign addr_w_o = {addr_o_u, addr_h_u};        //addr_w_o[8:0]  = {addr_o_u[3:0], addr_h_u[4:0]};
 
  // Counter(ADDR) Logic 784  addr_input_unit determined by  [[[ clr_784 , doCnt_784 ]]]
  always_ff@(posedge clk, negedge rst_n) begin 
    if (!rst_n)
      addr_input_unit <= 10'h0;
    else if (clr_784)
       addr_input_unit <= 10'h0;
    else if (doCnt_784)                
        addr_input_unit <= addr_input_unit + 1;
  end     
  
  // Counter Logic 32      addr_h_u determined by  [[[ clr_32 , doCnt_32 ]]] 
  always_ff@(posedge clk, negedge rst_n) begin
    if (!rst_n)
      addr_h_u <= 10'h0;
    else if (clr_32)
      addr_h_u <= 10'h0;
    else if (doCnt_32)
      addr_h_u <= addr_h_u + 1;
  end

  // Counter Logic 10      addr_o_u determined by  [[[ clr_10 , doCnt_10 ]]]
  always_ff@(posedge clk, negedge rst_n) begin
    if (!rst_n)
      addr_o_u <= 4'h0;
    else if (clr_10)
      addr_o_u <= 4'h0;
    else if (doCnt_10)
      addr_o_u <= addr_o_u + 1;
  end
 
  // COMPARE LOGIC  
  always_ff@(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
      digit <= 4'h0;
      nxt_digit <= 4'h0;
      val <= 8'h0;
      nxt_val <= 8'h0;
    end else if(we_o || comp) begin
      nxt_digit <= addr_o_u;
      nxt_val <= f_act_o; 
      if(nxt_val > val) begin
        digit <= nxt_digit;
        val <= nxt_val;
      end
    end
  end


  always_ff@(posedge clk, negedge rst_n) begin
    if(!rst_n)
      state <= IDLE;
    else
      state <= nxt_state;
  end   
  
    
    
  always_comb begin
    // INITIALIZE DEFAULT         
    clr_mac_n = 1'b1; // Do NOT clear MAC
    clr_784   = 1'b0; // Do clear addr_input_unit (784 cnter)   addr_input_unit = 10'h0; // determines q_input_l [from user
    doCnt_784 = 1'b0; 
    clr_32    = 1'b0;  // Initialize addr
    doCnt_32  = 1'b0;
    clr_10    = 1'b0;
    doCnt_10  = 1'b0;
    done      = 1'b0; 
    stage     = 1'b0;   // [whether take hidden_weight(0) or output_weight(1)
    layer     = 1'b0;   // [whether take q_input_l(0) or hidden_unit(1)
    we_h      = 1'b0;    
    we_o      = 1'b0;

    comp      = 1'b0;

    case(state)
      IDLE: begin
        clr_10  = 1'b1;
        clr_784 = 1'b1;
        clr_32  = 1'b1;
        clr_mac_n  = 1'b0;  // Do clear MAC
        if(start) begin
          nxt_state = MAC_HIDDEN_0;
        end else
          nxt_state = IDLE;
      end
      
      MAC_HIDDEN_0: begin    // Do the Multi and Acc 784 times 
        doCnt_784 = 1'b1;    // Increment both addrs for input and hidden weight next clk edge
        if (addr_input_unit == hidden) begin // if addr == d783
          nxt_state = MAC_HIDDEN_1;     
          clr_784 = 1'b1;
        end else begin
          nxt_state = MAC_HIDDEN_0;
          clr_784 = 1'b0;    
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
          stage = 1'b1; 
          nxt_state = MAC_OUT_0; 

        end else 
          nxt_state = MAC_HIDDEN_0; 
      end

      // For output part:
      // Need to: layer = 1
      //          stage = 1
      MAC_OUT_0: begin 
        doCnt_32 = 1'b1; 
        layer = 1'b1; 
        stage = 1'b1; 
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
        stage = 1'b1;
        nxt_state = MAC_OUT_2;
      end
      
      MAC_OUT_2: begin 
        layer = 1'b1;
        stage = 1'b1;
        nxt_state = MAC_OUT_3;
      end
      
      MAC_OUT_3: begin 
        layer = 1'b1;
        stage = 1'b1;
        we_o  = 1'b1;
        doCnt_10 = 1'b1;
        comp = 1;
        clr_mac_n = 1'b0;
        if (addr_o_u == 4'h9)
          nxt_state = WUJIAN;
        else 
          nxt_state = MAC_OUT_0;
      end
      
      WUJIAN: begin
        comp = 1;
        nxt_state = DONE;
      end
      
      DONE: begin
        comp = 1'b1;   
        done = 1'b1;
        nxt_state = IDLE;
      end
      
      default: begin
        clr_10  = 1'b1;
        clr_784 = 1'b1;
        clr_32  = 1'b1;
        clr_mac_n  = 1'b0;  // Do clear MAC
        if(start) begin
          nxt_state = MAC_HIDDEN_0;   
        end else
          nxt_state = IDLE;
      end
    endcase
  end
endmodule



