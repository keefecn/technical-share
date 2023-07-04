| 序号  | 修改时间       | 修改内容                         | 修改人   | 审稿人   |
| --- | ---------- | ---------------------------- | ----- | ----- |
| 1   | 2021-12-15 | 创建。从《数据库技术》、《数据库架构》迁移相关章节成文。 | Keefe | Keefe |
|     |            |                              |       |       |

<br><br><br>

---

[TOC]

<br>

---

# 简介

官网：http://www.postgres.org/

官网中文社区： http://www.postgres.cn/

官网文档：https://www.postgresql.org/docs/

[阿里云PostgreSQL](https://www.aliyun.com/product/rds/postgresql)

PostgreSQL是一个功能强大的开源对象关系数据库管理系统(ORDBMS)。 用于安全地存储数据; 支持最佳做法，并允许在处理请求时检索它们。

PostgreSQL(也称为Post-gress-Q-L)由PostgreSQL全球开发集团(全球志愿者团队)开发。 它不受任何公司或其他私人实体控制。 它是开源的，其源代码是免费提供的。PostgreSQL最初设想于1986年，当时被叫做Berkley Postgres Project。该项目一直到1994年都处于演进和修改中，直到开发人员Andrew Yu和Jolly Chen在Postgres中添加了一个SQL（Structured Query Language，结构化查询语言）翻译程序，该版本叫做Postgres95，在开放源代码社区发放。

**PostgreSQL** **的 主要优点如下**：

1）维护者是PostgreSQL Global Development Group，首次发布于1989年6月。

2）操作系统支持WINDOWS、Linux、UNIX、MAC OS X、BSD。

3）从基本功能上来看，支持[ACID](https://baike.baidu.com/item/ACID/10738)、关联完整性、[数据库事务](https://baike.baidu.com/item/数据库事务/9744607)、Unicode多国语言。

4）表和视图方面，PostgreSQL支持临时表，而物化视图，可以使用PL/pgSQL、PL/Perl、PL/Python或其他过程语言的存储过程和触发器模拟。

5）索引方面，全面支持R-/R+tree索引、哈希索引、反向索引、部分索引、Expression 索引、[GiST](https://baike.baidu.com/item/GiST/3204796)、GIN（用来加速全文检索），从8.3版本开始支持位图索引。

6）其他对象上，支持数据域，支持存储过程、触发器、函数、外部调用、游标7）数据表分区方面，支持4种分区，即范围、哈希、混合、列表。

8）从事务的支持度上看，对事务的支持与MySQL相比，经历了更为彻底的测试。

9）MyISAM表处理方式方面，MySQL对于无事务的MyISAM表，采用表锁定，1个长时间运行的查询很可能会阻碍对表的更新，而PostgreSQL不存在这样的问题。

10）从存储过程上看，PostgreSQL支持存储过程。因为存储过程的存在也避免了在网络上大量原始的SQL语句的传输，这样的优势是显而易见的。

11）用户定义函数的扩展方面，PostgreSQL可以更方便地使用UDF（用户定义函数）进行扩展。

## 版本

表格 PG各版本支持周期

| Version                                                 | Current minor | Supported | First Release      | Final Release     |
| ------------------------------------------------------- | ------------- | --------- | ------------------ | ----------------- |
| [14](https://www.postgresql.org/docs/14/index.html)     | 14.1          | Yes       | September 30, 2021 | November 12, 2026 |
| [13](https://www.postgresql.org/docs/13/index.html)     | 13.5          | Yes       | September 24, 2020 | November 13, 2025 |
| [12](https://www.postgresql.org/docs/12/index.html)     | 12.9          | Yes       | October 3, 2019    | November 14, 2024 |
| [11](https://www.postgresql.org/docs/11/index.html)     | 11.14         | Yes       | October 18, 2018   | November 9, 2023  |
| **[10](https://www.postgresql.org/docs/10/index.html)** | 10.19         | Yes       | October 5, 2017    | November 10, 2022 |
| 9.6                                                     | 9.6.24        | No        | September 29, 2016 | November 11, 2021 |
| 9.5                                                     | 9.5.25        | No        | January 7, 2016    | February 11, 2021 |
| 9.4                                                     | 9.4.26        | No        | December 18, 2014  | February 13, 2020 |
| 9.3                                                     | 9.3.25        | No        | September 9, 2013  | November 8, 2018  |
| 9.2                                                     | 9.2.24        | No        | September 10, 2012 | November 9, 2017  |
| 9.1                                                     | 9.1.24        | No        | September 12, 2011 | October 27, 2016  |
| 9.0                                                     | 9.0.23        | No        | September 20, 2010 | October 8, 2015   |
| 8.4                                                     | 8.4.22        | No        | July 1, 2009       | July 24, 2014     |
| 8.3                                                     | 8.3.23        | No        | February 4, 2008   | February 7, 2013  |
| 8.2                                                     | 8.2.23        | No        | December 5, 2006   | December 5, 2011  |
| 8.1                                                     | 8.1.23        | No        | November 8, 2005   | November 8, 2010  |
| 8.0                                                     | 8.0.26        | No        | January 19, 2005   | October 1, 2010   |
| 7.4                                                     | 7.4.30        | No        | November 17, 2003  | October 1, 2010   |
| 7.3                                                     | 7.3.21        | No        | November 27, 2002  | November 27, 2007 |
| 7.2                                                     | 7.2.8         | No        | February 4, 2002   | February 4, 2007  |
| 7.1                                                     | 7.1.3         | No        | April 13, 2001     | April 13, 2006    |
| 7.0                                                     | 7.0.3         | No        | May 8, 2000        | May 8, 2005       |
| 6.5                                                     | 6.5.3         | No        | June 9, 1999       | June 9, 2004      |
| 6.4                                                     | 6.4.2         | No        | October 30, 1998   | October 30, 2003  |
| 6.3                                                     | 6.3.2         | No        | March 1, 1998      | March 1, 2003     |
| ...                                                     |               |           |                    |                   |
| Postgres95                                              |               | No        | 1995               |                   |

> 版本说明： https://www.postgresql.org/support/versioning/
>
> [附录 E. 版本说明 (postgres.cn)](http://www.postgres.cn/docs/14/release.html)
>
> 截止2021.12，维护版本从v10+起。CentOS 8官方仓库PG版本默认是v10.17

查看版本:  `psql --version`

```shell
postgres=# select version();
                                                   version
<br>

-------------------------------------------------------------------------------------------------------------
 PostgreSQL 10.17 on x86_64-redhat-linux-gnu, compiled by gcc (GCC) 8.5.0 20210514 (Red Hat 8.5.0-2), 64-bit
(1 行记录)
```

表格 PG版本特性说明

| 版本     | 首版发布时间     | 特性说明                                                                                                                                                                        |
| ------ | ---------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 15     |            |                                                                                                                                                                             |
| 14     | 2021-09-30 |                                                                                                                                                                             |
| 13     | 2020-09-24 |                                                                                                                                                                             |
| 12     | 2019-10-03 | 支持 SQL/JSON path。支持 Generated Columns。 CTE 支持 Inlined With Queries。 <br>新增 Pluggable Table Storage Interface。 分区表性能大辐提升。 在线重建索引(Reindex Concurrently)                       |
| 11     | 2018-10-18 | 分区增强。并行执行。存储过程，支持嵌入事务。即时编译（JIT），支持表达式的快速求值。窗口函数。                                                                                                                            |
| **10** | 2017-10-05 | 内置分区表（ Native Table Partitioning）。逻辑复制（Logical Replication）。<br/>并行功能增强（Enhancement of Parallel Query）。Quorum Commit for Synchronous Replication。<br/>全文检索支持JSON和JSONB数据类型。 |
| 9.6    | 2016-09-29 | 新功能包括并行查询、同步复制改进、短语搜索、 性能和易用性方面的改进。                                                                                                                                         |
| 9.5    | 2016-01-07 | 主要特性包括IMPORT FOREIGN SCHEMA，Row-Level Security Policies，BRIN 索引，JSONB 数据类型操作的增强，以及 UPSERT 和 pg_rewind 等                                                                     |
| 9.4    | 2014-12-18 | JSONB 数据类型（高性能可索引）、可在线刷新物化视图、支持Linux大页操作、支持数据预热                                                                                                                             |
| 9.3    | 2013-09-09 | 数据校对 checksums、丰富 JSON 函数及操作符、并行 pg_dump 备份、物化视图。                                                                                                                           |
| 9.2    | 2012-09-10 | 级联数据复制、index-only scans、JSON 数据类型、空间分区 GiST 索引（SP-GiST）。                                                                                                                    |
| 9.1    | 2011-09-12 | 支持同步数据复制、unlogged tabels、serializable snapshot isolation、FDW 外部表。                                                                                                           |
| 9.0    | 2010-09-20 | 支持64位Windows系统、异步流数据复制、Hot Standby（相当于Active DataGuard）。                                                                                                                    |

>

## 第三方组件

表格 12 PG的第三方组件

| 组件          | 作用       | 注意点         |
| ----------- | -------- | ----------- |
| PgBouncer   | 轻量级连接池   | 分会话级、事务级。   |
| Slony-I     | 同步。      | 可作多个master。 |
| Bucardo     | 同步。      |             |
| PL/Proxy    | 水平分布中间件。 |             |
| Postgres-XC | 集群。      |             |

## 术语

**表空间**：PostgreSQL中的表空间允许数据库管理员在文件系统中定义用来存放表示数据库对象的文件的位置。

**角色**：PostgreSQL使用*角色*的概念管理数据库访问权限。一个角色可以被看成是一个数据库用户或者是一个数据库用户组，这取决于角色被怎样设置。角色的概念把“用户”和“组”的概念都包括在内。在PostgreSQL版本 8.1 之前，用户和组是完全不同的两种实体，但是现在只有角色。任意角色都可以扮演用户、组或者两者。

<br>

# 入门篇

## 安装&启动&使用

**1）安装**

linux分发版 yum仓库安装

```shell
# 安装详见 https://www.postgresql.org/download/linux/redhat/
# centos 7：use yum
$ sudo yum install postgresql-contrib, postgresql-devel
# centos 8:　use dnf　可指定版本 @postgresql:$version，如例子中的版本10
$ sudo dnf module list postgresql    # 列出可用的pg版本
$ sudo dnf install postgresql-contrib, @postgresql:10

# 初始化数据库，创建三个分别是postgres、template0和template1. 缺省创建了角色postgres-超级管理员，数据库postgres，系统用户postgres
$ initdb -D [DATA_DIR]

# 启动
postgres -D [DATA_DIR]
```

centos 7 pg官网仓库安装 pg14

```shell
# Install the repository RPM:
sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# Install PostgreSQL: bin在/usr/pgsql-14/, 数据目录在/var/lib/pgsql/14/
sudo yum install -y postgresql14-server

```

**2）首次初始化**

可指定数据目录

法1：默认初始化

```shell
$ sudo /usr/pgsql-14/bin/postgresql-14-setup initdb
```

法2：可在环境变量设置PG相关变量，更改数据目录路径。

```shell
$ vi ~/.bash_profile
export PG_HOME=/usr/local/pgsql
export PGDATA=/data/pgsql/data
export PATH=${PG_HOME}/bin:$PATH
export PGPORT=5432
export PGUSER=postgres
export PGDATABASE=postgres

# 重载环境变量
$ source ~/.bash_profile
#用默认地址初始化
$ {PG_HOME}/bin/initdb -D ${PGDATA} -E utf8
```

**3）启动**

service启动：/usr/lib/systemd/system/postgresql-14.service

可在 service里修改 数据目录和其它启动参数

```shell
# 设置服务自动启动
sudo systemctl enable postgresql-14
sudo systemctl start postgresql-14
```

命令行启动：

```shell
$ {PG_HOME}/bin/postgres -D [DATA_DIR]
```

windows下启动：缺省自动创建非管理员账号postgres
`任务管理器 -- 服务 -- postgresql （手动启动）`

**使用**

默认创建一个管理员用户/角色 postgres，默认登录时是不需要密码验证就可以直接登录。

```shell
# 进入到 psql命令行窗口
psql -U [user] [db]

# 默认本地 无密码登陆
$ su postgres
$ psql
# 给缺省角色 postgres 设置密码
postgres=# alter role postgres with password 'yourpassword';
ALTER ROLE
postgres=# select oid,datname from pg_database;
# 创建数据库、授权
postgres=# create database dcs_kzcloud owner postgres;
CREATE DATABASE
postgres=# grant all on database dcs_kzcloud to postgres;
GRANT
postgres=# \q
```

## 常用命令

表格  PostgreSQL常用命令

| DDL    |       | 命令                                                                                          |
| ------ | ----- | ------------------------------------------------------------------------------------------- |
|        | 命令行工具 | createdb/dropdb createuser                                                                  |
| 常用     |       | \? \l \d \du \dt                                                                            |
| create | 创建数据库 | create database xxx;  createdb xx;    # 命令行工具                                               |
| select |       | select * from xxx;                                                                          |
| insert |       |                                                                                             |
| delete |       | drop database xxx;  dropdb xx   # 命令行                                                       |
| 权限     | 创建用户  | create role xxx;    #默认不可登陆  <br/>create user xxx;   #默认可登陆   <br/>createuser xx;      #命令行 |
|        | 授权    | `grant all on table_xxx to user_xxx;`                                                       |

> 只有超级用户和具有`CREATEROLE`特权的角色才能创建新角色。

## 配置文件

主要有以下配置文件： 配置文件缺省目录 /var/lib/pgsql/data/

- postgresql.conf 配置服务器基本信息，如监听
- [pg_hba.conf](http://www.postgres.cn/docs/10/auth-pg-hba-conf.html) 配置数据库访问的认证信息
- pg_ident.conf ident认证配置

可在环境变量里设置数据目录

postgresql.conf

```ini
# 启用远程访问，默认是本地localhost访问
listen_addresses = "*"                  # (change requires restart)
#port = 5432                            # (change requires restart)
max_connections = 100                   # (change requires restart)
...
```

pg_hba.conf (/var/lib/pgsql/14/data/pg_hba.conf)

```ini
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            ident
host    all             all             0.0.0.0/0               md5
# IPv6 local connections:
host    all             all             ::1/128                 ident
# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replication     all                                     peer
host    replication     all             127.0.0.1/32            ident
host    replication     all             ::1/128                 ident
```

说明：第一个字段是连接类型，值可以是local, host, hostssl, hostnossl。最后一列是认证方法。

认证方法：通常支持 peer, ident, md5, trust，此外还支持 password, scram-sha-256, gss, sspi, ldmp, pam, radius, cert, reject等等。

- peer 拿到客户端操作系统用户名，对应unix socker连接。

- ident 类似peer，询问获取客户端操作系统用户名。通过ident协议询问(默认是113监听端口)。

- md5 将口令存为一个MD5哈希。

- trust 信任，无密码登陆。

- scram-sha-256 此加密方式在10以前的旧客户端不支持。SCRAM authentication requires libpq version 10 or above

应用1：本地访问需密码，将 local all那行的认证方式改为 md5或其它加密方式。

应用2：设置远程主机访问，新增一行 `host all all 0.0.0.0/0 md5`

应用3：忘记密码，再重取服务，即可无密码登陆。将 md5 改成 trust

<br>

# 高级篇

pg元数据详见 《[元数据分析.md](./元数据分析.md)》

<br>

# 架构原理篇

   ![1574509903288](../../media/sf_reuse/arch/db/arch_db_pg.png)

图  PostgreSQL体系结构图

PostgreSQL由连接管理系统（系统控制器），编译执行系统，存储管理系统，事务系统，系统表五大部分组成。

## 存储系统

存储系统是PostgreSQL的最底层模块，它向下通过操作系统接口访问物理数据，向上为上层模块提供存储操作的接口和函数。PostgreSQL对物理数据的访问和操作都是通过其存储系统模块来进行的。

PostgreSQL存储系统是由以下几个子模块所构成的：

1）页面管理子模块：对PostgreSQL缓冲区页面的组织结构进行定义以及提供页面操作的方法。

2）缓冲区管理子模块：管理PostgreSQL的缓冲区，包括本地缓冲区和共享缓冲区。

3）存储设备管理子模块：数据库记录是存储在存储介质上的，存储设备管理子模块将屏蔽不同物理存储设备（块设备，流设备）接口函数的差异，向上层缓冲区管理子模块提供统一的访问接口函数。

4）文件管理子模块：一般的操作系统对一个进程允许打开的文件数是有限制的，而PostgreSQL服务器有些时候需要打开的文件数是很多的，因此PostgreSQL文件管理子模块自身为了突破这个瓶颈，封装了文件的读写操作，在这里建立了一个[LRU](https://baike.baidu.com/item/LRU/1269842)链表，通过一定的替换算法来对打开的文件进行管理，使得可以打开的文件数目不受操作系统平台的限制。

## 内存页面

PostgreSQL内存页面的默认大小是8kB。页面的逻辑结构被定义成三个部分：页首部（PageHeader）、元组记录空间（ltem Space）以及特殊空间（Special Space）。

页首部记录了页面的使用信息，这些信息由元组记录空间和特殊空间的偏移量地址、页面分布格式版本号和页面的事物日志记载点等等所组成。

元组记录空间是存储元组信息的地方，在这里面每个元组记录被称为一个ltem，Item由ltemld和元组数据组成，ltemld内部定义了元组在页面中的偏移量、ltem指针的状态以及元组项的比特位数长度。

特殊空间是为了页面操作所需要的。为了其他模块对页面进行操作，PostgreSQL内部定义了一些页面的操作函数。页面的相关操作包括页面初始化、页面添加、修复和删除。供其他子模块进行调用。这里值得关注的是页面修复与页面批量删除的操作函数。为了实现这两个操作函数，PostgreSQL专门定义了一个数据结构itemldSortData，它为方便在这两个函数中对元组项Item实现降序排序而定义。

<br>

<br>

# 参考资料

官网文档

* 官网：http://www.postgres.org/
* 官网中文社区： http://www.postgres.cn/
* 官网文档：https://www.postgresql.org/docs/
* 阿里云PostgreSQL  https://www.aliyun.com/product/rds/postgresql
* 附录 E. 版本说明 (postgres.cn)   http://www.postgres.cn/docs/14/release.html

**参考链接**

* 百度百科-PostgreSQL [PostgreSQL_百度百科](https://baike.baidu.com/item/PostgreSQL)
* 如何在CentOS 8 上安装 PostgreSQL 数据库  https://blog.csdn.net/weixin_39983404/article/details/110571868
* 如何在华为鲲鹏云服务器上安装PostgreSQL  https://bbs.huaweicloud.com/blogs/266148
