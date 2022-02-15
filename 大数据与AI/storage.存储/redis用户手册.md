| 序号 | 修改时间  | 修改内容                                           | 修改人 | 审稿人 |
| ---- | --------- | -------------------------------------------------- | ------ | ------ |
| 1    | 2021-12-9 | 创建。从《数据库技术》、《数据库架构》迁移相关章节 | Keefe  | Keefe  |







<br>
---

[TOC]



<br>
---



# 简介

官网： http://redis.io/    [Redis中文官方网站](http://www.redis.cn/)



Redis 即 REmote Dictionary Server (远程字典服务)。

Redis是一个开源的使用ANSI C语言编写、支持网络、可基于内存亦可持久化的日志型、Key-Value数据库，并提供多种语言的API。从2010年3月15日起，Redis的开发工作由VMware主持。从2013年5月开始，Redis的开发由Pivotal赞助。

Redis是一个开源的，基于网络的，高性能的key-value数据库，弥补了memcached这类key-value存储的不足，在部分场合可以对关系数据库起到很好的补充作用，满足实时的高并发需求。

Redis跟memcached类似，不过数据可以持久化，而且支持的数据类型很丰富。支持在服务器端计算集合的并、交和补集(difference)等，还支持多种排序功能。

说明： Redis客户端跟服务端间的网络数据传输未加密，建议不要使用Redis存取敏感数据，否则可能存在安全风险。



**Redis** **与其他 key - value** **缓存产品有以下三个特点：**

*  Redis支持5种存储结构：不仅仅支持简单的key-value类型的数据，同时还提供list，set，zset，hash等数据结构的存储。每种存储结构都有自己独特的命令。
*  Redis支持数据的备份，即master-slave模式的数据备份。
*  Redis支持数据的持久化，可以将内存中的数据保存在磁盘中，重启的时候可以再次加载进行使用。



**Redis 优势**

*  丰富的数据类型 – Redis支持二进制案例的 Strings, Lists, Hashes, Sets 及 Ordered Sets 数据类型操作。
*  原子 – Redis的所有操作都是原子性的，意思就是要么成功执行要么失败完全不执行。单个操作是原子性的。多个操作也支持事务，即原子性，通过MULTI和EXEC指令包起来。
*  丰富的特性 – Redis还支持 publish/subscribe, 通知, key 过期等等特性。



# 入门篇

**1** **安装使用**

```shell
$sudo apt-get update
$sudo apt-get install redis-server

# 启动服务
$/usr/local/redis/bin/redis-server /usr/local/redis/etc/redis.conf

# 客户端访问
$redis-cli
```



**2.配置文件**

**/etc/redis.conf**



**3.Redis命令**

 Redis命令十分丰富，包括的命令组有Cluster、Connection、Geo、Hashes、HyperLogLog、Keys、Lists、Pub/Sub、Scripting、Sets、Sorted Sets、Strings、Transactions一共14个redis命令组两百多个redis命令。

表格 21 Redis命令组

| **group**    | **command**                                                  | **简介**  | **说明**                                                     |
| ------------ | ------------------------------------------------------------ | --------- | ------------------------------------------------------------ |
| Cluster      | info dbsize time config type                                 | 集群      |                                                              |
|              | flushall flushdb  save bgsave lastsave  command monitor      |           | 清空、保存数据                                               |
| Connection   | ping auth exit echo select  client list/setname/getname/kill | 连接      |                                                              |
| Geo          |                                                              |           |                                                              |
| HyperLogLog  | pfadd  pfcount pfmerge                                       | 基数统计. | Redis 在 2.8.9 版本添加了 HyperLogLog 结构。每个  HyperLogLog 键只需要花费 12 KB 内存，就可以计算接近 2^64 个不同元素的基 数。 |
| Keys         | keys * scan                                                  |           |                                                              |
| Pub/Sub      | pubsub psubscribe punsubscribe   subscribe unsubscribe publish | 发布订阅  |                                                              |
| Scripting    | eval                                                         | 脚本      |                                                              |
| Transactions | multi exec   discard watch unwatch                           | 事务      |                                                              |



表格 22 Redis的结构类型及操作命令

