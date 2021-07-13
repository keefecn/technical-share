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
*  Slice（切片）：即Chart。Slice就是配置好数据表的图表。一个Slice指向一个数据表和一种图表类型Chart。
*  Dataset 数据集：有时也称数据表table。数据表可以是数据源里的物理单表，也可以是多表关联查询而成的子查询虚拟表，另外也可导入CSV文件作为数据表。
*  Datasource 数据源：有时也称数据库database。支持11+种数据源和文件CSV格式。

 说明：从数据顺序流来看，先有数据源，再有数据集，再有Slice，然后若干个Slice组合在一起形成看板。



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

安装版本： superset-0.x

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



安装版本：apache-superset-1.x

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
| 常用类   | line               | 线图               |      | √        |
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

 

# 3 开发篇

## 3.1 开发者必知

* 私有版本和官方版本的合并 [Superset：合并私有版本和Airbnb官方版本（一）](http://zhuanlan.zhihu.com/p/27207957)

 

## 3.2 API

官方接口文档：  https://superset.apache.org/docs/rest-api   (flask_appbuild模块实现FAB_API_SWAGGER_UI )

路由映射方法 

* 主要使用 flask_appbuild 模块提供的装饰器:  expose 和 expose_api
  * expose   路由会在父路由基础上添加，如 expose('expore_json')，实际上指向 /superset/explore_json
  * （没用到）expose_api 用于API，返回JSON。如/api/v1/xxx
* xxAPP.route:  flask原生路由，仅用于 /healthy
* RestApi的路由前缀：`{route_base}`  或者 `/api/{version}/{resource_name}`  ，如 /api/v1/chart/
* ModelView的路由前缀：/superset/{route_base}，如 /superset/explore_json
* 路由返回结果有二种，一是返回JSON格式；二是HTML，用到模板。

API实现： superset API实现在各个目录下的api.py

备注：下面查询参数里的字符串 xxx表示 某个具体的查询字符串。



表格 superset API列表

| API类别            | API路径                     | API说明 |
| ------------------ | --------------------------- | ------- |
| Annotaion Layers   | /annotaion_layers/          |         |
| AsyncEventsRestApi | /async_event/               |         |
| CacheRestApi       | /cachekey/invalidate        |         |
| Charts             | /chart/                     |         |
| CSS Templates      | /css_template/              |         |
| Dashboards         | /dashboard/                 |         |
| Database           | /database/                  |         |
| Datasets           | /dataset/                   |         |
| LogRestApi         | /log/                       |         |
| Menu               | /menu/                      |         |
| OpenApi            | /openapi/{version}/_openapi |         |
| Queries            | /query/                     |         |
| Report Schedules   | /report/                    |         |
| Security           | /security/                  |         |



### explore系列

/superset/models/xx.py

这个目录下生成的路由都是以 /superset开头的。



### 图表 Chart列表页

此页是为了展示 模型列表。

![image-20210702145252701](..\..\media\code\code_superset_001.png)

* 图表列表页：/chart/list/?pageIndex=0&sortColumn=changed_on_delta_humanized&sortOrder=desc&viewMode=table

* 图表页：/superset/explore/?form_data=%7B%22slice_id%22%3A%20464%7D

表格 图表列表页所包括的接口

| 接口名                            | 用途           | 详细参数 GET方法                                             | 参数说明                                    | 响应结果                                                     |
| --------------------------------- | -------------- | ------------------------------------------------------------ | ------------------------------------------- | ------------------------------------------------------------ |
| /api/v1/chart/related/owners      | 修改人<br>     | ?q=()                                                        |                                             | {"count":3,"result":[{"text":"adminuser","value":1},{"text":"","value":2},{"text":"","value":3}]} |
| /api/v1/chart/related/created_by  | 创建人         | ?q=()                                                        |                                             | 同上                                                         |
| /api/v1/dataset/                  | 数据集列表     | ?q=(columns:!(datasource_name,datasource_id),keys:!(none),order_column:table_name,order_direction:asc) | order_column排序列，order_direction排序方向 |                                                              |
| /api/v1/chart/                    | 图表列表       | ?q=(order_column:changed_on_delta_humanized,order_direction:desc,page:0,page_size:25) | page, page_size                             |                                                              |
|                                   | 图表列表的过滤 | ?q=(filters:!((col:slice_name,opr:chart_all_text,value:xxx)),) | value                                       |                                                              |
| /api/v1/chart/_info               | 权限信息       | ?q=(keys:!(permissions))                                     |                                             | {"permissions":["can_write","can_read"]}                     |
| /api/v1/chart/favorite_status/    | 收藏状态       | ?q=xxxxxx                                                    |                                             | {"result":[{"id":464,"value":false},{"id":438,"value":false}]} |
|                                   |                |                                                              |                                             |                                                              |
| /superset/explore/                | 图表入口       | ?form_data=%7B%22slice_id%22%3A%20464%7D                     |                                             |                                                              |
| /superset/explore/table/<dbs_id>/ | 数据集入口     |                                                              |                                             |                                                              |
| /superset/profile/<user>          | 修改人入口     |                                                              |                                             |                                                              |

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



### 新增图表页

表格 看板列表页所包括的接口

| 接口名                  | 用途         | 详细参数 GET方法                                             | 参数说明                  | 响应结果                                                     |
| ----------------------- | ------------ | ------------------------------------------------------------ | ------------------------- | ------------------------------------------------------------ |
| /api/v1/time_range/     | 时间区域     | ?q=%E5%91%A8                                                 | 周/                       | {"result": {"since": "", "until": "2021-07-12T00:00:00", "timeRange": "\u5468"}} |
| /api/v1/chart/<id>      | 图表配置信息 |                                                              |                           |                                                              |
| /api/v1/dataset/        | 数据集列表   | ?q=(order_column:changed_on_delta_humanized,order_direction:asc,page:0,page_size:20) |                           |                                                              |
| /api/v1/dataset/_info   | 权限信息     | ?q=(keys:!(permissions))                                     |                           |                                                              |
|                         |              |                                                              |                           |                                                              |
| /superset/explore_json/ | 数据查询结果 | /?form_data=%7B%22slice_id%22%3A464%7D&result=true           | form_data, result是否展示 |                                                              |
|                         |              |                                                              |                           |                                                              |

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

### 国际化

实现原理：flask_babel --> babel

配置文件 config.py

 ```python
# Setup default language 缺省语种，flask_babel模块所需变量
BABEL_DEFAULT_LOCALE = 'zh'
 ```



主要修改二部分

1. 基础汉化

修改 superset/translates/zh/LC_MESSAGES/message.json  （可以通过工具 从message.po转化），这个文件会被前后端都用到。

 流程如下：

```shell
# 使用pybabel：提取 message.pot，再转化成 message.po
$ pybabel extract -F translations\babel.cfg -k _ -k __ -k t -k tn -k tct -o translations\messages.pot .

# step1: 人工翻译 messages.po

# step2: 编译 messages.po -> messages.mo, 可以用 pybabel或者msgfmt 进行转化
$ cd ./superset/translations/zh/LC_MESSAGES
$ pybabel compile -d translations
# 或者
$ msgfmt ./messages.po -o ./messages.mo

# step3: 文件格式转化 message.mo -> message.json, json格式为最后源码加载文件
$ po2json -d superset -f jed1.x ./messages.po ./messages.json
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



2. JSX文件：

   用__ 或者 t 圈起来的可以补充到message.json；没圈起来的修改label, description值即可，修改了需要重新构建。

   示例文件：superset-frontend/explore/controls.jsx

   ```jsx
   color_scheme: {
       type: 'ColorSchemeControl',
       label: t('Color scheme'),	# 译：彩色主题
       default: categoricalSchemeRegistry.getDefaultKey(),
       renderTrigger: true,
       choices: () => categoricalSchemeRegistry.keys().map(s => [s, s]),
       description: t('The color scheme for rendering chart'), # 译：渲染图表用彩色主题
       schemes: () => categoricalSchemeRegistry.getMap(),
     },
   ```


* flask_babel法:  使用 __

  ```jsx
  from flask_babel import gettext as __, lazy_gettext as _
  #汉化语法为
  _('需要汉化的字符')
  
  #按钮需要加上{{  }}才可行。
  {{_('需要汉化的按钮字符')}}
  ```

* @superset-ui:  使用 t

  ```jsx
  import {t, validateNonEmpty} from '@superset-ui/core';
  
  color_scheme: {
      type: 'ColorSchemeControl',
      label: t('Color scheme'),
  	description: t('The color scheme for rendering chart')        
  }
  ```

  

**需要翻译的内容示例**

new 和 SQL Query 在 templates/appbuilder/general/navbar_right.html
filter list和 Refresh 在 templates/appbuilder/general/widgets/search.html



**暂不可翻译的内容**

deck_screengrid



### 网页外部嵌入

嵌入页面缺少鉴权。

图表：

看板：



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

**配置文件的优先级**:  superset_config.py >  superset/config.py (即superset.config)  （详见下文源码分析 相关章节）

**环境变量**： 

* PYTHONPATH  python模块搜索路径，如果部署包不在虚拟环境的site-packages下，那么应该设置此值。用flask run启动会自动搜索当前路径是否有app，如果当前目录内能搜索到，则可避免设置此值。
* SUPERSET_HOME    元数据文件和日志文件目录，影响到变量DATA_DIR
* SUPERSET_CONFIG_PATH   superset配置路径，superset_config.py所在路径，赋值给CONFIG_PATH_ENV_VAR
* SUPERSET_CONFIG  配置文件路径，缺省为superset.config (即superset/config.py)
* FLASK_ENV  设置是否调试 development/prod，缺省development是debug模式  （用FLASK_开头的变量通常是flask模块内置支持的环境变量，如FLASK_APP，FLASK_ENV）。
* MAPBOX_API_KEY  是否支持MAPBOX可视化，缺省False



/superset/config.py  （一般不修改这个文件）

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

# Add endpoints that need to be exempt from CSRF protection 需要CSRF保持的API
WTF_CSRF_EXEMPT_LIST = ["superset.views.core.log", "superset.charts.api.data",
                        "superset.views.core.explore_json"]

# Superset allows server-side python stacktraces to be surfaced to the
# user when this feature is on. This may has security implications
# and it's more secure to turn it off in production settings.
SHOW_STACKTRACE = True

# Will allow user self registration 是否允许用户注册
AUTH_USER_REGISTRATION = True

# The default user self registration role 缺省用户角色
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

 



# 6 源码分析篇

源码分析版本： superset-1.0

```shell
$ pip show superset
Name: superset
Version: 0.30.1
Summary: Superset has moved to apache-superset, as of 0.34.0 onwards, please pip install apache-superset
Home-page: https://superset.apache.org/
Author: Apache Software Foundation
Author-email: dev@superset.incubator.apache.org
License: Apache License, Version 2.0
Location: /home/keefe/venv/superset-py36-env/lib/python3.6/site-packages
Requires: flask, boto3, gunicorn, python-dateutil, simplejson, future, contextlib2, pandas, pyyaml, bleach, colorama, pydruid, flask-migrate, python-geohash, sq
lalchemy-utils, thrift, sqlparse, pathlib2, sqlalchemy, unidecode, celery, flask-compress, geopy, humanize, cryptography, parsedatetime, flower, flask-appbuilder, requests, six, unicodecsv, polyline, flask-testing, flask-wtf, markdown, thrift-sasl, pyhive, flask-script, idna, flask-caching
Required-by: 
```



 ## 6.1 源码结构 

表格  项目顶层目录结构

| 目录                  | 二级目录或文件                 | 简介                                                         |
| --------------------- | ------------------------------ | ------------------------------------------------------------ |
| dist                  | xx.tar.gz                      | 打包时`python setup.py sdist`自动生成                        |
| docker                |                                | docker相关的脚本                                             |
| helm                  |                                | helm镜像仓库的配置目录                                       |
| RELEASING             |                                | 发布日志                                                     |
| requirements          |                                | 各种安装方式的模块依赖文件                                   |
| tests                 |                                | 测试目录                                                     |
| docs                  |                                | 文档，使用spinx生成                                          |
| scripts               | pypi_push.sh   python_tests.sh | superset常用的脚本                                           |
|                       | setup.py setup.cfg             | 部署常用的一些文件。  requirement.txt 组件需求，pip freeze   README.md     CHANGELOG.md |
| **superset**          |                                | superse后端源码目录                                          |
| **superset-frontend** |                                | superset前端源码目录                                         |
| CHANGELOG.md          |                                | 版本更新日志                                                 |
| setup.py setup.cfg    |                                | 安装脚本，包括了依赖组件                                     |

 

表格  源码后端目录superset里的结构

| 目录或文件        | 次模块                                       | 简介                                                         |
| ----------------- | -------------------------------------------- | ------------------------------------------------------------ |
| annotation_layers |                                              | 锚点层                                                       |
| (弃) assets       |                                              | 前端依赖框架集成，这里存放了npm集成的依赖js框架，当你打开后会看到node_modules文件夹，由npm动态生成，命令是`$ npm run dev-fast`<br>1.x版本已将此目录移到外层，改为superset-frontend |
| async_events      |                                              | 异步事件                                                     |
| cachekeys         |                                              | 缓存键K-V                                                    |
| charts            | api.py dao.py filters.py schemas.py          | 图表的API，数据库操作、过滤处理、解析查询参数的JSON项        |
| commands          | BaseCommand ExportModelsCommand              | 支持的命令                                                   |
| common            |                                              |                                                              |
| connectors        |                                              | 数据库连接器，连接数据源有2种类型，通过ConnectorRegistry连接 |
| db_engines        |                                              | DB引擎                                                       |
| dao               | BaseDAO DAOException                         | 数据访问基类、数据访问异常类                                 |
| dashboards        |                                              | 看板。结构类似图表。                                         |
| databases         |                                              | 数据库dbs/数据源。结构类似图表。                             |
| datasets          |                                              | 数据集。结构类似图表。                                       |
| db_engines        |                                              | 0.x时就有的目录。连接其他数据库的engines 比如mysql，pgsql等  |
| db_engine_spec    |                                              | 同上                                                         |
| examples          |                                              | 17个示例数据集，用 superset load-examples加载，需从网络下载  |
| migrations        |                                              | 做数据迁移用的，比如更新数据库，更新ORM(model和表中字段的映射关系)。 |
| models            |                                              | 存放项目的model，如果要修改字段，优先到这里寻找。            |
| quaries           |                                              | 查询SQL相关。结构类似图表。                                  |
| reports           |                                              | 报表相关。结构类似图表。                                     |
| security          | SupersetSecurityManager  DBSecurityException | 安全权限管理                                                 |
| sql_validators    |                                              | SQL验证                                                      |
| **static**        | assets                                       | 存放静态文件的目录，比如我们用到的css、js、图片等静态文件都在这里。superset-frontend前端构建打包后生成的文件放到这。 |
| tasks             |                                              | celery 任务脚本                                              |
| **templates**     | appbuilder, email, slack, superset           | JinJa2模板目录，几乎项目所有的HTML文件都在这里。<br>superset/basic.html提供web整体的样式风格。<br>appbuilder/navbar_menu.html导航菜单 |
| translations      | zh en ...                                    | 翻译文件，只需修改字段对应的名称。                           |
| utils             |                                              | 工具                                                         |
| views             | health.py  core.py                           | 视图文件，这里定义了url，来作为前端的入口。  <br>core.py中的函数在渲染页面时，都要指定basic.html模板为基础。 |
| app.py            | create_app                                   | WEB实例初始化，也是调试入口                                  |
| cli.py            |                                              | superset命令                                                 |
| viz.py            | BaseViz NVD3Viz viz_types                    | 可视化图表类型的基类及派生类。viz_sip38.py是替换版本。       |
| extensions.py     |                                              | 定义 celery， logger 等中间件                                |

 >superset后端用到的组件主要有：flask_appbuilder, flask_sqlalchemy, Jinja2, pandas



表格  前端目录superset-frontend源码结构

| 目录或文件        | 二级目录或文件 | 简介                                                         |
| ----------------- | -------------- | ------------------------------------------------------------ |
| .eslintrc.js      |                | eslint配置文件                                               |
| babel.config.js   |                | babel配置文件。可将jsx文件编译成js。                         |
| package.json      |                | 前端模块依赖，用npm/yarn管理                                 |
| webpack.config.js |                | webpack构建配置文件。前端入口文件。<br>定义了 以src文件夹去生成打包js文件。 |
| src               |                | 源码                                                         |
|                   | components     | 组件                                                         |
|                   | explore        | 菜单数据探索 生成图表的表单项相关。<br>controls.jsx 表单项列表 |
|                   | filters        | 过滤器                                                       |
|                   | visualizations | 可视化图表类型实现                                           |
|                   | views          | 各个页面的控制逻辑，如/welcome/是首页                        |
|                   | ...            |                                                              |
| branding          |                | 存放项目logo                                                 |
| cypress-base      | cypress        | UI自动化测试框架                                             |
| images            |                | 图片                                                         |
| spec              |                |                                                              |
| stylesheets       |                |                                                              |

> superset前端用到的组件主要有：React, D3



## 6.2 组件概述 

**依赖组件**：

前端组件

*  React：交互
*  Jinja2：模板引擎
*  D3/NVD3：图表

后端组件

*  Flask：web服务框架
*  SQLALchemy：数据访问
*  Pandas：数据结果展示



**整体流程**

1. npm run dev --将每个模块打包成一个单独的js文件（在webpack.config.js中配置）
2. superset run  --启动http服务
3. 浏览器登录  --记录cookie
4. 点击某一菜单
5. wsgi 将请求重定向到python侧，执行views/core.py中的对应函数
6. core.py中的函数用render_template构造html页面（render_template的参数entry用户指定所需的js文件，此文件即npm打包而成的单一js）
7. 浏览器render后端返回的html页面



**npm打包流程**

打包的依据是assets/webpack.config.js文件中的配置。



### 前后端联动

**1. 前后端打包**： 

* 后端打包setup.py 取的版本号来自  前端superset-frontend/package.json:  `python setup.py sdist`
* 前端生成的包 在superset/static目录： `npm run build`

前后端分离不能彻底的原因

1. 前端用了Jinja2模板，导航栏菜单是前后端一起来完成的。
2. 前端生成包还不能单独部署到WEB服务器。



#### 扩展 extensions.py

* /superset/extensions.py 包括ResultsBackendManager和UIManifestProcessor，UIManifestProcessort管理前端脚本文件（用到mainfest.json)。
* /superset/static/assets/manifest.json  前端脚本文件信息

/superset/extensions.py

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
    def __init__(self) -> None:
        self._results_backend = None	#后端结果存储
        self._use_msgpack = False		#后端消息队列

    def init_app(self, app: Flask) -> None:
        self._results_backend = app.config["RESULTS_BACKEND"]
        self._use_msgpack = app.config["RESULTS_BACKEND_USE_MSGPACK"]

    @property
    def results_backend(self) -> Optional[BaseCache]:
        return self._results_backend

    @property
    def should_use_msgpack(self) -> bool:
        return self._use_msgpack

    
class UIManifestProcessor:
    """ UI主文件处理器 """
    def __init__(self, app_dir: str) -> None:
        self.app: Optional[Flask] = None
        self.manifest: Dict[str, Dict[str, List[str]]] = {}
        self.manifest_file = f"{app_dir}/static/assets/manifest.json"

    def init_app(self, app: Flask) -> None:
        self.app = app
        # Preload the cache
        self.parse_manifest_json()
        
   def parse_manifest_json(self) -> None:
        try:	# 读取json文件，取值entrypoints
            with open(self.manifest_file, "r") as f:
                full_manifest = json.load(f)
                self.manifest = full_manifest.get("entrypoints", {})
        except Exception:  # pylint: disable=broad-except
            pass
        
        
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



**/superset/static/assets/manifest.json  前端脚本配置**

前端构建时生成，罗列了前端用到的静态文件js/css。entrypoints是入口。

```json
{
  "app": "superset",
  "entrypoints": {
    "theme": {
      "css": [
        "/static/assets/theme.d2b6a75182b640fe1d54.entry.css"
      ],
      "js": [
        "/static/assets/theme.d2b6a75182b640fe1d54.entry.js"
      ]
    },
    "preamble": {
      "css": [],
      "js": [
        "/static/assets/62972ce831e91d2dca0d.chunk.js",
        "/static/assets/dc683cbf32f0aef035a1.chunk.js",
        "/static/assets/preamble.5e6f4a5179518c022dee.entry.js"
      ]
    },
    "addSlice": {
      "css": [
        "/static/assets/addSlice.d41169c29a209c310582.entry.css"
      ],
      "js": [
        "/static/assets/62972ce831e91d2dca0d.chunk.js",
        "/static/assets/1892de5deadee276f4a2.chunk.js",
        "/static/assets/b10f92a903cc38d8427a.chunk.js",
        "/static/assets/addSlice.d41169c29a209c310582.entry.js"
      ]
    },
    "explore": {
      "css": [
        "/static/assets/explore.3d9deffb55fed5cd873e.entry.css"
      ],
      "js": [
        "/static/assets/62972ce831e91d2dca0d.chunk.js",
        "/static/assets/1892de5deadee276f4a2.chunk.js",
        "/static/assets/b10f92a903cc38d8427a.chunk.js",
        "/static/assets/explore.3d9deffb55fed5cd873e.entry.js"
      ]
    },
    "dashboard": {
      "css": [
        "/static/assets/dashboard.ed6e450574e9c2b600ae.entry.css"
      ],
      "js": [
        "/static/assets/62972ce831e91d2dca0d.chunk.js",
        "/static/assets/1892de5deadee276f4a2.chunk.js",
        "/static/assets/b10f92a903cc38d8427a.chunk.js",
        "/static/assets/dashboard.ed6e450574e9c2b600ae.entry.js"
      ]
    },
    "sqllab": {
      "css": [
        "/static/assets/sqllab.3bf302f60a7d158e1af2.entry.css"
      ],
      "js": [
        "/static/assets/62972ce831e91d2dca0d.chunk.js",
        "/static/assets/dc683cbf32f0aef035a1.chunk.js",
        "/static/assets/sqllab.3bf302f60a7d158e1af2.entry.js"
      ]
    },
    "crudViews": {
      "css": [
        "/static/assets/crudViews.25fc76dd77af13aa3e2d.entry.css"
      ],
      "js": [
        "/static/assets/62972ce831e91d2dca0d.chunk.js",
        "/static/assets/1892de5deadee276f4a2.chunk.js",
        "/static/assets/b10f92a903cc38d8427a.chunk.js",
        "/static/assets/crudViews.25fc76dd77af13aa3e2d.entry.js"
      ]
    },
    "menu": {
      "css": [],
      "js": [
        "/static/assets/62972ce831e91d2dca0d.chunk.js",
        "/static/assets/dc683cbf32f0aef035a1.chunk.js",
        "/static/assets/menu.8f8be0ac12b9b0b96090.entry.js"
      ]
    },
    "profile": {
      "css": [
        "/static/assets/profile.be686dc9c5bf9d7c0496.entry.css"
      ],
      "js": [
        "/static/assets/62972ce831e91d2dca0d.chunk.js",
        "/static/assets/dc683cbf32f0aef035a1.chunk.js",
        "/static/assets/profile.be686dc9c5bf9d7c0496.entry.js"
      ]
    },
    "showSavedQuery": {
      "css": [
        "/static/assets/showSavedQuery.852d0a2e94dc0d585568.entry.css"
      ],
      "js": [
        "/static/assets/62972ce831e91d2dca0d.chunk.js",
        "/static/assets/showSavedQuery.852d0a2e94dc0d585568.entry.js"
      ]
    }
  }
}
```



#### 导航栏布局

导航栏指 页面顶层的一排导航菜单项，导航栏进入到各个页面都保持不变

导航栏： `导航左侧navbar   菜单    导航`

* 导航左侧 /superset/templates/appbuilder/navbar.html
* 菜单
* 导航右侧 /superset/templates/appbuilder/navbar_right.html

/superset/templates/appbuilder/navbar.html  

```html
{% set menu = appbuilder.menu %}
{% set app_icon_width = appbuilder.app.config['APP_ICON_WIDTH'] %}
{% set logo_target_path = appbuilder.app.config['LOGO_TARGET_PATH'] or '/profile/{}/'.format(current_user.username) %}
{% set root_path = logo_target_path if not logo_target_path.startswith('/') else '/superset' + logo_target_path if current_user.username is defined else '#'  %}

{% block navbar %}
  <div id="app-menu">
    <div class="navbar navbar-static-top {{menu.extra_classes}}" role="navigation">
      <div class="container-fluid">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="{{ root_path }}">
            <img
              width="{{ app_icon_width }}"
              src="{{ appbuilder.app_icon }}"
              alt="{{ appbuilder.app_name }}"
            />
          </a>
        </div>
      </div>
    </div>
  </div>
{% endblock %}
```



/superset/templates/appbuilder/navbar.html  

```html

```



#### 导航菜单

菜单更改 要涉及到 Jinja2模板的更改，appbuilder菜单权限的管控等。

* /superset/templates/appbuilder/navbar.html  Jinja2模板布局页面
* /superset/app.py  添加菜单链接，调用flask_appbuilder.add_link()
* /superset/views/core.py  添加菜单视图函数
* /superset-frontend/webpack.config.js   前端构建脚本添加入口文件
* superset-frontend/src/xxx/index.js    前端脚本实现逻辑



以菜单项 Datasets 为例

1. /superset/templates/appbuilder/navbar.html  



/superset/app.py  

SupersetAppInitializer.init_views()

```python
# add_link：给菜单添加链接，点击菜单跳转到链接href
appbuilder.add_link(
    "Datasets",
    label=__("Datasets"),
    href="/tablemodelview/list/?_flt_1_is_sqllab_view=y",
    icon="fa-table",
    category="Data",
    category_label=__("Data"),
    category_icon="fa-table",
)
appbuilder.add_separator("Data")
# add_view：增加视图
appbuilder.add_view(
    SliceModelView,
    "Charts",
    label=__("Charts"),
    icon="fa-bar-chart",
    category="",
    category_icon="",
)
```



/superset/views/core.py  添加处理函数

```python
class Superset(BaseSupersetView):
    """The base views for Superset!"""

    logger = logging.getLogger(__name__)
    
    @has_access_api
    @event_logger.log_this
    @expose("/datasources/")  # 实际指向 /superset/datasources/
    def datasources(self) -> FlaskResponse:
        return self.json_response(
            sorted(
                [
                    datasource.short_data
                    for datasource in ConnectorRegistry.get_all_datasources(db.session)
                    if datasource.short_data.get("name")
                ],
                key=lambda datasource: datasource["name"],
            )
        ) 
```



/superset-frontend/webpack.config.js  添加入口文件

 ```js
const config = {
  node: {
    fs: 'empty',
  },
  // entry, 指定src目录下各目录的打包入口
  entry: {
    theme: path.join(APP_DIR, '/src/theme.ts'),
    preamble: PREAMBLE,
    addSlice: addPreamble('/src/addSlice/index.tsx'),
    explore: addPreamble('/src/explore/index.jsx'),
    dashboard: addPreamble('/src/dashboard/index.jsx'),
    sqllab: addPreamble('/src/SqlLab/index.tsx'),
    crudViews: addPreamble('/src/views/index.tsx'),
    menu: addPreamble('src/views/menu.tsx'),
    profile: addPreamble('/src/profile/index.tsx'),
    showSavedQuery: [path.join(APP_DIR, '/src/showSavedQuery/index.jsx')],
  },
}    
 ```



/superset-frontend/src/xxx/index.js  

```js
import React from "react";
import ReactDOM from "react-dom";
import App from "./App";

ReactDOM.render(<App />, document.getElementById("app"));
```





## 6.3 后端 /superset/

### 命令行处理 cli.py

启动命令： `falsk run xxx`  或者  `superset run xxx`

```shell
# superset/releasing/from_tarball_entrypoint.sh
FLASK_ENV=development FLASK_APP="superset.app:create_app()" \
flask run -p 8088 --with-threads --reload --debugger --host=0.0.0.0
```

说明： flask, superset这二个脚本都要在$PATH路径下。

导出 SUPERSET_CONFIG_PATH时，

* flask 若未指定FLASK_APP，将会启用自动搜索识别APP路径（先当前目录，其次SUPSET_CONFIG_PATH所在目录，再site-packages。）。建议使用flask命令前先要 `export FLASK_APP=superset`

* superset run 只能识别 site-packages下的superset目录。



flask 或者 superset 脚本

```python
# -*- coding: utf-8 -*-
import re
import sys

# flask脚本  
from flask.cli import main  # flask脚本入口
if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw|\.exe)?$', '', sys.argv[0])
    sys.exit(main())
    
