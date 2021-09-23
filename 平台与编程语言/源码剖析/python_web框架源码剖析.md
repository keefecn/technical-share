| 序号 | 修改时间  | 修改内容                                   | 修改人 | 审稿人 |
| ---- | --------- | ------------------------------------------ | ------ | ------ |
| 1    | 2021-6-9  | 创建。从《PYTHON WEB框架分析》迁移相关章节 | Keefe  |        |
| 2    | 2021-7-6  | 新增 gunicorn源码剖析 章节，7.18另文       | 同上   |        |
| 3    | 2021-8-23 | flask源码剖析 拆分单独成文。               | 同上   |        |









---

[TOC]

---

# web框架源码剖析小结

## 实现方式比较

表格  python三大框架的实现方式比较

|                | Django                                              | Flask                                            | tornado                                                      |
| -------------- | --------------------------------------------------- | ------------------------------------------------ | ------------------------------------------------------------ |
| 简述           | 全能、重量级框架                                    | 轻量级框架，原生组件少                           | 轻量、异步高性能                                             |
| 代码行数       | 120K                                                | 42K                                              | 6.5K                                                         |
| 全局WEB实例    | startproject                                        | `from flask import Flask  g_app=Flask(__name__)` | tornado.web.Application                                      |
| 应用app实例    | startapp                                            | 蓝图Blureprint                                   |                                                              |
| restful扩展    | djangorestframework                                 | flask_restplus                                   |                                                              |
| 类基础视图View | from django.views import View                       | from flask.views import View                     |                                                              |
| 类视图APIView  | from rest_framework.views import APIView            |                                                  |                                                              |
| 路由映射       | urlpatterns = [    path('admin/', admin.site.urls), | add_url_rule('/xx', viewfun=xxView.as_view())    | router = RuleRouter([     Rule(PathMatches("/router.*"), CustomRouter()) ]) |
| ORM            | DRF                                                 | flask_sqlalchemy                                 |                                                              |
| swagger        | drf-yasg 或 coreapi                                 | flassger 或 restplus                             |                                                              |



#  1 django源码剖析

源码版本：django-3.2.4

依赖组件： pytz, sqlparse

* pytz 世界时区定义、转化和
* sqlparse sql解析库

```shell
$ pip show django
Name: Django
Version: 2.2.24
Summary: A high-level Python Web framework that encourages rapid development and
 clean, pragmatic design.
Home-page: https://www.djangoproject.com/
Author: Django Software Foundation
Author-email: foundation@djangoproject.com
License: BSD
Location: e:\dev\python\bin\python37\lib\site-packages
Requires: pytz, sqlparse
Required-by: drf-yasg, djangorestframework
```



##  源码结构 

表格 django源码结构

| 目录          | 子目录或文件                                                 | 说明                           |
| ------------- | ------------------------------------------------------------ | ------------------------------ |
| app           |                                                              |                                |
| bin           | django-admin.py                                              |                                |
| conf          |                                                              | 配置信息，分语种               |
| contrib       | 目录有admin auth contenttypes  flatpages gis  postgres <br>redirects sessions sitemaps sites statfiles syndication | 兼容旧版本的功能，包括各个 app |
| core          | 缓存 序列化 代理 信号 验证器                                 | 核心功能                       |
|               | 目录: cache check files handlers mail serializers servers    |                                |
|               | 文件: asgi.py wsgi.py signals.py validator.py                |                                |
| db            | 目录：backends migrations models                             | 数据库、迁移、ORM              |
| dispatch      | dispatch.py                                                  |                                |
| forms         | 目录有jiajia2, template                                      | 前端控件                       |
| http          | request.py response.py cookie.py multipartparser.py          |                                |
| middleware    | csrf.py gzip.py http.py locale.py security.py                | 中间件                         |
| template      |                                                              | 模板                           |
| tempatetags   |                                                              |                                |
| test          |                                                              | 测试                           |
| urls          | base.py conf.py converters.py resolvers.py                   | url检测、转换、解析            |
| utils         | functional.py                                                | 工具                           |
| views         | 目录有decorator, generic, template<br>文件有csrf.py static.py | 视图                           |
| `__main__.py` |                                                              |                                |
| shortcuts.py  |                                                              |                                |



## 命令行指令

###   命令行入口 execute_from_command_line

无论 manager.py 还是 django-admin.py 最终执行的命令都是通过 调用 execute_from_command_line实现的

```python
# manager.py 或者 django-admin
from django.core.management import execute_from_command_line

execute_from_command_line(sys.argv)
```



django/core/management/commands

```shell
#django支持的命令：包括manager.py xx 和 django-admin xx
$ ls core/management/commands/
__init__.py          flush.py           sendtestemail.py     startapp.py
check.py             inspectdb.py       shell.py             startproject.py
compilemessages.py   loaddata.py        showmigrations.py    test.py
createcachetable.py  makemessages.py    sqlflush.py          testserver.py
dbshell.py           makemigrations.py  sqlmigrate.py
diffsettings.py      migrate.py         sqlsequencereset.py
dumpdata.py          runserver.py       squashmigrations.py
```



###   程序启动命令: runserver

django有两种运行方式

1. 通过python manage.py runserver运行自带的web server
2. 通过mod_python（弃）



命令：`python manger.py runserver` 

实际执行： `django/core/management/commands/runserver.py:run`

```python
from django.conf import settings
from django.core.management.base import BaseCommand, CommandError
from django.core.servers.basehttp import (
    WSGIServer, get_internal_wsgi_application, run,
)
from django.utils import autoreload
from django.utils.regex_helper import _lazy_re_compile

class Command(BaseCommand):
    help = "Starts a lightweight Web server for development."

    # Validation is called explicitly each time the server is reloaded.
    requires_system_checks = []
    stealth_options = ('shutdown_message',)

    default_addr = '127.0.0.1'
    default_addr_ipv6 = '::1'
    default_port = '8000'
    protocol = 'http'
    server_cls = WSGIServer  #要启动的服务器类
    
    def run(self, **options):
        """Run the server, using the autoreloader if needed."""
        use_reloader = options['use_reloader']

        if use_reloader:	#运行时重载支持
            autoreload.run_with_reloader(self.inner_run, **options)
        else:
            self.inner_run(None, **options) #实际run    
            
    def inner_run(self, *args, **options):
        ...
        try:
            handler = self.get_handler(*args, **options) #获取处理器
            run(self.addr, int(self.port), handler,
                ipv6=self.use_ipv6, threading=threading, server_cls=self.server_cls)
        except
        	...
```



django/core/servers/basehttp.py 

在这启动WSGIServer

```python
from wsgiref import simple_server

def run(addr, port, wsgi_handler, ipv6=False, threading=False, server_cls=WSGIServer):
    server_address = (addr, port)
    if threading:
        httpd_cls = type('WSGIServer', (socketserver.ThreadingMixIn, server_cls), {})
    else:
        httpd_cls = server_cls
    httpd = httpd_cls(server_address, WSGIRequestHandler, ipv6=ipv6)
    if threading: # 后台启动线程
        # ThreadingMixIn.daemon_threads indicates how threads will behave on an
        # abrupt shutdown; like quitting the server by the user or restarting
        # by the auto-reloader. True means the server will not wait for thread
        # termination before it quits. This will make auto-reloader faster
        # and will prevent the need to kill the server manually if a thread
        # isn't terminating correctly.
        httpd.daemon_threads = True
    httpd.set_app(wsgi_handler)	#设置处理句柄
    httpd.serve_forever()   	#程序一直存活


class WSGIServer(simple_server.WSGIServer):
    """BaseHTTPServer that implements the Python WSGI protocol"""
	# WSGI定义
    request_queue_size = 10

    def __init__(self, *args, ipv6=False, allow_reuse_address=True, **kwargs):
        if ipv6:
            self.address_family = socket.AF_INET6
        self.allow_reuse_address = allow_reuse_address
        super().__init__(*args, **kwargs)
    
```



### 数据库转移命令 migrate

命令：`python manger.py migrate`

当数据库表、字段有变化时，可以通过migrate命令进行数据库重建。



## HTTP处理

###   请求处理 WSGIServer/WSGIHandler

请求处理流程小结：

1. 建立WSGIServer对象。
2. 接收到HttpRequest时，通过相应的wsgi_handler处理`WSGIHandler.__call__()`
3. 步骤2调用父类的`base.BaseHandler.get_response()`处理URL路由、中间件链路，得到响应结果HttpResponse

django/core/handlers/wsgi.py

```python
from django.http import HttpRequest, QueryDict, parse_cookie
from django.urls import set_script_prefix
from django.core.handlers import base

class WSGIRequest(HttpRequest):
    def __init__(self, environ):
        script_name = get_script_name(environ)
        # If PATH_INFO is empty (e.g. accessing the SCRIPT_NAME URL without a
        # trailing slash), operate as if '/' was requested.
        path_info = get_path_info(environ) or '/'
        self.environ = environ
        self.path_info = path_info
        # be careful to only replace the first slash in the path because of
        # http://test/something and http://test//something being different as
        # stated in https://www.ietf.org/rfc/rfc2396.txt
        self.path = '%s/%s' % (script_name.rstrip('/'),
                               path_info.replace('/', '', 1))
        self.META = environ
        self.META['PATH_INFO'] = path_info
        self.META['SCRIPT_NAME'] = script_name
        self.method = environ['REQUEST_METHOD'].upper()
        # Set content_type, content_params, and encoding.
        self._set_content_type_params(environ)
        try:
            content_length = int(environ.get('CONTENT_LENGTH'))
        except (ValueError, TypeError):
            content_length = 0
        self._stream = LimitedStream(self.environ['wsgi.input'], content_length)
        self._read_started = False
        self.resolver_match = None
    
    
class WSGIHandler(base.BaseHandler):
    request_class = WSGIRequest  # HTTPRequest子类

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.load_middleware()  #调用父类方法加载中间件

    def __call__(self, environ, start_response):
        """ 构造函数执行完就被自动调用 __call__ """
        set_script_prefix(get_script_name(environ))
        signals.request_started.send(sender=self.__class__, environ=environ)
        # 从环境变量中获取请求、响应对象类
        request = self.request_class(environ)
        # 调用父类方法 get_response获取处理结果 
        response = self.get_response(request)

        response._handler_class = self.__class__
        status = '%d %s' % (response.status_code, response.reason_phrase)
        response_headers = [
            *response.items(),
            *(('Set-Cookie', c.output(header='')) for c in response.cookies.values()),
        ]
        start_response(status, response_headers)
        if getattr(response, 'file_to_stream', None) is not None and environ.get('wsgi.file_wrapper'):
            # If `wsgi.file_wrapper` is used the WSGI server does not call
            # .close on the response, but on the file wrapper. Patch it to use
            # response.close instead which takes care of closing all files.
            response.file_to_stream.close = response.close
            response = environ['wsgi.file_wrapper'](response.file_to_stream, response.block_size)
        return response
```



django/core/handlers/base.py

```python
# asgiref模块是django软件基金会维护的，属于django的子模块
from asgiref.sync import async_to_sync, sync_to_async  

class BaseHandler:
    _view_middleware = None
    _template_response_middleware = None
    _exception_middleware = None
    _middleware_chain = None

    def load_middleware(self, is_async=False):
        """
        Populate middleware lists from settings.MIDDLEWARE.
		从settings.MIDDLEWARE加载中间件，要求在环境初始化后
        Must be called after the environment is fixed (see __call__ in subclasses).
        """        
        get_response = self._get_response_async if is_async else self._get_response
        handler = convert_exception_to_response(get_response)
        handler_is_async = is_async   
        
        # 多个中间件时的处理
        for middleware_path in reversed(settings.MIDDLEWARE):
        	# 略        
        
        # Adapt the top of the stack, if needed.
        handler = self.adapt_method_mode(is_async, handler, handler_is_async)
        self._middleware_chain = handler
        
    def get_response(self, request):
        """Return an HttpResponse object for the given HttpRequest."""
        # Setup default url resolver for this thread
        # 获取路由映射，从路由映射中得到view函数
        set_urlconf(settings.ROOT_URLCONF)
        # 执行中间件链
        response = self._middleware_chain(request)
        response._resource_closers.append(request.close)
        if response.status_code >= 400:
            log_response(
                '%s: %s', response.reason_phrase, request.path,
                response=response,
                request=request,
            )
        return response

    async def get_response_async(self, request):
        """
        Asynchronous version of get_response.
		异步响应： async + await 
        Funneling everything, including WSGI, into a single async
        get_response() is too slow. Avoid the context switch by using
        a separate async response path.
        """
        # Setup default url resolver for this thread.
        set_urlconf(settings.ROOT_URLCONF)
        response = await self._middleware_chain(request)
        response._resource_closers.append(request.close)
        if response.status_code >= 400:
            await sync_to_async(log_response, thread_sensitive=False)(
                '%s: %s', response.reason_phrase, request.path,
                response=response,
                request=request,
            )
        return response        
```





## MVC

### Django原生MVC

* 视图 Views： 2种形式，分别是FBV（基于函数）和CBV（基于类）。

* 序列化：



### 路由

1) 模块路由映射函数：path, re_path模块

