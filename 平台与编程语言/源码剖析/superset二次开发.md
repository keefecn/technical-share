| 序号 | 修改时间  | 修改内容                               | 修改人 | 审稿人 |
| ---- | --------- | -------------------------------------- | ------ | ------ |
| 1    | 2018-5-5  | 创建，从《BI专题》迁移至此。           | Keefe  |        |
| 2    | 2021-6-11 | 调整部分内容，全文迁移到源码剖析目录。 | 同上   |        |
| 3    | 2021-6-21 | 更新superset-1.0的相关内容。           | 同上   |        |











---

[TOC]



---



# 1 简介

官网： https://superset.apache.org/

API文档： https://superset.apache.org/docs/rest-api

下载： https://dist.apache.org/repos/dist/release/superset/

**github项目**

superset：https://github.com/apache/superset/

官网页面 superset-site：https://github.com/apache/superset-site

孵化代码（仅限于0.28之前）：https://github.com/apache/incubator-superset/

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

| 版本  | 发布时间   | 功能特性                                                |
| ----- | ---------- | ------------------------------------------------------- |
| 1.1   | 2021-4-14  |                                                         |
| 1.0   | 2021-1-21  | 里程碑。晋升为 ASF 顶级项目。用户体验和性能有极大提升。 |
| 0.38  | 2020-10-17 |                                                         |
| 0.37  | 2020-8-14  |                                                         |
| 0.36  | 2020-04-02 |                                                         |
| 0.35  | 2019-10-31 |                                                         |
| 0.34  | 2019-08-09 |                                                         |
| ...   |            |                                                         |
| 0.28  | 2018-10-17 | incubator-superset仓库的最终版本tag。                   |
| 0.24  | 2018-3-27  |                                                         |
| ...   |            |                                                         |
| 0.4   | 2015-9-27  |                                                         |
| 0.2.0 | 2015-9-5   | 第一个正式发布版本。                                    |

> 版本号a.b.0一般简写为a.b.
>
> ChangeLog: https://github.com/apache/superset/blob/master/CHANGELOG.md
>
> 版本更新规律：a.b.x小版本在1个月，a.x.c大版本在三个月左右（一个大版本大概包括2-4个小版本）。目前架构升级版本只进行了一次 (0-->1)，用了6年。



## 术语

*  Dashboard（仪表盘、看板）：由多个Slice组合而成。
*  Slice（切片）：即数据集Datasets 或者 Chart。Slice就是配置好数据表的图表。一个Slice指向一个数据表和一种图表类型Chart。
*  Table：数据表可以是数据源里的物理单表，也可以是多表关联查询而成的子查询虚拟表，另外也可导入CSV文件作为数据表。
*  Datasource 数据源：支持11+种数据源和文件CSV格式。

 

# 2 用户篇

Apache Superset-1.0是个里程碑，相对于之前版本改动较大。

## 2.1 安装

Installation 

*  installing-superset-from-scratch 从头装起 https://superset.apache.org/docs/installation/installing-superset-from-scratch

