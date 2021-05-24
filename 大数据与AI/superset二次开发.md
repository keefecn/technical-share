| 序号 | 修改时间 | 修改内容                     | 修改人 | 审稿人 |
| ---- | -------- | ---------------------------- | ------ | ------ |
| 1    | 2018-5-5 | 创建，从《BI专题》迁移至此。 | 吴启福 |        |
|      |          |                              |        |        |
---

 

 

 

目录

[1    用户使用篇... 3](#_Toc523953283)

[2    安装篇... 3](#_Toc523953284)

[2.1    PIP安装... 3](#_Toc523953285)

[2.1.1     支持的数据源... 4](#_Toc523953286)

[2.2    编译安装... 5](#_Toc523953287)

[3    使用篇... 5](#_Toc523953288)

[3.1    时间字段... 5](#_Toc523953289)

[4    开发篇... 5](#_Toc523953290)

[4.1    组件概述... 5](#_Toc523953291)

[4.2    私有版本和官方版本的合并... 7](#_Toc523953292)

[4.3    根路由定制... 7](#_Toc523953293)

[4.4    国际化... 7](#_Toc523953294)

[4.5    自定义图表开发... 7](#_Toc523953295)

[4.6    新增数据源开发... 8](#_Toc523953296)

[4.7    其它... 8](#_Toc523953297)

[4.7.1     中文内容乱码问题... 8](#_Toc523953298)

[5    性能优化篇... 9](#_Toc523953299)

[5.1    缓存 flask-cache. 9](#_Toc523953300)

[5.2    WEB服务器... 9](#_Toc523953301)

[5.2.1     gunicorn. 9](#_Toc523953302)

[5.2.2     nginx. 10](#_Toc523953303)

[5.3    元数据替换... 10](#_Toc523953304)

[6    运维篇... 10](#_Toc523953305)

[6.1    权限管理... 10](#_Toc523953306)

[6.2    安全认证... 11](#_Toc523953307)

[6.3    配置文件... 12](#_Toc523953308)

[6.4    常见问题FAQ.. 12](#_Toc523953309)

[7    架构篇... 12](#_Toc523953310)

[7.1    IT架构... 13](#_Toc523953311)

[7.2    UML视图... 13](#_Toc523953312)

[7.2.1     部署视图... 13](#_Toc523953313)

[7.2.2     开发视图（组件）... 13](#_Toc523953314)

[7.2.3     逻辑视图... 13](#_Toc523953315)

[7.3    数据架构（数据模型）... 13](#_Toc523953316)

[7.3.1     fabmanger. 15](#_Toc523953317)

[7.3.2     superset meta. 15](#_Toc523953318)

[8    superset组件分析... 19](#_Toc523953319)

[8.1    整体流程... 19](#_Toc523953320)

[8.2    flask. 20](#_Toc523953321)

[8.3    D3/NVD3. 20](#_Toc523953322)

[9    源码分析... 20](#_Toc523953323)

[参考资料... 20](#_Toc523953324)

 



 

 

# 1    用户使用篇

**术语**
*  Dashboard（仪表盘、看板）：由多个slice组合而成。
*  Slice（切片）：slice就是配置好数据表的图表。一个Slice指向一个数据表和一种图表类型。
*  Table：数据表可以是数据源里的物理单表，也可以是多表关联查询而成的子查询虚拟表，另外也可导入CSV文件作为数据表。
*  Datasource 数据源：支持11种数据源和文件CSV格式。

 

# 2    安装篇

版本：superser-0.24

版本需求：要求python 2.7.8+或者python 3.6+。python 2.7环境pip安装时需预安装pytest-runner.

 

## 2.1   PIP安装

\# 在线安装

pip install superset

\# 离线安装

pip download -d <dir> superset

pip install --no-index -f <dir> superset

\# 升级安装

pip install superset --upgrade

 

\# Create an admin user (you will be prompted to set username, first and last name before setting a password)

fabmanager create-admin --app superset

 

\# Initialize the database，若版本更新，运行前需要先执行此句

superset db upgrade

 

\# Load some data to play with，非必需。

superset load_examples

 

\# Create default roles and permissions

superset init

 

\# Start the web server on port 8088, use -p to bind to another port

superset runserver

 

\# -d调试；­-p监听端口，缺省8088

superset runserver -d -p 8088

 

**#** **查看页面，缺省端口8088**

http://localhost:8088

 

### 2.1.1 支持的数据源

**Database dependencies**

| database   | pypi package                          | SQLAlchemy URI prefix     |
| ---------- | ------------------------------------- | ------------------------- |
| MySQL      | pip install mysqlclient               | mysql://                  |
| Postgres   | pip install psycopg2                  | postgresql+psycopg2://    |
| Presto     | pip install pyhive                    | presto://                 |
| Oracle     | pip install cx_Oracle                 | oracle://                 |
| sqlite     |                                       | sqlite://                 |
| Redshift   | pip install sqlalchemy-redshift       | postgresql+psycopg2://    |
| MSSQL      | pip install pymssql                   | mssql://                  |
| Impala     | pip install impyla                    | impala://                 |
| SparkSQL   | pip install pyhive                    | jdbc+hive://              |
| Redshift   | pip install psycopg2                  | postgresql+psycopg2://    |
| Athena     | pip install  "PyAthenaJDBC>1.0.9"     | awsathena+jdbc://         |
| Vertica    | pip install sqlalchemy-vertica-python | vertica+vertica_python:// |
| ClickHouse | pip install sqlalchemy-clickhouse     | clickhouse://             |
| Kylin      | pip install kylinpy                   | kylin://                  |

备注：以kylin示例URL：kylin://user: Greenplum pwd@host:port/project?charset=utf-8

\1. 元数据：默认情况下，superset是把元数据保存到sqlite。sqlite是python标准库，其它的数据库插件需要安装才能使用。

\2. URI前缀相同的表示使用相同协议，如Postgres /Greenplum/ Redshift，Postgres是RDBS；Greenplum是基于Postgres开发的海量（50PB）级别的RDBS；Redshift是AWS的云化数据仓库。

\3. 数据源类型分类：RDBS有MySQL/Postgres/Oracle/MSSQL；数据仓库有Presto/Impala/SparkSQL/ Athena/ Vertica；预计算有Kylin

## 2.2   编译安装

cd incubator-superset-xxx

pip install .

cd superset/assets

\# 安装编译工具 yarn

npm install -g yarn

yarn config set registry https://registry.npm.taobao.org

yarn

yarn run build

 

# 3    使用篇

数据源 - 数据表 -- 切片/图表 -- 看板

 

## 3.1   时间字段

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

# 4    开发篇

## 4.1   组件概述

**前后端组件**

前端组件
*  React：交互
*  Jiaja2：模板引擎
*  D3/NVD3：图表

 

后端组件
*  Flask：web服务框架
*  SQLALchemy：数据访问
*  Pandas：数据结果展示

 

**目录结构**

表格 2 superset目录结构

| 目录     | 二级目录或  文件   | 简介                                                         | 备注 |
| -------- | ------------------ | ------------------------------------------------------------ | ---- |
| tests    |                    | 测试目录                                                     | 测试 |
| docs     |                    | 文档，使用sphinx生成                                         | 文档 |
| scripts  |                    |                                                              |      |
|          | setup.py setup.cfg | 部署常用的一些文件。  requirement.txt 组件需求，pip freeze   README.md     CHANGELOG.md | 部署 |
| superset |                    |                                                              |      |
|          | assets             | 前端依赖框架集成，这里存放了npm集成的依赖js框架，当你打开后会看到node_modules文件夹，这里都是由npm动态生成，命令是$ npm run dev-fast。里面还有一个dist文件夹，是根据package.json文件中的配置生成的，里面存储的都是所用js框架的名称，版本号，和下载地址。 |      |
|          | bin                | bin/superset这个文件用来启动WEB服务器。                      |      |
|          | db_engines         |                                                              |      |
|          | connectors         |                                                              |      |
|          | migrations         | 做数据迁移用的，比如更新数据库，更新ORM(model和表中字段的映射关系)。 |      |
|          | models             | 存放项目的model，如果要修改字段，优先到这里寻找。            |      |
|          | views              | 视图文件，这里定义了url，来作为前端的入口。  core.py中的函数在渲染页面时，都要指定basic.html模板为基础。 |      |
|          | static             | 存放静态文件的目录，比如我们用到的css，js，图片等静态文件都在这里。 |      |
|          | templates          | 模板目录，几乎项目所有的HTML文件都在这里。  basic.html提供web整体的样式风格。 |      |
|          | translations       | 翻译文件，只需修改字段对应的名称。                           | 汉化 |
|          | data               |                                                              |      |

 

## 4.2   私有版本和官方版本的合并

[Superset：合并私有版本和Airbnb官方版本（一）](http://zhuanlan.zhihu.com/p/27207957)

 

## 4.3   根路由定制

说明：主要修改flask_appbuilder的各种view的route_base，以及superset JS里链接跳转的硬编码部分。

flask_appbuilder/

​    modified:  babel/views.py

​    modified:  baseviews.py

​    modified:  const.py

​    modified:  security/views.py

​    modified:  views.py

 

 

## 4.4   国际化

flask_babel --> babel

 

\# 配置文件 config.py

 

\# 编译： messages.po -> messages.mo

pybabel compile -d translations

## 4.5   自定义图表开发

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

 

## 4.6   新增数据源开发

原理：SQLAlchemy，ORM模式。

 

## 4.7   其它

表格 3 superset一般问题列表

| 问题                                                         | 解决方法                                                     | 备注           |
| ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- |
| superset元数据的日志时间缺省为UTC，需更改为本地时间~东八区UTC8 | 修改 core/model/core.py  dttm=Column(DateTime,  default=datetime.now) | 将ucnow改为now |
|                                                              |                                                              |                |

 

### 4.7.1 中文内容乱码问题

表格 4 superset中文乱码问题解决

| 问题描述                                 | 解决方法                                                     | 备注                                                    |
| ---------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------- |
| MySQL字段内容中文乱码                    | create_engine('mysql+mysqlconnector://USER:  PWD@HOST/DB?charset=utf8') | sqlalchemy在mysql里的实现。                             |
| PostgreSQL字段内容中文乱码               | create_engine('postgresql+psycopg2://USER:  PWD@HOST/DB', echo=True, client_encoding='utf8') | 同上                                                    |
| 图表里的CSV文件导出后在中文OS的excel乱码 | config.py里设置 csv导出编码为gbk。                           | sql lab的csv文件中并没导出编码设置项，缺省编码仍为utf-8 |

备注：superset里的数据存储中文乱码主要是由sqlalchemy的create_engine参数引起的。

# 5    性能优化篇

## 5.1   缓存 flask-cache

superset使用Flask-Cache来缓存数据。

修改文件：*flask_cache/__init__.py, superset/config.py*

*# superset/config.py*

 

 

## 5.2   WEB服务器

**A proper WSGI HTTP Server**

WSGI是Web Server Gateway Interface的缩写。以层的角度来看，WSGI所在层的位置低于CGI。但与CGI不同的是WSGI具有很强的伸缩性且能运行于多线程或多进程的环境下，这是因为WSGI只是一份标准并没有定义如何去实现。WSGI介于WEB框架和WEB服务器之间。

WSGI 没有官方的实现, 因为WSGI更像一个协议. 只要遵照这些协议,WSGI应用(Application)都可以在任何服务器(Server)上运行, 反之亦然。

WSGI标准在 PEP 333 [1] 中定义并被许多框架实现，其中包括现广泛使用的django框架。

 

### 5.2.1 gunicorn

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


### 5.2.2 nginx

 

## 5.3   元数据替换

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

 

 

# 6    运维篇

## 6.1   权限管理

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

 

## 6.2   安全认证

细粒度高可扩展性的安全访问模型，支持主要的认证供应商（数据库、OpenID、LDAP、OAuth 等）。

How can i configure OAuth authentication and authorization?

You can take a look at this Flask-AppBuilder [configuration example](https://github.com/dpgaspar/Flask-AppBuilder/blob/master/examples/oauth/config.py).

https://raw.githubusercontent.com/dpgaspar/Flask-AppBuilder/master/examples/oauth/config.py
```SHELL
#----------------------------------------------------
# AUTHENTICATION CONFIG
#----------------------------------------------------
# The authentication type
# AUTH_OID : Is for OpenID
# AUTH_DB : Is for database (username/password()
# AUTH_LDAP : Is for LDAP
# AUTH_REMOTE_USER : Is for using REMOTE_USER from web server
AUTH_TYPE = AUTH_OAUTH
 
//这里的LDAP得自己加上
from flask_appbuilder.security.manager import AUTH_DB, AUTH_LDAP 
AUTH_TYPE = AUTH_LDAP
AUTH_LDAP_SERVER = "ldap://ldapserver.new" 
AUTH_LDAP_SEARCH="dc=mycompany,dc=com" //己方LDAP服务器的根路径
//关键: flask会把你输入的用户名替换进去，得到一个完整的DN，比如输入用户名是admin，那么flask就会在LDAP中寻找"cn=admin,OU=Users,DC=mycompany,DC=com"，然后匹配密码，没有这个是不可能找到用户的。
AUTH_LDAP_USERNAME_FORMAT = "cn=%s,OU=Users,DC=mycompany,DC=com"
```


## 6.3   配置文件

配置文件的优先级

superset_config.py > config.py > superset.config

说明：config.py文件尾会加载superset_config.py。如果环境变量中无配置文件，则会使用superset.config作为配置文件缺省名（无效场景）。

 

## 6.4   常见问题FAQ

Q1：连接MySQL中文乱码

A1：在写数据库连接串时末尾加上编码格式，如下（仅适用于py27） 
 mysql://superset_nbdata_r:XXXXXXXXXX@10.64.1.248:3338/spider?charset=utf8


Q2：py3在windows安装失败

A2: 需vc++ 14.0（即vs 2005）支持，此工具占用好几GB。


Q3：py2.7编码乱码问题

A3：方法1更新到py3.x；

方法2：
```PYTHON
import sys 
reload(sys) 
sys.setdefaultencoding('utf-8') 
```


# 7    架构篇

本章架构篇的分析方法采用了TOGAF和UML视图法。

其中使用了TOGAF的IT架构，UML的四大视图法。

架构工具：Enterprise Architect

## 7.1   IT架构

在TOGAF体系中，IT架构包括了应用架构、数据架构和技术架构。

 

## 7.2   UML视图

### 7.2.1 部署视图

 

### 7.2.2 开发视图（组件）

​               ![image-20191201170208395](../media/ai/dv_superset_001.png)                

### 7.2.3 逻辑视图

主要是UML中的主要开发期和运行期视图。

包括类图、活动图等。

 

 

## 7.3   数据架构（数据模型）



| 模块                   | 次模块                       | *说明*                                                       |
| ---------------------- | ---------------------------- | ------------------------------------------------------------ |
| Flask  Appbuilder(fab) | fabmanger    create-admin    | 共创建8张表，以ab_开头。  user  -> role -> premission_view-> (permission, view_menu) |
| superset  meta         | superset  db upgrade         | 共创建24张表。                                               |
|                        | datasources:  druid/database | 数据源包括两种组织形式：druid和database  druid:  cluster - datasources - columns/metrics  database：dbs - tables -  tablecolumn/sql_metrics |
|                        | views:    slice/dashboard    | slice：slices slice_user  slice_dashboard  dashboard:  dashboard dashboard_user |
|                        | sql                          | query  saved_query                                           |
|                        | other                        | KV,  url(短网址）                                            |
| CSV文件                |                              | 每个CSV文件会转成元数据库里的一张表。  database为main        |

备注：1. fab通过给role授权数据源(view_menu)和权项限(persionn)访问权限来控制可访问的view，粒度从数据源级别到数据源内的list/add/show/del/edit权限。

2. 通过修改视图的Owner来管理修改权限。

3. superset_meta通过ab_role来关联fab的安全管理功能。



### 7.3.1 fabmanger

 ![image-20191201170256358](../media/ai/dv_superset_002.png)

 

### 7.3.2 superset meta

**1）SQL_ALL**

 ![image-20191201170320110](../media/ai/dv_superset_003.png)

 

**2）datasources**

![image-20191201170339236](../media/ai/dv_superset_004.png) 

 

3) slice/dashboard

 ![image-20191201170353037](../media/ai/dv_superset_005.png)

 

4) other

 ![image-20191201170410559](../media/ai/dv_superset_006.png)

 

# 8    superset组件分析

## 8.1   整体流程
1. npm run dev --将每个模块打包成一个单独的js文件（在webpack.config.js中配置）
2. superset runserver  --启动服务
3. 浏览器登录
4. 点击某一菜单
5. wsgi 将请求重定向到python侧，执行views/core.py中的对应函数
6. core.py中的函数用render_template构造html页面（render_template的参数entry用户指定所需的js文件，此文件即npm打包而成的单一js）
7. 浏览器render后端返回的html页面

 

**npm打包流程**

打包的依据是assets/webpack.config.js文件中的配置。

 

## 8.2   flask

详见 《WEB框架分析》

 

## 8.3   D3/NVD3

详见 《WEB框架分析》

 

数值格式：D3.format('d') https://github.com/d3/d3-format/blob/master/README.md#format 

 

# 9    源码分析

 

# 参考资料

[1].   superset官网源码 https://github.com/apache/incubator-superset/

[2].   superset的缓存配置 https://blog.csdn.net/qq_33440665/article/details/65628551

[3].   知乎专栏-superset开发 https://zhuanlan.zhihu.com/c_100045590

[4].   [Flask-AppBuilder官方文档](http://flask-appbuilder.readthedocs.io/en/latest/index.html) 

[5].   flask-appbuilder  http://flask-appbuilder.readthedocs.io/en/latest/config.html

[6].   利用Flask-AppBuilder 快速构建Web后台管理应用https://blog.csdn.net/oxuzhenyi/article/details/77586500

