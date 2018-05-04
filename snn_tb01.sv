module snn_tb01();

  reg clk, rst_n, pc_start;
  wire [7:0] pctosend; 
  wire pctx_rdy, tx, rx;
  wire [7:0] led, rx_data;
  reg [6:0] addr; //784/8-1= 98-1 = h62-1

  uart_tx pc_tx(.clk(clk), .rst_n(rst_n)
                , .tx_rdy(pctx_rdy), .tx(tx), .tx_start(pc_start), .tx_data(pctosend));

  uart_rx pc_rx(.clk(clk), .rst_n(rst_n)
                , .rx_rdy(pcrx_rdy), .rx(rx), .rx_data(rx_data));

  SNN iDUT (.clk(clk), .sys_rst_n(rst_n), .led(led), .uart_tx(rx), .uart_rx(tx));

  pc_input_unit pc_file (.addr(addr), .clk(clk), .q(pctosend));

  /***************************************
      Test Loading UART Input Samples
  ***************************************/
  // Declare the ROM variable
  reg [7:0] rom[(2**7 - 1):0];

  initial begin
    $readmemh("input_samples/uart_input_sample_3.txt",rom);
  end

  integer i;

  initial begin

    $display("PC:rdata:");

    for (i=0; i < 98; i=i+1)
      $display("%d:%h",i,rom[i]);
  end     
    


  always
    #5 clk = ~clk;
    
  initial begin
    clk = 0;
    pc_start = 1'b0;
    rst_n = 1'b0;
    repeat(2) @(posedge clk);
    rst_n = 1'b1;
    
    $display("pc_input_unit data: ");
    for( addr = 7'h0; addr < 7'h62; addr = addr + 1 ) begin 
      // transfer all uart input sample to Tx
      @(posedge clk);  
      $display("%h, %h", addr, pctosend);     	
      pc_start = 1'b1;
      @(posedge clk);
      pc_start = 1'b0;
      @(posedge pctx_rdy);

    end
      
    pc_start = 1'b0;
    
    repeat(1000) @(posedge clk);
    $stop; // FOR TEST check "pctosend"
    
    @(posedge pcrx_rdy);
    $stop;
  end
endmodule
