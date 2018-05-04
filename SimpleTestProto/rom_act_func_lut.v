module rom_act_func_lut(addr, clk, q);

   // ADDR_WIDTH should be 11;
   // DATA_WIDTH should be 8 match MAC
  input [10:0] addr; //[(ADDR_WIDTH - 1):0] addr;
  input clk;
  output [7:0] q; //[(DATA_WIDTH - 1):0] q;

  reg [7:0] q;
  // Declare the ROM variable
  reg [7:0] rom[2**11 - 1:0];

  initial begin
    // Need to put correct file here
    $readmemh("rom_act_func_lut_contents.txt",rom);
  end

  always @(posedge clk)
    q <= rom[addr];

endmodule
