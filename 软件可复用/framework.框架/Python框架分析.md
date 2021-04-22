| 序号 | 修改时间   | 修改内容         | 修改人 | 审稿人 |
| ---- | ---------- | ---------------- | ------ | ------ |
| 1    | 2020-12-16 | 创建。           | 吴启福 | 吴启福 |

---






















# 1 Python框架

表格 1 Python框架列表

| **框架名称** | **简介** | **介绍** |
| ------------ | -------- | -------- |
| Django         | 重量级WEB框架 |          |
| Flask          | 轻量级WEB框架 |          |
| Celery          | 多任务队列 |          |
| gunicorn | 多工作进程并发 | |

 

## 1.1 Celery 多任务队列

Celery 通过消息机制进行通信，通常使用中间人（Broker）作为客户端和职程（Worker）调节。启动一个任务，客户端向消息队列发送一条消息，然后中间人（Broker）将消息传递给一个职程（Worker），最后由职程（Worker）进行执行中间人（Broker）分配的任务。

特性：高可用、快速、灵活



* 仓库： https://github.com/celery/celery

* 中文文档：https://www.celerycn.io/



 它支持

- 中间人
  - [RabbitMQ]()
  - [Redis]()
  - [Amazon SQS]()
- 结果存储
  - AMQP、 Redis
  - Memcached
  - SQLAlchemy、Django ORM
  - Apache Cassandra、Elasticsearch
- 并发
  - prefork (multiprocessing)
  - [Eventlet](http://eventlet.net/)、[gevent](http://www.gevent.org/)
  - solo (single threaded)
- 序列化
  - pickle、json、yaml、msgpack
  - zlib、bzip2 compression
  - Cryptographic message signing

 

Celery可以快速的集成一些常用的Web框架，详细如下：

| Web框架                                                      | 集成包                                                       |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [Pyramid](http://docs.pylonsproject.org/en/latest/docs/pyramid.html) | [pyramid_celery](https://pypi.org/project/pyramid_celery/)   |
| [Pylons](http://pylonshq.com/)                               | [celery-pylons](https://pypi.python.org/pypi/celery-pylons/) |
| [Flask](http://flask.pocoo.org/)                             | 不需要                                                       |
| [web2py](http://web2py.com/)                                 | [web2py-celery](https://pypi.python.org/pypi/web2py-celery/) |
| [Tornado](http://www.tornadoweb.org/)                        | [tornado-celery](https://pypi.python.org/pypi/tornado-celery/) |
| [Tryton](http://www.tryton.org/)                             | [celery_tryton](https://pypi.python.org/pypi/celery_tryton/) |



### 入门篇

代码框架

```python
# tasks.py
from celery import Celery
# 创建Celery对象
app = Celery('tasks', broker='amqp://guest@localhost//')

# celery对象绑定各种类型的任务
@app.task
def add(x, y):
    return x + y

@app.task(bind=True)
def add(x, y):
 	print(self.request.id)
    return x + y
```



celery执行过程

```shell
# 安装
$ pip install celery

# 启动: -A [project]，下列中项目名为tasks， -P [pool_class]默认perfork， -–pidfile --logfile
$ celery -A tasks worker --loglevel=info
# 5.x+ 支持 celery multi
$ celery multi start|stop|stopwait|restart -A [project] 
```

调试

```python
$ celery shell
>>> from tasks import add
>>> resut = add.delay(4, 4)		# 执行任务的方法: delay, apply_async, 
>>> result.get(timeout=8)		# 获取任务结果的方法：get ready
```



**常用配置项**

配置项优先级： 装饰器 > config配置 > 队列启动命令

```python
# 获取配置参数项， app为celery对象
app.config_from_object('celeryconfig')	# 法1：文件中获取
app.conf.broker_url = 'pyamqp://'	# 法2：直接赋值

# celeryconfig.py
broker_url = 'pyamqp://'
result_backend = 'rpc://'

task_serializer = 'json'
result_serializer = 'json'
accept_content = ['json']
timezone = 'Europe/Oslo'
enable_utc = True

# 
CELERYD_MAX_TASKS_PER_CHILD = 10  # work执行任务数
concurrunt = 4   # 并发数

# 任务响应延迟，预取任务数
task_acks_late = True
worker_prefetch_multiplier = 1
```



celery常用命令

```shell

```





### 应用篇

默认情况下，默认的配置项没有针对吞吐量进行优化，默认的配置比较合适大量短任务和比较少的长任务。 如果需要优化吞吐量，请参考[`优化：Optimizing`]()。

**task**

task状态state:  PENDING  STARTED  RETRY  SUCCESS 

重试二次的状态变迁如下所示： 

PENDING -> STARTED -> RETRY -> STARTED -> RETRY -> STARTED -> SUCCESS



**故障自愈**

* worker:  *CELERY*D_MAX_TASKS_*PER_CH*ILD  重启进程
* task:  软超时soft_time_limit 和 硬超时time_limit 



### 原理篇







# 参考资料

---

[1]:  https://www.celerycn.io/  "celery中文手册"