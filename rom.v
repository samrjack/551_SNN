module rom(addr, clk, q);
  input [(ADDR_WIDTH - 1):0] addr;
  input clk;
  output [(DATA_WIDTH - 1):0] q;

  reg [(DATA_WIDTH - 1):0] q;
  // Declare the ROM variable
  reg [DATA_WIDTH - 1:0] rom[2**ADDR_WIDTH - 1:0];

  initial
    // Need to put correct file here
    readmemh("Initializeation file",rom);
  end

  always @(posedge clk)
    q <= rom[addr];

endmodule
