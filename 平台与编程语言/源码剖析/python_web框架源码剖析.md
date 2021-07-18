| 序号 | 修改时间 | 修改内容                                   | 修改人 | 审稿人 |
| ---- | -------- | ------------------------------------------ | ------ | ------ |
| 1    | 2021-6-9 | 创建。从《PYTHON WEB框架分析》迁移相关章节 | Keefe  |        |
| 2    | 2021-7-6 | 新增 gunicorn源码剖析 章节，7.18另文       | 同上   |        |













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

flask是基于Werkzeug的微框架，是可扩展的最佳实践。

源码版本：flask-1.1.2

依赖组件：click, Werkzeug, Jinja2, itsdangerous

* click 命令行接口工具包
* Werkzeug 功能强大的WSGI应用程序库
* jinja2 一个很快且方便扩展的模板引擎
* itsdangerous 在不可信网络环境中安全传输数据

扩展组件：flask_xxx

```shell
$ pip show flask
Name: Flask
Version: 1.1.2
Summary: A simple framework for building complex web applications.
Home-page: https://palletsprojects.com/p/flask/
Author: Armin Ronacher
Author-email: armin.ronacher@active-4.com
License: BSD-3-Clause
Location: e:\dev\python\bin\python37\lib\site-packages
Requires: click, Werkzeug, Jinja2, itsdangerous
Required-by: Flask-SQLAlchemy, flask-restplus, Flask-RESTful, flasgger
```



**程序demo**

```python
#!coding=utf8
"""
这是一个极简的 flask api示例
install:  pip install flask
run: python flask_main.py
"""

from flask import Flask
app = Flask(__name__)

@app.route("/")    # URL目录
def hello():
    return "Hello Flask!"   # return string


if __name__ == "__main__":
    app.run()
    app.run(host='0.0.0.0')
```



## 源码结构 

表格 flask源码结构

| 目录或文件    | 主要类或函数                                                 | 说明                              |
| ------------- | ------------------------------------------------------------ | --------------------------------- |
| ext           |                                                              | 扩展模块                          |
| _compat.ppy   | with_metaclass                                               | python2&3的兼容处理：类型和元类   |
| app.py        | Flask<br>::run route add_url_rule register_blueprint         | 全局WEB实例                       |
| blueprints.py | Blueprint<br>::route add_url_rule                            | 蓝图，相当于django中的app，某应用 |
| cli.py        | main run_command                                             | 命令行处理                        |
| config.py     | ConfigAttribute Config                                       | 配置数据                          |
| ctx.py        | AppContext RequestContext                                    | 上下文管理                        |
| exthook.py    | ExtensionImporter                                            | 加载扩展模块                      |
| globals.py    | current_app session request g                                | 全局变量                          |
| helpers.py    | _PackageBoundObject                                          | 帮助工具                          |
| json.py       | jsonify dump dumps load loads                                | json转化                          |
| logging.py    |                                                              | 日志                              |
| sessions.py   | SecureCookieSession  SessionInterface <br>SecureCookieSessionInterface | 会话                              |
| signals.py    | Namespace::signal                                            | 信号                              |
| templating.py | DispatchingJinjaLoader Environment                           | 前端用的模板，依赖jinja2          |
| testing.py    | FlaskClient                                                  | 测试                              |
| view.py       | View MethodViewType MethodView                               | 视图类                            |
| wrappers.py   | Request Response                                             | 继承wsgi wrappers，依赖werkzeug   |



## WEB核心对象 

### Flask全局实例 app.py

flask.app该模块近2000行代码，主要完成应用的配置、初始化、蓝图注册、请求装饰器定义、应用的启动和监听。

类：Flask

类方法： run  create_app  register_blueprint  register_db route/add_url_route

```python
from .helpers import _PackageBoundObject

class Flask(_PackageBoundObject):
	"""   Usually you create a :class:`Flask` instance in your main module or
    in the :file:`__init__.py` file of your package like this::

        from flask import Flask
        app = Flask(__name__)
	""" 

    def __init__(self, import_name, static_path=None, static_url_path=None,
                 static_folder='static', template_folder='templates',
                 instance_path=None, instance_relative_config=False,
                 root_path=None):
        """ 初始化一堆东西，如 """
        _PackageBoundObject.__init__(self, import_name,
                                     template_folder=template_folder,
                                     root_path=root_path)
        if static_path is not None:
            from warnings import warn
            warn(DeprecationWarning('static_path is now called '
                                    'static_url_path'), stacklevel=2)
            static_url_path = static_path

        if static_url_path is not None:
            self.static_url_path = static_url_path
        if static_folder is not None:
            self.static_folder = static_folder
        if instance_path is None:
            instance_path = self.auto_find_instance_path()
        elif not os.path.isabs(instance_path):
            raise ValueError('If an instance path is provided it must be '
                             'absolute.  A relative path was given instead.')

        self.instance_path = instance_path
        self._logger = None
        self.logger_name = self.import_name
        self.view_functions = {}
        self._error_handlers = {}
        self.error_handler_spec = {None: self._error_handlers}
        self.url_build_error_handlers = []
        self.before_request_funcs = {}

        self.before_first_request_funcs = []
        self.after_request_funcs = {}
        self.teardown_request_funcs = {}
        self.teardown_appcontext_funcs = []
        self.url_value_preprocessors = {}
        self.url_default_functions = {}
        self.template_context_processors = {
            None: [_default_template_ctx_processor]
        }

        self.shell_context_processors = []
        self.blueprints = {}
        self._blueprint_order = []
        self.extensions = {}
        self.url_map = Map()
        self._got_first_request = False
        self._before_request_lock = Lock()

        if self.has_static_folder:
            self.add_url_rule(self.static_url_path + '/<path:filename>',
                              endpoint='static',
                              view_func=self.send_static_file)
        self.cli = cli.AppGroup(self.name)
        
    def run(self, host=None, port=None, debug=None, **options):
        """Runs the application on a local development server.
        默认情况下，是单进程单线程模型，即一次只能处理一个请求，其它请求需排队。
        """
        if host is None:
            host = '127.0.0.1'
        if port is None:
            server_name = self.config['SERVER_NAME']
            if server_name and ':' in server_name:  #支持配置变量带:方式获取端口
                port = int(server_name.rsplit(':', 1)[1])
            else:
                port = 5000
        if debug is not None:  
            self.debug = bool(debug)  # bool(None)=False,故缺省非调试模式
        options.setdefault('use_reloader', self.debug)
        options.setdefault('use_debugger', self.debug)
        
        from werkzeug.serving import run_simple # 启动方式使用werkzeug模块提供的简单启动
        try: # 简单启动
            run_simple(host, port, self, **options)
        finally:
            # reset the first request information if the development server
            # reset normally.  This makes it possible to restart the server
            # without reloader and that stuff from an interactive shell.
            self._got_first_request = False     
            

	def route(self, rule, **options):	
        """ 路由映射装饰器 route， 实际调用add_url_rule类静态方法 """
        def decorator(f):
            endpoint = options.pop("endpoint", None)
            self.add_url_rule(rule, endpoint, f, **options) #实际调用类方法
            return f

        return decorator

    @setupmethod
    def add_url_rule(
        self,
        rule,
        endpoint=None,
        view_func=None,
        provide_automatic_options=None,
        **options
    ):            

        
if __name__ == '__main__':
    # 实际应用app定义，一般需要弄成全局实例
    app = Flask(__name__)
    with app.app_context():
        app.run(host='0.0.0.0', port=5001)          
```



**调试示例 ipython**

Flask实例关键变量有：cli, config, view_functions, url_map, blueprints, import_name, root_path...

```python
In [11]: from flask import Flask

In [12]: app=Flask('demo_app')

In [13]: type(app)
Out[13]: flask.app.Flask

In [14]: app.__dict__
Out[14]:
{'import_name': 'demo_app',
 'template_folder': 'templates',
 'root_path': 'e:\\isoftstone\\project\\repos\\superset\\joshua_code-superset-js
ohua\\superset',
 '_static_folder': 'static',
 '_static_url_path': None,
 'cli': <AppGroup demo_app>,
 'instance_path': 'e:\\isoftstone\\project\\repos\\superset\\joshua_code-superse
t-jsohua\\superset\\instance',
 'config': <Config {'ENV': 'production', 'DEBUG': False, 'TESTING': False, 'PROP
AGATE_EXCEPTIONS': None, 'PRESERVE_CONTEXT_ON_EXCEPTION': None, 'SECRET_KEY': No
ne, 'PERMANENT_SESSION_LIFETIME': datetime.timedelta(days=31), 'USE_X_SENDFILE':
 False, 'SERVER_NAME': None, 'APPLICATION_ROOT': '/', 'SESSION_COOKIE_NAME': 'se
ssion', 'SESSION_COOKIE_DOMAIN': None, 'SESSION_COOKIE_PATH': None, 'SESSION_COO
KIE_HTTPONLY': True, 'SESSION_COOKIE_SECURE': False, 'SESSION_COOKIE_SAMESITE':
None, 'SESSION_REFRESH_EACH_REQUEST': True, 'MAX_CONTENT_LENGTH': None, 'SEND_FI
LE_MAX_AGE_DEFAULT': datetime.timedelta(seconds=43200), 'TRAP_BAD_REQUEST_ERRORS
': None, 'TRAP_HTTP_EXCEPTIONS': False, 'EXPLAIN_TEMPLATE_LOADING': False, 'PREF
ERRED_URL_SCHEME': 'http', 'JSON_AS_ASCII': True, 'JSON_SORT_KEYS': True, 'JSONI
FY_PRETTYPRINT_REGULAR': False, 'JSONIFY_MIMETYPE': 'application/json', 'TEMPLAT
ES_AUTO_RELOAD': None, 'MAX_COOKIE_SIZE': 4093}>,
 'view_functions': {'static': <bound method _PackageBoundObject.send_static_file
 of <Flask 'demo_app'>>},
 'error_handler_spec': {},
 'url_build_error_handlers': [],
 'before_request_funcs': {},
 'before_first_request_funcs': [],
 'after_request_funcs': {},
 'teardown_request_funcs': {},
 'teardown_appcontext_funcs': [],
 'url_value_preprocessors': {},
 'url_default_functions': {},
 'template_context_processors': {None: [<function flask.templating._default_temp
late_ctx_processor()>]},
 'shell_context_processors': [],
 'blueprints': {},
 '_blueprint_order': [],
 'extensions': {},
 'url_map': Map([<Rule '/static/<filename>' (HEAD, OPTIONS, GET) -> static>]),
 'subdomain_matching': False,
 '_got_first_request': False,
 '_before_request_lock': <unlocked _thread.lock object at 0x000000C940D4FB40>,
 'name': 'demo_app'}
```





### Blueprint蓝图 blueprints.py

类Flask和Blueprint 都继承自  _PackageBoundObject， Bluepring粒度更小，一个Flask实例内可以有多个蓝图。

```python
from .helpers import _PackageBoundObject

class Blueprint(_PackageBoundObject):
    """Represents a blueprint.  A blueprint is an object that records
    functions that will be called with the
    :class:`~flask.blueprints.BlueprintSetupState` later to register functions
    or other things on the main application.  See :ref:`blueprints` for more
    information.

    .. versionadded:: 0.7
    """

    warn_on_modifications = False
    _got_registered_once = False

    def __init__(self, name, import_name, static_folder=None,
                 static_url_path=None, template_folder=None,
                 url_prefix=None, subdomain=None, url_defaults=None,
                 root_path=None):
        _PackageBoundObject.__init__(self, import_name, template_folder,
                                     root_path=root_path)
        self.name = name
        self.url_prefix = url_prefix
        self.subdomain = subdomain
        self.static_folder = static_folder
        self.static_url_path = static_url_path
        self.deferred_functions = []
        if url_defaults is None:
            url_defaults = {}
        self.url_values_defaults = url_defaults
```