# 或者 superset脚本    
from superset.cli import superset  # superset脚本入口
if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw|\.exe)?$', '', sys.argv[0])
    sys.exit(superset())
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

说明：1. 上面命令属于flask模块命令组的有run/shell/routes/version，属于flask_appbuild模块命令组有fab，属于flask_migrate模块命令组有db，其它命令属于superset本身命令组。

2. 命令方法名里的_会替换成-，如load_examples替换成load-examples



#### superset load-examples命令

load_examples 加载测试数据，需要从网络上下载数据。

* /superset/cli.py  命令定义
* /superset/examples/helpers.py  实际的样例加载方法

**下载网络失败的解决办法** （官方例子网站不稳定，经常挂）

- 在github上下载官方例子文件 网址：https://github.com/apache-superset/examples-data

- npm安装http-server： `npm install http-server`

- 在examples-data所在的文件下下开启服务，即：http-server

- 修改superset/examples/helpers.py文件，修改 BASE_URL

  ```python
  #根据实际情况填写ip:port
  BASE_URL = "http://ip:8080/examples-data-master/"
  ```

- 最后执行命令： `superset load-examples`

```python
# /superset/cli.py

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
        examples_db = utils.get_example_database()  #创建或加载数据库examples 
        print(f"Loading examples metadata and related data into {examples_db}")

    from superset import examples  #导入examples样例

    examples.load_css_templates()   #从表css_templates加载数据
    
    print("Loading energy related dataset")
	#从表energy_usage获取数据，如果没有，则从网络上下载数据    
    examples.load_energy(only_metadata, force)  
    ...
```



