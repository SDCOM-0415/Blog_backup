---
title: "macOS terminal - 让终端使用代理的方法（以Clash Verge配合举例）"
date: 2024-05-26
---

## 前言

最近，[nezha探针](http://nezha.wiki)面板更新了在macOS 上一键安装 Agent(nezha被控端)，而我，是一个黑苹果用户，所以就想着绑定在nezha探针上，在这之前，你只能通过launchd（作者根本没有尝试成功过）或者手动运行Agent二进制文件绑定至Dashboard(前端)（直接运行二进制文件还必须保持终端窗口运行，利用nohup的话还必须是root用户）

更新后，服务器管理页面多出了一个Apple 的图标，这就意味着在macOS上可以像Windows或者Linux那样一键安装了

![](images/16_56_20_202405261656562.png)

但是，当我满怀欣喜的运行时，却没有办法来正常的运行

![](images/16_58_7_202405261658921.png)

这是因为我们在国内，没有办法来流畅链接GitHub，虽然我们能使用代理，不过终端显然不认，所以就有了这一篇文章

而且对于大多数开发者而言，时常需要使用到 Git 同步仓库，以及一系列需要使用终端命令行的地方。**这时候给macOS 终端配置代理则变得非常有必要，随时启用代理访问或关闭。**只需简单3步即可搞定。

## 准备工作

### 查看代理软件端口

![](images/17_4_15_202405261704281.png)

## 开始配置

### 方法1

**默认大家的终端使用的是[zsh](https://zh.wikipedia.org/zh-tw/Z_shell)（如果你的mac不是太老旧且OS版本不是很久不更新的话，应该就是zsh）**

1.打开终端App，输入如下代码，回车

```
vi ~/.zshrc 
或 
vi ~/.bash_profile
```

2.打开 `~/.zshrc`或`~/.bash_profile` 后，滑至末尾另起一行，按`i`进入编辑模式并粘贴如下代码

（其中alias proxy的`proxy`与`unproxy`可以修改成你喜欢的代称）

```
alias proxy="
    export http_proxy=socks5://127.0.0.1:7897;
    export https_proxy=socks5://127.0.0.1:7897;
    export all_proxy=socks5://127.0.0.1:7897;
    export no_proxy=socks5://127.0.0.1:7897;
    export HTTP_PROXY=socks5://127.0.0.1:7897;
    export HTTPS_PROXY=socks5://127.0.0.1:7897;
    export ALL_PROXY=socks5://127.0.0.1:7897;
    export NO_PROXY=socks5://127.0.0.1:7897;"
alias unproxy="
    unset http_proxy;
    unset https_proxy;
    unset all_proxy;
    unset no_proxy;
    unset HTTP_PROXY;
    unset HTTPS_PROXY;
    unset ALL_PROXY;
    unset NO_PROXY"
```

![](images/17_14_42_202405261714015.png)

粘贴成功后，确保处于终端App窗口且已激活当前窗口；按键盘左上角`**esc**`，输入法切换至英文(abc)模式，输入`:wq!`，回车（跟Linux 终端命令行一模一样...）

![](images/17_15_42_202405261715142.png)

![](images/17_16_0_202405261716971.png)

3.使用 .zshrc

```
source ~/.zshrc
或
source ~/.bash_profile 
```

4.测试 proxy 效果

```
curl ip.sb
2409:****:****:****:****:****:****:***   # 无代理IP地址

proxy   #使用代理
curl ip.sb
178.173.236.224   # 代理服务器IP地址
```

![](images/17_21_31_202405261721547.png)

5.取消代理

```
unproxy
```

### 方法2

代理软件开放端口请自行查阅（参阅本文：**查看代理软件端口**部分），本例仍以端口7897为例

打开终端，输入以下代码即可完成代理配置

```
cat >> ~/.bash_profile << EOF
function proxy_on() {
    export http_proxy=http://127.0.0.1:7897
    export https_proxy=\$http_proxy
    echo -e "终端代理已开启。"
}

function proxy_off(){
    unset http_proxy https_proxy
    echo -e "终端代理已关闭。"
}
EOF

source ~/.bash_profile
```

同方法1：启用则使用命令

```
proxy_on
```

取消则使用

```
proxy_off
```

### 方法3

将代理软件**Tun模式**打开(只有部分软件有**Tun模式**，不推荐使用)

![](images/17_24_52_202405261724698.png)

## 结尾

还是部署在我的黑苹果上面成功的部署了nezha\_Agent，本次文章的难度远没有其他文章的难度高，已经算很方便的了，还是感谢[nezha](https://github.com/nezhahq/)这个项目的开发人员吧

![](images/0_10_24_17_27_3_telegram-cloud-photo-size-5-6239739405891910715-x.png)

![](images/17_28_56_202405261728896.png)
