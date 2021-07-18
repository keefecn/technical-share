| 序号 | 修改时间  | 修改内容                               | 修改人 | 审稿人 |
| ---- | --------- | -------------------------------------- | ------ | ------ |
| 1    | 2018-5-5  | 创建，从《BI专题》迁移至此。           | Keefe  |        |
| 2    | 2021-6-11 | 调整部分内容，全文迁移到源码剖析目录。 | 同上   |        |
| 3    | 2021-6-21 | 更新superset-1.0的相关内容。           | 同上   |        |
| 4    | 2021-7-18 | 源码剖析章节另文                       | 同上   |        |











---

[TOC]



---



# 1 简介

官网： https://superset.apache.org/

API文档： https://superset.apache.org/docs/rest-api

下载： https://dist.apache.org/repos/dist/release/superset/

**github代码仓库**

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
| 1.2   | 2021-7-    |                                                         |
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

**关键术语**

*  Dashboard（仪表盘、看板）：由多个Slice组合而成。
*  Slice（切片）：即Chart。Slice就是配置好数据表的图表。一个Slice指向一个数据表和一种图表类型Chart。
*  Dataset 数据集：有时也称数据表table。数据表可以是数据源里的物理单表，也可以是多表关联查询而成的子查询虚拟表，另外也可导入CSV文件作为数据表。
*  Datasource 数据源：有时也称数据库database。支持11+种数据源和文件CSV格式。

 说明：从数据顺序流来看，先有数据源，再有数据集，再有Slice，然后若干个Slice组合在一起形成看板。



**其它术语**

* 注解层



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

- Linux Fedore/RHL: ` yum install gcc gcc-c++ libffi-devel python-devel python-pip python-wheel openssl-devel cyrus-sasl-devel openldap-devel`
- windows: `python-geohash pillow mysqlclient cryptograph`



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
pip install superset --upgrade
```



本地版本更新安装：

```shell
# 激活虚拟环境，本地安装
$ source xx/bin/activate
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

# Create default roles and permissions
superset init

# Load some data to play with. 可选
superset load-examples
```



**更新版本**

```shell
# 更新版本时先执行此命令，再进行服务器启动
superset db upgrade

# 打包: 后端打包到dist目录
python setup.py sdist
```



**3. 服务器启动**

后端： 直接 run 或者 用gunicorn/uwsgi启动

```shell
# 启动法1：superset run启动 指定端口 -d调试；-p监听端口，缺省8088. 0.x用的runserver,
set SUPERSET_CONFIG_PATH=%SUPERSET_PATH%\superset\superset_config.py
superset run -d -h 0.0.0.0 -p 8088 --with-threads --reload

# 启动法2：flask run启动，命令参数superset. 会导入当前目录下的$FLASK_APP模块，搜索路径优先当前路径
export FLASK_APP=superset
flask run 
```



**查看页面，缺省端口8088**

http://localhost:8088



**4. 前端构建**： 可用npm或者yarn构建打包，生成的包在 superset/static/assets目录

```shell
# 前端：superset-1.0 要求"node": ">= 12.18.3 < 13", "npm": ">= 6.14.8"
$cd superset-frontend

# 法1：npm安装：开发环境依赖包
$ npm ci & npm run build
# 或者 js_build.sh会进行代码检查、单元测试后再build（时间20min+）
$ bash ./js_build.sh 