`/superset/examples/__init__.py`    导入了所有的样例数据加载方法 

```python
from .bart_lines import load_bart_lines
from .birth_names import load_birth_names
from .country_map import load_country_map_data
from .css_templates import load_css_templates
from .deck import load_deck_dash
from .energy import load_energy
from .flights import load_flights
from .long_lat import load_long_lat_data
from .misc_dashboard import load_misc_dashboard
from .multi_line import load_multi_line
from .multiformat_time_series import load_multiformat_time_series
from .paris import load_paris_iris_geojson
from .random_time_series import load_random_time_series_data
from .sf_population_polygons import load_sf_population_polygons
from .tabbed_dashboard import load_tabbed_dashboard
from .utils import load_from_configs
from .world_bank import load_world_bank_health_n_pop
```



/superset/examples/helpers.py

```python
from superset import app, db
from superset.connectors.connector_registry import ConnectorRegistry
from superset.models import core as models
from superset.models.slice import Slice

BASE_URL = "https://github.com/apache-superset/examples-data/blob/master/"


# 示例：加载能源数据集，表名energy_usage，数据集energy.json.gz
def load_energy(
    only_metadata: bool = False, force: bool = False, sample: bool = False
) -> None:
    """Loads an energy related dataset to use with sankey and graphs"""
    tbl_name = "energy_usage"
    database = utils.get_example_database()
    table_exists = database.has_table_by_name(tbl_name)

    if not only_metadata and (not table_exists or force):
        data = get_example_data("energy.json.gz")
        pdf = pd.read_json(data)
        pdf = pdf.head(100) if sample else pdf
        pdf.to_sql(
            tbl_name,
            database.get_sqla_engine(),
            if_exists="replace",
            chunksize=500,
            dtype={"source": String(255), "target": String(255), "value": Float()},
            index=False,
            method="multi",
        )
     ...
 

""" 从 BASE_URL下载样例数据 """    
def get_example_data(    
    filepath: str, is_gzip: bool = True, make_bytes: bool = False
) -> BytesIO:
    content = request.urlopen(f"{BASE_URL}{filepath}?raw=true").read()
    if is_gzip:
        content = zlib.decompress(content, zlib.MAX_WBITS | 16)
    if make_bytes:
        content = BytesIO(content)
    return content  
```



