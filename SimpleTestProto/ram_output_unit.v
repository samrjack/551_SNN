module ram_output_unit(data, addr, we, clk, q);
   // ADDR_WIDTH should be 4
   // DATA_WIDTH should be 8 match MAC
  input we, clk;
  input [7:0] data; //[(DATA_WIDTH - 1):0] data;
  input [3:0] addr; //[(ADDR_WIDTH - 1):0] addr;
  output [7:0] q;  //[(DATA_WIDTH - 1):0] q;

  // Declare the RAM variable
  reg [7:0] ram[2**4 - 1:0];

  // Variable to hold the registered read address
  reg [3:0] addr_reg;

  initial begin
    $readmemh("ram_output_contents.txt", ram);
  end

  always @(posedge clk) begin
    if(we) // Write
      ram[addr] <= data;
    addr_reg <= addr;
  end

  assign q = ram[addr_reg];

endmodule
