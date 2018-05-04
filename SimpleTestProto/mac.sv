module mac(clk, rst_n, a, b, clr_n, of, uf, acc);

input clk, rst_n, clr_n;
input signed [7:0] a, b;
output of, uf; //reg of, uf
output reg [25:0] acc;

wire [15:0] mult;
wire signed [25:0] mult_ext, add, acc_nxt;
wire fof, fuf;

assign mult = a*b;
assign mult_ext = {{10{mult[15]}}, mult};

assign of = ( !acc[25] && |acc[24:17] )? 1'b1 : 1'b0;
assign uf = ( acc[25]  && ( !(&acc[24:17]) ))? 1'b1 : 1'b0;

assign add = mult_ext + acc;
assign acc_nxt = clr_n? add : 26'h0;
 
always@(posedge clk, negedge rst_n) begin
   if (!rst_n) begin
       // of <= 1'b0;
       // uf <= 1'b0;
       acc <= 26'h0;
   end
   else begin
        acc <= acc_nxt;
       // of <= fof;
       // uf <= fuf;
   end
end

endmodule