### 全局实例或变量

/superset/`__init__.py`

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

# LocalProxy本地代理数据：conf results_backend data_cache数据缓存、缩略图缓存
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



#### 配置文件

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



#### WEB实例 app.py

/superset/app.py

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
        self.pre_init()		#初始化前，创建DATA_DIR
        self.setup_db()		# APP和数据库绑定
        self.configure_celery()
        self.setup_event_logger()
        self.setup_bundle_manifest()
        self.register_blueprints()
        self.configure_wtf()
        self.configure_logging()
        self.configure_middlewares()
        self.configure_cache()
        
        with self.flask_app.app_context():  # type: ignore
            self.init_app_in_ctx()  #更新APP上下文，包括更新视图init_views()

        self.post_init()        
              
    def init_views(self) -> None:
        """ 初始化视图
        构建路由视图类CBV,首页导航菜单、
        调用 flask_appbuilder.add_link, add_view
        """
```



#### 抽象类ABC

* /superset/commands/base.py  ORM CRUD命令抽象类，抽象方法有run, validate
* /superset/utils/log.py   日志抽象类，抽象方法有log
* /superset/utils/log_configurator.py 日志配置抽象类， 抽象方法有configure_logging

```python
# /superset/commands/base.py
from abc import ABC, abstractmethod
from typing import Any

