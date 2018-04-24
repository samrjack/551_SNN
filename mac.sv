/*********************************************************************
* MAC module - accumulates the multiplied values of the inputs. 
*                                                                    
* Authors: SAMUEL JACKSON (srjackson), COLTON BUSHEY (bushey),
*          Ian Deng (hdeng27), Zuoyi Li (zli482)
*          
* 
* INPUTS:
*   in1     - 1st number operand.
*   in2     - 2nd number operand.
*   clr_n - Clears accumulated value. SYNCHRONOUS. 
*   clk   - System timing clock. Assumed to run at 50MHz.
*   rst_n - ASYNCHRONOUS active-low reset.
*
* OUPTUTS:
*   acc   - Accumulated value of inputs.
*********************************************************************/
module mac(in1, in2, clk, rst_n, clr_n, acc);

  input clk, rst_n, clr_n;
  input signed [7:0] in1, in2;  

 
  output[25:0] acc;

  wire signed [15:0] mult;
  wire signed [25:0] mult_ext, acc_nxt; 
  wire signed [25:0] add; 

  reg [25:0] acc;

  assign mult     = in1*in2;
  assign add     = {{11{mult[15]}}, mult[14:0]} + acc;
  assign acc_nxt = (clr_n ?  add[25:0] : 26'h0000);

  // Accumulator assignment
  always_ff @(posedge clk, negedge rst_n)
    if(!rst_n)
      acc = 26'h0000;
     else
      acc = acc_nxt;

endmodule
