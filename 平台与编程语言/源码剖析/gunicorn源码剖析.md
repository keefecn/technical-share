| 序号 | 修改时间 | 修改内容                                   | 修改人 | 审稿人 |
| ---- | -------- | ------------------------------------------ | ------ | ------ |
| 1   | 2021-7-6 | 创建。新增gunicorn源码剖析。 | 同上   |   Keefe     |







---


# gunicorn源码剖析

源码版本： gunicorn-20.1.0

```shell
$ pip show gunicorn
Name: gunicorn
Version: 20.1.0
Summary: WSGI HTTP Server for UNIX
Home-page: https://gunicorn.org
Author: Benoit Chesneau
Author-email: benoitc@e-engura.com
License: MIT
Location: /home/keefe/venv/superset-py38-env/lib/python3.8/site-packages
Requires: setuptools
Required-by: 
```



**gunicorn特点**

* Gunicorn是一个基于Python实现的动态Web服务器，实现了WSGI协议，可以与Django、Flask等Web框架集成。

* 与Apache、Nginx等静态Web服务器相比，Gunicorn动态处理能力强。可以通过HTTP或者Unix Socket来与之通信，以此实现动静分离。

* Gunicorn由于源码调用了fcntl、fork等接口，因此只能跑在类Unix系统上，Windows上跑不了。

* Gunicorn通过pre-worker模型来实现并发，worker的工作模式有sync、gthread、gevent等，即可以通过多线程、或者协程来处理请求。

* Gunicorn是可配置的，可以通过命令行参数或者配置文件的形式，来完成对其配置。

* Gunicorn的日志功能丰富，可以输出到控制台、日志文件或者syslog服务器，另外日志分为http请求访问日志和程序运行时的错误日志，这点借鉴了Apache的思路。



## 源码结构

表格 gunicorn源码结构

| 目录或文件       | 主要类或函数                               | 说明                                 |
| ---------------- | ------------------------------------------ | ------------------------------------ |
| app              |                                            | app应用程序                          |
| app/base.py      | BaseApplication Application                | app基类                              |
| app/pasterapp.py | PasterServerApplication                    |                                      |
| app/wsgiapp.py   | WSGIApplication                            | WSGI应用实现，程序启动真正入口       |
| http             |                                            | http协议实现                         |
| http/body.py     | ChunkedReader LengthReader EOFReader Body  | 读取HTTP BODY                        |
| http/message.py  | Message, Request                           | HTTP请求体                           |
| http/parser.py   | Parser RequestParser                       | HTTP请求解析器                       |
| http/unreader.py | Unreader SocketUnreader IterUnreader       | 没读内容处理                         |
| http/wsgi.py     | FileWrapper WSGIErrorsWrapper Response     | HTTP响应体                           |
| instrument       | statsd.py                                  | Statsd类，客户端侧协议               |
| works            | base.py                                    | 工作进程基类，子类需要重载Worker:run |
|                  | base_async.py                              | 异步模式的基类                       |
|                  | ggevent.py                                 | gevent模式                           |
|                  | geventlent.py                              | eventlet模式                         |
|                  | gtornado.py                                | tornado模式                          |
|                  | gthread.py                                 | gthread模式 单进程多线程(线程池)     |
|                  | sync.py                                    | 同步模式 单进程单线程                |
|                  | workertmp.py                               | tmp文件，master监控worker进程的机制  |
| **arbiter.py**   | Arbiter                                    | 主进程，维护工作进程存活。           |
| config.py        | Config Setting                             | 配置相关，字段基类是Setting。        |
| debug.py         | Spew                                       | 调试类                               |
| erros.py         | HaltServer ConfigError AppImportError      | 定义了几种异常                       |
| glogging.py      | SafeAtoms  Logger                          | 全局日志                             |
| reloader.py      | Reloader InotifyReloader                   | 模块重载实现                         |
| pidfile.py       | Pidfile                                    | gunicorn主进程ID文件                 |
| sock.py          | BaseSocket TCPSocket TCP6Socket UnixSocket | socket类，用来与客户端通讯           |
| systemd.py       | listen_fds sd_notify                       | socket函数封装扩展                   |
| util.py          |                                            | 工具函数                             |