# 法2： yarn
yarn & yarn run build
```



## 2.2 支持数据源

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



## 2.3 支持图表

38+张图表

| 图表类别 | 图表英文名         | 图表中文名         | 用途 | 支持情况 |
| -------- | ------------------ | ------------------ | ---- | -------- |
| 常用图表 | line               | 线图               |      | √        |
|          | histogram          | 直方图             |      | √        |
|          | table              | 表                 |      | √        |
|          | filter_box         | 筛选盒             |      | √        |
|          | dist_bar           | 柱状图             |      | √        |
|          | area               | 面积图             |      | √        |
|          | pie                | 饼图               |      | √        |
|          | pivot_table        | 透视表             |      | √        |
|          | country_map        | 国家地图           |      | √        |
|          | world_map          | 世界地图           |      | √        |
| 时间序列 | bar                | 时间序列柱状图     |      | √        |
|          | time_table         | 时间序列表         |      | √        |
|          | time_pivot         | 时间序列周期轴     |      | √        |
|          | echarts_timeseries | 时间序列           |      | √        |
|          | compare            | 时间序列百分比变化 |      | √        |
|          | cal_heatmap        | 时间热力图         |      | √        |
|          | big_number_total   | 数字               |      | √        |
| 趋势类   | big_number         | 数字和趋势线       |      | √        |
|          | heatmap            | 热力图             |      | √        |
|          | dual_line          | 双线图             |      | √        |
|          | line_multi         | 多线图             |      | √        |
|          |                    |                    |      | √        |
| 复杂图   | rose               | 夜莺玫瑰图         |      | √        |
|          | bubble             | 气泡图             |      | √        |
|          | treemap            | 树状图             |      | √        |
|          | box_plot           | 箱线图             |      | √        |
|          | sunburst           | 旭日图             |      | √        |
|          | sankey             | 桑基图             |      | √        |
|          | word_cloud         | 词汇云             |      | √        |
|          | mapbox             | 地图盒             |      | √        |
|          | partition          | 分区图             |      | √        |
|          | event_flow         | 事件流             |      | √        |
|          | deck_path          | 平面路径图         |      | √        |
|          | directed_force     | 力导向图           |      | √        |
|          | bullet             | 子弹图             |      | √        |
|          | paired_ttest       | paired_ttest       |      | √        |
|          | para               | 平行坐标           |      | √        |
|          | chord              | 弦图               |      | √        |
|          | horizon            | 范围图             |      | √        |
| deck图   | deck_polygon       | 多边形装饰         |      |          |
|          | deck_arc           | 3D路径图           |      |          |
|          | deck_screengrid    | deck_screengrid    |      |          |
|          | deck_scatter       | 散射图             |      |          |
|          | deck_hex           | deck_hex           |      |          |
|          | deck_multi         | deck_multi         |      |          |
|          | deck_grid          | deck_grid          |      |          |
|          | deck_geojson       | deck_geojson       |      |          |



JSON串

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
      "deck.gl Arc": ["DECK 3D路径图"],
      "deck.gl Path": ["DECK平面路径图"],   
      "deck.gl Polygon": ["DECK多边形"],
      "deck.gl Scatterplot": ["DECK散射点图"],
      "deck.gl Grid": ["DECK网格图"],
      "deck.gl Screen Grid": ["DECK网格图2"],	
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







## 2.4 基本功能

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

 

### 邮件告警





# 3 开发篇

## 3.1 开发者必知

* 私有版本和官方版本的合并 [Superset：合并私有版本和Airbnb官方版本（一）](http://zhuanlan.zhihu.com/p/27207957)

 

### **本地调试（pycharm）**

**法1： Pycharm专业版：选择FLASK_SERVER**

```ini
Target:  {SUPERTSET_PATH}\superset\app.py
Additional option:  -h 0.0.0.0
FLASK_ENV:  development
```

![image-20210625090202608](.\superset_debug_pycharm.png)



**法2：(推荐) Pycharm社区版，选择 python**

```ini
Module name: superset.run 或者 flask/suerset
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



## 3.2 API

官方接口文档：  https://superset.apache.org/docs/rest-api   (flask_appbuild模块实现FAB_API_SWAGGER_UI )

**路由映射方法 **

* 主要使用 flask_appbuild 模块提供的装饰器:  expose 和 expose_api
  * expose   路由会在父路由基础上添加，如 expose('expore_json')，实际上指向 /superset/explore_json
  * （没用到）expose_api 用于API，返回JSON。如/api/v1/xxx
  
* xxAPP.route:  flask原生路由，仅用于 /healthy

* RestApi的路由前缀：`{route_base}`  或者 `/api/{version}/{resource_name}`  ，如 /api/v1/chart/

* ModelView的路由前缀：/superset/{route_base}，如 /superset/explore_json



