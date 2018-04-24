/*********************************************************************
* MAC_TB
*                                                                    
* Authors: SAMUEL JACKSON (srjackson), COLTON BUSHEY (bushey),
*          Ian Deng (hdeng27), Zuoyi Li (zli482)
*          
*********************************************************************/

module mac_tb();

  // Initiialize
  logic signed [7:0] stm_a, stm_b;
  logic signed [25:0] acc;
  logic clr_n, clk, rst_n;
  int signed exp_acc;
  
  mac iMAC(.clk(clk),.in1(stm_a), .in2(stm_b), .acc(acc), .clr_n(clr_n), .rst_n(rst_n));

  /*****************************************************************************
  * Call load when the values of a and b have been changed so that they may be *
  * triggered into the MAC and the new output may be checked against an        *
  * expected value.                                                            *
  *****************************************************************************/
  task load;
    @(posedge clk);
    $display("adding new values to result: a = %d\tb=%d\n", stm_a, stm_b);
    exp_acc = exp_acc + stm_a * stm_b;
    @(negedge clk); // let changes propagate through before comparing
      // Check if expected value matches given value
    if(acc != exp_acc[25:0]) begin
      $display("FAIL: actual result did not match expected output\t");
      $display("\texpected: %d\tactual:%d\n", exp_acc, acc);
      $stop;
    end
/*
    // Check if overflow has occured
    if(exp_acc > 16'sh7FFF) begin
      if(of != 1'b1 || uf == 1'b1) begin
        $display("FAIL: overflow not properly detected\n");
        $display("\tOF: %d\tUF: %d\tacc: %h\texpected: %h\n", of, uf, acc, exp_acc);
        $stop;
      end
      // Sign extend expected value to match acc so that future calculations
      // continue to match.
      exp_acc = {{16{acc[15]}}, acc}; 

    // Check if underflow has occred
    end else if(exp_acc < 16'sh8000) begin
      if(of == 1'b1 || uf != 1'b1) begin
        $display("FAIL: underflow not properly detected\n");
        $display("\tOF: %d\tUF: %d\tacc: %h\texpected: %h\n", of, uf, acc, exp_acc);
        $stop;
      end
      // Sign extend expected value to match acc so that future calculations
      // continue to match.
      exp_acc = {{16{acc[15]}}, acc};

    // If neither overflow nor underflow has occured, make sure of and uf
    // aren't asserted.
    end else if(of != 1'b0 || uf != 1'b0) begin
      $display("FAIL: underflow or overflow unexpectedly asserted\n");
      $display("\tOF: %d\tUF: %d\tacc: %h\texpected: %h\n", of, uf, acc, exp_acc);
      $stop;
    end
*/
  endtask

  /****************************************************************************
  * clear - Call clear to remove current data MAC and update expected value   *
  * too.                                                                      *
  ****************************************************************************/
  task clear;
    $display("Clearing results. Final value: %d.\n\n\n",acc);
    clr_n = 0;
    exp_acc = 0;
    @(posedge clk);
    clr_n = 1;
  endtask
  
  initial begin
    clk = 0;
    rst_n = 0;
    stm_a = 0;
    stm_b = 0;
    clr_n = 1;
    @(posedge clk);
    rst_n = 1;
    clear();

    // First example: 2*5 + (-2)*5 + (-3)*8
    
    stm_a = 8'd2;
    stm_b = 8'd5;
    load();

    stm_a = -8'd2;
    stm_b =  8'd5;
    load();

    stm_a = -8'd3;
    stm_b =  8'd8;
    load();

    clear();
    
    // Second example 126*126 + 126*126 + 126*126
    stm_a = 8'd126;
    stm_b = 8'd126;
    load();
    load();
    load();
   
    clear();

    // Third example - induced underflow - 126*-100 + 126*-100 + 126*-100
    stm_a =  8'd126;
    stm_b = -8'd100;
    load();
    load();
    load();
    load();
    load();
    load();

    clear();
    $stop;
  end  

  /***********************
  * Set oscilating clock *
  ***********************/
  always
    #5 clk = ~clk;
endmodule