说明：源码按目录结构可分为app实现、http实现和works实现、



![img](..\..\media\code\code_gunicorn_001.png)

图 gunicorn代码间关联



## 主流程

### gunicorn启动 

gunicorn启动方式有二种，一是 自行启动方式；二是命令行启动。

* 自行启动：`python main.py`  要求main.py里面至少要实现一个app handler函数或者app handler类和一个app server类。本启动方式主要用于调试gunicorn
* 命令行启动：`python -m  gunicorn.app.wsgiapp project.wsgi --chdir /path/to/project-root -c /path/to/project-cfg.py`   



法1： 自行启动

```python
# main.py
import multiprocessing
import gunicorn.app.base


def app_handler(environ, start_response):
    status = '200 OK'
    response_headers = [
        ('Content-Type', 'text/plain'),
    ]
    start_response(status, response_headers)

    # response_body = ['Works fine\n']
    response_body = []
    for key, value in environ.items():
      response_body.append(f'{key}: {value}')
    response_body.append('\nWorks fine\n')

    return response_body.encode('utf-8')


class APPHandler(object):
  def __init__(self, environ, start_response):
    self.environ = environ
    self.start_response = start_response

  def __call__(self, environ, start_response):
    self.environ = environ
    self.start_response = start_response

  def __iter__(self):
    data = 'Hello, World!\n'

    status = '200 OK'
    response_headers = [
      ('Content-type', 'text/plain'),
      ('Content-Length', str(len(data))),
      ('Foo', 'B\u00e5r'),  # Foo: Bår
    ]
    self.start_response(status, response_headers)

    yield data.encode("utf-8")


class APPServer(gunicorn.app.base.BaseApplication):
    def __init__(self, app, options=None):
        self.options = options or {}
        self.application = app
        super().__init__()

    def load_config(self):
        config = {key: value for key, value in self.options.items()
                  if key in self.cfg.settings and value is not None}
        for key, value in config.items():
            self.cfg.set(key.lower(), value)

    def load(self):
        return self.application


if __name__ == '__main__':
    options = {
        'bind': ['0.0.0.0:6000', '[::]:6000'],
        'workers': multiprocessing.cpu_count(),
    }
    APPServer(app_handler, options).run()
    # APPServer(APPHandler, options).run()
```



法2： gunicorn脚本

```python
# -*- coding: utf-8 -*-
import re
import sys
from gunicorn.app.wsgiapp import run
if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw|\.exe)?$', '', sys.argv[0])
    sys.exit(run())    
```



### 主进程 arbiter.py

主要通过信号量来控制查看工作进程状态。

这些信号量的含义是：

    HUP，重启所有的配置和所有的worker进程
    QUIT，正常关闭，它会等待所有worker进程处理完各自的东西后关闭
    INT/TERM，立即关闭，强行中止所有的处理
    TTIN，增加一个worker进程
    TTOU，减少一个worker进程
    USR1，重新打开由master和worker所有的日志处理
    USR2，重新运行master和worker
    WINCH，正常关闭所有worker进程，保持主控master进程的运行
下面通过handle_xx 来作相应处理，xx为信号，如hanler_hup。