### 视图 views.py 

```python
from .globals import request
from ._compat import with_metaclass


http_method_funcs = frozenset(['get', 'post', 'head', 'options',
                               'delete', 'put', 'trace', 'patch'])


class View(object):
    methods = None    #支持的方法，如['GET']
    decorators = ()    #外部装饰器
    
    def dispatch_request(self):
		""" 子类需要重载这方法 """    
        
    @classmethod
    def as_view(cls, name, *class_args, **class_kwargs):
        """ 将类转化成视图函数。Internally this generates a function on the
        fly which will instantiate the :class:`View` on each request and call
        the :meth:`dispatch_request` method on it.

        The arguments passed to :meth:`as_view` are forwarded to the
        constructor of the class.
        """
        def view(*args, **kwargs):
            self = view.view_class(*class_args, **class_kwargs)
            return self.dispatch_request(*args, **kwargs)

        if cls.decorators:
            view.__name__ = name
            view.__module__ = cls.__module__
            for decorator in cls.decorators:
                view = decorator(view)

        # 类绑定为函数，一是便于定位CBV；二是便于测试和调试
        view.view_class = cls
        view.__name__ = name
        view.__doc__ = cls.__doc__
        view.__module__ = cls.__module__
        view.methods = cls.methods
        return view        
```





### 导出模块/全局变量

* `flask/__init__.py`:  导入了一堆对外使用的类、函数、变量
* flask/globals.py:  依赖于werkzeug的Local对象



`flask/__init__.py`    

```python
__version__ = '0.12.2'

# utilities we import from Werkzeug and Jinja2 that are unused
# in the module but are exported as public interface.
from werkzeug.exceptions import abort
from werkzeug.utils import redirect
from jinja2 import Markup, escape

from .app import Flask, Request, Response
from .config import Config
from .helpers import url_for, flash, send_file, send_from_directory, \
     get_flashed_messages, get_template_attribute, make_response, safe_join, \
     stream_with_context
from .globals import current_app, g, request, session, _request_ctx_stack, \
     _app_ctx_stack
from .ctx import has_request_context, has_app_context, \
     after_this_request, copy_current_request_context
from .blueprints import Blueprint
from .templating import render_template, render_template_string

# the signals
from .signals import signals_available, template_rendered, request_started, \
     request_finished, got_request_exception, request_tearing_down, \
     appcontext_tearing_down, appcontext_pushed, \
     appcontext_popped, message_flashed, before_render_template

# We're not exposing the actual json module but a convenient wrapper around
# it.
from . import json

# This was the only thing that Flask used to export at one point and it had
# a more generic name. 这个jsonify方法比较常用，将参数转化成JSON响应格式返回给浏览器
jsonify = json.jsonify

# backwards compat, goes away in 1.0
from .sessions import SecureCookieSession as Session
json_available = True
```



flask/globals.py

依赖于werkzeug的Local对象，详看下面werkzeug章节。

```python
from functools import partial
from werkzeug.local import LocalStack, LocalProxy

# context locals
# LocalStack: 请求上下文、应用上下文
_request_ctx_stack = LocalStack()
_app_ctx_stack = LocalStack()
# LocalProxy: 
current_app = LocalProxy(_find_app)
request = LocalProxy(partial(_lookup_req_object, 'request'))
session = LocalProxy(partial(_lookup_req_object, 'session'))
g = LocalProxy(partial(_lookup_app_object, 'g'))
```



### 配置文件

flask/config.py

```python
from werkzeug.utils import import_string

class Config(dict):
    def __init__(self, root_path, defaults=None):
        dict.__init__(self, defaults or {})
        self.root_path = root_path
        
    def from_envvar(self, variable_name, silent=False)：
    	""" """
        
    def from_pyfile(self, filename, silent=False)：
     	""" 从config.py加载数据 """
        filename = os.path.join(self.root_path, filename)
        d = types.ModuleType("config")
        d.__file__ = filename
        try:
            with open(filename, mode="rb") as config_file:
                exec(compile(config_file.read(), filename, "exec"), d.__dict__)
        except IOError as e:
            if silent and e.errno in (errno.ENOENT, errno.EISDIR, errno.ENOTDIR):
                return False
            e.strerror = "Unable to load configuration file (%s)" % e.strerror
            raise
        self.from_object(d)
        return True
    
    def from_object(self, obj):
    	""" 加载字符串或者对象，K/V形式保存到字典结构里 """
        if isinstance(obj, string_types):
            obj = import_string(obj)
        for key in dir(obj):
            if key.isupper():
                self[key] = getattr(obj, key)
                
    def from_json(self, filename, silent=False):        
    	""" """     
        
    def from_mapping(self, *mapping, **kwargs):
    	""" """      
        
    def get_namespace(self, namespace, lowercase=True, trim_namespace=True):        
    	""" """

    def __repr__(self):
        return "<%s %s>" % (self.__class__.__name__, dict.__repr__(self))        
```



flask/app.py   `flask.app:__init__`时加载app实例所在目录下的config.py

```python
# flask/app.py
from .config import Config
from .config import ConfigAttribute

class Flask(_PackageBoundObject):
    
    config_class = Config    
    def __init__(...):
        ...
		self.config = self.make_config(instance_relative_config)
        
    def make_config(self, instance_relative=False):
        """Used to create the config attribute by the Flask constructor.
        The `instance_relative` parameter is passed in from the constructor
        of Flask (there named `instance_relative_config`) and indicates if
        the config should be relative to the instance path or the root path
        of the application.

        .. versionadded:: 0.8
        """
        root_path = self.root_path
        if instance_relative:
            root_path = self.instance_path
        defaults = dict(self.default_config)
        defaults["ENV"] = get_env()
        defaults["DEBUG"] = get_debug_flag()
        return self.config_class(root_path, defaults)        
```



## flask命令

flask命令基于click库实现。

* `flask/__main__.py`： 命令行调用入口demo
* flask/cli.py:  命令行实现

**常用命令**：

* flask run:  运行开发服务器
* flask shell:  启动一个交互python shell
* flask db:  数据库迁移相关。不能直接使用，需要获取Migrate实例。

flask支持命令： v1.1.2只支持run/shell，v1.1.4增加了routes，fab是flask_appbuilder模块命令组，db是flask_migrate模块命令组。

```shell
$ flask --help
Usage: flask [OPTIONS] COMMAND [ARGS]...

  A general utility script for Flask applications.

  Provides commands from Flask, extensions, and the application. Loads the
  application defined in the FLASK_APP environment variable, or from a
  wsgi.py file. Setting the FLASK_ENV environment variable to 'development'
  will enable debug mode.

    $ export FLASK_APP=hello.py
    $ export FLASK_ENV=development
    $ flask run

Options:
  --version  Show the flask version
  --help     Show this message and exit.

Commands:
  db      Perform database migrations.
  fab     FAB flask group commands
  routes  Show the routes for the app.
  run     Run a development server.
  shell   Run a shell in the app context.
```



**环境变量**：

* FLASK_ENV： FLASK环境变量，development环境会启用交互式调试和自动重载。
* FLASK_DEBUG：FLASK调试标识 boolean，FLASK_ENV=='development'
* FLASK_APP： FLASK APP实例路径



**app模块导入的搜索顺序** (flask.cli:ScriptInfo::load_app)

1. 有create_app，用create_app/~~make_app~~函数返回的实例
2. 有设置环境变量FLASK_APP，导入路径为FLASK_APP(flask.cli:find_default_import_path)；没有设置，导入路径为传参路径。
3. 有导入路径 locate_app()
   - ~~如果未设置FLASK_APP，flask命令会查找`wsgi.py`或`app.py`文件并探测应用实例或工厂函数。~~
   - (flask.cli:find_best_app)flask命令在给定的module导入内寻找一个名为`app`或者`application`的应用实例 或者 `module.__dict__`查找类型为Flask实例的值。



**脚本入口定义**(setup.py)： 配置`entry_points -> flask.commands`



 flask命令真正调用处

```python
# `flask/__main__.py`
if __name__ == '__main__':
    from .cli import main
    main(as_module=True)
```



flask/cli.py 

```python
import click

cli = FlaskGroup(help="""  """)

def main(as_module=False):
    this_module = __package__ + '.cli'
    args = sys.argv[1:]

    if as_module:
        if sys.version_info >= (2, 7):
            name = 'python -m ' + this_module.rsplit('.', 1)[0]
        else:
            name = 'python -m ' + this_module

        # This module is always executed as "python -m flask.run" and as such
        # we need to ensure that we restore the actual command line so that
        # the reloader can properly operate.
        sys.argv = ['-m', this_module] + sys.argv[1:]
    else:
        name = None

    cli.main(args=args, prog_name=name)
    
    
class AppGroup(click.Group):
    """ 继承click.Group """
    
class FlaskGroup(AppGroup): 
    def __init__(self, add_default_commands=True, create_app=None,
                 add_version_option=True, **extra):
        """
        :param add_default_commands True时添加run/shell命令
        :param create_app app创建方法
        :param add_version_option True时添加版本命令
        """
        params = list(extra.pop('params', None) or ())

        if add_version_option:	#缺省添加版本命令 
            params.append(version_option)

        AppGroup.__init__(self, params=params, **extra)
        self.create_app = create_app  #app初始化方法

        if add_default_commands: #缺省添加命令 run/shell
            self.add_command(run_command)
            self.add_command(shell_command)

        self._loaded_plugin_commands = False
        
    def main(self, *args, **kwargs):
        obj = kwargs.get('obj')
        if obj is None:
            obj = ScriptInfo(create_app=self.create_app)
        kwargs['obj'] = obj
        kwargs.setdefault('auto_envvar_prefix', 'FLASK')
        return AppGroup.main(self, *args, **kwargs)
    
    
class ScriptInfo(object):
    """ 脚本帮助，如查找模块路径 """
    def __init__(self, app_import_path=None, create_app=None):
        """
        :param app_import_path app导入路径，优先查找
        :param create_app 可选方法加载app
        """
        if create_app is None:
            if app_import_path is None:  #查找缺省导入路径 FLASK_APP
                app_import_path = find_default_import_path()
            self.app_import_path = app_import_path
        else:
            app_import_path = None

        #: Optionally the import path for the Flask application.
        self.app_import_path = app_import_path
        #: Optionally a function that is passed the script info to create
        #: the instance of the application.
        self.create_app = create_app
        #: A dictionary with arbitrary data that can be associated with
        #: this script info.
        self.data = {}
        self._loaded_app = None   #用来保存已经导入的APP
        
    def load_app(self):
        """Loads the Flask app (if not yet loaded) and returns it.  Calling
        this multiple times will just result in the already loaded app to
        be returned.
        """
        __traceback_hide__ = True
        if self._loaded_app is not None: #已导入，直接返回
            return self._loaded_app
        if self.create_app is not None:  #通过create_app方法导入app
            rv = self.create_app(self)
        else:
            if not self.app_import_path:  #找不到app导入路径时，抛出异常
                raise NoAppException(
                    'Could not locate Flask application. You did not provide '
                    'the FLASK_APP environment variable.\n\nFor more '
                    'information see '
                    'http://flask.pocoo.org/docs/latest/quickstart/')
            rv = locate_app(self.app_import_path)
        debug = get_debug_flag()
        if debug is not None:
            rv.debug = debug
        self._loaded_app = rv
        return rv     

    
def locate_app(app_id):
    """Attempts to locate the application. app导入的搜索路径顺序：
    1.支持aa.bb:cc，import aa.bb; 
    2.find_best_app：查找变量名app/application, module.__dict__是否有值类型是Flask
    """
    __traceback_hide__ = True
    if ':' in app_id:
        module, app_obj = app_id.split(':', 1)
    else:
        module = app_id
        app_obj = None

    try:
        __import__(module)
    except ImportError:
        # Reraise the ImportError if it occurred within the imported module.
        # Determine this by checking whether the trace has a depth > 1.
        if sys.exc_info()[-1].tb_next:
            raise
        else:
            raise NoAppException('The file/path provided (%s) does not appear'
                                 ' to exist.  Please verify the path is '
                                 'correct.  If app is not on PYTHONPATH, '
                                 'ensure the extension is .py' % module)

    mod = sys.modules[module]
    if app_obj is None:
        # 查找Flask实例：通过变量名app/application，遍历module.__dict__的v值
        app = find_best_app(mod)
    else:
        app = getattr(mod, app_obj, None)
        if app is None:
            raise RuntimeError('Failed to find application in module "%s"'
                               % module)

    return app


def find_best_app(module):
    """ 查找模块里app的搜索路径 """
    from . import Flask

    # Search for the most common names first. 查找 app/application 变量名
    for attr_name in 'app', 'application':
        app = getattr(module, attr_name, None)
        if app is not None and isinstance(app, Flask):
            return app

    # Otherwise find the only object that is a Flask instance.
    matches = [v for k, v in iteritems(module.__dict__)
               if isinstance(v, Flask)]

    if len(matches) == 1:
        return matches[0]
    raise NoAppException('Failed to find application in module "%s".  Are '
                         'you sure it contains a Flask application?  Maybe '
                         'you wrapped it in a WSGI middleware or you are '
                         'using a factory function.' % module.__name__)    
```



