| 序号 | 修改时间   | 修改内容                           | 修改人 | 审稿人 |
| ---- | ---------- | ---------------------------------- | ------ | ------ |
| 1    | 2019-12-24 | 创建。从《CNCF原生框架分析》拆分。 | 吴启福 |        |
|      |            |                                    |        |        |

---



目录

[1 Docker简介... 1](#_Toc28459579)

[2 技术原理篇... 3](#_Toc28459580)

[3 安装篇... 4](#_Toc28459581)

[ubuntu安装... 4](#_Toc28459582)

[windows安装... 6](#_Toc28459583)

[4 使用篇... 6](#_Toc28459584)

[4.1 docker命令组... 8](#_Toc28459585)

[4.1.1 命令行... 8](#_Toc28459586)

[4.1.2 进入容器... 11](#_Toc28459587)

[4.2 docker仓库管理镜像... 11](#_Toc28459588)

[4.2.1 官方镜像仓库 docker Hub.. 12](#_Toc28459589)

[4.2.2 私有镜像仓库 Registry2.. 12](#_Toc28459590)

[4.3 容器镜像制作... 13](#_Toc28459591)

[4.4 docker-compose管理多个容器... 15](#_Toc28459592)

[5 实例... 17](#_Toc28459593)

[5.1 docker镜像使用示例... 17](#_Toc28459594)

[5.2 操作系统ubuntu.. 19](#_Toc28459595)

[5.3 CICD之jenkis. 21](#_Toc28459596)

[5.4 本节参考... 22](#_Toc28459597)

[FAQ.. 22](#_Toc28459598)

[本章参考... 23](#_Toc28459599)

 



[TOC]



---


## 1 Docker简介

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



## 2 技术原理篇

​         ![1574518833495](../../media/sf_reuse/framework/frame_docker_001.png)

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



## 3 安装篇

https://docs.docker.com/install/

要求安装在64位平台。

### ubuntu安装

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



### windows安装

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



## 4  使用篇

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

鉴于国内网络问题，后续拉取 Docker 镜像十分缓慢，我们可以需要配置加速器来解决。

例如网易的镜像地址：http://hub-mirror.c.163.com。

新版的 Docker 使用 如下配置文件来配置 Daemon

* Linux： /etc/docker/daemon.json

* Windows： %programdata%\docker\config\daemon.json
* Windows： %HOME%\.docker\machine\machines\default\config.json



请在该配置文件中加入（没有该文件的话，请先建一个）：
```shell
{
  "registry-mirrors": ["http://hub-mirror.c.163.com"]
}
```


### 4.1  docker命令组

   ![1574518882918](../../media/sf_reuse/framework/frame_docker_003.png)

图 3 docker_commands

备注：镜像标签tag=$name:$version



### 4.1.1 命令行

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
    kill      Kill a running container
    load      Load an image from a tar archive
    logi*     Register or log in to a Docker registry server
    logout    Log out from a Docker registry server
    logs      Fetch the logs of a container  查看运行镜像实例的日志
    port      Lookup the public-facing port that is NAT-ed to PRIVATE_PORT
    pause     Pause all processes within a container
    ps        List containers  查看正在运行镜像实例
    pull      Pull an image or a repository from a Docker registry server 拉取镜像
    push      Push an image or a repository to a Docker registry server 上传镜像
    rename    Rename an existing container
    restart   Restart a running container
    rm        Remove one or more containers
    rmi       Remove one or more images
    run       Run a command in a new container 启动容器
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



### 4.1.2 进入容器

* 法1：docker attach  <docker_id>
  使用该命令有一个问题。当多个窗口同时使用该命令进入该容器时，所有的窗口都会同步显示。如果有一个窗口阻塞了，那么其他窗口也无法再进行操作。

* 法2（推荐）：  docker exec -it <docker_id> /bin/bash

  ```sh
  # 以root身份登陆docker容器 -u root
  $ docker exec -it -u root [docker_id] /bin/bash
  ```

* 法3：SSH




### 4.2  docker仓库管理镜像

镜像存储路径
*  linux:  /var/lib/docker
*  windows: ~/.docker/

镜像管理主要命令：

*  docker images  # 查看本地镜像列表
*  docker search xx   # 搜索某个镜像
*  docker pull xx  # 下载某个镜像



### 4.2.1 官方镜像仓库 docker Hub

Docker Hub ( http://hub.docker.com )是缺省的官方仓库。

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



### 4.2.2 私有镜像仓库 Registry2

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


### 4.3  容器镜像制作

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



### 4.4  docker-compose管理多个容器

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

后台启动： -d

```sh
$ doccker-compose up -d
```



## 5 实例

### 5.1  docker镜像使用示例

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

docker run -d -p 8082:80 --name runoob-nginx-test-web -v ~/nginx/www:/usr/share/nginx/html -v ~/nginx/conf/nginx.conf:/etc/nginx/nginx.conf -v ~/nginx/logs:/var/log/nginx nginx

命令说明：

* -p 8082:80： 将容器的 80 端口映射到主机的 8082 端口。
* --name runoob-nginx-test-web：将容器命名为 runoob-nginx-test-web。
* -v ~/nginx/www:/usr/share/nginx/html：将我们自己创建的 www 目录挂载到容器的 /usr/share/nginx/html。
* -v ~/nginx/conf/nginx.conf:/etc/nginx/nginx.conf：将我们自己创建的 nginx.conf 挂载到容器的 /etc/nginx/nginx.conf。
* -v ~/nginx/logs:/var/log/nginx：将我们自己创建的 logs 挂载到容器的 /var/log/nginx。




### 5.2  操作系统ubuntu

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

`$docker run -it -v /test:/soft centos /bin/bash`

这样在容器启动后，容器内会自动创建/soft的目录。通过这种方式，我们可以明确一点，即-v参数中，冒号":"前面的目录是宿主机目录，后面的目录是容器内目录。

```sh
# 复制文件
$docker cp [contain_id]:/xx xxx
```

4. **保存新镜像**
```sh
$docker commit -m='' -a=[author] [contain_id] [dst_image:tag]
# 示例
$docker commit -m='add gcc' -a=keefewu [contain_id] keefe/ubuntu:3
```


### 5.3  CICD之jenkis

**jenkis进阶使用：详见** **本人另文《运维场景》章节之运维工具Jenkins**



jenkins官网 https://jenkins.io/

镜像：jenkins/jenkins:lts

**docker启动：创建容器**

**法1：docker run**

```shell
docker run --name jenkins -d -p 8080:8080 -p 50000:50000 --restart always \
       jenkins/jenkins:lts
```



法2：docker-compose up**

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



### 5.4  本节参考



## FAQ

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

docker exec -i c $ c> docker exec -it   # 注：未测试成功



**3. 批量删除tag为None的镜像**

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



## 本章参考

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

[1]: [Docker 教程](http://www.runoob.com/docker/docker-tutorial.html) http://www.runoob.com/docker/docker-architecture.html

[2]: Docker教程 https://www.w3cschool.cn/docker/

[3]: Docker从入门到进阶https://yq.aliyun.com/topic/78?spm=5176.8275330.622780.11.LK3KRG

[4]: 32bit-Docker跑32bit-Ubuntu14.04 https://www.jianshu.com/p/61fe3c78464a

[5]: 使用 docker-compose 快速安装Jenkins https://www.cnblogs.com/morang/p/docker-jenkins-use.html

[6]: Docker容器进入的4种方式 https://www.cnblogs.com/xhyan/p/6593075.html

[7]: jenkins https://jenkins.io/zh/doc/book/installing/