```python
import select
import signal

from gunicorn.errors import HaltServer, AppImportError
from gunicorn.pidfile import Pidfile
from gunicorn import sock, systemd, util


class Arbiter(object):
    """ 管理进程类，用信号来处理各种事件  
    run(): 启动主进程，在循环内管理工作进程变化    
    """
    WORKER_BOOT_ERROR = 3

    # A flag indicating if an application failed to be loaded
    APP_LOAD_ERROR = 4

    START_CTX = {}

    LISTENERS = []
    WORKERS = {}
    PIPE = []

    # I love dynamic languages
    SIG_QUEUE = []
    SIGNALS = [getattr(signal, "SIG%s" % x)
               for x in "HUP QUIT INT TERM TTIN TTOU USR1 USR2 WINCH".split()]
    SIG_NAMES = dict(
        (getattr(signal, name), name[3:].lower()) for name in dir(signal)
        if name[:3] == "SIG" and name[3] != "_"
    )
    
    def __init__(self, app):
        os.environ["SERVER_SOFTWARE"] = SERVER_SOFTWARE

        self._num_workers = None
        self._last_logged_active_worker_count = None
        self.log = None

        self.setup(app)

        self.pidfile = None
        self.systemd = False
        self.worker_age = 0
        self.reexec_pid = 0
        self.master_pid = 0
        self.master_name = "Master"

        cwd = util.getcwd()

        args = sys.argv[:]
        args.insert(0, sys.executable)

        # init start context
        self.START_CTX = {
            "args": args,
            "cwd": cwd,
            0: sys.executable
        }   
        
    def run(self):
        """Main master loop. 
        主循环，启动主进程并一直存活，管理工作进程manage_workers """
        self.start()	# 启动监听socket，加载配置信息
        util._setproctitle("master [%s]" % self.proc_name)

        try:
            # 管理工作进程，用prefork模式启动指定数量工作进程
            self.manage_workers()  

            while True:
                self.maybe_promote_master()

                sig = self.SIG_QUEUE.pop(0) if self.SIG_QUEUE else None
                if sig is None: 
                    # 有信号时，执行下列操作：睡眠直到无读事件或超时，杀死空闲工作进程，管理工作进程
                    self.sleep()
                    self.murder_workers()
                    self.manage_workers()
                    continue

                if sig not in self.SIG_NAMES:
                    self.log.info("Ignoring unknown signal: %s", sig)
                    continue

                signame = self.SIG_NAMES.get(sig)
                handler = getattr(self, "handle_%s" % signame, None)
                if not handler:
                    self.log.error("Unhandled signal: %s", signame)
                    continue
                self.log.info("Handling signal: %s", signame)
                handler()
                self.wakeup()
        except (StopIteration, KeyboardInterrupt):
            self.halt()
        except HaltServer as inst:
            self.halt(reason=inst.reason, exit_status=inst.exit_status)
        except SystemExit:
            raise
        except Exception:
            self.log.info("Unhandled exception in main loop",
                          exc_info=True)
            self.stop(False)
            if self.pidfile is not None:
                self.pidfile.unlink()
            sys.exit(-1)        
```



## app应用程序 /app/

### wsgiapp.py 

本文件可以直接跑。`python -m gunicorn.app.wagiapp`

```python
from gunicorn.errors import ConfigError
from gunicorn.app.base import Application
from gunicorn import util


class WSGIApplication(Application):
    def init(self, parser, opts, args):
        if opts.paste:
            from .pasterapp import has_logging_config

            config_uri = os.path.abspath(opts.paste)
            config_file = config_uri.split('#')[0]

            if not os.path.exists(config_file):
                raise ConfigError("%r not found" % config_file)

            self.cfg.set("default_proc_name", config_file)
            self.app_uri = config_uri

            if has_logging_config(config_file):
                self.cfg.set("logconfig", config_file)

            return

        if not args:
            parser.error("No application module specified.")

        self.cfg.set("default_proc_name", args[0])
        self.app_uri = args[0]

    def load_wsgiapp(self):
        return util.import_app(self.app_uri)

    def load_pasteapp(self):
        from .pasterapp import get_wsgi_app
        return get_wsgi_app(self.app_uri, defaults=self.cfg.paste_global_conf)

    def load(self):
        if self.cfg.paste is not None:
            return self.load_pasteapp()
        else:
            return self.load_wsgiapp()


def run():
    """\
    The ``gunicorn`` command line runner for launching Gunicorn with
    generic WSGI applications.
    """
    from gunicorn.app.wsgiapp import WSGIApplication
    WSGIApplication("%(prog)s [OPTIONS] [APP_MODULE]").run()


if __name__ == '__main__':
    run()    
```



### base.py

本文件定义了2个应用程序基类：BaseApplication, Application。

BaseApplication::run() 启动了主进程Aribiter.run()。

Application::run() 在启动主进程之前加载了配置信息，并作相应处理。

Application::load_config() 加载配置信息，可以解析命令行或者文件里获取配置数据。