导入： `from django.urls import path, re_path`

源文件：django/urls/conf

```python
from functools import partial
from importlib import import_module

from django.core.exceptions import ImproperlyConfigured

from .resolvers import (
    LocalePrefixPattern, RegexPattern, RoutePattern, URLPattern, URLResolver,
)

def _path(route, view, kwargs=None, name=None, Pattern=None):
    if isinstance(view, (list, tuple)): 
        # For include(...) processing. 支持原来的include方法
        pattern = Pattern(route, is_endpoint=False)
        urlconf_module, app_name, namespace = view
        return URLResolver(
            pattern,
            urlconf_module,
            kwargs,
            app_name=app_name,
            namespace=namespace,
        )
    elif callable(view): #view是可调用函数，即函数或xxView.as_view()转化过
        pattern = Pattern(route, name=name, is_endpoint=True)
        return URLPattern(pattern, view, kwargs, name)
    else:
        raise TypeError('view must be a callable or a list/tuple in the case of include().')


path = partial(_path, Pattern=RoutePattern)     #路由模式
re_path = partial(_path, Pattern=RegexPattern)	#正则模式
```



django/urls/resolver.py

```python
from django.core.checks.urls import check_resolver
from .converters import get_converter
from .exceptions import NoReverseMatch, Resolver404

class CheckURLMixin:
    def describe(self):
        """
        Format the URL pattern for display in warning messages.
        """
    def _check_pattern_startswith_slash(self):
        """ 检查模式不要以/开头
        Check that the pattern does not begin with a forward slash.
        """
        
class RoutePattern(CheckURLMixin):
    regex = LocaleRegexDescriptor('_route')

    def __init__(self, route, name=None, is_endpoint=False):
        self._route = route
        self._regex_dict = {}
        self._is_endpoint = is_endpoint
        self.name = name
        self.converters = _route_to_regex(str(route), is_endpoint)[1]

    def match(self, path):
        #...
    def check(self):
        #...
```



