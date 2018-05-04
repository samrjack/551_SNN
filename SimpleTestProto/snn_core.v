/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : M-2016.12
// Date      : Wed May  2 18:47:29 2018
/////////////////////////////////////////////////////////////


module snn_core ( clk, rst_n, start, q_input, addr_input_unit, digit, done );
  output [9:0] addr_input_unit;
  output [3:0] digit;
  input clk, rst_n, start, q_input;
  output done;
  wire   N34, N35, N36, N37, N38, N39, N40, N41, N63, N64, N65, n110, n111,
         n112, n113, n114, n115, n116, n117, n118, n119, n120, n121, n122,
         n123, n124, n125, n126, n127, n128, n287, n289, n293, n285, n291,
         n290, n286, n288, n292, n294, n148, n149, n165, n166, n171, n204,
         n205, n206, n207, n208, n209, n210, n211, n212, n213, n214, n215,
         n216, n217, n218, n219, n220, n221, n222, n223, n224, n226, n227,
         n228, n229, n230, n231, n232, n233, n234, n235, n236, n237, n238,
         n239, n240, n241, n242, n243, n244, n245, n246, n247, n248, n249,
         n250, n252, n253, n254, n255, n256, n257, n258, n259, n260, n261,
         n262, n264, n266, n268, n269, n270, n271, n273, n274, n275, n281,
         n283, n284;
  wire   [4:0] addr_h_u;
  wire   [3:0] addr_o_u;
  wire   [3:0] state;
  wire   [3:0] nxt_state;
  wire   [4:2] \add_77/carry ;
  wire   [9:2] \add_66/carry ;

  DFCNQD1BWP \state_reg[0]  ( .D(nxt_state[0]), .CP(clk), .CDN(n283), .Q(
        state[0]) );
  DFCNQD1BWP \addr_h_u_reg[2]  ( .D(n112), .CP(clk), .CDN(n284), .Q(
        addr_h_u[2]) );
  DFCNQD1BWP \addr_h_u_reg[3]  ( .D(n111), .CP(clk), .CDN(n284), .Q(
        addr_h_u[3]) );
  DFCNQD1BWP \addr_h_u_reg[4]  ( .D(n110), .CP(clk), .CDN(n283), .Q(
        addr_h_u[4]) );
  DFCNQD1BWP \state_reg[2]  ( .D(nxt_state[2]), .CP(clk), .CDN(n283), .Q(
        state[2]) );
  DFCNQD1BWP \state_reg[3]  ( .D(nxt_state[3]), .CP(clk), .CDN(n283), .Q(
        state[3]) );
  DFCNQD1BWP \addr_o_u_reg[0]  ( .D(n127), .CP(clk), .CDN(n283), .Q(
        addr_o_u[0]) );
  DFCNQD1BWP \addr_o_u_reg[1]  ( .D(n128), .CP(clk), .CDN(n283), .Q(
        addr_o_u[1]) );
  DFCNQD1BWP \addr_o_u_reg[2]  ( .D(n126), .CP(clk), .CDN(n283), .Q(
        addr_o_u[2]) );
  DFCNQD1BWP \addr_o_u_reg[3]  ( .D(n125), .CP(clk), .CDN(n283), .Q(
        addr_o_u[3]) );
  DFCNQD1BWP \addr_input_unit_reg[1]  ( .D(n124), .CP(clk), .CDN(n284), .Q(
        n293) );
  DFCNQD1BWP \addr_input_unit_reg[0]  ( .D(n123), .CP(clk), .CDN(n284), .Q(
        n294) );
  DFCNQD1BWP \addr_input_unit_reg[2]  ( .D(n122), .CP(clk), .CDN(n284), .Q(
        n292) );
  DFCNQD1BWP \addr_input_unit_reg[3]  ( .D(n121), .CP(clk), .CDN(n284), .Q(
        n291) );
  DFCNQD1BWP \addr_input_unit_reg[8]  ( .D(n116), .CP(clk), .CDN(n284), .Q(
        n286) );
  DFCNQD1BWP \addr_input_unit_reg[9]  ( .D(n115), .CP(clk), .CDN(n284), .Q(
        n285) );
  DFCNQD1BWP \addr_input_unit_reg[7]  ( .D(n117), .CP(clk), .CDN(rst_n), .Q(
        n287) );
  AO221D1BWP U151 ( .A1(n226), .A2(n227), .B1(n228), .B2(n229), .C(n230), .Z(
        nxt_state[3]) );
  NR3D2BWP U170 ( .A1(n241), .A2(state[0]), .A3(n274), .ZN(n229) );
  AO22D1BWP U191 ( .A1(addr_h_u[2]), .A2(n209), .B1(N64), .B2(n208), .Z(n112)
         );
  AO22D1BWP U192 ( .A1(addr_h_u[3]), .A2(n209), .B1(N65), .B2(n208), .Z(n111)
         );
  AOI32D2BWP U196 ( .A1(n234), .A2(n212), .A3(n171), .B1(n257), .B2(state[3]), 
        .ZN(n244) );
  OR2D1BWP U197 ( .A1(n227), .A2(state[2]), .Z(n257) );
  DFCND1BWP \addr_h_u_reg[1]  ( .D(n114), .CP(clk), .CDN(n283), .Q(n148), .QN(
        n165) );
  DFCND1BWP \addr_h_u_reg[0]  ( .D(n113), .CP(clk), .CDN(n283), .Q(n149), .QN(
        n166) );
  HA1D0BWP U270 ( .A(addr_h_u[3]), .B(\add_77/carry [3]), .CO(
        \add_77/carry [4]), .S(N65) );
  HA1D0BWP U269 ( .A(n148), .B(n149), .CO(\add_77/carry [2]), .S(N63) );
  HA1D0BWP U268 ( .A(addr_h_u[2]), .B(\add_77/carry [2]), .CO(
        \add_77/carry [3]), .S(N64) );
  HA1D0BWP \add_66/U1_1_8  ( .A(n286), .B(\add_66/carry [8]), .CO(
        \add_66/carry [9]), .S(N41) );
  HA1D0BWP \add_66/U1_1_7  ( .A(n287), .B(\add_66/carry [7]), .CO(
        \add_66/carry [8]), .S(N40) );
  HA1D0BWP \add_66/U1_1_3  ( .A(n291), .B(\add_66/carry [3]), .CO(
        \add_66/carry [4]), .S(N36) );
  HA1D0BWP \add_66/U1_1_2  ( .A(n292), .B(\add_66/carry [2]), .CO(
        \add_66/carry [3]), .S(N35) );
  HA1D0BWP \add_66/U1_1_1  ( .A(addr_input_unit[1]), .B(addr_input_unit[0]), 
        .CO(\add_66/carry [2]), .S(N34) );
  HA1D0BWP \add_66/U1_1_6  ( .A(addr_input_unit[6]), .B(\add_66/carry [6]), 
        .CO(\add_66/carry [7]), .S(N39) );
  HA1D0BWP \add_66/U1_1_4  ( .A(addr_input_unit[4]), .B(\add_66/carry [4]), 
        .CO(\add_66/carry [5]), .S(N37) );
  HA1D0BWP \add_66/U1_1_5  ( .A(addr_input_unit[5]), .B(\add_66/carry [5]), 
        .CO(\add_66/carry [6]), .S(N38) );
  DFCND1BWP \state_reg[1]  ( .D(nxt_state[1]), .CP(clk), .CDN(n283), .Q(n274), 
        .QN(n171) );
  DFCNQD1BWP \addr_input_unit_reg[4]  ( .D(n120), .CP(clk), .CDN(n284), .Q(
        n290) );
  DFCNQD1BWP \addr_input_unit_reg[6]  ( .D(n118), .CP(clk), .CDN(n284), .Q(
        n288) );
  DFCNQD1BWP \addr_input_unit_reg[5]  ( .D(n119), .CP(clk), .CDN(n284), .Q(
        n289) );
  INR2D1BWP U230 ( .A1(state[2]), .B1(state[3]), .ZN(n226) );
  INR3D0BWP U231 ( .A1(n226), .B1(n171), .B2(state[0]), .ZN(n235) );
  ND4D1BWP U232 ( .A1(addr_h_u[4]), .A2(addr_h_u[3]), .A3(n258), .A4(
        addr_h_u[2]), .ZN(n232) );
  AN2XD1BWP U233 ( .A1(n270), .A2(n261), .Z(n259) );
  AN2XD1BWP U234 ( .A1(n274), .A2(n212), .Z(n260) );
  AN2XD1BWP U235 ( .A1(n268), .A2(n269), .Z(n261) );
  CKND0BWP U236 ( .I(n289), .ZN(n262) );
  CKND12BWP U237 ( .I(n262), .ZN(addr_input_unit[5]) );
  CKND0BWP U238 ( .I(n288), .ZN(n264) );
  CKND12BWP U239 ( .I(n264), .ZN(addr_input_unit[6]) );
  CKND0BWP U240 ( .I(n290), .ZN(n266) );
  CKND12BWP U241 ( .I(n266), .ZN(addr_input_unit[4]) );
  CKND0BWP U242 ( .I(addr_input_unit[5]), .ZN(n268) );
  CKND0BWP U243 ( .I(addr_input_unit[4]), .ZN(n269) );
  CKND0BWP U244 ( .I(addr_input_unit[6]), .ZN(n270) );
  INVD1BWP U245 ( .I(n293), .ZN(n271) );
  CKND12BWP U246 ( .I(n271), .ZN(addr_input_unit[1]) );
  CKND2D0BWP U247 ( .A1(addr_input_unit[0]), .A2(addr_input_unit[1]), .ZN(n253) );
  CKND12BWP U248 ( .I(n273), .ZN(done) );
  CKND0BWP U249 ( .I(n241), .ZN(n275) );
  ND2D1BWP U250 ( .A1(n275), .A2(n260), .ZN(n273) );
  CKND12BWP U251 ( .I(n220), .ZN(addr_input_unit[2]) );
  INVD1BWP U252 ( .I(n292), .ZN(n220) );
  CKND12BWP U253 ( .I(n221), .ZN(addr_input_unit[3]) );
  INVD1BWP U254 ( .I(n291), .ZN(n221) );
  CKND12BWP U255 ( .I(n222), .ZN(addr_input_unit[8]) );
  INVD1BWP U256 ( .I(n286), .ZN(n222) );
  CKND12BWP U257 ( .I(n224), .ZN(addr_input_unit[7]) );
  INVD1BWP U258 ( .I(n287), .ZN(n224) );
  CKND12BWP U259 ( .I(n223), .ZN(addr_input_unit[9]) );
  INVD1BWP U260 ( .I(n285), .ZN(n223) );
  OAI32D0BWP U261 ( .A1(n219), .A2(n285), .A3(n206), .B1(n250), .B2(n223), 
        .ZN(n115) );
  ND4D1BWP U262 ( .A1(n285), .A2(n224), .A3(n259), .A4(n252), .ZN(n240) );
  INVD1BWP U263 ( .I(n294), .ZN(n281) );
  CKND12BWP U264 ( .I(n281), .ZN(addr_input_unit[0]) );
  MOAI22D0BWP U265 ( .A1(addr_input_unit[0]), .A2(n206), .B1(
        addr_input_unit[0]), .B2(n207), .ZN(n123) );
  AO22D0BWP U266 ( .A1(addr_input_unit[1]), .A2(n207), .B1(N34), .B2(n248), 
        .Z(n124) );
  AO22D0BWP U267 ( .A1(n207), .A2(addr_input_unit[5]), .B1(N38), .B2(n248), 
        .Z(n119) );
  AO22D0BWP U271 ( .A1(n207), .A2(addr_input_unit[4]), .B1(N37), .B2(n248), 
        .Z(n120) );
  AO22D0BWP U272 ( .A1(n207), .A2(addr_input_unit[6]), .B1(N39), .B2(n248), 
        .Z(n118) );
  ND3D1BWP U273 ( .A1(state[0]), .A2(n171), .A3(n226), .ZN(n236) );
  ND3D1BWP U274 ( .A1(n171), .A2(n212), .A3(n226), .ZN(n231) );
  NR2XD0BWP U275 ( .A1(state[2]), .A2(state[3]), .ZN(n234) );
  NR4D0BWP U276 ( .A1(n218), .A2(n215), .A3(addr_o_u[1]), .A4(addr_o_u[2]), 
        .ZN(n228) );
  INVD1BWP U277 ( .I(n249), .ZN(n207) );
  INVD1BWP U278 ( .I(n255), .ZN(n208) );
  INVD1BWP U279 ( .I(n248), .ZN(n206) );
  INVD1BWP U280 ( .I(n254), .ZN(n209) );
  INR2XD2BWP U281 ( .A1(n240), .B1(n239), .ZN(n248) );
  MOAI22D0BWP U282 ( .A1(n222), .A2(n249), .B1(N41), .B2(n248), .ZN(n116) );
  MOAI22D0BWP U283 ( .A1(n249), .A2(n224), .B1(N40), .B2(n248), .ZN(n117) );
  AOI22D1BWP U284 ( .A1(n215), .A2(n229), .B1(n205), .B2(n244), .ZN(n243) );
  INVD1BWP U285 ( .I(n229), .ZN(n205) );
  MOAI22D0BWP U286 ( .A1(n221), .A2(n249), .B1(N36), .B2(n248), .ZN(n121) );
  MOAI22D0BWP U287 ( .A1(n220), .A2(n249), .B1(N35), .B2(n248), .ZN(n122) );
  AOI31D1BWP U288 ( .A1(n234), .A2(n212), .A3(n274), .B(n235), .ZN(n237) );
  ND2D1BWP U289 ( .A1(n244), .A2(n239), .ZN(n249) );
  OAI221D1BWP U290 ( .A1(n228), .A2(n205), .B1(n231), .B2(n232), .C(n233), 
        .ZN(nxt_state[2]) );
  AOI211XD0BWP U291 ( .A1(n234), .A2(n227), .B(n210), .C(n235), .ZN(n233) );
  IOA21D1BWP U292 ( .A1(n231), .A2(n236), .B(n232), .ZN(n255) );
  INVD1BWP U293 ( .I(n244), .ZN(n211) );
  ND3D1BWP U294 ( .A1(n236), .A2(n231), .A3(n244), .ZN(n254) );
  NR3D0BWP U295 ( .A1(n274), .A2(n241), .A3(n212), .ZN(n230) );
  INVD1BWP U296 ( .I(n236), .ZN(n210) );
  OAI211D1BWP U297 ( .A1(n232), .A2(n236), .B(n237), .C(n238), .ZN(
        nxt_state[1]) );
  IAO21D0BWP U298 ( .A1(n239), .A2(n240), .B(n230), .ZN(n238) );
  NR4D0BWP U299 ( .A1(n253), .A2(n220), .A3(n222), .A4(n221), .ZN(n252) );
  AOI21D1BWP U300 ( .A1(n248), .A2(n219), .B(n207), .ZN(n250) );
  INVD1BWP U301 ( .I(\add_66/carry [9]), .ZN(n219) );
  NR2XD0BWP U302 ( .A1(n166), .A2(n165), .ZN(n258) );
  ND3D1BWP U303 ( .A1(state[0]), .A2(n171), .A3(n234), .ZN(n239) );
  CKND1BWP U304 ( .I(state[0]), .ZN(n212) );
  OAI32D1BWP U305 ( .A1(n217), .A2(addr_o_u[3]), .A3(n245), .B1(n247), .B2(
        n218), .ZN(n125) );
  AOI21D1BWP U306 ( .A1(n229), .A2(n217), .B(n246), .ZN(n247) );
  INVD1BWP U307 ( .I(addr_o_u[2]), .ZN(n217) );
  OAI32D1BWP U308 ( .A1(n205), .A2(addr_o_u[1]), .A3(n215), .B1(n243), .B2(
        n216), .ZN(n128) );
  INVD1BWP U309 ( .I(addr_o_u[1]), .ZN(n216) );
  OAI32D1BWP U310 ( .A1(n211), .A2(n229), .A3(n215), .B1(addr_o_u[0]), .B2(
        n205), .ZN(n127) );
  OAI32D1BWP U311 ( .A1(n213), .A2(addr_h_u[4]), .A3(n255), .B1(n256), .B2(
        n214), .ZN(n110) );
  INVD1BWP U312 ( .I(addr_h_u[4]), .ZN(n214) );
  AOI21D1BWP U313 ( .A1(n208), .A2(n213), .B(n209), .ZN(n256) );
  INVD1BWP U314 ( .I(\add_77/carry [4]), .ZN(n213) );
  ND3D1BWP U315 ( .A1(n229), .A2(addr_o_u[0]), .A3(addr_o_u[1]), .ZN(n245) );
  INVD1BWP U316 ( .I(addr_o_u[0]), .ZN(n215) );
  IND2D1BWP U317 ( .A1(state[2]), .B1(state[3]), .ZN(n241) );
  OAI21D1BWP U318 ( .A1(addr_o_u[1]), .A2(n205), .B(n243), .ZN(n246) );
  ND4D1BWP U319 ( .A1(n205), .A2(n206), .A3(n231), .A4(n242), .ZN(nxt_state[0]) );
  AOI221D1BWP U320 ( .A1(start), .A2(n211), .B1(n210), .B2(n232), .C(n204), 
        .ZN(n242) );
  INVD1BWP U321 ( .I(n237), .ZN(n204) );
  MOAI22D0BWP U322 ( .A1(addr_o_u[2]), .A2(n245), .B1(n246), .B2(addr_o_u[2]), 
        .ZN(n126) );
  NR2XD0BWP U323 ( .A1(n212), .A2(n171), .ZN(n227) );
  MOAI22D0BWP U324 ( .A1(n166), .A2(n254), .B1(n208), .B2(n166), .ZN(n113) );
  MOAI22D0BWP U325 ( .A1(n165), .A2(n254), .B1(N63), .B2(n208), .ZN(n114) );
  INVD1BWP U326 ( .I(addr_o_u[3]), .ZN(n218) );
  CKBD2BWP U327 ( .I(rst_n), .Z(n283) );
  CKBD2BWP U328 ( .I(rst_n), .Z(n284) );
  TIELBWP U329 ( .ZN(digit[3]) );
  TIELBWP U330 ( .ZN(digit[2]) );
  TIELBWP U331 ( .ZN(digit[1]) );
  TIELBWP U332 ( .ZN(digit[0]) );
endmodule

