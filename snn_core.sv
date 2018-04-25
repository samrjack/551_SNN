module snn_core(clk, rst_n, start, q_input, addr_input_unit, digit, done);

  input clk, rst_n, start, q_input;
  output reg [9:0] addr_input_unit;
  output [3:0] digit;
  output reg done;

  assign digit = addr_o_u;

  reg [15:0] MAC_RESULT;
  reg clr_784, clr_32, clr_10, doCnt_784, doCnt_32, doCnt_10, clr_mac_n, stage, layer, we_h, we_o; // Modified in always@

  reg [10:0]  addr_f_act;
  reg [4:0]   addr_h_u;
  reg [3:0]   addr_o_u;

  wire [7:0] in1, in2, w_h, w_o, f_act, q_output, q_hidden;
 
  wire [25:0] mac_res;
  wire addr_w_h[14:0];
  wire addr_w_o[8:0];

  typedef enum reg {IDLE, MAC_HIDDEN_0, MAC_HIDDEN_1, MAC_HIDDEN_2, 
    MAC_HIDDEN_3, MAC_OUT_0, MAC_OUT_1, MAC_OUT_2, MAC_OUT_3, DONE} state_t;

  state_t state, nxt_state;

  localparam hidden = 10'h30f; // 783
  localparam hUnit = 15'h61ff; // 784*32 -1 

  // Instantiate MAC
  // one input to MAC is the {Q_INPUT} OR {ram_hidden(RESULT FROM FIRST ROUND)}
  // the other is decided by a mux 
  mac MAC(.in1(in1), .in2(in2), .clk(clk), .rst_n(rst_n), .clr_n(clr_mac_n), .acc(mac_res));

  // Instantiate ROMS (READ ONLY)
  rom #(.DATA_WIDTH(8)
      , .ADDR_WIDTH(15)
      , .INIT_FILE("rom_hidden_weight_contents.txt")) 
      rom_hidden_weight(.addr(addr_w_h), .clk(clk), .q(w_h));

  rom #(.DATA_WIDTH(8)
      , .ADDR_WIDTH(9)
      , .INIT_FILE("rom_output_weight_contents.txt")) 
      rom_output_weight(.addr(addr_w_0), .clk(clk), .q(w_o));

  rom #(.DATA_WIDTH(8)
      , .ADDR_WIDTH(11)
      , .INIT_FILE("rom_act_func_lut_contents.txt")) 
      rom_act_func_lut(.addr(addr_f_act), .clk(clk), .q(f_act));

  //Instantiate RAM
  ram #(.DATA_WIDTH(8)
      , .ADDR_WIDTH(5)
      , .INIT_FILE("ram_hidden_contents.txt"))
      ram_hidden_unit(.data(f_act), .addr(addr_h_u), .we(we_h), .clk(clk), .q(q_hidden));

  ram #(.DATA_WIDTH(8)
      , .ADDR_WIDTH(4)
      , .INIT_FILE("ram_output_contents.txt"))
      ram_op_uni(.data(f_act), .addr(addr_o_u), .we(we_o), .clk(clk), .q(q_output));

  // DATA FLOW  'b' of mac
  assign q_input_l = {8{q_input}};   // Extend q_input
  assign in2 = (stage?) w_o : w_h; // stage = 0, weight = w_h, as in2 input of MAC
  assign in1 = (layer?) q_hidden : q_input_l; //layer = 0, q_input as in1 input of MAC
  assign act_input = (!mac_res[25] && |mac_res[24:17]) ? 11'h3ff : 
                     (mac_res[25] && ~&mac_res[24:17]) ? 11'h400 : 
					 ret(mac_res[17:7]) + 10'h400;  //rect(mac)+1024
  assign addr_w_h[14:0] = {addr_h_u[4:0], addr_input_unit[9:0]}; //addr_hidden_weight[14:0] = {addr_h_u[4:0], cnt_input[9:0]}
  assign addr_w_o[8:0]  = {addr_o_u[3:0], addr_h_u[4:0]};

  //  Counter(ADDR) Logic 784  // addr_input_unit determined by  [[[ clr_784 , doCnt_784 ]]]
  always_ff@(posedge clk, negedge rst_n)begin 
    if (!rst_n)
      addr_input_unit <= 10'h0;
    else if (clr_784)
      addr_input_unit <= 10'h0;
    else if (doCnt_784)                 // NOTE: Make sure doCnt_784 is asserted when both need update
      addr_input_unit <= addr_input_unit + 1;
    p
  end			

  // Counter Logic 32	      
  // addr_h_u determined by  [[[ clr_32 , doCnt_32 ]]] 
  always_ff@(posedge clk, negedge rst_n) begin
    if (!rst_n)
      addr_h_u <= 10'h0;
    else if (clr_32)
      addr_h_u <= 10'h0;
    else if (doCnt_32)
    addr_h_u <= addr_h_u + 1;
  end

  // Counter Logic 10 	   // addr_o_u determined by  [[[ clr_10 , doCnt_10 ]]]
  always_ff@(posedge clk, negedge rst_n) begin
    if (!rst_n)
    addr_o_u <= 4'h0;
    else if (clr_10)
    addr_o_u <= 4'h0;
    else if (doCnt_10)
    addr_o_u <= addr_h_u + 1;
  end

  always_ff@(posedge clk, negedge rst_n) begin  // addr_f_act determined by [[[ store , UF , OF , mac_res ]]]
    if (!rst_n)
      addr_f_act <= 11'h0;
    else if(store) 
      addr_f_act <= act_input; 
  end

  always_ff@(posedge clk, negedge rst_n)begin  //TODO del
    if (!rst_n)
      d_hidden <= 8'h00;
    else if()
    d_hidden <= f_act;
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
    clr_784 = 1'b0; // Do clear addr_input_unit (784 cnter)   addr_input_unit = 10'h0; // determines q_input_l [from user
    doCnt_784 = 1'b0; 
    clr_32 = 1'b0;  // Initialize addr
    doCnt_32 = 1'b0;
    clr_10 = 1'b0;
    doCnt_10 = 1'b0;
    done = 1'b0;
    store = 1'b0;   // when asserted, next clk edge(if normal), the mac_res(wire) will be stored to MAC_RESULT(dff) 
                    // OR when asserted, next clk edge, put mac's result in the rom and wait for next clk to receive 
    stage = 1'b0;   // [whether take hidden_weight(0) or output_weight(1)
    layer = 1'b0;   // [whether take q_input_l(0) or hidden_unit(1)
    we_h = 1'b0;
    we_o = 1'b0;

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

      MAC_HIDDEN_0: begin   // Do the Multi and Acc 784 times 
        doCnt_784 = 1'b1;    // Increment both addrs for input and hidden weight next clk edge
        if (addr_input_unit == hidden) begin// if addr == d783
          // next state the hidden weight advance to (n+1, 0)
          nxt_state = MAC_HIDDEN_1;   
          //store = 1; //TODO  At the 0-783 last time multi, next clk posedge, acc would be available.  
          clr_784 = 1'b1;
          doCnt_32 = 1'b1;   // next cycle hidden weight addr & hidden unit addr updated
        end else begin
          nxt_state = MAC_HIDDEN_0;
          clr_784	= 1'b0;	   
        end
      end

      MAC_HIDDEN_1: begin // Wait one cycle for the 784th mac res to be accumulated
        nxt_state = MAC_HIDDEN_2;   // Next State  ACT Func Output VALID
        store = 1'b1; // put mac_res in act function, mac_res VALID in this state
      end

      MAC_HIDDEN_2: begin //LUT output would be valid next state
        we_h = 1'b1;        //Next state, finish writing to hidden unit
        // addr_f_act determined by addr_h_u and cnt, Then mac would also be cleared next state
        nxt_state = MAC_HIDDEN_3;
      end

      MAC_HIDDEN_3: begin // To write result to Hidden RAM 
                          // value is already loaded to the addr
                          // LUT output is valid in this state
                          // we_h = 1;    
                          //
                          //             WE would be deasserted, will value be stored?     !!!!!!!!!!
        clr_mac_n = 1'b0; // act low
        if (addr_h_u == 5'h1f) begin  // hidden unit addr = 31 of [0:31]
                                      // move to next phase, need to clear mac
                                      // 							to clear the hidden unit addr
          nxt_state = MAC_OUT_0;
          clr_32 = 1'b1;
        end else begin // NEED TO: clr mac,     
          nxt_state = MAC_HIDDEN_0; 
        end
      end

      // For output part:
      // Need to: layer = 1
      // 			stage = 1
      MAC_OUT_0: begin 
        doCnt_32 = 1'b1;
        layer = 1'b1; 
        stage = 1'b1; 
        if (addr_h_u == 5'b1f) begin
          nxt_state = MAC_OUT_1;
          doCnt_10 = 1'b1;
          clr_32 = 1'b1;
        end else
          nxt_state = MAC_OUT_0;
      end

      MAC_OUT_1: begin 
        layer = 1'b1;
        stage = 1'b1;
        nxt_state = MAC_OUT_2;
        store = 1'b1;
      end

      MAC_OUT_2: begin 
        layer = 1'b1;
        stage = 1'b1;
        we_o  = 1'b1;
        nxt_state = MAC_OUT_3;
      end

      MAC_OUT_3: begin 
        layer = 1'b1;
        stage = 1'b1;
        clr_mac_n = 1'b0;
        if (addr_o_u == 4'h09)
          nxt_state = DONE;
        else 
          nxt_state = MAC_OUT_0;
      end

      DONE: begin
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