请求响应结果格式，有二种：

  * JSON格式：页面局部更新。
  * HTML格式：每个页面都是一个单独HTML，页面名称可参见 webpack.config.js里的entry。需用到模板，页面全部更新。

API实现： superset API实现在各个目录下的api.py

备注：下面查询参数里的字符串 xxx表示 某个具体的查询字符串。



**Rison**:  查询参数格式示例



表格 superset API列表

| API类别            | API路径                     | API说明      |
| ------------------ | --------------------------- | ------------ |
| Annotaion Layers   | /annotaion_layers/          |              |
| AsyncEventsRestApi | /async_event/               | 异步查询事件 |
| CacheRestApi       | /cachekey/invalidate        |              |
| Charts             | /chart/                     |              |
| CSS Templates      | /css_template/              |              |
| Dashboards         | /dashboard/                 |              |
| Databases          | /database/                  |              |
| Datasets           | /dataset/                   |              |
| LogRestApi         | /log/                       |              |
| Menu               | /menu/                      |              |
| OpenApi            | /openapi/{version}/_openapi |              |
| Queries            | /query/                     |              |
| Report Schedules   | /report/                    |              |
| Security           | /security/                  |              |



**常用参数**

* standalone:  true/false，是否网页外嵌，适用于看板和图表页
* force:  true/false, 是否强制刷新，适用于看板和图表的数据查询



### explore系列

/superset/models/xx.py

这个目录下生成的路由都是以 /superset开头的。



### 图表 Chart列表页

此页是为了展示 模型列表。

![image-20210702145252701](..\..\media\code\code_superset_001.png)

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
| /api/v1/dataset/        | 数据集列表   |      | ?q=(order_column:changed_on_delta_humanized,order_direction:asc,page:0,page_size:20) |                               |                                                              |
| /api/v1/dataset/_info   | 权限信息     |      | ?q=(keys:!(permissions))                                     |                               |                                                              |
| /api/v1/chart/data      | 查看图表数据 | POST | ?form_data=%7B%22slice_id%22%3A437%7D                        | result_type: results或samples |                                                              |
| /superset/explore_json/ | 数据查询结果 |      | /?form_data=%7B%22slice_id%22%3A464%7D&result=true           | form_data, result是否展示     |                                                              |
|                         |              |      |                                                              |                               |                                                              |

说明：

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

| 修改项                 | 前端修改react  /superset-frondend/                       | 后端修改python  /superset/             | 备注            |
| ---------------------- | -------------------------------------------------------- | -------------------------------------- | --------------- |
| 字符符国际化           | tsx,jsx文件里需要国际化的字符串加 t()                    | py,html文件里需要国际化的字符串加 __() | 详见 国际化章节 |
| 列表页修改默认排序字段 | 传参时修改页面呈现字段：ChartList.tsx  DashboardList.tsx | 不传参修改缺省字段                     |                 |
|                        |                                                          |                                        |                 |
|                        |                                                          |                                        |                 |

说明：上面表格中出现的xx表示要修改的内容。



### 国际化

实现原理：flask_babel --> babel

配置文件 config.py

 ```python
# Setup default language 缺省语种，flask_babel模块所需变量
BABEL_DEFAULT_LOCALE = 'zh'
 ```



中文化修改细则: 