| **结构类型**    | **结构存储的值**                                 | **操作命令**                                      |
| --------------- | ------------------------------------------------ | ------------------------------------------------- |
| string          | sting/int/float                                  | get set del   incr decr incrby decrby incrbyfloat |
| list            | list[string...]                                  | rpush lrange lindex lpop                          |
| set             | set(string...)，set内的值唯一不重                | sadd smembers sismember srem                      |
| hash            | 包含键值对的无序散列表                           | hset hget hgetall hdel                            |
| zset  有序集合  | 有序键值对 {member:score}，排序由score大小决定。 | zadd zrange zrangebyscore zrem                    |
| bitstring  位串 | 位串的二进制位0或1                               | SETBIT GETBIT BITCOUNT BITOP                      |

备注：string/list/set/hash/zset是Redis五种基本数据结构。某些场景下可以合用内存高效的数据结构~位串。



**4. redis安全**

**设置密码访问**

```shell
CONFIG get requirepass
CONFIG set requirepass "PASSWD"
AUTH "PASSWD"
```



**5. redis脚本**

Redis 脚本使用 Lua 解释器来执行脚本。 Redis 2.6 版本通过内嵌支持 Lua 环境。执行脚本的常用命令为 **EVAL**。

Eval 命令的基本语法如下：

redis 127.0.0.1:6379> `EVAL script numkeys key [key ...] arg [arg ...]`



# 高级篇

**1.** **数据备份和恢复**

```shell
save  # 备份，保存内存到文件dump.rdb
bgsave # 后台备份
config get dir # 恢复，获取配置目录，将dump.rdb移到此即可
```



**2. redis分区**

分区是分割数据到多个Redis实例的处理过程，因此每个实例只保存key的一个子集。

常见分区有：范围、HASH



**3.** **性能测试**

\# 启动10000个请求测试

`redis-benchmark -n 10000 -q`



**4. Redis各种锁的实现**

以下锁都要设置KEY过期时间。如果请求执行因为某些原因意外退出了，导致创建了锁但是没有删除锁，那么这个锁将一直存在，以至于以后缓存再也得不到更新。于是乎我们需要给锁加一个过期时间以防不测。

redis每个命令都是原子操作，如果是2个命令要原子操作，那么要用 LUA脚本 封装成原子操作。

法1： INCR

原理：key 不存在，那么 key 的值会先被初始化为 0 ，然后再执行 INCR 操作进行加一。
然后其它用户在执行 INCR 操作进行加一时，如果返回的数大于 1 ，说明这个锁正在被使用当中。

```shell
    $redis->incr($key);
    $redis->expire($key, $ttl); //设置生成时间为1秒
```

法2： SETNX

原理：如果 key 不存在，将 key 设置为 value。如果 key 已存在，则 `SETNX` 不做任何动作

```shell
    $redis->setNX($key, $value);
    $redis->expire($key, $ttl);
```

法3：SET

原理：SET命令本身已经从版本 2.6.12 开始包含了设置过期时间的功能。这个命令已经是原子操作了。

```shell
$redis->set($key, $value, array('nx', 'ex' => $ttl));  //ex表示秒
```



# 实践篇

说明：Redis使用中要注意缓存穿透、缓存击穿和缓存雪崩的情形。

表格 23 Redis各个数据类型应用场景

| 类型                  | 简介                                                   | 特性                                                         | 场景                                                         |
| --------------------- | ------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| String (字符串)       | 二进制安全                                             | 可以包含任何数据,比如jpg图片或者序列化的对象,一个键最大能存储512M | ---                                                          |
| Hash (字典)           | 键值对集合,即编程语言中的Map类型                       | 适合存储对象,并且可以像数据库中update一个属性一样只修改某一项属性值(Memcached中需要取出整个字符串反序列化成对象修改完再序列化存回去) | 存储、读取、修改用户属性                                     |
| List (列表)           | 链表(双向链表)                                         | 增删快,提供了操作某一段元素的API                             | 1.最新消息排行等功能(比如朋友圈的时间线)   2.消息队列        |
| Set (集合)            | 哈希表实现，元素不重复                                 | 1.添加、删除,查找的复杂度都是O(1)<br>2.为集合提供了求交集、并集、差集等操作 | 1、共同好友   2、利用唯一性,统计访问网站的所有独立ip   3、好友推荐时,根据tag求交集,大于某个阈值就可以推荐 |
| Sorted Set (有序集合) | 将Set中的元素增加一个权重参数score,元素按score有序排列 | 数据插入集合时，已经进行天然排序                             | 1、排行榜，TOP N<br>2、带权重的消息队列                      |



## 业务场景

由于Redis丰富的存储结构类型，Redis有非常广阔的业务场景，常用在缓存、电商等领域。

表格 24 Redis的业务场景示例

