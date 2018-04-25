module rom_output_weight(addr, clk, q);

   // ADDR_WIDTH should be 9or10 32*10 = h140;
   // DATA_WIDTH should be 8 match MAC
  input [8:0] addr;
  input clk;
  output [7:0] q;

  reg [7:0] q;
  // Declare the ROM variable
  reg [7:0] rom[2**9 - 1:0];

  initial
    // Need to put correct file here
    readmemh("rom_output_weight_contents",rom);
  end

  always @(posedge clk)
    q <= rom[addr];

endmodule