### flask run命令

flask/cli.py

```python
import click

pass_script_info = click.make_pass_decorator(ScriptInfo, ensure=True)

# click.command作为一个命令，click.option可选项
@click.command('run', short_help='Runs a development server.')
@click.option('--host', '-h', default='127.0.0.1',
              help='The interface to bind to.')
@click.option('--port', '-p', default=5000,
              help='The port to bind to.')
@click.option('--reload/--no-reload', default=None,
              help='Enable or disable the reloader.  By default the reloader '
              'is active if debug is enabled.')
@click.option('--debugger/--no-debugger', default=None,
              help='Enable or disable the debugger.  By default the debugger '
              'is active if debug is enabled.')
@click.option('--eager-loading/--lazy-loader', default=None,
              help='Enable or disable eager loading.  By default eager '
              'loading is enabled if the reloader is disabled.')
@click.option('--with-threads/--without-threads', default=False,
              help='Enable or disable multithreading.')
@pass_script_info
def run_command(info, host, port, reload, debugger, eager_loading,
                with_threads):
    """Runs a local development server for the Flask application.
	flask应用程序启动一个开发服务器，只推荐开发时使用
    This local server is recommended for development purposes only but it
    can also be used for simple intranet deployments.  By default it will
    not support any sort of concurrency at all to simplify debugging.  This
    can be changed with the --with-threads option which will enable basic
    multithreading.
    """
    from werkzeug.serving import run_simple

    debug = get_debug_flag()
    if reload is None:
        reload = bool(debug)
    if debugger is None:
        debugger = bool(debug)
    if eager_loading is None:
        eager_loading = not reload

    app = DispatchingApp(info.load_app, use_eager_loading=eager_loading)

    # Extra startup messages.  This depends a bit on Werkzeug internals to
    # not double execute when the reloader kicks in.
    if os.environ.get('WERKZEUG_RUN_MAIN') != 'true':
        # 打印 APP导入路径 和 调试开关信息
        if info.app_import_path is not None:
            print(' * Serving Flask app "%s"' % info.app_import_path)
        if debug is not None:
            print(' * Forcing debug mode %s' % (debug and 'on' or 'off'))

    run_simple(host, port, app, use_reloader=reload,
               use_debugger=debugger, threaded=with_threads)
```



### flask shell命令

```python

@click.command("shell", short_help="Run a shell in the app context.")
@with_appcontext
def shell_command():
    """Run an interactive Python shell in the context of a given
    Flask application.  The application will populate the default
    namespace of this shell according to it's configuration.

    This is useful for executing small snippets of management code
    without having to manually configure the application.
    """
    import code
    from .globals import _app_ctx_stack

    app = _app_ctx_stack.top.app
    banner = "Python %s on %s\nApp: %s [%s]\nInstance: %s" % (
        sys.version,
        sys.platform,
        app.import_name,
        app.env,
        app.instance_path,
    )
    ctx = {}

    # Support the regular Python interpreter startup script if someone
    # is using it.
    startup = os.environ.get("PYTHONSTARTUP")
    if startup and os.path.isfile(startup):
        with open(startup, "r") as f:
            eval(compile(f.read(), startup, "exec"), ctx)

    ctx.update(app.make_shell_context())

    code.interact(banner=banner, local=ctx)
```



## 扩展 exthook.py

flask/exthook.py

```python
class ExtensionImporter(object):
    """This importer redirects imports from this submodule to other locations.
    This makes it possible to transition from the old flaskext.name to the
    newer flask_name without people having a hard time.
    """
    
    def install(self):
        sys.meta_path[:] = [x for x in sys.meta_path if self != x] + [self]

    def find_module(self, fullname, path=None):
        if fullname.startswith(self.prefix) and \
           fullname != 'flask.ext.ExtDeprecationWarning':
            return self

    def load_module(self, fullname):
        if fullname in sys.modules:
            return sys.modules[fullname]    
```



## 依赖模块

### werkzeug

The comprehensive WSGI web application library. 综合的WSGI WEB应用程序库。

```shell
$ pip show werkzeug
Name: Werkzeug
Version: 0.16.1
Summary: The comprehensive WSGI web application library.
Home-page: https://palletsprojects.com/p/werkzeug/
Author: Armin Ronacher
Author-email: armin.ronacher@active-4.com
License: BSD-3-Clause
Location: e:\dev\python\bin\python37\lib\site-packages
Requires:
Required-by: tensorboard, Flask
```

* werkzeug/serving.py： 请求处理方式
* werkzeug/local.py： 本地代理/数据栈



#### 请求处理方式 serving.py

**说明**：Flask::run (flask/app.py) 调用了 serving.py里的run_simple函数， 最终make_server() 调用了HTTPServer.serve_forever (lib/socketserver.py)

**处理链**： run_simple ->  inner -> make_server 

**每请求的处理方式**： make_server (根据入参threaded/processes 来启动相应的WSGI服务器)

* 线程：threaded为True， 调用ThreadedWSGIServer，启动一个后台线程来处理请求
* 进程：processes>1，调用ForkingWSGIServer，启动一个fork进程来处理请求
* 总共1进程1线程：调用BaseWSGIServer，监听队列长度120，加入监听队列，等待poll或epoll监听



```python
try:
    import socketserver
    from http.server import BaseHTTPRequestHandler
    from http.server import HTTPServer
except ImportError:
    import SocketServer as socketserver
    from BaseHTTPServer import HTTPServer
    from BaseHTTPServer import BaseHTTPRequestHandler
    
LISTEN_QUEUE = 128  # socket监听队列长度
can_open_by_fd = not WIN and hasattr(socket, "fromfd")

def run_simple(
    hostname,
    port, 
    reloader_interval=1,
    reloader_type="auto",
    threaded=False,
    processes=1,
    request_handler=None,
    static_files=None,
    passthrough_errors=False,
    ssl_context=None,
):
    def inner():  
        # 实际的启动函数 
        try:
            fd = int(os.environ["WERKZEUG_SERVER_FD"])
        except (LookupError, ValueError):
            fd = None
        srv = make_server( hostname,port,application,threaded,processes,request_handler,
                          passthrough_errors,ssl_context,fd=fd,)
        if fd is None:
            log_startup(srv.socket)
        srv.serve_forever()        
        
    if use_reloader:
 		#使用重载，要保证端口可用，用socket建立socke联接
        if not is_running_from_reloader():
            if port == 0 and not can_open_by_fd:
                raise ValueError(
                    "Cannot bind to a random port with enabled "
                    "reloader if the Python interpreter does "
                    "not support socket opening by fd."
                )

            address_family = select_address_family(hostname, port)
            server_address = get_sockaddr(hostname, port, address_family)
            s = socket.socket(address_family, socket.SOCK_STREAM)
            s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            s.bind(server_address)
            if hasattr(s, "set_inheritable"):
                s.set_inheritable(True)

            # If we can open the socket by file descriptor, then we can just
            # reuse this one and our socket will survive the restarts.
            if can_open_by_fd:
                os.environ["WERKZEUG_SERVER_FD"] = str(s.fileno())
                s.listen(LISTEN_QUEUE) #开始监听
                log_startup(s)
            else:
                s.close()
                if address_family == af_unix:
                    _log("info", "Unlinking %s" % server_address)
                    os.unlink(server_address)

        # Do not use relative imports, otherwise "python -m werkzeug.serving"
        # breaks. 要使用本地导入
        from ._reloader import run_with_reloader
		# 信号终止旧线程，启动一个后台线程执行 inner函数
        run_with_reloader(inner, extra_files, reloader_interval, reloader_type)
    else:
        inner()    
        
def make_server(
    host=None,
    port=None,
    app=None,
    threaded=False,	# 是否每个请求对应一个独立线程
    processes=1,    # 如果大于1，那么每个请求对应一个进程，并发数受限于并发进程数
    request_handler=None,
    passthrough_errors=False,
    ssl_context=None,
    fd=None,
):
    """Create a new server instance that is either threaded, or forks
    or just processes one request after another.
    """
    if threaded and processes > 1:
        raise ValueError("cannot have a multithreaded and multi process server.")
    elif threaded:  
        # 单线程每请求，启动WSGI（修改属性multithread和daemon_threads为True）
        return ThreadedWSGIServer(
            host, port, app, request_handler, passthrough_errors, ssl_context, fd=fd
        )
    elif processes > 1: 
        # 单进程每请求，启动WSGI（multiprocess=True, self.max_children = processes）
        return ForkingWSGIServer(
            host,
            port,
            app,
            processes,
            request_handler,
            passthrough_errors,
            ssl_context,
            fd=fd,
        )
    else:
        return BaseWSGIServer(
            host, port, app, request_handler, passthrough_errors, ssl_context, fd=fd
        )
```



三种WSGI服务:  

* BaseWSGIServer:  最终调用原生模块  lib/socketserver.py:BaseServer