class BaseCommand(ABC):
    @abstractmethod
    def run(self) -> Any:
        """
        Run executes the command. Can raise command exceptions
        :raises: CommandException
        """

    @abstractmethod
    def validate(self) -> None:
        """
        Validate is normally called by run to validate data.
        Will raise exception if validation fails
        :raises: CommandException
        """    
        

# /superset/utils/log.py        
class AbstractEventLogger(ABC): 
    @abstractmethod 
    def log( self, user_id: Optional[int], action: str, dashboard_id: Optional[int], duration_ms: Optional[int], slice_id: Optional[int], referrer: Optional[str], *args: Any, **kwargs: Any, ) -> None: pass  
    
    
# /superset/utils/log_configurator.py
class LoggingConfigurator(abc.ABC):
    @abc.abstractmethod
    def configure_logging(
        self, app_config: flask.config.Config, debug_mode: bool
    ) -> None:
        pass
```



### 原始数据查询 

数据的查询和展示是superset的核心功能，前端用D3.js来渲染各种图标，后端用pandas来处理各种数据。

**superset数据查询过程**：

1.将前端的配置信息form_data传给explore_json函数  /superset/views/core.py
2.根据所选的图表类型，找到对应的图表类	/superset/viz.py
3.根据过滤条件生成sql查询语句	/superset/charts/filters.py
4.根据数据库的连接条件找到对应的数据库engine，创建engine	
5.使用pandas的read_sql函数获取查询结果，并生成一个dataframe



/superset/views/core.py

```python
class Superset(BaseSupersetView): 
    
	@api
    @has_access_api
    @handle_api_exception
    @event_logger.log_this
    @expose(
        "/explore_json/<datasource_type>/<int:datasource_id>/",
        methods=EXPLORE_JSON_METHODS,
    )
    @expose("/explore_json/", methods=EXPLORE_JSON_METHODS)
    @etag_cache()
    @check_resource_permissions(check_datasource_perms)
    def explore_json(
        self, datasource_type: Optional[str] = None, datasource_id: Optional[int] = None
    ) -> FlaskResponse:
        response_type = utils.ChartDataResultFormat.JSON.value
        responses: List[
            Union[utils.ChartDataResultFormat, utils.ChartDataResultType]
        ] = list(utils.ChartDataResultFormat)
        responses.extend(list(utils.ChartDataResultType))
        for response_option in responses:
            if request.args.get(response_option) == "true":
                response_type = response_option
                break
		# 获取form数据
        form_data = get_form_data()[0]

        try:
            datasource_id, datasource_type = get_datasource_info(
                datasource_id, datasource_type, form_data
            )

            force = request.args.get("force") == "true"

            # TODO: support CSV, SQL query and other non-JSON types  异步处理支持
            if (
                is_feature_enabled("GLOBAL_ASYNC_QUERIES")
                and response_type == utils.ChartDataResultFormat.JSON
            ):
                try: # 异步查询
                    async_channel_id = async_query_manager.parse_jwt_from_request(
                        request
                    )["channel"]
                    job_metadata = async_query_manager.init_job(async_channel_id)
                    load_explore_json_into_cache.delay(
                        job_metadata, form_data, response_type, force
                    )
                except AsyncQueryTokenException:
                    return json_error_response("Not authorized", 401)

                return json_success(json.dumps(job_metadata), status=202)

            # 获取图表类型
            viz_obj = get_viz(
                datasource_type=cast(str, datasource_type),
                datasource_id=datasource_id,
                form_data=form_data,
                force=force,
            )
			# 返回数据JSON格式
            return self.generate_json(viz_obj, response_type)
        except SupersetException as ex:
            return json_error_response(utils.error_msg_from_exception(ex), 400)   
        
    def generate_json(
        self, viz_obj: BaseViz, response_type: Optional[str] = None
    ) -> FlaskResponse:
        if response_type == utils.ChartDataResultFormat.CSV:
            return CsvResponse(
                viz_obj.get_csv(),
                status=200,
                headers=generate_download_headers("csv"),
                mimetype="application/csv",
            )

        if response_type == utils.ChartDataResultType.QUERY:
            return self.get_query_string_response(viz_obj)

        if response_type == utils.ChartDataResultType.RESULTS:
            return self.get_raw_results(viz_obj)

        # 数据采样返回，调用了 get_df_payload (pandas)
        if response_type == utils.ChartDataResultType.SAMPLES:
            return self.get_samples(viz_obj)

        payload = viz_obj.get_payload()
        return data_payload_response(*viz_obj.payload_json_and_has_error(payload))        
```



#### 可视化图表

* /superset/viz.py 定义了可视化基类BaseViz及各个子类，可视化列表viz_types
* /superset/superset_config.py  此处变量VIZ_TYPE_DENYLIST会被 viz_types用到
* /superset/views/utils.py  get_viz()会根据传参类型返回BaseViz的实际子类。



/superset/viz.py  可视化图表类型的基类和子类

```python
from flask_babel import lazy_gettext as _


class BaseViz:

    """All visualizations derive this base class"""

    viz_type: Optional[str] = None
    verbose_name = "Base Viz"
    credits = ""
    is_timeseries = False
    cache_type = "df"
    enforce_numerical_metrics = True

    def __init__(
        self,
        datasource: "BaseDatasource",
        form_data: Dict[str, Any],
        force: bool = False,
        force_cached: bool = False,
    ) -> None:
        if not datasource:
            raise QueryObjectValidationError(_("Viz is missing a datasource"))

        self.datasource = datasource
        self.request = request
        self.viz_type = form_data.get("viz_type")
        self.form_data = form_data

        self.query = ""
        self.token = utils.get_form_data_token(form_data)

        self.groupby: List[str] = self.form_data.get("groupby") or []
        self.time_shift = timedelta()

        self.status: Optional[str] = None
        self.error_msg = ""
        self.results: Optional[QueryResult] = None
        self.errors: List[Dict[str, Any]] = []
        self.force = force
        self._force_cached = force_cached
        self.from_dttm: Optional[datetime] = None
        self.to_dttm: Optional[datetime] = None
        self._extra_chart_data: List[Tuple[str, pd.DataFrame]] = []

        self.process_metrics()

        self.applied_filters: List[Dict[str, str]] = []
        self.rejected_filters: List[Dict[str, str]] = []

          
