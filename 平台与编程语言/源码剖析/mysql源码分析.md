

| 序号 | 修改时间  | 修改内容                              | 修改人 | 审稿人 |
| ---- | --------- | ------------------------------------- | ------ | ------ |
| 1    | 2021-7-28 | 从《MySQL使用指南》相关章节迁入成文。 | Keefe  | Keefe  |
|      |           |                                       |        |        |

<br><br><br>

---

[TOC]



<br>

---

#  0 MySQL架构篇

## 总体架构：插件式存储引擎

**图14.1：MySQL插件式存储引擎的体系结构**

   ![1574509819671](../../media/sf_reuse/arch/db/arch_db_mysql.png)

图  MySQL插件式存储引擎的体系结构

说明：插件式存储引擎体系结构提供了标准的管理和支持服务集合，它们对所有的基本存储引擎来说是共同的。存储引擎本身是数据库服务器的组件，负责对在物理服务器 层面上维护的基本数据进行实际操作。



## 存储引擎

### 存储引擎比较

表格 1 MySQL存储引擎比较列表

| 特点         | MyISAM | BDB  | Memory | InnoDB | Archive |
| ------------ | ------ | ---- | ------ | ------ | ------- |
| 存储限制     | 没有   | 没有 | 有     | 64TB   | 没有    |
| **事务安全** |        | 支持 |        | *支持* |         |
| 锁机制       |        |      |        |        |         |
| B树索引      | 支持   | 支持 | 支持   | 支持   |         |
| 哈希索引     |        |      | 支持   | 支持   |         |
| 全文索引     | *支持* |      |        |        |         |
| 集群索引     |        |      |        | 支持   |         |
| 数据缓存     |        |      | 支持   | 支持   |         |
| 索引缓存     | 支持   |      | 支持   | 支持   |         |
| 数据可压缩   | 支持   |      |        |        | 支持    |
| 空间使用     | 低     | 低   | N/A    | 高     | 非常低  |
| 内存使用     | 低     | 低   | 中等   | 高     | 低      |
| 批量插入速度 | 高     | 高   | 高     | 低     | 非常高  |
| 支持外键     |        |      |        | 支持   |         |

说明：MyISAMt和InnoDB是最常用的两种存储引擎。

*  MyISAM：默认的MySQL插件式存储引擎，它是在Web、数据仓储和其他应用环境下最常使用的存储引擎之一。适合进行 **OLAP** 运算。支持更多数据类型，管理非事务表，提供高速存储和检索，以及全文搜索能力（全文索引只能用MyISAM表）。注意，通过更改STORAGE_ENGINE配置变量，能够方便地更改MySQL服务器的默认存储引擎。
*  InnoDB：用于事务处理应用程序，具有众多特性，包括ACID事务支持。用于数据完整性/写性能要求比较高的应用。是为处理巨大数据量时的最大性能设计。需要做更多的配置，不过值得，可以更安全的存储数据，以及得到更快的速度。相比MyISAM，写的效率会低些并且会占用更多磁盘空间用来保存索引和数据。
*  BDB：可替代InnoDB的事务引擎，支持COMMIT、ROLLBACK和 其他事务特性。
*  Memory：将所有数据保存在RAM中，在需要快速查找引用和 其他类似数据的环境下，可提供极快的访问。
*  Merge：允许MySQL DBA或开发人员将一系列等同的MyISAM表以逻辑方式组合在一起，并作为1个 对象引用它们。对于诸如数据仓储等VLDB环境十分适合。
*  Archive：为大量很少引用的历史、归档、或安全审计信息的存储和检索提供了完美的解决 方案。
*  Federated：能够将多个分离的MySQL服务器链接起 来，从多个物理服务器创建一个逻辑数据库。十分适合于分布式环境或数据集市环境。
*  Cluster/NDB：MySQL的簇式数据库引擎，尤其适合 于具有高性能查找要求的应用程序，这类查找需求还要求具有最高的正常工作时间和可用性。
*  Other：其他存储引擎包括CSV（引用由逗号隔开的用作数据 库表的文件），Blackhole（用于临时禁止对数据库的应用程序输入），以及Example引 擎（可为快速创建定制的插件式存储引擎提供帮助）。



### 自定义存储引擎

实施新存储引擎的最简单方法是，通过拷贝和更改EXAMPLE存储引擎开始。在MySQL 5.1源码树的sql/examples/目录下可找到文件ha_example.cc和ha_example.h。



### 使用存储引擎

**1)** **将存储引擎指定给表**

可以在创建新表时指定存储引擎，或通过使用ALTER TABLE语句指定存储引擎。