| 页面     | 类别                        | 字符串                                                       | 字符串位置 示例                                              | 修改tag | 修改方法                                      | 效果   |
| -------- | --------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------- | --------------------------------------------- | ------ |
| ALL      | 普通修改                    |                                                              | .py .html .tsx .js .jsx                                      | __或t   | 修改message.json相应项                        | OK     |
| 导航菜单 | 服务端 py                   | Data Datasets Databases Charts Dashboard "SQL Lab" "Saved Query"  Settings | app.py add_link/add_view里的label=__("Datasets"),            | __      | 修改flask_appbulder下的po文件，再转成mo文件。 | OK     |
|          | 服务端 html                 | "SQL Query"                                                  | /templates/appbuuilder/nav_right.html                        | __      | 修改 message.json                             | OK     |
|          | flask_appbulder             | Security "User info"                                         | flask_appbuilder/security/views.py:141 lazy_gettext("User info") | t       | 修改flask_appbulder下的po文件，再转成mo文件。 | OK     |
|          | ?                           | Version                                                      | ？                                                           |         |                                               | 不生效 |
|          | 客户端 tsx                  | About                                                        | /src/component/menu/Menu.tsx                                 | t       |                                               | OK     |
| 首页     | 首页右侧按钮                | "VIEW ALL" "SQL QUERY" DASHBOARD                             | /src/views/CRUD/welcome/xx.tsx<br>                           | 缺      | 需改造 代码，加t                              |        |
| 列表页   | 列表页右侧按钮              | "BULK SELECT"                                                | /src/views/xx.tsx<br>name: t('Bulk select'),                 | t       |                                               | OK     |
|          | 列表页过滤字段              | All Any                                                      | ChartList.tsx DashboardList.tsx                              | 缺      | 需改造 代码，加t                              |        |
|          | 列表页过滤/排序字段(带空格) | "Created By" "Modified By"                                   | ChartList.tsx DashboardList.tsx <BR>代码字段名是：<br/>`Header: t('Created by'),` | t       | Created By->Created by                        | OK     |
|          | 列表页过滤/排序字段(无空格) | Modified Search Actions Favorite Dataset                     | Header: t('Favorite'),                                       | t       |                                               | OK     |
|          | 列表页过滤字段下拉框值      | 图表类型的下拉框值                                           | 格式如 "Event Flow" "MapBox"                                 | t       | 修改message.json相应项                        | OK     |
| 图表     | 时间下拉框                  | "Adaptative formating"                                       | 前端                                                         | 缺      | 需改造 代码，加t                              |        |
|          | 时间格式                    |                                                              | control.jsx DataFilterControl.jsx                            | t       |                                               | OK     |
|          | 时间序列图                  | "Weekly seasonality"                                         | @superset-ui包                                               |         | 需改造 代码，加t                              |        |
| 看板     | 排序下拉框                  | Sort by Recent                                               | SliceAdder.jsx  Sort by {label}                              |         | 需改造 代码，加t                              |        |
|          | 图表类型                    | pie table word_cloud ...                                     | AddSliceCard.jsx <br>`<span>{visType}</span>`                | 缺      | 需改造 代码，加t                              |        |

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

  * @superset-ui:  xx.jsx 使用 t，t支持格式化字符串

  ```jsx
  import {t, validateNonEmpty} from '@superset-ui/core';
  
  color_scheme: {
      type: 'ColorSchemeControl',
      label: t('Color scheme'),
  	description: t('The color scheme for rendering chart'),
      label_t : t('Calculated column [%s] requires an expression', col.column_name),  //支持t 带格式化符     
  }
  ```

* **修改方法**：
  
  * superset的translation： messages.json直接修改。或者修改messages.po，然后工具转化成json。修改后重启python服务即生效。
  * flask_appbuilder的translation:  messages.mo才能生效，因此修改po文件后要用工具转成mo格式。导航菜单这部分直接使用fab权限，因此要把菜单字段值添加到/flask_appbuilder/tranlations目录下相应文件才生效。



主要修改二部分

1. **基础国际化**

参见  上面修改方法。

pot/po/mo/json格式转化流程如下：