```python
from gunicorn import util
from gunicorn.arbiter import Arbiter
from gunicorn.config import Config, get_default_config_file
from gunicorn import debug

class BaseApplication(object):
    """
    An application interface for configuring and loading
    the various necessities for any given web framework.
    """
    def __init__(self, usage=None, prog=None):
        self.usage = usage
        self.cfg = None
        self.callable = None
        self.prog = prog
        self.logger = None
        self.do_load_config()  # 加载配置信息
        
    def run(self):
        try:  # 启动主进程
            Arbiter(self).run()
        except RuntimeError as e:
            print("\nError: %s\n" % e, file=sys.stderr)
            sys.stderr.flush()
            sys.exit(1)
  

class Application(BaseApplication):
    
    def load_config(self):
        """ 从文件或者 命令行里获取 配置信息 """
        # parse console args
        parser = self.cfg.parser()
        args = parser.parse_args()

        # optional settings from apps
        cfg = self.init(parser, args, args.args)

        # set up import paths and follow symlinks
        self.chdir()

        # Load up the any app specific configuration
        if cfg:
            for k, v in cfg.items():
                self.cfg.set(k.lower(), v)

        env_args = parser.parse_args(self.cfg.get_cmd_args_from_env())

        if args.config:
            self.load_config_from_file(args.config)
        elif env_args.config:
            self.load_config_from_file(env_args.config)
        else:
            default_config = get_default_config_file()
            if default_config is not None:
                self.load_config_from_file(default_config)

        # Load up environment configuration
        for k, v in vars(env_args).items():
            if v is None:
                continue
            if k == "args":
                continue
            self.cfg.set(k.lower(), v)

        # Lastly, update the configuration with any command line settings.
        for k, v in vars(args).items():
            if v is None:
                continue
            if k == "args":
                continue
            self.cfg.set(k.lower(), v)

        # current directory might be changed by the config now
        # set up import paths and follow symlinks
        self.chdir()

    def run(self):
        if self.cfg.check_config:
            try:
                self.load()
            except:
                msg = "\nError while loading the application:\n"
                print(msg, file=sys.stderr)
                traceback.print_exc()
                sys.stderr.flush()
                sys.exit(1)
            sys.exit(0)

        if self.cfg.spew:
            debug.spew()

        if self.cfg.daemon:
            util.daemonize(self.cfg.enable_stdio_inheritance)

        # set python paths  添加python路径到系统路径
        if self.cfg.pythonpath:
            paths = self.cfg.pythonpath.split(",")
            for path in paths:
                pythonpath = os.path.abspath(path)
                if pythonpath not in sys.path:
                    sys.path.insert(0, pythonpath)

        super().run()    
```



## http协议  /http/

```python
#/gunicorn/http/__init__.py
from gunicorn.http.message import Message, Request
from gunicorn.http.parser import RequestParser

__all__ = ['Message', 'Request', 'RequestParser']
```



## works工作模式  /works/

工作进程支持多种工作模式，可分为同步sync 和异步async。

异步又可分为eventlet, gevent, tornado。

* eventlet:  依赖eventlet模块

* gevent :  依赖gevent模块

* tornado  直接导入tornado模块，调用相关方法

* gthread  单进程多线程，使用了标准库的线程池

  

```python
#/gunicorn/works/__init__.py
# supported gunicorn workers.
SUPPORTED_WORKERS = {
    "sync": "gunicorn.workers.sync.SyncWorker",
    "eventlet": "gunicorn.workers.geventlet.EventletWorker",
    "gevent": "gunicorn.workers.ggevent.GeventWorker",
    "gevent_wsgi": "gunicorn.workers.ggevent.GeventPyWSGIWorker",
    "gevent_pywsgi": "gunicorn.workers.ggevent.GeventPyWSGIWorker",
    "tornado": "gunicorn.workers.gtornado.TornadoWorker",
    "gthread": "gunicorn.workers.gthread.ThreadWorker",
}
```



works/base.py