要想在创建表时指定存储引擎，可使用ENGINE参数： （示例表名：engineTest）

```mysql
CREATE TABLE engineTest(
id INT
) ENGINE = MyISAM;
```



要想更改已有表的存储引擎，可使用ALTER TABLE语句：

`ALTER TABLE engineTest ENGINE = ARCHIVE;`



**2)** **插入拨出存储引擎**

能够使用存储引擎之前，必须使用INSTALL PLUGIN语句将存储引擎plugin（插件）装载到mysql。例如，要想加载example引擎，首先应加载ha_example.so模块：

INSTALL PLUGIN *ha_example* SONAME '*ha_example.so*';

文件.so必须位于MySQL服务器库目录下（典型情况下是installdir/lib）



要想拔出存储引擎，可使用UNINSTALL PLUGIN语句：

UNINSTALL PLUGIN *ha_example*;

如果拔出了正被已有表使用的存储引擎，这些表将成为不可访问的。拔出存储引擎之前，请确保没有任何表使用该存储引擎。



**3)** **插件式存储器的安全含义**

为了安装插件式存储引擎，*plugin*文件必须位于恰当的MySQL库目录下，而且发出INSTALL PLUGIN语句的用户必须具有SUPER权限。



## MySQL数据表的存储（磁盘文件）

MySQL通过数据库目录中的.frm表格式（定义）文件表示每个表。表的存储引擎也可能会创建其它文件。对于MyISAM表，存储引擎可以创建数据和索引文件。

MySQL数据表类型有：ISAM、MyISAM、MERGE、BDB、InnoDB和HEAP。每种数据表在文件系统中都有不同的表示方式，有一个共同点就是每种数据表至少有一个存放数据表结构定义的.frm文件。下面介绍每种数据表文件：

表格 2 MySQL数据表类型

| 数据表   类型 | 简介                                                         | 存储文件                                                     | 备注 |
| ------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
| ISAM          | ISAM数据表是最原始的数据表，有三个文件                       | *.frm，存放数据表的结构定义；<br>*.ISD，数据文件，存放数据表中的各个数据行的内空；<br>*.ISM，索引文件，存放数据表的所有索引信息。 |      |
| MyISAM        | MyISAM数据表是ISAM数据表的继承者，也有三个文件。             | *  .frm，结构定义文件；<br/>*  .MYD，数据文件；   <br/>*  .MYI，索引文件。 |      |
| MERGE         | MERGE数据表是一个逻辑结构，代表一组结构完全相同的MyISAM数据表构成的集合。它在文件系统中有二个文件。 | *  .frm，结构定义文件；   <br/>*  .MRG，构成MERGE表的MyISAM数据表清单，每个MyISAM数据表名占一行。也就是说可通过改变该表的内容来改变MERGE数据表的结构。修改前请先刷新缓存(flush tables)，但不建议这样修改MERGE数据表。 |      |
| BDB           | BDB数据表用两个文件来表示                                    | *  .frm，结构定义文件；   <br/>*  .db，数据表数据和索引文件  |      |
| InnoDB        | InnoDB由于采用表空间的概念来管理数据表，所以它只有一个与数据表对应.frm文件，同一目录下的其它文件表示为表空间，存储数据表的数据和索引。 | *  .frm，结构定义文件；                                      |      |
| HEAP          | HEAP数据表是一个存在于内存中的表，所以它的数据和索引都存在于内存中。文件系统中只有一个.frm文件，以定义结构。 | *  .frm，结构定义文件；                                      |      |

备注：了解MySQL数据表在文件系统中表现形式后，我们可知道，创建、修改或删除数据表，其实就是对这些文件进行操作。例如一些数据表(除InnoDB和HEAP数据表外)，我们可直接在文件系统中删除相应的文件来删除数据表。

```
% cd datadir
% rm -f mydb/mydb.*
```

以上命令可删除mydb数据库中的mydb数据表。



## MySQL索引的存储结构

FULLTEXT索引只能对CHAR, VARCHAR和TEXT列编制索引，并且只能在MyISAM表中编制。

部分储存引擎允许在创建索引时指定索引类型。*index_type*指定语句的语法是USING *type_name*。不同的储存引擎所支持的*type_name*值已显示在下表中。如果列有多个索引类型，当没有指定*index_type*时，第一个类型是默认值。

| **存储引擎** | **允许的索引类型** |
| ------------ | ------------------ |
| MyISAM       | B TREE             |
| InnoDB       | B+ TREE            |
| MEMORY/HEAP  | HASH, BTREE        |

示例：

