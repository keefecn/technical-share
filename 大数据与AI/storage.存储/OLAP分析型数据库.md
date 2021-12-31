| 序号 | 修改时间   | 修改内容                                                     | 修改人 | 审稿人 |
| ---- | ---------- | ------------------------------------------------------------ | ------ | ------ |
| 1    | 2021-12-30 | 创建。从《数据库技术》、《数据库架构》迁移OLAP相关章节成文。 | Keefe  | Keefe  |
|      |            |                                                              |        |        |









---

[TOC]



---



# 1 OLAP简介

OLAP：On Line Analyse Process在线分析处理。

表格 2 OLAP系统的分类

|          | 原理                                                         | 工具                           | 应用<br>场景 |
| -------- | ------------------------------------------------------------ | ------------------------------ | ------------ |
| MPP      | 有很好的数据量和灵活性支持，但是对响应时间是没有保证的。     | Presto/Impala/SparkSQL/Drill等 | 分布式查询   |
| 搜索引擎 | 入库时将数据转换为倒排索引，采用Scatter-Gather计算模型，牺牲了灵活性换取很好的性能，在搜索类查询上能做到亚秒级响应。<BR>但是对于扫描聚合为主的查询，随着处理数据量的增加，响应时间也会退化到分钟级。 | Elasticsearch、  Solr          | 搜索         |
| 预计算   | 入库时对数据进行预聚合，进一步牺牲灵活性换取性能（一般是用空间换时间），以实现对超大数据集的秒级响应。 | Druid/Kylin/ClickHouse等       | 聚合查询     |

备注：1. 以上OLAP针对的是亿级以上的海量数据。没有一个引擎能同时在数据量，灵活性和性能这三个方面做到完美，用户需要基于自己的需求进行取舍和选型。

2. 搜索引擎和预计算都是以空间换时间。



表格 3 OLAP工具比较

| 工具          | 简介                                                         | 优点                                                         | 缺点                                                         |
| ------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Hive          | Facebook开源的分布式、按列存储的数据仓库。缺省调用MR，是一个批处理过程。 |                                                              | 查询较慢，可能是分钟级。                                     |
| Presto        | Facebook开源的分布式实时查询引擎，可以对PB级的数据进行快速的交互式查询。 | 支持较多的数据源，包括hive、图数据库、传统关系型数据库、Redis等。 | 学习成本较高，语法语义有问题。开源版无权限控制。             |
| Impala        | Clouder公司主导开发的基于hive的实时分布式查询引擎。它提供SQL语义，能查询存储在Hadoop的HDFS和HBase中的PB级大数据。 | 与hive公用元数据库信息。  适用于模式固定，查询条件简答的实时查询。 | 对udf的结合不够好，而且在嵌套数据的处理上也有问题。          |
| Apache  Kylin | 首个国产Apache顶级项目。核心思想是预计算。一般从Hive读取源数据，使用 MapReduce作为Cube构建的引擎，并把预计算结果保存在HBase中，对外暴露ANSI SQL/Rest  API/JDBC/ODBC的查询接口。 | 聚合查询很快。                                               | 数据源目前只支持Hive和HBase。预计算构建Cube耗时较长，不适用实时场景。 |
| Apache  Drill |                                                              | 支持自定义嵌套数据集。与Hive一体化。支持多数据源。低延迟。   | 不是完全的ANSI SQL，只提供查询操作。                         |

备注：目前对HBase加速的还没较好工具。



表格 4 OLAP产品基本信息比较

| 产品       | 维护者            | 首版时间 | 开源 | 关键特性    | 备注                                          |
| ---------- | ----------------- | -------- | ---- | ----------- | --------------------------------------------- |
| IQ         | Sybase/SAP        | 1987     | N    | MPP DW 列式 | Sybase成立于1984年。2010年被SAP收购。         |
| Teradata   | Teradata          | 1996     | N    | MPP DW 列式 | Teradata成立于1979年。                        |
| Vertica    | Vertica/HP        | 2005     | N    | MPP列式     | 2011年HP收购Vertica。                         |
| GreenPlum  | Greenplum/EMC     | 2006     | Y    | MPP列式     | 2010.7，EMC收购Greenplum。2015年开源。        |
| HANA       | SAP               | 2010     | N    | MPP 内存    | SAP公司成立于1972年。                         |
| Druid      |                   | 2011     | Y    | 时序 列式   |                                               |
| Impala     | Cloudara          | 2012     | Y    | MPP列式     |                                               |
| Presto     | Facebook          | 2013     | Y    | MPP列式     |                                               |
| Pinot      | LinkedIn          | 2013     | Y    | MPP         |                                               |
| Kylin      | eBay/Kyligence    | 2014     | Y    | 预计算      |                                               |
| ClickHouse | Yandex/ClickHouse | 2016     | Y    | 时序 列式   | 2021.9，从Yandex独立成为新公司ClickHouse, Inc |