```
import socketserver

ThreadingMixIn = socketserver.ThreadingMixIn  
can_fork = hasattr(os, "fork")  # 判断是否支持fork
if can_fork:  
    ForkingMixIn = socketserver.ForkingMixIn
else:
    class ForkingMixIn(object):
        pass
    
class ThreadedWSGIServer(ThreadingMixIn, BaseWSGIServer):
    """A WSGI server that does threading. 调用ThreadingMixIn.process_request() """

    multithread = True
    daemon_threads = True
    
class ForkingWSGIServer(ForkingMixIn, BaseWSGIServer):

    """A WSGI server that does forking. 调用ForkMixIn.process_request() """

    multiprocess = True

    def __init__(
        self,
        host,
        port,
        app,
        processes=40,  #进程总数
        handler=None,
        passthrough_errors=False,
        ssl_context=None,
        fd=None,
    ):
        if not can_fork:
            raise ValueError("Your platform does not support forking.")
        BaseWSGIServer.__init__(
            self, host, port, app, handler, passthrough_errors, ssl_context, fd
        )
        self.max_children = processes
    

class BaseWSGIServer(HTTPServer, object):

    """Simple single-threaded, single-process WSGI server."""

    multithread = False
    multiprocess = False
    request_queue_size = LISTEN_QUEUE # HTTPServer默认的请求队列长度是5

   def __init__(
        self,
        host,
        port,
        app,
        handler=None,
        passthrough_errors=False,
        ssl_context=None,
        fd=None,
    ):
        if handler is None:
            handler = WSGIRequestHandler

        self.address_family = select_address_family(host, port)

        if fd is not None:
            real_sock = socket.fromfd(fd, self.address_family, socket.SOCK_STREAM)
            port = 0

        server_address = get_sockaddr(host, int(port), self.address_family)

        # remove socket file if it already exists
        if self.address_family == af_unix and os.path.exists(server_address):
            os.unlink(server_address)
        HTTPServer.__init__(self, server_address, handler)

        self.app = app
        self.passthrough_errors = passthrough_errors
        self.shutdown_signal = False
        self.host = host
        self.port = self.socket.getsockname()[1]

        # Patch in the original socket.
        if fd is not None:
            self.socket.close()
            self.socket = real_sock
            self.server_address = self.socket.getsockname()

        if ssl_context is not None:
            if isinstance(ssl_context, tuple):
                ssl_context = load_ssl_context(*ssl_context)
            if ssl_context == "adhoc":
                ssl_context = generate_adhoc_ssl_context()
            # If we are on Python 2 the return value from socket.fromfd
            # is an internal socket object but what we need for ssl wrap
            # is the wrapper around it :(
            sock = self.socket
            if PY2 and not isinstance(sock, socket.socket):
                sock = socket.socket(sock.family, sock.type, sock.proto, sock)
            self.socket = ssl_context.wrap_socket(sock, server_side=True)
            self.ssl_context = ssl_context
        else:
            self.ssl_context = None
            
    def serve_forever(self):
        self.shutdown_signal = False
        try:
            HTTPServer.serve_forever(self) #select监听数据
        except KeyboardInterrupt:
            pass
        finally:
            self.server_close()     
```

​       

**BaseServer.serve_forever** (lib/socketserver.py):  poll或select方式监听

```python
# lib/socketserver.py

# 这里定义选择器：poll或者select
if hasattr(selectors, 'PollSelector'):
    _ServerSelector = selectors.PollSelector
else:
    _ServerSelector = selectors.SelectSelector
    
class BaseServer:
    def serve_forever(self, poll_interval=0.5):
        """Handle one request at a time until shutdown.

        Polls for shutdown every poll_interval seconds. Ignores
        self.timeout. If you need to do periodic tasks, do them in
        another thread.
        """
        self.__is_shut_down.clear()
        try:
            # 根据_ServerSelector()选择相应的poll或select注册事件，poll性能会更差些
            with _ServerSelector() as selector:
                selector.register(self, selectors.EVENT_READ)

                while not self.__shutdown_request:
                    ready = selector.select(poll_interval)  # 定时监听
                    # bpo-35017: shutdown() called during select(), exit immediately.
                    if self.__shutdown_request:
                        break
                    if ready:
                        self._handle_request_noblock()

                    self.service_actions()
        finally:
            self.__shutdown_request = False
            self.__is_shut_down.set()

```



#### 本地代理/数据栈 local.py 

背景：使用thread local对象（`from threading import local`）虽然可以基于线程存储全局变量，但是在Web应用中可能会存在如下问题：

1. 协程中不能保证数据隔离，因为一个线程里可能有多个协程。
2. 线程会连续处理请求，上一次处理的数据并不能保证清空。

因此，Werkzeug开发了自己的local对象。

* Local对象：结构类似dict，用dict的常用方法。
* LocalStack：是先进先出队列，封装操作: pop/push/top。
* LocalProxy:  用于代理Local对象和LocalStack对象，而所谓代理就是作为中间的代理人来处理所有针对被代理对象的操作。
* LocalManager：管理Local对象。



**上下文需要放在栈中的原因**
　　1. 应用上下文 _app_ctx_stack
　　flask底层是基于werkzeug，werkzeug是可以包含多个app的，所以这个时候用一个栈来保存，如果要使用app1，则app1需在栈的顶部，如果用完了app1，则app1应该从栈中删除，方便其他代码使用下面的app。

　2. 请求上下文  _request_ctx_stack
　　如果在写测试代码或者离线脚本的时候，有时候可能需要穿件多个请求上下文，这个时候就需要存放到另一个栈中，使用哪个请求上下文的时候，就把对应的请求上下文放到栈的顶部，用完了就要把这个请求上下文从栈中移除掉。



```python
_identity = lambda x: x
implements_bool = _identity

try: # 有协程时，get_ident获取协程ID，保证了协程的全局唯一
    from greenlet import getcurrent as get_ident
except ImportError:
    try: # 没有协程时，get_ident获取线程ID
        from thread import get_ident
    except ImportError:
        from _thread import get_ident

           
class Local(object):
    __slots__ = ("__storage__", "__ident_func__")

    def __init__(self):
        # 初始化__storage__为空字典，__ident_func__调用get_ident
        object.__setattr__(self, "__storage__", {})
        object.__setattr__(self, "__ident_func__", get_ident)

        
class LocalStack(object):
    """ 相当于一个本地数据先进先出stack, 使用Local()存储数据, 方法有push/pop/top """
    def __init__(self):
        self._local = Local()   
        
    def push(self, obj):        
        """Pushes a new item to the stack"""
        rv = getattr(self._local, "stack", None)
        if rv is None:
            self._local.stack = rv = []
        rv.append(obj)
        return rv

    def pop(self):
        """Removes the topmost item from the stack, will return the
        old value or `None` if the stack was already empty.
        """
                
        
class LocalManager(object):
    def __init__(self, locals=None, ident_func=None):
        if locals is None:
            self.locals = []
        elif isinstance(locals, Local):
            self.locals = [locals]
        else:
            self.locals = list(locals)
        if ident_func is not None:
            self.ident_func = ident_func
            for local in self.locals:
                object.__setattr__(local, "__ident_func__", ident_func)
        else:
            self.ident_func = get_ident    
    
@implements_bool
class LocalProxy(object):
    __slots__ = ("__local", "__dict__", "__name__", "__wrapped__")

    def __init__(self, local, name=None):
        object.__setattr__(self, "_LocalProxy__local", local)
        object.__setattr__(self, "__name__", name)
        if callable(local) and not hasattr(local, "__release_local__"):
            # "local" is a callable that is not an instance of Local or
            # LocalManager: mark it as a wrapped function.
            object.__setattr__(self, "__wrapped__", local)
 
```



### click 

可组合命令行接口工具包。命令组 Group - >  命令Command

```shell
$ pip show click
Name: click
Version: 7.1.2
Summary: Composable command line interface toolkit
Home-page: https://palletsprojects.com/p/click/
Author: None
Author-email: None
License: BSD-3-Clause
Location: e:\dev\python\venv\superset-py37-env\lib\site-packages
Requires:
Required-by: Flask, Flask-AppBuilder, apache-superset
```

源文件

* click/core.py: 实现核心，定义了Group及其父类，Argument, Option
* click/decorator.py 常用装饰器。如group, command, argument, option



click/core.py 

```python
class BaseCommand(object):
    """ """
    
class Command(BaseCommand):
    """ """
    
class MultiCommand(Command):
    """ 多个命令类 继承单个命令 """
    
class Group(MultiCommand):
    """命令组可以跟命令绑定
    :param commands: a dictionary of commands.
    类方法：command group add_command  get_command list_command
    """
   def group(self, *args, **kwargs):
        """快速绑定命令组到另一个命令组的装饰器.
        """
        from .decorators import group

        def decorator(f):
            cmd = group(*args, **kwargs)(f)
            self.add_command(cmd)
            return cmd

        return decorator
    
    def command(self, *args, **kwargs):
        """A shortcut decorator for declaring and attaching a command to
        the group.  This takes the same arguments as :func:`command` but
        immediately registers the created command with this instance by
        calling into :meth:`add_command`.
        用来作为快速创建命令的装饰器，实质调用 add_command方法
        """
        from .decorators import command

        def decorator(f):
            cmd = command(*args, **kwargs)(f)
            self.add_command(cmd)
            return cmd

        return decorator    
```



click/decorator.py 

命令处理常用装饰器，包括group, command, argument, option, make_pass_decorator

```python
from functools import update_wrapper

from ._compat import iteritems
from ._unicodefun import _check_for_unicode_literals
from .core import Argument
from .core import Command
from .core import Group
from .core import Option

def group(name=None, **attrs):
    """Creates a new :class:`Group` with a function as callback.  This
    works otherwise the same as :func:`command` just that the `cls`
    parameter is set to :class:`Group`.
    """
    attrs.setdefault("cls", Group)
    return command(name, **attrs)

def command(name=None, cls=None, **attrs):
    if cls is None:
        cls = Command

    def decorator(f):
        cmd = _make_command(f, name, attrs, cls)
        cmd.__doc__ = f.__doc__
        return cmd

    return decorator

# 必选参数
def argument(*param_decls, **attrs):
    """Attaches an argument to the command.  All positional arguments are
    passed as parameter declarations to :class:`Argument`; all keyword
    arguments are forwarded unchanged (except ``cls``).
    This is equivalent to creating an :class:`Argument` instance manually
    and attaching it to the :attr:`Command.params` list.

    :param cls: the argument class to instantiate.  This defaults to
                :class:`Argument`.
    """

    def decorator(f):
        ArgumentClass = attrs.pop("cls", Argument)
        _param_memo(f, ArgumentClass(param_decls, **attrs))
        return f

    return decorator

# 可选参数
def option(*param_decls, **attrs):
    """Attaches an option to the command.  All positional arguments are
    passed as parameter declarations to :class:`Option`; all keyword
    arguments are forwarded unchanged (except ``cls``).
    This is equivalent to creating an :class:`Option` instance manually
    and attaching it to the :attr:`Command.params` list.

    :param cls: the option class to instantiate.  This defaults to
                :class:`Option`.
    """

    def decorator(f):
        # Issue 926, copy attrs, so pre-defined options can re-use the same cls=
        option_attrs = attrs.copy()

        if "help" in option_attrs:
            option_attrs["help"] = inspect.cleandoc(option_attrs["help"])
        OptionClass = option_attrs.pop("cls", Option)
        _param_memo(f, OptionClass(param_decls, **option_attrs))
        return f

    return decorator
```



click高效的装饰器： 以 flask fab命令组为例

* @xx.group()   将当前方法名作为一个xx命令组的子命令组，如xx为click，那么fab的上级命令组是app实例

  ```python
  import click
  
  # 示例： flask fab命令组定义
  @click.group()
  def fab():
      """ FAB flask group commands"""
      pass
  ```

* @xx.command()， 将当前方法名作为xx命令组里的最终命令，如`flask fab create-admin`

  ```python
  @fab.command("create-admin")
  @click.option("--username", default="admin", prompt="Username")
  @click.option("--firstname", default="admin", prompt="User first name")
  @click.option("--lastname", default="user", prompt="User last name")
  @click.option("--email", default="admin@fab.org", prompt="Email")
  @click.password_option()
  @with_appcontext
  def create_admin(username, firstname, lastname, email, password):
      """
          Creates an admin user
      """
  ```