```mysql
CREATE TABLE lookup (id INT) ENGINE = MEMORY;
CREATE INDEX id_index USING BTREE ON lookup (id);
```

#  1 代码结构

整体架构 详见： 《[数据库架构](数据库架构.md)》MySQL实现章节。

代码版本：5.7

编程语言：C



<br>

# 2 MySQL存储引擎实现





<br>

# 3  MySQL查询实现





# 4 MySQL应用开发

参见  [MySQL应用开发：API](http://doc.mysql.cn/mysql5/refman-5.1-zh.html-chapter/apis.html#c)

## Connector~C API：MySQL连接对象探讨

参考: http://doc.mysql.cn/mysql5/refman-5.1-zh.html-chapter/apis.html#c

### MySQL结构体st_mysql

以下代码块是用来连接数据库的通讯过程

```c
typedef struct st_mysql {
  NET           net;            /* Communication parameters */
  gptr          connector_fd;   /* ConnectorFd for SSL */
  char          *host,*user,*passwd,*unix_socket,
                *server_version,*host_info,*info,*db;
  unsigned int  port,client_flag,server_capabilities;
  unsigned int  protocol_version;
  unsigned int  field_count;
  unsigned int  server_status;
  unsigned long thread_id;      /* Id for connection in server */
  my_ulonglong affected_rows;
  my_ulonglong insert_id;       /* id if insert on table with NEXTNR */
  my_ulonglong extra_info;              /* Used by mysqlshow */
  unsigned long packet_length;
  enum mysql_status status;
  MySQL_FIELD   *fields;
  MEM_ROOT      field_alloc;
  my_bool       free_me;        /* If free in mysql_close */
  my_bool       reconnect;      /* set to 1 if automatic reconnect */
  struct st_mysql_options options;
  char          scramble_buff[9];
  struct charset_info_st *charset;
  unsigned int  server_language;
} MySQL;
```



**MySQL结构大小**：

`printf("size = %u\n", sizeof(MySQL));`

**测试结果**：

```c
[wuqifu@localhost sqltest]$ ./a.out
size = 952bytes（v5.1.12是954bytes）
```

new MySQL时除下面2个，其它所有数据将初始化为0；

methods_to_use = MySQL_OPT_CONNECT_TIMEOUT,

status = MySQL_STATUS_READY,



mysql_init()后会填充的数据：

```c
options{ thods_to_use = MySQL_OPT_GUESS_CONNECTION,report_data_truncatio=1; }
rpl_pivot = 1 '\001',
master = 0x9565008,
next_slave = 0x9565008,
last_used_con = 0x9565008,
```

mysql_real_connect后填充的数据：

注：4.1..7版reconnect此时填充为1，默认可自动重连接，而5.1.13则填充为0，则手动设置才能重连。

```shell
(gdb) p *ll_mysql
$8 = {
 net = {
  vio = 0x95658a0,
  buff = 0x956a108 "",
  buff_end = 0x956c108 "",
  write_pos = 0x956a108 "",
  read_pos = 0x956a108 "",
  fd = 7,
  max_packet = 8192,
  max_packet_size = 1073741824,
  pkt_nr = 3,
  compress_pkt_nr = 3,
  write_timeout = 31536000,
  read_timeout = 31536000,
  retry_count = 1,
  fcntl = 0,
  compress = 0 '\0',
  remain_in_buf = 0,
  length = 0,
  buf_length = 0,
  where_b = 0,
  return_status = 0x0,
  reading_or_writing = 0 '\0',
  save_char = 0 '\0',
  no_send_ok = 0 '\0',
  no_send_eof = 0 '\0',
  no_send_error = 0 '\0',
  last_error = '\0' <repeats 511 times>,
  sqlstate = "00000",
  last_errno = 0,
  error = 0 '\0',
  query_cache_query = 0x0,
  report_error = 0 '\0',
  return_errno = 0 '\0'
 },
 connector_fd = 0x0,
 host = 0x957b138 "localhost",
 user = 0x957b1a0 "mysqluser",
 passwd = 0x957b1b0 "456789",
 unix_socket = 0x957b148 "/var/lib/mysql/mysql.sock",
 server_version = 0x957b168 "5.1.12-beta",
 host_info = 0x957b118 "Localhost via UNIX socket",
 info = 0x0,
 db = 0x957b1c0 "test",
 charset = 0x9646c0,
 fields = 0x0,
<br>

---Type <return> to continue, or q <return> to quit---
 field_alloc = {
  free = 0x0,
  used = 0x0,
  pre_alloc = 0x0,
  min_malloc = 0,
  block_size = 0,
  block_num = 0,
  first_block_usage = 0,
  error_handler = 0
 },
 affected_rows = 0,
 insert_id = 0, 　 /* id if insert on table with NEXTNR */
 extra_info = 0,
 thread_id = 76, 　 /* Id for connection in server */
 packet_length = 0,
 port = 0,
 client_flag = 41613,
 server_capabilities = 41516,
 protocol_version = 10,
 field_count = 0,
 server_status = 2,
 server_language = 8,
 warning_count = 0,
 options = {
  connect_timeout = 0,
  read_timeout = 0,
  write_timeout = 0,
  port = 0,
  protocol = 2,
  client_flag = 128,
  host = 0x0,
  user = 0x0,
  password = 0x0,
  unix_socket = 0x0,
  db = 0x0,
  init_commands = 0x0,
  my_cnf_file = 0x0,
  my_cnf_group = 0x0,
  charset_dir = 0x0,
  charset_name = 0x9565940 "latin1",
  ssl_key = 0x0,
  ssl_cert = 0x0,
  ssl_ca = 0x0,
  ssl_capath = 0x0,
  ssl_cipher = 0x0,
  shared_memory_base_name = 0x0,
<br>

---Type <return> to continue, or q <return> to quit---
  max_allowed_packet = 0,
  use_ssl = 0 '\0',
  compress = 0 '\0',
  named_pipe = 0 '\0',
  rpl_probe = 0 '\0',
  rpl_parse = 0 '\0',
  no_master_reads = 0 '\0',
  separate_thread = 0 '\0',
  methods_to_use = MySQL_OPT_GUESS_CONNECTION,
  client_ip = 0x0,
  secure_auth = 0 '\0',
  report_data_truncation = 1 '\001',
  local_infile_init = 0,
  local_infile_read = 0,
  local_infile_end = 0,
  local_infile_error = 0,
  local_infile_userdata = 0x0
 },
 status = MySQL_STATUS_READY,
 free_me = 0 '\0', 　 /* If free in mysql_close */
 reconnect = 0 '\0', 　 /* set to 1 if automatic reconnect */
 scramble = "{dcGt8V+oo`uIM'wG<56",
 rpl_pivot = 1 '\001',
 master = 0x9565008,
 next_slave = 0x9565008,
 last_used_slave = 0x0,
 last_used_con = 0x9565008,
 stmts = 0x0,
 methods = 0xa77ae0,
 thd = 0x0,
 unbuffered_fetch_owner = 0x0,
 info_buffer = 0x0
}