表格  OLAP实现方案对比

|              | Hive/SparkSQL | Kylin | ES   | Druid  |
| ------------ | ------------- | ----- | ---- | ------ |
| 超大数据集   | 好            | 好    | 中   | 好     |
| 查询性能     | 差            | 好    | 中   | 好     |
| 数据实时性   | 差            | 中    | 好   | 中     |
| 高并发       | 差            | 好    | 好   | 好     |
| Schema灵活性 | 好            | 差    | 好   | 好     |
| SQL接口      | 好            | 好    | 中   | 好     |
| 精确去重     | 支持          | 支持  | 支持 | 不支持 |



表格  SAP和Sybase比较

| SAP                                                          | Sybase                                                       |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| SAP公司成立于1972年，总部位于德国沃尔多夫市，是全球最大的企业管理和协同化商务解决方案供应商、全球第三大独立软件供应商。目前，在全球有120多个国家的超过95,000家用户正在运行SAP软件。1995年在北京正式成立SAP中国公司，并陆续建立了上海、广州、大连分公司。 | Sybase公司成立于1984年，总部设在美国加州都柏林，是全球领先的企业级和移动软件公司，致力于信息的管理、分析和移动。在所有主要的系统、网络和设备上，我们都是全球公认的在数据密集应用领域有杰出的性能表现的领导者。Sybase的信息管理、分析和企业移动解决方案已经为全球的金融服务、通信、制造和政府等的业务关键系统提供强劲动力。 |
| 商务套件：SAP  Business Suite (ERP，CRM，SRM，SCM，PLM)      | 交易数据库：Sybase  ASE，Sybase SQL  Anywhere，Sybase ADS    |
| 企业应用：SAP可持续发展解决方案，SAP服务与资产管理等         | 分析数据库：Analytic  Appliance，Sybase IQ列式数据库         |
| 中小企业：SAP  Business All-in-One,SAP Business ByDesign     | 移动服务：Afaria，iAnywhere Mobile Office，Sybase 365 mCommerce Solution，MMX 365 |
| 技术平台：Enterprise  SOA，SAP NetWeaver平台                 | 数据集成：  Replication Server                               |
| 商业智能：Business  Objects产品，水晶报表                    | 开发工具：  PowerBuilder，PowerDesigner                      |
| 解决方案：垂直行业解决方案                                   | 解决方案：金融服务解决方案RAP                                |

备注：2010.5，SAP宣布58亿美元收购Sybase移动平台和数据库业务，但Sybase仍以独立公司形式运作，同年SAP推出HANA。

2015年，华为与SAP合作打造HANA一体机。



# 2 OLAP（开源）

## 2.1  GreenPlum (Pivotal/EMC)

Pivotal公司成立于2003年，2006年推出了首款产品，其主营业务关注在数据仓库和商业智能方面，Greenplum DW/BI软件可以在虚拟化x86服务器上运行无分享（shared-nothing）的大规模并行处理（MPP）架构。2010年被EMC收购。

两款产品：GreenPlum、HAWQ



### 2.1.1  GreenPlum