### jinja2

参考 《WEB前端框架》相关章节



```shell
$ pip show jinja2
Name: Jinja2
Version: 3.0.1
Summary: A very fast and expressive template engine.
Home-page: https://palletsprojects.com/p/jinja/
Author: Armin Ronacher
Author-email: armin.ronacher@active-4.com
License: BSD-3-Clause
Location: d:\dev\langs\python\python37\lib\site-packages
Requires: MarkupSafe
Required-by:
```

表格 Jinja2源码结构 

| 文件            | 主要类或函数                                                 | 简介       |
| --------------- | ------------------------------------------------------------ | ---------- |
| asyncfilters.py |                                                              | 异步过滤器 |
| asyncsupport.py |                                                              | 异步支持   |
| bccache.py      |                                                              |            |
| compiler.py     |                                                              |            |
| constants.py    |                                                              | 常量       |
| environment.py  | Environment Template TemplateExpression TemplateModule TemplateStream | 环境变量   |
| filters.py      |                                                              | 过滤器     |
| lexer.py        |                                                              |            |
| loaders.py      |                                                              | 加载器     |
| meta.py         |                                                              | 元数据     |
| nativetypes.py  |                                                              | 原生类型   |
| nodes.py        |                                                              |            |
| optimizer.py    |                                                              | 优化       |
| parser.py       |                                                              | 解析器     |
| runtime.y       |                                                              |            |
| sandbox.py      |                                                              | 沙盒       |
| utils.py        |                                                              | 工具       |
| visitor.py      |                                                              |            |



/jinja2/environment.py

```python
class Template(object):
    environment_class = Environment

    def __new__(,,,)
    def render(self, *args, **kwargs):
        """ 模板渲染实现 """
        vars = dict(*args, **kwargs)
        try:
            return concat(self.root_render_func(self.new_context(vars)))
        except Exception:
            self.environment.handle_exception()

    def render_async(self, *args, **kwargs):
        
        
class Environment(object):
    
	@internalcode
    def get_or_select_template(self, template_name_or_list, parent=None, globals=None):
        """Does a typecheck and dispatches to :meth:`select_template`
        if an iterable of template names is given, otherwise to
        :meth:`get_template`.
		模板继承实现
        .. versionadded:: 2.3
        """
        if isinstance(template_name_or_list, (string_types, Undefined)):
            return self.get_template(template_name_or_list, parent, globals)
        elif isinstance(template_name_or_list, Template):  # Template类型，直接返回数据
            return template_name_or_list
        # 选择父类模板
        return self.select_template(template_name_or_list, parent, globals)
    

class TemplateExpression(object):
    """The :meth:`jinja2.Environment.compile_expression` method returns an
    instance of this object.  It encapsulates the expression-like access
    to the template with an expression it wraps.
    """

    def __init__(self, template, undefined_to_none):
        self._template = template
        self._undefined_to_none = undefined_to_none

    def __call__(self, *args, **kwargs):
        context = self._template.new_context(dict(*args, **kwargs))
        consume(self._template.root_render_func(context))
        rv = context.vars["result"]
        if self._undefined_to_none and isinstance(rv, Undefined):
            rv = None
        return rv


@implements_to_string
class TemplateModule(object):
    
@implements_iterator
class TemplateStream(object):
    ...
```




## 扩展模块

### flask_appbuilder

Flask-AppBuilder是基于Flask实现的一个用于快速构建Web后台管理系统的简单的框架。主要用于解决构建Web后台管理系统时避免一些重复而繁琐的工作，提高项目完成时间，它可以和 Flask/Jinja2自定义的页面进行无缝集成，并且可以进行高级的配置。这个框架还集成了一些CSS和JS库，包括以下内容：

*  Google charts CSS and JS
*  BootStrap CSS and JS
*  BootsWatch Themes
*  Font-Awesome CSS and FontsFlask-AppBuilder是基于Flask实现的一个用于快速构建Web后台管理系统的简单的框架。主要用于解决构建Web后台管理系统时避免一些重复而繁琐的工作，提高项目完成时间，它可以和 Flask/Jinja2自定义的页面进行无缝集成，并且可以进行高级的配置。这个框架还集成了一些CSS和JS库，包括以下内容：
   *  Google charts CSS and JS
   *  BootStrap CSS and JS
   *  BootsWatch Themes
   *  Font-Awesome CSS and Fonts



```shell
$ pip show Flask-AppBuilder
Name: Flask-AppBuilder
Version: 3.1.1
Summary: Simple and rapid application development framework, built on top of Flask. includes detailed security, auto CRUD generation for your models, google charts and much more.
Home-page: https://github.com/dpgaspar/flask-appbuilder/
Author: Daniel Vaz Gaspar
Author-email: danielvazgaspar@gmail.com
License: BSD
Location: /home/keefe/venv/superset-py36-env/lib/python3.6/site-packages
Requires: email-validator, click, marshmallow, marshmallow-enum, PyJWT, Flask-SQLAlchemy, Flask-JWT-Extended, Flask-Login, Flask, apispec, python-dateutil, marshmallow-sqlalchemy, jsonschema, Flask-Babel, Flask-WTF, sqlalchemy-utils, prison, colorama, Flask-OpenID
Required-by: 
```

Flask-AppBuilder功能强大，同时需要依赖很多flask扩展，如`Flask-SQLAlchemy, Flask-JWT-Extended, Flask-Login, Flask, Flask-Babel, Flask-WTF, Flask-OpenID`



#### 源码结构

表格 flask_appbuilder源码结构

| 目录或文件     | 主要类或函数                                                 | 说明                    |
| -------------- | ------------------------------------------------------------ | ----------------------- |
| api            | 文件：convert.py manager.py schemas.py<br>类：BaseApi BaseModelApi ModelRestApi OpenApi OpenApiManager SwaggerView  BaseModelSchema<br>装饰器：rison safe |                         |
| babel          | BabelManager LocaleView                                      | 依赖于flask_babel       |
| charts         | dict_to_json views.py widgets.py                             | 图表                    |
| models         | generic/ mongoengine/ sqla/  filters.py groups.py mixins.py base.py | 模型                    |
| security       | mongoengine/ sqla/  api.py decorators.py forms.py manager.py registerviews.py views.py | 安全                    |
| static         | 目录：css datapicker fonts img js select2                    | 静态文件                |
| templates      | appbuilder/                                                  | Jinja2模板              |
| tests          |                                                              | 测试                    |
| translations   |                                                              | 翻译                    |
| utils          | get_column_root_relation  get_column_leaf  is_column_dotted lazy_formatter_gettext | 工具                    |
| `__init__.py`  | BaseApi BaseModelApi ModelRestApi                            |                         |
| actions.py     | action ActionItem                                            |                         |
| base.py        | AppBuilder dynamic_class_import                              | app构建类（主类）       |
| basemanager.py | BaseManager                                                  | 所有管理类的父类        |
| baseviews.py   | expose expose_api  <br>BaseView BaseFormView BaseModelView BaseCRUDView | 视图基类                |
| cli.py         | fab create_admin create_user...                              | 命令行，依赖click模块   |
| console.py     | cli_app                                                      |                         |
| const.py       |                                                              | 常量                    |
| fields.py      | AJAXSelectField QuerySelectField QuerySelectMultipleField EnumField | 值域，依赖于wtforms模块 |
| filters.py     | app_template_filter TemplateFilters                          |                         |
| forms.py       | FieldConverter GeneralModelConverter DynamicForm             | 依赖于flask_wtf         |
| hooks.py       | before_request wrap_route_handler_with_hooks get_before_request_hooks | 勾子方法                |
| menu.py        | MenuItem Menu MenuApi MenuApiManager                         | 菜单管理                |
| views.py       | IndexView UtilView SimpleFormView PublicFormView...          | 各种视图                |
| widgets.py     | RenderTemplateWidget FormWidget FormVerticalWidget...        | 依赖于Flask-WTF         |



#### fab命令 cli.py

依赖模块click

fab命令：

```shell
$ flask fab --help
Usage: flask fab [OPTIONS] COMMAND [ARGS]...

  FAB flask group commands

Options:
  --help  Show this message and exit.

Commands:
  babel-compile       Babel, Compiles all translations
  babel-extract       Babel, Extracts and updates all messages marked for...
  collect-static      Copies flask-appbuilder static files to your projects...
  create-addon        Create a Skeleton AddOn (needs internet connection to...
  create-admin        Creates an admin user
  create-app          Create a Skeleton application (needs internet...
  create-db           Create all your database objects (SQLAlchemy...
  create-permissions  Creates all permissions and add them to the ADMIN...
  create-user         Create a user
  list-users          List all users on the database
  list-views          List all registered views
  reset-password      Resets a user's password
  security-cleanup    Cleanup unused permissions from views and roles.
  security-converge   Converges security deletes...
  version             Flask-AppBuilder package version
      1 [sig] bash 10116! get_proc_lock: Couldn't acquire sync_proc_subproc for(5,1), last 7, Win32 error 0
   2249 [sig] bash 10116! proc_subproc: couldn't get proc lock. what 5, val 1
```



**命令示例 create-admin**

```python
import click
from flask import current_app
from flask.cli import with_appcontext

@click.group()
def fab():
    """ FAB flask group commands"""
    pass


@fab.command("create-admin")
@click.option("--username", default="admin", prompt="Username")
@click.option("--firstname", default="admin", prompt="User first name")
@click.option("--lastname", default="user", prompt="User last name")
@click.option("--email", default="admin@fab.org", prompt="Email")
@click.password_option()
@with_appcontext
def create_admin(username, firstname, lastname, email, password):
    """
        Creates an admin user
    """
    auth_type = {
        AUTH_DB: "Database Authentications",
        AUTH_OID: "OpenID Authentication",
        AUTH_LDAP: "LDAP Authentication",
        AUTH_REMOTE_USER: "WebServer REMOTE_USER Authentication",
        AUTH_OAUTH: "OAuth Authentication",
    }
    click.echo(
        click.style(
            "Recognized {0}.".format(
                auth_type.get(current_app.appbuilder.sm.auth_type, "No Auth method")
            ),
            fg="green",
        )
    )
    # username排重
    user = current_app.appbuilder.sm.find_user(username=username)
    if user:
        click.echo(click.style(f"Error! User already exists {username}", fg="red"))
        return
    # email排重
    user = current_app.appbuilder.sm.find_user(email=email)
    if user:
        click.echo(click.style(f"Error! User already exists {username}", fg="red"))
        return
    role_admin = current_app.appbuilder.sm.find_role(
        current_app.appbuilder.sm.auth_role_admin
    )
    # 创建管理员权限的用户
    user = current_app.appbuilder.sm.add_user(
        username, firstname, lastname, email, role_admin, password
    )
    if user:
        click.echo(click.style("Admin User {0} created.".format(username), fg="green"))
    else:
        click.echo(click.style("No user created an error occured", fg="red"))

```



#### app构建 base.py

视图操作：

* 菜单视图：调用 Menu对象的相关方法，如 add_link, add_view, add_separator  
* 非菜单视图：添加非菜单项的API视图，如add_api 同add_view_no_menu  