```


### 初始化mysqsl_init

```
MySQL *mysql_init(MySQL *mysql)
```

20.4.28.1 说明

分配或初始化适合`mysql_real_connect()`的一个`MySQL`对象。如果`mysql`是一个`NULL`指针，函数分配、初始化并且返回一个新对象。否则对象被初始化并且返回对象的地址。如果`mysql_init()`分配一个新对象，它将在调用`mysql_close()`关闭连接时被释放。



20.4.28.2 返回值

一个被初始化的`MySQL*`句柄。如果没有足够的内存来分配一个新对象，`NULL`。



20.4.28.3 错误

在内存不够的情况下，返回`NULL`。



**测试说明**：

1）`mysql_init()``初始化一个对象`，传入参数不为空，那么它的参数与它的返回值指向的是同一地址，这个对象要用户自己销毁，并还得调用mysql_close.

​    MySQL* l_mysql = new MySQL;

​    MySQL* ll_mysql;

​    ll_mysql = mysql_init(l_mysql);

​    printf("l_mysql=%x, ll_mysql=%x\n", l_mysql, ll_mysql);

**测试结果1**：

 [wuqifu@localhost sqltest]$ ./a.out

size = 952

l_mysql=83c8008, ll_mysql=83c8008



2）`mysql_init()`分配一个新对象，传入参数为NULL指针。那么它的返回值就是新分配对象的指针，此指针在mysql_close()时将自动关闭连接并释放。



### 连接mysql_real_connect

`MySQL *mysql_real_connect(MySQL *mysql, const char *host, const char *user, const char *passwd, const char *db, unsigned int port, const char *unix_socket, unsigned int client_flag) `



**20.4.40.1** **说明**

mysql_real_connect()试图建立到运行host的一个MySQL数据库引擎的一个连接。 mysql_real_connect()在你可以执行任何其他API函数之前必须成功地完成，除了mysql_get_client_info()。



参数指定如下：

第一个参数应该是一个现存MySQL结构的地址。在调用mysql_real_connect()之前，你必须调用mysql_init()初始化MySQL结构。



**20.4.40.2** **返回值**

如果连接成功，一个 MySQL*连接句柄。如果连接失败，NULL。对一个成功的连接，**返回值与第一个参数值相同**，除非你传递NULL给该参数。



**20.4.40.3** **错误**

CR_CONN_HOST_ERROR

不能连接MySQL服务器。

CR_CONNECTION_ERROR

不能连接本地MySQL服务器。

CR_IPSOCK_ERROR

不能创建一个IP套接字。

CR_OUT_OF_MEMORY

内存溢出。

CR_SOCKET_CREATE_ERROR

不能创建一个Unix套接字。

CR_UNKNOWN_HOST

不能找到主机名的IP地址。

CR_VERSION_ERROR

由于试图使用一个不同协议版本的一个客户库与一个服务器连接导致的一个协议失配。如果你使用一个非常老的客户库连接一个没有使用--old-protocol选项启动的新服务器，这就能发生。

CR_NAMEDPIPEOPEN_ERROR;

不能在 Win32 上创建一个命名管道。

CR_NAMEDPIPEWAIT_ERROR;

不能在 Win32 上等待一个命名管道。

CR_NAMEDPIPESETSTATE_ERROR;

不能在 Win32 上得到一个管道处理器。



1）测试函数调用后，连接指针是否发生改变

mysql_real_connect()执行后，每一个参数与返回值的MySQL*都与前面初始化时的指针相等，说明它们指向的是同一个同存地址，指向同一个结构MySQL。

```c
    MySQL* l_mysql = new MySQL;
    MySQL* ll_mysql;
    ll_mysql = mysql_init(l_mysql);
    printf("l_mysql=%x, ll_mysql=%x\n", l_mysql, ll_mysql);

    ll_mysql = mysql_real_connect(l_mysql,"localhost", "mysqluser", "456789", "test",0,NULL,0);
    if(!ll_mysql)
    {
      printf( "Error connecting to database: %s\n",mysql_error(&mysql));
    }
    else
    {
       printf("Connected...\n");
    }
    printf("l_mysql=%x, ll_mysql=%x\n", l_mysql, ll_mysql);