class NVD3Viz(BaseViz):

    """Base class for all nvd3 vizs"""

    credits = '<a href="http://nvd3.org/">NVD3.org</a>'
    viz_type: Optional[str] = None
    verbose_name = "Base NVD3 Viz"
    is_timeseries = False
        

class BubbleViz(NVD3Viz):

    """Based on the NVD3 bubble chart"""

    viz_type = "bubble"
    verbose_name = _("Bubble Chart")
    is_timeseries = False

    def query_obj(self) -> QueryObjectDict:
        
        
def get_subclasses(cls: Type[BaseViz]) -> Set[Type[BaseViz]]:
    return set(cls.__subclasses__()).union(
        [sc for c in cls.__subclasses__() for sc in get_subclasses(c)]
    )


viz_types = {
    o.viz_type: o
    for o in get_subclasses(BaseViz)
    if o.viz_type not in config["VIZ_TYPE_DENYLIST"]
}            
```



/supetset/superset_config.py 

```python
设置不处理的图表类型，这里只是后端不处理报错；前端仍然会显示此图表
VIZ_TYPE_DENYLIST = ['pivot_table', 'treemap']
```



/superset/views/utils.py 

get_viz()根据传参viz_type返回相应的图表类。

```python
if is_feature_enabled("SIP_38_VIZ_REARCHITECTURE"):
    from superset import viz_sip38 as viz
else:
    from superset import viz  # type: ignore
    
def get_viz(
    form_data: FormData,
    datasource_type: str,
    datasource_id: int,
    force: bool = False,
    force_cached: bool = False,
) -> BaseViz:
    viz_type = form_data.get("viz_type", "table")
    datasource = ConnectorRegistry.get_datasource(
        datasource_type, datasource_id, db.session
    )
    viz_obj = viz.viz_types[viz_type](  # 如果viz_types不存在或配置文件里的限制类型，将返回KeyError
        datasource, form_data=form_data, force=force, force_cached=force_cached
    )
    return viz_obj
```





### 视图逻辑 /views/

Views可分为二大类

* CBV，类实现视图，通常与数据库CRUD密切相关的 ModelView.  
* FBV，函数实现视图，通常不涉及到数据库操作。



#### **基础视图**  base.py

/superset/views/base.py

```python
from flask_appbuilder import BaseView, Model, ModelView


class SupersetModelView(ModelView):
    # 数据库CRUD相关
    page_size = 100
    list_widget = SupersetListWidget

    def render_app_template(self) -> FlaskResponse:
        payload = {
            "user": bootstrap_user_data(g.user),
            "common": common_bootstrap_payload(),
        }
        return self.render_template(
            "superset/crud_views.html",
            entry="crudViews",
            bootstrap_data=json.dumps(
                payload, default=utils.pessimistic_json_iso_dttm_ser
            ),
        )
    
    
class BaseSupersetView(BaseView):
    # HTML返回，需要用到模板页面
    @staticmethod
    def json_response(
        obj: Any, status: int = 200
    ) -> FlaskResponse:  # pylint: disable=no-self-use
        return Response(
            json.dumps(obj, default=utils.json_int_dttm_ser, ignore_nan=True),
            status=status,
            mimetype="application/json",
        )

    def render_app_template(self) -> FlaskResponse:
        payload = {
            "user": bootstrap_user_data(g.user),
            "common": common_bootstrap_payload(),
        }
        return self.render_template(
            "superset/crud_views.html",
            entry="crudViews",
            bootstrap_data=json.dumps(
                payload, default=utils.pessimistic_json_iso_dttm_ser
            ),
        )    
```



#### 普通视图 core.py

此文件的路由都是 /superset/开头，共有63个API。

```python
from flask import abort, flash, g, Markup, redirect, render_template, request, Response
from flask_appbuilder import expose
from flask_appbuilder.models.sqla.interface import SQLAInterface
from flask_appbuilder.security.decorators import (
    has_access,
    has_access_api,
    permission_name,
)
from flask_appbuilder.security.sqla import models as ab_models
from flask_babel import gettext as __, lazy_gettext as _, ngettext
from jinja2.exceptions import TemplateError
from jinja2.meta import find_undeclared_variables


class Superset(BaseSupersetView): 

    logger = logging.getLogger(__name__)

    @has_access_api
    @event_logger.log_this
    @expose("/datasources/")
    def datasources(self) -> FlaskResponse:
```





#### ModelView逻辑

**ModelView层次体系**：

*flask_appbuilders模块*：BaseView(object)  -> BaseModelView -> BaseCRUDView-> RestCRUDView -> ModelView

*superset模块*：		 			-> SupersetModelView  (/superset/views/base.py)

​														-> DashboardModelView  (/superset/views/chart/views.py)

​										    			-> SliceModelView

说明：ModelView的路由前缀是 `/superset/{route_base}`,  实现API常用方法 list/show/get/post/add/edit/download



/superset/views/chart/views.py

```python
import json

from flask import g
from flask_appbuilder import expose, has_access
from flask_appbuilder.models.sqla.interface import SQLAInterface
from flask_babel import lazy_gettext as _

from superset import db, is_feature_enabled
from superset.connectors.connector_registry import ConnectorRegistry
from superset.constants import MODEL_VIEW_RW_METHOD_PERMISSION_MAP, RouteMethod
from superset.models.slice import Slice
from superset.typing import FlaskResponse
from superset.utils import core as utils
from superset.views.base import (
    check_ownership,
    common_bootstrap_payload,
    DeleteMixin,
    SupersetModelView,
)
from superset.views.chart.mixin import SliceMixin
from superset.views.utils import bootstrap_user_data


class SliceModelView(
    SliceMixin, SupersetModelView, DeleteMixin
):  # pylint: disable=too-many-ancestors
    """
    SliceMixin:  Slice的数据成员类，不涉及到方法。 导入在同级目录下的 mixin.py
    DeleteMixin： 定义了删除方法。导入在上级目录的../base.py
    SupersetModelView： 此类实现render_app_template方法
    """    
    route_base = "/chart"	# 路由路径前缀
    datamodel = SQLAInterface(Slice)
    include_route_methods = RouteMethod.CRUD_SET | {
        RouteMethod.DOWNLOAD,
        RouteMethod.API_READ,
        RouteMethod.API_DELETE,
    }
    class_permission_name = "Chart"
    method_permission_name = MODEL_VIEW_RW_METHOD_PERMISSION_MAP

    def pre_add(self, item: "SliceModelView") -> None:
        utils.validate_json(item.params)

    def pre_update(self, item: "SliceModelView") -> None:
        utils.validate_json(item.params)
        check_ownership(item)

    def pre_delete(self, item: "SliceModelView") -> None:
        check_ownership(item)

    @expose("/add", methods=["GET", "POST"])
    @has_access
    def add(self) -> FlaskResponse:
        datasources = [
            {"value": str(d.id) + "__" + d.type, "label": repr(d)}
            for d in ConnectorRegistry.get_all_datasources(db.session)
        ]
        payload = {
            "datasources": sorted(datasources, key=lambda d: d["label"]),
            "common": common_bootstrap_payload(),
            "user": bootstrap_user_data(g.user),
        }
        # render_template方法是在此项目根路径下的 templates目录再取相应模块页面, 
        # 实际调用 /suserset/templates/superset/add_slice.html
        return self.render_template(
            "superset/add_slice.html", bootstrap_data=json.dumps(payload)
        )

    @expose("/list/")
    @has_access
    def list(self) -> FlaskResponse:
        if not is_feature_enabled("ENABLE_REACT_CRUD_VIEWS"):
            return super().list()

        return super().render_app_template()
