| 序号  | 修改时间       | 修改内容                              | 修改人   | 审稿人 |
| --- | ---------- | --------------------------------- | ----- | --- |
| 1   | 2019-12-24 | 创建。从《CNCF原生框架分析》拆分。               | Keefe |     |
| 2   | 2020-1-11  | 更新容器使用经验。                         | 同上    |     |
| 3   | 2021-8-13  | 增加 harbor章节                       | 同上    |     |
| 4   | 2022-4-1   | 增加docker stack章节；更新docker swarm章节 | 同上    |     |
| 5   | 2022-4-26  | 增加nvidia-docker章节                 | 同上    |     |

<br><br><br>

---

目录

[TOC]

<br>

---

# 1 Docker简介

官网： http://www.docker.com

Docker 是 [PaaS](http://baike.baidu.com/view/1413359.htm) 提供商 dotCloud 于2013年开源的一个基于 [LXC](http://baike.baidu.com/view/6572152.htm) 的高级容器引擎，源代码托管在 [Github](http://baike.baidu.com/view/3366456.htm) 上, 基于[go语言](http://baike.baidu.com/view/2976233.htm)并遵从Apache2.0协议开源。

Docker 可以让开发者打包他们的应用以及依赖包到一个轻量级、可移植的容器中，然后发布到任何流行的 Linux 机器上，也可以实现虚拟化（操作系统层虚拟化）。

容器是完全使用沙箱机制，相互之间不会有任何接口（类似 iPhone 的 app）,更重要的是容器性能开销极低。

2017.3.2，docker正式宣布推出企业版EE，原先的docker开源免费版本更名为社区版CE。

**Docker的应用场景**

* Web 应用的自动化打包和发布。
* 自动化测试和持续集成、发布。
* 在服务型环境中部署和调整数据库或其他的后台应用。
* 从头编译或者扩展现有的OpenShift或Cloud Foundry平台来搭建自己的PaaS环境。

## docker开源项目

[Open Source Container Project Collaboration | Docker](https://www.docker.com/community/open-source)

开源项目官网仓库：

* ~~(**deprecated** )  docker/docker-ce: Docker CE (github.com)~~  https://github.com/docker/docker-ce

| 项目                  | 源码仓库                                     | 简介                                                    | 版本说明                       |
| ------------------- | ---------------------------------------- | ----------------------------------------------------- | -------------------------- |
| Containerd          | https://github.com/containerd/containerd | 容器运行工业级标准内核，已捐献给CNCF。                                 | 2018.11从docker-ce-18.09拆分。 |
| Docker CLI          | https://github.com/docker/cli            | The cli used in the Docker CE and Docker EE products. | 2018.11从docker-ce-18.09拆分。 |
| BuildKit            | https://github.com/moby/buildkit         | docker build工具                                        |                            |
| Compose             | https://github.com/docker/compose        | 多容器管理                                                 |                            |
| Docker Distribution | https://github.com/docker/distribution   | docker私有镜像仓库registry2                                 |                            |
| ...                 |                                          |                                                       |                            |

## docker CE版本

各个OS的docker源不一样，需要根据安装文档来更新最新版本的docker-ce。

镜像仓库Docker CE(community-edition)  社区版  [Explore Docker's Container Image Repository | Docker Hub](https://hub.docker.com/search?q=&type=edition&offering=community)

* [Install Docker Engine on CentOS | Docker Documentation](https://docs.docker.com/engine/install/centos/)

* [部署并使用Docker（Alibaba Cloud Linux 2）](https://help.aliyun.com/document_detail/51853.html)  https://help.aliyun.com/document_detail/51853.html

表格 各OS的docker源

| OS                             | OS推荐源仓库                                                          | OS自带仓库文件的路径                                    |
| ------------------------------ | ---------------------------------------------------------------- | ---------------------------------------------- |
| alibaba cloud linux 2 (alinux) | https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo | /etc/yum.repos.d/docker-ce.repo                |
| centos                         | https://download.docker.com/linux/centos/docker-ce.repo          | 同上                                             |
| fedora                         | https://download.docker.com/linux/fedora/docker-ce.repo          | 同上                                             |
| RHEL                           | https://download.docker.com/linux/rhel/docker-ce.repo            | 同上                                             |
| sles                           | https://download.docker.com/linux/sles/docker-ce.repo            | 同上                                             |
| ubuntu                         | https://download.docker.com/linux/ubuntu/gpg                     | /usr/share/keyrings/docker-archive-keyring.gpg |
| debian                         | https://download.docker.com/linux/debian/gpg                     | 同上                                             |

说明：可用各OS的推荐源代替OS自带的docker源。alinux/centos/fedora/rhel/sles都支持yum安装，可以替换相应文件docker-ce.repo。

* 下载替换自带源脚本：`sudo wget -O /etc/yum.repos.d/docker-ce.repo [dest_repo]`

* 配置源仓库脚本（需先安装yum-utils）：`sudo yum-config-manager --add-repo [dest_repo]`

版本发布日志 https://docs.docker.com/engine/release-notes/

表格 docker CE版本 （Docker Engine - Community）

| 组件        | 版本      | 发布时间       | 功能特性                                                                                                                                      |
| --------- | ------- | ---------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| docker    | 1.0     | 2013       |                                                                                                                                           |
|           | 1.13.1  | 2017-2-8   | CE之前最后一个版本。                                                                                                                               |
| docker-ce | 17.03   | 2017-3     | CE第一个版本，此版本号为发布时间。                                                                                                                        |
|           | 17.05.0 | 2017-05-04 | 引入参数 ARGS                                                                                                                                 |
|           | 18.09   | 2018-11-08 | 此版本起，The client and container runtime 分离为2个项目。<br>完整功能要安装3个包：`apt install docker-ce docker-ce-cli containerd.io`.<br>18.x最后一个版本18.09.9()。 |
|           | 19.03   | 2019-07-22 | 19.x最后一个版本19.03.15(2021-02-01).                                                                                                           |
|           | 20.10.8 | 2021-8-3   |                                                                                                                                           |
|           | ？       | ？          |                                                                                                                                           |

说明：docker-ce包括服务器(进程名dockerd) 和客户端(docker)。docker-ce的起始版本是 17.03， 该版本及更高版本建议安装到centos7+。docker-ce-18.09版本，将项目拆解为三个子项目，分别是docker-ce(服务端)，docker-ce-cli(客户端) 和containerd.io。

<br>

# 2 技术原理篇

​         ![1574518833495](../../media/sf_reuse/framework/frame_docker_001.png)

图 1 容器技术与VM技术的比较

Docker 容器通过 Docker 镜像来创建。

容器与镜像的关系类似于面向对象编程中的对象与类。

   ![1574518854525](../../media/sf_reuse/framework/frame_docker_002.png)

图 2 Docker 架构

说明： Docker 使用客户端-服务器 (C/S) 架构模式，Docker daemon 作为服务端一般在宿主主机后台运行，等待接收来自客户端的消息。 Docker 客户端则为用户提供一系列可执行命令（创建build、运行run、分发pull容器），用户用这些命令实现跟 Docker daemon 交互。

客户端和服务端既可以运行在一个机器上，也可通过 socket 或者RESTful API 来进行通信。

表格 2 Docker组件说明表

| 组件                   | 说明                                                                                                                                      |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| Docker 镜像(Images)    | Docker 镜像是用于创建 Docker 容器的只读模板，它包含创建Docker容器的说明。                                                                                         |
| Docker 容器(Container) | 容器是独立运行的一个或一组应用，镜像的可运行实例。镜像和容器的关系类似面向对象中的类和对象的关系。                                                                                       |
| Docker  客户端(Client)  | Docker  客户端通过命令行或者其他工具使用  Docker API (https://docs.docker.com/reference/api/docker_remote_api) 与 Docker 的守护进程通信。比如docker，docker-compose |
| Docker 主机(Host)      | 一个物理或者虚拟的机器用于执行 Docker 守护进程和容器。                                                                                                         |
| Docker 仓库(Registry)  | Docker仓库用来保存镜像，类似代码控制中的代码仓库。可分为公有和私有仓库。Docker Hub(https://hub.docker.com)是官方也是默认的Docker仓库，存放着海量镜像，并可通过docker命令下载并使用。                    |
| Docker Daemon        | Docker守护进程。运行在宿主机(Docker Host)的后台进程(linux里此进程名为dockerd)，可通过Docker客户端与之通信。                                                               |
| Docker Machine       | Docker Machine是一个简化Docker安装的命令行工具，通过一个简单的命令行即可在相应的平台上安装Docker，比如VirtualBox、 Digital Ocean、Microsoft Azure。                              |

备注：docker客户端和服务端daemon可以在同一台机器也可分布在不同机器。

* docker service:  服务。docker启动的一个服务。

* docker stack:  指的是一个服务集。 一个 swarm 集群中可以启动多个stack， 一个stack 中可以有多个服务，一个服务可以有多个分片（容器）， 启动一个stack默认创建一个网络。功能类似docker-compose。

<br>

# 3  安装篇

Docker Desktop includes [Docker Engine](https://docs.docker.com/engine/), Docker CLI client, [Docker Compose](https://docs.docker.com/compose/), [Docker Content Trust](https://docs.docker.com/engine/security/trust.md), [Kubernetes](https://github.com/kubernetes/kubernetes/), and [Credential Helper](https://github.com/docker/docker-credential-helpers/).

To install Docker CE, you need the 64-bit version  要求安装在64位平台。

- [Install Docker Desktop on Windows](https://docs.docker.com/docker-for-windows/install/)

- [Install Docker Desktop on Mac](https://docs.docker.com/docker-for-mac/install/)

安装Docker Engine [Install Docker Engine | Docker Documentation](https://docs.docker.com/engine/install/) https://docs.docker.com/install/

* [Install Docker Engine on CentOS | Docker Documentation](https://docs.docker.com/engine/install/centos/)

## ubuntu安装

Docker CE is supported on Ubuntu on x86_64, armhf, s390x (IBM Z), and ppc64le (IBM Power) architectures.

官网缺省不支持32位平台，需特殊处理。

1) ~~32位平台~~ （可废弃）
   
   ```SHELL
   $ sudo apt-get install docker.io
   # 导入32位ubuntu 14.04镜像
   $ sudo cat ubuntu-14.04-x86-minimal.tar.gz | docker import - ubuntu:14.04
   $ sudo docker run -it ubuntu:14.04 /bin/bash
   
   $ sudo docker version
   Client version: 1.6.2
   Client API version: 1.18
   Go version (client): go1.2.1
   Git commit (client): 7c8fca2
   OS/Arch (client): linux/386
   Server version: 1.6.2
   Server API version: 1.18
   Go version (server): go1.2.1
   Git commit (server): 7c8fca2
   OS/Arch (server): linux/386
   ```

2) 64位平台

```
# 法1：自动检测平台，下载相应最新版本
$ wget -qO- https://get.docker.com/ | sh

# 法2：手动替换源仓库URL，并安装 (下面示例是centos环境)
$ sudo yum install docker-ce docker-ce-cli containerd.io
# 安装后，启动docker后台服务 
$ sudo service docker start 

# 安装 docker-compose
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose 
$ sudo chmod +x /usr/local/bin/docker-compose
```

管理Docker守护进程。

```shell
systemctl start docker     #运行Docker守护进程
systemctl stop docker      #停止Docker守护进程
systemctl restart docker   #重启Docker守护进程
systemctl enable docker    #设置Docker开机自启动
systemctl status docker    #查看Docker的运行状态
```

## windows安装

**win7、win8系统**

win7、win8 等需要利用 docker toolbox 来安装，国内可以使用阿里云的镜像来下载，下载地址：http://mirrors.aliyun.com/docker-toolbox/windows/docker-toolbox/

docker toolbox 是一个工具集，它主要包含以下一些内容：

* Docker CLI 客户端，用来运行docker引擎创建镜像和容器
* Docker Machine. 可以让你在windows的命令行中运行docker引擎命令
* Docker Compose. 用来运行docker-compose命令
* Kitematic. 这是Docker的GUI版本
* Docker QuickStart shell. 这是一个已经配置好Docker的命令行环境
* Oracle VM Virtualbox. 虚拟机

官网安装教程：https://docs.docker.com/toolbox/toolbox_install_windows/

下载安装后：点击Docker QuickStart图标，直到出现$。

**boot2docker**（deprecated）

boot2docker is a lightweight Linux distribution based on Tiny Core Linux made specifically to run Docker containers. It runs completely from RAM, weighs ~27MB and boots in ~5s (YMMV).

This project is officially deprecated in favor of [Docker Machine](https://docs.docker.com/machine/). The code and documentation here only exist as a reference for users who have not yet switched over (but please do soon). The recommended way to install Machine is with the [Docker Toolbox](https://docker.com/toolbox).

**Docker Toolbox** （win7+）

To run Docker, your machine must have a 64-bit operating system running Windows 7 or higher.

**Legacy desktop solution.** Docker Toolbox is for older Mac and Windows systems that do not meet the requirements of [Docker for Mac](https://docs.docker.com/docker-for-mac/) and [Docker for Windows](https://docs.docker.com/docker-for-windows/). We recommend updating to the newer applications, if possible.

[Docker for Windows](https://docs.docker.com/docker-for-windows/) （win10+）

Docker for Windows requires Windows 10 Pro or Enterprise version 14393, or Windows server 2016 RTM to run

**win 10+**

Docker for Windows is a desktop application based on [Docker Community Edition (CE)](https://www.docker.com/community-edition). The Docker for Windows install package includes everything you need to run Docker on a Windows system.

## mac安装

```shell
# 此处安装为 docker desktop，缺省使用k8s编排 
# 安装后，docker路径在/Application/Docker.app
% brew install --cask docker

# 启动
% open /Application/Docker.app
% docker ps

# 关闭要使用 launchctl list寻找任务名，再 launchctl stop [任务名]
% launchctl list |grep docker
-    0    com.docker.helper
2264    0    application.com.docker.docker.1711053.1711058
% launchctl stop 
```

## nvidia-docker2安装

[nvidia-官网](https://www.nvidia.cn/Download/index.aspx?lang=cn)

GPU环境需要安装nvidia驱动，安装docker、nvidia-docker2。

1. 安装显卡驱动
   
   ```shell
   # 查找获取能直接安装的软件
   $ yum search nvidia
   
   # 若未找到nvidia可用软件，则装添加仓库源
   # 先导入公共密钥
   $ sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org 
   # 导入仓库源，以centos7为例，其它版本详见 http://elrepo.org/tiki/HomePage
   $ sudo yum install https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
   
   # 若lsmod存在nouveau（系统缺省使用的显卡驱动）, 则禁用nouveau
   $ lsmod | grep nouveau
   $ vi /etc/modprobe.d/blacklist-nouveau.conf 
   blacklist nouveau
   options nouveau modeset=0
   # 重启内核
   $ sudo dracut --force
   
   # 1.安装 nvidia-driver
   # centos为例, xxx为gpu Kernel Module版本，如495
   $ sudo yum install nvidia-xxx    
   $ sudo yum install nvidia-container-runtime
   
   # 安装完，执行nivdia-smi，测试驱动是否安装成功。若nvidia-smi命令有报错提示，则重启机器reboot
   $ nvidia-smi
   ```

2. 安装容器docker, nvidia-docker2

```shell
# 安装容器, nvidia-docker2 依赖于docker
# 1)配置仓库源 docker-ce
$ sudo wget -O /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/centos/docker-ce.repo
$ sudo yum makecache
$ sudo yum install docker-ce

# 2)配置仓库源 nvidia-docker2
$ distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
$ curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.repo | sudo tee /etc/yum.repos.d/nvidia-docker.repo
$ sudo yum install nvidia-docker2
```

<br><br>

# 4 用户篇

安装成功后，验证docker

step 1: 启动 docker守护进程 ( dockerd:  Docker Daemon，服务端)

```shell
# ubuntu/linux下服务启动
$ sudo service docker start

# 或者 centos
$ sudo systemctl restart docker

# 或者 linux环境直接二进制程序启动
$ dockerd -d

# 或者 windows
$ docker-machine
```

step 2: docker客户端运行hello-world镜像 （docker：Docker客户端）

```shell
# run命令: 如果本地没有镜像，将默认从官网(docker.io)拉取镜像pull，再运行run
$ docker run hello-world
$ docker run -it ubuntu bash
```

备注：dockerd服务端和docker客户端可以同主机也要在不同host里，它们之间可以通过socket或REST进行通讯。

**非root用户启动dockerd**

```shell
# 建立docker组，将目标用户加入到docker组, 重启docker
$ sudo groupadd docker
$ sudo gpasswd -a [user] docker
$ sudo systemctl restart docker

# 切换到目标用户（需要注销退出再登陆），查看现在是否有docker响应信息
$ docker ps
```

> docker服务的权限组是docker，对于docker组的用户都可以启动停止docker容器实例，非docker组用户无法操作docker。

## 4.1 配置文件 daemon.json

Docker Engine V1.12 之后版本，用户可以自行创建 daemon.json 文件对 Docker Engine 进行配置和调整。要点如下：

- 该文件作为 Docker Engine 的配置管理文件, 里面几乎涵盖了所有 docker 命令行启动可以配置的参数。
- 不管是在哪个平台以何种方式启动, Docker 默认都会来这里读取配置。使用户可以统一管理不同系统下的 docker daemon 配置。
- 相关参数的使用说明，可以参阅 `man dockerd` 帮助信息，或者参阅[官方文档](https://docs.docker.com/engine/reference/commandline/dockerd/#daemon)。

新版的 Docker 使用 如下配置文件来配置 Daemon

* Linux: /etc/docker/daemon.json

* Windows: %programdata%\docker\config\daemon.json

* Windows: %HOME%\.docker\machine\machines\default\config.json

修改配置文件之后需要重启 docker守护进程生效

```shell
# 重启服务
$ systemctl restart docker.service
# 或者
$ killall dockerd | xargs dockerd -d

# 查看是否开机启动：
systemctl list-units|grep enable

# 设置docker开机启动
systemctl enable docker.service

# 设置自动启动容器：
docker run xxx --restart=always
```

daemon.json 示例配置文件

```json
# 注意: 下面不是规范JSON串,带#注释在实际环境中需要删除
{
    "registry-mirrors": ["http://hub-mirror.c.163.com"], # 镜像加载仓库，可用docker info查看
    "insecure-registries": [], #配置docker的私库地址
    "authorization-plugins": [],
    "data-root": "",  #Docker运行时使用的根路径,根路径下的内容稍后介绍，默认/var/lib/docker
    "dns": [],
     #设定容器DNS的地址，在容器的 /etc/resolv.conf文件中可查看
    "dns-opts": [],
     #容器 /etc/resolv.conf 文件，其他设置
    "dns-search": [],
     #设定容器的搜索域，当设定搜索域为 .example.com 时，在搜索一个名为 host 的 主机时，DNS不仅搜索host，还会搜索host.example.com。
注意：如果不设置，Docker 会默认用主机上的 /etc/resolv.conf来配置容器。
    "exec-opts": [],
    "exec-root": "",
    "experimental": false,
    "features": {},
    "storage-driver": "",
    "storage-opts": [],
    "labels": [],
     #docker主机的标签，很实用的功能,例如定义：–label nodeName=host-121
    "live-restore": true,
    "debug": true,
    "hosts": [],
    "log-level": "",
    "tls": true,  #默认 false, 启动TLS认证开关
}
```

### nvidia环境

nvidia环境 daemon.json配置示例如下，

```json
{
    "default-runtime": "nvidia",
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    },
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "100m"
    },
    "storage-driver": "overlay2",
    "storage-opts": [
        "overlay2.override_kernel_check = true"
    ],
    "registry-mirrors": ["https://4p5gxeik.mirror.aliyuncs.com"],
    "data-root": "/home/lib/docker/"
}
```

### 镜像加速

* Docker官方镜像：docker.io

* Docker中文区官方镜像：registry.docker-cn.com

鉴于国内网络问题，后续拉取 Docker 镜像十分缓慢，我们可以需要配置加速器来解决。

请在配置文件daemon.json 中加入（没有该文件的话，请先建一个）：分别是 中文区官方镜像 / 网易 / 中科大。

```shell
{
  "registry-mirrors": [
    "https://registry.docker-cn.com",
    "http://hub-mirror.c.163.com",
    "https://docker.mirrors.ustc.edu.cn"
  ]
}
```

## 4.2  docker命令组

   ![1574518882918](../../media/sf_reuse/framework/frame_docker_003.png)

图 3 docker_commands

备注：镜像标签`tag=$name:$version`

docker命令组可分为几大块：容器、镜像、运行

**容器命令**

| Command                                                                                             | Description                                                                   |
| --------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| [docker container attach](https://docs.docker.com/engine/reference/commandline/container_attach/)   | Attach local standard input, output, and error streams to a running container |
| [docker container commit](https://docs.docker.com/engine/reference/commandline/container_commit/)   | Create a new image from a container’s changes                                 |
| [docker container cp](https://docs.docker.com/engine/reference/commandline/container_cp/)           | Copy files/folders between a container and the local filesystem               |
| [docker container create](https://docs.docker.com/engine/reference/commandline/container_create/)   | Create a new container                                                        |
| [docker container diff](https://docs.docker.com/engine/reference/commandline/container_diff/)       | Inspect changes to files or directories on a container’s filesystem           |
| [docker container exec](https://docs.docker.com/engine/reference/commandline/container_exec/)       | Run a command in a running container                                          |
| [docker container export](https://docs.docker.com/engine/reference/commandline/container_export/)   | Export a container’s filesystem as a tar archive                              |
| [docker container inspect](https://docs.docker.com/engine/reference/commandline/container_inspect/) | Display detailed information on one or more containers  显示容器详细信息              |
| [docker container kill](https://docs.docker.com/engine/reference/commandline/container_kill/)       | Kill one or more running containers                                           |
| [docker container logs](https://docs.docker.com/engine/reference/commandline/container_logs/)       | Fetch the logs of a container                                                 |
| [docker container ls](https://docs.docker.com/engine/reference/commandline/container_ls/)           | List containers                                                               |
| [docker container pause](https://docs.docker.com/engine/reference/commandline/container_pause/)     | Pause all processes within one or more containers                             |
| [docker container port](https://docs.docker.com/engine/reference/commandline/container_port/)       | List port mappings or a specific mapping for the container                    |
| [docker container prune](https://docs.docker.com/engine/reference/commandline/container_prune/)     | Remove all stopped containers  移除所有停止容器                                       |
| [docker container rename](https://docs.docker.com/engine/reference/commandline/container_rename/)   | Rename a container                                                            |
| [docker container restart](https://docs.docker.com/engine/reference/commandline/container_restart/) | Restart one or more containers                                                |
| [docker container rm](https://docs.docker.com/engine/reference/commandline/container_rm/)           | Remove one or more containers                                                 |
| [docker container run](https://docs.docker.com/engine/reference/commandline/container_run/)         | Run a command in a new container                                              |
| [docker container start](https://docs.docker.com/engine/reference/commandline/container_start/)     | Start one or more stopped containers                                          |
| [docker container stats](https://docs.docker.com/engine/reference/commandline/container_stats/)     | Display a live stream of container(s) resource usage statistics               |
| [docker container stop](https://docs.docker.com/engine/reference/commandline/container_stop/)       | Stop one or more running containers                                           |
| [docker container top](https://docs.docker.com/engine/reference/commandline/container_top/)         | Display the running processes of a container                                  |
| [docker container unpause](https://docs.docker.com/engine/reference/commandline/container_unpause/) | Unpause all processes within one or more containers                           |
| [docker container update](https://docs.docker.com/engine/reference/commandline/container_update/)   | Update configuration of one or more containers                                |
| [docker container wait](https://docs.docker.com/engine/reference/commandline/container_wait/)       | Block until one or more containers stop, then print their exit codes          |

**镜像命令**

| Command                                                                                     | Description                                                              |
| ------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| [docker image build](https://docs.docker.com/engine/reference/commandline/image_build/)     | Build an image from a Dockerfile                                         |
| [docker image history](https://docs.docker.com/engine/reference/commandline/image_history/) | Show the history of an image                                             |
| [docker image import](https://docs.docker.com/engine/reference/commandline/image_import/)   | Import the contents from a tarball to create a filesystem image          |
| [docker image inspect](https://docs.docker.com/engine/reference/commandline/image_inspect/) | Display detailed information on one or more images                       |
| [docker image load](https://docs.docker.com/engine/reference/commandline/image_load/)       | Load an image from a tar archive or STDIN                                |
| [docker image ls](https://docs.docker.com/engine/reference/commandline/image_ls/)           | List images                                                              |
| [docker image prune](https://docs.docker.com/engine/reference/commandline/image_prune/)     | Remove unused images                                                     |
| [docker image pull](https://docs.docker.com/engine/reference/commandline/image_pull/)       | Pull an image or a repository from a registry                            |
| [docker image push](https://docs.docker.com/engine/reference/commandline/image_push/)       | Push an image or a repository to a registry                              |
| [docker image rm](https://docs.docker.com/engine/reference/commandline/image_rm/)           | Remove one or more images                                                |
| [docker image save](https://docs.docker.com/engine/reference/commandline/image_save/)       | Save one or more images to a tar archive (streamed to STDOUT by default) |
| [docker image tag](https://docs.docker.com/engine/reference/commandline/image_tag/)         | Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE                    |

**docker cli基本命令： docker**

```shell
$ docker
Usage:  docker [OPTIONS] COMMAND

A self-sufficient runtime for containers

Options:
      --config string      Location of client config files (default "/root/.docker")
  -c, --context string     Name of the context to use to connect to the daemon (overrides DOCKER_HOST env var and default context set with "docker context use")
  -D, --debug              Enable debug mode
  -H, --host list          Daemon socket(s) to connect to
  -l, --log-level string   Set the logging level ("debug"|"info"|"warn"|"error"|"fatal") (default "info")
      --tls                Use TLS; implied by --tlsverify
      --tlscacert string   Trust certs signed only by this CA (default "/root/.docker/ca.pem")
      --tlscert string     Path to TLS certificate file (default "/root/.docker/cert.pem")
      --tlskey string      Path to TLS key file (default "/root/.docker/key.pem")
      --tlsverify          Use TLS and verify the remote
  -v, --version            Print version information and quit


Management Commands:
  builder     Manage builds
  config      Manage Docker configs
  container   Manage containers
  context     Manage contexts
  engine      Manage the docker engine
  image       Manage images
  network     Manage networks
  node        Manage Swarm nodes
  plugin      Manage plugins
  secret      Manage Docker secrets
  service     Manage services
  stack       Manage Docker stacks
  swarm       Manage Swarm
  system      Manage Docker 如查看占用空间df，清理空间prune
  trust       Manage trust on Docker images
  volume      Manage volumes

Commands:
    attach    Attach to a running container
    build     Build an image from a Dockerfile
    commit    Create a new image from a container's changes
    cp        Copy files/folders from a container's filesystem to the host path
    create    Create a new container
    diff      Inspect changes on a container's filesystem
    events    Get real time events from the server
    exec      Run a command in a running container
    export    Stream the contents of a container as a tar archive
    history   Show the history of an image
    images    List images
    import    Create a new filesystem image from the contents of a tarball
    info      Display system-wide information
    inspect   Return low-level information on a container or image
    kill      Kill a running container
    load      Load an image from a tar archive
    login     Register or log in to a Docker registry server
    logout    Log out from a Docker registry server
    logs      Fetch the logs of a container  #查看运行镜像实例的日志
    port      Lookup the public-facing port that is NAT-ed to PRIVATE_PORT
    pause     Pause all processes within a container
    ps        List containers  #查看正在运行镜像实例
    pull      Pull an image or a repository from a Docker registry server #拉取镜像
    push      Push an image or a repository to a Docker registry server   #上传镜像
    rename    Rename an existing container
    restart   Restart a running container
    rm        Remove one or more containers
    rmi       Remove one or more images
    run       Run a command in a new container #启动容器
    save      Save an image to a tar archive
    search    Search for an image on the Docker Hub
    start     Start a stopped container
    stats     Display a stream of a containers' resource usage statistics
    stop      Stop a running container
    tag       Tag an image into a repository
    top       Lookup the running processes of a container
    unpause   Unpause a paused container
    version   Show the Docker version information
    wait      Block until a container stops, then print its exit code

Run 'docker COMMAND --help' for more information on a command.
```

### 4.2.1 常用命令

* docker version  获取docker服务端和客户端版本
* docker info 获取服务器信息
* docker inspect [containd_id|image_id]  会自动识别ID属于容器还是镜像，显示一或多个容器|镜像的详细信息
* docker update --restart=always [contained_id]   开机时自动启动容器
* docker network 容器网络
* docker ps 查看进程
* docker service 查看服务
* docker stats 实时统计服务使用的资源情况

**docker version**： 获取docker服务端和客户端版本

```shell
# docker-1.13.1: 2017.2前发布，centos7的yum缺省版本。
$ docker version
Client:
 Version:         1.13.1
 API version:     1.26
 Package version: docker-1.13.1-108.git4ef4b30.1.al7.x86_64
 Go version:      go1.13.3
 Git commit:      4ef4b30/1.13.1
 Built:           Fri Jan 31 15:01:11 2020
 OS/Arch:         linux/amd64

Server:
 Version:         1.13.1
 API version:     1.26 (minimum version 1.12)
 Package version: docker-1.13.1-108.git4ef4b30.1.al7.x86_64
 Go version:      go1.13.3
 Git commit:      4ef4b30/1.13.1
 Built:           Fri Jan 31 15:01:11 2020
 OS/Arch:         linux/amd64
 Experimental:    false

# docker-ce-20.10.8：2021发布。
# docker-ce拆分成了4块，分别是ce, contained, docker-init, runc
docker version
Client: Docker Engine - Community
 Version:           20.10.8
 API version:       1.41
 Go version:        go1.16.6
 Git commit:        3967b7d
 Built:             Fri Jul 30 19:53:39 2021
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.8
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.16.6
  Git commit:       75249d8
  Built:            Fri Jul 30 19:52:00 2021
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.4.9
  GitCommit:        e25210fe30a0a703442421b0f60afac609f950a3
 runc:
  Version:          1.0.1
  GitCommit:        v1.0.1-0-g4144b63
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
```

**docker info命令**

服务器信息：包括容器/镜像、存储引擎、执行驱动/日志驱动、硬件情况（OS/CPU/MEM）

```shell
# windows
$ docker info
Containers: 10
Images: 19
Storage Driver: aufs
 Root Dir: /mnt/sda1/var/lib/docker/aufs
 Backing Filesystem: extfs
 Dirs: 75
 Dirperm1 Supported: true
Execution Driver: <not supported>
Logging Driver: json-file
Kernel Version: 4.9.89-boot2docker
Operating System: Boot2Docker 18.03.0-ce (TCL 8.2.1); HEAD : 404ee40 - Thu Mar 22 17:12:23 UTC 2018
CPUs: 1
Total Memory: 995.6 MiB
Name: default
ID: NCA4:CCKW:YBLC:PFLP:OTOQ:UJVG:EJGR:FE2K:HRJJ:NWMT:TS3J:NVA2
Username: keefewu
Registry: https://index.docker.io/v1/
Labels:
 provider=virtualbox

# linux
$ sudo docker info
Containers: 0
 Running: 0
 Paused: 0
 Stopped: 0
Images: 0
Server Version: 1.13.1
Storage Driver: overlay2
 Backing Filesystem: extfs
 Supports d_type: true
 Native Overlay Diff: false
Logging Driver: journald
Cgroup Driver: systemd
Plugins:
 Volume: local
 Network: bridge host macvlan null overlay
Swarm: inactive
Runtimes: runc docker-runc
Default Runtime: docker-runc
Init Binary: /usr/libexec/docker/docker-init-current
containerd version:  (expected: aa8187dbd3b7ad67d8e5e3a15115d3eef43a7ed1)
runc version: e45dd70447fb72ee4e1f6989173aa6c5dd492d87 (expected: 9df8b306d01f59d3a8029be411de015b7304dd8f)
init version: fec3683b971d9c3ef73f284f176672c44b448662 (expected: 949e6facb77383876aeff8a6944dde66b3089574)
Security Options:
 seccomp
  WARNING: You're not using the default seccomp profile
  Profile: /etc/docker/seccomp.json
Kernel Version: 4.19.91-23.al7.x86_64
Operating System: Alibaba Cloud Linux (Aliyun Linux) 2.1903 LTS (Hunting Beagle)
OSType: linux
Architecture: x86_64
Number of Docker Hooks: 3
CPUs: 1
Total Memory: 1.915 GiB
Name: iZ2zebj7eoe7terrup37y4Z
ID: ZWKR:MR6J:AH3S:DMOA:ZKRN:NGBK:VOVB:2VWX:ISWC:4V67:MGQX:TYCR
Docker Root Dir: /var/lib/docker
Debug Mode (client): false
Debug Mode (server): false
Registry: https://index.docker.io/v1/
Experimental: false
Insecure Registries:
 127.0.0.0/8
Live Restore Enabled: false
Registries: docker.io (secure)
```

1. 获取某个容器的IP
   
   ```shell
   docker inspect --format '{{ .NetworkSettings.IPAddress }}' <CONTAINER ID or NAME>
   ```

2. 给容器指定一个固定 IP 地址，而不是容器每次启动时IP地址变化
   
   ```shell
   # 创建一个桥接网络，示例中网关掩码为172.25.0.0/16, IP为172.15.3.3
   $ docker network create -d bridge --subnet 172.25.0.0/16 my-net
   
   $ docker run --network=my-net --ip=172.25.3.3 -itd --name=my-container busybox
   ```

3. 查看服务资源占用情况
   
   ```shell
   # —no-stream可以不实时展示
   $ docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
   NAME                                                     CPU %               MEM USAGE / LIMIT
   sretest_extract_admin_html.1.rd0hmftqmkmkj6l72er8rme0a   0.00%               5.301MiB / 15.51GiB
   sretest_retest.1.zbf6or7l08u7a8f99xcmw3g03               0.10%               137.7MiB / 15.51GiB
   sretest_mysql.1.8scutj0ecm7wvxb1zbuklyd6d                3.73%               872.4MiB / 15.51GiB
   prtainer-test                                            0.00%               19.46MiB / 15.51GiB
   
   # 查看磁盘使用情况, Docker 1.13引入，RECLAMABLE指可回收的磁盘（镜像/容器未使用）
   #   RECLAIMABLE不为0时，可用docker system prune清理回收磁盘空间。
   $ docker system df  
   TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
   Images          49        15        20.99GB   19.29GB (91%)
   Containers      34        25        172kB     16B (0%)
   Local Volumes   3         1         200.1MB   199.3MB (99%)
   Build Cache     2         0         725B      725B
   ```

### 4.2.3 容器运行 run

**docker run命令**

```shell
denny@denny-ubuntu:~/downloads$ docker run --help
Usage: docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

Run a command in a new container
  -a, --attach=[]            Attach to STDIN, STDOUT or STDERR
  --add-host=[]              Add a custom host-to-IP mapping (host:ip)
  -c, --cpu-shares=0         CPU shares (relative weight)
  --cap-add=[]               Add Linux capabilities
  --cap-drop=[]              Drop Linux capabilities
  --cgroup-parent=           Optional parent cgroup for the container
  --cidfile=                 Write the container ID to the file
  --cpuset-cpus=             CPUs in which to allow execution (0-3, 0,1)
  -d, --detach=false         Run container in background and print container ID
  --device=[]                Add a host device to the container
  --dns=[]                   Set custom DNS servers
  --dns-search=[]            Set custom DNS search domains
  -e, --env=[]               Set environment variables  #环境变量，优先级最高
  --entrypoint=              Overwrite the default ENTRYPOINT of the image
  --env-file=[]              Read in a file of environment variables
  --expose=[]                Expose a port or a range of ports
  -h, --hostname=            Container host name
  --help=false               Print usage
  -i, --interactive=false    Keep STDIN open even if not attached   #交互式启动
  --ipc=                     IPC namespace to use
  -l, --label=[]             Set meta data on a container
  --label-file=[]            Read in a line delimited file of labels
  --link=[]                  Add link to another container #容器链接 <contain_name>:<alias>
  --log-driver=              Logging driver for container
  --lxc-conf=[]              Add custom lxc options
  -m, --memory=              Memory limit
  --mac-address=             Container MAC address (e.g. 92:d0:c6:0a:29:33)
  --memory-swap=             Total memory (memory + swap), '-1' to disable swap
  --name=                       Assign a name to the container  #容器别名
  --net=bridge               Set the Network mode for the container #设置网络模式
  -P, --publish-all=false    Publish all exposed ports to random ports
  -p, --publish=[]           Publish a container's port(s) to the host #端口映射 <宿主>:<容器>
  --pid=                     PID namespace to use
  --privileged=false         Give extended privileges to this container
  --read-only=false          Mount the container's root filesystem as read only
  --restart=no               Restart policy to apply when a container exits
  --rm=false                 Automatically remove the container when it exits
  --security-opt=[]          Security Options
  --sig-proxy=true           Proxy received signals to the process
  -t, --tty=false            Allocate a pseudo-TTY    TTY终端启动
  -u, --user=                Username or UID (format: <name|uid>[:<group|gid>])
  --ulimit=[]                Ulimit options
  -v, --volume=[]            Bind mount a volume  挂载目录
  --volumes-from=[]          Mount volumes from the specified container(s)
  -w, --workdir=             Working directory inside the container
```

说明：1. `-v [宿主机数据卷]:[容器数据卷]` 数据持久化，可以用来将容器数据卷映射到宿主机，便于管理数据，不会因容器移除导致数据丢失。

2. `--link <contain_name>:<alias> `  用于同宿主机的容器A访问另一个容器B服务。contain_name为B容器启动的名称（--name），alias是可以在A容器中使用的B容器的HOST。详见下文 docker网络
3. --net=bridge  设置容器网络模式

### 4.2.3 进入容器 attach/exec

* 法1：`docker attach <docker_id>`
  使用该命令有一个问题。当多个窗口同时使用该命令进入该容器时，所有的窗口都会同步显示。如果有一个窗口阻塞了，那么其他窗口也无法再进行操作。另外退出窗口时，可能也会导出容器退出。

* 法2（推荐）：  `docker exec -it <docker_id> /bin/bash`
  
  ```sh
  # 以root身份登陆docker容器 -u root
  $ docker exec -it -u root [docker_id] /bin/bash
  ```

* 法3：SSH

## 4.3 docker网络

涉及命令

```shell
# 列出运行在本地 docker 主机上的全部网络
docker network ls

# 提供 Docker 网络的详细配置信息
docker network inspect <NETWORK_NAME>

# 创建新的单机桥接网络，名为 localnet，其中 -d 不指定的话，默认是 bridge 驱动。并且主机内核中也会创建一个新的网桥。
docker network create -d bridge localnet

# 删除 Docker 主机上指定的网络
docker network rm

# 删除主机上全部未使用的网络
docker network prune

# 运行一个新的容器，并且让这个容器加入 Docker 的 localnet 这个网络中
docker container run -d --name demo1 --network localnet alpine sleep 3600

# 运行一个新的容器，并且让这个容器暴露 22、20 两个端口
docker container run -d --name web --expose 22 --expose 20 nginx

# 运行一个新的容器，并且将这个容器的 80 端口映射到主机的 5000 端口
docker container run -d --name web --network localnet -p 5000:80 nginx

# 查看系统中的网桥（centos命令不可用）
brctl show
```

### 容器的网络模式

docker容器的四种网络模式：bridge 桥接模式、host 模式、container 模式和 none 模式
启动容器时可以使用 –net 参数指定，默认是桥接模式。

| 网络模式      | 简介                                                                          | 备注                    |
| --------- | --------------------------------------------------------------------------- | --------------------- |
| Bridge    | 此模式会为每一个容器分配、设置IP等，并将容器连接到一个docker0虚拟网桥，通过docker0网桥以及Iptables nat表配置与宿主机通信。 | 缺省模式。--link只能使用在此模式下。 |
| Host      | 容器将不会虚拟出自己的网卡、配置自己的IP等，而是使用宿主机的IP和端口。                                       |                       |
| Container | 创建的容器不会创建自己的网卡，配置自己的IP，而是和一个指定的容器共享IP、端口范围。                                 | 两个容器的进程可以通过lo网卡设备通信。  |
| None      | 该模式关闭了容器的网络功能。                                                              |                       |
| overlay   | docker swarm支持模式。用于连接不同机器上的docker容器，允许不同机器上的容器相互通信，同时支持对消息进行加密。             |                       |

**docker swarm网络**

当我们初始化一个swarm或是加入到一个swarm中时，在docker主机上会出现两种网络：

1. 名称为ingress的overlay网络，用于传递集群服务的控制或是数据消息，若在创建swarm服务时没有指定连接用户自定义的overlay网络，将会加入到默认的ingress网络。

2. 名称为docker_gwbridge桥接网络会连接swarm中所有独立的docker系统进程。docker_gwbridge 默认就是使用`172.18.0.0/16`作为子网范围。
   
   ```shell
   $ docker network ls
   NETWORK ID          NAME                   DRIVER              SCOPE
   e64a4026851d        docker_gwbridge        bridge              local
   bgckv5kskicv        ingress                overlay             swarm
   ```

**安装Docker时，它会自动创建三个网络，bridge（创建容器默认连接到此网络）、none 、host**

```shell
$ docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
381a1613c3d4   bridge    bridge    local
93afb5d191c9   host      host      local
f0909ee01a3d   none      null      local
```

Docker内置这三个网络，运行容器时，你可以使用该 –network 标志来指定容器应连接到哪些网络。

该bridge网络代表docker0所有Docker安装中存在的网络。除非你使用该`docker run --network=选项指定`，否则Docker守护程序默认将容器连接到此网络。

命令`ip a` 可查看当前支持的所有网络，其中docker0支docker网络。<br>

**host 模式**

采用 host 模式的 Docker Container,可以直接使用宿主机的 IP 地址与外界进行通信,若宿主机的 eth0 是一个公有 IP,那么容器也拥有这个公有 IP。同时容器内服务的端口也可以使用宿主机的端口,无需额外进行 NAT 转换。当然,有这样的方便,肯定会损失部分其他的特性,最明显的是 Docker Container 网络环境隔离性的弱化,即容器不再拥有隔离、独立的网络栈。另外,使用 host 模式的 Docker Container 虽然可以让容器内部的服务和传统情况无差别、无改造的使用,但是由于网络隔离性的弱化,该容器会与宿主机共享竞争网络栈的使用;另外,容器内部将不再拥有所有的端口资源。

### 容器间数据通讯

第一种搭建容器的桥接网络，第二种使用Docker容器之间的Link机制（只适用于单机容器是互联）。

同一个宿主机上的多个docker容器之间如果想进行通信，可以通过使用容器的ip地址来通信，也可以通过宿主机的ip加上容器暴露出的端口号来通信。

前者会导致ip地址的硬编码，不方便迁移，并且容器重启后ip地址会改变，除非使用固定的ip；后者的通信方式比较单一，只能依靠监听在暴露出的端口的进程来进行有限的通信。

通过docker的link机制可以通过一个name来和另一个容器通信，link机制方便了容器去发现其它的容器并且可以安全的传递一些连接信息给其它的容器。

**1.桥接网络**

直接使用 docker inspect 容器ID
查看容器的元信息，可获取到宿主机分配给容器的IP。

**2.Link机制**

`--link <contain_name>:<alias> `  用于同宿主机的容器A访问另一个容器B服务。contain_name为B容器启动的名称（--name），alias是可以在A容器中使用的B容器的HOST。

示例如下

```shell
# 容器B先启动，是mysql服务，--name mysql
docker run  --name mysql -p 3306:3306 -v /mysql/database/data:/var/lib/mysql
-e MYSQL_ROOT_PASSWORD=root -d mysql:5.7

# 容器A后启动，用--link使用容器B服务 --link mysql:aliasmysql
docker run -d -v /Docker:/usr/java/tomcat/apache-tomcat-8.5.27/webapps -p 8080:8080
--name MyTomcat --link mysql:aliasmysql javaweb:1.0 /root/run.sh

# 容器A后访问mysql的URI: 将原来的ip-127.0.0.1替换成 aliasmysql
SQLALCHEMY_DATABASE_URI = 'mysql://root:123456@aliasmysql:3306/superset_1.0'
```

<br/>

## 本章参考

* Docker配置文件daemon.json解析 https://www.jianshu.com/p/c7c7dc24b9e3

* Docker网络详解——原理篇 https://blog.csdn.net/meltsnow/article/details/94490994

# 5 高级篇

## 5.1  docker镜像仓库

镜像存储路径

* linux:  /var/lib/docker
* windows: ~/.docker/

镜像管理主要命令：

* docker images  # 查看本地镜像列表

* docker search xx   # 搜索某个镜像

* docker pull xx  # 下载某个镜像
  
  ```shell
  # 以python为例 找能用的python版本
  # 先找带有python名称的镜像
  docker search python
  
  # 打印出python镜像的所有layer
  curl https://registry.hub.docker.com/v1/repositories/python/tags| tr -d '[\[\]" ]' | tr '}' '\n'
  
  # 在上面语句基础上用awk提取:的第三段，组合成python:[3]
  curl https://registry.hub.docker.com/v1/repositories/python/tags| tr -d '[\[\]" ]' | tr '}' '\n'| awk -F: -v image='python' '{if(NR!=NF && $3 != ""){printf("%s:%s\n",image,$3)}}'
  python:3.9.8
  python:3.9.8-alpine
  python:3.9.8-alpine3.13
  python:3.9.8-alpine3.14
  python:3.9.8-bullseye
  python:3.9.8-buster
  python:3.9.8-slim
  python:3.9.8-slim-bullseye
  python:3.9.8-slim-buster
  python:3.9.8-windowsservercore
  python:3.9.8-windowsservercore-1809
  python:3.9.8-windowsservercore-ltsc2016
  python:3.9.8-windowsservercore-ltsc2022
  ...
  ```

镜像仓库常用命令：

* 登陆：`docker login [OPTIONS] [SERVER]`    #若未指定SERVER，则默认连接Daemon指定的服务器

* 退出：`docker logout [SERVER]`

### 5.1.1 官方 docker Hub

Docker Hub ( http://hub.docker.com )是缺省的官方仓库。pull拉取镜像默认是从官仓拉取的。

登陆docker Hub, 推送镜像，配置文件 ~/.docker/config.json

```shell
$ cat ~/.docker/config.json
{
        "auths": {
                "https://index.docker.io/v1/": {
                        "auth": "a2VlZmV3dTp3cWYzNjN3cWYzNjM=",
                        "email": ""
                }
        },
        "HttpHeaders": {
                "User-Agent": "Docker-Client/18.03.0-ce (windows)"
        }
}

$ docker login
$ docker push [image:tag]
```

### 5.1.2 私有 Registry2

docker官方开源的私有镜像仓库registry，分为二个版本。

* registry1：python语言开发，要求docker1.6以下版本。
* registry2：即docker distribution，go语言开发，更加安全和快速。要求docker版本高于1.6。harbor是基于registry2开发的。

Registry 2不包含界面、用户管理、权限控制等功能，如果想使用这些功能，可使用Docker Trusted Registry 或者 企业级镜像仓库harbor。

docker配置文件 daemon.json 里增加私仓

```json
{
  "insecure-registries": [
    "http://localhost:5000",
  ]
}
```

服务启动：

```shell
$ docker run -d -p 5000:5000 --restart=always --name registry2 registry:2
```

修改tag，如果tag前不加host:port/，缺省将推送到官仓相应的镜像里（如果有权限）

```shell
$ docker tag [old_image:tag] [localhost:5000/new_image:tag]
$ docker push [localhost:5000/new_image:tag]
```

### 5.1.3 企业级Harbor

开源项目地址：https://github.com/goharbor/harbor/releases

VMware开源的企业级Registry项目Harbor，以Docker公司开源的registry 为基础，提供了管理UI, 基于角色的访问控制(Role Based Access Control)，AD/LDAP集成、以及审计日志(Audit logging) 等企业用户需求的功能，同时还原生支持中文，主要特点：

- 基于角色的访问控制 - 用户与 Docker 镜像仓库通过“项目”进行组织管理，一个用户可以对多个镜像仓库在同一命名空间（project）里有不同的权限。

- 镜像复制 - 镜像可以在多个 Registry 实例中复制（同步）。尤其适合于负载均衡，高可用，混合云和多云的场景。

- 图形化用户界面 - 用户可以通过浏览器来浏览，检索当前 Docker 镜像仓库，管理项目和命名空间。

- AD/LDAP 支持 - Harbor 可以集成企业内部已有的 AD/LDAP，用于鉴权认证管理。

- 审计管理 - 所有针对镜像仓库的操作都可以被记录追溯，用于审计管理。

- 国际化 - 已拥有英文、中文、德文、日文和俄文的本地化版本。更多的语言将会添加进来。

- RESTful API - RESTful API 提供给管理员对于 Harbor 更多的操控, 使得与其它管理软件集成变得更容易。

- 部署简单 - 提供在线和离线两种安装工具， 也可以安装到 vSphere 平台(OVA 方式)虚拟设备

1）下载安装

```shell
[root@otrs004097 opt]# wget https://storage.googleapis.com/harbor-releases/release-1.8.0/harbor-offline-installer-v1.8.2.tgz
[root@otrs004097 opt]# tar xf harbor-offline-installer-v1.8.2.tgz
[root@otrs004097 opt]# cd harbor/
[root@otrs004097 harbor]# ls
harbor.v1.8.2.tar.gz harbor.yml install.sh LICENSE prepare
```

2）**配置文件 harbor.yml**

可根据实际情况修改hostname, port, harbor_admin_password, database.password,

**必须参数**

* hostname: 目标主机的主机名。它应该是目标计算机的 IP 地址或完全限定的域名（FQDN），例如：172.16.1.30 或 reg.yourdomain.com。不要使用 localhost 或 127.0.0.1 作为主机名。

* data_volume: Harbor 数据的存储位置

* harbor_admin_password: 管理员的初始密码。此密码仅在 Harbor 首次启动时生效。请注意，默认用户 名/密码为  admin / Harbor12345

* database: 与本地数据库相关的配置。

* password: 默认数据库密码为 root123，应该改为一个安全的生产环境密码。

**可选参数**

* port: https 的端口号。

* certificate: SSL 证书的路径，仅在协议设置为 https 时应用。

* private_key: SSL 密钥的路径，仅在协议设置为 https 时应用。

```yaml
# The IP address or hostname to access admin UI and registry service.
# DO NOT use localhost or 127.0.0.1, because Harbor needs to be accessed by external clients.
hostname: 121.36.106.72

# http related config: 如果修改了port，也要同步修改 docker-compose.yml相应内容
http:
  # port for http, default is 80. If https enabled, this port will redirect to https port
  port: 1180

# https related config
# https:
#   # https port for harbor, default is 443
#   port: 443
#   # The path of cert and key files for nginx
#   certificate: /your/certificate/path
#   private_key: /your/private/key/path

# Uncomment external_url if you want to enable external proxy
# And when it enabled the hostname will no longer used
# external_url: https://reg.mydomain.com:8433

# The initial password of Harbor admin
# It only works in first time to install harbor
# Remember Change the admin password from UI after launching Harbor.
harbor_admin_password: xxxx

# Harbor DB configuration
database:
  # The password for the root user of Harbor DB. Change this before any production use.
  password: xxxx

# The default data volume
data_volume: /data

# Harbor Storage settings by default is using /data dir on local filesystem
# Uncomment storage_service setting If you want to using external storage
# storage_service:
#   # ca_bundle is the path to the custom root ca certificate, which will be injected into the truststore
#   # of registry's and chart repository's containers.  This is usually needed when the user hosts a internal storage with self signed certificate.
#   ca_bundle:

#   # storage backend, default is filesystem, options include filesystem, azure, gcs, s3, swift and oss
#   # for more info about this configuration please refer https://docs.docker.com/registry/configuration/
#   filesystem:
#     maxthreads: 100
#   # set disable to true when you want to disable registry redirect
#   redirect:
#     disabled: false

# Clair configuration
clair:
  # The interval of clair updaters, the unit is hour, set to 0 to disable the updaters.
  updaters_interval: 12

  # Config http proxy for Clair, e.g. http://my.proxy.com:3128
  # Clair doesn't need to connect to harbor internal components via http proxy.
  http_proxy:
  https_proxy:
  no_proxy: 127.0.0.1,localhost,core,registry

jobservice:
  # Maximum number of job workers in job service
  max_job_workers: 10

chart:
  # Change the value of absolute_url to enabled can enable absolute url in chart
  absolute_url: disabled

# Log configurations
log:
  # options are debug, info, warning, error, fatal
  level: info
  # Log files are rotated log_rotate_count times before being removed. If count is 0, old versions are removed rather than rotated.
  rotate_count: 50
  # Log files are rotated only if they grow bigger than log_rotate_size bytes. If size is followed by k, the size is assumed to be in kilobytes.
  # If the M is used, the size is in megabytes, and if G is used, the size is in gigabytes. So size 100, size 100k, size 100M and size 100G
  # are all valid.
  rotate_size: 200M
  # The directory on your host that store log
  location: /var/log/harbor

#This attribute is for migrator to detect the version of the .cfg file, DO NOT MODIFY!
_version: 1.8.0

# Uncomment external_database if using external database.
# external_database:
#   harbor:
#     host: harbor_db_host
#     port: harbor_db_port
#     db_name: harbor_db_name
#     username: harbor_db_username
#     password: harbor_db_password
#     ssl_mode: disable
#   clair:
#     host: clair_db_host
#     port: clair_db_port
#     db_name: clair_db_name
#     username: clair_db_username
#     password: clair_db_password
#     ssl_mode: disable
#   notary_signer:
#     host: notary_signer_db_host
#     port: notary_signer_db_port
#     db_name: notary_signer_db_name
#     username: notary_signer_db_username
#     password: notary_signer_db_password
#     ssl_mode: disable
#   notary_server:
#     host: notary_server_db_host
#     port: notary_server_db_port
#     db_name: notary_server_db_name
#     username: notary_server_db_username
#     password: notary_server_db_password
#     ssl_mode: disable

# Uncomment external_redis if using external Redis server
# external_redis:
#   host: redis
#   port: 6379
#   password:
#   # db_index 0 is for core, it's unchangeable
#   registry_db_index: 1
#   jobservice_db_index: 2
#   chartmuseum_db_index: 3

# Uncomment uaa for trusting the certificate of uaa instance that is hosted via self-signed cert.
# uaa:
#   ca_file: /path/to/ca
```

3）运行安装脚本

[root@registory harbor]# ./install.sh

4）使用ADMIN账号登陆

5）Harbor服务操作

如果想要停止,或者是服务器重启了,需要手动重启,在harbor的安装目录,里执行命令

```shell
$ docker-compose stop|start|restart
```

#### 技术原理

Harbor由6个大的模块所组成：

- **Proxy**: Harbor的registry、UI、token services等组件，都处在一个反向代理后边。该代理将来自浏览器、docker clients的请求转发到后端服务上。

- **Registry**: 负责存储Docker镜像，以及处理Docker push/pull请求。因为Harbor强制要求对镜像的访问做权限控制， 在每一次push/pull请求时，Registry会强制要求客户端从token service那里获得一个有效的token。

- **Core services**: Harbor的核心功能，主要包括如下3个服务:
  
  - UI: 作为Registry Webhook, 以图像用户界面的方式辅助用户管理镜像。
  
  - WebHook：WebHook是在registry中配置的一种机制， 当registry中镜像发生改变时，就可以通知到Harbor的webhook endpoint。Harbor使用webhook来更新日志、初始化同步job等。
  
  - Token 服务：负责根据用户权限给每个docker push/pull命令签发token. Docker 客户端向Regiøstry服务发起的请求,如果不包含token，会被重定向到这里，获得token后再重新向Registry进行请求。

- **Database**：为core services提供数据库服务，负责储存用户权限、审计日志、Docker image分组信息等数据。

- **Job services**: 主要用于镜像复制，本地镜像可以被同步到远程Harbor实例上。

- **Log collector**: 负责收集其他组件的日志到一个地方

这里我们与上面运行的7个容器对比，对`harbor-adminserver`感觉有些疑虑。其实这里`harbor-adminserver`主要是作为一个后端的配置数据管理，并没有太多的其他功能。`harbor-ui`所要操作的所有数据都通过harbor-adminserver这样一个数据配置管理中心来完成。

harbor运行时有7个容器：`nginx`、`harbor-jobservice`、`harbor-ui`、`harbor-db`、`harbor-adminserver`、`registry`以及`harbor-log`。

Harbor的每一个组件都被包装成一个docker容器。自然，Harbor是通过docker compose来部署的。在[Harbor源代码](https://github.com/vmware/harbor)的make目录下的docker-compose模板会被用于部署Harbor。打开该模板文件，可以看到Harbor由7个容器组件所组成：

- `proxy`: 通过nginx服务器来做反向代理
- `registry`: docker官方发布的一个仓库镜像组件
- `ui`: 整个架构的核心服务。该容器是Harbor工程的主要部分
- `adminserver`: 作为Harbor工程的配置数据管理器使用
- `mysql`: 通过官方Mysql镜像创建的数据库容器
- `job services`: 通过状态机的形式将镜像复制到远程Harbor实例。镜像删除同样也可以被同步到远程Harbor实例中。
- `log`: 运行rsyslogd的容器，主要用于收集其他容器的日志

这些容器之间都通过Docker内的DNS服务发现来连接通信。通过这种方式，每一个容器都可以通过相应的容器来进行访问。对于终端用户来说，只有反向代理(Nginx)服务的端口需要对外暴露。

Harbor由6个大的模块所组成：

- **Proxy**: Harbor的registry、UI、token services等组件，都处在一个反向代理后边。该代理将来自浏览器、docker clients的请求转发到后端服务上。

- **Registry**: 负责存储Docker镜像，以及处理Docker push/pull请求。因为Harbor强制要求对镜像的访问做权限控制， 在每一次push/pull请求时，Registry会强制要求客户端从token service那里获得一个有效的token。

- **Core services**: Harbor的核心功能，主要包括如下3个服务:
  
  - UI: 作为Registry Webhook, 以图像用户界面的方式辅助用户管理镜像。
  
  - WebHook：WebHook是在registry中配置的一种机制， 当registry中镜像发生改变时，就可以通知到Harbor的webhook endpoint。Harbor使用webhook来更新日志、初始化同步job等。
  
  - Token 服务：负责根据用户权限给每个docker push/pull命令签发token. Docker 客户端向Regiøstry服务发起的请求,如果不包含token，会被重定向到这里，获得token后再重新向Registry进行请求。

- **Database**：为core services提供数据库服务，负责储存用户权限、审计日志、Docker image分组信息等数据。

- **Job services**: 主要用于镜像复制，本地镜像可以被同步到远程Harbor实例上。

- **Log collector**: 负责收集其他组件的日志到一个地方

这里我们与上面运行的7个容器对比，对`harbor-adminserver`感觉有些疑虑。其实这里`harbor-adminserver`主要是作为一个后端的配置数据管理，并没有太多的其他功能。`harbor-ui`所要操作的所有数据都通过harbor-adminserver这样一个数据配置管理中心来完成。

## 5.2  容器镜像制作

**环境变量优先级**

docker run -e > Dockerfile里定义的ENV > ~/.bashrc > /etc/.bashrc

**容器运行时执行指令**

CMD和ENTRYPOINT这两个指令配置容器的运行命令。Dockerfile里是CMD和ENTRYPOINT；Docker Compose files则是使用小写，command和entrypoint。

* CMD/command指令：是当Docker镜像被启动后Docker容器将会默认执行的命令。一个Dockerfile仅仅最后一个CMD起作用。

* ENTRYPOINT：用于设定容器启动时第一个运行的命令及其参数。运行镜像的时候，可以通过 `--entrypoint` 来覆盖默认的 `ENTRYPOINT` 命令。任何使用`docker run <image>`命令传入的参数都会附加在`entrypoint`指令之后，并且用此命令传入的参数会覆盖在Dockerfile中使用`CMD`指令设定的值。比如`docker run <image> bash`命令会将`bash`命令附加在`entrypoint`指令设定的值的后面。

* RUN指令：是创建Docker镜像（image）的步骤，RUN指令对Docker容器（ container）造成的改变是会被反映到创建的Docker镜像上的。一个Dockerfile中可以有许多个RUN命令。另外docker run命令可用于启动一个容器。

`CMD`和`ENTRYPOINT`都定义了容器运行时的执行命令。如下是它们的一些使用规则：

1. `CMD`和`ENTRYPOINT`在Dockerfiles中应该至少应该有一个被定义。
2. 当构建可执行容器时，应该定义`ENTRYPOINT`指令。
3. `CMD`要么用于给`ENTRYPOINT`提供默认参数，要么用于在容器中执行一个特定命令。
4. `CMD`可以通过容器启动命令`docker run`的参数来替换它。

```shell
# 法1 shell语法：命令作为字符串执行，并且会执行变量替换。
ENTRYPOINT command param1 param2
CMD command param1 param2

# 法2 exce语法：命令和其参数以JSON数组的格式书写，更加安全
CMD [“executable”, “param1”, “param2”…]
```

### 单容器 Dockerfile

[Dockerfile reference | Docker Documentation](https://docs.docker.com/engine/reference/builder/)

当我们从docker镜像仓库中下载的镜像不能满足我们的需求时，我们可以通过以下两种方式对镜像进行更改。

镜像构建方式

* docker build方式，使用 Dockerfile 指令来创建一个新的镜像。
* docker commit方式，从已经创建的容器中更新镜像，并且提交这个镜像。

通常我们都是使用第一种方式来构建容器，二者的区别就像批处理和单步执行一样。

**1. 更新镜像docker commit**

```sh
# 容器有修改后，重新执行commit命令，会覆盖上一次标签。
docker commit -m='xxx' -a=[author] [contain_id] [dst_image:tag]
```

**2. Dockerfile**

**容器配置文件 Dockerfile**

常用指令有：FROM RUN CMD ENV EXPOSE ADD COPY VOLUME ENTRYPOINT USER WORKDIR ONBUILD

DockerFile分为四部分组成：基础镜像、维护者信息、镜像操作指令和容器启动时执行指令。例如：

```dockerfile
# 第一行必须指令基于的基础镜像 From
From ubutu

# 维护者信息 MAINTAINER
MAINTAINER docker_user  docker_user@mail.com

# ENV 设置环境变量，可以被之后的命令使用
ENV BASE_DIR "/opt/redis"
# 镜像的操作指令 RUN~使用&&或\执行多行命令
apt/sourcelist.list
RUN apt-get update && apt-get install -y ngnix
RUN echo "\ndaemon off;">>/etc/ngnix/nignix.conf

# EXPOSE 打开端口并映射到docker主机的外部端口上
EXPOSE 6379
# ADD/COPY 将文件移入镜像，ADD会将TAR文件解压, 
ADD redis.tgz /rdis
COPY redis.conf $BASE_DIR
# VOLUEM挂载卷并映射到外部位置
VOLUME $BASE_DIR/data

# 容器启动时执行指令 CMD 或 ENTRYPOINT执行镜像中main命令
# 下面示例：ENTRYPOINT启动redis-server，然后CMD启动了nginx
ENTRYPOINT ['redis-server']
CMD /usr/sbin/ngnix
```

**docker build**

命令读取指定路径下（包括子目录）所有的Dockefile，并且把目录下所有内容发送到服务端，由服务端创建镜像。另外可以通过创建.dockerignore文件（每一行添加一个匹配模式）让docker忽略指定目录或者文件。

```SHELL
% docker build --help

Usage:  docker build [OPTIONS] PATH | URL | -

Build an image from a Dockerfile

Options:
      --add-host list           Add a custom host-to-IP mapping (host:ip)
      --build-arg list          Set build-time variables
      --cache-from strings      Images to consider as cache sources
      --disable-content-trust   Skip image verification (default true)
  -f, --file string             Name of the Dockerfile (Default is 'PATH/Dockerfile')
      --iidfile string          Write the image ID to the file
      --isolation string        Container isolation technology
      --label list              Set metadata for an image
      --network string          Set the networking mode for the RUN instructions during build (default "default")
      --no-cache                Do not use cache when building the image
  -o, --output stringArray      Output destination (format: type=local,dest=path)
      --platform string         Set platform if server is multi-platform capable
      --progress string         Set type of progress output (auto, plain, tty). Use plain to show container output (default "auto")
      --pull                    Always attempt to pull a newer version of the image
  -q, --quiet                   Suppress the build output and print image ID on success
      --secret stringArray      Secret file to expose to the build (only if BuildKit enabled): id=mysecret,src=/local/secret
      --ssh stringArray         SSH agent socket or keys to expose to the build (only if BuildKit enabled) (format:
                                default|<id>[=<socket>|<key>[,<key>]])
  -t, --tag list                创建标签。Name and optionally a tag in the 'name:tag' format
      --target string           Set the target build stage to build.
```

例如：Dockerfile路径为 /tmp/docker_build/，生成镜像的标签为build_repo/my_images

```sh
$ docker build -t build_repo/my_images /tmp/docker_build/

# 多平台支持：目前支持linux/arm64, linux/amd64, linux/riscv64, linux/ppc64le,
#   linux/s390x, linux/386, linux/arm/v7, linux/arm/v6
$ docker build --platform linux/amd64 -t build_repo/my_images [dockfile_path]
```

说明：

### 多容器 docker-compose

[Compose file | Docker Documentation](https://docs.docker.com/compose/compose-file/)

docker-compose简化了容器的管理与配置，避开了运行多个容器中容易出错的手工步骤。

```shell
$ docker-compose.exe --help
Define and run multi-container applications with Docker.

Usage:
  docker-compose [-f <arg>...] [options] [COMMAND] [ARGS...]
  docker-compose -h|--help

Options:
  -f, --file FILE             Specify an alternate compose file
                              (default: docker-compose.yml)
  -p, --project-name NAME     Specify an alternate project name
                              (default: directory name)
  --verbose                   Show more output
  --log-level LEVE*           Set log level (DEBUG, INFO, WARNING, ERROR, CRITICAL)
  --no-ansi                   Do not print ANSI control characters
  -v, --version               Print version and exit
  -H, --host HOST             Daemon socket to connect to

  --tls                       Use TLS; implied by --tlsverify
  --tlscacert CA_PATH         Trust certs signed only by this CA
  --tlscert CLIENT_CERT_PATH  Path to TLS certificate file
  --tlskey TLS_KEY_PATH       Path to TLS key file
  --tlsverify                 Use TLS and verify the remote
  --skip-hostname-check       Don't check the daemon's hostname against the
                              name specified in the client certificate
  --project-directory PATH    Specify an alternate working directory
                              (default: the path of the Compose file)
  --compatibility             If set, Compose will attempt to convert deploy
                              keys in v3 files to their non-Swarm equivalent

Commands:
  build              Build or rebuild services
  bundle             Generate a Docker bundle from the Compose file
  config             Validate and view the Compose file
  create             Create services
  down               Stop and remove containers, networks, images, and volumes
  events             Receive real time events from containers
  exec               Execute a command in a running container
  help               Get help on a command
  images             List images
  kill               Kill containers
  logs               View output from containers
  pause              Pause services
  port               Print the public port for a port binding
  ps                 List containers
  pull               Pull service images
  push               Push service images
  restart            Restart services
  rm                 Remove stopped containers
  run                Run a one-off command
  scale              Set number of containers for a service
  start              Start services
  stop               Stop services
  top                Display the running processes
  unpause            Unpause services
  up                 Create and start containers
  version            Show the Docker-Compose version information
```

**配置文件**：docker-compose.yml 或者 xxx.yml

yml文件规范 （以下是四大顶级关键词）

* version: 代表了Compose文件格式的版本号。为了应用于Stack，需要3.0或者更高的版本。

* services: 定义了组成当前应用的服务都有哪些。

* networks: 列出了必需的网络。

* secrets: 定义了应用用到的密钥。

示例：容器服务web，依赖于redis

```yaml
version: "3.9"  # optional since v1.27.0
services:
  web:
    build: .
    ports:    #映射端口：宿主:容器
      - "5000:5000"
    volumes:  #挂载卷
      - .:/code
      - logvolume01:/var/log
    links:    # 或者用depends_on
      - redis
  redis:
    image: redis    # 镜像
    restart: always    # 容器是否重启
    environment:    # 环境变量
      REDIS_HOST: redisx
      REDIS_PORT: 6379

volumes:
  logvolume01: {}
```

后台启动： -d

```sh
$ docker-compose up -d

# 停止
$ docker-compose down
```

### docker stack

表格 Docker Stack和Docker Compose区别

|       | docker stack                                                | docker-compose                     |
| ----- | ----------------------------------------------------------- | ---------------------------------- |
| 镜像    | 会忽略了“构建”指令，无法使用stack命令构建新镜像，它是需要镜像是预先已经构建好的。                | 更适合于开发场景                           |
| 工具    | 包含在Docker引擎中。你不需要安装额外的包来使用它，docker stacks 只是swarm mode的一部分。 | 需要安装单独工具。在内部，它使用Docker API规范来操作容器。 |
| yml版本 | 版本3以上                                                       | 支持版本2和3                            |

备注：同服务名称的配置项，yml文件后面的会覆盖前面的。

docker stack把docker compose的所有工作都做完了，因此docker stack将占主导地位。同时，对于大多数用户来说，切换到使用docker stack既不困难，也不需要太多的开销。如果您是Docker新手，或正在选择用于新项目的技术，请使用docker stack。

表格 Docker Stack常用命令   

| 命令                    | 描述              |
| --------------------- | --------------- |
| docker stack deploy   | 部署新的堆栈 或 更新现有堆栈 |
| docker stack ls       | 列出现有堆栈          |
| docker stack ps       | 列出堆栈中的任务        |
| docker stack rm       | 删除一个或多个堆栈       |
| docker stack services | 列出堆栈中的服务        |

```shell
$ docker stack

Usage:  docker stack [OPTIONS] COMMAND

Manage Docker stacks

Options:
      --orchestrator string   Orchestrator to use (swarm|kubernetes|all)

Commands:
  deploy      Deploy a new stack or update an existing stack
  ls          List stacks
  ps          List the tasks in the stack
  rm          Remove one or more stacks
  services    List the services in the stack

Run 'docker stack COMMAND --help' for more information on a command.


$ docker stack deploy --help
Usage:  docker stack deploy [OPTIONS] STACK
Deploy a new stack or update an existing stack

Aliases:
  deploy, up

Options:
  -c, --compose-file strings   Path to a Compose file, or "-" to read from stdin
      --orchestrator string    rchestrator to use (swarm|kubernetes|all)  容器编排方式
      --prune                  Prune services that are no longer referenced
      --resolve-image string   Query the registry to resolve image digest and supported platforms ("always"|"changed"|"never") (default "always")
      --with-registry-auth     Send registry authentication details to Swarm agents, default false
```

说明：实际上 docker stack COMMAND STACK_NAME ，STACK_NAME为栈名称，要有STACK_NAME才能执行。

**进阶**

1. 只重启stack单个服务

```shell
# 若报错 image could not be accessed on a registry to record its digest
# 则加上参数 --with-registry-auth
# 法1：stack depoly命令部署更新，只更新标记需要更新的服务？
$ docker stack deploy STACK_NAME --with-registry-auth

# 法2：指定service id 强制更新某个service, 这个命令只能用于swarm管理节点
#  示例中service_id是3xrdy2c7pfm3
$ docker stack services STACK_NAME
# 重启服务，重启服务并更新某个服务的镜像
$ docker service update --force 3xrdy2c7pfm3
$ docker service update --image image_name service_name
```

2. 查看服务问题
   
   ```shell
   # 服务有启动：查看某个服务的日志, -f 日志持续查看
   $ docker service logs -f SERVICE_NAME 
   
   # 查看容器报错信息
   $ docker ps --no-trunc
   # 若容器失败，查看对应失败容器的日志. docker ps -a 可以查看所有历史启动容器
   $ docker logs -f <container_id>
   
   # 查看stack的启动状态, --no-trunc 查看服务详细报错 如yml加载错误的信息
   $ docker stack ps <stack-name> --no-trunc
   ```

**docker stack集群部署**

docker stack默认使用 swarm模式部署。部署细节 详见下文章节。

<br>

## 5.3 镜像管理

### 镜像&容器清理

* <none>：<none> iamge : 它们代表中间映像，可以使用`docker images -a`看到, 它们不会导致磁盘空间问题，但这绝对是屏幕空间问题。

* <none>:<none> —— dangling=true（会导致磁盘空间问题），可用`docker image prune`清除，可释放磁盘空间。

**1. 批量删除tag为None的镜像**

**描述**：

**原因**：有时候重新构建镜像(build) 的时候，该镜像正在被某容器使用中，那么在重新构建同名同版本镜像后，docker保留原来的镜像，即容器还是用原来的，除非重启。那么原来的镜像名称变成NONE，TAG也成了NONE。

**解决方法：（3种方法，慎用）**

```shell
# 删除镜像
docker images|grep none|awk '{print $3}'|xargs docker rmi
docker rmi $(docker images | grep "^<none>" | awk "{print $3}")

# 清除dangling 悬空镜像，下面二种清除方法
docker image prune
docker rmi $(docker images -f "dangling=true" -q)
```

**2. 清理容器** （可以在镜像清理前操作）

```shell
# （推荐）删除停止的容器，可以回容器名。-a显示所有  正在运行的容器要先停止stop才会被删除rm
docker rm $(docker ps -a -q)

# 清理当前未运行的容器
docker container prune

# 停止正在运行的容器
docker stop $(docker container ls -q)
```

3. 清理镜像和容器
   
   ```shell
   # 清理已停止的容器、没有被容器使用的网络、悬空镜像、悬空构建缓存
   $ docker system prune
   WARNING! This will remove:
     - all stopped containers
     - all networks not used by at least one container
     - all dangling images
     - all dangling build cache
   ```

### 镜像体积裁减

**体积分析**

Docker镜像是由很多镜像层（Layers）组成的（最多127层）， Dockerfile 中的每条指定都会创建镜像层，不过**只有 `RUN`, `COPY`, `ADD` 会使镜像的体积增加**。这个可以通过命令 `docker history image_id` 来查看每一层的大小。 这里我们以官方的 [alpine:3.12](https://github.com/alpinelinux/docker-alpine/blob/90788e211ec6d5df183d79d6cb02e068b258d198/x86_64/Dockerfile) 为例看看它的镜像层情况。

```shell
$ docker images |grep alpine
alpine                                          latest       0ac33e5f5afa   5 weeks ago     5.57MB
redis                                           alpine       3900abf41552   5 months ago    32.4MB
python                                          3.4-alpine   c06adcf62f6e   3 years ago     72.9MB
$ docker image ls alpine
$ docker history 
# 查看redis镜像图层组成，使用redis镜像ID
$ docker history 3900abf41552
IMAGE          CREATED        CREATED BY                                      SIZE      COMMENT
3900abf41552   5 months ago   /bin/sh -c #(nop)  CMD ["redis-server"]         0B        
<missing>      5 months ago   /bin/sh -c #(nop)  EXPOSE 6379                  0B        
<missing>      5 months ago   /bin/sh -c #(nop)  ENTRYPOINT ["docker-entry…   0B        
<missing>      5 months ago   /bin/sh -c #(nop) COPY file:c48b97ea65422782…   377B      
<missing>      5 months ago   /bin/sh -c #(nop) WORKDIR /data                 0B        
<missing>      5 months ago   /bin/sh -c #(nop)  VOLUME [/data]               0B        
<missing>      5 months ago   /bin/sh -c mkdir /data && chown redis:redis …   0B        
<missing>      5 months ago   /bin/sh -c set -eux;   apk add --no-cache --…   25.5MB    
<missing>      5 months ago   /bin/sh -c #(nop)  ENV REDIS_DOWNLOAD_SHA=5b…   0B        
<missing>      5 months ago   /bin/sh -c #(nop)  ENV REDIS_DOWNLOAD_URL=ht…   0B        
<missing>      5 months ago   /bin/sh -c #(nop)  ENV REDIS_VERSION=6.2.6      0B        
<missing>      5 months ago   /bin/sh -c apk add --no-cache   'su-exec>=0.…   1.34MB    
<missing>      5 months ago   /bin/sh -c addgroup -S -g 1000 redis && addu…   4.7kB     
<missing>      5 months ago   /bin/sh -c #(nop)  CMD ["/bin/sh"]              0B        
<missing>      5 months ago   /bin/sh -c #(nop) ADD file:9233f6f2237d79659…   5.58MB    
```

说明：如上面示例，ADD, apk命令会带来体积增长，CMD命令并不占空间。

**体积压缩方式**

了解了镜像构建中体积增大的原因，那么就可以对症下药：**精简层数**或**精简每一层大小**。 

精简层数的方法有如下几种： 

1. [RUN指令合并](https://zhuanlan.zhihu.com/p/161685245/edit#run%E6%8C%87%E4%BB%A4%E5%90%88%E5%B9%B6) ：指令合并是最简单也是最方便的降低镜像层数的方式。该操作节省空间的原理是在同一层中清理“缓存”和工具软件。

2. [多阶段构建](https://zhuanlan.zhihu.com/p/161685245/edit#%E5%A4%9A%E9%98%B6%E6%AE%B5%E6%9E%84%E5%BB%BA)：多阶段构建方法是官方打包镜像的最佳实践，它是将精简层数做到极致的方法。通俗点讲它是将打包镜像分成两个阶段，一个阶段用于开发，打包，该阶段包含构建应用程序所需的所有内容；一个用于生产运行，该阶段只包含你的应用程序以及运行它所需的内容。这被称为“建造者模式”。两个阶段的关系有点像JDK和JRE的关系。使用多阶段构建肯定会降低镜像大小，但是瘦身的粒度和编程语言有关系，对编译型语言效果比较好，因为它去掉了编译环境中多余的依赖，直接使用编译后的二进制文件或jar包。而对于解释型语言效果就不那么明显了。

精简每一层的方法有如下几种：

- [使用合适的基础镜像](https://zhuanlan.zhihu.com/p/161685245/edit#%E4%BD%BF%E7%94%A8%E5%90%88%E9%80%82%E7%9A%84%E5%9F%BA%E7%A1%80%E9%95%9C%E5%83%8F)（首选alpine，体积通常较小）Alpine 是一个高度精简又包含了基本工具的轻量级 Linux 发行版，基础镜像只有 4.41M，各开发语言和框架都有基于 Alpine 制作的基础镜像，强烈推荐使用它。进阶可以尝试使用scratch和busybox镜像进行基础镜像的构建。
- [删除RUN的缓存文件](https://zhuanlan.zhihu.com/p/161685245/edit#%E5%88%A0%E9%99%A4run%E7%9A%84%E7%BC%93%E5%AD%98%E6%96%87%E4%BB%B6)

**Dockfile最佳实践**

- 编写.dockerignore文件
- 一个容器只运行单个应用
- 基础镜像和生产镜像的标签不要使用latest
- 设置WORKDIR和CMD
- 使用ENTRYPOINT，并用exec启动命令（可选）
- 相比ADD，优先使用COPY
- 设置默认的环境变量，映射端口和数据卷
- 使用LABEL设置镜像元数据
- 添加HEALTHCHECK

小结

* 多使用 Dockerfile生成新镜像，减少commit方式生成的镜像。每commit一次相当于在原有基础镜像上再增加内容（因为docker文件系统为overlay，删除的文件目录仍会占用存储空间）。

<br>

## 本章参考

* 使用Docker Stack部署应用  https://zhuanlan.zhihu.com/p/182198031

* Best practices for writing Dockerfiles. https://docs.docker.com/develop/develop-images/dockerfile_best-practices/

* [docker多阶段构建](https://docs.docker.com/develop/develop-images/multistage-build/)

* [三个技巧，将 Docker 镜像体积减小 90%](https://www.infoq.cn/article/3-simple-tricks-for-smaller-docker-images)

* [优化Dockerfile最佳实践](https://blog.csdn.net/xyz_dream/article/details/89741751%3Futm_medium%3Ddistribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.nonecase%26depth_1-utm_source%3Ddistribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.nonecase)

* [alpine3.12镜像](https://github.com/alpinelinux/docker-alpine/blob/90788e211ec6d5df183d79d6cb02e068b258d198/x86_64/Dockerfile)

* Dockerfile中ENTRYPOINT和CMD的区别和最佳实践  https://www.jianshu.com/p/54cfa5721d5f

<br><br>

# 6 镜像实例

## 6.1  docker常用镜像

* 拉取镜像:  docker pull xxx:xxx
* 运行镜像：docker run
* 镜像都来自于官网 docker.io
* 镜像tag不要用latest，要固化明确的版本。

表格 alpine基础镜像

| images            | 镜像大小   | 实例描述        | 实例启动命令 run                   | 访问URL |
| ----------------- | ------ | ----------- | ---------------------------- | ----- |
| alpine            | 5.57MB | 安全的轻量级linux | docker run alpine echo '123' |       |
| redis:alpine      | 32.4MB | redis       |                              |       |
| python:3.7-alpine | 41.8MB | python3.7   |                              |       |
| python:3.4-alpine | 72.9MB | python3.4   |                              |       |
| nginx:alpine      | 286MB  |             |                              |       |
|                   |        |             |                              |       |

> Alpine: `Alpine` 操作系统是一个面向安全的轻型 `Linux` 发行版。它不同于通常 `Linux` 发行版，`Alpine` 采用了 `musl libc` 和 `busybox` 以减小系统的体积和运行时资源消耗，但功能上比 `busybox` 又完善的多，因此得到开源社区越来越多的青睐。在保持瘦身的同时，`Alpine` 还提供了自己的包管理工具 `apk`，可以通过 `https://pkgs.alpinelinux.org/packages` 网站上查询包信息，也可以直接通过 `apk` 命令直接查询和安装各种软件。

```shell
$ docker images |grep alpine
alpine   latest       0ac33e5f5afa   5 weeks ago     5.57MB
redis    alpine       3900abf41552   5 months ago    32.4MB
python   3.4-alpine   c06adcf62f6e   3 years ago     72.9MB
```

表格 常用基础镜像 （不改源码，只作最基础服务的镜像 ）

| images                     | 镜像大小   | 实例描述               | 实例启动命令 run                                                                                | 访问URL           |
| -------------------------- | ------ | ------------------ | ----------------------------------------------------------------------------------------- | --------------- |
| nginx:1.9                  |        | nginx后台服务          | docker run --name keefe-nginx -p 8081:80 -d nginx:1.9                                     | http://IP:8081/ |
| linuxserver/nginx          |        | linux服务器的nginx服务   |                                                                                           |                 |
| tomcat                     |        | tomcat             |                                                                                           |                 |
| ubuntu:15.10               | 72.8MB | 交互式启动：进入操作系统ubuntu | docker run -i -t ubuntu:15.10 /bin/bash                                                   |                 |
| redis:3.2                  | 105MB  | redis后台服务          | docker run -p 6379:6379 -v  $PWD/data:/data -d redis:3.2  redis-server --appendonly yes   |                 |
| rqbbitmq:3.6.15-management | 138MB  |                    |                                                                                           |                 |
| mysql                      | 448MB  | mysql后台服务          | docker run --name keefe-mysql -p 3306:3306 -e  MYSQL_ROOT_PASSWORD=123456 -d mysql:latest | mysql://xx:3306 |
| mongo                      |        | mongo              | docker run --name mongo -d mongo                                                          |                 |
| tensorflow                 | 800MB  | 交互式启动tensorflow    | docker run -it tensorflow/tensorflow /bin/bash                                            |                 |
| python:3.7                 | 852MB  | 调用python解释器        | docker run python:3.7 python3 -c 'import  copy;print("hello")'                            |                 |

表格 常用服务型镜像（镜像实例可以直接作为提供为业务服务）

| images                | 镜像大小   | 实例描述         | 实例启动命令 run                                                                                                                                                                                           | 访问URL           |
| --------------------- | ------ | ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| minio                 | 406MB  | 对象存储         | docker run -d -p 9000:9000 -p 9090:9090 --name minio1 -e "MINIO_ROOT_USER=admin" -e "MINIO_ROOT_PASSWORD=123456" -v /data:/data  --restart=always minio/minio server /data --console-address ':9090' | http://IP:9090/ |
| elasticsearch         |        | 单节点ES        | docker run -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.12.0                                                                            |                 |
| apache/superset:1.0.0 | 1.45GB | 同上。压缩后535MB  | docker run -d -p 8088:8088 --name superset apache/superset:1.0.0                                                                                                                                     | 同上              |
| amancevice/superset   | 2.25GB | 后台启动superset | docker run --name my_superset -d -p 8088:8088 -v /home/ai/superset:/home/superset amancevice/superset                                                                                                | http://IP:8088/ |
| wordpress +mysql      |        | 两个容器链接在一起    | docker run --name wordpress --link <contain_name]:mysql -p 80:80 -d wordpress                                                                                                                        | http://IP/      |
| apache/drill          | 936MB  |              |                                                                                                                                                                                                      |                 |
|                       |        |              |                                                                                                                                                                                                      |                 |

> minio: **MinIO** 是一个基于 Apache License v2.0 开源协议的对象存储服务。它兼容亚马逊 S3 云存储服务接口，非常适合于存储大容量非结构化的数据，例如图片、视频、日志文件、备份数据和容器/虚拟机镜像等，而一个对象文件可以是任意大小，从几 kb 到最大 5T 不等。

表格 其它镜像 （基础和服务型镜像之外的）

| images                   | 镜像大小   | 实例描述       | 实例启动命令 run                                                                                       | 访问URL |
| ------------------------ | ------ | ---------- | ------------------------------------------------------------------------------------------------ | ----- |
| hello-world              | 13.3KB | 运行：打印帮助文档  | docker run hello-world                                                                           |       |
| docker/getting-started   | 27.4MB | docker入门文档 | docker run -d -p 80:80 docker/getting-started                                                    |       |
| docker_practice:vuepress | 46.9MB | docker实践文档 | docker run -it --rm -p 4000:80 ccr.ccs.tencentyun.com/dockerpracticesig/docker_practice:vuepress |       |
| hashicorp/http-echo      | 3.97MB | 服务端回显      | //回显内容来自入参-text的值，go实现，不支持mac平台<br>docker run -p 5678:5678 hashicorp/http-echo -text apple       |       |

备注：如果docker run在git bash下无法启动，可换用docker toolbox shell。

1. 镜像用` : `分隔版本号。---name指的是当前启动容器名称。-d后台启动，-i交互式启动。
2. windows下docker环境用`docker-machine ip defalut`获取虚拟IP，用此IP进行访问。

```shell
# docker run时本地无镜像，则从官网下载；再运行
$ docker run -d -p  9000:9000 --privileged -v /var/run/docker.sock:/var/run/docker.sock  uifd/ui-for-docker
Unable to find image 'uifd/ui-for-docker:latest' locally
Trying to pull repository docker.io/uifd/ui-for-docker ...
latest: Pulling from docker.io/uifd/ui-for-docker
841194d080c8: Pull complete
Digest: sha256:fe371ff5a69549269b24073a5ab1244dd4c0b834cbadf244870572150b1cb749
Status: Downloaded newer image for docker.io/uifd/ui-for-docker:latest
743e47f7ece394774920b35990a72e39622b976042accb69543835e25b08e22c

$ docker images
REPOSITORY                      TAG                 IMAGE ID            CREATED             SIZE
docker.io/ubuntu                latest              1318b700e415        2 weeks ago         72.8 MB
docker.io/amancevice/superset   latest              bc910e3fc165        5 weeks ago         2.25 GB
docker.io/registry              2                   1fd8e1b0bb7e        3 months ago        26.2 MB
docker.io/hello-world           latest              d1165f221234        5 months ago        13.3 kB
docker.io/uifd/ui-for-docker    latest              965940f98fa5        4 years ago         8.1 MB
```

**1.  运行入门容器hello-world**

```shell
$ docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://cloud.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/engine/userguide/
```

**2. nginx部署**

```sh
docker run -d -p 8082:80 --name runoob-nginx-test-web -v ~/nginx/www:/usr/share/nginx/html -v ~/nginx/conf/nginx.conf:/etc/nginx/nginx.conf -v ~/nginx/logs:/var/log/nginx nginx
```

命令说明：

* -p 8082:80： 将容器的 80 端口映射到主机的 8082 端口。
* --name runoob-nginx-test-web：将容器命名为 runoob-nginx-test-web。
* -v ~/nginx/www:/usr/share/nginx/html：将我们自己创建的 www 目录挂载到容器的 /usr/share/nginx/html。
* -v ~/nginx/conf/nginx.conf:/etc/nginx/nginx.conf：将我们自己创建的 nginx.conf 挂载到容器的 /etc/nginx/nginx.conf。
* -v ~/nginx/logs:/var/log/nginx：将我们自己创建的 logs 挂载到容器的 /var/log/nginx。

## 6.2  操作系统ubuntu

镜像：ubuntu:15.10

备注：官网的ubuntu镜像只含linux内核和基础命令约89.3MB，安装gcc/g++后约增加180MB（合计266MB），再安装vim增加60MB（合计327MB）。

1. 运行容器ubuntu中Hello World

`docker run ubuntu:15.10 /bin/echo "Hello world"`

2. -i -t 交互式启动，交互式启动时不能使用 -name

```sh
$ docker run -i -t ubuntu:15.10 /bin/bash

# 进入到容器里（exec交互式调用需要容器本身支持tty终端）
$ docker exec -it [images]  /bin/bash
```

3. **Docker挂载本地目录及实现文件共享**

Docker容器启动的时候，如果要挂载宿主机的一个目录，可以用-v参数指定。

譬如我要启动一个centos容器，宿主机的/test目录挂载到容器的/soft目录，可通过以下方式指定：（要求两边都是全路径，不能出现相对路径）

`$ docker run -it -v /test:/soft centos /bin/bash`

这样在容器启动后，容器内会自动创建/soft的目录。通过这种方式，我们可以明确一点，即-v参数中，冒号":"前面的目录是宿主机目录，后面的目录是容器内目录。

```sh
# 复制文件
$ docker cp [contain_id]:/xx xxx
```

4. **保存新镜像**
   
   ```shell
   $ docker commit -m='' -a=[author] [contain_id] [dst_image:tag]
   # 示例
   $ docker commit -m='add gcc' -a=keefewu [contain_id] keefe/ubuntu:3
   ```

## 6.3 Devop全家桶

表格  devops常用镜像

| 镜像                                            | 镜像大小   | 简介            | 运行命令                                                                                                                                                                                | 访问              |
| --------------------------------------------- | ------ | ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| gitlab/gitlab-ce:12.9.3-ce.0                  | 1.92G  | 源仓管理          |                                                                                                                                                                                     |                 |
| gitlab/gitlab-runner:v12.9.0                  | 390MB  | CICD支持        |                                                                                                                                                                                     |                 |
| caturbhuja/vscode-server-3.1.1:python3.6-base | 885MB  | web版vscode    |                                                                                                                                                                                     |                 |
| codercom/code-server                          | 1.63GB | web版vscode    | docker run -d -u root -p 8088:8080 --name code-server -v /home/docker/code/config.yaml:/root/.config/code-server/config.yaml  -v /home/ docker/code:/home/code codercom/code-server | http://IP:8088/ |
| jenkis                                        |        | jenkis CICD服务 | docker run -d jenkins/jenkins:lts /bin/bash                                                                                                                                         | http://IP:8080/ |

### CICD之Jenkis

jenkis进阶使用详见： [jenkins用户手册](./jenkins%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C.md)

jenkins官网 [https://jenkins.io/](https://jenkins.io/)

安装： https://jenkins.io/zh/doc/book/installing/

镜像：jenkins/jenkins:lts

docker启动：创建容器，缺省8080端口。

**法1：docker run**

```shell
docker run --name jenkins -d -p 8080:8080 -p 50000:50000 --restart always \
       jenkins/jenkins:lts
```

**法2：docker-compose up**

配置文件：docker-compose.yml

```yaml
version: '3'
services:
  docker_jenkins:
    user: root
    restart: always
    image: jenkins/jenkins:lts
    container_name: docker_jenkins
    ports:
      - '8080:8080'
      - '50000:50000'
    volumes:
      - /e/data/jenkins_home/:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/bin/docker:/usr/bin/docker
```

### docker远程调试sshd

```shell
# 进入容器内执行以下操作：安装sshd
# linux安装sshd：
apt-get install openssh-server

# 配置sshd：
vim /etc/ssh/sshd_config
PermitRootLogin yes         #允许root认证登录
PasswordAuthentication yes  #允许密码认证

# linux开通ssh服务
/usr/sbin/sshd -D

# 修改root密码 用于远程ssh root密码登陆
passwd root

# 重启sshd(可选)
service ssh restart

# 在宿主机保存镜像为开发镜像，启动导出SSH端口的容器
docker commit <container_id> xxx_service:dev_20220729
docker run -p 55555:22 -it xxx_service:dev_20220729 /bin/bash
```

然后将上面容器重新保存为镜像，打个dev标签，后续就可将此镜像用于远程登陆调试。

<br><br>

# 7 docker管理工具

| 工具名                                                       | 镜像大小   | 描述               | 使用                                                                                                                                            | 访问             |
| --------------------------------------------------------- | ------ | ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------- | -------------- |
| portainer                                                 | 79MB   | docker管理可视化。     | `docker run -d -p 9000:9000 --restart=always -v /var/run/docker.sock:/var/run/docker.sock --name prtainer-test docker.io/portainer/portainer` | http://IP:9000 |
| ui-for-docker                                             | 8.1MB  | docker管理可视化。     | docker run -d -p  9000:9000 --privileged -v /var/run/docker.sock:/var/run/docker.sock  uifd/ui-for-docker                                     | http://IP:9000 |
| register:2                                                | 26.2MB | 本地私有镜像仓库（常驻服务）   | docker run -d -p 5000:5000 --restart=always  --name registry2 registry:2                                                                      | http://IP:5000 |
| clair                                                     |        | 镜像安全扫描           |                                                                                                                                               |                |
| [docker-slim](https://github.com/docker-slim/docker-slim) | 无      | 镜像压缩工具           | 从Github下载其二进制文件。                                                                                                                              |                |
| Docker Desktop                                            | 无      | 桌面应用软件，支持mac和win |                                                                                                                                               |                |
| DockStation                                               | 无      | 桌面应用软件           |                                                                                                                                               |                |
| Lazydocker                                                |        | UI终端             |                                                                                                                                               |                |
| Docui                                                     |        | UI终端             |                                                                                                                                               |                |

备注：上表访问中IP指宿主机IP。

## Portainer

Portainer是Docker的图形化管理工具，提供状态显示面板、应用模板快速部署、容器镜像网络数据卷的基本操作（包括上传下载镜像，创建容器等操作）、事件日志显示、容器控制台操作、Swarm集群和服务等集中管理和操作、登录用户管理和控制等功能。功能十分全面，基本能满足中小型单位对容器管理的全部需求。

**集群运行**

默认是单节点运行。要改为集群运行，如下操作

```shell
# 先修改子节点服务器的docker.service配置文件
$ vim /lib/systemd/system/docker.service
#修改ExecStart行，IP为本机ip
#ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
ExecStart=/usr/bin/dockerd -H tcp://$IP:2375 -H unix:///var/run/docker.sock  

# 然后重启 docker
$ systemctl daemon-reload
$ systemctl restart docker
```

<br>

## 本章参考

* 5 款顶级 Docker GUI 工具！免费又好用  https://mp.weixin.qq.com/s/rPPZmT2IiZ8QmzvHMhiibw

<br>

# 容器新技术

### 容器 Podman

官网 [Podman](https://podman.io/)

Podman 是一个开源的容器运行时项目，可在大多数 Linux 平台上使用。Podman 提供与 Docker 非常相似的功能。它不需要在你的系统上运行任何<u>守护进程</u>，并且它也可以在没有 root 权限的情况下运行。

Podman 可以管理和运行任何符合 OCI（Open Container Initiative）规范的容器和容器镜像。Podman 提供了一个与 Docker 兼容的命令行前端来管理 Docker 镜像。

<br>

# 容器编排

编排Orchestration这一术语来源于音乐领域，根据作曲家的作品，编曲决定音乐作品的某一部分由某种乐器以某种方式在某个时机来演奏，这一过程称为编排。

编排这一术语被借用到了IT领域，

- Service Orchestration： 在SOA和微服务体系中，针对Service。

- Cloud Orchestration：在Cloud 体系中，针对云资源描述。

- 容器编排：负责容器的启停调度，并且通过管理容器集群来提升容器使用率。

表格6 容器编排K8s/Mesos/Swarm比较

|        | K8s                                                                                                        | Mesos                                                                        | Swarm                                                                                                              |
| ------ | ---------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| <br>简介 | 基于Google在过去十五年来大量生产环境中运行工作负载的经验。 高度通用，开源。                                                                  | 分布式调度系统内核。作为资源管理器的Apache Mesos在容器之前就已经出现很久了，支持运行容器化化和非容器化的工作负载。 适用于大型系统      | Docker开发的调度框架。 标准Docker API的使用。 易于集成和设置，灵活的API，有限的定制。                                                              |
| 支撑厂商   | Google                                                                                                     | Mesosphere                                                                   | Docker                                                                                                             |
| 核心概念   | APIServer Pod Label Service kubelet                                                                        | Master Slave Zookeeper Framework                                             |                                                                                                                    |
| 特性     | 通过Pods这一抽象的概念，解决Container之间的依赖与通信问题。Pods, Services, Deployments是独立部署的部分，可以通过Selector提供更多的灵活性。内置服务注册表和负载平衡。 | 可以支持应用程序的健康检查，开放的架构。支持多个框架和多个调度器，通过不同的Framework可以运行Haddop/Spark/MPI等多种不同的任务。 | 由于随Docker引擎一起发布，无需额外安装，配置简单。支持服务注册、服务发现，内置Overlay Network以及Load Balancer。与Docker CLI非常类似的操作命令，对熟悉Docker的人非常容易上手学习。 |

备注：2016年容器三家平分秋色；到2017年，K8s成为主流。

### K8s

详见 《[kubernetes用户手册.md](../tools.%E5%B7%A5%E5%85%B7/kubernetes%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C.md)》

### Mesos

参见 《[大数据集群管理.md](../%E5%A4%A7%E6%95%B0%E6%8D%AE%E4%B8%8EAI/bigdata/%E5%A4%A7%E6%95%B0%E6%8D%AE%E9%9B%86%E7%BE%A4%E7%AE%A1%E7%90%86.md)》 Mesos章节

### Docker Swarm

Docker Swarm是一个由Docker开发的调度框架。由Docker自身开发的好处之一就是标准Docker API的使用，Swarm由多个代理（Agent）组成，把这些代理称之为节点（Node）。这些节点就是主机，这些主机在启动Docker Daemon的时候就会打开相应的端口，以此支持Docker远程API。这些机器会根据Swarm调度器分配给它们的任务，拉取和运行不同的镜像。

![1574518882918](../../media/sf_reuse/framework/frame_docker_003.png)

图 Docker Swarm结构

Swarm基本概念：

- Manager：在整个集群中分配任务，集群中控制Worker的节点。
- Worker：运行由Manager节点分配的任务.
- Services：跨节点的执行特定接口的一组容器。.
- Key-valuestore：内建的Key-Value存储解决方案，做服务发现、服务注册以及主节点选举工作。

docker stack默认使用 swarm模式部署。

docker swarm命令

```shell
$ docker swarm --help
Usage:  docker swarm COMMAND

Manage Swarm
Commands:
  ca          Display and rotate the root CA
  init        Initialize a swarm
  join        Join a swarm as a node and/or manager
  join-token  Manage join tokens
  leave       Leave the swarm
  unlock      Unlock swarm
  unlock-key  Manage the unlock key
  update      Update the swarm

Run 'docker swarm COMMAND --help' for more information on a command.


# 节点管理
$ docker node
Usage:  docker node COMMAND
Manage Swarm nodes

Commands:
  demote      Demote one or more nodes from manager in the swarm
  inspect     Display detailed information on one or more nodes
  ls          List nodes in the swarm
  promote     Promote one or more nodes to manager in the swarm
  ps          List tasks running on one or more nodes, defaults to current node
  rm          Remove one or more nodes from the swarm
  update      Update a node

Run 'docker node COMMAND --help' for more information on a command.
```

docker swarm命令示例

```shell
# 初化化 默认成为主节点，管理节点
$ docker swarm init

# 添加工作节点 Worker 1 (wrk-1)
$ docker swarm join --token SWMTKN-1-2hl6...-...3lqg 172.31.40.192:2377
This node joined a swarm as a worker. 

# 添加管理节点
$ docker swarm join-token manager
To add a manager to this swarm, run the following command:
    docker swarm join --token SWMTKN-1-106itx81w- 192.168.0.240:2377

# 查看节点
$ docker node ls
ID            HOSTNAME  STATUS    AVAILABILITY   MANAGER STATUS
lhm...4nn *   mgr-1     Ready     Active         Leader
b74...gz3     wrk-1     Ready     Active
```

**监听端口**

```shell
firewall-cmd --zone=public -add-port=2377/tcp --permanent &&
firewall-cmd --zone=public --add-port=7946/tcp --permanent &&
firewall-cmd --zone=public --add-port=7946/udp --permanent &&
firewall-cmd --zone=public --add-port=4789/udp --permanent &&
firewall-cmd --reload
```

说明：2377 端口是集群管理通信端口，只需要在管理节点开启。7946 tcp,udp 是节点间通信使用端口，4789 是 overlay network 使用的端口。

如果docker daemon运行时没有指定端口，默认用`unix:///var/run/docker.sock`

```shell
# 相当于将默认的socket绑定在本机的2376
docker -d -H unix:///var/run/docker.sock -H 0.0.0.0:2376
```

<br>

### 本章参考

* Swarm 集群管理 https://www.runoob.com/docker/docker-swarm.html

* Docker Swarm 集群搭建  https://learnku.com/articles/37840

<br><br>

# FAQ

**1. windows下的docker后台端口访问失败**

描述：在Windows浏览器中输入localhost:8080后，出现访问失败的情况。

原因：docker是运行在linux虚拟机上的，我们在Windows系统中运行docker，实际上是先在Windows下先安装了一个Linux环境，然后在这个环境中运行的docker。所以，访问服务中使用的localhost指的是这个Linux环境的地址，而不是我们的Windows。

解决方法：获取虚拟IP来访问，不能使用localhost或者127.0.0.1

```sh
$ docker-machine ip defalut
192.168.100.99
```

**2. docker exec -it returns: cannot enable tty mode on non tty input**

描述：不要用 -it交互式启动

原因：用了不支持tty终端的命令行。

解决方法：切换到专门提供的docker命令行(Docker Toolbox)执行，不要在git bash或CMD下执行命令。(OK)

或者

`docker exec -i c $ c> docker exec -it`   // 备注：未测试成功

**3. docker login 报【Error response from daemon: Get https://172.17.8.201:8002/v2/: http: server gave HTTP response to HTTPS client】**

原因：docker镜像仓库暂不支持https。

解决方法：daemon.json里添加 { "insecure-registries":["172.17.8.201:8003"] }， 然后重启docker服务即可。

## 版本兼容问题

**1. docker 启动容器报错：Error response from daemon: oci runtime error:**

描述：

```shell
[ai@ecs-ce1a ~]$ docker run -d -p 8080:8088 --name superset3 apache/superset
c17dc1bbeaee20e75a7d1b5e64d47a96145eb6ff986c2e4a66ea08b4b69d8b91
docker: Error response from daemon: OCI runtime create failed: container_linux.go:370: starting container process caused: process_linux.go:338: getting the final child's pid from pipe caused: read init-p: connection reset by peer: unknown.
```

原因：linux与docker版本的兼容性问题，通常需要降低docker版本。

解决方法：

**2. docker build报错**

描述：

```shell
$ docker build .
Sending build context to Docker daemon 17.41 kB
Step 1/45 : ARG NODE_VERSION=12
Please provide a source image with `from` prior to commit
```

原因：linux与docker版本的兼容性问题，通常需要降低docker版本。允许这种用法是在`docker 17.05.0-ce (2017-05-04)`之后才引入的。

解决方法：升级版本至CE-17.05之后。

<br>

# 参考资料

**Docker官方英文资源**

docker官网：http://www.docker.com  分社区CE和商业EE版

Docker windows入门：https://docs.docker.com/windows/

Docker Linux 入门：https://docs.docker.com/linux/

Docker mac 入门：https://docs.docker.com/mac/

Docker 用户指引：https://docs.docker.com/engine/userguide/

Docker 官方博客：http://blog.docker.com/

Docker Hub: https://hub.docker.com/

Docker开源： https://www.docker.com/open-source

boot2docker  http://boot2docker.io/  用于windows和 Mac，已Deprecated

Github Docker源码：https://github.com/docker/docker

**Docker中文资源**

Docker中文网站：https://www.docker-cn.com/

Docker安装手册：https://docs.docker-cn.com/engine/installation/

**Docker 国内镜像**

网易加速器：http://hub-mirror.c.163.com

官方中国加速器：https://registry.docker-cn.com

ustc的镜像：https://docker.mirrors.ustc.edu.cn

daocloud：https://www.daocloud.io/mirror#accelerator-doc （注册后使用）

<br>

**参考链接**

[1]: [Docker 教程](http://www.runoob.com/docker/docker-tutorial.html) http://www.runoob.com/docker/docker-architecture.html

[2]: Docker教程 https://www.w3cschool.cn/docker/

[3]: Docker从入门到进阶 https://yq.aliyun.com/topic/78 

[4]: 32bit-Docker跑32bit-Ubuntu14.04 https://www.jianshu.com/p/61fe3c78464a

[5]: 使用 docker-compose 快速安装Jenkins https://www.cnblogs.com/morang/p/docker-jenkins-use.html

[6]: Docker容器进入的4种方式 https://www.cnblogs.com/xhyan/p/6593075.html

* Docker Secret管理和使用  https://www.jianshu.com/p/e1df30077d75

* Docker安全配置及Docker-TLS加密  https://blog.csdn.net/kele_baba/article/details/119395564

* Docker Security: Using Docker Secrets With Swarm. https://dzone.com/articles/docker-security-using-docker-secrets-with-swarm

* docker部署code-server https://www.cnblogs.com/barwe/p/14685389.html

* docker从入门到实践  https://yeasy.gitbook.io/docker_practice/
