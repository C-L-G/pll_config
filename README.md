# altera 的 PLL 重配置模块

目前仅在 Cyclone IV上 测试，pll 为 short chain mode

1、PLL建议配置成 C0-C4口都使用

2、详细使用说明，请参考 pll_config_tb.sv 测试文件 

3、输出的频率 = 输入的频率x（Mult系数）÷ （Div系数）÷ （clock div 系数）÷ 2 ;;; 注意还要除二


--@--Young--@--