| **分类**       | **业务场景**   | **详述**                                                     |
| -------------- | -------------- | ------------------------------------------------------------ |
| WEB应用        | cookie         | 缓存cookie，设置过期时间                                     |
| 购物车         | 同一个session  |                                                              |
| 网页缓存       |                |                                                              |
| 数据行缓存     |                |                                                              |
| 支持程序       | 记录日志       |                                                              |
|                | 计数器和统计器 | INCR/DECR/INCRBY/HMSET/ZADD， 如INCR global:xxx              |
|                | 查找IP所属区域 |                                                              |
|                | 服务发现与配置 |                                                              |
| 应用程序组件   | 自动补齐       | 模式匹配查找 keys xx 或者 scan xx                            |
|                | 分布式锁       |                                                              |
|                | 任务队列       | List                                                         |
|                | 消息拉取       | List                                                         |
| 基于搜索的应用 | 搜索           | 模式匹配                                                     |
|                | 广告定向       |                                                              |
|                | 职位搜索       |                                                              |
| 构建社交网站   |                | 可用于用户状态、主页时间线、关注者和被关注者列表、状态消息的发布与删除 |



**示例：REDIS键模式**

表格 25 REDIS示例：信纸电商销售的redis键模式

| 键                         | 值类型 | 说明                                                         | 命令示例                                                  |
| -------------------------- | ------ | ------------------------------------------------------------ | --------------------------------------------------------- |
| global:stationery          | int    | 用于存储计数器。每当有新的信纸时会加1                        | INCR global:stationery 1                                  |
| stationery:{int}           | 哈希   | 为每种信纸类型存储高度、宽度和颜色。                         | HMSET stationery:1 color blue with '30cm' heigh '40cm' ok |
| stationery:{int}:sheets    | int    | 用于存储每件包裹的信纸张数，如示例中一个包裹15张信纸。       | INCRYBY stationery:1:sheets 15                            |
| stationery:{int}:inventory | int    | 用于存储仓库可用于销售的包裹总数                             | SET stationery:1:inventory 250                            |
| stationery:{int}:sales     | zset   | 其中的每个元素以销售的UNIX  timestamp作为分值，以销售价格作为值。 | ZADD stationery:1:sales  143861194 20.0                   |

说明：一个包裹可以包含多张信纸，销售时一般以包裹为单位。 命令示例中语句单个大写单词为REDIS命令。



表格 26 REDIS示例：消息队列~模板/数据更新通知

| 键                  | 值类型 | 说明                                                     | 命令示例 |
| ------------------- | ------ | -------------------------------------------------------- | -------- |
| tenants             | set    | 用于存储所有租户信息                                     |          |
| $tenant:templates   | set    | 用于存储租户所对应的所有模板                             |          |
| $tenant:$template   | 哈希   | 用于存储某模板信息                                       | 暂不用   |
| xxa:xxb:rq          | set    | xxa:xxb前缀用来识别服务器信息.  异步用的消息队列，不重。 |          |
| xxa:xxb:gq          | list   | 异步用的先进先出消息队列，可重。                         |          |
| xxa:xxb:update_time | string | 模型更新的时间。                                         |          |

备注：前缀带`$`表示变量，如$tenant表示某租户名。



# 原理篇

## RESP协议

Redis的协议规范是 Redis Serialization Protocol (Redis序列化协议)。

该协议是用于与Redis服务器通信的，用的较多的是Redis-cli通过pipe与Redis服务器联系。

 协议如下：

​       客户端以规定格式的形式发送命令给服务器；

​       服务器在执行最后一条命令后，返回结果。



客户端发送命令的格式(类型)：5种类型（由第一个字节决定）

间隔符号，在Linux下是\r\n，在Windows下是\n

```
+ 代表简单字符串
- 代表错误字符串
:  代表整数字符串
$ 代表块字符串
* 代表数组
```



## Redis持久化

Redis提供了RDB与AOF等多种不同级别的持久化方式。

表格 5 Redis持久化RDB和AOF比较

