module dff_we(clk, we, data, q);

input we, clk;
input [7:0] data;
output reg [7:0] q;

always@(posedge clk) begin
  if(we)
    q <= data;
end

endmodule 
