module states_we(start, clk, rst_n, q);
input clk, rst_n, start;
output [7:0] q; 
reg we;
reg [7:0] data;

dff_we store(.data(data), .we(we), .clk(clk), .q(q));

typedef enum reg {A, B} state_t;

state_t state, nxt_state;

always_ff@(posedge clk, negedge rst_n)
if(!rst_n)
    state <= A;
else 
    state <= nxt_state;

always_ff@(posedge clk, negedge rst_n)
if(!rst_n)
    data <= 8'h0;
else
    data <= data+1;


always_comb begin
we = 0;
case(state)
    A: begin
    if(start)
       nxt_state = B;
    else nxt_state = A;
    end

    B: begin
    we = 1; 
    nxt_state = A;
    end

endcase

end


endmodule