2005 年，Greenplum [数据库](https://cloud.tencent.com/solution/database?from=10680)第一个版本发布。基于强大的开源数据库PostgreSQL

2015 年，Greenplum 开源，世界上第一款开源MPP数据库。开源版本基于Greenplum4.3。

   ![1574510608552](../../media/sf_reuse/arch/db/arch_db_greenplum_001.png)

图 21 GreenPlum架构



### 2.1.2  HAWQ

Pivotal的SQL on Hadoop方案是基于10多年来产品开发的成果价值，即投资研发Greenplum Database——Pivotal的旗舰分析数据仓库。Pivotal正是利用这一代码基础和深度数据管理专业知识来构建了业内最好的SQL on Hadoop企业引擎。

HAWQ，全称Hadoop With Query（带查询Hadoop）。HAWQ使企业能够获益于经过锤炼的基于MPP的分析功能及其查询性能，同时利用Hadoop堆栈。



HAWQ的历史和现状

1. 想法和原型系统（2011）：GOH阶段（Greenplum Database On HDFS）。
2. HAWQ 1.0 Alpha（2012）：多个国外大型客户试用，当时客户性能测试是Hive的数百倍。促进了HAWQ 1.0作为正式产品发布。
3. HAWQ 1.0 GA（2013年初）：改变了传统MPP数据库架构，包括事务，容错，元数据管等。
4. HAWQ 1.X版本（2014-2015 Q2）：增加了一些企业级需要的功能，比如Parquet存储，新的优化器，Kerberos，Ambari安装部署。客户覆盖全球。
5. HAWQ 2.0 Alpha发布并成为Apache孵化器项目：针对云环境的系统架构重新设计，数十个高级功能，包括弹性执行引擎，高级资源管理，YARN集成，秒级扩容等等。现在大家在Apache开源的是最新的2.0 Alpha版本。未来的开发都在Apache进行。

 ![1574510634084](../../media/sf_reuse/arch/db/arch_db_hawq_001.png)



图 22 Pivotal的SQL on Hadoop方案

 ![1574510659118](../../media/sf_reuse/arch/db/arch_db_hawq_002.png)



图 23 HAWQ系统架构

HAWQ集群的主要组件：其中有几个Master节点：包括HAWQ master节点，HDFS master节点NameNode，YARN master节点ResourceManager。每个Slave节点上部署有HDFS DataNode，YARN NodeManager以及一个HAWQ Segment。HAWQ Segment在执行查询的时候会启动多个QE (Query Executor, 查询执行器)。



## 2.2   Impala (Cloudara)

Impala是用于处理存储在Hadoop集群中的大量数据的MPP（大规模并行处理）SQL查询引擎，由Cloudera公司主导开发。 它是一个用C ++和Java编写的开源软件。

与其他Hadoop的SQL引擎相比，它提供了高性能和低延迟。宣称比原来基于MapReduce的HiveSQL查询速度提升3~90倍，且更加灵活易用。提供类SQL的查询语句，能够查询存储在Hadoop的HDFS和Hbase中的PB级大数据。查询速度快是其最大的卖点。

### 2.2.1   架构

![1574510702324](../../media/sf_reuse/arch/db/arch_db_impala_001.png)



图 24 Impala架构图

位于Datanode上的每个impalad进程，都具有Query Planner, Query Coordinator, Query Exec Enginer这几个组件，每个impala节点在功能上是对等的。



Impala由Impalad，State Store，CLI组成：

*  Impalad：是impala的核心进程，与Datanode在同一个节点上，接受客户端的查询请求(接受查询请求的impalad为Coordinator，Coordinator通过JNI调用java前端解释SQL查询语句，生成查询计划树，再通过调度器吧执行计划分发给具有相应数据的其他impalad执行)，读写数据，并行执行查询，并把结果通过网络流式传给Coordinator，有Coordinator返回给客户端。同时impalad也与statestore保持连接，用于确定哪些impalad的健康的是可以执行新任务的。

*  State Store：类似Zookeeper。跟踪集群中的impalad的健康状态及位置信息，并不断把健康状况发送给所有的impalad进程节点。一旦某个impala节点不可用，State Store确保将这一信息及时传达到所有的impalad进程节点，当有新的查询请求时，Impalad进程节点不会把查询请求发送到不可用的节点上。State Store通过创建多个线程来处理Impalad的注册订阅和与各个Impalad保持心态连接。值得注意的是，statestore并非关键进程，即使不可用，Impalad进程节点间仍然可以相互协调正常对外提供分布式查询。

*  CLI：用户查询的命令行共组，还提供了Hue、JDBC、ODBC等接口。

*  Meta Store: Impala使用传统的MySQL、PostgreSQL或Hive来存储表定义。 诸如表和列信息和表定义的重要细节存储在称为元存储的集中式数据库中。



### 2.2.2   查询流程

   ![1574510782948](../../media/sf_reuse/arch/db/arch_db_impala_002.png)

图 25 impala查询处理过程

Impalad分为Java前端与C++处理后端，接受客户端连接的Impalad即作为这次查询的Coordinator，Coordinator通过JNI调用Java前端对用户的查询SQL进行分析生成执行计划树，不同的操作对应不用的PlanNode,如：SelectNode， ScanNode， SortNode， AggregationNode， HashJoinNode等等。

执行计划树的每个原子操作由一个PlanFragment表示，通常一条查询语句由多个Plan Fragment组成， PlanFragment 0表示执行树的根，汇聚结果返回给用户，执行树的叶子结点一般是Scan操作，分布式并行执行。

Java前端产生的执行计划树以Thrift数据格式返回给ImpalaC++后端（Coordinator）（执行计划分为多个阶段，每一个阶段叫做一个PlanFragment，每一个PlanFragment在执行时可 以由多个Impalad实例并行执行(有些PlanFragment只能由一个Impalad实例执行,如聚合操作)，整个执行计划为一执行计划树），由 Coordinator根据执行计划，数据存储信息（Impala通过libhdfs与HDFS进行交互。通过hdfsGetHosts方法获得文件数据 块所在节点的位置信息），通过调度器（现在只有simple-scheduler, 使用round-robin算法）Coordinator::Exec对生成的执行计划树分配给相应的后端执行器Impalad执行（查询会使用LLVM 进行代码生成，编译，执行。

## 2.3   Presto (Facebook)

Facebook也是Hive的初始开发者。

Presto 是 Facebook 推出的一个基于Java开发的大数据分布式 SQL 查询引擎，可对从数 G 到数 P 的大数据进行交互式的查询，查询的速度达到商业数据仓库的级别，据称该引擎的性能是 Hive 的 10 倍以上。Presto 可以查询包括 Hive、Cassandra 甚至是一些商业的数据存储产品，单个 Presto 查询可合并来自多个数据源的数据进行统一分析。



### 2.3.1   架构

   ![1574510803845](../../media/sf_reuse/arch/db/arch_db_presto_001.png)

图 26 Presto架构

Presto查询引擎是一个Master-Slave的架构，由下面三部分组成:

*  一个Coordinator节点
*  一个Discovery Server节点
*  多个Worker节点



节点说明：

*  Coordinator: 负责解析SQL语句，生成执行计划，分发执行任务给Worker节点执行
*  Discovery Server: 通常内嵌于Coordinator节点中
*  Worker节点: 负责实际执行查询任务,负责与HDFS交互读取数据。
*  节点间交互： Worker节点启动后向Discovery Server服务注册，Coordinator从Discovery Server获得可以正常工作的Worker节点。如果配置了Hive Connector，需要配置一个Hive MetaStore服务为Presto提供Hive元信息


### 2.3.2   查询流程

   ![1574510827623](../../media/sf_reuse/arch/db/arch_db_presto_002.png)

图 27 Presto执行过程示意图

用户使用Presto Cli提交一个查询语句后，Cli使用HTTP协议与Coordinator通信，Coordinator收到查询请求后调用SqlParser解析SQL语句得到Statement对象，并将Statement封装成一个QueryStarter对象放入线程池中等待执行。



## 2.4   Pinot (LinkedIn)

Pinot 是一个实时分布式的 OLAP 数据存储和分析系统。LinkedIn 使用它实现低延迟可伸缩的实时分析。Pinot 从离线数据源（包括 [Hadoop](http://www.oschina.net/p/hadoop) 和各类文件）和在线数据源（如 [Kafka](http://www.oschina.net/p/kafka)）中攫取数据进行分析。Pinot 被设计是可以进行水平扩展的。

### 2.4.1   架构

   ![1574510869776](../../media/sf_reuse/arch/db/arch_db_pinot_002.png)

图 28 Pinot 的组件架构



   ![1574510890908](../../media/sf_reuse/arch/db/arch_db_pinot_003.png)

图 29 Pinot组件架构图

整个系统利用Apache Helix作为集群的管理，还利用了Zookeeper存储集群的状态，同时保存Helix和Pinot的配置。

## 2.5   Kylin

Kylin来自 eBay 的中国人韩卿 [@lukehq](https://twitter.com/lukehq) 领导的团队开发的一个 OLAP 分析引擎，这是 ebay 历史上第一次开源并贡献给 apache 基金会的项目。Kylin于2014年10月在github开源，并很快在2014年11月加入Apache孵化器，于2015年11月正式毕业成为Apache顶级项目，也成为首个完全由中国团队设计开发的Apache顶级项目。

2016年3月，Apache Kylin核心开发成员在上海创建Kyligence公司，力求更好地推动项目和社区的快速发展。2016年4月，大数据公司Kyligence 跬智科技宣布获得了数百万美元的天使轮投资。

### 2.5.1   架构

Apache Kylin™是一个开源的分布式分析引擎，提供Hadoop/Spark之上的SQL查询接口及多维分析（OLAP）能力以支持超大规模数据，最初由eBay Inc. 开发并贡献至开源社区。它能在亚秒内查询巨大的Hive表。

   ![1574510912537](../../media/sf_reuse/arch/db/arch_db_kylin_001.png)

图 30 kylin部署架构

说明：数据源有hive/kafka；cube存储引擎缺省为hbase；cube构建引擎使用spark/MR；kylin元数据缺省存储在hbase，也可选mysql等。



   ![1574510929895](../../media/sf_reuse/arch/db/arch_db_kylin_002.png)

图 31 Kylin应用架构之组件（插件化）

说明：

* REST Server：提供一些restful接口，例如创建cube、构建cube、刷新cube、合并cube等cube的操作，project、table、cube等元数据管理、用户访问权限、系统配置动态修改等。除此之外还可以通过该接口实现SQL的查询，这些接口一方面可以通过第三方程序的调用，另一方也被kylin的web界面使用。

* jdbc/odbc接口：kylin提供了jdbc的驱动，驱动的classname为org.apache.kylin.jdbc.Driver，使用的url的前缀jdbc:kylin:，使用jdbc接口的查询走的流程和使用RESTFul接口查询走的内部流程是相同的。这类接口也使得kylin很好的兼容tebleau甚至mondrian。

* Query引擎：kylin使用一个开源的Calcite框架实现SQL的解析，相当于SQL引擎层。

* Routing：该模块负责将解析SQL生成的执行计划转换成cube缓存的查询，cube是通过预计算缓存在hbase中，这部分查询是可以再秒级甚至毫秒级完成，而还有一些操作使用过查询原始数据（存储在hadoop上通过hive上查询），这部分查询的延迟比较高。

* Metadata：kylin中有大量的元数据信息，包括cube的定义，星状模型的定义、job的信息、job的输出信息、维度的directory信息等等，元数据和cube都存储在hbase中，存储的格式是json字符串，除此之外，还可以选择将元数据存储在本地文件系统。

* Cube构建引擎：这个模块是所有模块的基础，它负责预计算创建cube，创建的过程是通过hive读取原始数据然后通过一些mapreduce计算生成Htable然后load到hbase中。

  ![1574510945176](../../media/sf_reuse/arch/db/arch_db_kylin_003.png)

图 32 Kylin 生态圈

说明：

*  Kylin 核心: Kylin OLAP引擎基础框架，包括元数据（Metadata）引擎，查询引擎，Job引擎及存储引擎等，同时包括REST服务器以响应客户端请求
*  扩展: 支持额外功能和特性的插件
*  整合: 与调度系统，ETL，监控等生命周期管理系统的整合
*  用户界面: 在Kylin核心之上扩展的第三方用户界面
*  驱动:ODBC 和 JDBC 驱动以支持不同的工具和产品，比如Tableau



### 2.5.2 KAP



### 2.5.3 Kyligence Cloud

使用 Kyligence Cloud，用户可以在公有云（如微软 Azure, 亚马逊 AWS，阿里云等）上快速建立大数据分析集群，接入各种云端数据源并进行建模分析，实现对 PB 级数据的交互式 OLAP 分析与关键业务查询的亚秒级响应。

   ![1574510962305](../../media/sf_reuse/arch/db/arch_db_kylin_004.png)

图 33 Kyligence Cloud 的架构图

说明：1. Hadoop / Spark 集群、Kyligence Enterprise、KyAnalyzer 是随需启动的服务，与您的集群具有相同的生命周期。云存储和元数据则具有更长的持久性，当集群停止时，它们不会被删除。

2. 表结构、Cube 模型等元数据存储在您帐户下的 RDS 或 SQL Server 实例中，Cube 数据会保存在 S3、 Azure blob store 或 OSS 中。



## 2.6  ClickHouse

clickhouse官网中文文档  https://clickhouse.com/docs/zh/

2016年6月15日，Yandex开源了一个数据分析的数据库，名字叫做ClickHouse。

2021年9月，ClickHouse 的创建者 Alexey 在 GitHub 宣布他们决定正式从 Yandex 独立，成立一个公司：ClickHouse, Inc。

ClickHouse是一个开源的面向列式数据的数据库管理系统，能够使用SQL查询并且生成实时数据报告。



**应用场景**

1.绝大多数请求都是用于读访问的

2.数据需要以大批次（大于1000行）进行更新，而不是单行更新；或者根本没有更新操作

3.数据只是添加到数据库，没有必要修改

4.读取数据时，会从数据库中提取出大量的行，但只用到一小部分列

5.表很“宽”，即表中包含大量的列

6.查询频率相对较低（通常每台服务器每秒查询数百次或更少）

7.对于简单查询，允许大约50毫秒的延迟

8.列的值是比较小的数值和短字符串（例如，每个URL只有60个字节）

9.在处理单个查询时需要高吞吐量（每台服务器每秒高达数十亿行）

10.不需要事务

11.数据一致性要求较低

12.每次查询中只会查询一个大表。除了一个大表，其余都是小表

13.查询结果显著小于数据源。即数据有过滤或聚合。返回结果不超过单个服务器内存大小



**不适用场景（使用限制）**

1.不支持真正的删除/更新支持，不支持事务（事务性工作OLTP）

2.不支持二级索引

3.有限的SQL支持，join实现与众不同

4.不支持窗口功能

5.元数据管理需要人工干预维护

6.高并发的键值访问

7.Blob或者文档存储



## 本章参考

[1]. Greenplum 数据库架构分析及5.x新功能分享  http://blog.sina.com.cn/s/blog_12c856e4c0102yhek.html

[2]. [Apache Kylin](http://kylin.apache.org)  http://kylin.apache.org

[3]. [kylinpy on Github](https://github.com/Kyligence/kylinpy)

[4]. [Superset:Airbnb’s data exploration platform](https://medium.com/airbnb-engineering/caravel-airbnb-s-data-exploration-platform-15a72aa610e5)

[5]. http://kyligence.io

[6]. http://docs.kyligence.io/

[7]. Kyligence Cloud  http://docs.kyligence.io/books/cloud/zh-cn/overview/architecture.cn.html

[8]. impala的原理架构介绍及应用场景 https://blog.csdn.net/javajxz008/article/details/50523332

[9]. Presto架构及原理 https://www.cnblogs.com/tgzhu/p/6033373.html

[10]. LinkedIn Pinot初探 https://blog.talkingdata.net/?p=3169

[11]. Pinot架构介绍 https://www.jianshu.com/p/67a9156f041a

[12]. clickhouse 基础知识 https://www.jianshu.com/p/a5bf490247ea

* clickhouse官网中文文档  https://clickhouse.com/docs/zh/development/architecture/ 



# 3 OLAP（商业付费）

Tera~简写为T，10的12次方，这是Teradata的大数据。

Exa~简写为E，10的16次方，Oracle超越Teradata的野心。

软硬机一体机出现的场景是：大数据分析时，需要将大容量数据从磁盘读到内存，再作WHERE过滤后只返回部分数据，这时读数据的过程占了很大时间。因此出现了一体机智能扫锚数据，大大减少了需要传输的数据量。

## 3.1 IQ (Sybase/SAP)

1984年，Mark B. Hiffman和Robert Epstern创建了Sybase公司，并在1987年推出了Sybase数据库产品。

Sybase IQ是Sybase公司推出的特别为数据仓库设计的关系型数据库，是第一个商用的列式数据库。

IQ的架构与大多数关系型数据库不同，特别的设计用以支持大量并发用户的即时查询。

*  ASA是Sybase OLTP数据库，行式存储。主要用于移动设备数据库，属于小型数据库产品。

*  IQ是Sybase OLAP和DSS的数据库，采用列式存储，适合数据仓库、数据集市等分析性应用，不符合并发压力大的联机场景。



**SAP Sybase IQ** **功能特性：**
 海量存储（PB级）
 高压缩比 (5~100倍)
 极速装载(Load：34T/h)
 高性能查询
 丰富接口
 线性扩展(集群)
 列式计算
 极简运维

 **SAP Sybase IQ应用场景：**
 自助分析
 分布式数据集市
 数据仓库
 报表查询(DSS)



### 3.1.1   IQ整体架构

   ![1574510990346](../../media/sf_reuse/arch/db/arch_db_iq_001.png)

图 34 SAP IQ 16 Engine



   ![1574511007769](../../media/sf_reuse/arch/db/arch_db_iq_002.png)

图 35 SAP IQ Loading Engine



### 3.1.2   存储架构

   ![1574511028242](../../media/sf_reuse/arch/db/arch_db_iq_003.png)

备注：图中mydb为示例的数据库名称。

一个数据库有一个或者多个实例，每一个实例有自己的元数据存储（mydb.db）、临时存储（mydb.iqtmp）、元数据事务日志（mydb.log）、服务器消息日志（mydb.iqmsg），一个写服务器实例和多个查询服务器实例共享一个IQ存储（mydb.iq）

*  IQ Main Store 数据表空间，通常是dbname.iq
*  Catalog Store 元数据表空间，通常是dbname.db
*  IQ Temporary Store 临时表空间，通常是dbname.iqtmp
*  IQ Message Log IQ信息日志文件(可以清理)，通常是dbname.iqmsg
*  Catalog Store Transaction Log 元数据事务日志文件，通常是dbname.log
*  IQ Server Logs IQ服务器日志，通常是00n.stderr 和00n.srvlog
*  Interfaces 接口文件，通常是$SYSBASE/interfaces



**元数据存储** **(xxx.db)**

元数据存储采用Sybase按行存储的数据库Sybase ASA，其数据库页面通常是4K (4096 byte)，其页面大小在建立数据库时指定。

通常元数据存储中包括如下系统表，完整的系统表列表可以参考SybaseIQ的产品手册：

SYSIQCOLUMN：数据库中的所有表和视图的字段信息；

SYSIQFILE：数据库操作系统文件列表；

SYSIQINDEX：数据库的索引信息；

SYSIQTABLE：数据库中的所有表和视图信息；

这些系统表数据可以通过DBISQL客户端或者 Sybase Central浏览。



**IQ存储** **(xxx.iq)**

Sybase IQ的数据以压缩的索引方式存储在磁盘上的数据 ，也包括SybaseIQ的事务日志，采用(free list)方式管理分配空间，free list指明已经分配给IQ存储的磁盘页面。



## 3.2   HANA (SAP)

2010年SAP全球技术研发者大会上，SAP发布了SAP 高性能分析应用软件（SAP High-Performance Analytic Appliance ，简称SAP HANA），2011年则开始将成熟的产品和解决方案向全球推广,目前SAP HANA也是SAP历史上用户增长速度最为迅猛的产品之一。

SAP HANA是一款支持企业预置型部署和云部署模式的内存计算平台，提供高性能的数据查询功能，用户可以直接对大量实时业务数据进行查询和分析，而不需要对业务数据进行建模、聚合等。

SAP HANA是在Sybase(SAP收购的数据库软件)的基础上开发的基于内存的列数据库，加上内存和存储设备的硬件。

HANA的[内存数据库](https://baike.baidu.com/item/内存数据库)（SAP In-Memory Database, IMDB）是其重要组成部分，包括数据库服务器(In-Memory Database Server)、建模工具（Studio）和客户端工具（ODBO、JDBC、ODBC、SQLDBC等）。HANA的计算引擎（Computing Engine）是其核心，负责解析并处理对大量数据的各类CRUDQ操作，支持SQL和MDX语句、SAP和non-SAP数据。





图 36 HANA软件架构

最下层是SAP ECC、BW及其它非SAP数据源，通过Data Services和Modeling Studio把数据导入HANA，通过Replication Services写到磁盘，，通过HANA计算引擎处理数据插入和查询等操作。HANA是一个平台，在这个平台之上可以是BO、BW，以及其它产品。



## 3.3   Oracle Exadata

**版本历史**

2000~2005，SAGE（网格环境存储设备）--HP的硬件和Oracle软件。

2008年，与HP合作，推出Oracle Exadata X1（定位为数据仓库平台），基本没商用。

2009年9月宣布：推出世界上第一个OLTP数据库机——Sun Oracle数据库机（即Oracle Exadata X2即第二版）。2009年12年，Oracle用74亿美元收购SUN。X2-2定位为大型OLTP系统。

2012年，发布Exadata X3。

​      ![1574511074176](../../media/sf_reuse/arch/db/arch_db_oracle_004.png)



### 3.3.1   软件架构

Oracle Exadata 是核心由Database Machine（数据库服务器） 与 Exadata Storage Server （存储服务器） 组成的一体机硬件平台。运行在exadata的软件核心为Oracle数据库和 Exadata Cell软件，分别对应着ORACLE 11g软件和存储管理软件。

可以将Exadata划分为两部分，即存储层和数据库层，两层使用infiniband网络来连接，使用iDB协议进行通信

*  数据库层：多个sun服务器组成，运行Oracle 11g R2软件，RAC不是必须的，当通常会配置成一个或者多个RAC集群，使用ASM来管理存储(ASM是必须的）。
*  存储层：也是多个sun服务器构成，每个存储服务器12块磁盘，运行Oracle存储服务器软件（cellsrv）。
*  infiniband：提供低延时、高宽带的管钱通信链路，也提供链路上的冗余和联结（bonding）
*  iDB协议：iDB用来将请求和请求的元数据（比如查询谓词where）传到存储服务器软件cellsrv中，通过cellsrv软件在存储中进行智能扫描到需要的数据，然后将最终的结果返回给数据库层，所以将大大减少传输到数据库层的数据量。当不能进行智能扫描时，cellsrv会返回整个Oracle数据块。iDB使用的是RDS协议，这是一种低延时的协议，跳过了内核调用。


 ![1574511054544](../../media/sf_reuse/arch/db/arch_db_hana_001.png)

​    ![1574511130019](../../media/sf_reuse/arch/db/arch_db_oracle_005.png)

图 37 Oracle Exadata软件架构

上半部分是标准的Oracle 11g架构，显示了缓冲区和共享池的全局区（SGA），也显示了一些主要的进程。

下半部分显示一台存储服务器的组件，只有一个进程cellsrv来处理与数据库服务器之间的通信，还拥有一些少数的辅助进程和监控环境。

cellsrv使用init.ora以及alert.log文件，以及ADR（自动诊断信息库）。



图 38 Oracle Exadata软件架构2

 ![1574511171915](../../media/sf_reuse/arch/db/arch_db_oracle_006.png)

### 3.3.2   存储架构

Exadata的磁盘层次结构非常清晰，依次是Physical Disk→LUN→Cell Disk→Grid Disk →
 ASM Disk

  ![1574511305920](../../media/sf_reuse/arch/db/arch_db_oracle_007.png)

图 39 Exadata存储架构

上半部分表示操作系统所在的磁盘（一般为前2块磁盘）的架构；下半部分表示非操作系统盘的存储架构（剩余没有进行分区的10块盘）。

*  Grid Disk在RDBMS层面对应的是ASM disk，Grid Disk和ASM disk实际是同一个东西，但是分别站在Exadata Stroage和RDBMS的角度来看。

*  当前Cell Disk与Grid Disk的对应关系是一对多。

## 3.4   Teradata

Teradata于2007年从其母公司NCR独立出来，是世界上最早提供数据仓库一体机的厂商。

### 3.4.1   Teardata Aster

2015年，数据存储设备厂商Teradata斥资2.63亿美元收购了非结构化数据处理工具软件厂商Aster Data Systems。

Teradata Aster 大数据探索平台（Teradata Aster Discovery Platform），该平台是业内首个最全面的数据探索解决方案，拥有20多项全新的大数据分析能力，包括定制的可视化功能等。借助分析获得的洞察力，将促使企业通过改善客户关系、增加销售量来提升盈利能力。



### 3.4.2   架构



   ![1574511331894](../../media/sf_reuse/arch/db/arch_db_teradata_001.png)

图 40 Teradata架构



### 3.4.3   查询流程

   ![1574511352900](../../media/sf_reuse/arch/db/arch_db_teradata_002.png)

图 41 Teradata数据写取流程图

数据写取步骤

*  Parsing Engine分发需要写入的记录.
*  Message Passing Layer确定应管理记录的AMP
*  AMP将记录写入磁盘一个AMP管理一个逻辑存储单元
*  virtual disk （它对应多个物理的存储单元）



   ![1574511401442](../../media/sf_reuse/arch/db/arch_db_teradata_003.png)

图 42 Teradata数据读取流程图

数据读取步骤

*  Parsing Engine将数据读取请求发送到处理单元
*  Message Passing Layer确定要读取的记录属于哪个AMP管理
*  AMP(s)定位要读取的记录的存储位置并读取.
*  Message Passing Layer将结果记录反馈到PE
*  PE将结果记录反馈到请求端.



## Vertica (Vertica/HP)

[Vertica](http://www.vertica.com/)(2001年被HP收购)，是一个基于DBMS架构的数据库系统，适合读密集的分析型数据库应用，比如数据仓库。





## 本章参考

[1]. impala教程 https://www.w3cschool.cn/impala/

[2]. [FusionInsight LibrA 产品文档](http://support.huawei.com/hedex/pages/EDOC1000157768YZG0630G/02/EDOC1000157768YZG0630G/02/resources/hedex-homepage.html) http://support.huawei.com/hedex/hdx.do?docid=EDOC1000157768&lang=zhSybase

[3]. 列式数据库大PK:Sybase IQ和其他数据库 http://tech.hexun.com/2011-03-22/128100480.html

[4]. Teradata架构 https://wenku.baidu.com/view/d378e5747fd5360cba1adbda.html

[5]. SAP收购Sybase——软件行业垄断格局逐渐形成  https://searchdatabase.techtarget.com.cn/microsite/7-22767/

[6]. Vertica: 基于DBMS架构的列存储数据仓库 https://blog.csdn.net/pelick/article/details/38480313

[7]. HAWQ技术总结 https://www.cnblogs.com/liuzhongfeng/p/8241066.html

[8]. SAP IQ http://infocenter.sybase.com/help/index.jsp

[9]. Oracle Exadata体系笔记https://www.cnblogs.com/zhenxing/p/3905047.html

[10]:  IQ体系结构  http://bbs.chinaunix.net/thread-990918-1-1.html



# 参考资料

**DB官网**  参见  《[数据库技术](../../大数据与AI/storage.存储/数据库技术.md)》相关章节

**相关文档**：《[元数据分析](../../大数据与AI/storage.存储/元数据分析.md)》、《[数据库技术](../../大数据与AI/storage.存储/数据库技术.md)》