```shell
# 安装pybabel
$ pip install babel

# step1: 生成pot/po格式 （pot和po格式类似）
# 从babel.cfg配置的文件里提取 message.pot (-k参数可忽略,默认识别标鉴_ __ t）, 要在superset父目录执行命令才能提取到babel.cfg里配置的文件
# NOTE: pybabel不能保证完全提取 -k参数中的内容，若有遗漏需要自行添加到PO文件里
$ cd $SUPERSET_HOME
$ pybabel extract -F superset/translations/babel.cfg -k _ -k __ -k t -k tn -k tct -o superset/translations/messages.pot .
# 将 .pot转化成 .po格式， -d指向生成目录，-l指向语种，下例中生成文件在 translations/zh/message.po
$ pybabel init -i messages.pot -d translations -l zh

# step2: 人工翻译 messages.po


# step3: po需要转化成 mo 或 json才能被使用
# 编译 .po -> .mo 
# (OK)法1：pybable -d 编译目标目录，-l 语种。要求指定目录的里层结构是$locale/LC_MESSAGES/xx.po
$ pybabel compile -d translations -l zh
#  法2：linux工具msgfmt
$ msgfmt ./messages.po -o ./messages.mo

# 编辑 .po -> .json
# (OK推荐)js实现的po2json：npm install po2json -g, 参数-d domain, -f format -p pretty
$ po2json -d superset -f jed1.x -p ./messages.po ./messages.json

# python实现的po2json: pip install po2json
# (OK)linux终端下执行成功：po2json [locale_path] [output_path] [domain]， output_path目录要求有语种对应的js如zh.js
$ po2json translate2 translate messages
# windows下执行没报错，也没生成文件: -X 指定编码，windows终端缺省编码是gbk会报编码错误。将po2json目录下__init__.py复制为main.py
$ python -X utf8 -m po2json.main translations2 translations messages
```



babel.cfg 示例

```ini
[ignore: superset-frontend/node_modules/**]
[python: superset/**.py]
[jinja2: superset/**/templates/**.html]
[javascript: superset-frontend/src/**.js]
[javascript: superset-frontend/src/**.jsx]
[javascript: superset-frontend/src/**.tsx]

encoding = utf-8
```

说明：上面配置放弃了superset-frontend/node_module/，实际@superset-ui模块有好多显示字符串。下面三个目录合计返回约2307次。

* superset/目录下，搜索 ` _("` 返回匹配次数774次。
* superset-frontend/src/目录下，搜索` t(`  返回匹配次数645次。
* superset-frontend/node_module/@superset-ui/目录下，搜索` t(`  返回匹配次数888次，排重后618次。



**messages.po示例**

纯文本格式，三行内容（第一行变量位置，第二行msgid-字符串值，第三行msgstr-翻译串）

```ini
# Chinese translations for Apache Superset.
msgid ""
msgstr ""
"Project-Id-Version: Apache Superset 0.22.1\n"
"Report-Msgid-Bugs-To: zhouyao94@qq.com\n"
"POT-Creation-Date: 2021-01-22 15:56-0300\n"
"PO-Revision-Date: 2019-01-04 22:19+0800\n"
"Last-Translator: \n"
"Language-Team: zh <benedictjin2016@gmail.com>\n"
"Language: zh\n"
"MIME-Version: 1.0\n"
"Content-Type: text/plain; charset=UTF-8\n"
"Content-Transfer-Encoding: 8bit\n"
"Plural-Forms: nplurals=1; plural=0\n"
"Generated-By: Babel 2.8.0\n"

# 说明：纯文本格式，三行内容（第一行变量位置，第二行msgid-字符串值，第三行msgstr-翻译串）。示例如下：
#: superset/app.py:225
msgid "Home"
msgstr ""

#: superset/app.py:230 superset/views/annotations.py:119
msgid "Annotation Layers"
msgstr "注解层"
```



2. **特殊修改**
* 一般情况下字符串要完全匹配，严格区分大小写和符号。 但对于按纽或表单类，经常有作大小写转化，要区别对待。
  * 通常可以用页面显示的英文串作为KEY；如果不生效，再在代码中搜索，用代码中的英文串作KEY。
  
  * 表单类示例：显示"Edit Time Range", 代码"Edit time range"，翻译要用显示Edit Time Range
  
  * 按钮类示例：显示"BULK SELECT"，代码中"Bulk select"，翻译要用代码Bulk select。显示全大写的字符串，试用首字母大写，其它全小写 或者 每个单词首字母大写。
  
  * KEY值尾部带空格：用PO生成的KEY尾部带空格有24个，要注意判断。如
  
    	"Edit Dataset ": ["编辑数据集"],
  
* 尚未用 __或t 圈起来的字符串，需在代码中添加国际化修改操作符。

* 导航菜单的标题字符串，需要在flask_appbuilder模块的translations增加。