```

**测试结果**：

[wuqifu@localhost mysql]$ ./a.out

l_mysql=9fd7008, ll_mysql=9fd7008, l_mysql=9fd7008

Connected...

l_mysql=9fd7008, ll_mysql=9fd7008



2）测试重连后是否产生新线程，造成内存泄露

```c
 for(int i=0; i<2; i++){
    ll_mysql = mysql_real_connect(l_mysql,"localhost", "mysqluser", "456789", "test",0,NULL,0);
    if(!ll_mysql)
    {
      printf( "Error connecting to database: %s\n",mysql_error(&mysql));
    }
    else
    {
       printf("\nConnected...\n");
    }
    printf("[%d]l_mysql=%x, ll_mysql=%x\n",i, l_mysql, ll_mysql);
    printf("ll_mysql=%x, fd=%d, threadid=%d, reconnect=%d\n", ll_mysql,ll_mysql->net.fd,ll_mysql->thread_id,ll_mysql->reconnect);
 }
```

**测试结果**：

Connected...

[0]l_mysql=8e10008, ll_mysql=8e10008

ll_mysql=8e10008, fd=3, threadid=77, reconnect=0



Connected...

[1]l_mysql=8e10008, ll_mysql=8e10008

ll_mysql=8e10008, fd=4, threadid=78, reconnect=0



### MySQL连接的内存管理

1）MySQL* l_mysql = new MySQL;

```shell
说明：new了不关闭的情形，只会导致still reachable 972=956+16, 而没有引起程序泄露或mysqld内存泄露，真是有意思，难道mysql已经托管了跟它有关的内存？
ERROR SUMMARY: 1 errors from 1 contexts (suppressed: 21 from 2)
==17306== malloc/free: in use at exit: 972 bytes in 2 blocks.
==17306== malloc/free: 48 allocs, 47 frees, 4618 bytes allocated.
==17306== For counts of detected errors, rerun with: -v
==17306== searching for pointers to 2 not-freed blocks.
==17306== checked 4149148 bytes.
==17306==
==17306==
==17306== 16 bytes in 1 blocks are still reachable in loss record 1 of 2
==17306==  at 0x1B904984: malloc (vg_replace_malloc.c:131)
==17306==  by 0x93381D: my_malloc (in /usr/lib/libmysqlclient.so.15.0.0)
==17306==  by 0x93466D: my_error_register (in /usr/lib/libmysqlclient.so.15.0.0)
==17306==  by 0x933491: init_client_errs (in /usr/lib/libmysqlclient.so.15.0.0)
==17306==
==17306==
==17306== 956 bytes in 1 blocks are still reachable in loss record 2 of 2
==17306==  at 0x1B904AFB: operator new(unsigned) (vg_replace_malloc.c:133)
==17306==  by 0x8048CA6: main (testsql.cpp:63)
==17306==
==17306== LEAK SUMMARY:
==17306==  definitely lost: 0 bytes in 0 blocks.
==17306==  possibly lost:  0 bytes in 0 blocks.
==17306==  still reachable: 972 bytes in 2 blocks.
==17306==     suppressed: 0 bytes in 0 blocks.
```

2）MySQL* l_mysql = new MySQL;　 delete l_mysql;

​    说明：new了个MySQL指针，如果又主动删除了，将会只有16b的still reachable，而这种情形使用了mysql_close()并没明显影响，基本认为此时mysql_close()可无可有。但如果调用了mysql_real_connect后，那么就一定要mysql_close(),　否则会出现泄露。

```shellERROR SUMMARY: 64 errors from 32 contexts (suppressed: 21 from 2)
==17330== malloc/free: in use at exit: 16 bytes in 1 blocks.
==17330== malloc/free: 48 allocs, 48 frees, 4618 bytes allocated.
==17330== For counts of detected errors, rerun with: -v
==17330== searching for pointers to 1 not-freed blocks.
==17330== checked 4152288 bytes.
==17330==
==17330==
==17330== 16 bytes in 1 blocks are still reachable in loss record 1 of 1
==17330==  at 0x1B904984: malloc (vg_replace_malloc.c:131)
==17330==  by 0x93381D: my_malloc (in /usr/lib/libmysqlclient.so.15.0.0)
==17330==  by 0x93466D: my_error_register (in /usr/lib/libmysqlclient.so.15.0.0)
==17330==  by 0x933491: init_client_errs (in /usr/lib/libmysqlclient.so.15.0.0)
==17330==
==17330== LEAK SUMMARY:
==17330==  definitely lost: 0 bytes in 0 blocks.
==17330==  possibly lost:  0 bytes in 0 blocks.
==17330==  still reachable: 16 bytes in 1 blocks.
==17330==     suppressed: 0 bytes in 0 blocks.

