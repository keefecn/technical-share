| 序号 | 修改时间 | 修改内容                     | 修改人 | 审稿人 |
| ---- | -------- | ---------------------------- | ------ | ------ |
| 1    | 2018-8-4 | 创建。从《微服务架构》拆分。 | 吴启福 |        |
|      |          |                              |        |        |
---








# 目录

[目录... 1](#_Toc25398466)

[1       CNCF项目列表... 4](#_Toc25398467)

[2       容器部署 Docker. 5](#_Toc25398468)

[2.1        Docker简介... 5](#_Toc25398469)

[2.2        技术原理篇... 6](#_Toc25398470)

[2.3        安装篇... 7](#_Toc25398471)

[2.4        使用篇... 9](#_Toc25398472)

[2.4.1         docker命令组... 10](#_Toc25398473)

[2.4.2         docker仓库管理镜像... 14](#_Toc25398474)

[2.4.3         容器镜像制作... 15](#_Toc25398475)

[2.4.4         docker-compose管理多个容器... 16](#_Toc25398476)

[2.5        实例... 18](#_Toc25398477)

[2.5.1         docker镜像使用示例... 18](#_Toc25398478)

[2.5.2         操作系统ubuntu. 20](#_Toc25398479)

[2.5.3         CICD之jenkis. 21](#_Toc25398480)

[2.5.4         本节参考... 21](#_Toc25398481)

[2.6        FAQ.. 21](#_Toc25398482)

[2.7        本章参考... 22](#_Toc25398483)

[3       Kubernetes. 23](#_Toc25398484)

[3.1        概述... 23](#_Toc25398485)

[3.1.1         简介... 23](#_Toc25398486)

[3.1.2         K8s术语... 25](#_Toc25398487)

[3.2        架构篇... 27](#_Toc25398488)

[3.2.1         Borg. 27](#_Toc25398489)

[3.2.2         Kubernetes架构... 28](#_Toc25398490)

[3.2.3         多集群架构... 31](#_Toc25398491)

[3.3        安装篇... 31](#_Toc25398492)

[3.3.1         安装准备... 32](#_Toc25398493)

[3.3.2         本地Docker方案... 33](#_Toc25398494)

[3.3.3         vagrant创建单节点集群... 34](#_Toc25398495)

[3.4        使用篇... 35](#_Toc25398496)

[3.4.1         kubectl 35](#_Toc25398497)

[3.5        本章参考... 35](#_Toc25398498)

[4       Prometheus. 35](#_Toc25398499)

[4.1        架构... 36](#_Toc25398500)

[4.2        本章参考... 37](#_Toc25398501)

[5       gRPC. 38](#_Toc25398502)

[5.1        简介... 38](#_Toc25398503)

[5.2        架构... 39](#_Toc25398504)

[5.3        本章参考... 39](#_Toc25398505)

[6       Etcd. 39](#_Toc25398506)

[6.1        本章参考... 40](#_Toc25398507)

[7       Istio. 40](#_Toc25398508)

[参考资料... 40](#_Toc25398509)

 

[TOC]








# 1       CNCF项目列表

CNCF（Cloud Native Computing Foundation）于 2015 年 7 月成立，隶属于 Linux 基金会，初衷围绕“云原生”服务云计算，致力于维护和集成开源技术，支持编排容器化微服务架构应用。

CNCF 还帮助项目建立了治理结构。CNCF 提出了成熟度级别的概念：沙箱、孵化和毕业。这些级别分别对应下图中的创新者、早期采用者和早期大众。

 

表格 1 CNCF项目列表

|      | 项目        | 简介                                                         | 备注                          |
| ---- | ----------- | ------------------------------------------------------------ | ----------------------------- |
| 2015 | Kubernetes  | google于2014年创建，2015年开源，集群中管理跨多台主机容器化应用的开源系统； | K8S最热门的容器编排平台。     |
|      | Prometheus  | SoundCloud于2012年创建。专注于时间序列数据，为客户端依赖及第三方数据消费提供广泛集成支持的开源监控解决方案； | 系统及服务监控工具。          |
|      | OpenTracing | 与厂商无关的分布式追踪开源标准；                             |                               |
|      | Fluentd     | 创建统一日志层的开源数据收集器。                             | ElasticSearch公司开源。       |
| 2017 | Linkerd     | 为微服务提供可靠性支持、自动化负载均衡、服务发现和运行时可恢复性的开源“服务网格”项目 | 优步创建。   透明式服务网络。 |
|      | gRPC        | google开源，现代化高性能开源远程调用框架                     |                               |
|      | CoreDNS     | 快速灵活的构建 DNS 服务器的方案                              |                               |
|      | rkt         | 帮助开发者打包应用和依赖包，简化搭环境等部署工作，提高容器安全性和易用性的容器引擎。 | Pod原生容器引擎。             |
| ?    | Envoy       | 为云原生应用程序设计的开源边缘和服务代理。Envoy是一种高性能C++分布式代理，专为单一服务和应用程序设计，还是一种为大型微服务服务网格架构设计的通信总线和通用数据平面。 | Lyft创建。                    |
|      | **Jaeger**  | 开源端到端分布式跟踪系统。                                   | 分布式跟踪。                  |
|      | Helm        | Kubernetes的包管理器。                                       |                               |
|      | Etcd        | 可靠的分布式键值存储项目，可用于存储分布式系统中关键的数据。 | 分布式键值存储                |
|      | CRI-O       | 遵守开放容器倡议(OCI)的情况下实现了Kubernetes运行时接口。    | 针对K8s的轻量运行时           |
|      |             |                                                              |                               |

备注：

 

# 2       容器部署 Docker

## 2.1     Docker简介

本教程适合运维工程师及后端开发人员。

Docker 是一个开源的应用容器引擎，基于 [Go 语言](http://www.runoob.com/go/go-tutorial.html) 并遵从Apache2.0协议开源。 

Docker 可以让开发者打包他们的应用以及依赖包到一个轻量级、可移植的容器中，然后发布到任何流行的 Linux 机器上，也可以实现虚拟化（操作系统层虚拟化）。

容器是完全使用沙箱机制，相互之间不会有任何接口（类似 iPhone 的 app）,更重要的是容器性能开销极低。

Docker 是 [PaaS](http://baike.baidu.com/view/1413359.htm) 提供商 dotCloud 于2013年开源的一个基于 [LXC](http://baike.baidu.com/view/6572152.htm) 的高级容器引擎，源代码托管在 [Github](http://baike.baidu.com/view/3366456.htm) 上, 基于[go语言](http://baike.baidu.com/view/2976233.htm)并遵从Apache2.0协议开源。

 

**Docker的应用场景**

*  Web 应用的自动化打包和发布。
*  自动化测试和持续集成、发布。
*  在服务型环境中部署和调整数据库或其他的后台应用。
*  从头编译或者扩展现有的OpenShift或Cloud Foundry平台来搭建自己的PaaS环境。



**boot2docker**（deprecated）

boot2docker is a lightweight Linux distribution based on Tiny Core Linux made specifically to run Docker containers. It runs completely from RAM, weighs ~27MB and boots in ~5s (YMMV).

This project is officially deprecated in favor of [Docker Machine](https://docs.docker.com/machine/). The code and documentation here only exist as a reference for users who have not yet switched over (but please do soon). The recommended way to install Machine is with the [Docker Toolbox](https://docker.com/toolbox).

 

**Docker Toolbox** （win7+）

To run Docker, your machine must have a 64-bit operating system running Windows 7 or higher.

**Legacy desktop solution.** Docker Toolbox is for older Mac and Windows systems that do not meet the requirements of [Docker for Mac](https://docs.docker.com/docker-for-mac/) and [Docker for Windows](https://docs.docker.com/docker-for-windows/). We recommend updating to the newer applications, if possible.

 

[Docker for Windows](https://docs.docker.com/docker-for-windows/) （win10+）

Docker for Windows requires Windows 10 Pro or Enterprise version 14393, or Windows server 2016 RTM to run

 

## 2.2     技术原理篇

​                 ![1574518833495](../../media/sf_reuse/framework/frame_docker_001.png)                                 

图 1 容器技术与VM技术的比较

 

**Docker** **架构**

Docker 容器通过 Docker 镜像来创建。

容器与镜像的关系类似于面向对象编程中的对象与类。

   ![1574518854525](../../media/sf_reuse/framework/frame_docker_002.png)

图 2 Docker 架构

说明： Docker 使用客户端-服务器 (C/S) 架构模式，Docker daemon 作为服务端一般在宿主主机后台运行，等待接收来自客户端的消息。 Docker 客户端则为用户提供一系列可执行命令（创建、运行、分发容器），用户用这些命令实现跟 Docker daemon 交互。

客户端和服务端既可以运行在一个机器上，也可通过 socket 或者RESTful API 来进行通信。

表格 2 Docker组件说明表

| Docker 镜像(Images)    | Docker 镜像是用于创建 Docker 容器的只读模板，它包含创建Docker容器的说明。 |
| ---------------------- | ------------------------------------------------------------ |
| Docker 容器(Container) | 容器是独立运行的一个或一组应用，镜像的可运行实例。镜像和容器的关系类似面向对象中的类和对象的关系。 |
| Docker  客户端(Client) | Docker  客户端通过命令行或者其他工具使用  Docker API (https://docs.docker.com/reference/api/docker_remote_api) 与 Docker 的守护进程通信。 |
| Docker 主机(Host)      | 一个物理或者虚拟的机器用于执行 Docker 守护进程和容器。       |
| Docker 仓库(Registry)  | Docker仓库用来保存镜像，类似代码控制中的代码仓库。可分为公有和私有仓库。Docker Hub(https://hub.docker.com)是官方也是默认的Docker仓库，存放着海量镜像，并可通过docker命令下载并使用。 |
| Docker Daemon          | Docker守护进程。运行在宿主机(Docker Host)的后台进程，可通过Docker客户端与之通信。 |
| Docker Machine         | Docker Machine是一个简化Docker安装的命令行工具，通过一个简单的命令行即可在相应的平台上安装Docker，比如VirtualBox、 Digital Ocean、Microsoft Azure。 |

备注：docker客户端和服务端daemon可以在同一台机器也可分布在不同机器。

 

## 2.3     安装篇

https://docs.docker.com/install/

要求安装在64位平台。

#### ubuntu安装

OS requirements

To install Docker CE, you need the 64-bit version of one of these Ubuntu versions:

Artful 17.10 (Docker CE 17.11 Edge and higher only)

Xenial 16.04 (LTS)

Trusty 14.04 (LTS)

Docker CE is supported on Ubuntu on x86_64, armhf, s390x (IBM Z), and ppc64le (IBM Power) architectures.

官网缺省不支持32位平台，需特殊处理。

 

1)  32位平台
```SHELL
$ sudo apt-get install docker.io
# 导入32位ubuntu 14.04镜像
$ sudo cat ubuntu-14.04-x86-minimal.tar.gz | docker import - ubuntu:14.04
$ sudo docker run -it ubuntu:14.04 /bin/bash
 
denny@denny-ubuntu:~$ sudo docker version 
[sudo] password for denny: 
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


2) 正常平台
```SHELL
# 会自动检测平台，下载相应最新版本
$ wget -qO- https://get.docker.com/ | sh
 
# 安装后，启动docker后台服务
$ sudo service docker start
```

#### windows安装

**win7、win8系统**

win7、win8 等需要利用 docker toolbox 来安装，国内可以使用阿里云的镜像来下载，下载地址：http://mirrors.aliyun.com/docker-toolbox/windows/docker-toolbox/

docker toolbox 是一个工具集，它主要包含以下一些内容：

*  Docker CLI 客户端，用来运行docker引擎创建镜像和容器
*  Docker Machine. 可以让你在windows的命令行中运行docker引擎命令
*  Docker Compose. 用来运行docker-compose命令
*  Kitematic. 这是Docker的GUI版本
*  Docker QuickStart shell. 这是一个已经配置好Docker的命令行环境
*  Oracle VM Virtualbox. 虚拟机

官网安装教程：https://docs.docker.com/toolbox/toolbox_install_windows/ 

下载安装后：点击Docker QuickStart图标，直到出现$。

 

**win 10+**

Docker for Windows is a desktop application based on [Docker Community Edition (CE)](https://www.docker.com/community-edition). The Docker for Windows install package includes everything you need to run Docker on a Windows system.

 

## 2.4     使用篇

安装成功后，验证docker

step 1: 启动 dockerd守护进程
```shell
$ service docker start  
# 或者 linux
$ dockerd -d
# 或者 windows
$ docker-machine 
```


step2: 测试运行hello-world镜像
```shell
$ docker run hello-world
$ docker run -it ubuntu bash
```


**镜像加速**

鉴于国内网络问题，后续拉取 Docker 镜像十分缓慢，我们可以需要配置加速器来解决，我使用的是网易的镜像地址：http://hub-mirror.c.163.com。

新版的 Docker 使用 

/etc/docker/daemon.json（Linux） 

或者 

%programdata%\docker\config\daemon.json（Windows） 

%HOME%\.docker\machine\machines\default\config.json

来配置 Daemon。

 

请在该配置文件中加入（没有该文件的话，请先建一个）：
```shell
{
  "registry-mirrors": ["http://hub-mirror.c.163.com"]
}
```


### 2.4.1  docker命令组

   ![1574518882918](../../media/sf_reuse/framework/frame_docker_003.png)

图 3 docker_commands

备注：镜像标签tag=$name:$version

 

#### 2.4.1.1 命令行

```shell
$ docker
Usage: docker [OPTIONS] COMMAND [arg...]

A self-sufficient runtime for linux containers.
Options:
  --api-cors-header=                   Set CORS headers in the remote API
  -b, --bridge=                        Attach containers to a network bridge
  --bip=                               Specify network bridge IP
  -D, --debug=false                    Enable debug mode
  -d, --daemon=false                   Enable daemon mode
  --default-ulimit=[]                  Set default ulimits for containers
  --dns=[]                             DNS server to use
  --dns-search=[]                      DNS search domains to use
  -e, --exec-driver=native             Exec driver to use
  --fixed-cidr=                        IPv4 subnet for fixed IPs
  --fixed-cidr-v6=                     IPv6 subnet for fixed IPs
  -G, --group=docker                   Group for the unix socket
  -g, --graph=/var/lib/docker          Root of the Docker runtime
  -H, --host=[]                        Daemon socket(s) to connect to
  -h, --help=false                     Print usage
  --icc=true                           Enable inter-container communication
  --insecure-registry=[]               Enable insecure registry communication
  --ip=0.0.0.0                         Default IP when binding container ports
  --ip-forward=true                    Enable net.ipv4.ip_forward
  --ip-masq=true                       Enable IP masquerading
  --iptables=true                      Enable addition of iptables rules
  --ipv6=false                         Enable IPv6 networking
  -l, --log-level=info                 Set the logging level
  --label=[]                           Set key=value labels to the daemon
  --log-driver=json-file               Containers logging driver
  --mtu=0                              Set the containers network MTU
  -p, --pidfile=/var/run/docker.pid    Path to use for daemon PID file
  --registry-mirror=[]                 Preferred Docker registry mirror
  -s, --storage-driver=                Storage driver to use
  --selinux-enabled=false              Enable selinux support    export    Export a container's filesystem as a tar archive
  --storage-opt=[]                     Set storage driver options
  --tls=false                          Use TLS; implied by --tlsverify
  --tlscacert=~/.docker/ca.pem         Trust certs signed only by this CA
  --tlscert=~/.docker/cert.pem         Path to TLS certificate file
  --tlskey=~/.docker/key.pem           Path to TLS key file
  --tlsverify=false                    Use TLS and verify the remote
  -v, --version=false                  Print version information and quit

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
    kil*      Kill a running container
    load      Load an image from a tar archive
    logi*     Register or log in to a Docker registry server
    logout    Log out from a Docker registry server
    logs      Fetch the logs of a container  查看运行镜像实例的日志
    port      Lookup the public-facing port that is NAT-ed to PRIVATE_PORT
    pause     Pause all processes within a container
    ps        List containers  查看正在运行镜像实例
    pul*      Pull an image or a repository from a Docker registry server 拉取镜像
    push      Push an image or a repository to a Docker registry server 上传镜像
    rename    Rename an existing container
    restart   Restart a running container
    rm        Remove one or more containers
    rmi       Remove one or more images
    ru*       Run a command in a new container 启动容器
    save      Save an image to a tar archive
    search    Search for an image on the Docker Hub
    start     Start a stopped container
    stats     Display a stream of a containers' resource usage statistics
    stop      Stop a running container
    tag       Tag an image into a repository
    top       Lookup the running processes of a container
    unpause   Unpause a paused container
    versio*   Show the Docker version information
    wait      Block until a container stops, then print its exit code

Run 'docker COMMAND --help' for more information on a command.

```



denny@denny-ubuntu:~/downloads$ docker run --help

```shell
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
  -e, --env=[]               Set environment variables
  --entrypoint=              Overwrite the default ENTRYPOINT of the image
  --env-file=[]              Read in a file of environment variables
  --expose=[]                Expose a port or a range of ports
  -h, --hostname=            Container host name
  --help=false               Print usage
  -i, --interactive=false    Keep STDIN open even if not attached   交互式启动
  --ipc=                     IPC namespace to use
  -l, --label=[]             Set meta data on a container
  --label-file=[]            Read in a line delimited file of labels
  --link=[]              Add link to another container 容器链接 <contain_name>:<alias>
  --log-driver=              Logging driver for container
  --lxc-conf=[]              Add custom lxc options
  -m, --memory=              Memory limit
  --mac-address=             Container MAC address (e.g. 92:d0:c6:0a:29:33)
  --memory-swap=             Total memory (memory + swap), '-1' to disable swap
  --name=              Assign a name to the container  容器别名
  --net=bridge               Set the Network mode for the container
  -P, --publish-all=false   Publish all exposed ports to random ports
  -p, --publish=[]        Publish a container's port(s) to the host 端口映射 <宿主>:<容器>
  --pid=                     PID namespace to use
  --privileged=false         Give extended privileges to this container
  --read-only=false          Mount the container's root filesystem as read only
  --restart=no               Restart policy to apply when a container exits
  --rm=false                 Automatically remove the container when it exits
  --security-opt=[]          Security Options
  --sig-proxy=true           Proxy received signals to the process
  -t, --tty=false            Allocate a pseudo-TTY	TTY终端启动
  -u, --user=                Username or UID (format: <name|uid>[:<group|gid>])
  --ulimit=[]                Ulimit options
  -v, --volume=[]            Bind mount a volume  挂载目录
  --volumes-from=[]          Mount volumes from the specified container(s)
  -w, --workdir=             Working directory inside the container

```



#### 2.4.1.2 进入容器

* 法1：docker attach  <docker_id>
  使用该命令有一个问题。当多个窗口同时使用该命令进入该容器时，所有的窗口都会同步显示。如果有一个窗口阻塞了，那么其他窗口也无法再进行操作。

* 法2（推荐）：  docker exec -it <docker_id> /bin/bash

```shell
  # 以root身份登陆docker容器
  $ docker exec -it -u root [docker_id] /bin/bash
```

* 法3：SSH

* 法4：

### 2.4.2  docker仓库管理镜像

镜像存储路径
*  linux:  /var/lib/docker
*  windows: ~/.docker/

镜像管理主要命令：

*  docker images  # 查看本地镜像列表
*  docker search xx   # 搜索某个镜像
*  docker pull xx  # 下载某个镜像

 

#### 2.4.2.1 官方镜像仓库 docker Hub

Docker Hub ( http://hub.docker.com )是缺省的官方仓库。

\# 登陆docker Hub, 推送镜像，配置文件 ~/.docker/config.json

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

#### 2.4.2.2 私有镜像仓库 Registry2

创建私有仓库Docker Registry 2.0（需docker版本高于1.6.0），Registry 2不包含界面、用户管理、权限控制等功能，如果想使用这些功能，可使用Docker Trusted Registry.

配置文件 ~/ 

```shell
$ docker run -d -p 5000:5000 --restart=always --name registry2 registry:2
```

修改tag，如果tag前不加host:port/，缺省将推送到github相应的镜像里（如果有权限）
```shell
$ docker tag [old_image:tag] [localhost:5000/new_image:tag]
$ docker push [localhost:5000/new_image:tag]
```


### 2.4.3  容器镜像制作 

当我们从docker镜像仓库中下载的镜像不能满足我们的需求时，我们可以通过以下两种方式对镜像进行更改。

* 从已经创建的容器中更新镜像，并且提交这个镜像
* 使用 Dockerfile 指令来创建一个新的镜像

**1. 更新镜像docker commit**

docker commit -m='xxx' -a=[author] [contain_id] [dst_image:tag]

**2. Dockerfile**

**容器配置文件 Dockerfile**

常用指令有：FROM RUN CMD ENV EXPOSE ADD COPY VOLUME ENTRYPOINT USER WORKDIR ONBUILD

DockerFile分为四部分组成：基础镜像、维护者信息、镜像操作指令和容器启动时执行指令。例如：

```dockerfile
---------------------- DockerFile START ----------------------
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
# ADD/COPY 将文件移入镜像，ADD会将TAR文件解压, VOLUEM挂载卷并映射到外部位置
ADD redis.tgz /rdis
COPY redis.conf $BASE_DIR
VOLUME $BASE_DIR/data

# 容器启动时执行指令 CMD 或 ENTRYPOINT执行镜像中main命令
ENTRYPOINT ['redis-server']
CMD /usr/sbin/ngnix
---------------------- DockerFile END ----------------------
```

**docker build**

命令读取指定路径下（包括子目录）所有的Dockefile，并且把目录下所有内容发送到服务端，由服务端创建镜像。另外可以通过创建.dockerignore文件（每一行添加一个匹配模式）让docker忽略指定目录或者文件。-t 创建标签。

例如：Dockerfile路径为 /tmp/docker_build/，生成镜像的标签为build_repo/my_images 
 $ docker build -t build_repo/my_images /tmp/docker_build/

 

### 2.4.4  docker-compose管理多个容器 

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
  -v, --versio*               Print version and exit
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
  dow*               Stop and remove containers, networks, images, and volumes
  events             Receive real time events from containers
  exec               Execute a command in a running container
  help               Get help on a command
  images             List images
  kil*               Kill containers
  logs               View output from containers
  pause              Pause services
  port               Print the public port for a port binding
  ps                 List containers
  pul*               Pull service images
  push               Push service images
  restart            Restart services
  rm                 Remove stopped containers
  ru*                Run a one-off command
  scale              Set number of containers for a service
  start              Start services
  stop               Stop services
  top                Display the running processes
  unpause            Unpause services
  up                 Create and start containers
  versio*            Show the Docker-Compose version information
```

配置文件：docker-compose.yml 或者 xxx.yml

```yaml
info:
 build: .
 links:
  - reids
 ports
  - "8080:5001"
redis:
 image: redis
```

#  -d后台启动

```sh 
$ doccker-compose up -d
```



## 2.5     实例

### 2.5.1  docker镜像使用示例

*  创建镜像:  docker pull xxx:xxx
*  使用镜像如下表

表格 3 常用镜像的实例和启动命令

| images            | 实例描述                               | 实例命令                                                     | 状态                               |
| ----------------- | -------------------------------------- | ------------------------------------------------------------ | ---------------------------------- |
| hello-world       | 运行：打印帮助文档                     | docker run  hello-world                                      | ok                                 |
| ui-for-docker     | docker可视化                           | docker run -d -p  9000:9000 --privileged -v /var/run/docker.sock:/var/run/docker.sock  uifd/ui-for-docker | ok  http://<dockerd  host ip>:9000 |
| register:2        | 后台启动：本地私有镜像仓库（常驻服务） | docker run -d -p 5000:5000 --restart=always  --name registry2 registry:2 | ok                                 |
| nginx             | 后台启动：nginx后台服务                | docker run --name keefe-nginx -p 8081:80 -d nginx            | ok。访问http://xxx:8081/           |
| mysql             | 后台启动：mysql                        | docker run --name keefe-mysql -p 3306:3306 -e  MYSQL_ROOT_PASSWORD=123456 -d mysql:latest | ok                                 |
| wordpress  +mysql | 两个容器链接在一起                     | docker run --name  wordpress --link <contain_name]:mysql -p 80:80 -d wordpress |                                    |
| redis             | 后台启动：redis后台服务                | docker run -p 6379:6379 -v  $PWD/data:/data -d redis:3.2  redis-server --appendonly yes | ok                                 |
| ubuntu            | 交互式启动：进入操作系统ubuntu         | docker run -i -t ubuntu:15.10 /bin/bash                      | ok                                 |
| tensorflow        | 交互式启动：进入操作系统ubuntu         | docker run -i -t tensorflow/tensorflow /bin/bash             | ok                                 |
| python:3.5        | 调用python解释器                       | docker run python:3.5 python3 -c 'import  copy;print("hello")' | ok                                 |
| jenkis            |                                        | docker run -i -t  jenkins/jenkins:lts /bin/bash              |                                    |
|                   |                                        |                                                              |                                    |

备注：如果docker run在git bash下无法启动，可换用docker toolbox shell。

1. 镜像用 : 分隔版本号。---name指的是当前启动容器名称 
2. windows下docker环境用docker-machine ip defalut获取虚拟IP，用此IP进行访问。


**1.** 运行入门容器hello-world

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



**2.nginx** **部署**

docker run -d -p 8082:80 --name runoob-nginx-test-web -v ~/nginx/www:/usr/share/nginx/html -v ~/nginx/conf/nginx.conf:/etc/nginx/nginx.conf -v ~/nginx/logs:/var/log/nginx nginx

命令说明：

* -p 8082:80： 将容器的 80 端口映射到主机的 8082 端口。
* --name runoob-nginx-test-web：将容器命名为 runoob-nginx-test-web。 
* -v ~/nginx/www:/usr/share/nginx/html：将我们自己创建的 www 目录挂载到容器的 /usr/share/nginx/html。
* -v ~/nginx/conf/nginx.conf:/etc/nginx/nginx.conf：将我们自己创建的 nginx.conf 挂载到容器的 /etc/nginx/nginx.conf。
* -v ~/nginx/logs:/var/log/nginx：将我们自己创建的 logs 挂载到容器的 /var/log/nginx。




### 2.5.2  操作系统ubuntu

镜像：ubuntu:15.10

备注：官网的ubuntu镜像只含linux内核和基础命令约89.3MB，安装gcc/g++后约增加180MB（合计266MB），再安装vim增加60MB（合计327MB）。

**1.** **运行容器ubuntu中Hello World**

docker run ubuntu:15.10 /bin/echo "Hello world"

 

**2. -i -t** **交互式启动，交互式启动时不能使用** **-name**

docker run -i -t ubuntu:15.10 /bin/bash

 

*  **进入到容器里（exec交互式调用需要容器本身支持tty终端）**

docker exec -it [images]  /bin/bash 

 

*  **Docker挂载本地目录及实现文件共享**

Docker容器启动的时候，如果要挂载宿主机的一个目录，可以用-v参数指定。

譬如我要启动一个centos容器，宿主机的/test目录挂载到容器的/soft目录，可通过以下方式指定：（要求两边都是全路径，不能出现相对路径）

$ docker run -it -v /test:/soft centos /bin/bash

这样在容器启动后，容器内会自动创建/soft的目录。通过这种方式，我们可以明确一点，即-v参数中，冒号":"前面的目录是宿主机目录，后面的目录是容器内目录。

\# 复制文件

$ docker cp [contain_id]:/xx xxx

 

*  **保存新镜像**

docker commit -m='' -a=[author] [contain_id] [dst_image:tag]

如 docker commit -m='add gcc' -a=keefewu [contain_id] keefe/ubuntu:3

### 2.5.3  CICD之jenkis

**jenkis进阶使用：详见** **本人另文《运维场景》章节之运维工具Jenkins**

 

jenkins官网 https://jenkins.io/

镜像：jenkins/jenkins:lts

**docker启动：创建容器**

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



### 2.5.4  本节参考

## 2.6     FAQ

**1)  windows下的docker后台端口访问失败**

描述：在Windows浏览器中输入localhost:8080后，出现访问失败的情况。

原因：docker是运行在linux虚拟机上的，我们在Windows系统中运行docker，实际上是先在Windows下先安装了一个Linux环境，然后在这个环境中运行的docker。所以，访问服务中使用的localhost指的是这个Linux环境的地址，而不是我们的Windows。

解决方法：获取虚拟IP来访问，不能使用localhost或者127.0.0.1

$ docker-machine ip defalut  

192.168.100.99

 

**2)  docker exec -it returns: cannot enable tty mode on non tty input**

描述：不要用 -it交互式启动

原因：用了不支持tty终端的命令行。

解决方法：切换到专门提供的docker命令行(Docker Toolbox)执行，不要在git bash或CMD下执行命令。(OK)

或者 

docker exec -i c $ c> docker exec -it   # 注：未测试成功

 

**3). 批量删除tag为None的镜像** 

**描述**：

**原因**：有时候重新构建镜像(build) 的时候，该镜像正在被某容器使用中，那么在重新构建同名同版本镜像后，docker保留原来的镜像，即容器还是用原来的，除非重启。那么原来的镜像名称变成NONE，TAG也成了NONE。

**解决方法：（3种方法，慎用）**

```shell
docker images|grep none|awk '{print $3}'|xargs docker rmi
docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
docker rmi $(docker images -f "dangling=true" -q)

# 在删除镜像前先删除停止的容器，
docker rm $(docker ps -a -q)

# 清理当前未运行的容器（未验证）
docker system prune
```

 

## 2.7     本章参考

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

 

**Docker** **国内镜像**

网易加速器：http://hub-mirror.c.163.com 

官方中国加速器：https://registry.docker-cn.com 

ustc的镜像：https://docker.mirrors.ustc.edu.cn 

daocloud：https://www.daocloud.io/mirror#accelerator-doc （注册后使用）

 

**参考链接**

[1].     [Docker 教程](http://www.runoob.com/docker/docker-tutorial.html) http://www.runoob.com/docker/docker-architecture.html 

[2].     Docker教程 https://www.w3cschool.cn/docker/ 

[3].     Docker从入门到进阶https://yq.aliyun.com/topic/78?spm=5176.8275330.622780.11.LK3KRG 

[4].     32bit-Docker跑32bit-Ubuntu14.04 https://www.jianshu.com/p/61fe3c78464a

[5].     使用 docker-compose 快速安装Jenkins https://www.cnblogs.com/morang/p/docker-jenkins-use.html 

[6].     Docker容器进入的4种方式 https://www.cnblogs.com/xhyan/p/6593075.html 

[7].     jenkins https://jenkins.io/zh/doc/book/installing/

# 3       Kubernetes

## 3.1     概述

### 3.1.1  简介

​         **Kubernetes**的名字来自希腊语，意思是“*舵手**”* 或 “*领航员”*。*K8s*是将8个字母“ubernete”替换为“8”的缩写。是一个开源的，用于管理云平台中多个主机上的容器化的应用，Kubernetes的目标是让部署容器化的应用简单并且高效（powerful）,Kubernetes提供了应用部署，规划，更新，维护的一种机制。

​         Kubernetes是Google 2014年创建管理的，是Google 10多年大规模容器管理技术Borg的开源版本。    

​         在Kubernetes中，我们可以创建多个容器，每个容器里面运行一个应用实例，然后通过内置的负载均衡策略，实现对这一组应用实例的管理、发现、访问，而这些细节都不需要运维人员去进行复杂的手工配置和处理。

​         Kubernetes 属于主从的分布式集群架构，包含 Master 和 Node：Master 作为控制节点，调度管理整个系统；Node 是运行节点，运行业务容器。

 

**Kubernetes** **特点**

*  可移植: 支持公有云，私有云，混合云，多重云（multi-cloud）

*  可扩展: 模块化，插件化，可挂载，可组合

*  自动化: 自动部署，自动重启，自动复制，自动伸缩/扩展

 

**容器优势总结：**

- **快速创建/部署应用：**与VM虚拟机相比，容器镜像的创建更加容易。
- **持续开发、集成和部署：**提供可靠且频繁的容器镜像构建/部署，并使用快速和简单的回滚(由于镜像不可变性)。
- **开发和运行相分离：**在build或者release阶段创建容器镜像，使得应用和基础设施解耦。
- **开发，测试和生产环境一致性：**在本地或外网（生产环境）运行的一致性。
- **云平台或其他操作系统：**可以在 Ubuntu、RHEL、 CoreOS、on-prem、Google      Container Engine或其它任何环境中运行。
- **Loosely coupled，分布式，弹性，微服务化：**应用程序分为更小的、独立的部件，可以动态部署和管理。
- **资源隔离**
- **资源利用：**更高效

 

   ![1574519347217](../../media/sf_reuse/framework/frame_k8s_001.png)

 ![1574519369627](../../media/sf_reuse/framework/frame_k8s_002.png)

   

图 4 K8s组件

### 3.1.2  K8s术语

表格 4 K8s关键术语


| 名词                   | 释义                                                         | 设计理念                                                     |
| ---------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| API对象                | K8s集群中的管理操作单元。K8s集群系统每支持一项新功能，引入一项新技术，一定会新引入对应的API对象，支持对该功能的管理操作。 | K8s中所有的配置都是通过API对象的spec去设置的。即所有的操作都是声明式（Declarative）的而不是命令式（Imperative）的。 |
| Pod                    | 微服务。K8s集群中运行部署应用或服务的最小单元，它是可以支持多容器的。Pod是K8s集群中所有业务类型的基础，可以看作运行在K8s集群中的小机器人，不同类型的业务就需要不同类型的小机器人去执行。 | 支持多个容器在一个Pod中共享网络地址和文件系统，可以通过进程间通信和文件共享这种简单高效的方式组合完成服务。 |
| 复制控制器 RC          | （Replication Controller，RC），RC是K8s集群中最早的保证Pod高可用的API对象。 | 通过监控运行中的Pod来保证集群中运行指定数目的Pod副本（1~多个）。 |
| 副本集 RS              | （Replica Set，RS）新一代RC，提供同样的高可用能力，区别主要在于RS后来居上，能支持更多种类的匹配模式。 | 副本集对象一般不单独使用，而是作为Deployment的理想状态参数使用。 |
| 部署(Deployment)       | 部署表示用户对K8s集群的一次更新操作。部署是一个比RS应用模式更广的API对象，可以是创建/更新/滚动升级新服务 |                                                              |
| 服务（Service）        | 在K8s集群中，客户端需要访问的服务就是Service对象。在K8s集群中微服务的负载均衡是由Kube-proxy实现的。 | 每个Service会对应一个集群内部有效的虚拟IP，集群内部通过虚拟IP访问一个服务。 |
| 任务（Job）            | Job是K8s用来控制批处理型任务的API对象。                      | Job管理的Pod根据用户的设置把任务成功完成就自动退出了。       |
| 后台支撑服务集         | （DaemonSet）后台支撑型服务的核心关注点在K8s集群中的节点（物理机或虚拟机），要保证每个节点上都有一个此类Pod运行。 |                                                              |
| 有状态服务集（PetSet） | PetSet用来控制有状态服务，PetSet中的每个Pod的名字都是事先确定的，不能更改。 | 适合于PetSet的业务包括数据库服务MySQL和PostgreSQL，集群化管理服务Zookeeper、etcd等有状态服务。 |
| 集群联邦               | （Federation）为提供跨Region跨服务商K8s集群服务而设计的。    |                                                              |
| 存储卷                 | （Volume）K8s的存储卷的生命周期和作用范围是一个Pod。         |                                                              |
|                        | 持久存储卷（Persistent Volume，PV）和持久存储卷声明（Persistent Volume Claim，PVC） |                                                              |
| 节点（Node）           | K8s集群中的计算能力由Node提供。 Node可以是物理机也可以是虚拟机。 | K8s集群中的Node也就等同于Mesos集群中的Slave节点，是所有Pod运行所在的工作主机。 |
| 名字空间（Namespace）  | 名字空间为K8s集群提供虚拟的隔离作用，K8s集群初始有两个名字空间，分别是默认名字空间default和系统名字空间kube-system | 管理员可以可以创建新的名字空间满足需要。                     |
| RBAC访问授权           | 基于角色的访问控制（Role-based Access Control，RBAC）的授权模式。RBAC主要是引入了角色（Role）和角色绑定（RoleBinding）的抽象概念。 | RBAC中，访问策略可以跟某个角色关联，具体的用户在跟一个或多个角色相关联 |
|                        |                                                              |                                                              |

备注：其它常用术语还有密钥对象（Secret）、用户帐户（User Account）和服务帐户（Service Account）。从K8s的系统架构、技术概念和设计理念，我们可以看到K8s系统最核心的两个设计理念：一个是容错性，一个是易扩展性。容错性实际是保证K8s系统稳定性和安全性的基础，易扩展性是保证K8s对变更友好，可以快速迭代增加新功能的基础。

1. API对象。每个API对象都有3大类属性：元数据metadata、规范spec和状态status。  
   1. 元数据是用来标识API对象的，每个对象都至少有3个元数据：namespace，name和uid；除此以外还有各种各样的标签labels用来标识和匹配不同的对象，例如用户可以用标签env来标识区分不同的服务部署环境，分别用env=dev、env=testing、env=production来标识开发、测试、生产的不同服务。
   2. 规范描述了用户期望K8s集群中的分布式系统达到的理想状态（Desired State），例如用户可以通过复制控制器Replication Controller设置期望的Pod副本数为3；
   3. status描述了系统实际当前达到的状态（Status），例如系统当前实际的Pod副本数为2；那么复制控制器当前的程序逻辑就是自动启动新的Pod，争取达到副本数为3。

2. Pod: 目前K8s中的业务主要可以分为长期伺服型（long-running）、批处理型（batch）、节点后台支撑型（node-daemon）和有状态应用型（stateful application）；分别对应的小机器人控制器为Deployment、Job、DaemonSet和PetSet.

3. RC、RS和Deployment只是保证了支撑服务的微服务Pod的数量，但是没有解决如何访问这些服务的问题。Service解决服务访问的问题。RC和RS主要是控制提供无状态服务的，其所控制的Pod的名字是随机设置的，名字不重要，重要的是Pod总数。
4. 在云计算环境中，服务的作用距离范围从近到远一般可以有：同主机（Host，Node）、跨主机同可用区（Available Zone）、跨可用区同地区（Region）、跨地区同服务商（Cloud Service Provider）、跨云平台。K8s的设计定位是单一集群在同一个地域内，因为同一个地区的网络性能才能满足K8s的调度和计算存储连接要求。而联合集群服务就是为提供跨Region跨服务商K8s集群服务而设计的。

## 3.2     架构篇

### 3.2.1  Borg

Borg是谷歌内部的大规模集群管理系统，负责对谷歌内部很多核心服务的调度和管理。Borg的目的是让用户能够不必操心资源管理的问题，让他们专注于自己的核心业务，并且做到跨多个数据中心的资源利用率最大化。

Borg主要由BorgMaster、Borglet、borgcfg和Scheduler组成，如下图所示

   ![1574519402884](../../media/sf_reuse/framework/frame_cncf_001.png)

图 5 google_Borg架构

*  BorgMaster是整个集群的大脑，负责维护整个集群的状态，并将数据持久化到Paxos存储中；

*  Scheduer负责任务的调度，根据应用的特点将其调度到具体的机器上去；

*  Borglet负责真正运行任务（在容器中）；

*  borgcfg是Borg的命令行工具，用于跟Borg系统交互，一般通过一个配置文件来提交任务。

### 3.2.2  Kubernetes架构

Kubernetes借鉴了Borg的设计理念，比如Pod、Service、Labels和单Pod单IP等。Kubernetes的整体架构跟Borg非常像，如下图所示

   ![1574519428231](../../media/sf_reuse/framework/frame_k8s_003.png)

图 6 Kubernetes架构

![1574519488689](../../media/sf_reuse/framework/frame_k8s_004.png)

备注：K8s master由四部分组成，分别是API Server、Scheduler、Controller和etcd。

   ![1574519522443](../../media/sf_reuse/framework/frame_k8s_005.png)

Kubernetes主要由以下几个核心组件组成：

*  etcd保存了整个集群的状态；
*  apiserver提供了资源操作的唯一入口，并提供认证、授权、访问控制、API注册和发现等机制；
*  controller manager负责维护集群的状态，比如故障检测、自动扩展、滚动更新等；
*  scheduler负责资源的调度，按照预定的调度策略将Pod调度到相应的机器上；
*  kubelet负责维护容器的生命周期，同时也负责Volume（CVI）和网络（CNI）的管理；
*  Container runtime负责镜像管理以及Pod和容器的真正运行（CRI）；
*  kube-proxy负责为Service提供cluster内部的服务发现和负载均衡；

除了核心组件，还有一些推荐的Add-ons：

*  kube-dns负责为整个集群提供DNS服务
*  Ingress Controller为服务提供外网入口
*  Heapster提供资源监控
*  Dashboard提供GUI
*  Federation提供跨可用区的集群
*  Fluentd-elasticsearch提供集群日志采集、存储与查询


**分层架构**

Kubernetes设计理念和功能其实就是一个类似Linux的分层架构，如下图所示

   ![1574519541207](../../media/sf_reuse/framework/frame_k8s_006.png)

图 7 K8s分层架构

- 核心层：Kubernetes最核心的功能，对外提供API构建高层的应用，对内提供插件式应用执行环境

- 应用层：部署（无状态应用、有状态应用、批处理任务、集群应用等）和路由（服务发现、DNS解析等）

- 管理层：系统度量（如基础设施、容器和网络的度量），自动化（如自动扩展、动态Provision等）以及策略管理（[RBAC](http://docs.kubernetes.org.cn/148.html)、Quota、PSP、NetworkPolicy等）

- 接口层：[kubectl命令行工具](http://docs.kubernetes.org.cn/61.html)、客户端SDK以及集群联邦

- 生态系统：在接口层之上的庞大容器集群管理调度的生态系统，可以划分为两个范畴 

- - Kubernetes外部：日志、监控、配置管理、CI、CD、Workflow、FaaS、OTS应用、ChatOps等
  - Kubernetes内部：CRI、CNI、CVI、镜像仓库、Cloud       Provider、集群自身的配置和管理等

 

### 3.2.3  多集群架构

*  全世界数据中心的统一 API

*  多集群时代的 “ The Platform for Platform”

 

Kubernetes 和它所推崇的声明式[容器编排与管理体系](https://yq.aliyun.com/go/articleRenderRedirect?url=https%3A%2F%2Fwww.infoq.cn%2Farticle%2FR1p3H3_29f4TYImExsyw)，让软件交付本身变得越来越标准化和统一化，并且实现了与底层基础设施的完全解耦；而另一方面，云原生技术体系在所有公有云和大量数据中心里的落地，使得软件面向一个统一的 API 实现“一次定义，到处部署”成为了可能。

Kubernetes 项目的本质其实是 Platform for Platform，也就是一个用来构建“平台”的“平台”。 相比于 Mesos 和 Swarm 等容器管理平台，Kubernetes 项目最大的优势和关注点，在于它始终专注于如何帮助用户基于 Kubernetes 的声明式 API ，快速、便捷的构建健壮的分布式应用，并且按照统一的模型（容器设计模式和控制器机制）来驱动应用的实际状态向期望状态逼近和收敛。

   ![1574519565059](../../media/sf_reuse/framework/frame_k8s_007.png)

图 8 多集群 K8s 隧道架构

如图所示，其核心分为两层，下层是被托管的集群，在其中会有一个 Agent，Agent 一方面在被托管的集群中运行，可以轻易的在内网访问被托管的集群，另一方面它通过公网与公有云接入层中的节点 (Stub) 构建一个隧道 (tunnel)。在上层，用户通过公有云统一的方式接入审计、鉴权、权限相关功能，通过访问 Stub，再通过隧道由 Agent 向用户自己的 Kubernetes 集群转发命令。

## 3.3     安装篇

工具Vagrant & VirtualBox 详见 《运维专题》

### 3.3.1  安装准备

Kubernetes可以在多种平台运行，从笔记本电脑，到云服务商的虚拟机，再到机架上的裸机服务器。要创建一个Kubernetes集群，根据不同场景需要做的也不尽相同，可能是运行一条命令，也可能是配置自己的定制集群。

*  本地服务器方案：包括三种，分别是本地Docker、Vagrant和无虚拟机本地集群（Linux）。基于Docker的本地方案：是众多能够完成快速搭建的本地集群方案中的一种，但是局限于单台机器。
*  托管解决方案（如Google Container Engine）是最容易搭建和维护的。当你准备好扩展到多台机器和更高可用性时。
*  全套云端方案（如AWS、Azure等）：只需要少数几个命令就可以在更多的云服务提供商搭建Kubernetes。
*  定制方案 需要花费更多的精力，但是覆盖了从零开始搭建Kubernetes集群的通用建议到分步骤的细节指引。


表格 5 Kubernatess发行版

| 发行版                                                       | 简介                                                         | 许可和定价模型                             | 安装                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------ | ------------------------------------------------------------ |
| 原版开源 Kubernetes                                          | Kubernetes 由 Cloud Native Computing Foundation（云原生计算资金会）和 Kubernetes 用户组成的多样化社区支持，也是第一个从 CNCF 毕业的项目。 | 开源且 100％免费                           |                                                              |
| 红帽 [OpenShift](https://www.redhat.com/en/technologies/cloud-computing/openshift) | 在 Kubernetes 之前，OpenShift 作为一个单独项目并使用完全不同的技术运行。后来，红帽意识到 Kubernetes 的能力越来越强大，因此在第 3 版中明智地将其作为 OpenShift 的核心。 | 三种定价模式：                             | 不是很复杂，但需要特定配置。                                 |
| CoreOS  [Tectonic](https://coreos.com/tectonic/)             | 由 CoreOS 创建，CoreOS 是一家致力于发展容器技术公司，但已被红帽收购，目前正在与红帽集成。优势功能如下：易于设置、用户友好的 Web UI、用户管理 对供应商的支持 | 拥有商业许可模式，最多可免费提供 10 个节点 | 可以通过安装程序或 Terraform 安装。                          |
| Stackube                                                     | 以 Kubernetes 为中心的 OpenStack 发行版。可根据所用容器运行时环境提供不同程度的多租户机制，用户可选择 Docker 或者虚拟机进行配置。 | KDC 和 Containerum 平台都是 100％开源      | 设置相对容易                                                 |
| [Rancher](https://rancher.com/kubernetes/)                   | 包含 Kubernetes 的容器管理平台。主要特点如下：跨供应商集群部署、用户管理 Web、用户界面、集成CI/CD管道。 | 100％开源，该公司可提供咨询和支持服务      | 可使用名为 RKE 的 Kubernetes 安装工具。                      |
| Canonical  Distribution of Kubernetes（[CDK](https://ubuntu.com/kubernetes)） | 由 Linux 发行版 Ubuntu 背后的公司 Canonical 支持，相当于是一个可在主流公有云提供商和 OpenStack 等私有云解决方案上轻松部署的  vanilla Kubernetes，能够轻松设置并管理跨供应商的 Kubernetes 集群，用户界面是官方 Kubernetes 仪表板。 | 完全免费。但是，每个虚拟节点有几个支持包   | 可使用 Canonical 开发的部署工具 Conjure-up 或 Juju 来完成安装。 |
| [Docker ](https://www.docker.com/products/kubernetes)社区版 /企业版 | Docker  Enterprise 3.0添加了Docker Kubernetes服务            |                                            |                                                              |
| Pivotal 容器服务 ([PKS](https://pivotal.io/cn/platform/pivotal-container-service)) | 突出的特性是与VMware虚拟机堆栈紧密集成                       |                                            |                                                              |
| [SUSE ](https://www.suse.com/products/caas-platform/)容器服务平台 | SUSE CaaS平台让人想起CoreOS Tectonic，它结合了运行容器的裸机“微型”操作系统、Kubernetes、内置的镜像仓库和集群配置工具。 |                                            |                                                              |

 

**下载并解压** **Kubernetes** **二进制文件**

$ git clone https://github.com/kubernetes/kubernetes.git

 $ ./kubernetes/cluster/get-kube-binaries.sh

./kubernetes/server/bin/kube-apiserver.tar  # 目标二进制文件

 

**选择镜像**

使用谷歌容器仓库（GCR）上托管的镜像 gcr.io/

 

### 3.3.2  本地Docker方案

说明: 本地docker方案需要linux环境。

   ![1574519587996](../../media/sf_reuse/framework/frame_k8s_008.png)

图 9 K8s集群~本地Docker方案

 

**第一步：运行Etcd**

docker run --net=host -d gcr.io/google_containers/etcd:2.0.12 /usr/local/bin/etcd --addr=127.0.0.1:4001 --bind-addr=0.0.0.0:4001 --data-dir=/var/etcd/data

 

**第二步：启动master**

```shell
docker run \
    --volume=/:/rootfs:ro \
    --volume=/sys:/sys:ro \
    --volume=/dev:/dev \
    --volume=/var/lib/docker/:/var/lib/docker:ro \
    --volume=/var/lib/kubelet/:/var/lib/kubelet:rw \
    --volume=/var/run:/var/run:rw \
    --net=host \
    --pid=host \
    --privileged=true \
    -d \
    gcr.io/google_containers/hyperkube:v1.0.1 \
    /hyperkube kubelet --containerized --hostname-override=&quot;127.0.0.1&quot; --address=&quot;0.0.0.0&quot; --api-servers=h

```


**第三步：运行service proxy**
```shell
docker run -d --net=host --privileged gcr.io/google_containers/hyperkube:v1.0.1 /hyperkube proxy --master=http://127.0.0.1:8080 
```

**测试**
```shell
kubectl get nodes
```


### 3.3.3  vagrant创建单节点集群

\# vagrant启动每个虚拟机约需1G内存。get.k8s.ios可能需翻墙访问。

**法1：脚本部署**
```shell
export KUBERNATES_PROVIDER=vagrant 
export NUM_MINIORS=2
curl -s3 https://get.k8s.io/ |bash
```


**法2：docker-compose部署**

1）下载安装docker docker-compose

2）进入虚拟机 /vagrant目录，执行下列命令

```shell
docker-compose -f k8s.yml up -d
docker ps
./kubectl get nodes
```

## 3.4     使用篇

### 3.4.1  kubectl

kubectl用于运行Kubernetes集群命令的管理工具。
```shell
kubectl [command] [TYPE] [NAME] [flags]
```

## 3.5     本章参考
[1].     Kubernetes中文社区 | 中文文档 http://docs.kubernetes.org.cn/
[2].     容器十年 ——一部软件交付编年史 https://blog.csdn.net/weixin_43970890/article/details/94569105
[3].     云原生时代， Kubernetes 多集群架构初探 https://blog.csdn.net/weixin_43970890/article/details/98959354 
[4].     解锁云原生 AI 技能|在 Kubernetes 上构建机器学习系统 https://blog.csdn.net/weixin_43970890/article/details/97134534 
[5].     云原生应用 Kubernetes 监控与弹性实践 https://blog.csdn.net/weixin_43970890/article/details/94570862 
[6].     阿里云 PB 级 Kubernetes 日志平台建设实践 https://blog.csdn.net/weixin_43970890/article/details/89883335 
[7].     10个业界最流行的Kubernetes发行版 https://blog.csdn.net/RancherLabs/article/details/98478755
[8].     基于Docker本地运行Kubernetes https://www.kubernetes.org.cn/doc-5 


# 4  Prometheus

Prometheus 是一套开源的监控、报警和时间序列数据库的组合，成立于 2012 年，由 SoundCloud 公司开发，此后许多组织接受和采用了 Prometheus，遂将其独立为开源项目。该项目使用 Go 语言开发，社区氛围非常活跃。

 

**关键功能包括：**

*  多维数据模型：metric，labels
*  灵活的查询语言：PromQL， 在同一个查询语句，可以对多个 metrics 进行乘法、加法、连接、取分数位等操作。
*  可独立部署，拆箱即用，不依赖分布式存储
*  通过Http pull的采集方式
*  通过push gateway来做push方式的兼容
*  通过静态配置或服务发现获取监控项
*  支持图表和dashboard等多种方式

## 4.1     架构

   ![1574519635361](../../media/sf_reuse/framework/frame_cncf_002.png)

图 10 Prometheus组件架构

*  Prometheus Server： 采集和存储时序数据
*  client库： 用于对接 Prometheus Server, 可以查询和上报数据
*  push gateway处理短暂任务：用于批量，短期的监控数据的汇总节点，主要用于业务数据汇报等
*  定制化的exporters,比如：HAProxy， StatsD，Graphite等等， 汇报机器数据的插件
*  告警管理：Prometheus 可以配置 rules，然后定时查询数据，当条件触发的时候，会将 alert 推送到配置的 Alertmanager
*  多种多样的支持工具

 

   ![1574519657243](../../media/sf_reuse/framework/frame_cncf_003.png)

图 11 Prometheus的整体技术架构

Prometheus的整体技术架构可以分为几个重要模块：
*  Main function：作为入口承担着各个组件的启动，连接，管理。以Actor-Like的模式协调组件的运行
*  Configuration：配置项的解析，验证，加载
*  Scrape discovery manager：服务发现管理器同抓取服务器通过同步channel通信，当配置改变时需要重启服务生效。
*  Scrape manager：抓取指标并发送到存储组件
*  Storage：
* Fanout Storage：存储的代理抽象层，屏蔽底层local storage和remote storage细节，samples向下双写，合并读取。
*  Remote Storage：Remote Storage创建了一个Queue管理器，基于负载轮流发送，读取客户端merge来自远端的数据。
* Local Storage：基于本地磁盘的轻量级时序数据库。
*  PromQL engine：查询表达式解析为抽象语法树和可执行查询，以Lazy Load的方式加载数据。
*  Rule manager：告警规则管理
*  Notifier：通知派发管理器
*  Notifier discovery：通知服务发现
*  Web UI and API：内嵌的管控界面，可运行查询表达式解析，结果展示。

## 4.2     本章参考

[1].     时序数据库连载系列：指标届的独角兽Prometheus https://blog.csdn.net/weixin_43970890/article/details/87938347 



# 5       gRPC

## 5.1     简介

[gRPC](http://www.oschina.net/p/grpc-framework) 是一个高性能、开源和通用的 RPC 框架，面向移动和 HTTP/2 设计。目前提供 C、Java 和 Go 语言版本，分别是：grpc, grpc-java, grpc-go. 其中 C 版本支持 C, C++, Node.js, Python, Ruby, Objective-C, PHP 和 C# 支持.

gRPC 基于 HTTP/2 标准设计，带来诸如双向流、流控、头部压缩、单 TCP 连接上的多复用请求等特。这些特性使得其在移动设备上表现更好，更省电和节省空间占用。

 

gRPC 一开始由 google 开发，是一款语言中立、平台中立、开源的远程过程调用(RPC)系统。

在 gRPC 里客户端应用可以像调用本地对象一样直接调用另一台不同的机器上服务端应用的方法，使得您能够更容易地创建分布式应用和服务。

   ![1574519677188](../../media/sf_reuse/framework/frame_cncf_grpg_001.png)

图 12 gRPC简图

 

**特性**

*  基于HTTP/2

HTTP/2 提供了连接多路复用、双向流、服务器推送、请求优先级、首部压缩等机制。可以节省带宽、降低TCP链接次数、节省CPU，帮助移动设备延长电池寿命等。gRPC 的协议设计上使用了HTTP2 现有的语义，请求和响应的数据使用HTTP Body 发送，其他的控制信息则用Header 表示。

*  IDL使用ProtoBuf

gRPC使用ProtoBuf来定义服务，ProtoBuf是由Google开发的一种数据序列化协议（类似于XML、JSON、hessian）。ProtoBuf能够将数据进行序列化，并广泛应用在数据存储、通信协议等方面。压缩和传输效率高，语法简单，表达力强。

*  多语言支持（C, C++, Python, PHP, Nodejs, C#, Objective-C、Golang、Java）

gRPC支持多种语言，并能够基于语言自动生成客户端和服务端功能库。目前已提供了C版本grpc、Java版本grpc-java 和 Go版本grpc-go，其它语言的版本正在积极开发中，其中，grpc支持C、C++、Node.js、Python、Ruby、Objective-C、PHP和C#等语言，grpc-java已经支持Android开发。

 

**优点：**

*  protobuf二进制消息，性能好/效率高（空间和时间效率都很不错）
*  proto文件生成目标代码，简单易用
*  序列化反序列化直接对应程序中的数据类，不需要解析后在进行映射(XML,JSON都是这种方式)
*  支持向前兼容（新加字段采用默认值）和向后兼容（忽略新加字段），简化升级
*  支持多种语言（可以把proto文件看做IDL文件）
*  Netty等一些框架集成



**缺点：**
*  GRPC尚未提供连接池，需要自行实现
*  尚未提供“服务发现”、“负载均衡”机制
*  因为基于HTTP2，绝大部多数HTTP Server、Nginx都尚不支持，即Nginx不能将GRPC请求作为HTTP请求来负载均衡，而是作为普通的TCP请求。（nginx1.9版本已支持）
*  Protobuf二进制可读性差（貌似提供了Text_Fromat功能）。默认不具备动态特性（可以通过动态定义生成消息类型或者动态编译支持）


## 5.2     架构

 

## 5.3     本章参考

[1].     gRPC 官方文档中文版 http://doc.oschina.net/grpc  

[2].     gRPC https://blog.csdn.net/xuduorui/article/details/78278808 

[3].     RPC框架性能基本比较测试 [www.useopen.net/blog/2015/rpc-performance.html](http://www.useopen.net/blog/2015/rpc-performance.html) 

 

# 6       Etcd

Etcd是CoreOS 基于 Raft 开发的分布式 key-value 存储，可用于服务发现、共享配置以及一致性保障（如数据库选主、分布式锁等）。

etcd作为一个受到ZooKeeper与doozer启发而催生的项目，除了拥有与之类似的功能外，更专注于以下四点。

*  简单：基于HTTP+JSON的API让你用curl就可以轻松使用。

*  安全：可选SSL客户认证机制。

*  快速：每个实例每秒支持一千次写操作。

*  可信：使用Raft算法充分实现了分布式。

   

 ![1574519708248](../../media/sf_reuse/framework/frame_cncf_005.png)

## 6.1     本章参考

[1].     ETCD 简介+使用 https://blog.csdn.net/bbwangj/article/details/82584988 

 

# 7       Istio

 

# 参考资料


```

```