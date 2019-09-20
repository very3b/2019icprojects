# 一.npn的放大倍数验证
## 1. 搭建电路
*   选取一个npn类目里的元件，常用_inh后缀的元件，无衬底端。在原理图中直接在BJT的BCE三个端口加上pin，如下图所示，再将这个通过creat-Cellview from Cellview将该电路建成一个可以调用的symbol。随后新建一个schematic，可做-testbench后缀，表示相当于一个外端的测试平台。调用刚建立的symbol后，在其前面添加理想电流源产生Ib，后面添加理想电压源做Vce.电路图如下所示：

![Alt text](https://github.com/eehyli/pictures/blob/master/symbol-testbench.png)

Ps.建立symbol后在新建的_testbench里再调用该“黑匣子”是通用方式。可以对同一个设计电路构建不同的外端测试工具来测试不同的性能参数。

## 2. Launch-ADE L仿真环境设置
*   按如下图添加变量，设置Ib为5uA，Analyses设置详情也如图 。表示要得到一个Vce作为横坐标从-1.2V到1.8V的范围内Ib的变化曲线

![Alt text](https://github.com/eehyli/pictures/blob/master/ADE%20L%E8%AE%BE%E7%BD%AE%E7%95%8C%E9%9D%A2.jpg)
![Alt text](https://github.com/eehyli/pictures/blob/master/Analyses%E8%AE%BE%E7%BD%AE%E7%95%8C%E9%9D%A2.jpg)

Ps.可以把上面的设置在Session中Save State，下次可以直接Load State。

## 3.扫参设置及结果示例
* 为了探究不同Ib值带来的Ic的变化，可以按如下步骤添加扫参变量。
![Alt text](https://github.com/eehyli/pictures/blob/master/%E6%89%AB%E5%8F%82%E8%AE%BE%E7%BD%AE%E7%95%8C%E9%9D%A2.jpg)

例如，选择ib后，输入Value为5u，From 0 投 30u，Steps 为16，这样可以得到步长为1uA的 Ib带来的多条变化曲线。

* 可得到如下结果：

![Alt text](https://github.com/eehyli/pictures/blob/master/%E7%BB%93%E6%9E%9C%E5%AE%9E%E4%BE%8B.jpg)

  从图中可以看到BJT的三个工作区域，并且可以计算出放大倍数。
