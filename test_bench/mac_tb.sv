/*********************************************************************
* MAC_TB
*                                                                    
* Authors: SAMUEL JACKSON (srjackson), COLTON BUSHEY (bushey),
*          Ian Deng (hdeng27), Zuoyi Li (zli482)
*          
*********************************************************************/

module mac_tb();

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
  endtask

  /****************************************************************************
  * clear - Call clear to remove current data MAC and update expected value   *
  * too.                                                                      *
  ****************************************************************************/
  task clear;
    $display("Clearing results. Final value: %d.\n\n\n",acc);
    clr_n = 1'b0;
    exp_acc = 1'b0;
    @(posedge clk);
    clr_n = 1'b1;
  endtask

  task initialize;
    clk = 1'b0;
    rst_n = 1'b0;
    stm_a = 1'b0;
    stm_b = 1'b0;
    clr_n = 1'b1;
    @(posedge clk);
    rst_n = 1'b1;
    clear();
  endtask
  
  initial begin
    initialize();
 
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