### 网页嵌入外部系统

* superset本身已支持的共享项：看板、图表，用standalone=true识别，外部系统要能访问需要开通公共用户权限，并且公共角色需要相关数据源/数据集权限。这个外部系统的共享只能用于公开数据。
* 需要修改布局：看板列表页、图表列表页
* 权限管控的网页嵌入：？



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

5. iframe传参

   图表表单传参JSON串示例如下：

```json
form_data={"datasource":"3__table","viz_type":"line","slice_id":63,"granularity_sqla":"ds","time_grain_sqla":null,"since":"100 years ago","until":"now","metrics":[{"aggregate":"SUM","column":{"column_name":"num_california","expression":"CASE WHEN state = 'CA' THEN num ELSE 0 END"},"expressionType":"SIMPLE","label":"SUM(num_california)"}],"adhoc_filters":[{"expressionType":"SIMPLE","subject":"gender","operator":"==","comparator":"boy","clause":"WHERE","sqlExpression":null,"fromFormData":true,"filterOptionName":"filter_gtzm93u9ocq_9sy5vd5ocfg"},{"expressionType":"SIMPLE","subject":"name","operator":"LIKE","comparator":"Aaron","clause":"WHERE","sqlExpression":null,"fromFormData":true,"filterOptionName":"filter_6cgdixdoh4_5wrgyuorwoa"}],"groupby":["name"],"limit":"10","timeseries_limit_metric":{"aggregate":"SUM","column":{"column_name":"num_california","expression":"CASE WHEN state = 'CA' THEN num ELSE 0 END"},"expressionType":"SIMPLE","label":"SUM(num_california)"},"order_desc":true,"contribution":false,"row_limit":50000,"color_scheme":"bnbColors","show_brush":"auto","show_legend":true,"rich_tooltip":true,"show_markers":false,"line_interpolation":"linear","x_axis_label":"","bottom_margin":"auto","x_ticks_layout":"auto","x_axis_format":"smart_date","x_axis_showminmax":false,"y_axis_label":"","left_margin":"auto","y_axis_showminmax":false,"y_log_scale":false,"y_axis_format":".3s","y_axis_bounds":[null,null],"rolling_type":"None","time_compare":[],"num_period_compare":"","period_ratio_type":"growth","resample_how":null,"resample_rule":null,"resample_fillmethod":null,"annotation_layers":[],"compare_lag":"10","compare_suffix":"o10Y","markup_type":"markdown","metric":"sum__num","where":"","url_params":{}}
```



看板示例URL： http://localhost:5000/superset/dashboard/1/?standalone=true

图板示例URL：http://localhost:5000/superset/explore/?r=5&standalone=true&height=400



**存在问题**：嵌入页面缺少鉴权，存在数据泄露问题。



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



### 下钻

参见  

* Superset 表格下钻(基于时间维度,地域维度和普通维度) https://blog.csdn.net/tb77506668/article/details/107717258

* Superset 0.28三奏曲——安装、集成ECharts和汉化（包括中国地图下钻） https://blog.csdn.net/qq_33703137/article/details/87874277?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-2.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-2.control



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

备注：权限和被管对象通过表`ab_permission_view`关联起来。

 

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

**配置文件的优先级**:  xx/superset_config.py >  superset/config.py (即superset.config)  （详见下文源码分析 相关章节）

**环境变量**： 

* PYTHONPATH  python模块搜索路径，如果部署包不在虚拟环境的site-packages下，那么应该设置此值。用flask run启动会自动搜索当前路径是否有app，如果当前目录内能搜索到，则可避免设置此值。
* SUPERSET_HOME    元数据文件和日志文件目录，影响到变量DATA_DIR
* SUPERSET_CONFIG_PATH   superset用户自定义配置文件路径（文件名可以命名为superset_config.py，文件路径可以自定义，无需放在superset目录），此路径会赋值给CONFIG_PATH_ENV_VAR。此配置文件要生效，需要显式设置此环境变量。
* SUPERSET_CONFIG  superset配置文件路径，缺省为superset.config (即superset/config.py)
* FLASK_ENV  设置是否调试 development/production，缺省development是debug模式  （用FLASK_开头的变量通常是flask模块内置支持的环境变量，如FLASK_APP，FLASK_ENV，FLASK_DEBUG）。
* MAPBOX_API_KEY  是否支持MAPBOX可视化，缺省False