```python
from flask import Blueprint, current_app, url_for

from . import __version__
from .api.manager import OpenApiManager
from .babel.manager import BabelManager

from .filters import TemplateFilters
from .menu import Menu, MenuApiManager
from .views import IndexView, UtilView


class AppBuilder(object):
   baseviews = []
    security_manager_class = None
    # Flask app
    app = None
    # Database Session
    session = None
    # Security Manager Class
    sm = None
    # Babel Manager Class
    bm = None
    # OpenAPI Manager Class
    openapi_manager = None
    # dict with addon name has key and intantiated class has value
    addon_managers = None
    # temporary list that hold addon_managers config key
    _addon_managers = None

    menu = None			# 菜单对象
    indexview = None	# 首页视图

    static_folder = None
    static_url_path = None

    template_filters = None

    def __init__(
        self,
        app=None,
        session=None,
        menu=None,
        indexview=None,
        base_template="appbuilder/baselayout.html",
        static_folder="static/appbuilder",
        static_url_path="/appbuilder",
        security_manager_class=None,
        update_perms=True,
    ):
    	""" 定义app/session/menu/static/..."""   
        self.baseviews = []
        self._addon_managers = []
        self.addon_managers = {}
        self.menu = menu
        self.base_template = base_template
        self.security_manager_class = security_manager_class
        self.indexview = indexview
        self.static_folder = static_folder
        self.static_url_path = static_url_path
        self.app = app
        self.update_perms = update_perms

        if app is not None:
            self.init_app(app, session)    
            
    def init_app(self, app, session):
        """
            Will initialize the Flask app, supporting the app factory pattern.
            :param app:
            :param session: The SQLAlchemy session
        """
        # 从配置中更新
        ...
       _index_view = app.config.get("FAB_INDEX_VIEW", None)
        if _index_view is not None:
            self.indexview = dynamic_class_import(_index_view)
        else:
            self.indexview = self.indexview or IndexView	# 若无值，则为IndexView对象（/根视图）
        _menu = app.config.get("FAB_MENU", None)
        if _menu is not None:
            self.menu = dynamic_class_import(_menu)
        else:
            self.menu = self.menu or Menu()	# 若无值，则为Menu对象

        if self.update_perms:  # default is True, if False takes precedence from config
            self.update_perms = app.config.get("FAB_UPDATE_PERMS", True)
        _security_manager_class_name = app.config.get(
            "FAB_SECURITY_MANAGER_CLASS", None
        )
        if _security_manager_class_name is not None:
            self.security_manager_class = dynamic_class_import(
                _security_manager_class_name
            )
        if self.security_manager_class is None:
            from flask_appbuilder.security.sqla.manager import SecurityManager
            self.security_manager_class = SecurityManager  # 若无值，为SecurityManager对象          
        
      	self._addon_managers = app.config["ADDON_MANAGERS"]
        self.session = session
        self.sm = self.security_manager_class(self)
        self.bm = BabelManager(self)
        # 菜单和菜单路由管理
        self.openapi_manager = OpenApiManager(self)
        self.menuapi_manager = MenuApiManager(self)
        self._add_global_static()
        self._add_global_filters()
        app.before_request(self.sm.before_request)
        # 增加2个视图：admin, addon
        self._add_admin_views()
        self._add_addon_views()
        if self.app:	# 添加菜单权限
            self._add_menu_permissions()
        else:
            self.post_init()
        self._init_extension(app)        
                
    def add_view_no_menu(self, baseview, endpoint=None, static_folder=None):
        """
            Add your views without creating a menu.
			添加无菜单视图
        :param baseview:
            A BaseView type class instantiated.
        """
        baseview = self._check_and_init(baseview)
        log.info(LOGMSG_INF_FAB_ADD_VIEW.format(baseview.__class__.__name__, ""))

        if not self._view_exists(baseview):
            baseview.appbuilder = self
            self.baseviews.append(baseview)
            self._process_inner_views()
            if self.app:
                self.register_blueprint(
                    baseview, endpoint=endpoint, static_folder=static_folder
                )
                self._add_permission(baseview)
        else:
            log.warning(LOGMSG_WAR_FAB_VIEW_EXISTS.format(baseview.__class__.__name__))
        return baseview
    
    def add_api(self, baseview):
        """ 调用 add_view_no_menu """
        return self.add_view_no_menu(baseview)     
    
    def add_link(self, name, href, icon="", label="", category="", category_icon="", category_label="", baseview=None, cond=None,):
        """ 添加 菜单链接 """
        self.menu.add_link(
            name=name,
            href=href,
            icon=icon,
            label=label,
            category=category,
            category_icon=category_icon,
            category_label=category_label,
            baseview=baseview,
            cond=cond,
        )
        if self.app:
            self._add_permissions_menu(name)
            if category:
                self._add_permissions_menu(category)        
```



#### API视图和普通视图

* `/flask_appbuilder/api/__.init__.py `    API基类 BaseApi(object)  -> BaseModelApi -> ModelRestApi 

* /flask_appbuilder/baseview.py  
  * 路由装饰器函数  expose expose_api
  * 视图基类  BaseView(object) ->  BaseFormView/BaseModelView  --> BaseCRUDView(BaseModelView)
* /flask_appbuilder/views.py  视图常见路由实现，如list/add/edit/download/...

```shell
# 视图的层次体系: 类名带Base的实现一般在baseview.py
RestAPI:   BaseApi(object)  -> BaseModelApi -> ModelRestApi 
ModelView: 
	BaseView(object)  
		-> BaseModelView -> BaseCRUDView	(baseview.py)
			-> RestCRUDView -> ModelView    (views.py)
		-> BaseFormView
```



1. 路由扩展装饰器：expose expose_api

作用：在原有路由基础上增加次级路由

示例：原路由/superset，调用 @expose('/welcome')

结果：/superset/welcome

代码实现： flask_appbuilder/baseview.py

```python
def expose(url='/', methods=('GET',)):
    """
   Use this decorator to expose views on your view classes.
   :param url:  Relative URL for the view
   :param methods:  Allowed HTTP methods. By default only GET is allowed.
    """
    def wrap(f):
        if not hasattr(f, "_urls"):
            f._urls = []
        f._urls.append((url, methods))
        return f

    return wrap


def expose_api(name="", url="", methods=("GET",), description=""):
    """ API扩展路由，增加了API版本号name """
    def wrap(f):
        api_name = name or f.__name__
        api_url = url or "/api/{0}".format(name)
        if not hasattr(f, "_urls"):
            f._urls = []
            f._extra = {}
        f._urls.append((api_url, methods))
        f._extra[api_name] = (api_url, f.__name__, description)
        return f

    return wrap
```



2. 基础视图： 包括CRUD方法的真正实现

    flask_appbuilder/baseview.py

```python
class BaseView(object):
    """
        All views inherit from this class.
        it's constructor will register your exposed urls on flask as a Blueprint.

        This class does not expose any urls, but provides a common base for all views.

        Extend this class if you want to expose methods for your own templates
    """

    appbuilder = None
    blueprint = None
    endpoint = None

    route_base = None
    """ Override this if you want to define your own relative url """

    template_folder = "templates"
    """ The template folder relative location """
    static_folder = "static"
    """  The static folder relative location """
    base_permissions = None
    """
        List with allowed base permission.
        Use it like this if you want to restrict your view to readonly::

            class MyView(ModelView):
                base_permissions = ['can_list','can_show']
    """
    class_permission_name = None
    previous_class_permission_name = None
    """
        If set security cleanup will remove all permissions tuples
        with this name
    """
    method_permission_name = None
    """
        Override method permission names, example::

            method_permissions_name = {
                'get_list': 'read',
                'get': 'read',
                'put': 'write',
                'post': 'write',
                'delete': 'write'
            }
    """
    previous_method_permission_name = None
    """
        Use same structure as method_permission_name. If set security converge
        will replace all method permissions by the new ones
    """
    exclude_route_methods = set()
    """
        Does not register routes for a set of builtin ModelView functions.
        example::

            class ContactModelView(ModelView):
                datamodel = SQLAInterface(Contact)
                exclude_route_methods = {"delete", "edit"}

    """
    include_route_methods = None
    """
        If defined will assume a white list setup, where all endpoints are excluded
        except those define on this attribute
        example::

            class ContactModelView(ModelView):
                datamodel = SQLAInterface(Contact)
                include_route_methods = {"list"}


        The previous example will exclude all endpoints except the `list` endpoint
    """
    default_view = "list"
    """ the default view for this BaseView, to be used with url_for (method name) """
    extra_args = None

    """ dictionary for injecting extra arguments into template """
    _apis = None

    def __init__(self):
        """
            Initialization of base permissions
            based on exposed methods and actions

            Initialization of extra args
        """
        
        
   """ CRUD方法的真正实现 """ 
   def _list(self):
        """
            list function logic, override to implement different logic
            returns list and search widget
        """
        # 获取排序参数：排序字段，排序方向 
        if get_order_args().get(self.__class__.__name__):
            order_column, order_direction = get_order_args().get(
                self.__class__.__name__
            )
        else:
            order_column, order_direction = "", ""
        # 获取分页参数：page pagesize   
        page = get_page_args().get(self.__class__.__name__)
        page_size = get_page_size_args().get(self.__class__.__name__)
        # 获取过滤参数 filter
        get_filter_args(self._filters)
        widgets = self._get_list_widget(
            filters=self._filters,
            order_column=order_column,
            order_direction=order_direction,
            page=page,
            page_size=page_size,
        )
        form = self.search_form.refresh()
        self.update_redirect()
        return self._get_search_widget(form=form, widgets=widgets)        
```



3. 路由API实现  /flask_appbuilder/views.py

```python
from .baseviews import BaseCRUDView, BaseFormView, BaseView, expose, expose_api

class ModelView(RestCRUDView):
    """ 实现方法: list/add/edit/download/... """
	@expose("/list/")
    @has_access
    def list(self):

        widgets = self._list()	#实现在BaseView._list()
        return self.render_template(
            self.list_template, title=self.list_title, widgets=widgets
        )
```



#### 菜单 menu.py

4个对象分别是Menu、MenuItem、MenuApi和MenuApiManager，管理菜单项生成、菜单所对应的视图API和链接。

菜单相关的操作 AppBuilder.menu.xx()

* add_separator  添加菜单终止符
* add_link 给菜单项点击加链接
* add_view 给菜单项关联上视图，会调用add_link

