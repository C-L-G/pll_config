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
module pll_config_tb;

bit         clk_100M = 0;
bit         rst_n = 0;
bit         update_req = 0;

always #5 clk_100M  = ~clk_100M;

initial begin
    repeat(10)
        @(posedge clk_100M);
    rst_n   = 1;
    repeat(1000)
        @(posedge clk_100M);
    update_req = 1;
    @(posedge clk_100M);
    update_req = 0;

    repeat(1000)
        @(posedge clk_100M);
    update_req = 1;
    @(posedge clk_100M);
    update_req = 0;

    repeat(1000)
        @(posedge clk_100M);
    update_req = 1;
    @(posedge clk_100M);
    update_req = 0;

end

wire    to_pll_scan_clk     ;
wire    to_pll_scan_ena     ;
wire    to_pll_scan_data    ;
wire    to_pll_rst          ;
wire    to_pll_update       ;
wire    from_pll_scan_done  ;

pll_config pll_config_inst(
/*   input       */      .clock               (clk_100M         ),
/*   input       */      .rst_n               (rst_n            ),
/*   input       */      .update_req          (update_req       ),
/*   input [7:0] */      .Mult                (10               ),
/*   input [7:0] */      .div                 (2                ),
/*   input [7:0] */      .clk0_div            (5                ),
/*   input [7:0] */      .clk1_div            (5                ),
/*   input [7:0] */      .clk2_div            (3                ),
/*   input [7:0] */      .clk3_div            (2                ),
/*   input [7:0] */      .clk4_div            (1                ),
/*   output      */      .to_pll_scan_clk     (to_pll_scan_clk  ),
/*   output      */      .to_pll_scan_ena     (to_pll_scan_ena  ),
/*   output      */      .to_pll_scan_data    (to_pll_scan_data ),
/*   output      */      .to_pll_rst          (to_pll_rst       ),
/*   input       */      .from_pll_scan_done  (from_pll_scan_done),
/*   output      */      .to_pll_update       (to_pll_update    )
);

dyn_pll dyn_pll_inst(
	.areset        (to_pll_rst             ),
	.configupdate  (to_pll_update          ),
	.inclk0        (clk_100M               ),
	.scanclk       (to_pll_scan_clk        ),
	.scanclkena    (to_pll_scan_ena        ),
	.scandata      (to_pll_scan_data       ),
	.c0            (                       ),
	.c1            (                       ),
	.c2            (                       ),
	.c3            (                       ),
	.c4            (                       ),
	.locked        (                       ),
	.scandataout   (                       ),
	.scandone      (                       )
);


endmodule