```

3）NULL指针传入参数

如果是NULL指针传入参数创建的新MySQL对象，使用mysql_close()将会自动释放。

此时的测试结果同2）。



**4）一次调用mysql_real_connect后的内存管理**

　如果是new出来的MySQL对象，那么一定要自己delete, 然后调用mysql_close; 而如果是由NULL生成的MySQL对象，那么只需mysql_close. 上面如果不那么做，就一定会引起内存泄露。



**5）二次调用mysql_real_connect后的内存管理**

调用后，虽然用了

```c
    my_pid = mysql_thread_id(ll_mysql);
    mysql_kill(ll_mysql,my_pid);
```

如果还是用原来的结构，这时原有的线程能被删除，但会引起严重的内存泄露，就是这种2个线程共用一个结构是极其危险的。

测试用例：

```c
    ll_mysql = mysql_real_connect(ll_mysql,"localhost", "mysqluser", "456789", "test",0,NULL,0);
    if(!ll_mysql)
    {
      printf( "Error connecting to database: %s\n", mysql_error(ll_mysql));
    }
    else
    {
       printf("\nConnected...\n");
    }
    my_pid = mysql_thread_id(ll_mysql);
    mysql_kill(ll_mysql,my_pid);
    ll_mysql = mysql_real_connect(ll_mysql,"localhost", "mysqluser", "456789", "test",0,NULL,0);
    if(!ll_mysql)
    {
      printf( "Error connecting to database: %s\n", mysql_error(ll_mysql));
    }
    else
    {
       printf("\nConnected...\n");
    }
