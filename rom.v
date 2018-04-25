/*******************************************************************************
* ROM module - Read Only Memory. Reading from new address takes 1 clock cycle.
*
* Authors: Provided in Revision 3
*          
* INPUTS:
*   addr - Address to read from.
*   clk  - System timing clock. Assumed to run at 50MH.
*
* OUTPUTS:
*   q    - Data at mem position addr.
*******************************************************************************/
module rom(addr, clk, q);

  parameter DATA_WIDTH;
  parameter ADDR_WIDTH;
  parameter INIT_FILE;

  input [(ADDR_WIDTH - 1):0] addr;
  input clk;
  output [(DATA_WIDTH - 1):0] q;

  reg [(DATA_WIDTH - 1):0] q;
  // Declare the ROM variable
  reg [DATA_WIDTH - 1:0] rom_mem[2**ADDR_WIDTH - 1:0];

  initial begin
    // Need to put correct file here
    $readmemh(INIT_FILE, rom_mem);
  end

  always @(posedge clk)
    q <= rom_mem[addr];

endmodule