|              | RDB (Redis DataBase)                                         | AOF (Append Only File)                                       |
| ------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 原理         | 可以在指定的时间间隔内生成数据集的时间点快照（point-in-time snapshot）。二种方式：   <br>1. 手动执行持久化数据命令来让redis进行一次数据快照。命令：save/bgsave  <br/>save：save操作在Redis主线程中工作，因此会阻塞其他请求操作，应该避免使用。bgsave：调用Fork,产生子进程，父进程继续处理请求。<br>2. 根据你所配置的配置文件 的 策略，达到策略的某些条件时来自动持久化数据。 | 记录服务器执行的所有写操作命令，并在服务器启动时，通过重新执行这些命令来还原数据集。<br/>AOF文件（**appendonly.aof**）中的命令全部以Redis协议的格式来保存，新命令会被追加到文件的末尾。  <br/>Redis还可以在后台对AOF文件进行重写，使得AOF文件的体积不会超出保存数据集状态所需的实际大小。 |
| 存储文件     | 持久化到**dump.rdb**文件，并且在redis重启后，自动读取其中文件. |                                                              |
| 缺省配置策略 | save   900   # 每900秒变化1+键值做快照   save   300 3  # 每300秒变化3+键值   save   60 10000 # 每50秒变化1万+键值 | # 三个选择：everysync~每秒，no~, always~<br>appendonly   yes   appendsync   everysync |
| 缺省         | 通常情况下一千万的字符串类型键，1GB的快照文件，同步到内存中的 时间是20-30秒）。 |                                                              |
| 优点         | RDB恢复数据时更快，可以最大化redis性能，子进程对父进程无任何性能影响。 | AOF有序的记录了redis的命令操作。意外情况下数据丢失甚少。     |
| 缺点         | 数据丢失比AOF严重                                            |                                                              |

备注：Redis可以同时使用AOF持久化和RDB持久化。在这种情况下，当Redis重启时，它会优先使用AOF文件来还原数据集，因为AOF文件保存的数据集通常比RDB文件所保存的数据集更完整。用户也可以关闭持久化功能，让数据只在服务器运行时存在。



## Redis的哈希槽

Redis 集群并没有使用一致性hash，而是引入了哈希槽的概念。Redis 集群有16384个哈希槽，每个key通过CRC16校验后对16384取模来决定放置哪个槽，集群的每个节点负责一部分hash槽。

在redis节点发送心跳包时需要把所有的槽放到这个心跳包里，以便让节点知道当前集群信息，16384=16k，在发送心跳包时使用bitmap压缩后是2k（2 * 8 (8 bit) * 1024(1k) = 2K），也就是说使用2k的空间创建了16k的槽数。

虽然使用CRC16算法最多可以分配65535（2^16-1）个槽位，65535=65k，压缩后就是8k（8 * 8 (8 bit) * 1024(1k) = 8K），也就是说需要需要8k的心跳包，作者认为这样做不太值得；并且一般情况下一个redis集群不会有超过1000个master节点，所以16k的槽位是个比较合适的选择。



# 架构篇

## 逻辑架构

Reids逻辑架构包含Redis Server与Redis-WS，如图1所示。

图1 Redis逻辑架构
    ![1574510074791](../../media/sf_reuse/arch/db/arch_db_redisl.png)

* Redis Server：Redis组件的核心模块，负责Redis协议的数据读写、数据持久化、主从复制、集群功能。
* Redis-WS：Redis WebService管理模块，主要负责Redis集群的创建、扩容、减容、查询、删除等操作，集群管理信息存入DB数据库。

备注：每个节点会打开两个TCP socket。第一个用于标准的RESP协议，默认端口是6369；另一个用于集群间二进制协议，在第一个端口加上10000。



## 部署架构~运行模式

表格  Redis运行模式比较

|          | **单实例模式**                         | **集群模式**                                                 |
| -------- | -------------------------------------- | ------------------------------------------------------------ |
| 部署方式 | 一主多从，一从多从                     | 多主。多个Redis实例组合为一个Redis集群，共16384个槽位均分到各主实例上。 |
| 可用性   | 主实例宕机，服务终止。从实例默认只读。 | Redis   Sentinel，监控主从节点的实例。主实例故障，由集群中剩余的主实例选举出一个从实例升主，需要半数以上主实例OK才能选举。 |
| 可伸缩性 |                                        | Redis集群可以进行扩容、减容（新实例加入集群或Redis实例退出集群），并进行槽位迁移。 |
| 性能     |                                        |                                                              |

备注：单机版的Redis是有数据库概念的，并且每个数据库的数据是隔离的不能共享。集群没有数据库概念。



Redis实例可以部署在一个或多个节点上，且一个节点上也可以部署一个或多个Redis实例（FusionInsight HD平台中，每个节点上Redis实例的个数由软件根据节点硬件资源情况计算得出）。