```python
from flask import current_app, url_for
from flask_babel import gettext as __

from .api import BaseApi, expose
from .basemanager import BaseManager
from .security.decorators import permission_name, protect


class MenuItem(object):
    """ 菜单项：should_render, get_url """
    def __init__(
        self, name, href="", icon="", label="", childs=None, baseview=None, cond=None
    ):
        self.name = name
        self.href = href
        self.icon = icon
        self.label = label
        self.childs = childs or []  #列表存本级菜单的子项
        self.baseview = baseview
        self.cond = cond

    def should_render(self) -> bool:
        return bool(self.cond()) if self.cond is not None else True

    def get_url(self):
        if not self.href:
            if not self.baseview:
                return ""
            else:  # flask.url_for 获取当前请求路由的视图函数 
                return url_for(f"{self.baseview.endpoint}.{self.baseview.default_view}")
        else:
            try:
                return url_for(self.href)
            except Exception:
                return self.href

    def __repr__(self):
        return self.name
    
    
class Menu(object):
    """ 菜单对象 """
    def __init__(self, reverse=True, extra_classes=""):
        self.menu = []	#列表存储MenuItem
        if reverse:
            extra_classes = extra_classes + "navbar-inverse"
        self.extra_classes = extra_classes 
        
    def get_list(self):
        return self.menu
    
    def get_data(self, menu=None):
    def find(self, name, menu=None):
    def add_category(self, category, icon="", label="", parent_category=""):
        
 	def add_link( self, name, href="", icon="", label="", category="", category_icon="", category_label="", baseview=None, cond=None, ):      
        """ 根据category得到菜单，将name和对应的href添加到菜单下拉项 """
        label = label or name
        category_label = category_label or category
        if category == "":
            self.menu.append(
                MenuItem(
                    name=name,
                    href=href,
                    icon=icon,
                    label=label,
                    baseview=baseview,
                    cond=cond,
                )
            )
        else:
            menu_item = self.find(category)
            if menu_item:
                new_menu_item = MenuItem(
                    name=name,
                    href=href,
                    icon=icon,
                    label=label,
                    baseview=baseview,
                    cond=cond,
                )
                menu_item.childs.append(new_menu_item)
            else:
                self.add_category(
                    category=category, icon=category_icon, label=category_label
                )
                new_menu_item = MenuItem(
                    name=name,
                    href=href,
                    icon=icon,
                    label=label,
                    baseview=baseview,
                    cond=cond,
                )
                self.find(category).childs.append(new_menu_item)

    def add_separator(self, category="", cond=None):
        """ 给category对应的菜单添加结束标识- """
        menu_item = self.find(category)
        if menu_item:
            menu_item.childs.append(MenuItem("-", cond=cond))
        else:
            raise Exception(
                "Menu separator does not have correct category {}".format(category)
            )
      
    
class MenuApi(BaseApi):
    resource_name = "menu"
    openapi_spec_tag = "Menu"

    @expose("/", methods=["GET"])
    @protect(allow_browser_login=True)
    @permission_name("get")
    def get_menu_data(self):    
        return self.response(200, result=current_app.appbuilder.menu.get_data())


class MenuApiManager(BaseManager):
    def register_views(self):
        if self.appbuilder.app.config.get("FAB_ADD_MENU_API", True):
            self.appbuilder.add_api(MenuApi)        
```





#### 模板 /templates/

依赖模块Jinja2。

**首页相关的模板：**（说明：下面模板忽略路径前缀 /flask_appbuilder/templates/）

* appbuilder/index.html  继承自 appbuilder/base.html
* appbuilder/base.html 继承自 base_template
* base_template：为AppBuilder的内置变量，在AppBuilder对象构建时参数缺省值为"appbuilder/baselayout.html",
* appbuilder/baselayout.html   缺省布局页，继承自 appbuilder/init.html
* appbuilder/init.html  最终的HTML页面，include navbar.html和 footer.html
* **appbuilder/baselib.html**   定义常用宏，包括menu_item menu_debug menu_block locale_menu navbar_block
* appbuilder/navbar.html  导航栏，包括navbar_menu.html 和 navbar_right.html
* appbuilder/footer.html  页尾
* **appbuilder/navbar_menu.html**  导航栏菜单（多个菜单，可下拉）
* appbuilder/navbar_right.html    导航栏右侧 （包括语言切换、用户信息）

**首页模板继承关系**： index.html  -> base.html -> baselayout.html -> init.html



**首页布局**  /flask_appbuilder/templates/appbuilder/index.html

```jinja2
{% extends "appbuilder/base.html" %}

{% block content %}
<h2><center>{{_('Welcome')}}<center></h2>

<div class="well">

</div>
{% endblock %}
```



**首页缺省布局  appbuilder/baselayout.html **

重新定义了body块里的 导航栏navbar和页尾footer，通过include导入。

```jinja2
{% extends 'appbuilder/init.html' %}
{% import 'appbuilder/baselib.html' as baselib %}

{% block body %}
        {% include 'appbuilder/general/confirm.html' %}
        {% include 'appbuilder/general/alert.html' %}

    {% block navbar %}
        <header class="top" role="header">
        {% include 'appbuilder/navbar.html' %}
        </header>
    {% endblock %}

    <div class="container">
      <div class="row">
          {% block messages %}
            {% include 'appbuilder/flash.html' %}
          {% endblock %}
          {% block content %}
          {% endblock %}
      </div>
    </div>

    {% block footer %}
        <footer>
        <div class="img-rounded nav-fixed-bottom">
            <div class="container">
                {% include 'appbuilder/footer.html' %}
            </div>
        </div>
        </footer>
    {% endblock %}
{% endblock %}
```



**appbuilder/init.html  此模板才是最终HTML页面**

head实体定义3块，分别是head_meta/head_css/head_js。

body实体定义4块，分别是body, tail_js, add_tail_js, tail。

```jinja2
{% import 'appbuilder/baselib.html' as baselib with context %}

{% if appbuilder %}
  {% set app_name = appbuilder.app_name %}
{% endif %}

<!DOCTYPE html>
<html>
  <head>
    <title>{% block page_title %}{{app_name}}{% endblock %}</title>

    {% block head_meta %}
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <meta name="description" content="">
      <meta name="author" content="">
    {% endblock %}

    {% block head_css %}
      <link href="{{url_for('appbuilder.static',filename='css/bootstrap.min.css')}}" rel="stylesheet">
      <link href="{{url_for('appbuilder.static',filename='css/font-awesome.min.css')}}" rel="stylesheet">
      {% if appbuilder.app_theme %}
        <link href="{{url_for('appbuilder.static',filename='css/themes/'+ appbuilder.app_theme )}}" rel="stylesheet">
      {% endif %}
      <link href="{{url_for('appbuilder.static',filename='datepicker/bootstrap-datepicker.css')}}" rel="stylesheet">
      <link href="{{url_for('appbuilder.static',filename='select2/select2.css')}}" rel="stylesheet">
      <link href="{{url_for('appbuilder.static',filename='css/flags/flags16.css')}}" rel="stylesheet">
      <link href="{{url_for('appbuilder.static',filename='css/ab.css')}}" rel="stylesheet">
    {% endblock %}

    {% block head_js %}
      <script src="{{url_for('appbuilder.static',filename='js/jquery-latest.js')}}"></script>
      <script src="{{url_for('appbuilder.static',filename='js/ab_filters.js')}}"></script>
      <script src="{{url_for('appbuilder.static',filename='js/ab_actions.js')}}"></script>
    {% endblock %}
  </head>
  <body >
    {% block body %}
    {% endblock %}

    {% block tail_js %}
      <script src="{{url_for('appbuilder.static',filename='js/bootstrap.min.js')}}"></script>
      <script src="{{url_for('appbuilder.static',filename='datepicker/bootstrap-datepicker.js')}}"></script>
      <script src="{{url_for('appbuilder.static',filename='select2/select2.js')}}"></script>
      <script src="{{url_for('appbuilder.static',filename='js/ab.js')}}"></script>
    {% endblock %}

    {% block add_tail_js %}
    {% endblock %}

    {% block tail %}
    {% endblock %}
  </body>
</html>
```



appbuilder/baselib.html

定义常用宏，主要是菜单和导航栏相关的代码块。包括menu_item menu_debug menu_block locale_menu navbar_block

```jinja2
{% macro menu_debug(menu) %}
    {% for item1 in menu.get_list() %}
        {{ item1.label }} {{ item1.href }}
            {% for item2 in item1.childs %}
		        {{ item2.label }} {{ item2.href }}
        	{% endfor %}
	{% endfor %}
{% endmacro %}


{% macro menu_block(menu) %}
{% for item1 in menu.get_list() %}
    {% if item1 | is_menu_visible %}
        {% if item1.childs %}
            <li class="dropdown">
				<a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">
            {% if item1.icon %}
                <i class="fa {{item1.icon}}"></i>&nbsp;
            {% endif %}
				{{_(item1.label)}}<b class="caret"></b></a>
		        <ul class="dropdown-menu">
				{% set divider = False %}
            {% for item2 in item1.childs %}
                {% if item2.name == '-' %}
                    {% set divider = True %}
                {% else %}
                    {% if item2 | is_menu_visible %}
                        {% if divider %}
                            <li class="divider"></li>
                            {% set divider = False %}
                        {% endif %}
					        <li>{{ menu_item(item2) }}</li>
                    {% endif %}
					{% endif %}
				{% endfor %}
				</ul></li>
			{% else %}
				<li>
                {{ menu_item(item1) }}
				</li>
    	{% endif %}
    {% endif %}
{% endfor %}

{% endmacro %}

{% macro locale_menu(languages) %}
{% set locale = session['locale'] %}
{% if not locale %}
	{% set locale = 'en' %}
{% endif %}
<li class="dropdown">
	<a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">
	   <div class="f16"><i class="flag {{languages[locale].get('flag')}}"></i><b class="caret"></b>
       </div>
	</a>
    {% if languages.keys()|length > 1 %}
	<ul class="dropdown-menu">
	<li class="dropdown">
		{% for lang in languages %}
			{% if lang != locale %}
        		<a tabindex="-1" href="{{appbuilder.get_url_for_locale(lang)}}">
        		  <div class="f16"><i class="flag {{languages[lang].get('flag')}}"></i> - {{languages[lang].get('name')}}
        		</div></a>
        		{% endif %}
        	{% endfor %}
        </li>
        </ul>
    {% endif %}
</li>
{% endmacro %}

{% macro navbar_block(menu, languages) %}

<div class="navbar {{menu.extra_classes}}" role="navigation">
   <div class="container">
        <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                {% if appbuilder.app_icon %}
                	<a class="navbar-brand" href="{{appbuilder.get_url_for_index}}">
                	<img src="{{appbuilder.app_icon}}" >
                	</a>
                {% else %}
                	<span class="navbar-brand">
                	<a href="{{appbuilder.get_url_for_index}}">
                	{{ appbuilder.app_name }}
                	</a>
                	</span>
                {% endif %}
        </div>
        <div class="navbar-collapse collapse">
                <ul class="nav navbar-nav">
                        {{ menu_block(menu)}}
                </ul>
                <ul class="nav navbar-nav navbar-right">
                {{ locale_menu(languages) }}
                {% if not current_user.is_anonymous %}
                <li class="dropdown">
	               <a class="dropdown-toggle" data-toggle="dropdown" href="#">
	               <span class="fa fa-user"></span> {{g.user.get_full_name()}}<b class="caret"></b>
                   </a>
                    <ul class="dropdown-menu">
			<li><a href="{{appbuilder.get_url_for_userinfo}}"><span class="fa fa-fw fa-user"></span>{{_("Profile")}}</a></li>
			<li><a href="{{appbuilder.get_url_for_logout}}"><span class="fa fa-fw fa-sign-out"></span>{{_("Logout")}}</a></li>
                    </ul>
        		
                </li>
                {% else %}
                    <li><a href="{{appbuilder.get_url_for_login}}">
                    <i class="fa fa-fw fa-sign-in"></i>{{_("Login")}}</a></li>
                {% endif %}
                </ul>
        </div>
   </div>
</div>
{% endmacro %}
```



appbuilder/nav_bar.html

导航栏，定义了navbar-header（如有图片，则包含navbar-brand），navbar-collapse（分别导入2个模板navbar_menu 和 navbar_right）。

```jinja2
{% set menu = appbuilder.menu %}
{% set languages = appbuilder.languages %}

<div class="navbar {{menu.extra_classes}}" role="navigation">
   <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            {% if appbuilder.app_icon %}
                <a class="navbar-brand" href="{{appbuilder.get_url_for_index}}">
                <img src="{{appbuilder.app_icon}}" height="100%" width="auto">
                </a>
            {% else %}
                <span class="navbar-brand">
                <a href="{{appbuilder.get_url_for_index}}">
                {{ appbuilder.app_name }}
                </a>
                </span>
            {% endif %}                
        </div>
        <div class="navbar-collapse collapse">
            <ul class="nav navbar-nav">
                {% include 'appbuilder/navbar_menu.html' %}
            </ul>
            <ul class="nav navbar-nav navbar-right">
                {% include 'appbuilder/navbar_right.html' %}
            </ul>
        </div>
   </div>
</div>
```