```





### 图表逻辑 /charts/

图表charts、看板dashboards、databases和datasets 这4个的代码结构和处理逻辑类似。

* commands/  元数据CRUD操作命令
* api.py RestAPI接口
* dao.py 更复杂的SQL语句实现，如bulk_delete
* filters.py  过滤条件



#### 元数据CRUD命令 /commands/

/superset/charts/commands/create.py

```python
import logging
from typing import Any, Dict, List, Optional

from flask_appbuilder.models.sqla import Model
from flask_appbuilder.security.sqla.models import User
from marshmallow import ValidationError

from superset.charts.commands.exceptions import (
    ChartCreateFailedError,
    ChartInvalidError,
    DashboardsNotFoundValidationError,
)
from superset.charts.dao import ChartDAO
from superset.commands.base import BaseCommand
from superset.commands.utils import get_datasource_by_id, populate_owners
from superset.dao.exceptions import DAOCreateFailedError
from superset.dashboards.dao import DashboardDAO


class CreateChartCommand(BaseCommand):
    def __init__(self, user: User, data: Dict[str, Any]):
        self._actor = user
        self._properties = data.copy()

    def run(self) -> Model:
        self.validate()
        try:
            chart = ChartDAO.create(self._properties)
        except DAOCreateFailedError as ex:
            logger.exception(ex.exception)
            raise ChartCreateFailedError()
        return chart

    def validate(self) -> None:
```



#### RestApi逻辑 api.py

**RestApi层次体系**：

*flask_appbuilders模块*：BaseApi(object)  -> BaseModelApi -> ModelRestApi 

*superset模块*：		 			-> BaseSupersetModelRestApi (/superset/views/base_api.py)

​														-> ChartRestApi (/superset/charts/api.py)

​										    			-> DashboardRestApi (/superset/dashboards/api.py)

说明：RestApi类有一个关键属性resource_name。本处路由前缀是`{route_base}` 或者  `/api/{version}/{resource_name}/`

```python
from flask import g, make_response, redirect, request, Response, send_file, url_for
from flask_appbuilder.api import expose, protect, rison, safe
from flask_appbuilder.models.sqla.interface import SQLAInterface


class ChartRestApi(BaseSupersetModelRestApi):
    datamodel = SQLAInterface(Slice)

    resource_name = "chart"
    allow_browser_login = True
    
    @expose("/export/", methods=["GET"])
    @protect()
    @safe
    @statsd_metrics
    @rison(get_export_ids_schema)
    @event_logger.log_this_with_context(
        action=lambda self, *args, **kwargs: f"{self.__class__.__name__}.export",
        log_to_statsd=False,
    )
    def export(self, **kwargs: Any) -> Response:
        
```



#### **dao逻辑 dao.py**

dao逻辑实现了 操作数据库的事务方法，如bulk_delete, save, overwrite等等

```python
from superset.charts.filters import ChartFilter
from superset.dao.base import BaseDAO


class ChartDAO(BaseDAO):
    model_cls = Slice
    base_filter = ChartFilter

    @staticmethod
    def bulk_delete(models: Optional[List[Slice]], commit: bool = True) -> None:
```



#### **过滤逻辑 filters.py**

```python
from typing import Any

from flask_babel import lazy_gettext as _
from sqlalchemy import or_
from sqlalchemy.orm.query import Query

from superset import security_manager
from superset.connectors.sqla.models import SqlaTable
from superset.models.slice import Slice
from superset.views.base import BaseFilter
from superset.views.base_api import BaseFavoriteFilter


class ChartAllTextFilter(BaseFilter):  # pylint: disable=too-few-public-methods
    name = _("All Text")
    arg_name = "chart_all_text"

    def apply(self, query: Query, value: Any) -> Query:
        if not value:
            return query
        ilike_value = f"%{value}%"
        return query.filter(
            or_(
                Slice.slice_name.ilike(ilike_value),
                Slice.description.ilike(ilike_value),
                Slice.viz_type.ilike(ilike_value),
                SqlaTable.table_name.ilike(ilike_value),
            )
        )


class ChartFavoriteFilter(BaseFavoriteFilter):  # pylint: disable=too-few-public-methods
    """
    Custom filter for the GET list that filters all charts that a user has favored
    """

    arg_name = "chart_is_favorite"
    class_name = "slice"
    model = Slice


class ChartFilter(BaseFilter):  # pylint: disable=too-few-public-methods
    def apply(self, query: Query, value: Any) -> Query:
        if security_manager.can_access_all_datasources():
            return query
        perms = security_manager.user_view_menu_names("datasource_access")
        schema_perms = security_manager.user_view_menu_names("schema_access")
        return query.filter(
            or_(self.model.perm.in_(perms), self.model.schema_perm.in_(schema_perms))
        )

```





### 安全权限控制 

依赖于flask_appbuilder的权限管理

* /flask_appbuilder/security/   fab的权限管理实现
* /superset/security/   superset的权限管理
* /superset/xxx/api.py   superset某个API的实现
* /superset/app.py  superset菜单权限



**Superset权限管理类**

/superset/security/manager.py

```python
from flask import current_app, g
from flask_appbuilder import Model
from flask_appbuilder.security.sqla.manager import SecurityManager
from flask_appbuilder.security.sqla.models import (
    assoc_permissionview_role,
    assoc_user_role,
    PermissionView,
    User,
)
from flask_appbuilder.security.views import (
    PermissionModelView,
    PermissionViewModelView,
    RoleModelView,
    UserModelView,
    ViewMenuModelView,
)


class SupersetSecurityManager(SecurityManager):
    userstatschartview = None
    READ_ONLY_MODEL_VIEWS = {"Database", "DruidClusterModelView", "DynamicPlugin"}

    USER_MODEL_VIEWS = {
        "UserDBModelView",
        "UserLDAPModelView",
        "UserOAuthModelView",
        "UserOIDModelView",
        "UserRemoteUserModelView",
    }
    ...
```



**API访问权限**

API示例 /superset/charts/api.py

```python
from flask_appbuilder.api import expose, protect, rison, safe  # 都是在API实现中直接使用的装饰器

from superset.views.base_api import (
    BaseSupersetModelRestApi,
    RelatedFieldFilter,
    statsd_metrics,
)


class ChartRestApi(BaseSupersetModelRestApi):
    ...
    
    def __init__(self) -> None:
        if is_feature_enabled("THUMBNAILS"):
            self.include_route_methods = self.include_route_methods | {
                "thumbnail",
                "screenshot",
                "cache_screenshot",
            }
        super().__init__()

    @expose("/", methods=["POST"])
    @protect()
    @safe
    @statsd_metrics
    @event_logger.log_this_with_context(
        action=lambda self, *args, **kwargs: f"{self.__class__.__name__}.post",
        log_to_statsd=False,
    )
    def post(self) -> Response:
        """ 以上装饰器分别是路由、权限检查、异常处理、API统计、日志处理 """
        
```

* expose: API路由
* **protect**:  判断API权限
* rison  捕捉入参的Rison参数
* safe 捕捉异常，返回异常时的JSON
* has_access_api  



**菜单权限**

使用flask_appbuilder模块的AppBuilder 来处理菜单权限。



### 模板 /templates/

* 模板渲染 /flask_appbuilder/baseviews.py:render_template
* 网页渲染 render

/superset/templates/superset/basic.html



### 日志

DATA_DIR： 用来存放元数据文件（缺省sqlite是superset.db）、日志文件（superset.log）。依赖环境变量SUPERSET_HOME，缺省~/.superset/

几种logger

* STATS_LOGGER   实时统计的日志，方法有incr, decr, timing计时, gauge
* EVENT_LOGGER  操作DB的日志
* QUERY_LOGGER  查询日志

常用logger的定义如下

```python
# /superset/config.py
STATS_LOGGER = DummyStatsLogger()
EVENT_LOGGER = DBEventLogger()
QUERY_LOGGER = None

