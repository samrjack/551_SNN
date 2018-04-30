/******************************************************************************* 
* LOAD_INPUT_FILE_TB
*
* Authors: Samuel Jackson (srjackson), Colton Bushey (bushey),
*          Ian Deng (hdeng27), Zuoyi Li (zli482)
************************************************************/
module load_input_file_tb();

  // Variables used in DUTs
  reg clk, rst_n, trigger, q;


  // Variables used for testing
  reg q, data;

  reg [9:0] addr_test;
  reg [7:0] ready_test;

  load_input_file iDUT(.clk(clk)
                     , .rst_n(rst_n)
                     , .q(q)
                     , .trigger(trigger)
                     , .data()
                     , .addr()
                    , .ready());