- [Locally with Docker](https://superset.incubator.apache.org/installation.html#start-with-docker)
- [Install on Windows 10](https://gist.github.com/mark05e/d9cccae129dd11a21d7219eddd7d9923)
- [Install on CentOS](https://aichamp.wordpress.com/2019/11/20/installing-apache-superset-into-centos-7-with-python-3-7/)
- [Build Apache Superset from source](https://hackernoon.com/a-better-guide-to-build-apache-superset-from-source-6f2ki32n0)



**1) 常规安装：pip安装、初始化、启动**

**PIP安装**

安装版本： superset-0.24

安装需求：要求python 2.7.8+或者python 3.6+。python 2.7环境pip安装时需预安装pytest-runner.

```shell
# 安装法1：在线安装
pip install superset

# 安装法2：离线安装
pip download -d <dir> superset
pip install --no-index -f <dir> superset

# 安装法3: 升级安装
pip install superset --upgrade
```



安装版本：apache-superset-1.0

安装需求：Python ~=3.7

```shell
pip install apache-superset==1.0.0
```



**初始化**

```shell
# Create an admin user (you will be prompted to set username, first and last name before setting a password)
# 或者将 fabmanger 替换成 superset fab
fabmanager create-admin 

# Initialize the database，若版本更新，运行前需要先执行此句
superset db upgrade

# Create default roles and permissions
superset init

# Load some data to play with，可选非必需。
superset load-examples
```

**启动**

```shell
# 启动法1：缺省启动，Start the web server on port 8088， 0.x用的runserver
superset run

# 启动法2：指定端口 -d调试；-p监听端口，缺省8088
superset run -d -p 8088
```



**查看页面，缺省端口8088**

http://localhost:8088

 

**2)  安装 + 构建**

```shell
cd incubator-superset-xxx
pip install .
cd superset/assets

# 安装前端构建工具 yarn, 也可以直接用npm构建
npm install -g yarn
yarn config set registry https://registry.npm.taobao.org
yarn
yarn run build
```



## 2.2 支持的数据源

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

说明：以kylin示例URL：kylin://user: Greenplum pwd@host:port/project?charset=utf-8

1. 元数据：默认情况下，superset是把元数据保存到sqlite。sqlite是python标准库，其它的数据库插件需要安装才能使用。
2. URI前缀相同的表示使用相同协议，如Postgres/Greenplum/Redshift，Postgres是RDBS；Greenplum是基于Postgres开发的海量（50PB）级别的RDBS；Redshift是AWS的云化数据仓库。
3. 数据源类型分类：RDBS有MySQL/Postgres/Oracle/MSSQL；数据仓库有Presto/Impala/SparkSQL/Athena/ Vertica；预计算有Kylin.
4. 还不支持的DB：MongoDB



## 2.3 基本功能

数据流向： 数据源 - 数据表 -- 切片/图表 -- 看板

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

数值格式：D3.format('d') https://github.com/d3/d3-format/blob/master/README.md#format 

 

# 3 开发篇

## 3.1 开发者必知

* 私有版本和官方版本的合并 [Superset：合并私有版本和Airbnb官方版本（一）](http://zhuanlan.zhihu.com/p/27207957)

 

## 3.2 API

官方接口文档：  https://superset.apache.org/docs/rest-api   (flask_appbuild模块实现FAB_API_SWAGGER_UI )

路由映射方法 

* 主要使用 flask_appbuild 模块提供的装饰器:  expose 和 expose_api
  * expose 用于网页,  返回HTML。如/xx
  * （没用到）expose_api 用于API，返回JSON。如/api/v1/xxx
* route flask原生路由，仅用于 /healthy
* /api/

superset API实现在各个目录下的api.py



### 图表（模型） Chart

此页是为了展示 模型列表。

![image-20210702145252701](E:\mydocs\repos\technical-share\media\code\code_superset_001.png)

/chart/list/?pageIndex=0&sortColumn=changed_on_delta_humanized&sortOrder=desc&viewMode=table





### 看板 Dashboard





## 3.3 简易定制化

### 国际化

实现原理：flask_babel --> babel

配置文件 config.py

 ```python
# Setup default language 缺省语种，flask_babel模块所需变量
BABEL_DEFAULT_LOCALE = 'zh'
 ```



主要修改二部分

* translates/zh/LC_MESSAGES/message.json
* JSX文件： superset-frontend/explore/controls.jsx,   修改label, description值即可，修改了需要重新构建

```jsx
# 用t()圈起来的内容一般可以用 pybabel提取出来  
color_scheme: {
    type: 'ColorSchemeControl',
    label: t('Color scheme 彩色主题'),
    default: categoricalSchemeRegistry.getDefaultKey(),
    renderTrigger: true,
    choices: () => categoricalSchemeRegistry.keys().map(s => [s, s]),
    description: t('The color scheme for rendering chart 渲染图表用彩色主题'),
    schemes: () => categoricalSchemeRegistry.getMap(),
  },
```



以中文翻译为例 

```shell
# 使用pybabel：提取 message.pot，再转化成 message.po

# step1: 人工翻译 messages.po, 纯文本格式，示例如下：en 中文
msgid "Annotation Layers"
msgstr "注解层"

# step2: 编译 messages.po -> messages.mo
pybabel compile -d translations

# step3: 文件格式转化 message.mo -> message.json, json格式为最后源码加载文件
po2json -d superset -f jed1.x translations/zh/LC_MESSAGES/messages.po translations/zh/LC_MESSAGES/messages.json
```



### 网页外部嵌入

嵌入页面缺少鉴权。



## 3.4 复杂定制化

### 自定义图表开发

- [Building Custom Viz Plugins](https://superset.apache.org/docs/installation/building-custom-viz-plugins)
- [Managing and Deploying Custom Viz Plugins](https://medium.com/nmc-techblog/apache-superset-manage-custom-viz-plugins-in-production-9fde1a708e55)



未实现的图表如：同比、环比

https://github.com/airbnb/superset/pull/3013

https://github.com/airbnb/superset/issues?q=label%3Aexample+is%3Aclosed

 

示例: New viz~treemap https://github.com/apache/incubator-superset/pull/344

修改文件：superset/view/xx.js
*  imgage caravel/assets/images/viz_thumbnails/treemap.png 
*  js   caravel/assets/javascripts/modules/caravel.js
*  css  caravel/assets/visualizations/treemap.css
*  js   caravel/assets/visualizations/treemap.js
*  caravel/data/__init__.py
*  caravel/viz.py

 

### 新增数据源开发

原理：SQLAlchemy，ORM模式。

参考 增加自定义数据源 https://zhuanlan.zhihu.com/p/179162221



### 集成 eCharts

参见  Apache Superset集成Echarts https://blog.csdn.net/tancongcong/article/details/91991051?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-2.nonecase&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-2.nonecase



### 根路由定制（改动复杂）

路由部分主要是由 flask_appbuilder 来完成的。

修改项：修改flask_appbuilder的各种view的route_base，以及superset JS里链接跳转的硬编码部分。

```shell
flask_appbuilder/
    modified:  babel/views.py
    modified:  baseviews.py
    modified:  const.py
    modified:  security/views.py
    modified:  views.py
```





# 4 运维篇

## 4.1  权限和安全管理

### 权限管理

权限管理：权限项有287项，可分为两大类分别是基本权限和视图列表的操作权限。

表格 5 权限管理的角色说明（角色类似用户组的概念）

| 角色    | 权限说明                                                     | 权限项举例 |
| ------- | ------------------------------------------------------------ | ---------- |
| admin   | 管理员拥有所有可能的权利，包括授予或撤销其他用户的权限，以及更改其他人的切片和仪表板。 |            |
| Alpha   | Alpha可以访问所有数据源，但无法授予或撤销其他用户的访问权限。 它们也限于改变他们拥有的对象。 Alpha用户可以添加和更改数据源。 |            |
| Gamma   | 访问有限。他们只能使用他们通过另一个补充角色访问的数据源中的数据。相当于内容消费方。 |            |
| public  | 用户必须的信息。如个人密码修改                               |            |
| grant   |                                                              |            |
| sql_lab | sql lab访问和操作权限。                                      |            |

备注：superset的权限控制是由数据源中的数据表和dashboard来决定的。
1. 数据表的读权限
*  数据源（表）的属主缺省可以完全操作（读+写+删）此数据源的图表和视图。
*  Alpha角色可以读取所有数据源和dashboard，但不能修改。
*  Gamma只能看到数据库，数据表和dashboard都是缺省为空。
2. dashboard的写权限：要能修改dashboard，要在此看板设置所有者加入用户名。

 

表格 6 权限管理的数据表

| 表名          | 权限说明 | 权限详述                       |
| ------------- | -------- | ------------------------------ |
| ab_role       | 角色     |                                |
| ab_premission | 权限     | 如can list/can del等保存在此表 |
| ab_view_menu  | 被管对象 | 菜单、视图、数据源等等。       |

备注：权限和被管对象通过表ab_permission_view关联起来。

 

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

**配置文件的优先级**:  superset_config.py >  superset/config.py (即superset.config)  （详见下文源码分析 相关章节）

**环境变量**： 

* SUPERSET_HOME    元数据文件和日志文件目录，影响到变量DATA_DIR
* SUPERSET_CONFIG_PATH   superset配置路径，superset_config.py所在路径，赋值给CONFIG_PATH_ENV_VAR
* SUPERSET_CONFIG  配置文件路径，缺省为superset.config (即superset/config.py)
* FLASK_ENV  设置是否调试 development/prod，缺省development是debug模式
* MAPBOX_API_KEY  是否支持MAPBOX可视化，缺省False



superset/config.py  （一般不改这个文件内容）

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

# Your App secret key
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
```



 superset/superset_config.py  

用户个性化部分修改示例：

 ```python
from dateutil import tz
from typing import Any, Callable, Dict, List, Optional, Type, TYPE_CHECKING

# The SQLAlchemy connection string.
SQLALCHEMY_DATABASE_URI = 'mysql://root:xxxxxx@127.0.0.1/superset_1.0'

# [TimeZone List]
DRUID_TZ = tz.gettz('Asia/Shanghai')

# Setup default language  中文
BABEL_DEFAULT_LOCALE = "zh"

APP_NAME = "DataLab"

# 页面嵌入 配置
# Flask-WTF flag for CSRF
WTF_CSRF_ENABLED = False

ENABLE_CORS = True
# CORS_OPTIONS: Dict[Any, Any] = {"supports_credentials": True}

# SESSION_COOKIE_HTTPONLY = False  # Prevent cookie from being read by frontend JS?
# SESSION_COOKIE_SECURE = False  # Prevent cookie from being transmitted over non-tls?
# SESSION_COOKIE_SAMESITE = "None"  # One of [None, 'None', 'Lax', 'Strict']

# Add endpoints that need to be exempt from CSRF protection
WTF_CSRF_EXEMPT_LIST = ["superset.views.core.log", "superset.charts.api.data",
                        "superset.views.core.explore_json"]

# Superset allows server-side python stacktraces to be surfaced to the
# user when this feature is on. This may has security implications
# and it's more secure to turn it off in production settings.
SHOW_STACKTRACE = True

# Will allow user self registration
AUTH_USER_REGISTRATION = True

# The default user self registration role
AUTH_USER_REGISTRATION_ROLE = "Gamma"
 ```



## 4.3 性能优化

### 缓存 flask-cache

superset使用Flask-Cache来缓存数据。Flask-Caching supports various caching backends, including Redis, Memcached, SimpleCache (in-memory), or the local filesystem.

- Memcached: we recommend using [pylibmc](https://pypi.org/project/pylibmc/) client library as `python-memcached` does not handle storing binary data correctly.
- Redis: we recommend the [redis](https://pypi.python.org/pypi/redis) Python package

修改文件：superset/superset_config.py

 ```python
# 缓存数据源/数据库 
DATA_CACHE_CONFIG = {
    'CACHE_TYPE': 'redis',
    'CACHE_DEFAULT_TIMEOUT': 60 * 60 * 24, # 1 day default (in secs)
    'CACHE_KEY_PREFIX': 'superset_results',
    'CACHE_REDIS_URL': 'redis://localhost:6379/0',
}

# 缓存缩略图 Caching Thumbnails
FEATURE_FLAGS = {
    "THUMBNAILS": True,
    "THUMBNAILS_SQLA_LISTENERS": True,
}
 ```



### WEB服务器

**A proper WSGI HTTP Server**

WSGI是Web Server Gateway Interface的缩写。以层的角度来看，WSGI所在层的位置低于CGI。但与CGI不同的是WSGI具有很强的伸缩性且能运行于多线程或多进程的环境下，这是因为WSGI只是一份标准并没有定义如何去实现。WSGI介于WEB框架和WEB服务器之间。

WSGI 没有官方的实现, 因为WSGI更像一个协议. 只要遵照这些协议,WSGI应用(Application)都可以在任何服务器(Server)上运行, 反之亦然。

WSGI标准在 PEP 333 [1] 中定义并被许多框架实现，其中包括现广泛使用的django框架。

 

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
*  删除图表会影响到看板，删除看板不会影响到图片。

 

## 日志

* DATA_DIR： 用来存放元数据文件（缺省sqlite是superset.db）、日志文件（superset.log）。依赖环境变量SUPERSET_HOME，缺省~/.superset



# 5 架构篇

本章架构篇的分析方法采用了TOGAF和UML视图法。

其中使用了TOGAF的IT架构，UML的四大视图法。

架构工具：Enterprise Architect

## 5.1 IT架构

在TOGAF体系中，IT架构包括了应用架构、数据架构和技术架构。

 

## 5.2   UML视图

### 5.2.1 部署视图

 略



### 5.2.2 开发视图（组件）

​               ![image-20191201170208395](../../media/ai/dv_superset_001.png)                



### 5.2.3 逻辑视图

主要是UML中的主要开发期和运行期视图。

包括类图、活动图等。

 



## 5.3   数据架构（数据模型）



| 模块                   | 次模块或命令                 | *说明*                                                       |
| ---------------------- | ---------------------------- | ------------------------------------------------------------ |
| Flask  Appbuilder(fab) | `superset fab create-admin`  | 创建角色和管理员用户。1.x用superset fab替换fabmanger。<br>共创建8张表，以ab_开头。  user  -> role -> premission_view-> (permission, view_menu) |
| superset meta          | `superset db upgrade`        | 数据库初始化（版本更新时也要执行此命令）。<br>共创建24张表。 |
|                        | datasources:  druid/database | 数据源包括两种组织形式：druid和database  <br>druid:  cluster - datasources - columns/metrics  <br>database：dbs - tables -  tablecolumn/sql_metrics |
|                        | views:    slice/dashboard    | slice：slices slice_user  slice_dashboard <br>dashboard:  dashboard dashboard_user |
|                        | css/template                 | css_templates annotation annotation_layer                    |
|                        | sql                          | query  saved_query                                           |
|                        | other                        | KV,  url(短网址）  favstar logs                              |
|                        | 1.x新增7张表                 | access_request user_attribute sqltable_user<br>dashboard_email_schedules slice_email_schedules <br>tab_state tagged_object |
| CSV文件                |                              | 每个CSV文件会转成元数据库里的一张表。  database为main        |

备注：1. fab通过给role授权数据源(view_menu)和权项限(persionn)访问权限来控制可访问的view，粒度从数据源级别到数据源内的list/add/show/del/edit权限。

2. 通过修改视图的Owner来管理修改权限。

3. superset_meta通过ab_role来关联fab的安全管理功能。



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

 



# 6 源码分析篇

源码分析版本： superset-1.0

 ## 源码结构 

表格  项目顶级目录结构

| 目录               | 二级目录或文件                 | 简介                                                         |
| ------------------ | ------------------------------ | ------------------------------------------------------------ |
| dist               | xx.tar.gz                      | 打包时`python setup.py sdist`自动生成                        |
| docker             |                                | docker相关的脚本                                             |
| helm               |                                | helm镜像仓库的配置目录                                       |
| RELEASING          |                                | 发布日志                                                     |
| requirements       |                                | 各种安装方式的模块依赖文件                                   |
| tests              |                                | 测试目录                                                     |
| docs               |                                | 文档，使用spinx生成                                          |
| scripts            | pypi_push.sh   python_tests.sh | superset常用的脚本                                           |
|                    | setup.py setup.cfg             | 部署常用的一些文件。  requirement.txt 组件需求，pip freeze   README.md     CHANGELOG.md |
| superset           |                                | superse后端源码目录                                          |
| superset-frontend  |                                | superset前端源码目录                                         |
| CHANGELOG.md       |                                | 版本更新日志                                                 |
| setup.py setup.cfg |                                | 安装脚本，包括了依赖组件                                     |

 

表格  源码后端目录superset里的结构

| 目录或文件        | 次模块             | 简介                                                         |
| ----------------- | ------------------ | ------------------------------------------------------------ |
| annotation_layers |                    | 锚点层                                                       |
| assets            |                    | 前端依赖框架集成，这里存放了npm集成的依赖js框架，当你打开后会看到node_modules文件夹，由npm动态生成，命令是`$ npm run dev-fast`<br>1.x版本已将此目录移到外层，改为superset-frontend |
| async_events      |                    | 异步事件                                                     |
| cachekeys         |                    |                                                              |
| charts            |                    | 图表                                                         |
| commands          |                    | 支持的命令                                                   |
| common            |                    |                                                              |
| connectors        |                    | 数据库连接器，连接数据源有2种类型，通过ConnectorRegistry连接 |
| db_engines        |                    |                                                              |
| dao               |                    |                                                              |
| dashboards        |                    |                                                              |
| databases         |                    |                                                              |
| datasets          |                    |                                                              |
| db_engines        |                    | 0.x时就有的目录。连接其他数据库的engines 比如mysql，pgsql等  |
| db_engine_spec    |                    | 同上                                                         |
| examples          |                    |                                                              |
| migrations        |                    | 做数据迁移用的，比如更新数据库，更新ORM(model和表中字段的映射关系)。 |
| models            |                    | 存放项目的model，如果要修改字段，优先到这里寻找。            |
| quaries           |                    |                                                              |
| reports           |                    |                                                              |
| security          |                    | 修改权限入口                                                 |
| sql_validators    |                    |                                                              |
| static            |                    | 存放静态文件的目录，比如我们用到的css、js、图片等静态文件都在这里。 |
| tasks             |                    | celery 任务脚本                                              |
| templates         |                    | JinJa2模板目录，几乎项目所有的HTML文件都在这里。basic.html提供web整体的样式风格。 |
| translations      |                    | 翻译文件，只需修改字段对应的名称。                           |
| utils             |                    |                                                              |
| views             | health.py  core.py | 视图文件，这里定义了url，来作为前端的入口。  <br>core.py中的函数在渲染页面时，都要指定basic.html模板为基础。 |
| app.py            |                    | WEB实例初始化，也是调试入口                                  |
| cli.py            |                    | superset命令                                                 |
| viz.py            |                    | 所有得图表类型 后端数据处理入口                              |
| extensions.py     |                    | 定义 celery， logger 等中间件                                |

 >superset后端用到的组件主要有：flask, sqlalchemy, pandas



表格  前端目录superset-frontend源码结构

| 目录或文件        | 二级目录或文件 | 简介                                               |
| ----------------- | -------------- | -------------------------------------------------- |
| webpack.config.js |                | 前端入口文件。定义了 以src文件夹去生成打包js文件。 |
| src               |                | 源码                                               |
|                   | explore        |                                                    |
|                   |                |                                                    |
|                   |                |                                                    |
|                   |                |                                                    |
|                   |                |                                                    |
|                   |                |                                                    |
|                   |                |                                                    |
|                   |                |                                                    |
|                   |                |                                                    |
|                   |                |                                                    |
|                   |                |                                                    |

> superset前端用到的组件主要有：React, D3



## 组件概述 

**依赖组件**：

前端组件

*  React：交互
*  Jiaja2：模板引擎
*  D3/NVD3：图表

后端组件

*  Flask：web服务框架
*  SQLALchemy：数据访问
*  Pandas：数据结果展示



**整体流程**

1. npm run dev --将每个模块打包成一个单独的js文件（在webpack.config.js中配置）
2. superset runserver  --启动服务
3. 浏览器登录
4. 点击某一菜单
5. wsgi 将请求重定向到python侧，执行views/core.py中的对应函数
6. core.py中的函数用render_template构造html页面（render_template的参数entry用户指定所需的js文件，此文件即npm打包而成的单一js）
7. 浏览器render后端返回的html页面



**npm打包流程**

打包的依据是assets/webpack.config.js文件中的配置。





## 命令行处理 cli.py

启动命令： `falsk run xxx`  或者  `superset run xxx`

```shell
# superset/releasing/from_tarball_entrypoint.sh
FLASK_ENV=development FLASK_APP="superset.app:create_app()" \
flask run -p 8088 --with-threads --reload --debugger --host=0.0.0.0
```



flask 或者 superset 脚本

```python
# -*- coding: utf-8 -*-
import re
import sys

# flask脚本  
from flask.cli import main
if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw|\.exe)?$', '', sys.argv[0])
    sys.exit(main())
    
# 或者 superset脚本    
from superset.cli import superset
```



superset命令将会触发 app.py::create_app()

superset/cli.py

```python
from flask.cli import FlaskGroup, with_appcontext

# 此处superset函数用了二个装饰器，
# click.groupu装饰器会生成脚本组，触发函数create_app, 并且将方法名作归一化处理normalize_token
# with_appcontextu装饰器会使用应用上下文
@click.group(
    cls=FlaskGroup,
    create_app=create_app,
    context_settings={"token_normalize_func": normalize_token}, #此处将方法名里的_替换成-
)
@with_appcontext
def superset() -> None:
    """This is a management script for the Superset application."""

    @app.shell_context_processor
    def make_shell_context() -> Dict[str, Any]:  # pylint: disable=unused-variable
        return dict(app=app, db=db)    
```



superset支持命令

```shell
$ superset --help
logging was configured successfully
INFO:superset.utils.logging_configurator:logging was configured successfully
Usage: superset [OPTIONS] COMMAND [ARGS]...

  This is a management script for the Superset application.

Options:
  --version  Show the flask version
  --help     Show this message and exit.

Commands:
  alert                     Run the alert scheduler loop
  compute-thumbnails        Compute thumbnails
  db                        Perform database migrations.
  export-dashboards         Export dashboards to JSON
  export-datasource-schema  Export datasource YAML schema to stdout
  export-datasources        Export datasources to YAML
  fab                       FAB flask group commands
  flower                    Runs a Celery Flower web server Celery Flower is...

  import-dashboards         Import dashboards from ZIP file
  import-datasources        Import datasources from YAML
  init                      Inits the Superset application
  load-examples             Loads a set of Slices and Dashboards and a...
  load-test-users           Loads admin, alpha, and gamma user for testing...
  refresh-druid             Refresh druid datasources
  routes                    Show the routes for the app.
  run                       Run a development server.
  set-database-uri          Updates a database connection URI
  shell                     Run a shell in the app context.
  sync-tags                 Rebuilds special tags (owner, type, favorited...
  update-api-docs           Regenerate the openapi.json file in docs
  update-datasources-cache  Refresh sqllab datasources cache
  version                   Prints the current version number
  worker                    Starts a Superset worker for async SQL query...
```

说明：上面命令属于flask模块命令组的有run/shell/routes/version，属于flask_appbuild命令组有fab，属于flask_migrate命令组有db，其它命令属于superset本身命令组。



命令方法名里的_会替换成-，如load_examples替换成load-examples

### superset load-examples命令

load_examples 加载测试数据，需要从网络上下载数据

```python
# superset.command()装饰说明是superset这个命令组的次级命令
@with_appcontext
@superset.command()
@click.option("--load-test-data", "-t", is_flag=True, help="Load additional test data")
@click.option(
    "--only-metadata", "-m", is_flag=True, help="Only load metadata, skip actual data"
)
@click.option(
    "--force", "-f", is_flag=True, help="Force load data even if table already exists"
)
def load_examples(
    load_test_data: bool, only_metadata: bool = False, force: bool = False
) -> None:
    """Loads a set of Slices and Dashboards and a supporting dataset """
    load_examples_run(load_test_data, only_metadata, force)
    
    
def load_examples_run(
    load_test_data: bool, only_metadata: bool = False, force: bool = False
) -> None:
    """ 实际执行的加载样例方法 """
    if only_metadata:
        print("Loading examples metadata")
    else:
        examples_db = utils.get_example_database()
        print(f"Loading examples metadata and related data into {examples_db}")

    from superset import examples

    examples.load_css_templates()   
    ...
```





## 全局实例或变量

superset/`__init__.py`

```python
from flask import current_app, Flask
from werkzeug.local import LocalProxy

from superset.app import create_app
from superset.connectors.connector_registry import ConnectorRegistry
from superset.extensions import (
    appbuilder,
    cache_manager,
    db,
    event_logger,
    feature_flag_manager,
    manifest_processor,
    results_backend_manager,
    security_manager,
    talisman,
)
from superset.security import SupersetSecurityManager

#  All of the fields located here should be considered legacy(遗留的，传统的).  
#  The correct way to declare "global" dependencies is to define it in extensions.py,
#  then initialize it in app.create_app(). These fields will be removed
#  in subsequent PRs as things are migrated towards the factory pattern
app: Flask = current_app
cache = cache_manager.cache
# LocalProxy本地代理数据：conf results_backend 数据缓存、缩略图缓存
conf = LocalProxy(lambda: current_app.config)
get_feature_flags = feature_flag_manager.get_feature_flags
get_manifest_files = manifest_processor.get_manifest_files
is_feature_enabled = feature_flag_manager.is_feature_enabled
results_backend = LocalProxy(lambda: results_backend_manager.results_backend)
results_backend_use_msgpack = LocalProxy(
    lambda: results_backend_manager.should_use_msgpack
)
data_cache = LocalProxy(lambda: cache_manager.data_cache)
thumbnail_cache = LocalProxy(lambda: cache_manager.thumbnail_cache)
```



### 配置文件

**配置文件的优先级**:  superset_config.py >  config.py  

1. superset_config.py 用环境变量SUPERSET_CONFIG_PATH定义，在config.py文件尾会重载这个文件。

需要定义了环境变量才会启用。

**推荐所有需要个性化定制的变量都放到 superset_config.py进行修改，统一管理。**

```python
# superset/config.py
if CONFIG_PATH_ENV_VAR in os.environ:
    # Explicitly import config module that is not necessarily in pythonpath; useful
    # for case where app is being executed via pex.
    try:
        cfg_path = os.environ[CONFIG_PATH_ENV_VAR]
        module = sys.modules[__name__]
        override_conf = imp.load_source("superset_config", cfg_path)
        for key in dir(override_conf):
            if key.isupper():
                setattr(module, key, getattr(override_conf, key))

        print(f"Loaded your LOCAL configuration at [{cfg_path}]")
    except Exception:
        logger.exception(
            "Failed to import config for %s=%s", CONFIG_PATH_ENV_VAR, cfg_path
        )
```

2. superset.config:  superset.app:create_app方法内加载。一般很少用到。使用环境变量SUPERSET_CONFIG或者缺省文件 superset.config (即superset/config.py)

```python
# superset/app.py
def create_app() -> Flask:
    app = Flask(__name__)

    try:
        # Allow user to override our config completely 
        config_module = os.environ.get("SUPERSET_CONFIG", "superset.config")
        # Config.from_object可以加载一个字符串或者一个对象（py文件也是一个对象）
        app.config.from_object(config_module)  
```



### WEB实例 app.py

superset/app.py

```python
# 加载配置文件，初始化app(调用init_app)
def create_app() -> Flask:
    app = Flask(__name__)

    try:
        # Allow user to override our config completely 允许用户重载自己的配置文件
        config_module = os.environ.get("SUPERSET_CONFIG", "superset.config")
        app.config.from_object(config_module)

        # app初始化类，调用init_app	
        app_initializer = app.config.get("APP_INITIALIZER", SupersetAppInitializer)(app)
        app_initializer.init_app()

        return app
    # Make sure that bootstrap errors ALWAYS get logged
    except Exception as ex:
        logger.exception("Failed to create app")
        raise ex    

        
class SupersetIndexView(IndexView):
    """ 首页视图 / --> /superset/welcome """
    @expose("/")
    def index(self) -> FlaskResponse:
        return redirect("/superset/welcome")
  

class SupersetAppInitializer:
    """ APP初始化类 """
    init_flag = False

    def __init__(self, app: Flask) -> None:
        super().__init__()

        self.flask_app = app
        self.config = app.config
        self.manifest: Dict[Any, Any] = {}     
            
    def init_app(self) -> None:
        """
        Main entry point which will delegate to other methods in
        order to fully init the app
        """
        self.pre_init()		#
        self.setup_db()		# 数据库加载
        self.configure_celery()
        self.setup_event_logger()
        self.setup_bundle_manifest()
        self.register_blueprints()
        self.configure_wtf()
        self.configure_logging()
        self.configure_middlewares()
        self.configure_cache()
              
    def init_views(self) -> None:
        """ 构建首页的导航栏、"""
```



### 扩展 extensions.py

superset/extensions.py

```python
import json
import os
from typing import Any, Callable, Dict, List, Optional

import celery
from cachelib.base import BaseCache
from flask import Flask
from flask_appbuilder import AppBuilder, SQLA
from flask_migrate import Migrate
from flask_talisman import Talisman
from flask_wtf.csrf import CSRFProtect
from werkzeug.local import LocalProxy

from superset.utils.async_query_manager import AsyncQueryManager
from superset.utils.cache_manager import CacheManager
from superset.utils.feature_flag_manager import FeatureFlagManager
from superset.utils.machine_auth import MachineAuthProviderFactory

class ResultsBackendManager:
    """ 后端结果管理 """
    
class UIManifestProcessor:
    """ UI主文件处理器 """
    
APP_DIR = os.path.dirname(__file__)
appbuilder = AppBuilder(update_perms=False)
# 异步查询管理、缓存管理
async_query_manager = AsyncQueryManager()  
cache_manager = CacheManager()
celery_app = celery.Celery()
csrf = CSRFProtect()
db = SQLA()
# 本地代理LocalProxy：事件日志、安全管理
_event_logger: Dict[str, Any] = {}
event_logger = LocalProxy(lambda: _event_logger.get("event_logger"))
feature_flag_manager = FeatureFlagManager()
machine_auth_provider_factory = MachineAuthProviderFactory()
manifest_processor = UIManifestProcessor(APP_DIR)
migrate = Migrate()
results_backend_manager = ResultsBackendManager()
security_manager = LocalProxy(lambda: appbuilder.sm)
talisman = Talisman()    
```



## superset-frontend 前端



## 前后端联动

**1.前后端打包**： 

* 后端打包setup.py 取的版本号来自  前端superset-frontend/package.son:  `python setup.py sdist`
* 前端生成的包 在superset/static目录： `npm run build`



# FAQ 常见问题

## 安装常见问题

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

解决方法2： windows下安装vc++14.0+，linux下安装 python3-devel



**Q2: Linux环境安装报错： command '[gcc](https://www.laozuo.org/tag/gcc)' failed with exit status 1**

报错信息： command '[gcc](https://www.laozuo.org/tag/gcc)' failed with exit status 1

原因：缺少openssl-devel库

解决方法：

```shell
yum install gcc libffi-devel python3-devel openssl-devel -y
```



## 开发常见问题

**Q1： ImportError: cannot import name 'Any' from 'typing' **

报错信息：

```shell
  File "E:/isoftstone/project/repos/superset/joshua_code-superset-jsohua/superset/superset/app.py", line 21, in <module>
    from typing import Any, Callable, Dict
  File "E:\isoftstone\project\repos\superset\joshua_code-superset-jsohua\superset\superset\typing.py", line 17, in <module>
    from typing import Any, Callable, Dict, List, Optional, Sequence, Tuple, Union
ImportError: cannot import name 'Any' from 'typing' (E:\isoftstone\project\repos\superset\joshua_code-superset-jsohua\superset\superset\typing.py)
```

原因：实际上是typing.py和标准库里重名了。

解决方法1（推荐superset后续版本）：将superset/typing.py 改名 superset/superset_typing.py ，并修改相关多处导入 

` from superset.typing 处改为 from superset.superset_typing

重命名superset目录下的typing.py文件为superset_typing.py：该文件与python3自带的模块typing重名，不修改会导致项目运行报错。注意使用Shitf + F6选项来更新文件名，pycharm 会自动更新被引用位置的名字。

**解决方法2**：在pycarm terminal定义`PYTHON_PATH`为当前脚本路径，则在pycharm termianl启动没问题。但在pycahrm run/debug方式启动仍然报错（估计是 PYTHON_PATH路径未在整个pycharm生效）。



表格  superset一般问题列表

| 问题                                                         | 解决方法                                                     | 备注           |
| ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| superset元数据的日志时间缺省为UTC，需更改为本地时间~东八区UTC8 | 修改 core/model/core.py  dttm=Column(DateTime,  default=datetime.now) | 将ucnow改为now |
|                                                              |                                                              |                |

 

## 中文内容乱码问题

表格  superset中文乱码问题解决

| 问题描述                                 | 解决方法                                                     | 备注                                                    |
| ---------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------- |
| MySQL字段内容中文乱码                    | create_engine('mysql+mysqlconnector://USER:  PWD@HOST/DB?charset=utf8') | sqlalchemy在mysql里的实现。                             |
| PostgreSQL字段内容中文乱码               | create_engine('postgresql+psycopg2://USER:  PWD@HOST/DB', echo=True, client_encoding='utf8') | 同上                                                    |
| 图表里的CSV文件导出后在中文OS的excel乱码 | config.py里设置 csv导出编码为gbk。                           | sql lab的csv文件中并没导出编码设置项，缺省编码仍为utf-8 |

备注：superset里的数据存储中文乱码主要是由sqlalchemy的create_engine参数引起的。

Q1：连接MySQL中文乱码

A1：在写数据库连接串时末尾加上编码格式，如下（仅适用于py27） 
 `mysql://superset_nbdata_r:XXXXXXXXXX@10.64.1.248:3338/spider?charset=utf8`S



# 参考资料

**组件官网**

*  [Flask-AppBuilder官方文档](http://flask-appbuilder.readthedocs.io/en/latest/index.html)  http://flask-appbuilder.readthedocs.io/



**参考链接**

*  知乎专栏-superset开发 https://zhuanlan.zhihu.com/c_100045590
*  superset的缓存配置 https://blog.csdn.net/qq_33440665/article/details/65628551
*  增加自定义数据源 https://zhuanlan.zhihu.com/p/179162221 
*  利用Flask-AppBuilder 快速构建Web后台管理应用 https://blog.csdn.net/oxuzhenyi/article/details/77586500
* Superset 1.0 终于发布了 https://cloud.tencent.com/developer/article/1823370
* Superset 代码结构分析(前后端如何联动) https://zhuanlan.zhihu.com/p/163495199
* 从前端角度记录superset二次开发 http://sunjl729.cn/2020/08/07/superset二次开发/
* Superset安装及汉化 https://www.jianshu.com/p/c751278996f8

