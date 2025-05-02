---
title: "随时随地写代码--基于Code-server部署自己的云开发环境"
date: 2024-05-01
---

## 前言

在平时的学习工作中，我们经常会用到代码编辑器，Vscode已经成为我们的首选。但是本地编辑器有个弊端就是当我们在家庭和公司之间移动的时候，无法连续编码。这个时候就有很多新兴的在线编辑器（web IDE）出现了，例如微软和 Github 的Visual Studio Codespaces、腾讯的cloudstudio、华为云 CloudIDE等，这些产品要么访问不方便，要么免费用会有限制或者价格不低，目前还不是非常方便

如果想要低成本愉快使用，自己来搭建一个是不错的方案。对配置要求不高的话，一年几十块一百多块就能买到廉价的 VPS 或者云主机。Web IDE 的部署方案推荐两个，code-server 和 Theia

### 在线编辑器的选择

[Code-server](https://github.com/coder/code-server)是由 Coder 开发的，把 VS Code 搬到了浏览器上

![](images/16_15_44_202405011615184.png)

[Theia](https://theia-ide.org/jectId=2064025)是 Eclipse 推出的云端和桌面 IDE 平台，完全开源。Theia 是基于 VS Code 开发的，它的模块化特性非常适合二次开发，比如华为云 CloudIDE、阿里云 Function Compute IDE 便是基于 Theia 开发

![](images/15_3_10_20240501150303.png)

据我体验下来，Code-server对插件的支持更为完备，并且安全性更高

## 安装code-server

[code-server](https://github.com/coder/code-server)一个开源的基于vscode开发的在线编辑器工具。其支持一键安装脚本部署、二进制部署、Docker部署、HemlChart部署，目前还不支持windows部署，但是已经足够我们使用了

具体部署可以参考[官方文档](https://coder.com/docs/code-server/latest/install)

这里我们选择相对简单快捷的方式，一键安装脚本部署

### 前置条件

在部署code-server前，你需要准备一台Linux系统的机器，尽量为Ubuntu，你可以去云厂商购买，也可以在个人电脑创建虚机来使用

### 初步安装

#### 安装依赖

##### 必备依赖和必备工具

Ubuntu或Debian：`sudo apt install curl wget vim clang gcc python -y`

CentOS：`yum install curl wget vim clang gcc python -y`

##### 安装nodejs

Ubuntu系统：  
`curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash sudo apt-get install -y nodejs`  
  
Debian系统，以root执行：  
`curl -sL https://deb.nodesource.com/setup_12.x | bash apt-get install -y nodejs`

CentOS：`yum install nodejs -y`

##### 安装yarn

`sudo npm install -g yarn`

#### 运行安装脚本

国外服务器：`curl -fsSL https://code-server.dev/install.sh | sh`

国内镜像源：`curl -fsSL https://gitcode.net/SDCOM_0415/img/-/raw/master/install.sh | sh`

运行后等待安装完成

安装完成后会有如下提示

![](images/15_38_6_202405011538476.png)

然后输入`sudo systemctl enable --now code-server@$USER`

若运行后出现`error listen EADDRINUSE: address already in use 127.0.0.1:8080`错误，可能是安装完后code-server立即就运行了，直接看下面编辑配置文件就行了，配置完再重启

![](images/15_39_11_20240501153910.png)

输入`vim ~/.config/code-server/config.yaml`

按`i`进入编辑模式，参考我的注释进行编辑，编辑完按`ESC`输入`:wq`（确保为英文冒号）

```
bind-addr: 127.0.0.1:8080    ##code-server服务器绑定的IP和端口，注意这个code-server只允许本地连接，因此建议把8080修改成其他端口例如2333，然后用Nginx反向代理
auth: password
password: 你的验证密码    ##这里输入你要为code-server设置的访问密码
cert: false    ##保持false，这个是自签证书，几乎所有的浏览器都不认这个
```

配置完后以后台方式运行服务器就行了`` `sudo systemctl enable --now code-server@$USER` ``

## 后续配置

### 设置中文

输入密码进入网页版vscode

![](images/16_9_41_202405011609367.png)

选择它来安装中文插件

![](images/16_11_43_202405011611676.png)

搜索chinese，选择简体中文并安装

![](images/16_13_13_202405011613995.png)

安装好后选择`Change Language and Restart`

![](images/16_14_50_202405011614685.png)

这样，就中文就修改好了

![](images/16_15_44_202405011615184.png)

### 反向代理

#### 宝塔反向代理法：

进入宝塔：

![](images/16_20_28_202405011620516.png)

输入一个你喜欢的域名

![](images/16_25_21_202405011625980.png)

进入设置页选`反向代理-添加反向代理`

![](images/16_26_46_202405011626762.png)

然后根据图片来

![](images/16_30_5_202405011630520.png)

然后访问测试即可

**注意:如果是用宝塔，最好将对于静态文件的规则注释掉**

![](images/16_33_23_202405011633253.png)

#### Nginx原生反向代理法：

安装Nginx (如果已经安装过的跳过即可)

`apt install nginx -y`

移除默认网站配置

`rm /etc/nginx/sites-enabled/default`

开始为code-server配置反代：

`vim /etc/nginx/sites-available/code-server`

`i`进入编辑模式输入以下内容

```
server {
       ##外网访问端口
       listen 8080;
       ##服务器域名，在没有域名、只在局域网内访问的情况下，就填_就行了
       server_name _;

       ##地址，如果需要重定向请自己配置，这里直接以根目录开始
       location / {
        ##本地code-server的端口
        proxy_pass http://localhost:2333/;
        ##必要的头设置
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection upgrade;
        proxy_set_header Accept-Encoding gzip;
        }
}
```

按`ESC`后`:wq`保存退出，链接至sites-enabled使配置文件生效

`ln -s /etc/nginx/sites-available/code-server /etc/nginx/sites-enabled/`

重新载入nginx配置即可

`nginx -s reload`

### 内置的python没有pip3解决方法

#### 原因

这是因为code-server专注于编辑器而对语言本身稍有忽略，比如其内置的python没有pip3工具，需要自己安装；而且内置的deb源速度较慢，需要自行替换

#### 修改deb源

因为自带的vi不要用，所以我们使用以下方式修改deb源

1. 复制国内源地址到编辑器的文件`aaa`中

3. 使用命令 `cat aaa > /etc/apt/sources.list`

5. 使用命令`apt update`更新源

#### 安装pip3

在完成了修改deb源和更新deb源之后，我们就可以使用命令`apt install python3-pip`来安装pip3了

安装完成后，你就可以安装你所需要的库了

## 结尾

至此，你就成功的部署了code-server，接下来访问`http://服务器IP:你设置的端口`或你反代的域名

输入密码后进入网页版vscode开始code anywhere吧！
