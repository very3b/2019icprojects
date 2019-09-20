# Step1.MobaXterm上配置VCN端口

 1.Open MobaXterm，click New session--SHH，在Remote host中输入10.20.20.46
 
 2.依次输入如下指令,每输入一个指令都按回车键：“10.20.20.46”，“123sustc”，"vi .cshrc"，"vncs", 自动创建端口n。
 
 3.打开vncs，输入server address：10.20.20.46：n，输入统一密码即可登陆。


# Step2.VNC平台打开cadence

 1.右键Open the terminal--> 输入指令"cd /app/proj/++yourusername++/8xp" 回车----> "source cshrc_8xp" ------> "virtuoso &"
 
 2.要打开一个Library列表里包含 bicmos8hp 的PDK文件才算能正常使用cadence！新建Library时， 记得Attach to an existing technology library，在lib里可新建schematic&layout。新建后可以重新打开一下cadence查看是否能同时打开包含bicmos8hp和自己新建的lib。

# Step3.配置DRC和LVS文件
 1.按如下图选择文件，具体为“/app/eda/pdk/8XP/PDK_130HPSIGE-8XP_V1.8_4/DesignEnv_VirtuosoOA/DRC/Assura/drc.rul”
![Alt text](https://github.com/eehyli/pictures/blob/master/Assura.DRC.setup.jpg)

 2.Save state,自己命名，下次可直接Load state来进行DRC。
 
 3.按如下图选择文件，进行LVS，依旧save state。
