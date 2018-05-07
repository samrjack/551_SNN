/*******************************************************************************
* SNN_TB
*
* Authors: Samuel Jackson (srjackson), Colton Bushey (bushey),
*          Ian Deng (hdeng27), Zuoyi Li (zli482)
*******************************************************************************/
module snn_tb();

  reg clk, rst_n;
  reg [7:0] out;

  // TX variables
  reg send; // trigger tx to send
  wire tx;
  wire ready_freddy;

  // SNN variables
  wire rx; 
    
  // RX variables
  wire ready_neddy;
  wire [7:0] output_data;

  // RAM variables
  reg [6:0] ram_addr;
  wire [7:0] rom_data;

  uart_tx sender(.clk(clk), .rst_n(rst_n), .tx_rdy(ready_freddy), .tx(tx), .tx_start(send), .tx_data(rom_data));
  SNN iDUT(.clk(clk), .sys_rst_n(rst_n), .led(), .uart_tx(rx), .uart_rx(tx));
  uart_rx receiver(.clk(clk), .rst_n(rst_n), .rx_rdy(ready_neddy), .rx(rx), .rx_data(output_data));

  rom #(.DATA_WIDTH(8)
      , .ADDR_WIDTH(7)
      , .INIT_FILE("../input_samples/uart_sample_0.txt"))
      number_input0(.addr(ram_addr)
                  , .clk(clk)
                  , .q(rom_data));

  task initialize;
    clk      = 1'b0;
    rst_n    = 1'b0;
    send     = 1'b0;
    ram_addr = 7'h0; 
    @(posedge clk);
    rst_n    = 1'b1;
  endtask

  // Used to print all ram values
  task checkRom;
     for(ram_addr = 7'h0; ram_addr < 7'd98; ram_addr++) begin
      @(posedge clk); //Propgate changes
      @(posedge clk);

      $display("ROM at position %h is %h.\n", ram_addr, rom_data);
    end
  endtask

  initial begin
    initialize();
    for(ram_addr = 7'h0; ram_addr < 7'd98; ram_addr++) begin
      
      @(posedge clk); //Propgate changes
      @(posedge clk);
      
      send = 1'b1;
      @(posedge clk);
      send = 1'b0;
           
      @(posedge ready_freddy);

    end
    
    ram_addr = 7'h0;
    @(posedge ready_neddy);
    out = output_data;
    $display("Value outputed: %h\n", out);
    $stop;
  end

  always
    #5 clk = ~clk;

endmodule

