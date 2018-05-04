module ram_input_unit(data, addr, we, clk, q);
   // ADDR_WIDTH should be 4
   // DATA_WIDTH should be 8 match MAC
  input we, clk;
  input data; //[(DATA_WIDTH - 1):0] data;
  input [9:0] addr; //[(ADDR_WIDTH - 1):0] addr;
  output q;  //[(DATA_WIDTH - 1):0] q;

  // Declare the RAM variable
  reg ram[2**10 - 1:0];

  // Variable to hold the registered read address
  reg [9:0] addr_reg;

  initial begin
    $readmemh("input_samples/ram_input_contents_sample_1.txt", ram);
  end

  always @(posedge clk) begin
    if(we) // Write
      ram[addr] <= data;
    addr_reg <= addr;
  end

  assign q = ram[addr_reg];

endmodule