```python
from gunicorn.http.wsgi import Response, default_environ
from gunicorn.reloader import reloader_engines
from gunicorn.workers.workertmp import WorkerTmp


class Worker(object):
	""" 工作模式基类, 
	run方法子类需要重载
	init_process() 进程初始化，在方法最后调用 run()  
    """
    SIGNALS = [getattr(signal, "SIG%s" % x)
            for x in "ABRT HUP QUIT INT TERM USR1 USR2 WINCH CHLD".split()]

    PIPE = []

    def __init__(self, age, ppid, sockets, app, timeout, cfg, log):      
        """ 初始化变量，创建tmpfile """
        self.age = age
        self.pid = "[booting]"
        self.ppid = ppid
        self.sockets = sockets
        self.app = app
        self.timeout = timeout
        self.cfg = cfg
        self.booted = False
        self.aborted = False
        self.reloader = None

        self.nr = 0

        if cfg.max_requests > 0:
            jitter = randint(0, cfg.max_requests_jitter)
            self.max_requests = cfg.max_requests + jitter
        else:
            self.max_requests = sys.maxsize

        self.alive = True
        self.log = log
        self.tmp = WorkerTmp(cfg)  # 临时文件机制，父进程通过检测文件时间戳，来确认子进程是否存活。
        
    def __str__(self)
    def notify(self)        

    def run(self):
        """ 工作进程主循环
        This is the mainloop of a worker process. 子类必须重载
        """
        raise NotImplementedError()     

    def init_process(self):
        """\
        If you override this method in a subclass, the last statement
        in the function should be to call this method with
        super().init_process() so that the ``run()`` loop is initiated.
        主要事情：
        1.设置进程的进程组信息；
        2.创建单进程管道，Worker是通过管道来存储导致中断的信号，不直接处理，先收集起来，在主循环中处理；
        3.获取要监听的文件描述符，并将描述符设置为不可被子进程继承；
        4.设置中断信号处理函数 init_signals();
        5.设置代码更新时，自动重启的配置 reload_cls
        6.获取实现了wsgi协议的app对象 load_wsgi()
        7.进入主循环方法run，如果子类重载了init_process，需要加上此处。        
        """

        # set environment' variables
        if self.cfg.env:
            for k, v in self.cfg.env.items():
                os.environ[k] = v

        util.set_owner_process(self.cfg.uid, self.cfg.gid,
                               initgroups=self.cfg.initgroups)

        # Reseed the random number generator
        util.seed()

        # For waking ourselves up
        self.PIPE = os.pipe()
        for p in self.PIPE:
            util.set_non_blocking(p)
            util.close_on_exec(p)

        # Prevent fd inheritance
        for s in self.sockets:
            util.close_on_exec(s)
        util.close_on_exec(self.tmp.fileno())

        self.wait_fds = self.sockets + [self.PIPE[0]]

        self.log.close_on_exec()

        self.init_signals()

        self.load_wsgi()

        # start the reloader 启动重载引擎 
        if self.cfg.reload:
            def changed(fname):
                self.log.info("Worker reloading: %s modified", fname)
                self.alive = False
                os.write(self.PIPE[1], b"1")
                self.cfg.worker_int(self)
                time.sleep(0.1)
                sys.exit(0)

            reloader_cls = reloader_engines[self.cfg.reload_engine]
            self.reloader = reloader_cls(extra_files=self.cfg.reload_extra_files,
                                         callback=changed)
            self.reloader.start()

        self.cfg.post_worker_init(self)

        # （重要）Enter main run loop  进入主循环
        self.booted = True
        self.run()
        
    def load_wsgi(self)                  # 获得实现wsgi协议的app，如Flask
    def init_signals(self)
    def handle_usr1(self, sig, frame)
    def handle_exit(self, sig, frame)
    def handle_quit(self, sig, frame)
    def handle_abort(self, sig, frame)
    def handle_error(self, req, client, addr, exc)
    def handle_winch(self, sig, fname)        
```



works/base_async.py 异步模式基类

```python
import gunicorn.http as http
import gunicorn.http.wsgi as wsgi
import gunicorn.util as util
import gunicorn.workers.base as base

ALREADY_HANDLED = object()


class AsyncWorker(base.Worker):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.worker_connections = self.cfg.worker_connections
        
    def handle(self, listener, client, addr):
        
    def handle_request(self, listener_name, req, sock, addr):        
```



### 同步模式 sync.py

同步工作模式:  比较低效的工作模式

* run_for_one()处理单个时调用 accept，
* run_for_multi()处理多个时调用 wait

