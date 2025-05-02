---
title: "从GitHub到CNB：代码提交的更优选择"
draft: true
---

## 前言

自从上一台美国服务器到期后，我就几乎没有在管过我的各种web服务，以至于我DNS提供商还托管着我将近100+之前服务器的解析

![](images/image.png)

![](images/image-1.png)

在3月我又续费了我的域名，所以就想着修复我的各种Web服务，现在也将主要的服务修复

但是我的[WEB首页](https://www.sdcom.asia/)不想托管在服务器上面，所以我就想到了GitHub推出的一项免费服务：[GitHub Pages](https://pages.github.com/)

那段时间我使用的操作系统是[FydeOS](https://fydeos.com/)，在Linux子系统里面安装了VS Code，虽说能够正常的使用本地功能，但是无法正常的使用[GitHub Codespaces](https://docs.github.com/zh/codespaces/about-codespaces/what-are-codespaces)，但是[CNB](https://sdcom.cnstlapy.cn/493.html)却能正常的连接以及工作，所以我就想到了通过将代码推送至CNB，再由CNB推送到GitHub

（现在，GitHub的访问也变得极其不方便，被国内的多数运营商屏蔽，本人云南移动，已经被屏蔽，解析至127.0.0.1）

![](images/1.gif)

## 实现

**_注：该方法由CNB插件：[https://cnb.cool/cnb/plugins/tencentcom/git-sync](https://cnb.cool/cnb/plugins/tencentcom/git-sync) 实现_**

### 准备工作

首先，你需要创建一个密钥仓库、一个待同步仓库、另外一个Git平台的仓库、GitHub token或CNB token

### 密钥仓库的创建

进入创建仓库的页面

![](images/image-2.png)

注意这一步的公开性需要修改为**“密钥仓库”**

![](images/image-3.png)

![](images/image-4.png)

到这里，你就成功的创建了一个属于你自己的密钥仓库

### GitHub token创建

进入[https://github.com/settings/tokens](https://github.com/settings/tokens)

点击`Generate new token`，再点击`Generate new token`(classic)

![](images/image-7.png)

按照提示通过安全认证

按照图片来进行创建，只用勾选repo即可

![](images/image-8.png)

保留好创建的密钥

![](images/image-9.png)

### 密钥仓库操作

在密钥仓库新建文件，文件命名为`xxx.yml`（xxx为自己填写）

在下方输入如下代码

```
GIT_USERNAME: SDCOM-0415    # 自己GitHub的用户名 
GIT_ACCESS_TOKEN: ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx      # 刚刚创建的token
```

![](images/image-10.png)

### 待同步仓库操作

这个仓库，就是我们需要同步的仓库

![](images/image-5.png)
