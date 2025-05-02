---
title: "学会这个操作，不支持的显卡也能装最新版macOS！"
date: 2023-08-13
---

## 前言

好久不见，这里是SDCOM的blog

在往期，我们教大家[在普通PC上安装了macOS](https://sdcom.cnstlapy.cn/index.php/2023/07/13/%e9%bb%91%e8%8b%b9%e6%9e%9c%e5%ae%89%e8%a3%85%e6%95%99%e7%a8%8b/)；也教大家[如何在低版本macOS如何安装要求高版本macOS的软件](https://sdcom.cnstlapy.cn/index.php/2023/07/26/macos%e7%b3%bb%e7%bb%9f%e8%bd%af%e4%bb%b6%e9%99%90%e5%88%b6-%e4%bd%8e%e7%89%88%e6%9c%acmacos%e5%a6%82%e4%bd%95%e5%ae%89%e8%a3%85%e8%a6%81%e6%b1%82%e9%ab%98%e7%89%88%e6%9c%acmacos%e7%9a%84%e8%bd%af/)。但是呢我收到一些反馈，表示想体验新版本，而且，通过修改软件的方法，会让软件变得更不安全，可能会损失一些功能；所以，高版本系统显得如此的重要，但是我们显卡是一个最大的瓶颈

苹果官方在macOS Monterey的版本中移除了对英伟达显卡的支持和驱动，所以在macOS Monterey以上的系统并不能免驱使用英伟达显卡

例如本人电脑显卡位英伟达GT720，在免驱的情况下，也只能安装Big Sur，就十分的苦恼

![](images/KYwftUVK.png)

所以，在这时候我们就需要用一些神奇的工具来让我们完美体验最新的macOS

_温馨提示：oclp可能会造成软件无法更新，无法正常使用，崩溃闪退等。**操作有风险，玩机需谨慎，教程仅供参考，操作具体情况请以个人设备为准！**_

## 安装

首先，你需要把机型修改为合适的版本；例如我就修改为了iMac2020版

![](images/jtmWqkp0.png)

然后查看系统更新，更新到macOS Ventura

更新完成进入macOS Ventura后，你会发现系统很卡，进入关于本机-图形卡一栏，会显示“显示器 7MB”

这时候你就需要给系统打上补丁，让显卡驱动起来

### 准备

首先准备一个macOS Ventura未驱动的英伟达开普勒核心的显卡的电脑，ResetNvramEntry.efi，oclp，以及ocat

下载链接：

oclp（OpenCore-Legacy-Patcher）：[官方GitHub](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) [下载站](https://dz.sdcom.asia/123pan/1/Apps/macOS/oclp)

ocat（OCAuxiliaryTools）：[官方GitHub](https://github.com/ic005k/OCAuxiliaryTools/releases) [蓝奏云](https://sdcom.lanzouy.com/b02310o8j)(密码:1234)

ResetNvramEntry.efi：[蓝奏云](https://sdcom.lanzouy.com/i4A0B15bikzg)

### 配置修改

首先打开ocat

点击上方同步按钮

![](images/1zu3DKYq.png)

点击同步最新，等待同步完毕

![](images/bXrvHAxt.png)

挂载efi分区，要求我们输入密码

![](images/kOJcsgm3.png)

![](images/WLJ9mYEC.png)

挂载完毕，打开efi分区的efi-oc-config

![](images/phO19r3w.gif)

点击侧边栏misc选项卡

![](images/zjsV7aoi.png)

点击上方安全选项卡，找到securebootmode，下拉改为disable

![](images/5AmOUkOl.png)

点击侧边栏nvram选项卡

![](images/qrOsO735.png)

点击“7C436110-AB2A-4BBB-A880-FE41995C9F82”，找到boot-args

在后方空格后输入amfi\_get\_out\_of\_my\_way=1

![](images/s2NKg3Xs.png)

点击csr-active-config，输入FF0F0000

![](images/C1eJiQyG.png)

点击侧边栏uefi选项卡，找到上方drivers将准备好的ResetNvramEntry.efi拖入并启用

点击上方按钮保存重启

![](images/1cQSVOyN.png)

### 关闭SIP

进入选择系统界面，单击空格

选择revercory进入，并等待读条完毕

点击上方栏-实用工具

打开终端

依次输入

csrutil disable

csrutil authenticated-root disable

点击左上角重启

进入系统，在关于本机中点击更多信息-系统报告-软件，查看“系统完整性保护”是否为已停用，若为已停用，则证明SIP完全关闭

![](images/xrmEGJEI.png)

![](images/UBMBeI3s.png)

![](images/MAarRinz.png)

### 安装补丁

再次进入选择系统界面，单击空格

选择resetnvram选项，等待重启

如果重启后进入windows，请重新在bios选择设置第一启动项为oc

选择进入macOS

打开oclp

点击post-install root patch

选择start root patching

等待补丁安装完毕

重启检查效果

## 结尾

到这里，我们就成功的在macOS不支持的显卡下成功打上补丁，正常使用不支持英伟达的macOS Ventura，各项功能也都正常，Metal也完美支持；这个项目也可以在不支持新版系统的Mac中，体验新的macOS，感兴趣的小伙伴可以去官方的GitHub看看

![](images/kSJ7lwYU.png)

温馨提示：oclp可能会造成软件无法更新，无法正常使用，崩溃闪退等。**操作有风险，玩机需谨慎，教程仅供参考，操作具体情况请以个人设备为准！**
