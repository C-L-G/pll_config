# altera 的 PLL 重配置模块

目前仅在 Cyclone IV上 测试，pll 为 short chain mode

1、PLL建议配置成 C0-C4口都使用

2、PLL的乘系数和除系数需配置成偶数，这个不是我先的模块问题，Altera PLL IP 就是这个干的，我还怀疑测试了很久

3、详细使用说明，请参考 pll_config_tb.sv 测试文件 


--@--Young--@--