## 扩展模块

### 中间件处理

django/utils/deprecation.py  //? 待废弃的代码

```python
import asyncio
from asgiref.sync import sync_to_async

class MiddlewareMixin:
    sync_capable = True
    async_capable = True

    # RemovedInDjango40Warning: when the deprecation ends, replace with:
    #   def __init__(self, get_response):
    def __init__(self, get_response=None):
        self._get_response_none_deprecation(get_response)
        self.get_response = get_response
        self._async_check()
        super().__init__()  #？没基类
        
    def __call__(self, request):
        # 如果是异步模式，调用__acall__
        if asyncio.iscoroutinefunction(self.get_response):
            return self.__acall__(request)
        response = None
        if hasattr(self, 'process_request'):
            response = self.process_request(request)
        response = response or self.get_response(request)
        if hasattr(self, 'process_response'):
            response = self.process_response(request, response)
        return response

    async def __acall__(self, request):
        """
        Async version of __call__ that is swapped in when an async request
        is running.  异步模式的调用
        """
        response = None
        if hasattr(self, 'process_request'):
            response = await sync_to_async(
                self.process_request,
                thread_sensitive=True,
            )(request)
        response = response or await self.get_response(request)
        if hasattr(self, 'process_response'):
            response = await sync_to_async(
                self.process_response,
                thread_sensitive=True,
            )(request, response)
        return response
```



