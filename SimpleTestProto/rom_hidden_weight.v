module rom_hidden_weight(addr, clk, q);

   // ADDR_WIDTH should be (15or)16  784*32 = h6200;
   // DATA_WIDTH should be 8 match MAC
  input [14:0] addr;
  input clk;
  output reg [7:0] q;

  // Declare the ROM variable
  reg [7:0] rom[(2**15 - 1):0];

  initial begin
    // Need to put correct file here
    $readmemh("rom_hidden_weight_contents.txt",rom);
  end

  always @(posedge clk)
    q <= rom[addr];

endmodule
