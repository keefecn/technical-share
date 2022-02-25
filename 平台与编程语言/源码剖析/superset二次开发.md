| 序号 | 修改时间  | 修改内容                               | 修改人 | 审稿人 |
| ---- | --------- | -------------------------------------- | ------ | ------ |
| 1    | 2018-5-5  | 创建，从《BI专题》迁移至此。           | Keefe  |        |
| 2    | 2021-6-11 | 调整部分内容，全文迁移到源码剖析目录。 | 同上   |        |
| 3    | 2021-6-21 | 更新superset-1.0的相关内容。           | 同上   |        |
| 4    | 2021-7-18 | 《源码剖析》章节另文                   | 同上   |        |
|      |           |                                        |        |        |









<br>

---

[TOC]



<br>

---



# 1 简介

官网： https://superset.apache.org/

用户文档：https://superset.apache.org/docs/intro

API文档： https://superset.apache.org/docs/rest-api

下载： https://dist.apache.org/repos/dist/release/superset/

**github代码仓库**

superset：https://github.com/apache/superset/

官网页面 superset-site：https://github.com/apache/superset-site

~~孵化代码（仅限于0.28之前）~~：https://github.com/apache/incubator-superset/

superset-ui https://github.com/apache-superset/superset-ui/



Apache Superset 于 2015 年由 [Airbnb](http://airbnb.io/) 开源（首行代码提交于 Airbnb 的黑客马拉松上），2017年5月加入Apache孵化计划，2021.1.21宣布毕业成为Apache Software Foundation (ASF)的顶级项目。

当前主要贡献者有：

* Preset（https://preset.io/ ）：Superset 的创始人开办的公司，也是 Superset的主要维护团队。
* Cartel（http://carteldesign.com/）：一家设计公司。



Apache Superset is a modern data exploration and visualization platform。

Apache Superset是流行的数据探索和可视化平台。

云原生 Superset is also cloud-native in the sense that it is flexible and lets you choose the:

- web server (Gunicorn, Nginx, Apache),
- metadata database engine (MySQL, Postgres, MariaDB, etc),
- message queue (Redis, RabbitMQ, SQS, etc),
- results backend (S3, Redis, Memcached, etc),
- caching layer (Memcached, Redis, etc),



## Superset版本

Find out more about how the roadmap is managed in [SIP (Superset Improvement Proposal, Superset改进建议) 53](https://github.com/apache/superset/issues/10894)

superset roadmap https://github.com/apache-superset/superset-roadmap， 以下是大特性Feature的分路图，

* [Dashboard Advanced interaction X-filtering](https://github.com/apache/superset/projects/27)  目标：TOP5图表增加交叉过滤功能，新的Echarts图表支持交叉过滤功能。

* [Echarts Projects (github.com)](https://github.com/apache/superset/projects/13)   加强特性：下钻drilldown 和交叉过滤x-filtering

* [Native dashboard filters](https://github.com/apache/superset/projects/12)  看板原生过滤器

* Filterbox Migration  过滤盒迁移，将废弃过滤盒，使用看板原生过滤

*  [Single Page App](https://github.com/apache/superset/projects/10)  将前端转化成SPA页面。



| 版本 | 发布时间   | 功能特性（重大改变+Deprecations+Other）                      | 备注                                                         |
| ---- | ---------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 1.4  | 2022-1-19  |                                                              | 相比1.3.2，共447个commit<br>`git rev-list d29f66 ^286ba5d37 |wc -l ` |
| 1.3  | 2021-08-13 | 重大改变：去除表格的唯一性检验（因为各DB处理NULL值方式不一样）。<BR>1.3.2(20211011) | 图表类型新增11种合计59种，并且图表可以通过多种方式区分如分类、tag或推荐。 |
| 1.2  | 2021-06-04 | 废弃：旧的Report和Alerm及其相关的配置项。<br>特性行级别RLS缺省启用。看板添加了过滤映射。 | 源码新增目录superset-websocket 和RESOURCES。RESOURCES包括产品使用组织和特性进展二份文档。<br>v1.2成熟特性有9个，典型如DASHBOARD_CROSS_FILTERS、ROW_LEVEL_SECURITY、SCHEDULED_QUERIES。 |
| 1.1  | 2021-02-24 |                                                              | 1.1版本引入特性DASHBOARD_CROSS_FILTERS，在1.2版本成熟。      |
| 1.0  | 2021-01-15 | 重大改变：数据集更新检查属主。安全权限简化。...<br>1.0.1(20210202)引入Apache ECharts 5.0。 | 里程碑。晋升为 ASF 顶级项目。用户体验和性能有极大提升。开始语义化版本([SIP-57](https://github.com/apache/superset/issues/12566))。<br/>图表类型共48种。 |
| 0.38 | 2020-10-17 |                                                              | 0.x系列最后版本，共发布了38个版本，历时5年。                 |
| 0.37 | 2020-08-14 | 重大改变：flask-appbuilder升级到3.x; werkzeug升级到1.0.1。<br>支持邮件报告发送看板或图表。 | 这个版本起，主要贡献者从开源社区转移到创始人创办的商业公司Preset。 |
| 0.36 | 2020-04-02 |                                                              |                                                              |
| 0.35 | 2019-10-31 |                                                              |                                                              |
| 0.34 | 2019-08-09 |                                                              | 从 0.34.0 开始，Superset项目转移到 apache-superset。         |
| ...  |            |                                                              |                                                              |
| 0.28 | 2018-10-17 | 重大改变：python2废弃，只支持python3.6+。flask_login升级到0.3+。 | incubator-superset仓库的最终版本tag。                        |
| ...  |            |                                                              |                                                              |
| 0.24 | 2018-03-27 |                                                              |                                                              |
| ...  |            |                                                              |                                                              |
| 0.4  | 2015-09-27 |                                                              |                                                              |
| 0.2  | 2015-09-05 |                                                              | 第一个正式发布版本。                                         |

> 版本号a.b.0一般简写为a.b.  比较版本只在tag间进行，不要在branch比较。
>
> ChangeLog: https://github.com/apache/superset/blob/master/CHANGELOG.md
>
> UPDATING:  https://github.com/apache/superset/blob/master/UPDATING.md
>
> 版本更新规律：a.b.x小版本在1个月，a.x.c大版本在三个月左右（一个大版本大概包括2-4个小版本）。目前架构升级版本只进行了一次 (0-->1)，用了5年多。
>
> 版本更新规则：大版本升级通常要先进行 `superset db upgrade`以更新DB相关配置。如v1.2增加了2个权限`can share on dashboard, can share on chart`，这二权限默认添加到了三个缺省角色Admin/Alpha/Gamma。启用某特性标识一般也要更新DB，如RLS，会新建一张表。

备注：v1.1-1.3主要作UI美化和用户体验提升，并没有涉及到数据库迁移等较复杂的改动，向后兼容v1.0版本。



## 参与开源

项目开源社区：https://github.com/apache/superset

提交issue:  https://github.com/apache/superset/issues

Want to contribute to apache/superset?

If you have a bug or an idea, read the [contributing guidelines](https://github.com/apache/superset/blob/afb8bd5fe68066cfe2f3d384d659215dc4790d9d/CONTRIBUTING.md) before opening an issue.

If you're ready to tackle some open issues, [we've collected some good first issues for you](https://github.com/apache/superset/contribute).

SIP - Superset Improvement Proposa



截止2021.8.18，ISSUES共有6920个（其中open 927个，closed 5993个），PRS共有9002个（其中open 116个，closed 8886个）。每个小版本发布都会有上百个BUG修复或feature新增。

Every issue/PR must have one hash label (except spam entry). Labels that begin with `#` defines issue/PR type:

| Label           | for Issue                                                    | for PR                                                       |
| --------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `#bug`          | Bug report                                                   | Bug fix                                                      |
| `#code-quality` | Describe problem with code, architecture or productivity     | Refactor, tests, tooling                                     |
| `#feature`      | New feature request                                          | New feature implementation                                   |
| `#refine`       | Propose improvement that does not provide new features and is also not a bug fix nor refactor, such as adjust padding, refine UI style. | Implementation of improvement that does not provide new features and is also not a bug fix nor refactor, such as adjust padding, refine UI style. |
| `#doc`          | Documentation                                                | Documentation                                                |
| `#question`     | Troubleshooting: Installation, Running locally, Ask how to do something. Can be changed to `#bug` later. | N/A                                                          |
| `#SIP`          | Superset Improvement Proposal                                | N/A                                                          |
| `#ASF`          | Tasks related to Apache Software Foundation policy           | Tasks related to Apache Software Foundation policy           |



贡献类型 Types of Contributions：

* Report Bug:  需要列出OS、版本和如何重现步骤
* Submit Ideas or Feature Requests  提交创意和特性请求
* Fix Bugs：打标签 #bug
* Implement Features:   #feature
* Implement Document:  #doc
* Add Translations:  更改`superset/translations/<language_code>/LC_MESSAGES/messages.po` 或新语种
* Ask Questions:  建议在[StackOverflow](https://stackoverflow.com/)提问并 打上标签 #apache-superset。



贡献注意事项

* 翻译：需要提交messages.po，而不是messages.json (@superset-ui的翻译内容暂不包括在内)



对于新贡献者new contributor 的Pull Request流程

1. 贡献哲学：Before creating a PR, create an issue.  创建PR前，应先在issue区增加一个issue，描述问题和讨论解决方法。
2. PR通过所有CI测试。
3. CI检视者开始审视代码，提出审视意见。贡献者回答所有意见。
4. PR得到代码检视者批准，并且已合并了最新代码，然后再合并到master。
5. PR合并后，项目维护者可能会联系PR贡献者（PR里引入新问题） 或者 回退修改（PR发现关键问题比如破坏主分支CI）。



## 术语

**关键术语**

*  Dashboard（仪表盘、看板）：由多个Slice组合而成。
*  Slice（切片）：即Chart。Slice就是配置好数据表的图表。一个Slice指向一个数据表和一种图表类型Chart。
*  Dataset 数据集：有时也称数据表table。数据表可以是数据源里的物理单表，也可以是多表关联查询而成的子查询虚拟表(要求是同数据源)，另外也可导入CSV文件作为数据表。
*  Datasource 数据源：有时也称数据库database。支持11+种数据源和文件CSV格式。

 说明：1. 从数据顺序流来看，先有数据源，再有数据集，再有Slice，然后若干个Slice组合在一起形成看板。

2. 关于名称，数据源、数据集有对名称作约束（数据源名称全局唯一，数据集名称同数据源下唯一），图表、看板对名称不作约束。



**其它术语**

* ananotation 注解
* report schedule 报告调度
* alert 警报
* 服务端：指superset服务端，python实现，提供REST服务。
* 客户端：也叫前端，指superset-frontend前端。js+less实现。在浏览器上运行，是最终用户所看到的页面。



**Schema**: 是一个逻辑概念。

* MySQL：等同于表。
* Oracle:  被一个用户使用的数据库对象的集合。一个用户对应一个schema。默认schema和用户名同名。
* PostgeSQL:  schema默认命名为public，如果不特别指定，PostgeSQL以public模式操纵各类数据库对象。



<br>

# 2 用户篇

Apache Superset-1.0是个里程碑，相对于之前版本改动较大。

## 2.1 安装

Installation

*  installing-superset-from-scratch 从头装起 https://superset.apache.org/docs/installation/installing-superset-from-scratch

- [Locally with Docker](https://superset.incubator.apache.org/installation.html#start-with-docker)
- [Install on Windows 10](https://gist.github.com/mark05e/d9cccae129dd11a21d7219eddd7d9923)
- [Install on CentOS](https://aichamp.wordpress.com/2019/11/20/installing-apache-superset-into-centos-7-with-python-3-7/)
- [Build Apache Superset from source](https://hackernoon.com/a-better-guide-to-build-apache-superset-from-source-6f2ki32n0)
- [Installing Apache Superset Locally](https://preset.io/blog/2020-05-11-getting-started-installing-superset/)



安装OS依赖：

- Linux Fedore/RHL:

  ```shell
  # libffi-加密依赖，bzip2-压缩依赖
  $ yum install gcc gcc-c++ libffi-devel bzip2-devel openssl-devel cyrus-sasl-devel openldap-devel
  # 可选，若python版本有更新，则以下包可选
  $ yum install python-devel python-pip python-wheel
  ```

- windows: `python-geohash pillow mysqlclient cryptograph`

* python3.7+源码安装： `./configure --prefix=/usr/local/python38 --enable-optimizations  & make & make install`

> 备注：一般OS缺省自带的python版本较老，需要重新安装新版本python。



### 本地部署

**1. 本地安装**

**PIP安装**

安装版本： superset-0.x 模块名superset, 1.x版本s模块名apache-superset。下面安装以1.x以上版本为例

安装需求：superset 1.x版本要求Python3.7+;  0.x版本要求python 2.7.8+或者python 3.6+，python 2.7环境pip安装时还需预安装pytest-runner.

```shell
# 安装法1：在线安装, 如果不指定版本，将会安装最新版本
pip install apache-superset==1.0.0

# 安装法2：离线安装
pip download -d <dir> apache-superset
pip install --no-index -f <dir> apache-superset

# 安装法3: 升级安装
$ pip install superset --upgrade
# 或者只下载新包
$ pip download apache-superset==1.3.0 --no-deps
```



本地版本更新安装：

```shell
# 激活虚拟环境，本地安装
$ source xx/bin/activate

# 首次特别安装: DB-mysql/oralce/pg, 加密，
$ sudo yum install mysql-devel postgresql-devel # centos7环境
$ pip install mysqlclient cx_Oracle psycopg2
$ pip install pycryptodome flask_cors pillow

# 可选：oracle需要额外下载库，可在oracle官网下载
export LD_LIBRARY_PATH=/opt/oracle/instantclient_21_3:$LD_LIBRARY_PATH

# 安装新版本
$ pip install xx.tar.gz
```



**2. superset初始化**：pycharm terminal执行下列命令

**首次初始化**

```shell
# 先导入本地路径, windows用set，linux用export
set PYTHONPATH=%SUPERSET_PATH%

# 创建管理员  0.x使用fabmanager
$ export FLASK_APP=superset
superset fab create-admin

# initialize the database，若版本更新，run运行前需要先执行此句
superset db upgrade

# Create default roles and permissions. 有时执行db upgrade后也要执行 init
superset init

# Load some data to play with. 可选
superset load-examples
```



**更新版本**

升级涉及到数据库一般执行：`db migrate`(可选，数据库迁移)， `db upgrade`(必选)，`superset init`(可选，会重新覆盖预设角色)

```shell
# 更新版本时先执行此命令，再进行服务器启动
superset db upgrade

# 打包: 后端打包到dist目录
python setup.py sdist

# 把版本上传到部署服务器，放到 ~/目录下

# 安装版本
source ~/venv/superset-1.3-env/bin/activate
pip install xx.tar.gz

# 额外事情：更新中国国家地图文件xx.geojson
cp xx.geojson ~/project/superset/static/assets/
```



**3. 服务器启动**

后端： 直接 run 或者 gunicorn/uwsgi启动

```shell
# 启动法1：superset run启动 指定端口 -d调试；-p监听端口，缺省8088. 0.x用的runserver,
set SUPERSET_CONFIG_PATH=%SUPERSET_PATH%\superset\superset_config.py
superset run -d -h 0.0.0.0 -p 8088 --with-threads --reload

# 启动法2：flask run启动，命令参数superset. 会导入当前目录下的$FLASK_APP模块，搜索路径优先当前路径
export FLASK_APP=superset
flask run

# 启动法3：gunicorn启动，将日志参数后的- 替换成相应全路径文件名
gunicorn --bind 0.0.0.0:8088 --access-logfile ~/.superset/g.access.log --error-logfile ~/.superset/g.error.log --workers 2 --worker-class gthread --threads 20 --timeout 60  'superset.app:create_app()'
```



**查看页面，缺省端口8088**

http://localhost:8088



**4. 前端构建**： 可用npm或者yarn构建打包，生成的包在 superset/static/assets目录

```shell
# 前端：superset-1.0 要求"node": ">= 12.18.3 < 13", "npm": ">= 6.14.8"
$cd superset-frontend
# 安装模块（第一次构建时需要）: install 和 ci的效果是一样, ci命令不改变package.json
$ npm install
# 或者
$ npm ci

# 法1：npm构建: build-生产环境; dev-开发环境,会检测更改,自动构建; dev-server-远程调试
$ npm run build
# 或者 js_build.sh会进行代码检查、单元测试后再build（时间20min+）
$ bash ./js_build.sh

# 法2： yarn构建
$ yarn & yarn run build
```

说明: 对于前端构建需要满足node & npm版本要求.  node可以用 n模块进行升级(` n $version`),  npm可以自己升级 `npm install npm@version`.



### 容器部署

apache官方镜像 [apache/superset - Docker Image | Docker Hub](https://hub.docker.com/r/apache/superset)  https://hub.docker.com/r/apache/superset

多Dockerfile汇总  [superset/Dockerfile at master · apache/superset · GitHub](https://github.com/apache/superset/blob/master/Dockerfile)



表格 docker.io二款superset镜像比较

| 比较项                | apache/superset                                           | amancevice/superset                                          |
| --------------------- | --------------------------------------------------------- | ------------------------------------------------------------ |
| 简介                  | 官方镜像。gunicorn启动1工作进程22线程。                   | 非官方镜像， Debian+Python3 。star最多。gunicorn启动10工作进程。 |
| 镜像URL               | https://hub.docker.com/r/apache/superset                  | https://hub.docker.com/r/amancevice/superset                 |
| Dockerfile            | https://github.com/apache/superset/blob/master/Dockerfile | https://github.com/amancevice/docker-superset/blob/main/Dockerfile |
| 更新频率              | 与源码几乎同步更新                                        | 与源码几乎同步更新                                           |
| 镜像尺寸（压缩/解压） | 400MB/1.45GB                                              | 800MB/2.25GB                                                 |
| 容器启动脚本 CMD      | ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]              | CMD ["gunicorn", "superset.app:create_app()"]                |
| docker run            | docker run -d  --name superset apache/superset            | docker run -d --name superset amancevice/superset            |
| WEB访问URL            | http://HOST:8088/                                         | http://HOST:8088/                                            |
|                       |                                                           |                                                              |
| $SUPERSET_CONFIG_PATH | 无                                                        | 无                                                           |
| $SUPERSET_HOEM        | /app/superset_home/                                       | /var/lib/superset                                            |
| $PYTHONPATH           | /app/pythonpath                                           | /etc/superset:/home/superset:$PYTHONPATH                     |
| $FLASK_ENV            | development                                               |                                                              |
| 其它环境变量ENV       | SUPERSET_PORT=8088 FLASK_APP="superset.app:create_app()"  | GUNICORN_BIND=0.0.0.0:8088  GUNICORN_WORKERS=10 GUNICORN_CMD_ARGS= |
| site-packages         |                                                           | /usr/local/lib/python3.8/site-packages/                      |

备注：1. $SUPERSET_HOME是数据卷，默认用来存储sqlite db和日志。$SUPERSET_CONFIG_PATH是配置卷，用来存储自定义配置文件。

2. 上面二个镜像生成的方式不同，amancevice是pip安装superset源码；apache指定superset源码路径。都是用gunicorn启动。
3. 容器端口定义在Dockerfile变量里，目前二个镜像端口都是8088，apache定义在$SUPERSET_PORT,  amancevice定义在GUNICORN_PORT。可以指定宿主机端口：` -p [宿主机端口]:[容器端口]`

```shell
$ docker images
REPOSITORY                      TAG                 IMAGE ID            CREATED             SIZE
docker.io/apache/superset       1.0.0     			ad145d6f1a5a   		7 months ago   		1.45GB
docker.io/amancevice/superset   latest              bc910e3fc165        2 months ago        2.25 GB
docker.io/registry              2                   1fd8e1b0bb7e        4 months ago        26.2 MB
docker.io/python                3.7.9               65d5b6c539fd        7 months ago        877 MB

$ docker ps
CONTAINER ID        IMAGE                           COMMAND                  CREATED             STATUS                       PORTS                              NAMES
e80ac04bd94e        docker.io/amancevice/superset   "gunicorn superset..."   About an hour ago   Up About an hour (healthy)   0.0.0.0:8080->8080/tcp, 8088/tcp   my_superset
663f90ffcceb  		docker.io/apache/superset:1.0.0              13 hours ago  Up 13 hours ago  0.0.0.0:8080->8080/tcp  my_superset5
```



**镜像部署启动过程**

```shell
# 下载镜像 官网镜像 docker.io/apache/superset:1.0.0
# star最多镜像 docker.io/amancevice/superset
$ docker pull apache/superset:1.0.0

# 创建挂载目录
$ mkdir /opt/superset

# dockek启动： apache 或 amancevice, 都映射到宿主机端口 9002, 数据卷映射到/opt/superset. -d 后台启动
$ docker run --name my_superset -p 9002:8080 -v /opt/superset:/app/superset_home apache/superset:1.3.0
$ docker run -p 9002:8088 --name superset amancevice/superset

# 第一次初始化: superset init命令即可，也可完全执行本地部署时的 `superset db upgrade; superset init; superset fab create-admin;`
docker exec -it my_superset superset init
```



**容器内部执行情况**

1. apache/superset容器

```shell
# 进入到容器， 用root
$ docker exec -it -u root my_superset /bin/bash

# 容器内部命令
$ ps -ef
UID        PID  PPID  C STIME TTY          TIME CMD
superset     1     0  0 11:50 ?        00:00:00 /bin/bash /usr/bin/docker-entrypoint.sh
superset     8     1  0 11:50 ?        00:00:00 /usr/local/bin/python /usr/bin/gunicorn --bind 0.0.0.0:8080 --access-logfile - --error-logfile - --workers 1 --worker-class gthread --threads 20 --timeout 60 --limit-request-line 0 --limit-request-field_size 0 superset.app:create_app()
root      2505     0  1 11:59 pts/0    00:00:00 /bin/bash
superset  2565     8 99 12:00 ?        00:00:01 /usr/local/bin/python /usr/bin/gunicorn --bind 0.0.0.0:8080 --access-logfile - --error-logfile - --workers 1 --worker-class gthread --threads 20 --timeout 60 --limit-request-line 0 --limit-request-field_size 0 superset.app:create_app()

root@5dcbeffeb365:/app# cat /usr/bin/docker-entrypoint.sh
#!/bin/bash
set -eo pipefail

if [ "${#}" -ne 0 ]; then
    exec "${@}"
else
    gunicorn \
        --bind  "0.0.0.0:${SUPERSET_PORT}" \
        --access-logfile '-' \
        --error-logfile '-' \
        --workers 1 \
        --worker-class gthread \
        --threads 20 \
        --timeout 60 \
        --limit-request-line 0 \
        --limit-request-field_size 0 \
        "${FLASK_APP}"
fi
```



2. amancevice/superset容器

   ```shell
   # 启动10个工作进程
   superset@e80ac04bd94e:~$ ps -ef
   UID        PID  PPID  C STIME TTY          TIME CMD
   superset     1     0  0 01:02 ?        00:00:01 /usr/local/bin/python /usr/local/bin/gunicorn superset.app:create_app()
   superset     7     1  0 01:02 ?        00:00:04 /usr/local/bin/python /usr/local/bin/gunicorn superset.app:create_app()
   superset     8     1  0 01:02 ?        00:00:04 /usr/local/bin/python /usr/local/bin/gunicorn superset.app:create_app()
   superset     9     1  0 01:02 ?        00:00:04 /usr/local/bin/python /usr/local/bin/gunicorn superset.app:create_app()
   superset    10     1  0 01:02 ?        00:00:04 /usr/local/bin/python /usr/local/bin/gunicorn superset.app:create_app()
   superset    11     1  0 01:02 ?        00:00:04 /usr/local/bin/python /usr/local/bin/gunicorn superset.app:create_app()
   ```




## 2.2 基本功能

数据流向： 数据源/数据库database -- 数据集/数据表table -- 切片/图表 -- 看板

功能

* 数据流向：从数据源、数据集到图表、看板的完整流程。
* 支持主流数据源
* 支持图表类型50+
* 支持图表注解
* 支持告警
* 支持看板刷新
* 支持图表/看板分享
* 异步查询
* 基于RBAC的访问控制



### 支持数据源类型

数据源类型数量 ：

* v1.0共支持30种。

* v1.3共支持38种，v1.0+后新增8个新源（尚未测试），分别是ascend crate databricks firebird netezza rockset shillelagh trino。

**Database dependencies** (superset 1.0)

| Database                                                     | PyPI package                                                 | Connection String                                            |
| :----------------------------------------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| [Amazon Athena](https://superset.apache.org/docs/databases/athena) | `pip install "PyAthenaJDBC>1.0.9` , `pip install "PyAthena>1.2.0` | `awsathena+rest://{aws_access_key_id}:{aws_secret_access_key}@athena.{region_name}.amazonaws.com/{` |
| [Amazon Redshift](https://superset.apache.org/docs/databases/redshift) | `pip install sqlalchemy-redshift`                            | `redshift+psycopg2://:@:5439/`                               |
| [Apache Drill](https://superset.apache.org/docs/databases/drill) | `pip install sqlalchemy-drill`                               | `drill+sadrill:// For JDBC drill+jdbc://`                    |
| [Apache Druid](https://superset.apache.org/docs/databases/druid) | `pip install pydruid`                                        | `druid://:@:/druid/v2/sql`                                   |
| [Apache Hive](https://superset.apache.org/docs/databases/hive) | `pip install pyhive`                                         | `hive://hive@{hostname}:{port}/{database}`                   |
| [Apache Impala](https://superset.apache.org/docs/databases/impala) | `pip install impyla`                                         | `impala://{hostname}:{port}/{database}`                      |
| [Apache Kylin](https://superset.apache.org/docs/databases/kylin) | `pip install kylinpy`                                        | `kylin://:@:/?=&=`                                           |
| [Apache Pinot](https://superset.apache.org/docs/databases/pinot) | `pip install pinotdb`                                        | `pinot://BROKER:5436/query?server=http://CONTROLLER:5983/`   |
| [Apache Solr](https://superset.apache.org/docs/databases/solr) | `pip install sqlalchemy-solr`                                | `solr://{username}:{password}@{hostname}:{port}/{server_path}/{collection}` |
| [Apache Spark SQL](https://superset.apache.org/docs/databases/spark-sql) | `pip install pyhive`                                         | `hive://hive@{hostname}:{port}/{database}`                   |
| [Ascend.io](https://superset.apache.org/docs/databases/ascend) | `pip install impyla`                                         | `ascend://{username}:{password}@{hostname}:{port}/{database}?auth_mechanism=PLAIN;use_ssl=true` |
| [Azure MS SQL](https://superset.apache.org/docs/databases/sql-server) | `pip install pymssql`                                        | `mssql+pymssql://UserName@presetSQL:TestPassword@presetSQL.database.windows.net:1433/TestSchema` |
| [Big Query](https://superset.apache.org/docs/databases/bigquery) | `pip install pybigquery`                                     | `bigquery://{project_id}`                                    |
| [ClickHouse](https://superset.apache.org/docs/databases/clickhouse) | `pip install clickhouse-driver==0.2.0 && pip install clickhouse-sqlalchemy==0.1.6` | `clickhouse+native://{username}:{password}@{hostname}:{port}/{database}` |
| [CockroachDB](https://superset.apache.org/docs/databases/cockroachdb) | `pip install cockroachdb`                                    | `cockroachdb://root@{hostname}:{port}/{database}?sslmode=disable` |
| [Dremio](https://superset.apache.org/docs/databases/dremio)  | `pip install sqlalchemy_dremio`                              | `dremio://user:pwd@host:31010/`                              |
| [Elasticsearch](https://superset.apache.org/docs/databases/elasticsearch) | `pip install elasticsearch-dbapi`                            | `elasticsearch+http://{user}:{password}@{host}:9200/`        |
| [Exasol](https://superset.apache.org/docs/databases/exasol)  | `pip install sqlalchemy-exasol`                              | `exa+pyodbc://{username}:{password}@{hostname}:{port}/my_schema?CONNECTIONLCALL=en_US.UTF-8&driver=EXAODBC` |
| [Google Sheets](https://superset.apache.org/docs/databases/google-sheets) | `pip install shillelagh[gsheetsapi]`                         | `gsheets://`                                                 |
| [Hologres](https://superset.apache.org/docs/databases/hologres) | `pip install psycopg2`                                       | `postgresql+psycopg2://:@/`                                  |
| [IBM Db2](https://superset.apache.org/docs/databases/ibm-db2) | `pip install ibm_db_sa`                                      | `db2+ibm_db://`                                              |
| [MySQL](https://superset.apache.org/docs/databases/mysql)    | `pip install mysqlclient`                                    | `mysql://:@/`                                                |
| [Oracle](https://superset.apache.org/docs/databases/oracle)  | `pip install cx_Oracle`                                      | `oracle://`                                                  |
| [PostgreSQL](https://superset.apache.org/docs/databases/postgresql) | `pip install psycopg2`                                       | `postgresql://:@/`                                           |
| [Trino](https://superset.apache.org/docs/databases/trino)    | `pip install sqlalchemy-trino`                               | `trino://{username}:{password}@{hostname}:{port}/{catalog}`  |
| [Presto](https://superset.apache.org/docs/databases/presto)  | `pip install pyhive`                                         | `presto://`                                                  |
| [SAP Hana](https://superset.apache.org/docs/databases/hana)  | `pip install hdbcli sqlalchemy-hana or pip install apache-superset[hana]` | `hana://{username}:{password}@{host}:{port}`                 |
| [Snowflake](https://superset.apache.org/docs/databases/snowflake) | `pip install snowflake-sqlalchemy`                           | `snowflake://{user}:{password}@{account}.{region}/{database}?role={role}&warehouse={warehouse}` |
| SQLite                                                       |                                                              | `sqlite://`                                                  |
| [SQL Server](https://superset.apache.org/docs/databases/sql-server) | `pip install pymssql`                                        | `mssql://`                                                   |
| [Teradata](https://superset.apache.org/docs/databases/teradata) | `pip install sqlalchemy-teradata`                            | `teradata://{user}:{password}@{host}`                        |
| [Vertica](https://superset.apache.org/docs/databases/vertica) | `pip install sqlalchemy-vertica-python`                      | `vertica+vertica_python://<UserName>:<DBPassword>@<Database Host>/<Database Name>` |

参考 [SQLAlchemy docs](https://docs.sqlalchemy.org/en/13/core/engines.html) 有关如何构建 URI 的更多信息。

```python
# 实现： /superset/db_engine_specs/base.py:BasicParametersMixin
# placeholder with the SQLAlchemy URI template
#  其中engine相当于dialect或connector; driver为实现库，若未填充，则取默认驱动
# sqlalchemy_uri示例： postgresql://scott:tiger@localhost:5432/mydatabase?charset=utf-8
sqlalchemy_uri_placeholder = (
    "dialect[+driver]://user:password@host:port/dbname[?key=value&key=value...]"
)

# 实现示例
from sqlalchemy import create_engine
# 下面二种sqlalchemy_uri等同. postgresql的driver为空，则取默认驱动pyscopg2
engine = create_engine('postgresql://scott:tiger@localhost:5432/mydatabase')
engine = create_engine('postgresql+psycopg2://scott:tiger@localhost:5432/mydatabase')
```

详细说明：

1. 元数据：默认情况下，superset是把元数据保存到sqlite。sqlite是python标准库，**其它的数据库插件需要安装才能使用**。

2. URI前缀相同的表示使用相同协议，如Postgres/Greenplum/Redshift，Postgres是RDBS；Greenplum是基于Postgres开发的海量（50PB）级别的RDBS；Redshift是AWS的云化数据仓库。

3. 数据源类型分类：RDBS有MySQL/Postgres/Oracle/MSSQL；数据仓库有Presto/Impala/SparkSQL/Athena/ Vertica；预计算有Kylin.

4. 还不支持的DB：[MongoDB](https://www.mongodb.com/zh-cn/products/bi-connector)(有第三方付费插件支持)

5. 主流DB插件安装注意事项

   ```shell
   # 最常用的DB
   $ sudo yum install mysql-devel postgresql-devel
   $ pip install mysqlclient cx_Oracle psycopg2

   # 除了上面列的python插件，通常还需要对应的 DB动态库支持. 官方镜像apache/superset已经包括mysql, pg的开发库
   # mysql: yum install mysql-devel
   # oracle： 需要独立安装 客户端（约300MB）
   # pg: postgresql-devel 或者 libpq
   ```



**DB大小写敏感差异**：对象名（表名字段名），查询SQL

1. 对象名(如表名字段名）的大小写敏感：可以在服务器端的配置文件里配置对象名是否大小写敏感。Oracle/PG缺省大小写敏感（这二者对象名的大小写缺省定义刚好相反，ORACLE默认对象名大写，PG默认对象名小写；如果不是默认情况，需要加 `双引号` 用以区分），MySQL缺省大小写不敏感。对于大小写敏感的DB对象名，如果没按照缺省规则定义，superset生成的SQL未必正确。
2. 查询值字符串的大小写敏感，实质是校验规则。二进制检验是区分大小写的。改变了检验规则 ，那么索引最好重建。此外，检验规则也可以是会话级的，临时设定生效的。
    - Oracle的SQL语句默认是转化大写的。对于表名/字段名存在小写，则要用""圈起来才能识别。建议oracle的表名/字段名都用大写。
    - PG的SQL语句默认是转化小写的。对于表名/字段名存在大写，要用引号圈起来才能识别。建议PG的表名/字段名都用小写。



### 支持图表类型

图表类型数量 ：

* v1.0.0支持48种。

* v1.3.0支持59种，新增11种其中10种来自ECharts。v1.3.0支持图表按多种类别进行分类。



| 图表类别 | 图表英文名         | 图表中文名         | 必选维度     | 支持情况 |
| -------- | ------------------ | ------------------ | ------------ | -------- |
| 常用图表 | line               | 线图               |              | √        |
|          | histogram          | 直方图             |              | √        |
|          | table              | 表                 |              | √        |
|          | filter_box         | 筛选盒             |              | √        |
|          | dist_bar           | 柱状图             |              | √        |
|          | area               | 面积图             |              | √        |
|          | pie                | 饼图               |              | √        |
|          | pivot_table        | 透视表             |              | √        |
|          | country_map        | 国家地图           | geojson      | √        |
|          | world_map          | 世界地图           | country_code | √        |
| 时间序列 | bar                | 时间序列柱状图     |              | √        |
|          | time_table         | 时间序列表         |              | √        |
|          | time_pivot         | 时间序列周期轴     |              | √        |
|          | echarts_timeseries | 时间序列           |              | √        |
|          | compare            | 时间序列百分比变化 |              | √        |
|          | cal_heatmap        | 时间热力图         |              | √        |
|          | big_number_total   | 数字               |              | √        |
| 趋势类   | big_number         | 数字和趋势线       |              | √        |
|          | heatmap            | 热力图             |              | √        |
|          | dual_line          | 双线图             |              | √        |
|          | line_multi         | 多线图             |              | √        |
|          |                    |                    |              | √        |
| 复杂图   | rose               | 夜莺玫瑰图         |              | √        |
|          | bubble             | 气泡图             |              | √        |
|          | treemap            | 树状图             |              | √        |
|          | box_plot           | 箱线图             |              | √        |
|          | sunburst           | 旭日图             |              | √        |
|          | sankey             | 桑基图             |              | √        |
|          | word_cloud         | 词汇云             |              | √        |
|          | partition          | 分区图             |              | √        |
|          | event_flow         | 事件流             |              | √        |
|          | deck_path          | 平面路径图         |              | √        |
|          | directed_force     | 力导向图           |              | √        |
|          | bullet             | 子弹图             |              | √        |
|          | paired_ttest       | paired_ttest       |              | √        |
|          | para               | 平行坐标           |              | √        |
|          | chord              | 弦图               |              | √        |
|          | horizon            | 范围图             |              | √        |
| deck图   | 共10图，详见下表   |                    |              |          |



表格   Deck图详细说明 （共10图，其中3D有4个）

| 变量                 | 图表英文名                 | 图表中文名          | 用途                                                         | 样例数据表名           | 维度                 | 指标                     | tag  |
| -------------------- | -------------------------- | ------------------- | ------------------------------------------------------------ | ---------------------- | -------------------- | ------------------------ | ---- |
| deck_arc             | deck.gl Arc                | 弧                  | 绘制起点和目的地之间的距离（如飞行路径）。                   | fight                  | 经度首/尾、纬度首/尾 |                          | 3D   |
| deck_polygon         | deck.gl Polygon            | 多边形              | 将数据中的地理区域可视化为 Mapbox 渲染地图上的多边形。可以使用度量为多边形着色。 | sf_population_polygons | contour              | sum(population),<br>密度 | 3D   |
| deck_grid            | Deck.gl - 3D Grid          | 网格                | 在网格视图中可视化地理空间数据，例如 3D 建筑物、景观或对象。 | long_lat               | 经度、纬度           | 计数                     | 3D   |
| **deck_hex**         | Deck.gl - 3D HEX / Hexagon | 3D六角曲面 / 六边形 | 在地图上叠加六边形网格，并聚合每个单元格边界内的数据。       | long_lat               | 经度、纬度           |                          | 3D   |
| deck_screengrid      | Deck.gl Screen Grid        | 屏幕网格            | 聚合网格单元边界内的数据并将聚合值映射到动态色标             | long_lat               | 经度、纬度           | 权重                     |      |
| deck_scatter         | Deck.gl - Scatter plot     | 散射点图            | 在纬度/经度坐标处采用可变半径渲染圆的地图                    | long_lat               | 经度、纬度           | 计数                     |      |
| deck_Multiple Layers | Deck.gl - Multiple Layers  | 多层                | 将多个图层组合在一起以形成复杂的视觉效果。                   |                        | 多个Deck图组合       |                          |      |
| deck_path            | deck.gl Path               | 平面路径图          | 在地图上可视化形成路径的连接点。                             | bart_lines             | 线列、颜色           |                          |      |
| deck_geojson         | Deck.gl - GeoJson          | deck_geojson        | GeoJsonLayer 接收 GeoJSON 格式的数据并将其呈现为交互式多边形、线和点（圆形、图标和/或文本）。 | ?                      | GEOJSON列            |                          |      |
| mapbox               | MapBox                     | 地图盒              | 类似散射点图，指标呈现的是盒子状。                           | long_lat               | 经度、纬度、         |                          |      |

> 维度是指groupby项，指标是指要展现的计数列。



JSON串 (图表名称在不同版本会略有变化)

```json
{
	  "Area Chart": ["面积图"],
      "Bar Chart": ["柱状图"],
      "Big Number Total": ["数字"],
      "Big Number": ["数字和趋势线"],
      "Box Plot": ["箱线图"],
      "Bubble": ["气泡图"],
      "Bullet": ["子弹图"],
      "Cal Heatmap": ["时间热力图"],
      "Chord Diagram": ["弦图"],
      "Compare": ["高级线图"],
      "Country Map": ["国家地图"],
      "deck.gl 3D Hexagon": ["DECK 3D六边形"],
      "deck.gl Arc": ["DECK弧形"],
      "deck.gl Path": ["DECK平面路径"],
      "deck.gl Polygon": ["DECK多边形"],
      "deck.gl Scatterplot": ["DECK散射点图"],
      "deck.gl Grid": ["DECK网格"],
      "deck.gl Screen Grid": ["DECK屏幕网格"],
      "deck.gl Multiple Layers": ["DECK多层"],
      "Directed Force": ["力导向图"],
      "Dist Bar": ["柱状图2"],
      "Dual Line Chart": ["双线图"],
      "Echarts Timeseries": ["时间序列折线图"],
      "Force-directed Graph": ["事件流"],
      "Event Flow": ["事件流"],
      "Filter Box": ["筛选盒"],
      "Heatmap": ["热力图"],
      "Horizon Chart": ["水平直方图"],
      "Line Chart": ["线图"],
      "Multiple Line Charts": ["多线图"],
      "MapBox": ["地图盒"],
      "Nightingale Rose Chart": ["夜莺玫瑰图"],
      "Para": ["平行坐标"],
      "Partition Chart": ["分区图"],
      "Pie Chart": ["饼图"],
      "pie": ["饼图"],
      "Pivot Table": ["透视表"],
      "Paired t-test Table": ["成对t测试表"],
      "Range Filter Plugin": ["区域过滤插件"],
	  "Select Filter Plugin": ["选择过滤插件"],
      "Sankey Diagram": ["桑基图"],
      "Sunburst Chart": ["旭日图"],
      "Table": ["表"],
      "Time-series Chart": ["时间序列图"],
      "Time-series Bar Chart": ["时间序列柱状图"],
      "Time-series Period Pivot": ["时间序列周期轴"],
      "Time-series Percent Change": ["时间序列百分比"],
      "Time-series Table": ["时间序列表"],
      "Treemap": ["树状图"],
      "Word Cloud": ["词汇云"],
      "World Map": ["世界地图"],
}
```



### 样例数据集说明

数据集下载  [apache-superset/examples-data (github.com)](https://github.com/apache-superset/examples-data)

加载数据集命令： `superset load_examples`

| 原始数据集名                          | 表名                 | 说明                 | 关键字段                                 | 适用图表   |
| ------------------------------------- | -------------------- | -------------------- | ---------------------------------------- | ---------- |
| airport.csv.gz                        |                      | 机场                 |                                          |            |
| bart_lines                            | 同数据集名           | 条形线               | color, path_json                         | 平面路径图 |
| birth_france_data_for_country_map.csv |                      | 法国各州出生         | dept_id(FR-xx)                           | 国家地图   |
| birth_names                           |                      | 法国各州出生名字     | state                                    |            |
| countrys                              | wb_health_population |                      | country_code                             | 全球地图   |
| energy                                | energy_usage         | 能源用途             |                                          |            |
| fight_data.csv.gz                     | flights              | 飞行数据             | latitude, longitude, lat_dest, long_dest |            |
| multiformat_time_series               | 同数据集名           | 多格式时间序列       | ds, ds2, string0, string1, epoch_s       | 时间序列类 |
| paris_iris                            | paris_isir_mapping   |                      | type, features(geojson列)                |            |
| random_time_series                    | 同数据集名           | 随机时间序列         | ds                                       | 时间序列类 |
| san_francisco.csv.gz                  | long_lat             | 圣弗朗西斯科地理数据 | long, lat                                | Deck系列图 |
| sf_population                         | 同数据集名           | 人口多边形           | contour(列表)                            | Deck多边形 |
| turorial_flights.csv                  |                      |                      |                                          |            |
| unicode_utf8_unixn_test.csv           |                      |                      |                                          |            |

说明：若原始数据集名未特殊说明，一般为JSON的压缩文件，后缀名为.json.gz



## 2.3 扩展功能

### CSS样式

CSS样式分系统CSS模板和看板自定义CSS样式。

* 系统CSS模板（公有样式）：保存在css_templates表。系统CSS模板是通用性的，只对几个通用DIV标签起作用。是所有看板看到的可选样式列表（可以是多个）。增删改系统CSS模板需要专门权限。
* 看板自定义CSS样式（看板私有样式）：保存在dashboards表里的css字段里。编辑某个看板时可选择系统CSS模板，再根据当前看板的实际布局更细节地自定义CSS样式。看板私有样式的修改不会影响到公有样式 。看板私有样式修改后，需要保存看板才能生效。



## 2.4 特性 Feature

详见 superset/resources/[feature_flags.md](https://github.com/apache/superset/blob/master/RESOURCES/FEATURE_FLAGS.md)

superset特性标识是为了满足特定SIP要求，使用的启停开关。特性状态有开发中、测试中、试用中、废弃中等。

config.py里DEFAULT_FEATURE_FLAGS存储了缺省特性标识，可以在super_config.py里用FEATURE_FLAGS覆盖这些特性标识。

启用标识后，有可能需要新建或更新元数据表，最好先执行`superset init`

典型功能如

* 警报&邮件：ALERT_REPORTS
* 行级别安全： ROW_LEVEL_SECURITY
* 看板权限管控（当前只确定了看板页的读写权限，并未对涉及的图表作相关管制）：DASHBOARD_RBAC



表格  v1.0特性的标识及依赖

| Feature                   | Feature Flag                                                 | Dependencies                                                 | Documentation                                                |
| :------------------------ | :----------------------------------------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| Global Async Queries      | `GLOBAL_ASYNC_QUERIES: True`                                 | Redis 5.0+, celery workers configured and running            | [Extra documentation](https://github.com/apache/superset/blob/master/CONTRIBUTING.md#async-chart-queries) |
| Dashboard Native Filters  | `DASHBOARD_NATIVE_FILTERS: True`                             |                                                              |                                                              |
| Alerts & Reporting        | `ALERTS_REPORTS: True`                                       | [Celery workers configured & celery beat process](https://superset.apache.org/docs/installation/async-queries-celery) |                                                              |
| Homescreen Thumbnails     | `THUMBNAILS: TRUE, THUMBNAIL_CACHE_CONFIG: CacheConfig = { "CACHE_TYPE": "null", "CACHE_NO_NULL_WARNING": True}` | selenium, pillow 7, celery                                   |                                                              |
| Dynamic Viz Plugin Import | `DYNAMIC_PLUGINS: True`                                      |                                                              |                                                              |



config.py

DEFAULT_FEATURE_FLAGS里的特性缺省为false；如果默认是True说明将成为基本功能，一般无需在FEATURE_FLAGS重新定义。。

```python
# ---------------------------------------------------
# Feature flags
# ---------------------------------------------------
# Feature flags that are set by default go here. Their values can be
# overwritten by those specified under FEATURE_FLAGS in super_config.py
# For example, DEFAULT_FEATURE_FLAGS = { 'FOO': True, 'BAR': False } here
# and FEATURE_FLAGS = { 'BAR': True, 'BAZ': True } in superset_config.py
# will result in combined feature flags of { 'FOO': True, 'BAR': True, 'BAZ': True }
DEFAULT_FEATURE_FLAGS: Dict[str, bool] = {
    # allow dashboard to use sub-domains to send chart request
    # you also need ENABLE_CORS and
    # SUPERSET_WEBSERVER_DOMAINS for list of domains
    "ALLOW_DASHBOARD_DOMAIN_SHARDING": True,
    # Experimental feature introducing a client (browser) cache
    "CLIENT_CACHE": False,
    "DISABLE_DATASET_SOURCE_EDIT": False,
    "DYNAMIC_PLUGINS": False,
    "ENABLE_EXPLORE_JSON_CSRF_PROTECTION": False,
    "ENABLE_TEMPLATE_PROCESSING": False,
    "KV_STORE": False,
    "PRESTO_EXPAND_DATA": False,
    # Exposes API endpoint to compute thumbnails
    "THUMBNAILS": False,
    "DASHBOARD_CACHE": False,
    "REMOVE_SLICE_LEVEL_LABEL_COLORS": False,
    "SHARE_QUERIES_VIA_KV_STORE": False,
    "SIP_38_VIZ_REARCHITECTURE": False,
    "TAGGING_SYSTEM": False,
    "SQLLAB_BACKEND_PERSISTENCE": False,
    "LISTVIEWS_DEFAULT_CARD_VIEW": False,
    # Enables the replacement React views for all the FAB views (list, edit, show) with
    # designs introduced in https://github.com/apache/superset/issues/8976
    # (SIP-34). This is a work in progress so not all features available in FAB have
    # been implemented.
    "ENABLE_REACT_CRUD_VIEWS": True,
    # When True, this flag allows display of HTML tags in Markdown components
    "DISPLAY_MARKDOWN_HTML": True,
    # When True, this escapes HTML (rather than rendering it) in Markdown components
    "ESCAPE_MARKDOWN_HTML": False,
    "DASHBOARD_NATIVE_FILTERS": False,
    "GLOBAL_ASYNC_QUERIES": False,
    "VERSIONED_EXPORT": False,
    # Note that: RowLevelSecurityFilter is only given by default to the Admin role
    # and the Admin Role does have the all_datasources security permission.
    # But, if users create a specific role with access to RowLevelSecurityFilter MVC
    # and a custom datasource access, the table dropdown will not be correctly filtered
    # by that custom datasource access. So we are assuming a default security config,
    # a custom security config could potentially give access to setting filters on
    # tables that users do not have access to.
    "ROW_LEVEL_SECURITY": False,
    # Enables Alerts and reports new implementation
    "ALERT_REPORTS": False,
    # Enable experimental feature to search for other dashboards
    "OMNIBAR": False,
    "DASHBOARD_RBAC": False,
}
```



### 特性简易说明

superset_config.py

```python
FEATURE_FLAGS = {
    #"ROW_LEVEL_SECURITY" : True,
    "DASHBOARD_CROSS_FILTERS" : True,
    "THUMBNAILS" : True,
    "DASHBOARD_RBAC" : False,
    "ESCAPE_MARKDOWN_HTML" : True,
    "ENABLE_TEMPLATE_PROCESSING" : True,
    "LISTVIEWS_DEFAULT_CARD_VIEW" : True,
    "ALERTS_REPORTS" : True,
    "SCHEDULED_QUERIES" : False,
    "DASHBOARD_NATIVE_FILTERS": False,
    "GLOBAL_ASYNC_QUERIES" : False
}
```

特性说明：

* LISTVIEWS_DEFAULT_CARD_VIEW   卡片视图列表缺省   True-列表， False-缩略图

* ESCAPE_MARKDOWN_HTML    True- 不处理html文档（即不解析html标签）
* THUMBNAILS  缩略图   True-显示缩略大图；False-不显示缩略大图，没有缩略开关。
* DASHBOARD_RBAC  看板访问权限基于角色。 True-看板需要设置角色才能访问；False-默认公开访问。
* DASHBOARD_CROSS_FILTERS  交叉过滤。 True-图表页有个控制勾选开关。



### 行安全 ROW_LEVEL_SECURITY

路由： /rowlevelsecurityfiltersmodelview/list/

行过滤级器有二种，分为常规和基本。

* 常规：可以在指定角色的SQL查询语句里自动在 WHER语句里添加 过滤条件。
* 基本：应用于指定角色之外用户，相当于常规的反例。

过滤语法：示例如``大区`='华南'`， 字段名用``圈 起来，值用单引号圈起来，过滤条件可以得复杂组合。

行级别安全特性在v1.1后成熟。一个查询可以用到多个行过滤器，如果设置相同的groupkey, 那么它们的过滤条件是`或(OR)`关系，否则是`与(AND)`关系。



### 交叉过滤 DASHBOARD_CROSS_FILTERS

v1.1开始引入交叉过滤 x-filtering，1.2版本成熟。

**使用步骤**：

1. superset_config.py 里打开 DASHBOARD_CROSS_FILTERS特性标识。`FEATURE_FLAGS["DASHBOARD_CROSS_FILTERS"]=True`
2. 打开看板，要包括能触发看板交叉过滤（EMIT DASHBOARD CROSS FILTERS）的图表。目前能触发交叉过滤的图表有饼图、表格、Echarts(bar, line, treeview)等。
3. 点击图表维度字段，即触发交叉过滤。



**实现逻辑**

1. 点击看板某支持联动图表时，触发向看板其它图表发送请求，自身图表不触发新的AJAX请求。

   ```shell
   # 常规图表请求
   POST /api/v1/chart/data?form_data=

   # 特殊图表-地图请求
   POST /superset/explore_json/?form_data=

   # 请求参数：form_data数据（json格式）和 dashboard_id
   form_data={"slice_id":89}&dashboard_id=6
   ```



### 警报&报告 ALERTS_REPORTS

https://superset.apache.org/docs/installation/alerts-reports

v1.0以上版本支持，默认不开启。

用户可以配置自动警报和报告，以向电子邮件收件人或 Slack 渠道发送仪表板或图表。

* 达到 SQL 条件时发送警报
* 报告按计划发送



### 邮件 EMAIL

无特性标识。要ENABLE_SCHEDULED_EMAIL_REPORTS 为True时，然后`superset init`，

才会在 菜单设置- 出现2个菜单项： Dashboard Emails 和  Chart Email Schedules

可以选择发送的看板，crontab表达式，邮箱，是否发送测试邮件，内联还是附件。

也可以选择发送图表：可以选择发送原始数据。

```python
# Enable / disable scheduled email reports
ENABLE_SCHEDULED_EMAIL_REPORTS = False

# Enable / disable Alerts, where users can define custom SQL that
# will send emails with screenshots of charts or dashboards periodically
# if it meets the criteria
ENABLE_ALERTS = False

# Used for Alerts/Reports (Feature flask ALERT_REPORTS) to set the size for the
# sliding cron window size, should be synced with the celery beat config minus 1 second
ALERT_REPORTS_CRON_WINDOW_SIZE = 59

EMAIL_NOTIFICATIONS = True
SMTP_HOST = "email-smtp.eu-west-1.amazonaws.com"
SMTP_STARTTLS = True
SMTP_SSL = False
SMTP_USER = "smtp_username"
SMTP_PORT = 25
SMTP_PASSWORD = os.environ.get("SMTP_PASSWORD")
SMTP_MAIL_FROM = "insights@komoot.com"
```



### CELERY

邮件、异步查询 等功能依赖于celery。

```python
class CeleryConfig(object):
    BROKER_URL = 'redis://localhost:6379/0'
    CELERY_IMPORTS = (
        'superset.sql_lab',
        'superset.tasks',
    )
    CELERY_RESULT_BACKEND = 'redis://localhost:6379/0'
    CELERYD_LOG_LEVEL = 'DEBUG'
    CELERYD_PREFETCH_MULTIPLIER = 10
    CELERY_ACKS_LATE = True
    CELERY_ANNOTATIONS = {
        'sql_lab.get_sql_results': {
            'rate_limit': '100/s',
        },
        'email_reports.send': {
            'rate_limit': '1/s',
            'time_limit': 120,
            'soft_time_limit': 150,
            'ignore_result': True,
        },
    }
    CELERYBEAT_SCHEDULE = {
        'email_reports.schedule_hourly': {
            'task': 'email_reports.schedule_hourly',
            'schedule': crontab(minute=1, hour='*'),
        },
    }

CELERY_CONFIG = CeleryConfig
```



启动 celery

```shell
$ celery worker --app=superset.tasks.celery_app:app --pool=prefork -O fair -c 4
$ celery beat --app=superset.tasks.celery_app:app

# flower监听celery运行情况，flower只能运行在celery较低版本（接近废弃）
$ pip install flower
$ celery flower --app=superset.tasks.celery_app:app
```





## 2.5 使用技巧

### 时间字段

时间字段要求是datatime格式，类似YYYY-MM-DD HH:MM:SS。

如果是数值格式的timestamp，需要转化成datetime格式。

表格 1 各数据库的时间字段使用技巧

| database   | 时间字段格式               | timestamp转化                          | 其它 |
| ---------- | -------------------------- | -------------------------------------- | ---- |
| MySQL      | 常规。                     | FROM_*UNIXTIME*(unix_timestamp,format) |      |
| SQLite     | MM-DD要求是二位数，如10-01 |                                        |      |
| PostgreSQL |                            |                                        |      |
| Oracle     |                            |                                        |      |
| Kylin      |                            |                                        |      |

备注：字段格式使用D3格式。



### D3字段格式

数值格式：D3.format('d')  https://github.com/d3/d3-format/blob/master/README.md#format

时间格式：



<br>

# 3  开发篇

## 3.1 开发者必知

### 服务端本地调试（pycharm）

**法1： Pycharm专业版：选择FLASK_SERVER**

```ini
Target:  {SUPERTSET_PATH}\superset\app.py
Additional option:  -h 0.0.0.0
FLASK_ENV:  development
```



**法2：(推荐) Pycharm社区版，选择 python**

```ini
Module name: superset.run 或者 flask/superset
Parameters:
Environment variables: PYTHONUNBUFFERED=1;SUPERSET_CONFIG_PATH=;
Working directory: 当前superset目录父级
```

增加 superset/run.py（即superset.run，可选）

```python
from superset import create_app

if __name__ == '__main__':
    app = create_app()
    app.run(host="localhost", port=6000)
```

运行命令：`python -m superset.run`



**法3：命令行 或  Pycharm temianl运行 或者 Pycharm选择 shell script**

```shell
# 需要设置环境变量：PYTHONPATH和FLASK_APP, 环境变量设置windows用set, linux用export
set PYTHONPATH=`pwd`  #实际项目目录
set FLASK_APP=superset

# superset或flask启动，这二脚本需要能在系统路径识别，否则脚本全路径启动
superset run -h 0.0.0.0 -p 5000
```



### 前端调试

```shell
# 本地开发调试，js/less文件有改动会实时编译，但服务器端需要重启才能生效。 使用webpack.config.js配置
npm run dev

# 远程调试，会在webpack里导入webpack.proxy-config.js配置，指定远程服务器地址作为 调试时所连接的后端服务器。
npm run dev-server
```



webpack.proxy-config.js

```js
// 下面指定 远程服务器地址和端口 supersetUrl
const { supersetPort = 8088, superset: supersetUrl = null } = parsedArgs;
const backend = (supersetUrl || `http://localhost:${supersetPort}`).replace('//+$/','',);   //移除尾部符号/
```



## 3.2 API

官方接口文档：https://superset.apache.org/docs/rest-api

本服务接口文档：http://127.0.0.1:5000/swagger/v1

API swagger文档实现在flask_appbuild模块，通过变量FAB_API_SWAGGER_UI来配置。文档schema定义在/docs/src/resources.openapi.json。

可通过 命令`flask routes`获取路由、方法和视图函数列表，superset约有300个API。

**路由映射方法 **

* 主要使用 flask_appbuild 模块提供的装饰器:  expose 和 expose_api
  * expose   路由会在父路由基础上添加，如 expose('expore_json')，实际上指向 /superset/explore_json
  * （没用到）expose_api 用于API，返回JSON。如/api/v1/xxx
* xxAPP.route:  flask原生路由，仅用于健康检查API如`/health`, /healthcheck, /ping

**路由前缀**：  route_base要以/开头，新定义API类xxAPI要通过`app.py appbuilder.add_api(xxAPI)`才能注册路由。

* 继承自flask_appbuilder.baseviews.BaseView:  路由前缀为 `/lower(class.__name__)/`，如Superset类的路由前缀为/superset

* RestApi的路由前缀：`{route_base} or /api/{version}/{resource_name}`  ，如 /api/v1/chart/
* ModelView的路由前缀：/superset/{route_base}，如 /superset/explore_json



**请求体格式**：一般是JSON，也有部分API是form传输。

**响应体格式**，有二种：

  * JSON格式：页面局部更新。
  * HTML格式：每个页面都是一个单独HTML，页面名称可参见 webpack.config.js里的entry。需用到模板，页面全部更新。



**API实现**： 详见下方表格 superset API列表

表格 superset API 列表 (swagger api, 前缀是 /api/{version}/)

| API类别 (Swagger)  | API路径                                  | API实现文件                    | API说明      |
| ------------------ | ---------------------------------------- | ------------------------------ | ------------ |
| Annotaion Layers   | /annotaion_layers/                       | api.py                         | 注解层       |
| AsyncEventsRestApi | /async_event/                            | api.py                         | 异步查询事件 |
| CacheRestApi       | /cachekey/                               | api.py                         | 缓存         |
| Charts             | /chart/                                  | api.py                         | 图表         |
| CSS Templates      | /css_template/                           | api.py                         | CSS          |
| Dashboards         | /dashboard/                              | api.py                         | 看板         |
| Databases          | /database/                               | api.py                         | 数据库       |
| Datasets           | /dataset/                                | api.py                         | 数据集       |
| Queries            | /query/                                  | api.py                         | 查询         |
| Report Schedules   | /report/                                 | api.py                         | 报告调度     |
| Menu               | /menu/                                   | flask_appbuild/menu.py         | 菜单         |
| Security           | /security/                               | flask_appbuild/security/api.py | JWT安全登陆  |
| OpenApi            | /openapi/{version}/_openapi              | ?                              | openapi      |
| LogRestApi         | /log/                                    | /views/log/api.py              | 日志         |
|                    | /query/, /query_from_data/, /time_range/ | /views/api.py                  | {version}=v1 |

说明：若未特殊说明，Swagger API实现在路径前缀目录下的api.py。示例路由前缀/chart/，则相应API实现在/chart/api.py。



表格 superset API列表 (非/api/开头的)

| API类别    | API路径前缀                                                  | API实现文件          | API说明         |
| ---------- | ------------------------------------------------------------ | -------------------- | --------------- |
| Superset   | /superset/                                                   | /views/core.py       |                 |
| datasource | /datasource/                                                 | /views/datasource.py | 路由有save, get |
| key_value  | /kv/                                                         | /views/key_value.py  | 路由有store     |
| sql_lab    | /savedqueryview/, /tablestateview/                           | /views/sql_lab.py    |                 |
| health     | /ping, /healthcheck, /health                                 | /views/health.py     | 健康检查        |
| tags       | /tags/                                                       | /views/tags.py       |                 |
| schedule   | /emailscheduleview/,  /sliceemailscheduleview/,<BR>/dashboardemailscheduleview/ | /views/schedule.py   |                 |

**新增API**

* 如果新增API类，继承已有类，如 DatasetRestApi。
  * 通过`appbuilder.add_api(xxAPI)`才能注册路由；

* 如果在原有API类上增加API，只需保证路由名和路由函数在本类不一样即可。



**Rison**:  查询参数格式，用()圈起来，里面值可以转化成JSON格式。

* 参数的KEY和VALUE的格式：会作严格检验，不能是数字开头（`-0123456789`），也不能是

  ````
  \x00\x01\x02\x03\x04\x05\x06\x07\x08\t\n\x0b\x0c\r\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f !"#$%&\'()*+,:;<=>?@[]^`{|}
  ````

  这些开头。 因此，KEY和字符串格式的VALUE要求是字母或unicode非符号开头，能用的符号只有`- _ .`。

* prison特殊符号有：`( ) ! : ' `

示例如下（如果是URL传参，则需要将参数值URLENCODE），

```shell
# 示例：分页查询
?q=(order_column:changed_on_delta_humanized,order_direction:desc,page:0,page_size:25)
# 示例：搜索过滤
?q=(filters:!((col:slice_name,opr:chart_all_text,value:%E6%97%B6%E9%97%B4)),)

>>> import prison
>>> q = '(order_column:changed_on_delta_humanized,order_direction:desc,page:0,page_size:25)'
>>> qd = prison.loads(q)
>>> qd
{'order_column': 'changed_on_delta_humanized', 'order_direction': 'desc', 'page': 0, 'page_size': 25}
```

备注：上面查询参数里的字符串 xxx表示 某个具体的查询字符串。





**常用参数**

* standalone:  true/false，是否网页外嵌，适用于看板和图表页
* force:  true/false, 是否强制刷新，适用于看板和图表的数据查询



### /superset/前缀路由

以 /superset/开头的路由目前有60+。

相关文件：

* /superset/viwes/core.py   Superset视图类，继承自flask_appbuilder.baseviews.BaseView，route_base为类名即路由前缀为/superset/
* /superset/models/xx.py

| 接口名           | 接口路由 （省略前缀/superset） | 方法     | 参数说明 | 响应结果 |
| ---------------- | ------------------------------ | -------- | -------- | -------- |
| 图表页           | /explore/<slice_id>            | GET POST |          | HTML     |
| SQL查询          | /explore_json/                 | GET POST |          | JSON     |
| 看板页           | /dashboard/<dashboard_id>      | GET      |          | HTML     |
| 看板保存（覆盖） | /save_dash/<dashboard_id>      | GET POST |          | JSON     |
| 看板另存为       | /copy_dash/<dashboard_id>      | GET POST |          | JSON     |
| 获取token        | /csrf_token/                   | GET      |          | JSON     |
| ...              |                                |          |          |          |



### 图表 Chart列表页

![image-20210702145252701](../../media/code/code_superset_001.png)

* 图表列表页：/chart/list/?pageIndex=0&sortColumn=changed_on_delta_humanized&sortOrder=desc&viewMode=table

* 图表页：/superset/explore/?form_data=%7B%22slice_id%22%3A%20464%7D

表格 图表列表页所包括的接口

| 接口名                         | 用途             | 详细参数 GET方法                                             | 参数说明                                    | 响应结果                                                     |
| ------------------------------ | ---------------- | ------------------------------------------------------------ | ------------------------------------------- | ------------------------------------------------------------ |
| /api/v1/chart/related/<column> | 修改人<br>创建人 | ?q=(),                                                       | column: owners, created_by                  | {"count":3,"result":[{"text":"adminuser","value":1},{"text":"","value":2},{"text":"","value":3}]} |
| /api/v1/dataset/               | 数据集列表       | ?q=(columns:!(datasource_name,datasource_id),keys:!(none),order_column:table_name,order_direction:asc) | order_column排序列，order_direction排序方向 |                                                              |
| /api/v1/chart/                 | 图表列表         | ?q=(order_column:changed_on_delta_humanized,order_direction:desc,page:0,page_size:25) | page, page_size                             |                                                              |
|                                | 图表列表的过滤   | ?q=(filters:!((col:slice_name,opr:chart_all_text,value:xxx)),) | value                                       |                                                              |
| /api/v1/chart/_info            | 权限信息         | ?q=(keys:!(permissions))                                     |                                             | {"permissions":["can_write","can_read"]}                     |
| /api/v1/chart/favorite_status/ | 收藏状态         | ?q=xxxxxx                                                    |                                             | {"result":[{"id":464,"value":false},{"id":438,"value":false}]} |
|                                |                  |                                                              |                                             |                                                              |
| /superset/explore/             | 图表入口         | ?form_data=%7B%22slice_id%22%3A%20464%7D                     |                                             |                                                              |
| /superset/explore/table/<pk>/  | 数据集入口       |                                                              | pk-数据集ID                                 |                                                              |
| /superset/profile/<user>       | 修改人入口       |                                                              |                                             |                                                              |

说明：查询参数的语法类似 ES查询语法。

示例：**图表列表/api/v1/chart/  的响应结果 JSON**

```json
{
  "count": 0,
  "description_columns": {
    "column_name": "A Nice description for the column"
  },
  "ids": [
    "string"
  ],
  "label_columns": {
    "column_name": "A Nice label for the column"
  },
  "list_columns": [
    "string"
  ],
  "list_title": "List Items",
  "order_columns": [
    "string"
  ],
  "result": [
    {
      "cache_timeout": 0,
      "changed_by": {
        "first_name": "string",
        "last_name": "string"
      },
      "created_by": {
        "first_name": "string",
        "id": 0,
        "last_name": "string"
      },
      "datasource_id": 0,
      "datasource_type": "string",
      "description": "string",
      "id": 0,
      "owners": {
        "first_name": "string",
        "id": 0,
        "last_name": "string",
        "username": "string"
      },
      "params": "string",
      "slice_name": "string",
      "table": {
        "default_endpoint": "string",
        "table_name": "string"
      },
      "viz_type": "string"
    }
  ]
}
```



### 看板 Dashboard列表页

* 看板列表页 /dashboard/list/?pageIndex=0&sortColumn=changed_on_delta_humanized&sortOrder=desc&viewMode=table
* 看板页 /superset/dashboard/<id>/?form_data=%7B%22slice_id%22%3A%20464%7D

表格 看板列表页所包括的接口

| 接口名                               | 用途           | 详细参数 GET方法                                             | 参数说明                                    | 响应结果                                                     |
| ------------------------------------ | -------------- | ------------------------------------------------------------ | ------------------------------------------- | ------------------------------------------------------------ |
| /api/v1/dashboard/related/owners     | 修改人<br>     | ?q=()                                                        |                                             | {"count":3,"result":[{"text":"adminuser","value":1},{"text":"","value":2},{"text":"","value":3}]} |
| /api/v1/dashboard/related/created_by | 创建人         | ?q=()                                                        |                                             | 同上                                                         |
| /api/v1/dataset/                     | 数据集列表     | ?q=(columns:!(datasource_name,datasource_id),keys:!(none),order_column:table_name,order_direction:asc) | order_column排序列，order_direction排序方向 |                                                              |
| /api/v1/dashboard/                   | 图表列表       | ?q=(order_column:changed_on_delta_humanized,order_direction:desc,page:0,page_size:25) | page, page_size                             |                                                              |
|                                      | 图表列表的过滤 | ?q=(filters:!((col:slice_name,opr:chart_all_text,value:%E6%97%B6%E9%97%B4)),) | value                                       |                                                              |
| /api/v1/dashboard/_info              | 权限信息       | ?q=(keys:!(permissions))                                     |                                             | {"permissions":["can_write","can_read"]}                     |
| /api/v1/dashboard/favorite_status/   | 收藏状态       | ?q=xxxxxx                                                    |                                             | {"result":[{"id":464,"value":false},{"id":438,"value":false}]} |
|                                      |                |                                                              |                                             |                                                              |
| /superset/dashboard/<id>/            | 看板入口       | ?form_data=%7B%22slice_id%22%3A%20464%7D                     |                                             |                                                              |

说明：看板和图表 5个RESTFUL接口类似（将chart替换成相应的dashboard）：创建人、修改人、权限信息、列表、收藏状态。



### 图表页

* 图表页（返回HTML） /superset/explore/?form_data=

表格 新增图表页所包括的接口

| 接口名                  | 用途         | 方法 | 路径参数 （通常GET方法）                                     | 参数说明                      | 响应结果                                                     |
| ----------------------- | ------------ | ---- | ------------------------------------------------------------ | ----------------------------- | ------------------------------------------------------------ |
| /api/v1/time_range/     | 时间<br>区域 |      | ?q=%E5%91%A8                                                 | 周/                           | {"result": {"since": "", "until": "2021-07-12T00:00:00", "timeRange": "\u5468"}} |
| /api/v1/chart/<id>      | 图表配置信息 |      |                                                              |                               |                                                              |
| /api/v1/dataset/        | 数据集列表   | GET  | ?q=(order_column:changed_on_delta_humanized,order_direction:asc,page:0,page_size:20) |                               |                                                              |
| /api/v1/dataset/_info   | 权限信息     |      | ?q=(keys:!(permissions))                                     |                               |                                                              |
| /api/v1/chart/data      | 查看图表数据 | POST | ?form_data=%7B%22slice_id%22%3A437%7D                        | result_type: results或samples |                                                              |
| /superset/explore_json/ | 数据查询结果 | POST | /?form_data=%7B%22slice_id%22%3A464%7D&result=true           | form_data, result是否展示     |                                                              |

说明：保存图表接口是`POST /superset/explore/`（覆盖和另存为的区别在于保存数据时是否有传输slice_id，``），修改图表（即编辑图表属性）接口是`PUT /api/v1/chart/`。

1. 修改图表时只传改变的数据，必需参数slice_id/slice_name（会用来检验图表是否存在）。可选参数有datasource_id/datashboard/owners ，若传参datasource_id,会检测数据库ID是否存在（dbs表），datashboard会检查关联看板是否存在(dashboards表），owners会检查关联属主用户是否存在（slice_owner表）。

2. 隐藏校验：会用当前用户检验是否有数据访问权限（如数据源/数据集访问权限，是否图表/看板属主）。

示例：

```json
# 图表保存覆盖 请求json:  action: overwrite/saveas
{slice_id: 473, action: "overwrite", slice_name: "blood2", save_to_dashboard_id: null}
```



### 看板页

* 看板页（返回HTML）:  `GET /superset/dashboard/<dashboard_id_or_slug>`
* 保存看板（覆盖）： `@expose("/save_dash/<int:dashboard_id>/", methods=["GET", "POST"])`
* 保存看板（另存为）： `@expose("/copy_dash/<int:dashboard_id>/", methods=["GET", "POST"])`
* 编辑看板：`PUT /api/v1/dashboard/<dashboard_id_or_slug>`

说明：看板另存还包括是否复制图表。



### 数据集 dataset

* 创建：物理表- `POST /api/v1/dataset/`   ，虚表--`POST /superset/sqllab_viz/`
* 修改：`POST /datasource/save/`  OR  `PUT /api/v1/dataset/`（实际未用）
* 删除：`DEL /api/v1/dataset/ `



表格 修改数据集的二个API比较

| 路由     | /api/v1/dataset/                                  | /datasource/save/                                    |
| -------- | ------------------------------------------------- | ---------------------------------------------------- |
| 方法     | PUT                                               | POST                                                 |
| 数据格式 | JSON                                              | FORM                                                 |
| 简介     | 支持只更新参数中的字段，默认override_column=false | 会覆盖表中所有字段。                                 |
| 应用场景 | 未用                                              | 数据源编辑时保存                                     |
| API实现  | /views/datasets/api.py                            | /views/datasource.py                                 |
| 权限检验 | @has_access_api                                   | @has_access_api 需要有权限项`can save on datasource` |



示例：**数据集查询/api/v1/dataset/ 的响应结果 JSON**

```json
{
  "count": 1,
  "description_columns": {
    "column_name": "A Nice description for the column"
  },
  "ids": [
    "string"
  ],
  "label_columns": {
    "column_name": "A Nice label for the column"
  },
  "list_columns": [
    "string"
  ],
  "list_title": "List Items",
  "order_columns": [
    "string"
  ],
  "result": [
    {
      "changed_by": {
        "first_name": "string",
        "username": "string"
      },
      "database": {
        "database_name": "string",
        "id": 0
      },
      "default_endpoint": "string",
      "extra": "string",
      "id": 0,
      "owners": {
        "first_name": "string",
        "id": 0,
        "last_name": "string",
        "username": "string"
      },
      "schema": "string",
      "sql": "string",
      "table_name": "string"
    }
  ]
}
```





## 3.3 简易定制化

表格 简易定制化的修改项

| 修改项                          | 前端修改react  /superset-frondend/                       | 后端修改python  /superset/             | 备注            |
| ------------------------------- | -------------------------------------------------------- | -------------------------------------- | --------------- |
| 字符符国际化                    | tsx,jsx文件里需要国际化的字符串加 t()                    | py,html文件里需要国际化的字符串加 __() | 详见 国际化章节 |
| 图表/看板列表页修改默认排序字段 | 传参时修改页面呈现字段：ChartList.tsx  DashboardList.tsx | 不传参修改缺省字段                     |                 |
|                                 |                                                          |                                        |                 |

说明：上面表格中出现的xx表示要修改的内容。



### 3.3.1 国际化

国际化有几个常用模块：locale babel humanize

英文字母大写设计规约： [capitalization-guidelines](https://github.com/apache/superset/blob/afb8bd5fe68066cfe2f3d384d659215dc4790d9d/CONTRIBUTING.md#capitalization-guidelines)



**humanize 人性化**

依赖模块humanize。superset人性化主要是时间日期，服务端返回的字段changed_on_humanized已经是中文时间格式了。

客户端使用moment.js，可以从bootstra_data里获取moment_locale 进行初始化（尚未发现真正使用的地方）。



#### babel 语言翻译

实现原理：flask_babel --> babel

说明：babel翻译能自动对货币、日期格式按照语言环境进行切换。



配置文件 config.py

 ```python
# 本地化: BABEL_DEFAULT_LOCALE - flask_babel模块所需变量; LANGUAGES - for humanize和多语种选择
BABEL_DEFAULT_LOCALE = 'zh'
LANGUAGES = {"zh": {"flag": "cn", "name": "Chinese"}}
 ```



中文化修改细则:

| 页面     | 类别            | 字符串                                                       | 字符串位置 示例                                              | 修改tag | 修改方法                                      | 效果 |
| -------- | --------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------- | --------------------------------------------- | ---- |
| ALL      | 普通修改        |                                                              | .py .html .tsx .js .jsx                                      | __或t   | 修改message.json相应项                        | OK   |
| 导航菜单 | 服务端 py       | Data Datasets Databases Charts Dashboard "SQL Lab" "Saved Query"  Settings | app.py add_link/add_view里的label=__("Datasets"),            | __      | 修改flask_appbulder下的po文件，再转成mo文件。 | OK   |
|          | flask_appbulder | Security "User info"                                         | flask_appbuilder/security/views.py:141 lazy_gettext("User info") | t       | 修改flask_appbulder下的po文件，再转成mo文件。 | OK   |
|          | ?               | Version                                                      | ？                                                           |         |                                               | ?    |
| 首页     | 首页右侧按钮    | "VIEW ALL" "SQL QUERY" DASHBOARD                             | /src/views/CRUD/welcome/xx.tsx<br>                           | 缺      | 需改造 代码，加t                              |      |
| 列表页   | 列表页过滤字段  | All Any                                                      | ChartList.tsx DashboardList.tsx                              | 缺      | 需改造 代码，加t                              |      |
|          | 数据源列表字段  | name type connection schema creator                          | src/datasource/ChangeDatasourceModel.tsx                     | 缺      | 需改造 代码，加t                              |      |
| 图表     | 时间下拉框      | "Adaptative formating"                                       | 前端                                                         | 缺      | 需改造 代码，加t                              |      |
|          | 时间序列图      | "Weekly seasonality"                                         | @superset-ui包                                               | 缺      | 需改造 代码，加t                              |      |
| 看板     | 排序下拉框      | Sort by Recent                                               | SliceAdder.jsx  Sort by {label}                              | 缺      | 需改造 代码，加t                              |      |
|          | 图表类型        | pie table word_cloud ...                                     | AddSliceCard.jsx <br>`<span>{visType}</span>`                | 缺      | 需改造 代码，加t                              |      |
| 数据集   | 编辑            | "Enable Filter Select"                                       | 这个页面比较奇怪，代码中也是"Enable Filter Select"。<br>但所有label字符串都不起作用。 | ？      | 使用了flask_appbuilder组件，需要此模块加串    | ？   |

说明：可以用工具从指定目录或文件中生成po文件。如果只想添加少量字段，可以手工附加字段值到现有messages.json。

* 语言包数据传递：语言包数据包含在服务端传输给前端的data-boostra里，因此国际化修改最好是在服务端进行。

* **修改原理和tag**：`__和_` 是在服务端py或html文件里，t是在客户端tsx文件里。原理都是babel转化。如果有需要国际化的字符串，可根据文件名相应选择修改tag。

  * flask_babel法:  xx.py 或者 xx.html(jinja2模板) 使用 __

  ```jsx
  from flask_babel import gettext as __, lazy_gettext as _
  #汉化语法为
  _('需要汉化的字符')

  #按钮需要加上{{  }}才可行。
  {{_('需要汉化的按钮字符')}}
  ```

  * @superset-ui:  xx.jsx 使用 t，t 支持格式化字符串

  ```jsx
  import {t, validateNonEmpty} from '@superset-ui/core';

  color_scheme: {
      type: 'ColorSchemeControl',
      label: t('Color scheme'),
  	description: t('The color scheme for rendering chart'),
      label_t : t('Calculated column [%s] requires an expression', col.column_name),  //支持t 带格式化符
  }

  // @superset-ui/core/
  ```

* **修改方法**：

  * superset的translation： messages.json直接修改。或者修改messages.po，然后工具转化成json。修改后重启python服务即生效。
  * flask_appbuilder的translation:  messages.mo才能生效，因此修改po文件后要用工具转成mo格式。导航菜单这部分直接使用fab权限，因此要把菜单字段值添加到/flask_appbuilder/tranlations目录下相应文件才生效。



主要修改二部分

1. **基础国际化**

参见  上面修改方法。

pot/po/mo/json格式转化流程如下：

```shell
# 安全起见，避免覆盖 可先创建目录translation2，将生成的pot/po/json都先放到这个目录，等一切ok再替换superset/translations/zh下相关文件
$ cd $SUPERSET_HOME
$ mkdir translations2
$ pybabel extract -F superset/translations/babel.cfg -k _ -k __ -k t -k tn -k tct -o translations2/msg.pot .
# 将 .pot转化成 .po格式， -d指向生成目录，-l指向语种，下例中生成文件在 translations2/zh/message.po,
$ pybabel init -i translations2/msg.pot -d translations2 -l zh

# step2: 人工翻译 messages.po

# step3: 编译 .po -> .mo
# (OK)法1：pybable -d 编译目标目录，-l 语种。要求指定目录的里层结构是$locale/LC_MESSAGES/xx.po
$ pybabel compile -d translations2 -l zh

# step4: .po -> .json
# (OK推荐)js实现的po2json：npm install po2json -g, 参数-d domain, -f format -p pretty
$ po2json -d superset -f jed1.x -p ./messages.po ./messages.json
```



babel.cfg 示例

```ini
#[ignore: superset-frontend/node_modules/**]
[python: superset/**.py]
[jinja2: superset/**/templates/**.html]
[javascript: superset-frontend/src/**.js]
[javascript: superset-frontend/src/**.jsx]
[javascript: superset-frontend/src/**.tsx]
[javascript: superset-frontend/node_modules/@superset-ui/**.js]
[javascript: superset-frontend/node_modules/@superset-ui/**.jsx]
[javascript: superset-frontend/node_modules/@superset-ui/**.tsx]

encoding = utf-8
```

说明：上面配置放弃了superset-frontend/node_module/，实际@superset-ui模块有好多显示字符串。下面三个目录合计返回约2341次。

* superset/目录下，搜索 ` _("` 返回匹配次数774次。
* superset-frontend/src/目录下，搜索` t(`  返回匹配次数645次。
* superset-frontend/node_module/@superset-ui/目录下，搜索` t(`  返回匹配次数888次，排重后618次。



2. **特殊修改**
* 一般情况下字符串要完全匹配，严格区分大小写和符号。 但对于按纽或表单类，经常有作大小写转化（有命名规范：区分专有名词和普通名词），要区别对待。
  * 通常可以用页面显示的英文串作为KEY；如果不生效，再在代码中搜索，用代码中的英文串作KEY。示例：显示`Create By` 用  `Create by`, 显示`BULK SELECT`用 `Bulk select`.

  * KEY值尾部带空格：用PO生成的KEY尾部带空格有24个，要注意判断。如 `"Edit Dataset ": ["编辑数据集"],`

* 尚未用 __或t 圈起来的字符串，需在代码中添加国际化修改操作符。

* 使用了flask_appbuilder模块的组件或模板，国际化需要在flask_appbuilder模块的translations添加。这个一般直接返回HTML，客户端不再转化语言。

  * 导航菜单的字符串标签，使用了flask_appbuilder模块导航菜单组件
  * 表格编辑/tablemodelview/edit/<pk> 使用了flask_appbuilder模块原生模板

* 换行符处理：messages.json一般是unix格式，因此里面的\r\n要换成\n。





### 3.3.2 网页嵌入外部系统

**应用场景**

* superset本身已支持的共享项：看板、图表，用standalone=true识别，外部系统要能访问需要开通公共用户权限，并且公共角色需要相关数据源/数据集权限。这个外部系统的共享只能用于公开数据。
* 需要修改布局：看板列表页、图表列表页
* 权限管控的网页嵌入：？



#### 共享图表/看板

看板示例URL： http://localhost:5000/superset/dashboard/1/?standalone=true

图表示例URL：http://localhost:5000/superset/explore/?r=5&standalone=true&height=400

表格 嵌入URL

|              | 共享图表                                           | 共享看板                                                     | 共享看板里的图表                                             |
| ------------ | -------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 简介         | 页面点击生成共享链接                               | 页面点击生成共享链接                                         | 每个图表独自调用一个API explore_json，返回JSON格式           |
| 请求共享链接 | POST http://$HOST/r/shortner/                      | POST http://$HOST/r/shortner/                                |                                                              |
| 响应短网址   | /superset/explore/?r=35&standalone=true&height=400 | http://$HOST/r/38                                            | /superset/explore/?                                          |
| 响应URL      | /superset/explore/?form_data=                      | POST /superset/dashboard/66/?standalone=true                 | POST /superset/explore_json/?form_data={"datasource":"3__table","slice_id":xx}&dashboard_id=xx |
| 响应结果     | HTML                                               | HTML                                                         | JSON                                                         |
| 权限验证方法 | has_access                                         | has_access                                                   | check_resource_permissions                                   |
| 权限验证说明 |                                                    |                                                              | check_datasource_perms只检查图表数据源是否存在， 不检验用户权限 |
| 处理流程     |                                                    | 查看当前用户拥有的edit/save/csv/explore等权限，渲染相应模板返回HTML。 |                                                              |

说明：共享时得到的URL是类似 r=xx，这个r通过表url 会重新指向一个真正的链接。r接口实现在 `/views/redirects.py`



**superset共享项设置**

1. 修改superset配置文件，修改公共用户是GAMMA角色。

superset/superset_config.py

```python
# 公共用户角色默认是GAMMA, 可读
PUBLIC_ROLE_LIKE_GAMMA=True

# 避免iframe跨站访问问题
HTTP_HEADERS: Dict[str, Any] = {"X-Frame-Options" : "SAMEORIGON" }
```

2. 给角色增加权限：
   * can explore on Superset 为导出图表
   * can explore json on Superset 为导出图表json
   * all database access on all_database_access  访问所有数据库权限，也可以设置单个

3. iframe嵌入：可在图表、看板页面得到 iframe链接。 或者 URL加上 `standalone=true`

4. 重定向URL：避免原始URL



#### 图表传参

图表链接：/superset/explore/?form_data={}

form_data传参： `"datasource":"3__table"`此字段值通过`__`可拆分成datasource_id和datasource_type。

form_data数据也是图表元数据，是JSON格式，将会保存在Slice表的params字段里。

form_data JSON串示例如下：

```json
{
	"viz_type": "funnel",
	"datasource": "241__table",
	"slice_id": 624,
	"url_params": {},
	"time_range_endpoints": [
		"inclusive",
		"exclusive"
	],
	"granularity_sqla": "创建时间",
	"time_range": "No+filter",
	"groupby": [
		"年",
		"区域",
		"日期"
	],
	"metric": {
		"aggregate": "SUM",
		"column": {
			"column_name": "挑战完成率",
			"description": null,
			"expression": "",
			"filterable": true,
			"groupby": true,
			"id": 4909,
			"is_dttm": false,
			"python_date_format": null,
			"type": "INTEGER",
			"type_generic": 0,
			"verbose_name": null
		},
		"expressionType": "SIMPLE",
		"hasCustomLabel": false,
		"isNew": false,
		"label": "SUM(挑战完成率)",
		"optionName": "metric_4djeudatc27_uiuijq5vj99",
		"sqlExpression": null
	},
	"adhoc_filters": [
		{
			"clause": "WHERE",
			"comparator": "大区",
			"expressionType": "SIMPLE",
			"filterOptionName": "filter_wzqe9z9g4yr_5y28zfiona",
			"isExtra": false,
			"isNew": false,
			"operator": "==",
			"operatorId": "EQUALS",
			"sqlExpression": null,
			"subject": "区域类型"
		},
		{
			"clause": "WHERE",
			"comparator": "季度",
			"expressionType": "SIMPLE",
			"filterOptionName": "filter_xxnn076ej7_mipv2cm64ks",
			"isExtra": false,
			"isNew": false,
			"operator": "==",
			"operatorId": "EQUALS",
			"sqlExpression": null,
			"subject": "日期类型"
		}
	],
	"emit_filter": false,
	"row_limit": 10,
	"sort_by_metric": true,
	"color_scheme": "supersetColors",
	"legendOrientation": "top",
	"number_format": "SMART_NUMBER",
	"show_labels": true,
	"extra_form_data": {}
}
```

说明：

* adhoc_filters  []，保存过滤条件列表，过滤条件之间是逻辑与关系
* metric 指标  {}，
* groupby 分组  [],  支持多个分组字段
* emit_filter  boolean，true-发出交叉过滤，false-默认不发出交叉过滤



#### 看板传参

**看板共享链接**

http://$HOST/superset/dashboard/191/?preselect_filters={"627":{"大区":null},"628":{"区域":null},"629":{"日期类型":["年"]},"630":{"日期":["2021"]}}&native_filters=('607':(extraFormData:(),filterState:(value:!n),id:'607',ownState:()),'680':(extraFormData:(),filterState:(value:!n),id:'680',ownState:()))&standalone=true

链接参数说明

* preselect_filters 预过滤器，指过滤框里过滤字段的预设值
* native_filters 原生过滤器，指图表的交叉过滤范围。指当前图表改变时，不受影响的图表。
* standalone 独立模式，true时去除导航菜单。



**看板数据**

看板数据包括三部分，保存在dashboards表的相应字段。

* postion_json: 看板布局的位置信息，JSON串。这个支持看板拖拽。
* css:  看板用的CSS主题，css语法。支持用户在系统提供主题基础上修改。如果要修改系统主题，则需要相应权限。
* json_metadata:  看板本身的元数据，JSON中。

json_metadata示例如下：

```json
{
  "show_native_filters": false,
  "chart_configuration": {  #图表配置项，设置交叉过滤范围
    "607": {
      "id": 607,
      "crossFilters": {"scope": {"rootPath": ["ROOT_ID"], "excluded": [607]}}
    },
    "609": {
      "id": 609,
      "crossFilters": {"scope": {"rootPath": ["ROOT_ID"], "excluded": [609]}}
    },
  },
  "timed_refresh_immune_slices": [],
  "filter_scopes": {	#过滤区域：指图表-过滤盒过滤项的范围scope 和 受影响图表immune
    "627": {"区域类型": {"scope": ["ROOT_ID"], "immune": []}},
    "628": {"区域": {"scope": ["ROOT_ID"], "immune": [480]}},
    "629": {"日期类型": {"scope": ["ROOT_ID"], "immune": []}},
    "630": {"日期": {"scope": ["ROOT_ID"], "immune": []}},
  },
  "expanded_slices": {},
  "refresh_frequency": 0,	#看板刷新频率
  "default_filters": "{ \"630\": {\"\\u65e5\\u671f\": [\"2021\"]} }",	#过滤器缺省值
  "color_scheme": null		#颜色主体
}
```

说明：

* chart_configuration  图表配置项，设置交叉过滤范围。
* filter_scopes  过滤映射，指定这滤字段影响到的图表和区域。
* default_filters 可设置某个过滤器的缺省值。对应到看板共享链接参数preselect_filters
* refresh_frequency 看板刷新频率，单位为





### 3.3.3 图表类型

#### 国家地图 Country Map

国家地图是一个国家行政区的地图，可以是中国，也可以是其它国家如法国等。

ISO3316为标准国家及城市代码，如 [ISO-3166-2:CN](https://en.wikipedia.org/wiki/ISO_3166-2:CN)为中国省份代码，(e.g. `CN-91` -> `CN-HK`)  已经支持用2个字母替代2个数字，但仍兼容数字。

各个国家地图的文件名为 xx.geojson

中国国家地图文件名： /static/assets/65d35076af8ab2eac6355ea6f4932f54.geojson

中国国家地图文件示例：

```json
{
	"type": "FeatureCollection",
	"crs": {
		"type": "name",
		"properties": {
			"name": "urn:ogc:def:crs:OGC:1.3:CRS84"
		}
	},
	"features": [
		{
			"type": "Feature",
			"properties": {
				"ISO": "CN-65",
				"NAME_1": "新疆"	# 修改此处
			},
			"geometry": {
				"type": "Polygon",
				"coordinates": [
					[[77.88313195800004,35.431068420000048],
                     ...
                    ]
                 ]
             }
		}
}
```



**更新地图**

@superset-ui/legacy-plugin-chart-country-map/scripts/Country Map GeoJSON Generator.ipynb

```bash
# 安装依赖，用jupyter打开 ipynb文件
$ pip install geopandas shapely
$ pip install jupyter notebook
$ jupyter notebook
```

**替换geojson文件（中国地图为例）**

* 法1（推荐）：superset-frontend依赖node_modules插件替换，superset-frontend打包时会自动更新。 位置在 `@superset-ui/legacy-plugin-chart-country-map/xx/countryies/china.geojson`   xx分别为lib和esm
* 法2：插件源码替换，需要打包@superset-ui，然后更新node_modules的输出（可以搞软链接）。位置在` superset-ui.git/plugins/legacy-plugin-chart-country-map/src/countries/china.geojson`
* 法3：superset-frontend打包文件替换。位置在 `superset/static/assets/65d35076af8ab2eac6355ea6f4932f54.geojson`

说明：不需要修改superset-ui项目源码情况下，推荐法1更换geojson文件。



#### 世界地图 World Map

Country codes supported are numeric (ccn; internal reference format), **two letter country codes (cca2), and three letter country codes (cca3)**. In addition, incf.countryutils knows the simple English name of each country (cn) as well as the official English name.

国家编码(Country codes, cc)支持以下四种类型，

* ccn:  国家编码数值
* cca2: 国家编码2个字母
* cca3: 国家编码3个字母
* name:  使用英文简称，如cn是中国。



## 3.4 复杂定制化

表格 复杂定制化的修改项

| 修改项       | 前端修改react  /superset-frondend/                           | 后端修改python  /superset/                                   | 备注                   |
| ------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ---------------------- |
| 新增图表类型 | /src/visualizations/xx/ 可参照FilterBox目录结构              | viz.py 添加新图表类型的类：<br>`class xx(BaseViz):`          | 参见 新增图表类型 章节 |
| 新增数据源   |                                                              |                                                              | 参见  新增数据源 章节  |
| 新增导航菜单 | webpack.config.js 增加入口entry xx<br>/src/xx/ 可参照dashboard目录结构<BR>/src/views/App.tsx 增加新菜单路由映射组件 | app.py增加add_link/add_view 新菜单<br>/views/core.py Superset类里增加新路由函数 或者 新增一个视图类 |                        |
| 下钻         |                                                              |                                                              |                        |

说明：上面表格中出现的xx表示要修改的内容。集成eCharts属于新增图表类型范围。



### 新增图表类型

- [Building Custom Viz Plugins](https://superset.apache.org/docs/installation/building-custom-viz-plugins)
- [Managing and Deploying Custom Viz Plugins](https://medium.com/nmc-techblog/apache-superset-manage-custom-viz-plugins-in-production-9fde1a708e55)



未实现的图表如：同比、环比

https://github.com/airbnb/superset/pull/3013

https://github.com/airbnb/superset/issues?q=label%3Aexample+is%3Aclosed



示例: New viz~treemap https://github.com/apache/incubator-superset/pull/344

参见  Apache Superset集成Echarts https://blog.csdn.net/tancongcong/article/details/91991051?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-2.nonecase&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-2.nonecase



### 新增数据源

原理：SQLAlchemy，ORM模式。

参考 增加自定义数据源 https://zhuanlan.zhihu.com/p/179162221



### 数据钻取 drilldown

参见

* Superset 表格下钻(基于时间维度,地域维度和普通维度) https://blog.csdn.net/tb77506668/article/details/107717258
* Superset 0.28三奏曲——安装、集成ECharts和汉化（包括中国地图下钻） https://blog.csdn.net/qq_33703137/article/details/87874277?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-2.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-2.control

* feat: Draft drilldown POC #14688 https://github.com/apache/superset/pull/14688   (版本/组件依赖不确定，并入master遥遥无期)



数据钻取实现是要保存钻取的层次关系。

数据钻取常见需求：表格 和 地图。这二类图形可以展现比较明显的层次关系，层次关系如行政区域，组织结构或者时间层次等。此外一些用于表示整体和部分的图形如树图也很适合钻取。



### 根路由定制（改动复杂）

根路由定制，是指给superset的API服务提供一个相同路由前缀，便以nginx路由转发。如 /datav/xx/

superset路由涉及主要分二部分：

* fab后台管理：后台管理包括安全权限这块完全由flask_appbuilder来单独实现，因此这块路由都要在 flask_appbuiulder模块修改。

* superset本身功能：区分HTML页面和RestAPI，相应修改。

修改项：修改flask_appbuilder的各种view的route_base，以及superset JS里链接跳转的硬编码部分。

```shell
# 1.flask_appbuilder
/flask_appbuilder/
    modified:  babel/views.py
    modified:  baseviews.py
    modified:  const.py
    modified:  security/views.py
    modified:  views.py

# 2.superset
/superset/app.py		# 修改首页路由
/superset/views/xx.py	# 修改各视图类的route_base
```



## 3.5 前后端分离（实验性）

目前前端响应慢的一个原因是每次请求要传输大量相同的启动数据；二是很多模板是模板页生成的HTML，需要重复请求数据。针对上面二种情况，可以如下解决：

1. 前后端数据解耦：重复的数据前端只需服务取一次，后面从缓存中获取（后端可以设置缓存）。或者将数据直接保存在前端。
2. 相同模板页复用：如果HTML结构用的模板页一样，可以启用本地缓存数据，尽可能用SAP实现。



**启动数据data-bootstrap**

前后端耦合主要是启动数据data-bootstrap。

服务端生成启动数据data-bootstrap，数据内容包括导航菜单、语言包、用户信息、特征标识、环境和其它数据。

* 导航菜单：导航菜单由flask-appbuilder实现，菜单和菜单视图函数的绑定。菜单数据提供给前端，前端通过菜单数据（后端）+样式（前端）得到导航菜单的完整布局。此处将来可以解耦部分是菜单数据在前端提供，后端只负责实现菜单视图API。
* 语言包：语言包数据有前端也有后端。但最终展现是在前端。因此语言包完全可以放到前端。可以根据后端传输语言标识来启用相应语言包。
* 特征标识：这个标识前后端都有用到，可以共同维护一份。用相同标识，维护同样功能涉及到的前后端。
* 用户信息：其实登陆时就有了用户数据，无需重复获取。



## 3.6 Websock支持

WebSocket可以让服务器端主动向客户端推送数据。

在WebSocket API中，客户端和服务器只需要完成一次握手，两者之间就直接可以创建持久性的连接，并进行双向数据传输。

WebSocket 主要用于刷新 token、用户被踢出、平台消息、内存和 CPU 显示、平台日志处当前系统在线人数、数据连接编辑状态的确定。



依赖条件

- Node.js 12+ (not tested with older versions)
- Redis 5+
- 需要打开特性 GLOBAL_ASYNC_QUERIES

架构实现基于 [SIP-39](https://github.com/apache/superset/issues/9190).

![img](../../media/ai/dv_superset_007.png)



# 4 运维篇

## 4.1  安全管理

### RBAC机制

superset的权限管理是通过flask_appbuilder模块的权限管理实现的，是RBAC机制(Role-Based Access Control, 基于角色的访问控制)。

用户通过角色关联到 若干权限，权限为视图项权限（每个权限可以由二部分组成：视图项，视图项的某个权限如can_read）。

* 权限表 permission：规定若干基本权限如读/写/列表/删除/...,
* 视图项 view：页面上每一个要控制权限的项都可以作为一个视图项如数据源页，看板页，图表页甚至数据源某列等等。



表格 权限管理的数据表说明

| 表名                    | 权限说明           | 字段                                | 权限详述                                                     |
| ----------------------- | ------------------ | ----------------------------------- | ------------------------------------------------------------ |
| ab_role                 | 角色               | id, name(uni)                       | 一个角色映射到访问权限，一个用户可以是多个角色，一个角色也可以有多个用户。<br>6个预创建角色分别是Admin, Alpha, Gramma, granter, Public, sql_lab。 |
| ab_premission           | 权限               | id, name(uni)                       | 如can list/can del, menu_access等。共85个                    |
| ab_view_menu            | 被管对象           | id, name(uni)                       | 菜单、视图、数据源，数据集，看板，图板等等。<br>示例数据集：[database_name].(id:dbs_id), `[database_name].[table_name](id:tables_id)`, [database_name].[schema], |
| ab_permission_view      | 权限-视图关联      | id, permission_id, view_menu_id     | 建立permission表和view_menu表的关联，多对多关系。            |
| ab_permission_view_role | 角色-权限视图关联  | id, permission_view_id, <br>role_id | 角色对应的视图权限。<br>permission_view_id和role_id二个外键分别对应到ab_permission_view表和ab_role表的主键。 |
| ab_user_role            | user和role关联     | id, user_id, role_id                | 建立user表和role表的关联，多对多关系                         |
| ab_user                 |                    | id, username(uni)...                | 包括用户基本信息，包括用户名/密码等。                        |
| ab_register             | 用户注册时基本信息 | id, ...                             | 如果不允许用户自注册，此表则不用。                           |

备注：权限和被管对象通过表`ab_permission_view`关联起来。表字段id为自增主键，字段名后有(uni)表示是唯一键。



表格 ab_view_menu表里name字段的组成

| 资源类型          | name字段格式&说明                                            | 示例                                        |
| ----------------- | ------------------------------------------------------------ | ------------------------------------------- |
| druid数据源       | `[{cluster_name}].(id:{id})`                                 | 略                                          |
| 数据库            | `[database_name].(id:dbs_id)`                                | [database_test].(id:2)                      |
| 数据集            | `[database_name].[table_name](id:tables_id)`  同tables表里的perm字段值 | `[examples].[考勤数据汇总](id:13)`          |
| schema            | [database_name].[schema]   同tables表里的schema_perm字段值   | [examples].[dmap]                           |
| 菜单&视图&API视图 | 字符串，同页面显示                                           | “List Users”  "MenuApi" "ResetPasswordView" |

说明：看板/图表的读权限由数据集决定，不由ab_view_menu表控制；其修改权限由owner决定，由相应的slice_user, dashboard_user表控制。

> 上面database_name从Database.name获取，Database.name取值逻辑是先从verbose_name取，后从database_name取。



表格 资源数据库、数据集、图表、看板的名称说明

| 资源   | 表名       | 显示名字段      | 别名字段     | 描述字段    | 说明                                                         |
| ------ | ---------- | --------------- | ------------ | ----------- | ------------------------------------------------------------ |
| 数据库 | dbs        | database_name   | verbose_name | description | 二个名称都是全局唯一的。database_name可重命名，verbose_name缺省为空。<br>数据库真实名称包括在字段sqlalchemy_uri。sqlalchemy_url没要求唯一，也就是同一个sqlalchemy_url可以生成多个不一样的数据源名称。 |
| 数据集 | tables     | table_name      | extra        | description | table_name是真实表名（不可更改）。<br>extra字段类型是json，可保存别名（可更改），示例extra={"table_alias":"xx"}。 |
| 图表   | slices     | slice_name      | 无           | description | 名称需自行在验证逻辑里加判断，如是否用户内唯一。             |
| 看板   | dashboards | dashboard_title | 无           | description | 名称需自行在验证逻辑里加判断，如是否用户内唯一。             |

说明：description字段类型为text，用来描述资源，不唯一，一般也不重要。Database.name取值逻辑是先从verbose_name取，后从database_name取。

**数据库/集重命名影响**

1. 如果数据库重命名了，那么此数据库及此库关联表和shema都要重命名视图名（涉及元数据表ab_view_menu的name字段, tables的perm字段），否则find_view_menu(view_menu_name)时找不到相应view_id。但由于重命名操作只增加权限视图，不删旧视图的做法，不会更改旧的权限，只是造成了数据冗余 。
2. 如果数据集重命名了，因为只是用来显示的别名，因此更改没有影响 。

**数据库/集删除影响**

1. 删除数据库前，需要确保没有关联的数据集（已实现）。
2. 删除数据集前，需要确保没有关联的图表（已实现提示）。数据集删除，所对应的perm里的id字段为Null。



### 权限管理

权限管理：权限项有287+项，可分为两大类分别是基本权限 和 视图列表的操作权限。

表格 5 权限管理的角色说明（预设角色）

| 角色    | 权限说明                                                     | 权限项举例...                                                |
| ------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Admin   | 管理员拥有所有可能的权利，包括授予或撤销其他用户的权限，以及更改其他人的切片和仪表板。 | `menu access on List Roles`, `menu access on List Users`, `menu access on Security`, `can list on RoleModelView`, <br>`all database access on all_database_access`   ... |
| Alpha   | Alpha可以访问所有数据源，但无法授予或撤销其他用户的访问权限。 它们也限于改变他们拥有的对象。 Alpha用户可以添加和更改数据源。 | `all database access on all_database_access`  <br>...        |
| Gamma   | 访问有限。他们只能使用他们通过另一个补充角色访问的数据源中的数据。相当于内容消费方。 | `menu access on Charts`, `menu access on Dashboards`, <br>`database access on [mysql2].(id:10)`，  <br/>` datasource access on [superset_test].[covid-19](id:37)` |
| public  | 用户必须的信息。如个人密码修改。                             | `can read on Chart`, `can read on Dashboard`                 |
| grant   | 一般2个权限，分别是覆盖角色权限和推准权限。                  | `Can override role permission on Superset`, `Can approve on Superset` |
| sql_lab | sql lab访问和操作权限。                                      | ` [can list on UserDBModelView, can csv on Superset, can search queries on Superset, can sqllab viz on Superset, can sqllab table viz on Superset, can sqllab on Superset, can sql json on Superset, menu access on SQL Lab, menu access on SQL Editor, menu access on Saved Queries, menu access on Query Search]` |

备注：superset的权限控制通过用户所拥有的角色的权限合集来控制。`superset init`将会初始化权限和角色，会覆盖替换缺省角色的权限。所以不要直接改这三个角色的权限：Admin/Alpha/Gamma，若有需要，可基于这些角色复制出新角色再修改。
1. 数据源/库：数据库并无属主字段。但添加数据库需要有权限`can write on database`；修改数据库则要密码正确；删除数据库前会检查是否有数据集绑定，若有则无法删除。
2. 数据集/表
   - 读：数据表的读权限可以单独设置，并不需要其上数据库的读权限。读权限类似`dataset access on xx`。
   - 数据集（表）的属主owners缺省可以完全操作（读+写+删）此数据源的图表和看板。
   - Alpha角色可以读取所有数据源和dashboard，但不能修改。
   - Gamma只能看到数据库，数据表和dashboard都是缺省为空。可以以Gamma作为新角色基础，添加特定数据集的访问权限。来实现数据共享和隔离。
3. 图表/看板的读写权限：图表/看板都有一个owner列表。
   - 读权限：取决于是否有图表所用的数据集访问权限（最近粒度）。即使没有数据集所在数据库访问权限也可以。
   - 写权根：owner能修改，创建者缺省是owner。
4. 行级权限 Row Level：只有管理员才可以操作。



表格 特殊权限项说明

| 权限项                                                       | 应用场景                                                     | 说明                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ | -------------------------------------------------------- |
| `can save on datasource`                                     | 数据源编辑时需要此权限，同时还需是数据源的owner              | 应用到接口 /datasource/save/                             |
| `all database access on all_database_access`                 | 可以访问所有数据库，适用于演示用户                           | 给Alpha角色用，可读。                                    |
| `can write on database`, `can write on datasource`           | 可以创建数据源/数据源，适用于创建用户级的私有源              | 删除数据库需要没有绑定数据集；<br>删改数据集需要owners。 |
| `database access on [xdDB].(id:10)`，  <br/>` datasource access on [xdDB].[xxTABLE](id:37)` | 用户创建的数据源/数据集默认自己用。<br>若别人要用又没有特权角色，需要将此权限添加到特定角色，给用户分配此角色。 | 具体的数据库、数据集访问权限示例                         |



### 安全认证

细粒度高可扩展性的安全访问模型，支持主要的认证供应商（数据库、OpenID、LDAP、OAuth 等）。

How can i configure OAuth authentication and authorization?

You can take a look at this Flask-AppBuilder [configuration example](https://github.com/dpgaspar/Flask-AppBuilder/blob/master/examples/oauth/config.py).

https://raw.githubusercontent.com/dpgaspar/Flask-AppBuilder/master/examples/oauth/config.py
```SHELL
from flask_appbuilder.security.manager import AUTH_DB, AUTH_LDAP
#----------------------------------------------------
# AUTHENTICATION CONFIG
#----------------------------------------------------
# The authentication type
# AUTH_OID : Is for OpenID
# AUTH_DB : Is for database (username/password()
# AUTH_LDAP : Is for LDAP
# AUTH_REMOTE_USER : Is for using REMOTE_USER from web server
AUTH_TYPE = AUTH_OAUTH
```



LDAP认证

```python
AUTH_TYPE = AUTH_LDAP
AUTH_LDAP_SERVER = "ldap://ldapserver.new"
AUTH_LDAP_SEARCH="dc=mycompany,dc=com" #己方LDAP服务器的根路径
AUTH_LDAP_USERNAME_FORMAT = "cn=%s,OU=Users,DC=mycompany,DC=com"
```

AUTH_LDAP_USERNAME_FORMAT:  flask会把你输入的用户名替换进去，得到一个完整的DN，比如输入用户名是admin，那么flask就会在LDAP中寻找"cn=admin,OU=Users,DC=mycompany,DC=com"，然后匹配密码，没有这个是不可能找到用户的。除非LDAP服务器允许匿名查找。



## 4.2  配置文件

**配置文件的优先级**:  xx/superset_config.py >  superset/config.py (即superset.config)

**环境变量**： os.environ

* PYTHONPATH  python模块搜索路径，如果部署包不在虚拟环境的site-packages下，那么应该设置此值。用flask run启动会自动搜索当前路径是否有app，如果当前目录内能搜索到，则可避免设置此值。
* SUPERSET_HOME    元数据文件和日志文件目录，影响到变量DATA_DIR
* SUPERSET_CONFIG_PATH   superset用户自定义配置文件路径（文件名可以命名为superset_config.py，文件路径可以自定义，无需放在superset目录），此路径会赋值给CONFIG_PATH_ENV_VAR。此配置文件要生效，需要显式设置此环境变量。
* SUPERSET_CONFIG  superset配置文件路径，缺省为superset.config (即superset/config.py)
* FLASK_ENV  设置是否调试 development/production，缺省development是debug模式  （用FLASK_开头的变量通常是flask模块内置支持的环境变量，如FLASK_APP，FLASK_ENV，FLASK_DEBUG）。
* MAPBOX_API_KEY  是否支持MAPBOX可视化，缺省False



**/superset/config.py**  （一般不修改这个文件，文件行数约1000多行，去除注释和空格约400行）

**一般会修改的配置项（内部用，不外嵌）**

* APP_NAME
* 元数据库连接URI：SQLALCHEMY_DATABASE_URI
* 区域/语言：BABEL_DEFAULT_LOCALE  LANGUAGES
* 日志：ENABLE_TIME_ROTATE  TIME_ROTATE_LOG_LEVEL  FILENAME  LOG_FORMAT  LOG_LEVEL
* 用户注册：AUTH_USER_REGISTRATION  AUTH_USER_REGISTRATION_ROLE
* 安全：SECRET_KEY

**其它配置项：**

* 目录：BASE_DIR  DATA_DIR
* 静态文件：VERSION_INFO_FILE  PACKAGE_JSON_FILE  FAVICONS  APP_ICON
* WEB服务器配置：SUPERSET_WEBSERVER_TIMEOUT  SUPERSET_WEBSERVER_PORT  SUPERSET_WEBSERVER_PROTOCOL  SUPERSET_WEBSERVER_ADDRESS
* 调试参数：DEBUG  FLASK_USE_RELOAD  SHOW_STACKTRACE
* CSRF配置：WTF_CSRF_ENABLED WTF_CSRF_EXEMPT_LIST  WTF_CSRF_TIME_LIMIT
* CORS配置：ENABLE_CORS  CORS_OPTIONS  SUPERSET_WEBSERVER_DOMAINS  HTTP_HEADERS
* 查询参数：ROW_LIMIT  VIZ_ROW_LIMIT  SAMPLES_ROW_LIMIT  FILTER_SELECT_ROW_LIMIT  QUERY_SEARCH_LIMIT  SQL_MAX_ROW  DISPLAY_MAX_ROW
* SQLLAB查询参数：DEFAULT_SQLLAB_LIMIT  MAX_TABLE_NAMES  SQLLAB_TIMEOUT  SQLLAB_VALIDATION_TIMEOUT  SQLLAB_DEFAULT_DBID  SQLLAB_ASYNC_TIME_LIMIT_SEC  SQLLAB_QUERY_COST_ESTIMATE_TIMEOUT   SQLLAB_CTAS_NO_LIMIT
* DRUID：DRUID_TZ  DRUID_ANALYSIS_TYPES  DRUID_IS_ACTIVE  DRUID_METADATA_LINKS_ENABLED  DRUID_DATA_SOURCE_DENYLIST
* 认证参数：AUTH_TYPE（支持AUTH_OID、AUTH_DB、AUTH_LDAP、AUTH_REMOTE_USER），AUTH_ROLE_ADMIN  AUTH_ROLE_PUBLIC    ROBOT_PERMISSION_ROLES
* 特性标识：DEFAULT_FEATURE_FLAGS  FEATURE_FLAGS
* 缓存：CACHE_DEFAULT_TIMEOUT  CACHE_CONFIG  DATA_CACHE_CONFIG   STORE_CACHE_KEYS_IN_METADATA_DB
* 上传/导入/导出：UPLOAD_FOLDER  IMG_UPLOAD_FOLDER  ALLOWED_EXTENSIONS  CSV_EXPORT   CSV_TO_HIVE_UPLOAD_S3_BUCKET  CSV_TO_HIVE_UPLOAD_DIRECTORY
* 其它：CELERY_CONFIG   ENABLE_ALERTS  EMAIL_ASYNC_TIME_LIMIT_SEC  WEBDRIVER_TYPE  FAB_API_SWAGGER_UI

```python
from flask import Blueprint
from flask_appbuilder.security.manager import AUTH_DB

SUPERSET_LOG_VIEW = True

BASE_DIR = os.path.abspath(os.path.dirname(__file__))
if "SUPERSET_HOME" in os.environ:
    DATA_DIR = os.environ["SUPERSET_HOME"]
else:
    DATA_DIR = os.path.join(os.path.expanduser("~"), ".superset")

# ---------------------------------------------------------
# Superset specific config: static文件、SQL参数设置
# ---------------------------------------------------------
VERSION_INFO_FILE = os.path.join(BASE_DIR, "static", "version_info.json")
PACKAGE_JSON_FILE = os.path.join(BASE_DIR, "static", "assets", "package.json")

VERSION_STRING = _try_json_readversion(VERSION_INFO_FILE) or _try_json_readversion(
    PACKAGE_JSON_FILE
)

VERSION_SHA_LENGTH = 8
VERSION_SHA = _try_json_readsha(VERSION_INFO_FILE, VERSION_SHA_LENGTH)

ROW_LIMIT = 50000
VIZ_ROW_LIMIT = 10000
# max rows retreieved when requesting samples from datasource in explore view
SAMPLES_ROW_LIMIT = 1000
# max rows retrieved by filter select auto complete
FILTER_SELECT_ROW_LIMIT = 10000
SUPERSET_WORKERS = 2  # deprecated
SUPERSET_CELERY_WORKERS = 32  # deprecated

SUPERSET_WEBSERVER_PROTOCOL = "http"
SUPERSET_WEBSERVER_ADDRESS = "0.0.0.0"
SUPERSET_WEBSERVER_PORT = 8088

# This is an important setting, and should be lower than your
# [load balancer / proxy / envoy / kong / ...] timeout settings.
# You should also make sure to configure your WSGI server
# (gunicorn, nginx, apache, ...) timeout setting to be <= to this setting
SUPERSET_WEBSERVER_TIMEOUT = 60

# Your App secret key: 用于数据库表字段加密：如DB密码、服务器证书、服务器扩展数据
SECRET_KEY = "\2\1thisismyscretkey\1\2\\e\\y\\y\\h"

# The SQLAlchemy connection string. 缺省元数据库
SQLALCHEMY_DATABASE_URI = "sqlite:///" + os.path.join(DATA_DIR, "superset.db")
# SQLALCHEMY_DATABASE_URI = 'mysql://myapp@localhost/myapp'

# Whether to run the web server in debug mode or not
DEBUG = os.environ.get("FLASK_ENV") == "development"
FLASK_USE_RELOAD = True

CONFIG_PATH_ENV_VAR = "SUPERSET_CONFIG_PATH"

# ----------------------------------------------------
# AUTHENTICATION CONFIG 认证配置，缺省用 DB认证， 详见 安全认证章节
# ----------------------------------------------------
# The authentication type
# AUTH_OID : Is for OpenID
# AUTH_DB : Is for database (username/password)
# AUTH_LDAP : Is for LDAP
# AUTH_REMOTE_USER : Is for using REMOTE_USER from web server
AUTH_TYPE = AUTH_DB

# 特性标识开关字典：用来服务端 开发新特性需要
# 可调用is_feature_enabled，如is_feature_enabled('KV_STORE')，会加载DEFAULT_FEATURE_FLAGS，FEATURE_FLAGS
DEFAULT_FEATURE_FLAGS: Dict[str, bool] = { }

# 自定义安全管理类，可以 用来重载实现 个性化用户认证
CUSTOM_SECURITY_MANAGER = None
```



 /superset/superset_config.py

用户个性化部分修改示例：

 ```python
from dateutil import tz

APP_NAME = "DataLab"

# The SQLAlchemy connection string.
SQLALCHEMY_DATABASE_URI = 'mysql://root:xxxxxx@127.0.0.1/superset_1.0'


# Setup default language  中文
BABEL_DEFAULT_LOCALE = "zh"
LANGUAGES = {"zh": {"flag": "cn", "name": "Chinese"}}

# LOG
ENABLE_TIME_ROTATE = True
TIME_ROTATE_LOG_LEVEL = "DEBUG"

# CSRF设置：WTF_CSRF_ENABLED WTF_CSRF_EXEMPT_LIST
# Flask-WTF flag for CSRF
WTF_CSRF_ENABLED = False
ENABLE_CORS = True
# CORS_OPTIONS: Dict[Any, Any] = {"supports_credentials": True}
# Add endpoints that need to be exempt from CSRF protection 需要CSRF免除的API
WTF_CSRF_EXEMPT_LIST = ["superset.views.core.log", "superset.charts.api.data",
                        "superset.views.core.explore_json"]


# Will allow user self registration 是否允许用户注册
AUTH_USER_REGISTRATION = True

# The default user self registration role 用户注册后缺省角色
AUTH_USER_REGISTRATION_ROLE = "Gamma"

# 页面嵌入配置: PUBLIC_ROLE_LIKE_GAMMA、HTTP_HEADERS
# 公共用户角色默认是GAMMA, 可读。 v0.38起PUBLIC_ROLE_LIKE替换PUBLIC_ROLE_LIKE_GAMMA
PUBLIC_ROLE_LIKE=True
# 避免iframe跨站访问问题
HTTP_HEADERS: Dict[str, Any] = {"X-Frame-Options" : "SAMEORIGON" }
 ```



## 4.3 性能优化

### 缓存 flask-cache

superset使用Flask-Cache来缓存数据。Flask-Caching supports various caching backends, including Redis, Memcached, SimpleCache (in-memory), or the local filesystem.  参见  https://superset.apache.org/docs/installation/cache

- Memcached: we recommend using [pylibmc](https://pypi.org/project/pylibmc/) client library as `python-memcached` does not handle storing binary data correctly.
- Redis: we recommend the [redis](https://pypi.python.org/pypi/redis) Python package

修改文件：superset/superset_config.py

 ```python
from superset.typing import CacheConfig

# cache1: 缓存图表SQL查询结果-pandas数组
DATA_CACHE_CONFIG = {
    'CACHE_TYPE': 'redis',
    'CACHE_DEFAULT_TIMEOUT': 60 * 60 * 24, # 1 day default (in secs)
    'CACHE_KEY_PREFIX': 'superset_results',
    'CACHE_REDIS_URL': 'redis://localhost:6379/0',
}
# cache2: 缓存superset本身元数据, simple-内存; filesystem-本地文件,CACHE_DIR默认为当前目录,CACHE_THRESHOLD过期时间（单位为毫秒）
CACHE_CONFIG: CacheConfig = {"CACHE_TYPE": "filesystem"}
# cache3: 缩略图缓存，要开启FEATURE_FLAGS里的 THUMBNAILS
THUMBNAIL_CACHE_CONFIG: CacheConfig = {"CACHE_TYPE": "simple", "CACHE_NO_NULL_WARNING": True}

# superset-0.2x+（弃）
TABLE_NAMES_CACHE_CONFIG: CacheConfig = {"CACHE_TYPE": "simple"}

# 缓存缩略图 Caching Thumbnails, 缩略图用在看板/图表列表显示的缩略图（实际上没什么意义）
FEATURE_FLAGS = {
    "THUMBNAILS": True,
    "THUMBNAILS_SQLA_LISTENERS": True,
}
 ```



### WEB服务器

**A proper WSGI HTTP Server**

WSGI是Web Server Gateway Interface的缩写。以层的角度来看，WSGI所在层的位置低于CGI。但与CGI不同的是WSGI具有很强的伸缩性且能运行于多线程或多进程的环境下，这是因为WSGI只是一份标准并没有定义如何去实现。WSGI介于WEB框架和WEB服务器之间。

WSGI 没有官方的实现, 因为WSGI更像一个协议. 只要遵照这些协议,WSGI应用(Application)都可以在任何服务器(Server)上运行, 反之亦然。

WSGI标准在 PEP 333中定义并被许多框架实现，其中包括现广泛使用的django框架。



**gunicorn**

说明：gunicorn只能用于linux环境（使用了fcntl等模块），在windows下无法使用。

While you can setup Superset to run on Nginx or Apache, many use Gunicorn, preferably in **async mode**, which allows for impressive concurrency even and is fairly easy to install and configure. Please refer to the documentation of your preferred technology to set up this Flask WSGI application in a way that works well in your environment.

While the superset runserver command act as an quick wrapper around gunicorn, it doesn’t expose all the options you may need, so you’ll want to craft your own gunicorn command in your production environment. Here’s an **async** setup known to work well:

```SHELL
gunicorn \
    -w 10 \
    -k gevent \
    --timeout 120 \
    -b  0.0.0.0:6666 \
    --limit-request-line 0 \
    --limit-request-field_size 0 \
    --statsd-host localhost:8125 \
    superset:app

说明：-w为工作进程数；-k为通信方式，缺省为同步，可改为gevent；-b为监听端口。
```



### 元数据替换

元数据缺省存储是SQLite，存放在~/.superset/superset.db。

当数据量大时，可用MySQL或Postgresql替代。

只需替换配置文件。

修改文件：superset/config.py

```SHELL
# The SQLAlchemy connection string.
SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(basedir, 'app.db')
#SQLALCHEMY_DATABASE_URI = 'mysql://myapp@localhost/myapp'
#SQLALCHEMY_DATABASE_URI = 'postgresql://root:password@localhost/myapp'
```



**数据迁移**

主要关系到数据源、看板和用户权限三个方面，如下：

*  数据源：包括数据库和数据表。可用终端的数据源导入导出命令 import_datasources、export_datasources，文件格式为yaml
*  看板：可直接在前端页面导入导出，文件格式为JSON。
*  用户权限：暂未发现导入导出项，迁移后需重设用户和角色。



**页面删除操作注意事项**

*  删除数据库会同时删除表，删除表不会影响到数据库。数据源删除后，看板和图板所关联的数据源将指向为None.
*  删除图表会影响到看板，删除看板不会影响到图表。





# 5 架构篇

本章架构篇的分析方法采用了TOGAF和UML视图法。

其中使用了TOGAF的IT架构，UML的四大视图法。

架构工具：Enterprise Architect

## 5.1 IT架构

在TOGAF体系中，IT架构包括了应用架构、数据架构和技术架构。



## 5.2  UML视图

### 5.2.1 部署视图

 略



### 5.2.2 开发视图（组件）

​               ![image-20191201170208395](../../media/ai/dv_superset_001.png)



### 5.2.3 逻辑视图

主要是UML中的主要开发期和运行期视图。

包括类图、活动图等。



## 5.3  数据架构（数据模型）

表格 superset元数据的来源模块说明

| 模块                   | 次模块或命令                 | *说明*                                                       |
| ---------------------- | ---------------------------- | ------------------------------------------------------------ |
| Flask  Appbuilder(fab) | `superset fab create-admin`  | 创建角色和管理员用户。1.x用superset fab替换fabmanger。<br>共创建8张表，以ab_开头。  user  -> role -> premission_view-> (permission, view_menu) |
| superset meta          | `superset db upgrade`        | 数据库初始化（版本更新时也要执行此命令）。<br>共创建24张表。v1.x增加到47张表。 |
|                        | datasources:  druid/database | 共8张。数据源包括两种组织形式：druid 和 database  <br>druid:  cluster - datasources - columns/metrics  <br>database：dbs - tables -  tablecolumn/sql_metrics |
|                        | views:  slice/dashboard      | 共7张。<br>slice：slices slice_user  slice_dashboard <br>dashboard:  dashboard dashboard_user |
|                        | css/template                 | css_templates annotation annotation_layer                    |
|                        | sql                          | query  saved_query sql_observations sqltable_user            |
|                        | report/alert                 | report_execute_log report_recipient report_schedule report_schedule_user alert_logs alert_owner alerts |
|                        | other                        | KV,  url(短网址）  favstar logs                              |
|                        | 1.x新增表01                  | access_request user_attribute  dashboard_email_schedules <br>slice_email_schedules tab_state tagged_object |
|                        | 1.x新增表02                  | dynamic_plugin rls_filter_roles rls_filter_tables row_level_security_filters |
| CSV文件                |                              | 每个CSV文件会转成元数据库里的一张表。  database为main        |
| load-exampels          | superset load-examples       | 样例数据集会生成很多张表，大概是17张表。最好是加载样例到另外一个数据库。 |

备注：

1. fab通过给role授权数据源(view_menu)和权项限(persionn)访问权限来控制可访问的view，粒度从数据源级别到数据源内的list/add/show/del/edit权限。
2. 通过修改视图的Owner来管理修改权限。
3. superset_meta通过ab_role来关联fab的安全管理功能。
4. 创建数据集时，不管物理表还是虚表都会将数据集元数据写入到三张表，分别是tables(表元数据）、tablecolumn（表列）、sql_metrics（指针，一般默认有count(* )）。



### 5.3.1 fabmanger 权限管理

fab: flask_appbuild

 ![image-20191201170256358](../../media/ai/dv_superset_002.png)



### 5.3.2 superset meta

**1）SQL_ALL**

 ![image-20191201170320110](../../media/ai/dv_superset_003.png)



**2）datasources**

![image-20191201170339236](../../media/ai/dv_superset_004.png)



3) slice/dashboard

 ![image-20191201170353037](../../media/ai/dv_superset_005.png)



4) other

 ![image-20191201170410559](../../media/ai/dv_superset_006.png)






# FAQ 常见问题

## 安装常见问题

备注：安装Oracle/MySQL/SQLite报错，详见 《[Python开发](Python开发.md)》FAQ章节。

**Q1： windows/linux环境安装报错模块 python-geohash   **

报错信息：

```shell
Building wheel for python-geohash (setup.py) ... error...

building '_geohash' extension
error: Microsoft Visual C++ 14.0 or greater is required. Get it with "Microsof
C++ Build Tools": https://visualstudio.microsoft.com/visual-cpp-build-tools/
ERROR: Failed building wheel for python-geohash
```

原因：python-geohash安装依赖于c++编译工具。

解决方法1：直接下载相应的wml包安装，https://www.lfd.uci.edu/~gohlke/pythonlibs/#python-geohash

解决方法2： windows下安装vc++14.0+，linux下安装 python3-devel 或者 gcc-c++



**Q2: Linux环境安装报错： command '[gcc](https://www.laozuo.org/tag/gcc)' failed with exit status 1**

报错信息： command '[gcc](https://www.laozuo.org/tag/gcc)' failed with exit status 1

原因：缺少各种开发库如openssl-devel

解决方法：

```shell
$ yum install gcc libffi-devel python3-devel openssl-devel -y
```



**Q3：华为麒麟操作系统上运行报错**

报错信息：[jemalloc] unsupported system page size

原因：可用`getconf PAGESIZE`查看页大小。要在64K环境编译，才能兼容4K和16K的。

解决方法：重新在64位机上编译安装。另外更新报错模块要么用低版本（如pyrsistent），要么用最新版本（如pyarrow）

```shell
$ pip install pyarrow==6.0.1	  #原依赖要求pyarrow>=4.0.1, <4.1, 但会导致jemalloc错误，实需升级到最新的6.0.1版本。
$ pip install pyrsistent==0.14.0  #原依赖要求 pyrsistent>=0.14.0，最新版本0.18.0无法安装，指定版本安装
```





## 开发常见问题

表格  superset一般问题列表

| 问题                                                         | 解决方法                                                     | 备注           |
| ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| superset元数据的日志时间缺省为UTC，需更改为本地时间~东八区UTC8 | 修改 core/model/core.py  dttm=Column(DateTime,  default=datetime.now) | 将ucnow改为now |
| ...                                                          |                                                              |                |



**API调试技巧**

示例：要调用 /users/delete

可用 flask routes查看路由及其对应的路由视图。然后就可用 路由视图查找定位API位置。

```shell
$ flask routes
SliceModelView.add                                GET, POST  /chart/add
SliceModelView.api_delete                         DELETE     /chart/api/delete/<pk>
SliceModelView.api_read                           GET        /chart/api/read
SqlMetricInlineView.list                          GET, POST  /sqlmetricinlineview/list/
Superset.add_slices                               POST       /superset/add_slices/<int:dashboard_id>/
Superset.annotation_json                          GET        /superset/annotation_json/<int:layer_id>
Superset.approve                                  GET        /superset/approve
Superset.available_domains                        GET        /superset/available_domains/
Superset.copy_dash                                GET, POST  /superset/copy_dash/<int:dashboard_id>/
UserDBModelView.api_read                          GET        /users/api/read
UserDBModelView.delete                            GET, POST  /users/delete/<pk>
UserInfoEditView.this_form_post                   POST       /userinfoeditview/form
UtilView.back                                     GET        /back
appbuilder.static                                 GET        /static/appbuilder/<path:filename>
health                                            GET        /health
healthcheck                                       GET        /healthcheck
ping                                              GET        /ping
```

从上面找到 /usr/delete所对应的视图函数 UserDBModelView.delete。已经知道flask-appbuilder负责管理登陆用户相关功能。

于是在 flask-appbuilder模块内查找视图类 UserDBModelView，定位到 类所在的文件/flask_appbuiler/security/views.py

```python
# /flask_appbuiler/security/views.py
class UserDBModelView(UserModelView):
    """ 通过查看父类方法，定位到 delete方法
    UserDBModelView -> UserModelView -> ModelView
    """

class UserModelView(ModelView):
    route_base = "/users"

class ModelView(RestCRUDView):
    @expose("/delete/<pk>", methods=["GET", "POST"])
    @has_access
    def delete(self, pk):

"""
/users/delete/xx 用户删除时，要确保user_id没有外键关联，涉及到表slice, dashboard, logs, url, favstar，dbs...
查询数据关联SQL示例如下：（如果返回有值，则可依次到相应看板/图表删除）
use xxDB;
SELECT t1.slice_id, t2.dashboard_id, t0.id, t0.username
FROM ab_user t0, slice_user t1, dashboard_user t2
where
t1.user_id = t0.id and t2.user_id = t0.id and t0.id=1;

delete from logs where user_id in (17,);
delete from url where changed_by_fk in (17,);
delete from favstar where user_id in (17,);
"""
```



**Q1：ImportError: cannot import name 'Any' from 'typing' **

报错信息：

```shell
  File "/superset/superset/app.py", line 21, in <module>
    from typing import Any, Callable, Dict
  File "\superset\superset\typing.py", line 17, in <module>
    from typing import Any, Callable, Dict, List, Optional, Sequence, Tuple, Union
ImportError: cannot import name 'Any' from 'typing' (\superset\superset\typing.py)
```

原因：实际上是typing.py和标准库里重名了。

**解决方法1**（推荐superset后续版本）：将superset/typing.py 改名 superset/superset_typing.py ，并修改相关多处导入

` from superset.typing` 处改为 `from superset.superset_typing`

重命名superset目录下的typing.py文件为superset_typing.py：该文件与python3自带的模块typing重名，不修改会导致项目运行报错。注意使用Shitf + F6选项来更新文件名，pycharm 会自动更新被引用位置的名字。

**解决方法2**：在pycarm terminal定义`PYTHONPATH`为当前脚本路径，则在pycharm termianl启动没问题。但在pycahrm run/debug方式启动仍然报错（估计是 PYTHONPATH路径未在整个pycharm生效）。



**Q2：解决linux下nodejs中watch文件最大数异常**

描述：

```shell
ENOSPC: System limit for number of file watchers reached
```

解决方法：

```shell
$ echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```



**Q3:  A valid API access token is required to use Mapbox data**

描述：Deck图会出现如下提示  `A valid API access token is required to use Mapbox data`

解决方法：需要去http://account.mapbox.com/申请一个token。然后填充到sueprset配置文件 或 作为环境变量。示例如下，

`MAPBOX_API_KEY="pk.eyJ1Ijoia2VlZmUiLCJhIjoiY2t5d3BqYTlxMDRuazJucXZseTlnaTRhaiJ9.6KdCVh-NJxi1vOysqMJEb1"`



## 中文内容乱码问题

表格  superset中文乱码问题解决

| 问题描述                                 | 解决方法                                                     | 备注                                                    |
| ---------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------- |
| MySQL字段内容中文乱码                    | create_engine('mysql+mysqlconnector://USER:PWD@HOST/DB?charset=utf8') | sqlalchemy在mysql里的实现。                             |
| PostgreSQL字段内容中文乱码               | create_engine('postgresql+psycopg2://USER:PWD@HOST/DB', echo=True, client_encoding='utf8') | 同上                                                    |
| 图表里的CSV文件导出后在中文OS的excel乱码 | config.py里设置 csv导出编码为gbk。                           | sql lab的csv文件中并没导出编码设置项，缺省编码仍为utf-8 |

备注：superset里的数据存储中文乱码主要是由sqlalchemy的create_engine参数引起的。

Q1：连接MySQL中文乱码，表名或表列名为中文。

A1：在写数据库连接串时末尾加上编码格式，如下
 `mysql://superset_nbdata_r:XXXXXXXXXX@10.64.1.248:3338/spider?charset=utf8`




## superset官网PR

* fix(dashboard): cross filter chart highlight when filters badge icon clicked #16233 https://github.com/apache/superset/pull/16233/files   （已合并到v1.3）



<br>

# 参考资料

**组件官网**

*  [Flask-AppBuilder官方文档](http://flask-appbuilder.readthedocs.io/en/latest/index.html)  http://flask-appbuilder.readthedocs.io/
*  boostrap中文网  https://www.bootcss.com/
*  webpack中文文档 https://www.webpackjs.com/concepts/
*  babel中文文档 https://www.babeljs.cn/
*  react官网中文文档  https://zh-hans.reactjs.org



**superset相关专栏**

* superset专题 https://www.cnblogs.com/datawalkman/tag/superset/





**参考链接**

*  中文文档  https://docschina.org/
*  私有版本和官方版本的合并 [Superset：合并私有版本和Airbnb官方版本（一）](http://zhuanlan.zhihu.com/p/27207957)
*  superset的缓存配置 https://blog.csdn.net/qq_33440665/article/details/65628551
*  增加自定义数据源 https://zhuanlan.zhihu.com/p/179162221
*  利用Flask-AppBuilder 快速构建Web后台管理应用 https://blog.csdn.net/oxuzhenyi/article/details/77586500
*  Superset 1.0 终于发布了 https://cloud.tencent.com/developer/article/1823370
*  如何将Superset嵌入后台系统之实践 https://www.yisu.com/zixun/58300.html
*  superset、metabase、redash三个开源BI工具的个人使用心得及分析 https://blog.csdn.net/weixin_42473019/article/details/105419781
*  教程 —— 如何在自己的应用集成superset https://blog.csdn.net/weixin_38168198/article/details/101147712
*  安装Apache Superset--基于Docker的安装配置 https://blog.csdn.net/nikeylee/article/details/115264818
*  磨人的小妖精Apache Superset之绝对不改版 https://segmentfault.com/a/1190000022060920
*  如何将炫酷的报表直接截图发送邮件——在Superset 0.37使用Schedule Email功能 https://cloud.tencent.com/developer/article/1711719
*  Superset0.38.0新版本如何将中国地图由拼音显示中文 https://blog.csdn.net/zfqsmn1126/article/details/111313207
*  superset 二次开发之看板渲染为深色大屏 https://juejin.cn/post/7004462914765586445