```python
import gunicorn.http as http
import gunicorn.http.wsgi as wsgi
import gunicorn.util as util
import gunicorn.workers.base as base

class SyncWorker(base.Worker):
	""" 同步工作模式: run_for_one()处理单个时调用accept，处理多个时调用wait """
    def accept(self, listener):
        client, addr = listener.accept()
        client.setblocking(1)
        util.close_on_exec(client)
        self.handle(listener, client, addr)

    def wait(self, timeout):
        """ select模式，通过超时机制实现遍历监听 """
        try:
            self.notify()
            ret = select.select(self.wait_fds, [], [], timeout)
            if ret[0]:
                if self.PIPE[0] in ret[0]:
                    os.read(self.PIPE[0], 1)
                return ret[0]

        except select.error as e:
            if e.args[0] == errno.EINTR:
                return self.sockets
            if e.args[0] == errno.EBADF:
                if self.nr < 0:
                    return self.sockets
                else:
                    raise StopWaiting
            raise

    def run(self):
        # if no timeout is given the worker will never wait and will
        # use the CPU for nothing. This minimal timeout prevent it.
        timeout = self.timeout or 0.5

        # self.socket appears to lose its blocking status after
        # we fork in the arbiter. Reset it here.
        for s in self.sockets:    
            s.setblocking(0)  # 阻塞监听

        if len(self.sockets) > 1:  # 处理多个
            self.run_for_multiple(timeout)
        else:	# 处理一个
            self.run_for_one(timeout)            
```



### 线程池模式 gthread.py

大致流程 （换行且tab表示是在函数内部）

ThreadWorker::init_process() ->

​		run() ->

​			accept() -->

​				enqueue_req 请求入队 (finish_request, handle, handle_request )  

```python
import concurrent.futures as futures  # 标准库并发，本处用了线程池
import selectors  # 异步IO实现里的选择器

from . import base
from .. import http
from .. import util
from ..http import wsgi

class ThreadWorker(base.Worker):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.worker_connections = self.cfg.worker_connections
        self.max_keepalived = self.cfg.worker_connections - self.cfg.threads
        # initialise the pool
        self.tpool = None
        self.poller = None
        self._lock = None
        self.futures = deque()
        self._keep = deque()
        self.nr_conns = 0
        
    def init_process(self):
        """ 重载，获取一个线程池，设置poll选择器，设置读锁 """
        self.tpool = self.get_thread_pool()
        self.poller = selectors.DefaultSelector()
        self._lock = RLock()
        super().init_process()    
        
    def run(self):
        """ select模式 实现listen和异步IO, 主要流程如下：        
        更新tmpfile时间戳self.notify()
        获取就绪的请求连接self.accept()；
        如果并发数允许，分配一个线程处理请求；
        判断父进程是否已经停止工作，有的话准备退出主循环；
        杀死已经允许最大连接事件的keep-alive连接。
        """
        # init listeners, add them to the event loop
        for sock in self.sockets:
            sock.setblocking(False)
            # a race condition during graceful shutdown may make the listener
            # name unavailable in the request handler so capture it once here
            server = sock.getsockname()
            acceptor = partial(self.accept, server)  # 获取accept连接
            self.poller.register(sock, selectors.EVENT_READ, acceptor)

        while self.alive:
            # notify the arbiter we are alive
            self.notify()

            # can we accept more connections?
            if self.nr_conns < self.worker_connections:
                # wait for an event
                events = self.poller.select(1.0)
                for key, _ in events:
                    callback = key.data
                    callback(key.fileobj)

                # check (but do not wait) for finished requests
                result = futures.wait(self.futures, timeout=0,
                        return_when=futures.FIRST_COMPLETED)
            else:
                # wait for a request to finish
                result = futures.wait(self.futures, timeout=1.0,
                        return_when=futures.FIRST_COMPLETED)

            # clean up finished requests
            for fut in result.done:
                self.futures.remove(fut)

            if not self.is_parent_alive():
                break

            # handle keepalive timeouts
            self.murder_keepalived()

        self.tpool.shutdown(False)
        self.poller.close()

        for s in self.sockets:
            s.close()

        futures.wait(self.futures, timeout=self.cfg.graceful_timeout)   
        
    def enqueue_req(self, conn):
        """ 请求入队，从线程池里分配线程 """
        conn.init()
        # submit the connection to a worker
        fs = self.tpool.submit(self.handle, conn)
        self._wrap_future(fs, conn)
        
```