**appbuilder/navbar_menu.html**

导航栏菜单。从Appbuilder.menu获取菜单列表，宏menu_item获取单个菜单下拉项的icon/url/label。

```jinja2
{% macro menu_item(item) %}
    <a tabindex="-1" href="{{item.get_url()}}">
       {% if item.icon %}
        <i class="fa fa-fw {{item.icon}}"></i>&nbsp;
    {% endif %}
    {{_(item.label)}}</a>
{% endmacro %}


{% for item1 in menu.get_list() %}
    {% if item1 | is_menu_visible %}
        {% if item1.childs %}
            <li class="dropdown">
            <a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">
            {% if item1.icon %}
                <i class="fa {{item1.icon}}"></i>&nbsp;
            {% endif %}
            {{_(item1.label)}}<b class="caret"></b></a>
            <ul class="dropdown-menu">
            {% for item2 in item1.childs %}
                {% if item2 %}
                    {% if item2.name == '-' %}   {# 处理菜单分隔符- #}
                        {% if not loop.last %}
                          <li class="divider"></li>
                        {% endif %}
                    {% elif item2 | is_menu_visible %}
                        <li>{{ menu_item(item2) }}</li>
                    {% endif %}
                {% endif %}
            {% endfor %}
            </ul></li>
        {% else %}
            <li>
                {{ menu_item(item1) }}
            </li>
        {% endif %}
    {% endif %}
{% endfor %}
```



**appbuilder/navbar_right.html**

导航栏右侧。定义了 语言选择栏，用户信息栏。

```jinja2

{% macro locale_menu(languages) %}
{% set locale = session['locale'] %}
{% if not locale %}
    {% set locale = 'en' %}
{% endif %}
{% if languages.keys()|length > 1 %}
<li class="dropdown">
    <a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">
       <div class="f16"><i class="flag {{languages[locale].get('flag')}}"></i><b class="caret"></b>
       </div>
    </a>
    <ul class="dropdown-menu">
    <li class="dropdown">
        {% for lang in languages %}
            {% if lang != locale %}
                <a tabindex="-1" href="{{appbuilder.get_url_for_locale(lang)}}">
                  <div class="f16"><i class="flag {{languages[lang].get('flag')}}"></i> - {{languages[lang].get('name')}}
                </div></a>
            {% endif %}
        {% endfor %}
        </li>
        </ul>
</li>
{% endif %}
{% endmacro %}



{{ locale_menu(languages) }}
{% if not current_user.is_anonymous %}
    <li class="dropdown">
        <a class="dropdown-toggle" data-toggle="dropdown" href="#">
           <span class="fa fa-user"></span> {{g.user.get_full_name()}}<b class="caret"></b>
        </a>
        <ul class="dropdown-menu">
            <li><a href="{{appbuilder.get_url_for_userinfo}}"><span class="fa fa-fw fa-user"></span>{{_("Profile")}}</a></li>
            <li><a href="{{appbuilder.get_url_for_logout}}"><span class="fa fa-fw fa-sign-out"></span>{{_("Logout")}}</a></li>
        </ul>
    </li>
{% else %}
    <li><a href="{{appbuilder.get_url_for_login}}">
    <i class="fa fa-fw fa-sign-in"></i>{{_("Login")}}</a></li>
{% endif %}

```





### flask_migrate

```shell
$ pip show flask_migrate
Name: Flask-Migrate
Version: 3.0.1
Summary: SQLAlchemy database migrations for Flask applications using Alembic
Home-page: http://github.com/miguelgrinberg/flask-migrate/
Author: Miguel Grinberg
Author-email: miguelgrinberg50@gmail.com
License: MIT
Location: e:\dev\python\venv\superset-py37-env\lib\site-packages
Requires: Flask-SQLAlchemy, alembic, Flask
Required-by: apache-superset
```



`/flask_migrate/__init__.py`  

全局定义了模板在templates目录，DB迁移文件在 migrations目录 

```python
from flask import current_app

class _MigrateConfig(object):
    def __init__(self, migrate, db, **kwargs):
        self.migrate = migrate
        self.db = db
        self.directory = migrate.directory
        self.configure_args = kwargs

    @property
    def metadata(self):
        return self.db.metadata
        
        
class Config(AlembicConfig):
    def get_template_directory(self):
        """ 获取template模板目录 """
        package_dir = os.path.abspath(os.path.dirname(__file__))
        return os.path.join(package_dir, 'templates')


class Migrate(object):
    """ 迁移对象类，生成的文件在migrations目录 """
    def __init__(self, app=None, db=None, directory='migrations', **kwargs):
        self.configure_callbacks = []
        self.db = db
        self.directory = str(directory)
        self.alembic_ctx_kwargs = kwargs
        if app is not None and db is not None:
            self.init_app(app, db, directory)

    def init_app(self, app, db=None, directory=None, **kwargs):    
        """ """
  

def catch_errors(f):
    @wraps(f)
    def wrapped(*args, **kwargs):
        try:
            f(*args, **kwargs)
        except (CommandError, RuntimeError) as exc:
            log.error('Error: ' + str(exc))
            sys.exit(1)
    return wrapped

@catch_errors  # 异常时打印日志
def upgrade(directory=None, revision='head', sql=False, tag=None, x_arg=None):
    """Upgrade to a later version"""
    config = current_app.extensions['migrate'].migrate.get_config(directory,
                                                                  x_arg=x_arg)
    command.upgrade(config, revision, sql=sql, tag=tag)        
```



#### db命令 cli.py

```python
import click
from flask_migrate import upgrade as _upgrade

@click.group()
def db():  # db命令组
    """Perform database migrations."""
    pass

# 示例命令：flask db upgrade
@db.command()
@click.option('-d', '--directory', default=None,
              help=('Migration script directory (default is "migrations")'))
@click.option('--sql', is_flag=True,
              help=('Don\'t emit SQL to database - dump to standard output '
                    'instead'))
@click.option('--tag', default=None,
              help=('Arbitrary "tag" name - can be used by custom env.py '
                    'scripts'))
@click.option('-x', '--x-arg', multiple=True,
              help='Additional arguments consumed by custom env.py scripts')
@click.argument('revision', default='head')
@with_appcontext
def upgrade(directory, sql, tag, x_arg, revision):
    """Upgrade to a later version"""
    _upgrade(directory, revision, sql, tag, x_arg)        
```



### flask_sqlalchemy

依赖于 sqlalchemy.

```shell
$ pip show flask_sqlalchemy
Name: Flask-SQLAlchemy
Version: 2.5.1
Summary: Adds SQLAlchemy support to your Flask application.
Home-page: https://github.com/pallets/flask-sqlalchemy
Author: Armin Ronacher
Author-email: armin.ronacher@active-4.com
License: BSD-3-Clause
Location: e:\dev\python\venv\superset-py37-env\lib\site-packages
Requires: Flask, SQLAlchemy
Required-by: Flask-Migrate, Flask-AppBuilder
```



### flask_caching

Flask-Caching支持多个缓存后端（Redis，Memcached，SimpleCache（内存中）或本地文件系统）。

```python
# flask_caching/__init__.py
class Cache(object):
    """This class is used to control the cache objects."""

    def __init__(
        self,
        app: Optional[Flask] = None,
        with_jinja2_ext: bool = True,
        config=None,
    ) -> None:
        if not (config is None or isinstance(config, dict)):
            raise ValueError("`config` must be an instance of dict or None")

        self.with_jinja2_ext = with_jinja2_ext
        self.config = config

        self.source_check = None

        if app is not None:
            self.init_app(app, config)

    def init_app(self, app: Flask, config=None) -> None:
        """This is used to initialize cache with your app object"""
        if not (config is None or isinstance(config, dict)):
            raise ValueError("`config` must be an instance of dict or None")

		...
       config.setdefault('CACHE_DEFAULT_TIMEOUT', 300)  # 缓存过期时间缺省300秒
       config.setdefault('CACHE_DIR', None)   # 设置缓存路径
       # null改为'filesystem'，如果是redis/memache，则需要相应的服务器支持和安装python客户端模块
       config.setdefault('CACHE_TYPE', 'null')  

```



### flask_babel

国际化支持，依赖于标准库babel。

```python
# flask_babel/__init__.py
from flask import current_app, request
from flask.ctx import has_request_context
from babel import dates, numbers, support, Locale

class Babel(object):
    """Central controller class that can be used to configure how
    Flask-Babel behaves.  Each application that wants to use Flask-Babel
    has to create, or run :meth:`init_app` on, an instance of this class
    after the configuration was initialized.
    """

    default_date_formats = ImmutableDict({
        'time':             'medium',
        'date':             'medium',
        'datetime':         'medium',
        'time.short':       None,
        'time.medium':      None,
        'time.full':        None,
        'time.long':        None,
        'date.short':       None,
        'date.medium':      None,
        'date.full':        None,
        'date.long':        None,
        'datetime.short':   None,
        'datetime.medium':  None,
        'datetime.full':    None,
        'datetime.long':    None,
    })
    
    def __init__(self, app=None, default_locale='en', default_timezone='UTC',
                 default_domain='messages', date_formats=None,
                 configure_jinja=True):
        self._default_locale = default_locale
        self._default_timezone = default_timezone
        self._default_domain = default_domain
        self._date_formats = date_formats
        self._configure_jinja = configure_jinja
        self.app = app
        self.locale_selector_func = None
        self.timezone_selector_func = None

        if app is not None:
            self.init_app(app)

    def init_app(self, app):
        """ 初始化APP，用到一些传入变量： """
        self.app = app
        app.babel_instance = self
        if not hasattr(app, 'extensions'):
            app.extensions = {}
        app.extensions['babel'] = self

        # 重要变量：BABEL_DEFAULT_LOCALE语种 BABEL_DEFAULT_TIMEZONE时区
        app.config.setdefault('BABEL_DEFAULT_LOCALE', self._default_locale)
        app.config.setdefault('BABEL_DEFAULT_TIMEZONE', self._default_timezone)
        app.config.setdefault('BABEL_DOMAIN', self._default_domain)
        if self._date_formats is None:
            self._date_formats = self.default_date_formats.copy()    
      

def gettext(string, **variables):
    """Translates a string with the current locale and passes in the
    given keyword arguments as mapping to a string formatting string.
    ::
        gettext(u'Hello World!')
        gettext(u'Hello %(name)s!', name='World')
    """
    t = get_translations()
    if t is None:
        return string if not variables else string % variables
    s = t.ugettext(string)
    return s if not variables else s % variables
_ = gettext
 
    
def lazy_gettext(string, **variables):
    """ 晚获取，作为字符串时才翻译 """
    return LazyString(gettext, string, **variables)    
```

使用示例：

```python
from flask_babel import gettext as __

label = __('good man')
```



### flask_script

```python
# flask_script/__init__.py: Manager
class Print(Command):
    def run(self):
   print "hello"

from flask import Flask
from flask_script import Manager

app = Flask(__name__)
manager = Manager(app)
manager.add_command("print", Print())


if __name__ == "__main__":
    manager.run()

# ipython运行    
python manage.py print
> hello
```

 

## 本章参考

* FLask之Local、LocalStack和LocalProxy介绍 https://blog.csdn.net/weixin_45950544/article/details/103923191



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

