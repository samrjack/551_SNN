module rom_input_unit(addr, clk, q);

   // ADDR_WIDTH should be (15or)16  784*32 = h6200;
   // DATA_WIDTH should be 8 match MAC
  input [9:0] addr;
  input clk;
  output reg q;

  // Declare the ROM variable
  reg rom[(2**10 - 1):0];

  initial begin
    // Need to put correct file here
    $readmemh("input_samples/ram_input_contents_sample_1.txt",rom);
  end

  always @(posedge clk)
    q <= rom[addr];

endmodule