### gevent模式  ggevent.py

依赖模块 gevent

```python
try:
    import gevent
except ImportError:
    raise RuntimeError("gevent worker requires gevent 1.4 or higher")
else:
    from pkg_resources import parse_version
    if parse_version(gevent.__version__) < parse_version('1.4'):
        raise RuntimeError("gevent worker requires gevent 1.4 or higher")

from gevent.pool import Pool
from gevent.server import StreamServer
from gevent import hub, monkey, socket, pywsgi

import gunicorn
from gunicorn.http.wsgi import base_environ
from gunicorn.workers.base_async import AsyncWorker

class GeventWorker(AsyncWorker):

    server_class = None
    wsgi_handler = None
    
    def run(self):
        servers = []
        ssl_args = {}

        if self.cfg.is_ssl:
            ssl_args = dict(server_side=True, **self.cfg.ssl_options)

        for s in self.sockets:
            s.setblocking(1)
            pool = Pool(self.worker_connections)
            if self.server_class is not None:
                environ = base_environ(self.cfg)
                environ.update({
                    "wsgi.multithread": True,
                    "SERVER_SOFTWARE": VERSION,
                })
                server = self.server_class(
                    s, application=self.wsgi, spawn=pool, log=self.log,
                    handler_class=self.wsgi_handler, environ=environ,
                    **ssl_args)
            else:
                hfun = partial(self.handle, s)
                server = StreamServer(s, handle=hfun, spawn=pool, **ssl_args)

            server.start()
            servers.append(server)

        while self.alive:
            self.notify()
            gevent.sleep(1.0)

        try:
            # Stop accepting requests
            for server in servers:
                if hasattr(server, 'close'):  # gevent 1.0
                    server.close()
                if hasattr(server, 'kill'):  # gevent < 1.0
                    server.kill()

            # Handle current requests until graceful_timeout
            ts = time.time()
            while time.time() - ts <= self.cfg.graceful_timeout:
                accepting = 0
                for server in servers:
                    if server.pool.free_count() != server.pool.size:
                        accepting += 1

                # if no server is accepting a connection, we can exit
                if not accepting:
                    return

                self.notify()
                gevent.sleep(1.0)

            # Force kill all active the handlers
            self.log.warning("Worker graceful timeout (pid:%s)" % self.pid)
            for server in servers:
                server.stop(timeout=1)
        except:
            pass
        
    def init_process(self):
        self.patch()
        hub.reinit()
        super().init_process()
        
        
class PyWSGIServer(pywsgi.WSGIServer):
    pass


class GeventPyWSGIWorker(GeventWorker):
    "The Gevent StreamServer based workers."
    server_class = PyWSGIServer
    wsgi_handler = PyWSGIHandler
        
```



### eventlet模式  geventlet.py

依赖 eventlet模块

```python
try:
    import eventlet
except ImportError:
    raise RuntimeError("eventlet worker requires eventlet 0.24.1 or higher")
else:
    from pkg_resources import parse_version
    if parse_version(eventlet.__version__) < parse_version('0.24.1'):
        raise RuntimeError("eventlet worker requires eventlet 0.24.1 or higher")

from eventlet import hubs, greenthread
from eventlet.greenio import GreenSocket
from eventlet.hubs import trampoline
from eventlet.wsgi import ALREADY_HANDLED as EVENTLET_ALREADY_HANDLED
import greenlet

from gunicorn.workers.base_async import AsyncWorker

class EventletWorker(AsyncWorker):
    
    def init_process(self):
        self.patch()
        super().init_process()
        
    def run(self):
        acceptors = []
        for sock in self.sockets:
            gsock = GreenSocket(sock)
            gsock.setblocking(1)
            hfun = partial(self.handle, gsock)
            acceptor = eventlet.spawn(_eventlet_serve, gsock, hfun,
                                      self.worker_connections)

            acceptors.append(acceptor)
            eventlet.sleep(0.0)

        while self.alive:
            self.notify()
            eventlet.sleep(1.0)

        self.notify()
        try:
            with eventlet.Timeout(self.cfg.graceful_timeout) as t:
                for a in acceptors:
                    a.kill(eventlet.StopServe())
                for a in acceptors:
                    a.wait()
        except eventlet.Timeout as te:
            if te != t:
                raise
            for a in acceptors:
                a.kill()

                
    def patch(self):  
        # 植入 eventlet的监听
        hubs.use_hub()
        eventlet.monkey_patch()
        patch_sendfile()    
```