### djangorestframework-DRF

安装：`pip install djangorestframework ` 

```shell
$ pip show djangorestframework
Name: djangorestframework
Version: 3.12.4
Summary: Web APIs for Django, made easy.
Home-page: https://www.django-rest-framework.org/
Author: Tom Christie
Author-email: tom@tomchristie.com
License: BSD
Location: e:\dev\python\bin\python37\lib\site-packages
Requires: django
Required-by: drf-yasg, django-rest-swagger
```



1. 序列化

序列化类层次:  

```sh
Field(object) -> BaseSerialize -> Serialize -> ModelSerialize
                               -> ListSerialize
```

文件：rest_framework/fields.py

```python
class Field:
    _creation_counter = 0

    default_error_messages = {
        'required': _('This field is required.'),
        'null': _('This field may not be null.')
    }
    default_validators = []
    default_empty_html = empty
    initial = None

    def __init__(self, read_only=False, write_only=False,
                 required=None, default=empty, initial=empty, source=None,
                 label=None, help_text=None, style=None,
                 error_messages=None, validators=None, allow_null=False):
        """
        read_only：True表示不允许用户自己上传，只能用于api的输出。如果某个字段设置了read_only=True，那么就不需要进行数据验证，只会在返回时，将这个字段序列化后返回
        write_only: 与read_only对应
        required: 顾名思义，就是这个字段是否必填。
        allow_null/allow_blank：是否允许为NULL/空 。
        error_messages：出错时，信息提示,与form表单一样。
        label: 字段显示设置，如 label=’验证码’
        help_text: 在指定字段增加一些提示文字，这两个字段作用于api页面比较有用
        style: 说明字段的类型，这样看可能比较抽象，如：
        password = serializers.CharField(style={'input_type': 'password'})
        validators:指定验证器。
        """
        self._creation_counter = Field._creation_counter
        Field._creation_counter += 1

        # If `required` is unset, then use `True` unless a default is provided.
        if required is None:
            required = default is empty and not read_only

        # Some combinations of keyword arguments do not make sense.
        assert not (read_only and write_only), NOT_READ_ONLY_WRITE_ONLY
        assert not (read_only and required), NOT_READ_ONLY_REQUIRED
        assert not (required and default is not empty), NOT_REQUIRED_DEFAULT
        assert not (read_only and self.__class__ == Field), USE_READONLYFIELD

        self.read_only = read_only
        self.write_only = write_only
        self.required = required
        self.default = default
        self.source = source
        self.initial = self.initial if (initial is empty) else initial
        self.label = label
        self.help_text = help_text
        self.style = {} if style is None else style
        self.allow_null = allow_null

        if self.default_empty_html is not empty:
            if default is not empty:
                self.default_empty_html = default

        if validators is not None:
            self.validators = list(validators)

        # These are set up by `.bind()` when the field is added to a serializer.
        self.field_name = None
        self.parent = None

        # Collect default error message from self and parent classes
        messages = {}
        for cls in reversed(self.__class__.__mro__):
            messages.update(getattr(cls, 'default_error_messages', {}))
        messages.update(error_messages or {})
        self.error_messages = messages
```