最新版本的Redis支持集群功能，可以将多个Redis实例组合为一个Redis集群，从而对外提供一个分布式key-value数据库。集群通过分片（sharding）来进行数据共享，并提供复制和故障转移功能。



**单实例模式**

单实例模式逻辑部署方式如图2所示：

图2 单实例模式
    ![1574510108802](../../media/sf_reuse/arch/db/arch_db_redis_002.png)

说明：

*  一个主实例（master）可以对应有多个从实例（slave），从实例本身还可连接从实例。
*  发给主实例的命令请求，主实例会实时同步给从实例进行处理。
*  主实例宕机，从实例不会自动升主。
*  从实例默认只读，在配置了“slave-read-only”为no时，从实例也可写。但从实例重启后，会从主实例同步数据，之前写入从实例的数据丢失。
*  多层级从实例的结构，相对所有从实例都直接连接在主实例下的结构，由于减少了主实例需要直接同步的从实例个数，一定程度上能提升主实例的业务处理性能。



## 可伸缩性：Redis集群

**集群模式**

集群模式逻辑部署方式如下图所示：

**图**集群模式
    ![1574510144445](../../media/sf_reuse/arch/db/arch_db_redis_003.png)

说明：

*  多个Redis实例组合为一个Redis集群，共16384个槽位均分到各主实例上。

*  集群中的每个实例都记录有槽位与实例的映射关系，客户端也记录了槽位与实例的映射。客户端根据key算hash并模16384得到槽位 (HASH_SLOT=CRC16(key) module 16384)，根据槽位-实例映射，将消息直接发送到对应实例处理。

*  默认情况，从实例不能读不能写，在线执行readonly命令可使从实例可读。

*  主实例故障，由集群中剩余的主实例选举出一个从实例升主，需要半数以上主实例OK才能选举。

*  cluster-require-full-coverage配置项指示集群是否要求完整，若配置为yes，则其中一组主从都故障时，集群状态为FAIL，整个集群不能处理命令；若配置为no，则半数以上主实例OK，集群状态还是OK。

*  Redis集群可以进行扩容、减容（新实例加入集群或Redis实例退出集群），并进行槽位迁移。

*  目前FusionInsight HD中的Redis集群只支持一主一从模式。



**windows下创建多实例（一主多从）**

一个redis实例对应一个节点，每个节点对应一个配置文件，可配置一个监听端口。每个节点对应下面的2-3步。

1. 配置文件修改：redis.windows-service.conf，命名为 redis.windows-service-{port}.conf，如redis.windows-service-6380.conf

```shell
# master port为 6379

port 6380
slaveof 127.0.0.1 6379
```

2. 服务注册：命令行输入

```shell
redis-server --service-install redis.windows-service-6380.conf --service-name redis6380 --loglevel verbose
```

3. 服务启动：命令行输入

```shell
redis-server --service-start --service-name redis6380
```

4.客户端启动：命令行输入

```shell
redis-cli.exe -p 6379
redis-cli.exe -p 6380
```

备注：linux配置一主多从会更简单点，去除服务注册，直接用redis-server [conf]启动。



数据分区三种方法：

* 客户端分区：分区逻辑包含在客户端代码中。
* 辅助代理分区：连接到中间件，同中间件来分发请求。
* 查询路由：Redis集群当前的实现方式，典型实现有Twitter开源的Twemproxy。任一客户端查询集群中的随机节点将被路由到包含键的正确节点上。常见方法有范围分区、列表分区等等。
* 范围分区：根据传入键落入特定范围，并将该键划分给此范围所对应的实例。
* 列表分区：为分区指定一个列表值。如果传入键在某分区列表中，则命中此分区。如全国电话号码分布（将前若干位数字作为分区号）。
* 哈希分区：对键进行哈希，结果取模操作（%）。
* 复合分区：范围/列表/哈希组合分区的方式，使用一致性哈希（哈希槽16384，理论上集群节点数最多16384个）。



<br>

# 参考资料

* Redis锁机制的几种实现方式 https://www.cnblogs.com/fengff/p/10913492.html
* Redis在Windows下创建多个实例（2018最新） https://blog.csdn.net/SCUTJcfeng/article/details/80044576
* Redis两种持久化方式(RDB&AOF)  https://www.cnblogs.com/tdws/p/5754706.html
* Redis协议规范(RESP) https://www.cnblogs.com/tommy-huang/p/6051577.html
* why redis-cluster use 16384 slots? https://github.com/antirez/redis/issues/2576

