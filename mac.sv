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
module mac(a, b, clk, rst_n, clr_n, acc, of, uf);

  input clk, rst_n, clr_n;
  input signed [7:0] a, b;  

  output of, uf;
  output[15:0] acc;

  wire signed [15:0] mult, acc_nxt;
  wire signed [16:0] add; // Extra bit for testing overflow
  
  reg of, uf;
  reg [15:0] acc;

  assign mult    = a*b;
  assign add     = {mult[15], mult} + {acc[15], acc};
  assign acc_nxt = (clr_n ? add[15:0] : 16'h0000);

  // Accumulator assignment
  always_ff @(posedge clk, negedge rst_n)
    if(!rst_n)
      acc = 16'h0000;
    else
      acc = acc_nxt;

  // Overflow and Underflow assignment
  always_ff @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin      
      of = 0;
      uf = 0;
    end else
      of = 0;
      uf = 0;
      case(add[16:15])
        2'b10: uf = 1;
        2'b01: of = 1;
      endcase
  end

endmodule
