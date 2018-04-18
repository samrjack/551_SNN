module ram(data, addr, we, clk, q);
  input we, clk;
  input [(DATA_WIDTH - 1):0] data;
  input [(ADDR_WIDTH - 1):0] addr;
  output [(DATA_WIDTH - 1):0] q;

  // Declare the RAM variable
  reg [DATA_WIDTH - 1:0] ram[2**ADDR_WIDTH - 1:0];

  // Variable to hold the registered read address
  reg [ADDR_
endmodule;
