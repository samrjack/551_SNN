module pc_input_unit(addr, clk, q);

   ADDR_WIDTH = 16; //should be (15or)16  784*32 = h6200;
   DATA_WIDTH = 8;  //should be 8 match MAC
  input [6:0] addr;
  input clk;
  output reg [7:0] q;

  // Declare the ROM variable
  reg [7:0] rom[(2**7 - 1):0];

  initial begin
    // Need to put correct file here
    $readmemh("input_samples/uart_input_sample_3.txt",rom);
  end

  always @(posedge clk)
    q <= rom[addr];

endmodule