```

测试结果：

```shell==8921==
==8921== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 21 from 2)
==8921== malloc/free: in use at exit: 49554 bytes in 20 blocks.
==8921== malloc/free: 84 allocs, 64 frees, 89151 bytes allocated.
==8921== For counts of detected errors, rerun with: -v
==8921== searching for pointers to 20 not-freed blocks.
==8921== checked 3790712 bytes.
==8921==
==8921== 16850 bytes in 12 blocks are definitely lost in loss record 1 of 2
==8921==  at 0x1B904984: malloc (vg_replace_malloc.c:131)
==8921==  by 0x264992: my_malloc (in /usr/lib/mysql/libmysqlclient.so.14.0.0)
==8921==  by 0x28558B: vio_new (in /usr/lib/mysql/libmysqlclient.so.14.0.0)
==8921==  by 0x28291E: mysql_real_connect (in /usr/lib/mysql/libmysqlclient.so.14.0.0)
==8921==
==8921== LEAK SUMMARY:
==8921==  definitely lost: 16850 bytes in 12 blocks.
==8921==  possibly lost:  0 bytes in 0 blocks.
==8921==  still reachable: 32704 bytes in 8 blocks.
==8921==     suppressed: 0 bytes in 0 blocks.
==8921== Reachable blocks (those to which a pointer was found) are not shown.
==8921== To see them, rerun with: --show-reachable=yes
```



### mysql_ping

**1）MySQL连接有效性维护：mysql_ping**

```
int mysql_ping(MySQL *mysql)
```

20.4.38.1 说明

检查到服务器的连接是否正在工作。如果它关闭了，自动尝试一个再连接。

这个函数可被已经空闲很长时间的客户使用，来检查服务器是否关闭了连接并且如有必要重新连接。



20.4.38.2 返回值

如果服务器活着，零。如果出现一个错误，非零。



20.4.38.3 错误

```
CR_COMMANDS_OUT_OF_SYNC 命令以一个不适当的次序被执行。
CR_SERVER_GONE_ERROR    MySQL服务器关闭了。
CR_UNKNOWN_ERROR    发生一个未知的错误。
```
**版本差异导致的结果**：

mysql默认使用了8小时将会自动关闭连接，但是我们可以通过mysql_ping将其激活。

v4.1.7似乎如果mysql_init使用非空指针，那么这个mysql_ping时使用的效果似乎更好，从测试结果来看，（但这个版本默认reconnect=1的，可自动重连接）；而v5.1.13 mysql_ping的结果似乎是由reconnect的参数决定的，而这个参数是默认为0，不可自动重连接，但v5.1.13提供了mysql_options来改变参数；

跨版本支持：v5.1.13

```c
    my_bool my_true = true;
    if (mysql_options(ll_mysql, MySQL_OPT_RECONNECT, &my_true))
    {
     printf("mysql_options failed: unknown option MySQL_OPT_RECONNECT\n");
     return -1;
    }
```

common versiong:

  ll_mysql->reconnect = 1;



**2）MySQL连接使用次数控制**

通常使用次数可由程序来控制，让程序计算使用次数，进行控制。MySQL本身没对使用次数进行限制。



**3）MySQL如何解决打开文件描述符的数量限制**

/var/lib/mysql.sock　//for v5.1.12

The MySQL socket file is created as `/tmp/mysql.sock' by default.

| socket             | /var/lib/mysql/mysql.sock                 |



###  结论

**内存管理小结**

　 如果是由自己new出来的MySQL对象，在调用mysql_real_connect成为有效的MySQL连接对象后，释放时要做到2步，1）由mysql_close()来关闭这个MySQL结构里面由mysql来管理的内存，2）delete这个对象指针，释放由自己new的堆对象，这样才能做到不泄露。

　 如果是由NULL指针初始化产生的MySQL对象，在调用mysql_real_connect成为有效指针对象后，只要求调用mysql_close,就能释放由mysql管理的连接线程与内存。

　 每调用一次mysql_real_connect都会产生一个有效的MySQL连接对象，但它们会调用传入的同一个指针来保存，这时无论谁关闭了这个MySQL，都会导致内存泄露。因此，在重新调用每一个mysql_real_connect时要求mysql_close来关闭此前的MySQL管理的内存。



## MySQL各语言注意事项

### [MySQL PHP API](http://doc.mysql.cn/mysql5/refman-5.1-zh.html-chapter/apis.html#php)

**使用MySQL和PHP的常见问题**

错误：超出了最大执行时间，这是一种PHP限制，如果需要，进入文件php.ini，并设置最大执行时间（开始为30秒。max_execution_time = 30）。此外，还可以将每脚本允许使用的RAM增加一倍，从8MB变为16MB，这也是个不错的主意。



致命错误：在…中调用了不支持或未定义的mysql_connect()函数，这意味着，你的PHP版本不支持MySQL。你可以编译动态MySQL模块并将其加载到PHP，或使用内置的MySQL支持重新编译PHP。在PHP手册中，详细介绍了该进程。



错误：对'uncompress'的未定义引用，这意味着所编译的客户端库支持压缩客户端／服务器协议。更正方法是，用“-lmysqlclient”进行链接时，在最后添加“-lz”。



