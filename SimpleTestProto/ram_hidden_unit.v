module ram_hidden_unit(data, addr, we, clk, q);
   // ADDR_WIDTH should be 5
   // DATA_WIDTH should be 8 match MAC
  input we, clk;
  input [7:0] data; //[(DATA_WIDTH - 1):0] data;
  input [4:0] addr; //[(ADDR_WIDTH - 1):0] addr;
  output [7:0] q;  //[(DATA_WIDTH - 1):0] q;

  // Declare the RAM variable
  reg [7:0] ram[2**5 - 1:0];

  // Variable to hold the registered read address
  reg [4:0] addr_reg;

  initial begin
    $readmemh("ram_hidden_contents.txt", ram);
  end

  always @(posedge clk) begin
    if(we) // Write
      ram[addr] <= data;
    addr_reg <= addr;
  end

  assign q = ram[addr_reg];

endmodule