**/superset/config.py**  （一般不修改这个文件，文件行数约1000多行，去除注释和空格约400行）

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



 /superset/superset_config.py  

用户个性化部分修改示例：

 ```python
from dateutil import tz


APP_NAME = "DataLab"

# The SQLAlchemy connection string.
SQLALCHEMY_DATABASE_URI = 'mysql://root:xxxxxx@127.0.0.1/superset_1.0'

# [TimeZone List]
DRUID_TZ = tz.gettz('Asia/Shanghai')

# Setup default language  中文
BABEL_DEFAULT_LOCALE = "zh"

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
# 公共用户角色默认是GAMMA, 可读
PUBLIC_ROLE_LIKE_GAMMA=True
# 避免iframe跨站访问问题
HTTP_HEADERS: Dict[str, Any] = {"X-Frame-Options" : "SAMEORIGON" }   
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
*  删除图表会影响到看板，删除看板不会影响到图表。

 



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

表格 superset元数据的来源模块说明

| 模块                   | 次模块或命令                 | *说明*                                                       |
| ---------------------- | ---------------------------- | ------------------------------------------------------------ |
| Flask  Appbuilder(fab) | `superset fab create-admin`  | 创建角色和管理员用户。1.x用superset fab替换fabmanger。<br>共创建8张表，以ab_开头。  user  -> role -> premission_view-> (permission, view_menu) |
| superset meta          | `superset db upgrade`        | 数据库初始化（版本更新时也要执行此命令）。<br>共创建24张表。v1.x增加到47张表。 |
|                        | datasources:  druid/database | 共8张。数据源包括两种组织形式：druid 和 database  <br>druid:  cluster - datasources - columns/metrics  <br>database：dbs - tables -  tablecolumn/sql_metrics |
|                        | views:    slice/dashboard    | 共7张。<br>slice：slices slice_user  slice_dashboard <br>dashboard:  dashboard dashboard_user |
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

原因：缺少各种开发库如openssl-devel

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

**解决方法1**（推荐superset后续版本）：将superset/typing.py 改名 superset/superset_typing.py ，并修改相关多处导入 

` from superset.typing 处改为 from superset.superset_typing

重命名superset目录下的typing.py文件为superset_typing.py：该文件与python3自带的模块typing重名，不修改会导致项目运行报错。注意使用Shitf + F6选项来更新文件名，pycharm 会自动更新被引用位置的名字。

**解决方法2**：在pycarm terminal定义`PYTHONPATH`为当前脚本路径，则在pycharm termianl启动没问题。但在pycahrm run/debug方式启动仍然报错（估计是 PYTHONPATH路径未在整个pycharm生效）。



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
*  boostrap中文网  https://www.bootcss.com/
*  webpack中文文档 https://www.webpackjs.com/concepts/
*  babel中文文档 https://www.babeljs.cn/
*  react官网中文文档  https://zh-hans.reactjs.org



**参考链接**

*  中文文档  https://docschina.org/
*  superset的缓存配置 https://blog.csdn.net/qq_33440665/article/details/65628551
*  增加自定义数据源 https://zhuanlan.zhihu.com/p/179162221 
*  利用Flask-AppBuilder 快速构建Web后台管理应用 https://blog.csdn.net/oxuzhenyi/article/details/77586500
* Superset 1.0 终于发布了 https://cloud.tencent.com/developer/article/1823370
* Superset 表格下钻(基于时间维度,地域维度和普通维度) https://blog.csdn.net/tb77506668/article/details/107717258
* 如何将Superset嵌入后台系统之实践 https://www.yisu.com/zixun/58300.html
* superset、metabase、redash三个开源BI工具的个人使用心得及分析 https://blog.csdn.net/weixin_42473019/article/details/105419781

