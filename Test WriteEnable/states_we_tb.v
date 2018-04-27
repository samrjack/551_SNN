module states_we_tb();

reg clk, rst_n, start;
wire [7:0] q;

states_we iDUT(.start(start), .clk(clk), .rst_n(rst_n), .q(q));

always
  #5 clk = ~clk;

initial begin
  clk = 0;
  rst_n = 0;
  start = 0;
#7 rst_n = 1;
#2 start = 1;
#50 $stop;
end

endmodule