2. 视图

   视图类层次： 
   
   ```sh
   View(object) -> APIView -> GenericAPIView -> ListAPIView/xxAPIView
                           -> ViewSets
   ```
   
   

## 本章参考



#  2 flask源码剖析

参见  《[flask源码剖析.md](./flask源码剖析.md)》



#  3 tornado源码剖析

Tornado 由前 google 员工开发，代码非常精练，实现也很轻巧，加上清晰的注释和丰富的 demo，我们可以很容易的阅读分析 tornado. 通过阅读 Tornado 的[源码](http://www.nowamagic.net/academy/tag/源码)，你将学到：

- 理解 Tornado 的内部实现，使用 tornado 进行 web 开发将更加得心应手。
- 如何实现一个高性能，非阻塞的 http 服务器。
- 如何实现一个 web 框架。
- 各种网络编程的知识，比如 epoll
- python 编程的绝佳实践



源码版本：tornado-6.1

依赖组件： 无

```shell
$ pip show tornado
Name: tornado
Version: 6.1
Summary: Tornado is a Python web framework and asynchronous networking library,
originally developed at FriendFeed.
Home-page: http://www.tornadoweb.org/
Author: Facebook
Author-email: python-tornado@googlegroups.com
License: http://www.apache.org/licenses/LICENSE-2.0
Location: e:\dev\python\bin\python37\lib\site-packages
Requires:
Required-by: terminado, notebook, jupyterlab, jupyter-server, jupyter-client, ip
ykernel
```



**程序demo**

```python
import tornado.ioloop
import tornado.web
  
class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.write("Hello, world")
  
application = tornado.web.Application([
    (r"/index", MainHandler),
])
  
if __name__ == "__main__":
    application.listen(8888)
    tornado.ioloop.IOLoop.instance().start()
```



## 源码结构 

表格 tornado源码结构

| 类别    | 目录或文件           | 主要类或函数                                                 | 说明                                             |
| ------- | -------------------- | ------------------------------------------------------------ | ------------------------------------------------ |
|         | platform             | twisted.py asyncio.py asyncio.BaseAsyncIOLoop                | 依赖模块-网络异步IO                              |
| utils   | test                 | xx.py                                                        | 单元测试                                         |
|         | `__init__.py`        |                                                              | 版本号                                           |
|         | _locale_data.py      |                                                              | 语言映射                                         |
| other   | auth.py              | OpenIdMixin OAuthMixin OAuth2Mixin TwitterMixin GoogleOAuth2Mixin FacebookGraphMixin | 使用OpenId和OAuth进行第三方登录                  |
| other   | autoreload.py        | start wait watch main                                        | 生产环境中自动检查代码更新                       |
|         | concurrent.py        | Future DummyExecutor                                         | 并发                                             |
|         | curl_httpclient.py   | CurlAsyncHTTPClient                                          | CURL实现的HTTP客户端                             |
| core    | escape.py            | url_escape url_unescape json_encode json_decode              | HTML,JSON,URLs等的编码解码和一些字符串操作       |
| core    | locale.py            | Locale                                                       | 国际化支持                                       |
| core    | template.py          | BaseLoader Loader DictLoader                                 | 模板                                             |
| core    | web.py               | Application RequestHandler                                   | WEB框架的大部分功能。                            |
| core    | httpserver.py        | HTTPServer                                                   | 一个无阻塞HTTP服务器的实现                       |
| utils   | gen.py               | Runner Return                                                | 一个基于生成器的接口，使用该模块保证代码异步运行 |
|         | http1connection.py   | HTTP1Connection HTTP1ServerConnection                        | HTTP连接                                         |
| network | httpclient.py        | AsyncHTTPClient HTTPRequest HTTPResponse                     | HTTP客户端                                       |
| utils   | httputil.py          | HTTPServerRequest  HTTPHeaders HTTPFile HTTPConnection       | HTTP小工具，分析HTTP请求内容                     |
| network | ioloop.py            | IOLoop                                                       | IO循环                                           |
| network | iostream.py          | BaseIOStream                                                 | IO流                                             |
| utils   | locks.py             | Condition Event Semaphore Lock                               | 锁                                               |
| utils   | log.py               | LogFormatter                                                 | 日志                                             |
| network | netutil.py           | Resolver ExecutorResolver BlockingResolver ThreadedResolver OverrideResolver | 网络小工具                                       |
| utils   | options.py           | OptionParser                                                 | 解析终端参数                                     |
| utils   | process.py           | Subprocess                                                   | 多进程实现的封装                                 |
| utils   | queues.py            | Queue                                                        | 队列                                             |
|         | routing.py           | Router                                                       | 路由                                             |
|         | simple_httpclient.py | SimpleAsyncHTTPClient                                        | 简单HTTP客户端                                   |
|         | tcpclient.py         | TCPClient                                                    | TCP客户端                                        |
|         | tcpserver.py         | TCPServer                                                    | TCP服务端                                        |
| utils   | util.py              | Configurable ArgReplacer                                     | 工具集合                                         |
| other   | websocket.py         | WebSocketHandler                                             | 实现和浏览器的双向通信                           |
| other   | wsgi.py              | WSGIContainer                                                | 与其他python网络框架/服务器的相互操作            |

将上面代码分为四个部分，分别是Core核心WEB框架、network网络底层模块、other其它服务、utils工具类。



## WEB核心对象

* web.py web核心对象，包括Application、RequestHandler
* routing.py 路由对象 
* tcpserver.py TCP服务器



web.py 包括

*  Application应用程序对象: Application类启动web server，启动web server的相应功能。
* RequestHandler: 内含大量方法用于处理网络请求，并生成对应的response。

```python
class Application(ReversibleRouter):
    def __init__(
        self,
        handlers: Optional[_RuleList] = None,  # 路由列表
        default_host: Optional[str] = None,
        transforms: Optional[List[Type["OutputTransform"]]] = None,
        **settings: Any
    ) -> None:
        
    def listen(self, port: int, address: str = "", **kwargs: Any) -> HTTPServer:
        """Starts an HTTP server for this application on the given port.

        This is a convenience alias for creating an `.HTTPServer`
        object and calling its listen method.  Keyword arguments not
        supported by `HTTPServer.listen <.TCPServer.listen>` are passed to the
        `.HTTPServer` constructor.  For advanced uses
        (e.g. multi-process mode), do not use this method; create an
        `.HTTPServer` and call its
        `.TCPServer.bind`/`.TCPServer.start` methods directly.

        Note that after calling this method you still need to call
        ``IOLoop.current().start()`` to start the server.

        Returns the `.HTTPServer` object.

        .. versionchanged:: 4.3
           Now returns the `.HTTPServer` object.
        """
        server = HTTPServer(self, **kwargs)
        server.listen(port, address)  #此处listen方法实现socket bind + listen + add_socket
        return server    
    
    
class RequestHandler(object):
    """Base class for HTTP request handlers.

    Subclasses must define at least one of the methods defined in the
    "Entry points" section below.

    Applications should not construct `RequestHandler` objects
    directly and subclasses should not override ``__init__`` (override
    `~RequestHandler.initialize` instead).

    """
    SUPPORTED_METHODS = ("GET", "HEAD", "POST", "DELETE", "PATCH", "PUT", "OPTIONS")

    _template_loaders = {}  # type: Dict[str, template.BaseLoader]
    _template_loader_lock = threading.Lock()
    _remove_control_chars_regex = re.compile(r"[\x00-\x08\x0e-\x1f]")

    _stream_request_body = False

    # Will be set in _execute.
    _transforms = None  # type: List[OutputTransform]
    path_args = None  # type: List[str]
    path_kwargs = None  # type: Dict[str, str]    
```



routing.py 路由对象 

```python
class Router(httputil.HTTPServerConnectionDelegate):
    """Abstract router interface."""

    def find_handler(
        self, request: httputil.HTTPServerRequest, **kwargs: Any
    ) -> Optional[httputil.HTTPMessageDelegate]:
        """Must be implemented to return an appropriate instance of `~.httputil.HTTPMessageDelegate`
        that can serve the request.
        Routing implementations may pass additional kwargs to extend the routing logic.

        :arg httputil.HTTPServerRequest request: current HTTP request.
        :arg kwargs: additional keyword arguments passed by routing implementation.
        :returns: an instance of `~.httputil.HTTPMessageDelegate` that will be used to
            process the request.
        """
        raise NotImplementedError()

    def start_request(
        self, server_conn: object, request_conn: httputil.HTTPConnection
    ) -> httputil.HTTPMessageDelegate:
        return _RoutingDelegate(self, server_conn, request_conn)

    
class ReversibleRouter(Router):
    
```



tornado/tcpserver.py

支持三种使用方法

1. 简单单进程： listen

2. 简单多进程： bind, start

3. 高级多进程： add_sockets start

   ```PY
   sockets = tornado.netutil.bind_sockets(8888)
   tornado.process.fork_processes(0)
   server = HTTPServer(app)
   server.add_sockets(sockets)
   IOLoop.current().start()
   ```

   

定义
```python
class TCPServer(object):
    def __init__(
        self,
        ssl_options: Optional[Union[Dict[str, Any], ssl.SSLContext]] = None,
        max_buffer_size: Optional[int] = None,
        read_chunk_size: Optional[int] = None,
    ) -> None:
        self.ssl_options = ssl_options
        self._sockets = {}  # type: Dict[int, socket.socket]
        self._handlers = {}  # type: Dict[int, Callable[[], None]]
        self._pending_sockets = []  # type: List[socket.socket]
        self._started = False
        self._stopped = False
        self.max_buffer_size = max_buffer_size
        self.read_chunk_size = read_chunk_size
        
    def listen(self, port: int, address: str = "") -> None:
        """Starts accepting connections on the given port.
        """
        sockets = bind_sockets(port, address=address) #bind=socket+bind+listen
        self.add_sockets(sockets)

    def add_sockets(self, sockets: Iterable[socket.socket]) -> None:
        """Makes this server start accepting connections on the given sockets.

        The ``sockets`` parameter is a list of socket objects such as
        those returned by `~tornado.netutil.bind_sockets`.
        `add_sockets` is typically used in combination with that
        method and `tornado.process.fork_processes` to provide greater
        control over the initialization of a multi-process server.
        """
        for sock in sockets:
            self._sockets[sock.fileno()] = sock
            self._handlers[sock.fileno()] = add_accept_handler(
                sock, self._handle_connection
            )        
```





## 网络处理 ioloop.py

tornado.ioloop.IOLoop.instance().start()

说明：*事件循环机制*实现早期是用twisted的epoll实现，6.0+版本换用asyncio实现。

ioloop.py 

```python
import asyncio
import concurrent.futures
from tornado.concurrent import (
    Future,
    is_future,
    chain_future,
    future_set_exc_info,
    future_add_done_callback,
)

class IOLoop(Configurable):
    """An I/O event loop.

    As of Tornado 6.0, `IOLoop` is a wrapper around the `asyncio` event
    loop.
    """
    # In Python 3, _ioloop_for_asyncio maps from asyncio loops to IOLoops.
    _ioloop_for_asyncio = dict()  # type: Dict[asyncio.AbstractEventLoop, IOLoop]

    @classmethod
    def configure(
        cls, impl: "Union[None, str, Type[Configurable]]", **kwargs: Any
    ) -> None:
        # 配置IO循环的实现方式：6.x实现默认用 asyncio
        if asyncio is not None:
            # 此处导入BaseAsyncIOLoop 
            from tornado.platform.asyncio import BaseAsyncIOLoop
            
            if isinstance(impl, str):
                impl = import_object(impl)
            if isinstance(impl, type) and not issubclass(impl, BaseAsyncIOLoop):
                raise RuntimeError(
                    "only AsyncIOLoop is allowed when asyncio is available"
                )
        super(IOLoop, cls).configure(impl, **kwargs)
        
    @staticmethod
    def instance() -> "IOLoop":
        # IO对象实例化，返回当前一个可用的IO实例
        return IOLoop.current()      
    
    @staticmethod
    def current(instance: bool = True) -> Optional["IOLoop"]:
        try:
            loop = asyncio.get_event_loop()
        except (RuntimeError, AssertionError):
            if not instance:
                return None
            raise
        try:
            return IOLoop._ioloop_for_asyncio[loop]
        except KeyError:
            if instance:
                from tornado.platform.asyncio import AsyncIOMainLoop
                # 此处获取IO循环对象实例
                current = AsyncIOMainLoop(make_current=True)  # type: Optional[IOLoop]
            else:
                current = None
        return current        
```



ioloop.py 测试demo

```python
import errno
import functools
import socket

import tornado.ioloop
from tornado.iostream import IOStream

async def handle_connection(connection, address):
    stream = IOStream(connection)
    message = await stream.read_until_close()
    print("message from client:", message.decode().strip())

def connection_ready(sock, fd, events):
    while True:
        try: #阻塞获取到有数据的连接 
            connection, address = sock.accept()  
        except BlockingIOError:
            return
        connection.setblocking(0)
        io_loop = tornado.ioloop.IOLoop.current()
        io_loop.spawn_callback(handle_connection, connection, address)

if __name__ == '__main__':
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    sock.setblocking(0)
    sock.bind(("", 8888))
    sock.listen(128)

    io_loop = tornado.ioloop.IOLoop.current()
    callback = functools.partial(connection_ready, sock)
    io_loop.add_handler(sock.fileno(), callback, io_loop.READ)
    io_loop.start()
```



## 平台支持 platform

**Platforms**: Tornado is designed for Unix-like platforms, with best performance and scalability on systems supporting `epoll` (Linux), `kqueue` (BSD/macOS), or `/dev/poll` (Solaris).

tornado网络事件循环早期依赖于twisted，后期依赖于asyncio（python3.6+为标准库）。

* asyncio 详见《python源码剖析》相关章节
* twisted 第三方高性能网络库



platform/asyncio.py

```python
from tornado.ioloop import IOLoop, _Selectable

class BaseAsyncIOLoop(IOLoop):
    def initialize(  # type: ignore
        self, asyncio_loop: asyncio.AbstractEventLoop, **kwargs: Any
    ) -> None:
      """ """

    def start(self) -> None:
        """ 此处start实现，被子类复用：调用asyncio来执行写协程的EventLoop来管理协程 """
        try:
            old_loop = asyncio.get_event_loop()
        except (RuntimeError, AssertionError):
            old_loop = None  # type: ignore
        try:
            self._setup_logging()
            asyncio.set_event_loop(self.asyncio_loop)
            # 持续运行EventLoop
            self.asyncio_loop.run_forever()
        finally:
            asyncio.set_event_loop(old_loop)    
```



## 本章参考

* tornado官方文档 https://www.tornadoweb.org/en/stable/
* 知乎专栏--Tornado源码阅读 https://www.zhihu.com/column/tornado
* asyncio https://docs.python.org/3/library/asyncio.html




# celery源码剖析





# 参考资料