### tornado模式 gtornado.py

```python
try:
    import tornado
except ImportError:
    raise RuntimeError("You need tornado installed to use this worker.")
import tornado.web
import tornado.httpserver
from tornado.ioloop import IOLoop, PeriodicCallback
from tornado.wsgi import WSGIContainer
from gunicorn.workers.base import Worker
from gunicorn import __version__ as gversion


class TornadoWorker(Worker):
    
    def init_process(self):
        # IOLoop cannot survive a fork or be shared across processes
        # in any way. When multiple processes are being used, each process
        # should create its own IOLoop. We should clear current IOLoop
        # if exists before os.fork.
        IOLoop.clear_current()
        super().init_process()

    def run(self):
        self.ioloop = IOLoop.instance()
        self.alive = True
        self.server_alive = False

        if TORNADO5:
            self.callbacks = []
            self.callbacks.append(PeriodicCallback(self.watchdog, 1000))
            self.callbacks.append(PeriodicCallback(self.heartbeat, 1000))
            for callback in self.callbacks:
                callback.start()
        else:
            PeriodicCallback(self.watchdog, 1000, io_loop=self.ioloop).start()
            PeriodicCallback(self.heartbeat, 1000, io_loop=self.ioloop).start()

        # Assume the app is a WSGI callable if its not an
        # instance of tornado.web.Application or is an
        # instance of tornado.wsgi.WSGIApplication
        app = self.wsgi

        if tornado.version_info[0] < 6:
            if not isinstance(app, tornado.web.Application) or \
            isinstance(app, tornado.wsgi.WSGIApplication):
                app = WSGIContainer(app)

        # Monkey-patching HTTPConnection.finish to count the
        # number of requests being handled by Tornado. This
        # will help gunicorn shutdown the worker if max_requests
        # is exceeded.
        httpserver = sys.modules["tornado.httpserver"]
        if hasattr(httpserver, 'HTTPConnection'):
            old_connection_finish = httpserver.HTTPConnection.finish

            def finish(other):
                self.handle_request()
                old_connection_finish(other)
            httpserver.HTTPConnection.finish = finish
            sys.modules["tornado.httpserver"] = httpserver

            server_class = tornado.httpserver.HTTPServer
        else:

            class _HTTPServer(tornado.httpserver.HTTPServer):

                def on_close(instance, server_conn):
                    self.handle_request()
                    super(_HTTPServer, instance).on_close(server_conn)

            server_class = _HTTPServer

        if self.cfg.is_ssl:
            _ssl_opt = copy.deepcopy(self.cfg.ssl_options)
            # tornado refuses initialization if ssl_options contains following
            # options
            del _ssl_opt["do_handshake_on_connect"]
            del _ssl_opt["suppress_ragged_eofs"]
            if TORNADO5:
                server = server_class(app, ssl_options=_ssl_opt)
            else:
                server = server_class(app, io_loop=self.ioloop,
                                      ssl_options=_ssl_opt)
        else:
            if TORNADO5:
                server = server_class(app)
            else:
                server = server_class(app, io_loop=self.ioloop)

        self.server = server
        self.server_alive = True

        for s in self.sockets:
            s.setblocking(0)
            if hasattr(server, "add_socket"):  # tornado > 2.0
                server.add_socket(s)
            elif hasattr(server, "_sockets"):  # tornado 2.0
                server._sockets[s.fileno()] = s

        server.no_keep_alive = self.cfg.keepalive <= 0
        server.start(num_processes=1)

        self.ioloop.start()
    
```



## 本章参考

* 知乎专栏--Gunicorn源码分析 https://www.zhihu.com/column/c_1111933629604880384
* Gunicorn源码分析（二）Worker进程 https://www.jianshu.com/p/ef50cc1706d5
