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
module ram(data, addr, we, clk, q);
  
  localparam ADDR_WIDTH = 10;
  localparam DATA_WIDTH = 8;
  localparam INIT_FILE = "";

  input we, clk;
  input [(DATA_WIDTH - 1):0] data;
  input [(ADDR_WIDTH - 1):0] addr;
  output [(DATA_WIDTH - 1):0] q;

  // Declare the RAM variable
  reg [DATA_WIDTH - 1:0] ram[2**ADDR_WIDTH - 1:0];

  // Variable to hold the registered read address
  reg [ADDR_WIDTH - 1:0] addr_reg;

  initial
    readmemh(INIT_FILE, ram);
  end

  always @(posedge clk) begin
    if(we) // Write
      ram[addr] <= data;
    addr_reg <= addr;
  end

  assign q = ram[addr_reg];

endmodule;