# /superset/extensions.py 
# 其实不是日志，是一个本地代理
_event_logger: Dict[str, Any] = {}
event_logger = LocalProxy(lambda: _event_logger.get("event_logger"))

# xx.py
logger = logging.getLogger(__name__)

# /superset/utils/log.py
# /superset/stats_logger.py
```

/superset/utils/log.py

```python
from abc import ABC, abstractmethod


class AbstractEventLogger(ABC):
    
class DBEventLogger(AbstractEventLogger):
    def log(,,,,)   
```





## 6.4  前端 /superset-frontend/

前端文件格式有：jsx（JS扩展）、ts/tsx（typescript扩展）、js



### 前端构建逻辑 

* webpack.conf.json  构建配置文件
* src/xx/xx.tsx  某个目录的脚本

/superset-frontend/webpack.config.js  

 ```js
const config = {
  node: {
    fs: 'empty',
  },
  // entry, 指定src目录下各目录的打包入口
  entry: {
    theme: path.join(APP_DIR, '/src/theme.ts'),
    preamble: PREAMBLE,
    addSlice: addPreamble('/src/addSlice/index.tsx'),
    explore: addPreamble('/src/explore/index.jsx'),
    dashboard: addPreamble('/src/dashboard/index.jsx'),
    sqllab: addPreamble('/src/SqlLab/index.tsx'),
    crudViews: addPreamble('/src/views/index.tsx'),
    menu: addPreamble('src/views/menu.tsx'),
    profile: addPreamble('/src/profile/index.tsx'),
    showSavedQuery: [path.join(APP_DIR, '/src/showSavedQuery/index.jsx')],
  },
}    
 ```



/src/addSlice/index.tsx

```jsx
import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';

ReactDOM.render(<App />, document.getElementById('app'));
```



### 首页控制逻辑 

/superset-frontend/src/views/CRUD/welcome/

* ActivityTable.tsx  Recents栏切换表格
* ChartTable.tsx
* DashboardTable.tsx
* SavedQueries.tsx
* Welcome.tsx



1. Recents栏切换表格

/superset-frontend/src/views/CRUD/welcome/ActivityTable.tsx:127

```tsx
import React from 'react';
import moment from 'moment';
import { styled, t } from '@superset-ui/core';

import Loading from 'src/components/Loading';
import ListViewCard from 'src/components/ListViewCard';
import SubMenu from 'src/components/Menu/SubMenu';
import { ActivityData } from './Welcome';
import { mq, CardStyles } from '../utils';
import EmptyState from './EmptyState';

// 函数-活动表格
export default function ActivityTable({
  loading,
  activeChild,
  setActiveChild,
  activityData,
}: ActivityProps) {
  const getFilterTitle = (e: ActivityObjects) => {
    if (e.dashboard_title) return e.dashboard_title;
    if (e.label) return e.label;
    if (e.url && !e.table) return e.item_title;
    if (e.item_title) return e.item_title;
    return e.slice_name;
  };
    
 // 三个tab: Viewed Edited Created   
 const tabs = [
    {
      name: 'Edited',
      label: t('Edited'),
      onClick: () => {
        setActiveChild('Edited');
      },
    },
    {
      name: 'Created',
      label: t('Created'),
      onClick: () => {
        setActiveChild('Created');
      },
    },
  ];

  if (activityData?.Viewed) {
    tabs.unshift({
      name: 'Viewed',
      label: t('Viewed'),
      onClick: () => {
        setActiveChild('Viewed');
      },
    });
  } else {
    tabs.unshift({
      name: 'Examples',
      label: t('Examples'),
      onClick: () => {
        setActiveChild('Examples');
      },
    });
  }
```





###  控制菜单 controls.jsx

/superset-frontend/src/explorer/controls.jsx

```jsx
import React from 'react';
import {
  t,
  getCategoricalSchemeRegistry,
  getSequentialSchemeRegistry,
  legacyValidateInteger,
  validateNonEmpty,
} from '@superset-ui/core';
import { ColumnOption } from '@superset-ui/chart-controls';
import { formatSelectOptions, mainMetric } from 'src/modules/utils';
import { TIME_FILTER_LABELS } from './constants';

const categoricalSchemeRegistry = getCategoricalSchemeRegistry();
const sequentialSchemeRegistry = getSequentialSchemeRegistry();

export const PRIMARY_COLOR = { r: 0, g: 122, b: 135, a: 1 };

// groupby控制按键
const groupByControl = {
  type: 'SelectControl',
  multi: true,
  freeForm: true,
  label: t('Group by'),
  default: [],
  includeTime: false,
  description: t('One or many controls to group by'),
  optionRenderer: c => <ColumnOption column={c} showType />,
  valueRenderer: c => <ColumnOption column={c} />,
  valueKey: 'column_name',
  allowAll: true,
  filterOption: ({ data: opt }, text) =>
    (opt.column_name &&
      opt.column_name.toLowerCase().indexOf(text.toLowerCase()) >= 0) ||
    (opt.verbose_name &&
      opt.verbose_name.toLowerCase().indexOf(text.toLowerCase()) >= 0),
  promptTextCreator: label => label,
  mapStateToProps: (state, control) => {
    const newState = {};
    if (state.datasource) {
      newState.options = state.datasource.columns.filter(c => c.groupby);
      if (control && control.includeTime) {
        newState.options.push(timeColumnOption);
      }
    }
    return newState;
  },
  commaChoosesOption: false,
};
```





## 依赖模块

### 后端依赖 模板Jinja2

Jinja2 是一个现代的，设计者友好的，仿照 Django 模板的 Python 模板语言。 它速度快，被广泛使用，并且提供了可选的沙箱模板执行环境保证安全:

示例

```jinja2
<title>{% block title %}{% endblock %}</title>
<ul>
{% for user in users %}
  <li><a href="{{ user.url }}">{{ user.username }}</a></li>
{% endfor %}
</ul>
```



### 前端依赖 @superset-ui

前端依赖这个项目 superset-ui。

@superset-ui/legacy-*软件包从经典的中提取并转换为插件。 这些包的提取只需很小的更改（几乎保持原样）。 它们还依靠旧版API（ viz.py ）起作用。 

*@superset-ui/plugin-*软件包通常较新且质量更高。 它们不依赖viz.py （包含可视化特定的python代码）并与/api/v1/query/交互的主要区别在于：新的通用终结点旨在提供所有可视化。 还应该用Typescript编写。



### 后端依赖 flask_appbuilder

#### AppBuilder

菜单相关的操作 self.menu.xx()

* add_separator  添加菜单分隔符，后面创建的菜单顶在这个menu内
* add_link 给菜单项点击加链接
* add_view 给菜单项关联上视图，会调用add_link

菜单无关的操作
* add_api同 add_view_no_menu  添加非菜单项的视图



## 本章参考

* 知乎专栏-superset开发 https://zhuanlan.zhihu.com/c_100045590
* superset二次开发及汉化、图标等 https://blog.csdn.net/qq_34521526/article/details/116708025
* Superset 代码结构分析(前后端如何联动) https://zhuanlan.zhihu.com/p/163495199
* 从前端角度记录superset二次开发 http://sunjl729.cn/2020/08/07/superset二次开发/
* Superset安装及汉化 https://www.jianshu.com/p/c751278996f8
* Jinja2中文文档  http://docs.jinkan.org/docs/jinja2/



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



**参考链接**

*  superset的缓存配置 https://blog.csdn.net/qq_33440665/article/details/65628551
*  增加自定义数据源 https://zhuanlan.zhihu.com/p/179162221 
*  利用Flask-AppBuilder 快速构建Web后台管理应用 https://blog.csdn.net/oxuzhenyi/article/details/77586500
* Superset 1.0 终于发布了 https://cloud.tencent.com/developer/article/1823370
* Superset 表格下钻(基于时间维度,地域维度和普通维度) https://blog.csdn.net/tb77506668/article/details/107717258

