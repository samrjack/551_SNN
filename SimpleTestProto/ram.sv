/*******************************************************************************
* RAM module - Random Access Memory. Reading and writing each take 1 cycle.
*
* Authors: Provided in Revision 3       
* 
* INPUTS:
*   data - Data to write.
*   addr - Address to write to or read from.
*   we   - Write Enable. Data on datd input written to addr when high.
*   clk  - System timing clock. Assumed to run at 50MH.
*
* OUTPUTS:
*   q    - Data at mem position addr.
*******************************************************************************/
module ram #(parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 8, parameter INIT_FILE = "") 
            (data, addr, we, clk, q);

  /*parameter DATA_WIDTH;
  parameter ADDR_WIDTH;
  parameter INIT_FILE; */

  input we, clk;
  input [(DATA_WIDTH - 1):0] data;
  input [(ADDR_WIDTH - 1):0] addr;
  output [(DATA_WIDTH - 1):0] q;

  // Declare the RAM variable
  reg [(DATA_WIDTH - 1):0] ram_mem[(2**ADDR_WIDTH - 1):0];

  // Variable to hold the registered read address
  reg [ADDR_WIDTH - 1:0] addr_reg;

  initial begin
    $readmemh(INIT_FILE, ram_mem);
  end

  always @(posedge clk) begin
    if(we) // Write
      ram_mem[addr] <= data;

    addr_reg <= addr;
  end

  assign q = ram_mem[addr_reg];

endmodule
