/**********************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
descript:
author : Young
Version: VERA.0.0
creaded: 2016/6/23 上午11:18:42
madified:
***********************************************/
`timescale 1ns/1ps
module pll_config (
    input               clock               ,
    input               rst_n               ,
    input               update_req          ,
    input [7:0]         Mult                ,
    input [7:0]         div                 ,
    input [7:0]         clk0_div            ,
    input [7:0]         clk1_div            ,
    input [7:0]         clk2_div            ,
    input [7:0]         clk3_div            ,
    input [7:0]         clk4_div            ,

    output              to_pll_scan_clk     ,
    output              to_pll_scan_ena     ,
    output              to_pll_scan_data    ,
    output              to_pll_rst          ,
    input               from_pll_scan_done  ,
    output              to_pll_update
);


reconfig_block reconfig_block_inst(
/*  input         */    .scan_clk            (clock                          ),
/*  input         */    .scan_rst_n          (rst_n                          ),
/*  input         */    .conf_req            (update_req                     ),
/*  input [17:0]  */    .clock_0_conf        ({1'b0,clk0_div,1'b0,clk0_div}  /*18'h20000*/ ),
/*  input [17:0]  */    .clock_1_conf        ({1'b0,clk1_div,1'b1,clk1_div}  /*18'h20000*/ ),
/*  input [17:0]  */    .clock_2_conf        ({1'b0,clk2_div,1'b0,clk2_div}  /*18'h20000*/ ),
/*  input [17:0]  */    .clock_3_conf        ({1'b0,clk3_div,1'b0,clk3_div}  /*18'h20000*/ ),
/*  input [17:0]  */    .clock_4_conf        ({1'b0,clk4_div,1'b0,clk4_div}  /*18'h20000*/ ),
/*  input [17:0]  */    .M_config            ({1'b0,Mult[7:0],1'b0,Mult[7:0]}          /*18'h20000*/ ),
/*  input [17:0]  */    .N_config            ({1'b0, div[7:0],1'b0, div[7:0]}            /*18'h20000*/ ),
/*  output        */    .to_pll_scan_clk     (to_pll_scan_clk                ),
/*  output        */    .to_pll_scan_ena     (to_pll_scan_ena                ),
/*  output        */    .to_pll_scan_data    (to_pll_scan_data               ),
/*  output        */    .to_pll_rst          (to_pll_rst                     ),
/*  output        */    .to_pll_update       (to_pll_update                  )
);

endmodule