错误：客户端不支持鉴定协议，与MySQL 4.1.1和更高版本一起使用较旧的mysql扩展时常会遇到该问题。可能的解决方案是：降级到MySQL 4.0，转向PHP 5和较新的mysqli扩展，或用“--old-passwords”配置MySQL服务器（更多信息，请参见[A.2.3节，“客户端不支持鉴定协议”](http://doc.mysql.cn/mysql5/refman-5.1-zh.html-chapter/problems.html#old-client)）。



### MySQL Python API

MySQLdb为Python提供了MySQL支持，它符合Python DB API版本2.0的要求，可在http://sourceforge.net/projects/mysql-python/上找到它。



## PHPMyAdmin管理MySQL

https://www.phpmyadmin.net/

表结构分析：可规划表结构。

表字段：可查看非重复值， select count(*distinct* name) from tbl_name

**范式分析Normal Form**：提升表结构



### 数据字典示例

$show create pet

http://localhost/phpMyAdmin/db_datadict.php?db=game&token=1d3d6a83fe0ff79bc367c15256cf3760&goto=db_structure.php



表格 4 pet表结构

| Field       | Type         | Null | Key  | Default             | Extra                       |      |
| ----------- | ------------ | ---- | ---- | ------------------- | --------------------------- | ---- |
| id          | int(10)      | NO   | PRI  | NULL                | auto_increment              |      |
| mtime       | timestamp    | NO   | MUL  | CURRENT_TIMESTAMP   | on update CURRENT_TIMESTAMP |      |
| price       | varchar(32)  | NO   |      | 0                   |                             |      |
| name        | varchar(32)  | NO   |      |                     |                             |      |
| typeid      | varchar(10)  | NO   | MUL  | 0                   |                             |      |
| lx          | tinyint(4)   | YES  |      | 0                   |                             |      |
| is_baobao   | tinyint(1)   | YES  |      | 0                   |                             |      |
| skills      | varchar(255) | YES  |      | *NULL*              |                             |      |
| ctime       | datetime     | YES  |      | 2016-05-01 00:00:00 |                             |      |
| sqlkey      | varchar(255) | NO   |      | *NULL*              |                             |      |
| uniq_sqlkey | varchar(32)  | NO   | UNI  | *NULL*              |                             |      |
| calc_price  | varchar(32)  | NO   |      | 0                   |                             |      |

*注：执行命令$desc pet**可获取。*



表格 5 pet表的索引组成

| 键名        | 类型  | 唯一 | 紧凑 | 字段        | 基数 | 排序规则 | 空   | 注释 |
| ----------- | ----- | ---- | ---- | ----------- | ---- | -------- | ---- | ---- |
| PRIMARY     | BTREE | 是   | 否   | id          | 5472 | A        | 否   |      |
| uniq_sqlkey | BTREE | 是   | 否   | uniq_sqlkey | 5472 | A        | 否   |      |
| mtime       | BTREE | 否   | 否   | mtime       | 2736 | A        | 否   |      |
| typeid      | BTREE | 否   | 否   | typeid      | 365  | A        | 否   |      |

注：执行命令$ [show](http://localhost/phpMyAdmin/url.php?url=https://dev.mysql.com/doc/refman/5.5/en/show-index.html) [index](http://localhost/phpMyAdmin/url.php?url=https://dev.mysql.com/doc/refman/5.5/en/show-index.html) from pet或者$ [show](http://localhost/phpMyAdmin/url.php?url=https://dev.mysql.com/doc/refman/5.5/en/show-index.html) [keys](http://localhost/phpMyAdmin/url.php?url=https://dev.mysql.com/doc/refman/5.5/en/show-index.html) from pet可获取。



### 常用修改

远程访问数据库

修改libraries文件夹下的config.default.php文件或者phpmyadmin根目录的config.inc.php文件。

1、查找$cfg['PmaAbsoluteUri'] ，将其值设置为你本地的phpmyadmin路径

2、查找$cfg['Servers'][$i]['host'] ， 将其值设置为你mysql数据库地址，例如127.0.0.1

3、查找$cfg['Servers'][$i]['user'] ， 将其值设置为你mysql数据库用户名，例如admin

4、查找$cfg['Servers'][$i]['password'] ， 将其值设置为你mysql数据库密码，例如admin

然后重启apache即生效。



1）修改数据库导入限制大小，修改php.ini

```ini
uplod_max_filesize = 2M
post_max_size = 8M
memory_limit = 128M
```



<br>

# 参考资料

**官网**

* [dev.mysql.com](http://dev.mysql.com/doc/mysql/en)
* http://doc.mysql.cn/



**参考链接**



