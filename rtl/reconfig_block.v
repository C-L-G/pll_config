/**********************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
descript:
author : Young
Version: VERA.0.0
creaded: 2016/6/22 下午5:42:57
madified:
***********************************************/
`timescale 1ns/1ps
module reconfig_block (
    input               scan_clk            ,
    input               scan_rst_n          ,
    input               conf_req            ,
    input [17:0]        clock_0_conf        ,
    input [17:0]        clock_1_conf        ,
    input [17:0]        clock_2_conf        ,
    input [17:0]        clock_3_conf        ,
    input [17:0]        clock_4_conf        ,
    input [17:0]        M_config            ,
    input [17:0]        N_config            ,

    output              to_pll_scan_clk     ,
    output              to_pll_scan_ena     ,
    output              to_pll_scan_data    ,
    output              to_pll_rst          ,
    output              to_pll_update

);


reg [17:0]      clk0_conf;
reg [17:0]      clk1_conf;
reg [17:0]      clk2_conf;
reg [17:0]      clk3_conf;
reg [17:0]      clk4_conf;

reg [17:0]      N_conf;
reg [17:0]      M_conf;

wire[17:0]      head_conf    ;

localparam [2:0]    Charge_Pump_Current  = 1;
localparam [0:0]    VCO_Post_Scale       = 0;
localparam [4:0]    Loop_Filter_Resistance  = 27;
localparam [1:0]    Loop_Filter_Capacitance = 0;

assign head_conf    = {2'b00,Loop_Filter_Capacitance,Loop_Filter_Resistance,VCO_Post_Scale,5'b00000,Charge_Pump_Current};

localparam     LEN = 144+1;

wire[LEN-1:0]   scan_data    ;
reg [7:0]       scan_addr   ;


assign scan_data = {head_conf,M_conf,N_conf[17:0],clk0_conf,clk1_conf,clk2_conf,clk3_conf,clk4_conf,1'b0};


always@(posedge scan_clk,negedge scan_rst_n)begin
    if(~scan_rst_n)begin
        clk0_conf   <= 18'h2_0000;
        clk1_conf   <= 18'h2_0000;
        clk2_conf   <= 18'h2_0000;
        clk3_conf   <= 18'h2_0000;
        clk4_conf   <= 18'h2_0000;
        N_conf      <= 18'h2_0000;
        M_conf      <= 18'h2_0000;
    end else begin
        clk0_conf   <= clock_0_conf ;
        clk1_conf   <= clock_1_conf ;
        clk2_conf   <= clock_2_conf ;
        clk3_conf   <= clock_3_conf ;
        clk4_conf   <= clock_4_conf ;
        N_conf      <= M_config     ;
        M_conf      <= N_config     ;
end end

reg [2:0]       nstate,cstate;
localparam      IDLE        = 3'd0  ,
                START_CONF  = 3'd1  ,
                CONF_DONE   = 3'd2  ,
                UPDATE      = 3'd3  ,
                LAT_1       = 3'd4  ,
                PRESET      = 3'd5  ;

always@(posedge scan_clk,negedge scan_rst_n)
    if(~scan_rst_n) cstate      <= IDLE;
    else            cstate      <= nstate;

reg     conf_cnt_end;
reg     update_done;
always@(*)
    case(cstate)
    IDLE:
        if(conf_req)
                nstate = START_CONF;
        else    nstate = IDLE;
    START_CONF:
        if(conf_cnt_end)
                nstate = CONF_DONE;
        else    nstate = START_CONF;
    CONF_DONE:  nstate = UPDATE;
    UPDATE:
        if(update_done)
                nstate = LAT_1;
        else    nstate = UPDATE;
    LAT_1:      nstate = PRESET;
    PRESET:     nstate = IDLE;
    default:    nstate = IDLE;
    endcase

always@(posedge scan_clk,negedge scan_rst_n)
    if(~scan_rst_n)begin
            scan_addr       <= 8'd0;
            conf_cnt_end    <= 1'b0;
    end else begin
        case(nstate)
        START_CONF:begin
            if(scan_addr < (LEN-1) )
                    scan_addr       <= scan_addr + 1'b1;
            else    scan_addr       <= scan_addr;
            conf_cnt_end    <= scan_addr == (LEN-1);
        end
        default:begin
            scan_addr       <= 8'd0;
            conf_cnt_end    <= 1'b0;
        end
        endcase
    end

//----->> SCAN SIGNALS TO PLL <<------------------
reg     scan_out_data;

always@(posedge scan_clk,negedge scan_rst_n)
    if(~scan_rst_n)
            scan_out_data   <= 1'b0;
    else    scan_out_data   <= scan_data[scan_addr];


reg     scan_en_reg;

always@(posedge scan_clk,negedge scan_rst_n)
    if(~scan_rst_n)
            scan_en_reg <= 1'b0;
    else
        case(nstate)
        START_CONF:
            scan_en_reg <= 1'b1;
        default:
            scan_en_reg <= 1'b0;
        endcase

reg     scan_update_reg;
// assign  update_done     = scan_update_reg;
always@(posedge scan_clk,negedge scan_rst_n)
    if(~scan_rst_n)
            scan_update_reg <= 1'b0;
    else
        case(nstate)
        UPDATE:begin
            scan_update_reg <= 1'b1;
            update_done     <= scan_update_reg;
        end
        default:begin
            scan_update_reg <= 1'b0;
            update_done     <= 1'b0;
        end
        endcase

reg     pll_reset_reg;

always@(posedge scan_clk,negedge scan_rst_n)
    if(~scan_rst_n) pll_reset_reg   <= 1'b1;
    else
        case(nstate)
        PRESET:     pll_reset_reg   <= 1'b1;
        default:    pll_reset_reg   <= 1'b0;
        endcase

//-----<< SCAN SIGNALS TO PLL >>------------------

assign to_pll_scan_clk  = scan_clk;
assign to_pll_scan_ena  = scan_en_reg;
assign to_pll_scan_data = scan_out_data;
assign to_pll_update    = scan_update_reg;
assign to_pll_rst       = pll_reset_reg;

endmodule
