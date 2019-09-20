# The key point about BJT
## The structure
* 为了便于理解IC中BJT的实现与设计，可以从下图的简单截面图中理解BJT的NPN结构。
![Alt text](structure.png)

* 我们用到的SiiGe工艺是用到213的六层金属工艺，具体的层介绍如下图：
![Alt text](213metallayer.png)

*  每一层的层厚也需要注意，具体如下：
![Alt text](thickness.png)

## Layout-cadence
* 工艺中用到的NPN器件的性能参数如图，分为HP 和 HB两种：
![Alt text](HPnpn.png)
![Alt text](HBnpn.png)

*  cadence中观察到有如下六中BJT的layout结构，我将其分成两大类，一类直接CBE结构，一类有对称的C-B。如下图所示
![Alt text](NPN.png)

* 当我们探究工艺中具体用到的层时，可能需要了解下列Mask的含义与作用。
![Alt text](intro-mask.png)


## Principles about BJT
* BJT的工作原理简介：
![Alt text](workingregion.png)