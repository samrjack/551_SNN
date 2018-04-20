/*********************************************************************
* MAC module - accumulates the multiplied values of the inputs. 
*                                                                    
* Authors: SAMUEL JACKSON (srjackson), COLTON BUSHEY (bushey),
*          Ian Deng (hdeng27), Zuoyi Li (zli482)
*          
* 
* INPUTS:
*   a     - 1st number operand.
*   b     - 2nd number operand.
*   clr_n - Clears accumulated value. SYNCHRONOUS. 
*   clk   - System timing clock. Assumed to run at 50MH.
*   rst_n - ASYNCHRONOUS active-low reset.
*
* OUPTUTS:
*   acc   - Accumulated value of inputs.
*   of    - Flag that goes high when overflow is detected.
*   uf    - Flag that goes high when overflow is detected.
*********************************************************************/
module mac(a, b, clk, rst_n, clr_n, acc);

  input clk, rst_n, clr_n;
  input signed [7:0] a, b;  

  output [25:0] acc;

  wire signed [15:0] mult;
  wire signed [25:0] add, acc_nxt;
  
  reg [25:0] acc;

  assign mult    = a * b;
  assign add     = {{10{mult[15]}}, mult} + acc;
  assign acc_nxt = (clr_n ? add : 26'h0);

  // Accumulator assignment
  always_ff @(posedge clk, negedge rst_n)
    if(!rst_n)
      acc = 26'h0000;
    else
      acc = acc_nxt;

endmodule
