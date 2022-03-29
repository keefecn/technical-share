| 序号  | 修改时间      | 修改内容                                                | 修改人   | 审稿人   |
| --- | --------- | --------------------------------------------------- | ----- | ----- |
| 1   | 2021-8-23 | 创建。从《python_web框架源码剖析》拆分成文。另拆分flask_appbuilder章节另文。 | Keefe | Keefe |
|     |           |                                                     |       |       |

<br><br><br>

---

[TOC]

<br>

---

# 1 flask源码剖析

[pallets/flask](https://github.com/pallets/flask)  [Releases on PyPI](https://pypi.python.org/pypi/Flask)  [Documentation](https://flask.palletsprojects.com/)  [Test status](https://dev.azure.com/pallets/flask/_build)

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
#coding=utf8
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
    app.run(host='0.0.0.0')
```

## 源码结构

表格 flask源码结构

| 目录或文件         | 主要类或函数                                                                 | 说明                         |
| ------------- | ---------------------------------------------------------------------- | -------------------------- |
| ext/          |                                                                        | 扩展模块                       |
| _compat.ppy   | with_metaclass                                                         | python2&3的兼容处理：类型和元类       |
| app.py        | Flask<br>::run route add_url_rule register_blueprint                   | 全局WEB实例                    |
| blueprints.py | Blueprint<br>::route add_url_rule                                      | 蓝图，相当于django中的app，某应用      |
| cli.py        | main run_command                                                       | 命令行处理                      |
| config.py     | ConfigAttribute Config                                                 | 配置数据                       |
| ctx.py        | AppContext RequestContext                                              | 上下文管理                      |
| exthook.py    | ExtensionImporter                                                      | 加载扩展模块                     |
| globals.py    | current_app session request g                                          | 全局变量                       |
| helpers.py    | _PackageBoundObject                                                    | 帮助工具                       |
| json.py       | jsonify dump dumps load loads                                          | json转化                     |
| logging.py    |                                                                        | 日志                         |
| sessions.py   | SecureCookieSession  SessionInterface <br>SecureCookieSessionInterface | 会话                         |
| signals.py    | Namespace::signal                                                      | 定义若干信号，如消息，request...      |
| templating.py | DispatchingJinjaLoader Environment                                     | 前端用的模板，依赖jinja2            |
| testing.py    | FlaskClient                                                            | 测试                         |
| view.py       | View MethodViewType MethodView                                         | 视图类                        |
| wrappers.py   | Request Response                                                       | 继承wsgi wrappers，依赖werkzeug |

## WEB核心对象

### Flask全局实例 app.py

flask.app该模块近2000行代码，主要完成应用的配置、初始化、蓝图注册、请求装饰器定义、应用的启动和监听。

类：Flask

类方法：run  create_app  register_blueprint  register_db  route/add_url_route

flask启动调用 Flask.run，缺省监听参数是127.0.0.1:5000。

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
        缺省值：host=127.0.0.1, port=5000, debug=bool(None)=False 非调试模式
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
        rule,  #路由路径str
        endpoint=None,    #名称，一般同路由函数名称str
        view_func=None,    #路由函数func
        provide_automatic_options=None,
        **options
    ):
    """
            Basically this example::
            @app.route('/')
            def index():
                pass

        Is equivalent to the following::
            def index():
                pass
            app.add_url_rule('/', 'index', index)

        相当于： app.view_functions['index'] = index
    """

if __name__ == '__main__':
    # 实际应用app定义，一般需要弄成全局实例
    app = Flask(__name__)
    with app.app_context():
        # 缺省非调试模式，一进程一线程（processes=1）模式监听队列。缺省情况下，仅限用于本地单机测试。
        # 若要本机调试，debug=True
        # 若是生产环境，则启用进程或线程，分别使用`processes={num}`或者 threaded=True
        # 生产环境推荐 gunicorn 或者 uwsgi
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
 'root_path': '~\superset',
 '_static_folder': 'static',
 '_static_url_path': None,
 'cli': <AppGroup demo_app>,
 'instance_path': '~\superset\\instance',
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

#### wsgi应用 wsgi_app

```python
class Flask(_PackageBoundObject):
    def wsgi_app(self, environ, start_response):
        """ 真正的wsgi应用程序
        The actual WSGI application. This is not implemented in
        :meth:`__call__` so that middlewares can be applied without
        losing a reference to the app object. Instead of doing this::

            app = MyMiddleware(app)
        It's a better idea to do this instead::
            app.wsgi_app = MyMiddleware(app.wsgi_app)
        """
        ctx = self.request_context(environ)    #得到请求上下文
        error = None
        try:
            try:
                ctx.push()
                response = self.full_dispatch_request()    #分发请求
            except Exception as e:
                error = e
                response = self.handle_exception(e)
            except:  # noqa: B001
                error = sys.exc_info()[1]
                raise
            return response(environ, start_response)    # 返回响应结果Response, 此处实现了WSGI协议
        finally:
            if self.should_ignore_error(error):
                error = None
            ctx.auto_pop(error)

    def __call__(self, environ, start_response):
        """The WSGI server calls the Flask application object as the
        WSGI application. This calls :meth:`wsgi_app` which can be
        wrapped to applying middleware."""
        return self.wsgi_app(environ, start_response)
```

### 请求&响应 wrappers.py

* flask/app.py   Request请求处理&生成响应Response
* flask/wrappers.py   定义类Request和Response

```python
# flask/app.py
from .wrappers import Request
from .wrappers import Response

class Flask(_PackageBoundObject):
    request_class = Request        # 请求类
    response_class = Response    # 响应类

    def dispatch_request(self):
        """ 分发请求并处理：从请求栈里获取请求，通过请求参数（包括路由）获取到相应的路由视图函数 """
        req = _request_ctx_stack.top.request
        if req.routing_exception is not None:
            self.raise_routing_exception(req)
        rule = req.url_rule
        ...
        return self.view_functions[rule.endpoint](**req.view_args)

    def full_dispatch_request(self):
        """ 分发请求完整流程：请求前函数 -> preprocess_request -> dispatch_request -> finalize_request """
        self.try_trigger_before_first_request_functions()    # before请求
        try:
            request_started.send(self)
            rv = self.preprocess_request()        # 预处理请求
            if rv is None:
                rv = self.dispatch_request()    # 真正分发请求到处理函数
        except Exception as e:
            rv = self.handle_user_exception(e)
        return self.finalize_request(rv)    # after请求：处理完请求进行加工

      def preprocess_request(self):
        """Called before the request is dispatched. Calls
        :attr:`url_value_preprocessors` registered with the app and the
        current blueprint (if any). Then calls :attr:`before_request_funcs`
        registered with the app and the blueprint.

        If any :meth:`before_request` handler returns a non-None value, the
        value is handled as if it was the return value from the view, and
        further request handling is stopped.
        """
        bp = _request_ctx_stack.top.request.blueprint

        funcs = self.url_value_preprocessors.get(None, ())
        if bp is not None and bp in self.url_value_preprocessors:
            funcs = chain(funcs, self.url_value_preprocessors[bp])
        for func in funcs:
            func(request.endpoint, request.view_args)

        funcs = self.before_request_funcs.get(None, ())    #@before_request
        if bp is not None and bp in self.before_request_funcs:
            funcs = chain(funcs, self.before_request_funcs[bp])
        for func in funcs:
            rv = func()
            if rv is not None:
                return rv

    def make_response(self, rv):
        """ 生成 Response类 """

    @setupmethod
    def before_request(self, f):
        """Registers a function to run before each request.
        注册每个请求处理前函数，可以作装饰器 @xx.before_request
        """
        self.before_request_funcs.setdefault(None, []).append(f)
        return f

    @setupmethod
    def before_first_request(self, f):
        self.before_first_request_funcs.append(f)
        return f

    @setupmethod
    def after_request(self, f):
        """ 注册每个请求处理后函数 """
        self.after_request_funcs.setdefault(None, []).append(f)
        return f

    @setupmethod
    def teardown_request(self, f):
        self.teardown_appcontext_funcs.append(f)
        return f
```

wrappers.py  请求/响应类包装，依赖于werkzeug模块的相应基类

```python
from werkzeug.exceptions import BadRequest
from werkzeug.wrappers import Request as RequestBase
from werkzeug.wrappers import Response as ResponseBase
from werkzeug.wrappers.json import JSONMixin as _JSONMixin

from . import json
from .globals import current_app

class JSONMixin(_JSONMixin):
    json_module = json
    """ JSON加载异常返回 """
    def on_json_loading_failed(self, e):
        if current_app and current_app.debug:
            raise BadRequest("Failed to decode JSON object: {0}".format(e))

        raise BadRequest()


class Request(RequestBase, JSONMixin):
    """ 3个函数属性化：max_content_length endpoint blueprint """
    url_rule = None
    view_args = None

    @property
    def max_content_length(self):
        """Read-only view of the ``MAX_CONTENT_LENGTH`` config key."""
        if current_app:
            return current_app.config["MAX_CONTENT_LENGTH"]

    @property
    def endpoint(self):
        """The endpoint that matched the request.  This in combination with
        :attr:`view_args` can be used to reconstruct the same or a
        modified URL.  If an exception happened when matching, this will
        be ``None``.
        """
        if self.url_rule is not None:
            return self.url_rule.endpoint

    @property
    def blueprint(self):
        """The name of the current blueprint"""
        if self.url_rule and "." in self.url_rule.endpoint:
            return self.url_rule.endpoint.rsplit(".", 1)[0]


class Response(ResponseBase, JSONMixin):
    default_mimetype = "text/html"

    def _get_data_for_json(self, cache):
        return self.get_data()

    @property
    def max_cookie_size(self):
```

### 蓝图 blueprints.py

类Flask 和Blueprint 都继承自  _PackageBoundObject， Bluepring粒度更小，一个Flask实例内可以有多个蓝图。

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

视图View和 类视图函数方法as_view

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

### 会话 sessions.py

cookie数据生成依赖于itdangerous模块的安全算法。

```python
from itsdangerous import BadSignature
from itsdangerous import URLSafeTimedSerializer
from werkzeug.datastructures import CallbackDict


class SessionInterface(object):

class SecureCookieSessionInterface(SessionInterface):
    """The default session interface that stores sessions in signed cookies
    through the :mod:`itsdangerous` module.
    """

    #: the salt that should be applied on top of the secret key for the
    #: signing of cookie based sessions.
    salt = "cookie-session"
    #: the hash function to use for the signature.  The default is sha1
    digest_method = staticmethod(hashlib.sha1)
    #: the name of the itsdangerous supported key derivation.  The default
    #: is hmac.
    key_derivation = "hmac"
    #: A python serializer for the payload.  The default is a compact
    #: JSON derived serializer with support for some extra Python types
    #: such as datetime objects or tuples.
    serializer = session_json_serializer
    session_class = SecureCookieSession

    def get_signing_serializer(self, app):
        if not app.secret_key:
            return None
        signer_kwargs = dict(
            key_derivation=self.key_derivation, digest_method=self.digest_method
        )
        return URLSafeTimedSerializer(
            app.secret_key,    #外部传入的安全密钥
            salt=self.salt,    #类成员变量有缺省值
            serializer=self.serializer,
            signer_kwargs=signer_kwargs,
        )

    def open_session(self, app, request):
        s = self.get_signing_serializer(app)    #获取签名类
        if s is None:
            return None
        val = request.cookies.get(app.session_cookie_name)
        if not val:    #获取cookie名为session的值
            return self.session_class()
        max_age = total_seconds(app.permanent_session_lifetime)
        try:
            data = s.loads(val, max_age=max_age)    #解析cookie值
            return self.session_class(data)
        except BadSignature:
            return self.session_class()

    def save_session(self, app, session, response):
        domain = self.get_cookie_domain(app)
        path = self.get_cookie_path(app)

        # If the session is modified to be empty, remove the cookie.
        # If the session is empty, return without setting the cookie.
        if not session:
            if session.modified:
                response.delete_cookie(
                    app.session_cookie_name, domain=domain, path=path
                )

            return

        # Add a "Vary: Cookie" header if the session was accessed at all.
        if session.accessed:
            response.vary.add("Cookie")

        if not self.should_set_cookie(app, session):
            return

        httponly = self.get_cookie_httponly(app)
        secure = self.get_cookie_secure(app)
        samesite = self.get_cookie_samesite(app)
        expires = self.get_expiration_time(app, session)
        # cookie数据：调用URLSafeTimedSerializer类来序列化(使用hmac算法)
        val = self.get_signing_serializer(app).dumps(dict(session))
        response.set_cookie(
            app.session_cookie_name,
            val,
            expires=expires,
            httponly=httponly,
            domain=domain,
            path=path,
            secure=secure,
            samesite=samesite,
        )
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

flask框架自带的代理对象LocalStack有四个，分别是request，session，g和current_app。用代理而不是显式的对象的主要目的在于这四个对象使用太过频繁，贯穿整个请求周期，显式传递很容易造成循环导入的问题，需要一个第三方的对象来进行解耦。

依赖于werkzeug的Local对象，详看下面werkzeug章节。

```python
from functools import partial
from werkzeug.local import LocalStack, LocalProxy

# context locals
# LocalStack: 请求上下文、应用上下文
_request_ctx_stack = LocalStack()
_app_ctx_stack = LocalStack()
# LocalProxy: current_app request session g
current_app = LocalProxy(_find_app)
request = LocalProxy(partial(_lookup_req_object, 'request'))
session = LocalProxy(partial(_lookup_req_object, 'session'))
g = LocalProxy(partial(_lookup_app_object, 'g'))
```

### 配置文件

* flask/config.py  配置类，读取配置文件
* flask/app.py  加载配置类

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

## flask命令 cli.py

flask命令基于click库实现。

* `flask/__main__.py`： 命令行调用入口demo
* flask/cli.py:  命令行实现

**常用命令**：

* flask run:  运行开发服务器
* flask shell:  启动一个交互python shell
* flask db:  数据库迁移相关。不能直接使用，需要获取Migrate实例。
* flask routes  获取路由，v1.1.4新增。

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
        :param add_default_commands True时添加run/shell命令，1.1.4时增加routes命令
        :param create_app app创建方法
        :param add_version_option True时添加版本命令
        """
        params = list(extra.pop('params', None) or ())

        if add_version_option:    #缺省添加版本命令
            params.append(version_option)

        AppGroup.__init__(self, params=params, **extra)
        self.create_app = create_app  #app初始化方法

        if add_default_commands: #缺省添加命令 run/shell
            self.add_command(run_command)
            self.add_command(shell_command)
            self.add_command(routes_command)

        self._loaded_plugin_commands = False    #是否加载插件命令，如fab/db

    def _load_plugin_commands(self):
        """ 加载插件命令 """
        if self._loaded_plugin_commands:
            return
        try:
            import pkg_resources
        except ImportError:
            self._loaded_plugin_commands = True
            return

        for ep in pkg_resources.iter_entry_points("flask.commands"):
            self.add_command(ep.load(), ep.name)
        self._loaded_plugin_commands = True

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
    flask应用程序启动一个开发服务器，缺省值只推荐开发时使用，缺省开发模式，启用reload、debugger
    用flask run启动，缺省不使用线程
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

### flask routes命令

可以用flask routes获取到 路由类方法 和 路由的一个对照。

```shell
$ flask routes
Endpoint                                Methods    Rule
<br>

--------------------------------------  ---------  -----------------------------------------------------------------------
AnnotationLayerModelView.action_post    POST       /annotationlayermodelview/action_post
AnnotationLayerModelView.add            GET, POST  /annotationlayermodelview/add
AnnotationLayerRestApi.bulk_delete      DELETE     /api/v1/annotation_layer/
AnnotationLayerRestApi.delete           DELETE     /api/v1/annotation_layer/<int:pk>
AnnotationLayerRestApi.post             POST       /api/v1/annotation_layer/
AnnotationLayerRestApi.put              PUT        /api/v1/annotation_layer/<int:pk>
UserInfoEditView.this_form_post         POST       /userinfoeditview/form
UtilView.back                           GET        /back
appbuilder.static                       GET        /static/appbuilder/<path:filename>
health                                  GET        /health
healthcheck                             GET        /healthcheck
ping                                    GET        /ping
static                                  GET        /static/<path:filename>
```

routes命令支持按methods, rule, endpoint等进行排序

```python
@click.command("routes", short_help="Show the routes for the app.")
@click.option(
    "--sort",
    "-s",
    type=click.Choice(("endpoint", "methods", "rule", "match")),
    default="endpoint",
    help=(
        'Method to sort routes by. "match" is the order that Flask will match '
        "routes when dispatching a request."
    ),
)
@click.option("--all-methods", is_flag=True, help="Show HEAD and OPTIONS methods.")
@with_appcontext
def routes_command(sort, all_methods):
    """Show all registered routes with endpoints and methods."""

    rules = list(current_app.url_map.iter_rules())    # 获取到当前app注册的路由
    if not rules:
        click.echo("No routes were registered.")
        return

    ignored_methods = set(() if all_methods else ("HEAD", "OPTIONS"))

    if sort in ("endpoint", "rule"):    # 排序方式
        rules = sorted(rules, key=attrgetter(sort))
    elif sort == "methods":
        rules = sorted(rules, key=lambda rule: sorted(rule.methods))

    rule_methods = [", ".join(sorted(rule.methods - ignored_methods)) for rule in rules]

    headers = ("Endpoint", "Methods", "Rule")
    widths = (
        max(len(rule.endpoint) for rule in rules),
        max(len(methods) for methods in rule_methods),
        max(len(rule.rule) for rule in rules),
    )
    widths = [max(len(h), w) for h, w in zip(headers, widths)]
    row = "{{0:<{0}}}  {{1:<{1}}}  {{2:<{2}}}".format(*widths)

    click.echo(row.format(*headers).strip())
    click.echo(row.format(*("-" * width for width in widths)))

    for rule, methods in zip(rules, rule_methods):
        click.echo(row.format(rule.endpoint, methods, rule.rule).rstrip())
```

## 扩展勾子 exthook.py

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

## 扩展 ext/

<br>

# 2 flask依赖模块

## click

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

示例DEMO：

```python
import click

@click.command()
@click.option("--count", default=1, help="Number of greetings.")
@click.option("--name", prompt="Your name",
              help="The person to greet.")
def hello(count, name):
    """Simple program that greets NAME for a total of COUNT times."""
    for _ in range(count):
        click.echo("Hello, %s!" % name)

if __name__ == '__main__':
    hello()
```

以下是命令行

```shell
$ python hello.py --count=3
Your name: Click
Hello, Click!
Hello, Click!
Hello, Click!
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

## werkzeug

[pallets/werkzeug](https://github.com/pallets/werkzeug)  [Documentation](https://werkzeug.palletsprojects.com/)  [Changes](https://werkzeug.palletsprojects.com/en/2.0.x/changes/)   [Releases on PyPI](https://pypi.python.org/pypi/Werkzeug)

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

示例DEMO：

```python
from werkzeug.wrappers import Request, Response

@Request.application
def application(request):
    return Response("Hello, World!")

if __name__ == "__main__":
    from werkzeug.serving import run_simple
    run_simple("localhost", 5000, application)
```

表格 werkzeug版本说明 详见 [Changes](https://werkzeug.palletsprojects.com/en/2.0.x/changes/)

| 版本号    | 发布时间       | 功能或更新说明                      |
| ------ | ---------- | ---------------------------- |
| 0.1    | 2010-04-16 | 第一个公共发布版本。                   |
| 0.16.1 | 2020-01-27 | 0.x系列最后一个版本。                 |
| 1.0.0  | 2020-02-06 | 大版本。                         |
| 1.0.1  | 2020-03-31 | 1.x系列仅发布了2个小版本，即1.0.0和1.0.1。 |
| 2.0.0  | 2021-05-11 |                              |

说明：2020.2开始，flask 1.x+版本盯紧werkzeug，二者大/中版本基本保持一致。

### 源码结构

表格 werkzeug源码结构

| 目录或文件             | 主要类或函数                                                                                                   | 说明                             |
| ----------------- | -------------------------------------------------------------------------------------------------------- | ------------------------------ |
| debug/            |                                                                                                          | 扩展模块                           |
| middleware/       | 文件：dispatcher.py http_proxy.py lint.py profiler.py proxy_fix.py shared_data.py<br>类：DispatcherMiddleware | 中间件包括代理、共享数据                   |
| wrappers/         |                                                                                                          | 包括cors, etag, auth, user_agent |
| _compat.py        |                                                                                                          | 兼容py2和py3的类型和函数。`flake8: noqa` |
| _internal.py      | _log                                                                                                     | 提供内部用的helper和常量                |
| _reloader.py      | ReloaderLoop StatReloaderLoop  WatchdogReloaderLoop                                                      | 模块重载实现                         |
| datastructures.py |                                                                                                          | 用到的数据结构                        |
| exceptions.py     | BadRequest                                                                                               | 异常，多继承自HTTPException           |
| filesystem.py     | get_filesystem_encoding                                                                                  | 文件系统                           |
| http.py           | parse_date ...                                                                                           | 处理http数据的一组函数                  |
| local.py          |                                                                                                          | 本地代理/数据栈                       |
| posixemulation.py | rename                                                                                                   | POSIX模拟器                       |
| routing.py        | BaseConverter AnyConverter RuleFactory Rule                                                              | 路由相关的转化器、规则类                   |
| security.py       | check_password_hash generate_password_hash gen_salt safe_join safe_str_cmp                               | 安全相关工具，如密码哈希工具                 |
| serving.py        | BaseWSGIServer ForkingMixIn ForkingWSGIServer ThreadedWSGIServer WSGIRequestHandler                      | 请求处理方式。多进程/多线程/单进程线程。          |
| test.py           | run_wsgi_app                                                                                             | WSGI客户端应用测试                    |
| testapp.py        | test_app                                                                                                 | 测试WSGI服务端                      |
| urls.py           | 类：_URLTuple BaseURL  BytesURL URL Href  <br>函数：url_parse url_quote                                       | URL解析                          |
| useragents.py     | UserAgent UserAgentParser                                                                                | 用户代理                           |
| utils.py          |                                                                                                          | 工具                             |
| wsgi.py           | ClosingIterator FileWrapper LimitedStream                                                                | WSGI服务                         |

### 服务 serving.py

近一千行。

**说明**：Flask::run (flask/app.py) 调用了 serving.py里的run_simple函数，最终make_server() 调用了HTTPServer.serve_forever (lib/socketserver.py)进入到后台处理过程。

**处理链**： run_simple ->  inner -> make_server, serve_forever

#### 服务器创建 make_server

根据入参threaded/processes 来启动相应的WSGI服务器，然后各服务器调用相应的 serve_forever方法。

* ThreadedWSGIServer：threaded为True，启动一个后台线程来处理请求。
* ForkingWSGIServer：processes>1，启动一个fork进程来处理请求。
* BaseWSGIServer：缺省服务。总共1进程1线程，监听队列长度120，加入监听队列，等待poll或epoll监听。

/wrkzeug/serving.py

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
        # 实际的启动函数，无论是否重载都要调用此函数
        try:
            fd = int(os.environ["WERKZEUG_SERVER_FD"])
        except (LookupError, ValueError):
            fd = None
        srv = make_server( hostname,port,application,threaded,processes,request_handler,
                          passthrough_errors,ssl_context,fd=fd,)
        if fd is None:
            log_startup(srv.socket)
        srv.serve_forever()  # 服务器后台处理

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
        inner()    # 实际启动函数

def make_server(
    host=None,
    port=None,
    app=None,
    threaded=False,    # 是否每个请求对应一个独立线程
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

三种WSGI服务:   都继承了 BaseWSGIServer，初始化方法不一样，但都是通过 `BaseWSGIServer.serve_forever()`进入到实际处理。

* ThreadedWSGIServer： 调用 ThreadingMixIn.process_request()
* ForkingWSGIServer：调用 ForkMixIn.process_request()
* BaseWSGIServer:  最终调用原生模块 `lib/socketserver.py:BaseServer.serve_forever() `

```python
import socketserver

ThreadingMixIn = socketserver.ThreadingMixIn      # 线程类
can_fork = hasattr(os, "fork")  # 判断是否支持fork
if can_fork:
    ForkingMixIn = socketserver.ForkingMixIn    # 进程类
else:
    class ForkingMixIn(object):
        pass

class ThreadedWSGIServer(ThreadingMixIn, BaseWSGIServer):
    """A WSGI server that does threading. 调用 ThreadingMixIn.process_request() """

    multithread = True
    daemon_threads = True

class ForkingWSGIServer(ForkingMixIn, BaseWSGIServer):

    """A WSGI server that does forking. 调用 ForkMixIn.process_request() """

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
    """
    Simple single-threaded, single-process WSGI server.
    类继承：BaseWSGIServer -> HTTPServer -> TCPServer -> BaseServer
    """
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
        """ 服务器后台处理函数 """
        self.shutdown_signal = False
        try:
            HTTPServer.serve_forever(self) #HTTPServer实质调用父类BaseServer.serve_forever
        except KeyboardInterrupt:
            pass
        finally:
            self.server_close()
```

服务器创建后，调用BaseServer.serve_forever。

BaseServer.serve_forever 参见 《[python源码剖析](python源码剖析.md)》标准模块章节

服务器类体系：HTTPServer (lib/http/server.py)  -> TCPServer(lib/socketserver.py) ->  BaseServer(lib/socketserver.py)

**BaseServer.serve_forever**:  poll或select方式监听，然后非阻塞方式处理请求，如下，

```shell
# BaseServer.serve_forever处理流程
selector.select(poll_interval) -> self._handle_request_noblock (非阻塞处理请求)
        --> get_request, verify_request, process_request(一般派生类要重载,调用finish_request),  shutdown_request(异常时)
-> self.service_actions()

# process_request实现中的finish_request处理流程： BaseRequestHandler.handle()
```

#### 请求处理 WSGIRequestHandler

WSGIRequestHandler 重载父类方法 handle和handle_one_request，调用run_wsgi实现自己的写方式。

```python
try:
    import socketserver
    from http.server import BaseHTTPRequestHandler
    from http.server import HTTPServer
except ImportError:
    import SocketServer as socketserver
    from BaseHTTPServer import HTTPServer
    from BaseHTTPServer import BaseHTTPRequestHandler


class WSGIRequestHandler(BaseHTTPRequestHandler, object):
    """重载父类的handle_one_request，在这方法调用run_wsgi实现自己的写方式"""
    def run_wsgi(self):
        if self.headers.get("Expect", "").lower().strip() == "100-continue":
            self.wfile.write(b"HTTP/1.1 100 Continue\r\n\r\n")

        self.environ = environ = self.make_environ()
        headers_set = []
        headers_sent = []

        def write(data):    # 重新实现写方法
            assert headers_set, "write() before start_response"
            if not headers_sent:
                status, response_headers = headers_sent[:] = headers_set
                try:
                    code, msg = status.split(None, 1)
                except ValueError:
                    code, msg = status, ""
                code = int(code)
                self.send_response(code, msg)    #设置响应头 和 日志
                header_keys = set()
                for key, value in response_headers:
                    self.send_header(key, value)
                    key = key.lower()
                    header_keys.add(key)
                if not (
                    "content-length" in header_keys
                    or environ["REQUEST_METHOD"] == "HEAD"
                    or code < 200
                    or code in (204, 304)
                ):
                    self.close_connection = True
                    self.send_header("Connection", "close")
                if "server" not in header_keys:
                    self.send_header("Server", self.version_string())
                if "date" not in header_keys:
                    self.send_header("Date", self.date_time_string())
                self.end_headers()

            assert isinstance(data, bytes), "applications must write bytes"
            if data:
                # Only write data if there is any to avoid Python 3.5 SSL bug
                self.wfile.write(data)
            self.wfile.flush()

    def handle(self):
        """Handles a request ignoring dropped connections."""
        try:
            BaseHTTPRequestHandler.handle(self)    #直接调用父类的handle
        except (_ConnectionError, socket.timeout) as e:
            self.connection_dropped(e)
        except Exception as e:
            if self.server.ssl_context is None or not is_ssl_error(e):
                raise
        if self.server.shutdown_signal:  #处理shutdown信号
            self.initiate_shutdown()

    def handle_one_request(self):
        """Handle a single HTTP request."""
        self.raw_requestline = self.rfile.readline()
        if not self.raw_requestline:
            self.close_connection = 1
        elif self.parse_request():    #如果请求可以被解析
            return self.run_wsgi()      #运行wsgi，实行的请求过程处理

    def send_response(self, code, message=None):
        """Send the response header and log the response code."""
        self.log_request(code)    #日志处理，打印 请求行基本信息
        if message is None:
            message = code in self.responses and self.responses[code][0] or ""
        if self.request_version != "HTTP/0.9":
            hdr = "%s %d %s\r\n" % (self.protocol_version, code, message)
            self.wfile.write(hdr.encode("ascii"))
```

### 本地代理/数据栈 local.py

背景：使用thread local对象（`from threading import local`）虽然可以基于线程存储全局变量，但是在Web应用中可能会存在如下问题：

1. 协程中不能保证数据隔离，因为一个线程里可能有多个协程。
2. 线程会连续处理请求，上一次处理的数据并不能保证清空。

因此，Werkzeug开发了自己的local对象。

* Local对象：结构类似dict，用dict的常用方法。通过线程ID或协程ID，提供了线程/协程隔离的数据访问方式。
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
        # 属性：__storage__初始化为空字典，__ident_func__调用get_ident
        object.__setattr__(self, "__storage__", {})                #存储实际的数据，字典
        object.__setattr__(self, "__ident_func__", get_ident)    #获取线程/协程ID方法


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
        if callable(local) and not hasattr(local, "__release_local__"):     # 代理对象local必须是可调用的
            # "local" is a callable that is not an instance of Local or
            # LocalManager: mark it as a wrapped function.
            object.__setattr__(self, "__wrapped__", local)
```

### 中间件 /middleware/

* dispatcher.py  DispatcherMiddleware类实现

/werkzeug/middleware/dispatcher.py

[Application Dispatching](http://flask.pocoo.org/docs/0.12/patterns/appdispatch/#app-dispatch)是WSGI工具箱werkzeug提供的一种技术，目的是将多个Flask应用按URL前缀组合成一个应用。

```python
class DispatcherMiddleware(object):
    """Combine multiple applications as a single WSGI application.
    Requests are dispatched to an application based on the path it is
    mounted under.

    :param app: The WSGI application to dispatch to if the request
        doesn't match a mounted path.
    :param mounts: Maps path prefixes to applications for dispatching.
    示例：
    app = DispatcherMiddleware(serve_frontend, {
        '/api': api_app,
        '/admin': admin_app,
    })
    """

    def __init__(self, app, mounts=None):
        self.app = app
        self.mounts = mounts or {}

    def __call__(self, environ, start_response):
        script = environ.get("PATH_INFO", "")
        path_info = ""

        while "/" in script:
            if script in self.mounts:
                app = self.mounts[script]
                break

            script, last_item = script.rsplit("/", 1)
            path_info = "/%s%s" % (last_item, path_info)
        else:
            app = self.mounts.get(script, self.app)

        original_script_name = environ.get("SCRIPT_NAME", "")
        environ["SCRIPT_NAME"] = original_script_name + script
        environ["PATH_INFO"] = path_info
        return app(environ, start_response)
```

说明：app dispatch技术实现了app的隔离（独立的login manager、secret_key等），同时让每层业务系统都能模块化（只关心自己的URL部分），很有用。

### 安全 security.py

/werkzeug/security.py

包括密码HASH，字符串安全比较、安全拼接。

密码+盐值的HASH值，通常用来存储用户密码。

用户注册:  用户提供密码+随机盐值，生成HASH密码。用上面内容用$分割保存成`method$salt$hash_pwd` 写入到DB的密码项。

身份验证：先从DB取出密码项HASH，分别获取到方法、盐值和HASH密码；使用用户传输密码和获取到的盐值生成HASH密码，再比对二者的HASH密码是否一致。

```python
import codecs
import hashlib
import hmac
from random import SystemRandom


SALT_CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
DEFAULT_PBKDF2_ITERATIONS = 150000


def generate_password_hash(password, method="pbkdf2:sha256", salt_length=8):
    """ 用给的salt值长度 和 method 获取hash值 """
    salt = gen_salt(salt_length) if method != "plain" else ""
    h, actual_method = _hash_internal(method, salt, password)
    return "%s$%s$%s" % (actual_method, salt, h)

def check_password_hash(pwhash, password):
    """
    pbkdf2:method:iterations 比如
        pbkdf2:sha256:80000$salt$hash
           pbkdf2:sha256$salt$hash
    示例：pbkdf2:sha256:150000$Q8pN9sv3$5208bb8d9930777039a21d46a26f0fb83dc7d31fecb42d59fa233b1e5ef322ad
    """
    if pwhash.count("$") < 2:
        return False
    method, salt, hashval = pwhash.split("$", 2)
    return safe_str_cmp(_hash_internal(method, salt, password)[0], hashval)

def gen_salt(length):
    """Generate a random string of SALT_CHARS with specified ``length``. 根据长度，获取盐串中随机值 """
    if length <= 0:
        raise ValueError("Salt length must be positive")
    return "".join(_sys_rng.choice(SALT_CHARS) for _ in range_type(length))

def safe_str_cmp(a, b):
    """ 会将a,b编码统一转化成 unicode """


def safe_join(directory, *pathnames):
    """Safely join zero or more untrusted path components to a base
    directory to avoid escaping the base directory.

    :param directory: The trusted base directory.
    :param pathnames: The untrusted path components relative to the
        base directory.
    :return: A safe path, otherwise ``None``.
    """
    parts = [directory]

    for filename in pathnames:
        if filename != "":
            filename = posixpath.normpath(filename)

        if (
            any(sep in filename for sep in _os_alt_seps)
            or os.path.isabs(filename)
            or filename == ".."
            or filename.startswith("../")
        ):
            return None

        parts.append(filename)

    return posixpath.join(*parts)
```

### 日志

打印请求行基本信息

```python
# /werkzeug/serving.py
from ._internal import _log

class WSGIRequestHandler(BaseHTTPRequestHandler, object):
    """ 日志调用函数链：run_wsgi.write -> send_response -> log_request -> log """
    def log(self, type, message, *args):
        """
        示例：
        INFO:werkzeug:127.0.0.1 - - [17/Sep/2021 12:06:50] "GET /swagger/v1 HTTP/1.1" 200 -
        """
        _log(
            type,
            "%s - - [%s] %s\n"
            % (self.address_string(), self.log_date_time_string(), message % args),
        )
```

/werkzeug/_internal.py

```python
import logging

_logger = None

def _log(type, message, *args, **kwargs):
    """Log a message to the 'werkzeug' logger.

    The logger is created the first time it is needed. If there is no
    level set, it is set to :data:`logging.INFO`. If there is no handler
    for the logger's effective level, a :class:`logging.StreamHandler`
    is added.
    """
    global _logger

    if _logger is None:    # 如果未设置 _logger，则设置日志流处理StreamHandler
        _logger = logging.getLogger("werkzeug")
        if _logger.level == logging.NOTSET:
            _logger.setLevel(logging.INFO)

        if not _has_level_handler(_logger):
            _logger.addHandler(logging.StreamHandler())

    getattr(_logger, type)(message.rstrip(), *args, **kwargs)
```

## jinja2

参考 《[WEB前端框架](WEB前端框架.md)》相关章节

依赖于模块 MarkupSafe

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

示例DEMO：

```html
{% extends "layout.html" %}
{% block body %}
  <ul>
  {% for user in users %}
    <li><a href="{{ user.url }}">{{ user.username }}</a></li>
  {% endfor %}
  </ul>
{% endblock %}
```

### 源码结构

表格 Jinja2源码结构

| 文件              | 主要类或函数                                                                | 简介    |
| --------------- | --------------------------------------------------------------------- | ----- |
| asyncfilters.py |                                                                       | 异步过滤器 |
| asyncsupport.py |                                                                       | 异步支持  |
| bccache.py      |                                                                       |       |
| compiler.py     |                                                                       |       |
| constants.py    |                                                                       | 常量    |
| environment.py  | Environment Template TemplateExpression TemplateModule TemplateStream | 环境变量  |
| filters.py      |                                                                       | 过滤器   |
| lexer.py        |                                                                       |       |
| loaders.py      |                                                                       | 加载器   |
| meta.py         |                                                                       | 元数据   |
| nativetypes.py  |                                                                       | 原生类型  |
| nodes.py        |                                                                       |       |
| optimizer.py    |                                                                       | 优化    |
| parser.py       |                                                                       | 解析器   |
| runtime.y       |                                                                       |       |
| sandbox.py      |                                                                       | 沙盒    |
| utils.py        |                                                                       | 工具    |
| visitor.py      |                                                                       |       |

### 环境 environment.py

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

## itsdangerous

```shell
$ pip show itsdangerous
Name: itsdangerous
Version: 2.0.1
Summary: Safely pass data to untrusted environments and back.
Home-page: https://palletsprojects.com/p/itsdangerous/
Author: Armin Ronacher
Author-email: armin.ronacher@active-4.com
License: BSD-3-Clause
Location: d:\dev\langs\python\python37\lib\site-packages
Requires:
Required-by: Flask
```

安全传递数据到不可信任环境和后端。

示例DEMO：

```python
from itsdangerous import URLSafeSerializer

# 此处二个参数secret key和salt 要妥善保存，如果泄露，数据将不再安全
auth_s = URLSafeSerializer("secret key", "auth")
token = auth_s.dumps({"id": 5, "name": "itsdangerous"})

print(token)
# eyJpZCI6NSwibmFtZSI6Iml0c2Rhbmdlcm91cyJ9.6YP6T0BaO67XP--9UzTrmurXSmg
# 生成的token经过 zlib压缩+base64编码+签名

data = auth_s.loads(token)
print(data["name"])
# itsdangerous
```

### 源码结构

表格 itsdangerous源码结构

| 文件           | 主要类或函数                                                          | 简介        |
| ------------ | --------------------------------------------------------------- | --------- |
| url_safe.py  | URLSafeSerializerMixin URLSafeSerializer URLSafeTimedSerializer | url安全序列化器 |
| serialize.py | Serialize                                                       | 序列化类      |
| signer.py    | SigningAlgorithm Signer                                         | 签名和签名算法   |
| encoding.py  | base64_encode base64_decode int_to_bytes bytes_to_int           | 编码        |
| exc.py       |                                                                 | 异常        |
| jws.py       | JSONWebSignatureSerializer TimedJSONWebSignatureSerializer      | JSON序列化   |
| timed.py     | TimedSerializer TimestampSigner                                 | 时间序列化和签名  |
| _json.py     | _CompactJSON                                                    | json兼容    |

/itsdangerous/url_safe.py

```python
import zlib

from ._json import _CompactJSON
from .encoding import base64_decode
from .encoding import base64_encode
from .exc import BadPayload
from .serializer import Serializer
from .timed import TimedSerializer


class URLSafeSerializerMixin(object):

    def dump_payload(self, obj):
        json = super(URLSafeSerializerMixin, self).dump_payload(obj)
        is_compressed = False
        compressed = zlib.compress(json)    #压缩
        if len(compressed) < (len(json) - 1):
            json = compressed
            is_compressed = True
        base64d = base64_encode(json)        #base64编码
        if is_compressed:
            base64d = b"." + base64d
        return base64d

    def load_payload(self, payload, *args, **kwargs):
        decompress = False
        if payload.startswith(b"."):
            payload = payload[1:]
            decompress = True
        try:
            json = base64_decode(payload)
        except Exception as e:
            raise BadPayload(
                "Could not base64 decode the payload because of an exception",
                original_error=e,
            )
        if decompress:
            try:
                json = zlib.decompress(json)
            except Exception as e:
                raise BadPayload(
                    "Could not zlib decompress the payload before decoding the payload",
                    original_error=e,
                )
        return super(URLSafeSerializerMixin, self).load_payload(json, *args, **kwargs)


class URLSafeSerializer(URLSafeSerializerMixin, Serializer):
class URLSafeTimedSerializer(URLSafeSerializerMixin, TimedSerializer):
```

/itsdangerous/serialize.py

```python
class Serializer(object):
    """ 加载一个安全KEY 和 一个盐值 """
    def __init__(
        self,
        secret_key,
        salt=b"itsdangerous",
        serializer=None,
        serializer_kwargs=None,
        signer=None,
        signer_kwargs=None,
        fallback_signers=None,
    ):

    def dumps(self, obj, salt=None):
        """Returns a signed string serialized with the internal
        serializer. The return value can be either a byte or unicode
        string depending on the format of the internal serializer.
        """
        payload = want_bytes(self.dump_payload(obj))    #zlib压缩后base64编码
        rv = self.make_signer(salt).sign(payload)          #生成签名
        if self.is_text_serializer:
            rv = rv.decode("utf-8")
        return rv

    def loads(self, s, salt=None):
        """Reverse of :meth:`dumps`. Raises :exc:`.BadSignature` if the
        signature validation fails.
        """
        s = want_bytes(s)  #返回bytes类型
        last_exception = None
        for signer in self.iter_unsigners(salt):
            try:
                return self.load_payload(signer.unsign(s))
            except BadSignature as err:
                last_exception = err
        raise last_exception

    def make_signer(self, salt=None):
        """Creates a new instance of the signer to be used. The default
        implementation uses the :class:`.Signer` base class.
        """
        if salt is None:
            salt = self.salt
        return self.signer(self.secret_key, salt=salt, **self.signer_kwargs)
```

/itsdangerous/signer.py

```python
class SigningAlgorithm(object):
    def get_signature(self, key, value):
        """Returns the signature for the given key and value."""
        raise NotImplementedError()

    def verify_signature(self, key, value, sig):
        """Verifies the given signature matches the expected
        signature.
        """
        return constant_time_compare(sig, self.get_signature(key, value))


class NoneAlgorithm(SigningAlgorithm):
    def get_signature(self, key, value):
        return b""

class HMACAlgorithm(SigningAlgorithm):
    """Provides signature generation using HMACs."""

    #: The digest method to use with the MAC algorithm. This defaults to
    #: SHA1, but can be changed to any other function in the hashlib
    #: module.
    default_digest_method = staticmethod(hashlib.sha1)

    def __init__(self, digest_method=None):
        if digest_method is None:
            digest_method = self.default_digest_method
        self.digest_method = digest_method

    def get_signature(self, key, value):
        mac = hmac.new(key, msg=value, digestmod=self.digest_method)
        return mac.digest()


class Signer(object):

    def sign(self, value):
        """Signs the given string."""
        return want_bytes(value) + want_bytes(self.sep) + self.get_signature(value)
```

## markupsafe

安全地使用HTML和XML字符。

```SH
$ pip show markupsafe
Name: MarkupSafe
Version: 2.0.1
Summary: Safely add untrusted strings to HTML/XML markup.
Home-page: https://palletsprojects.com/p/markupsafe/
Author: Armin Ronacher
Author-email: armin.ronacher@active-4.com
License: BSD-3-Clause
Location: d:\dev\langs\python\python37\lib\site-packages
Requires:
Required-by: Jinja2
```

示例DEMO：

```python
>>> from markupsafe import Markup, escape
>>> # escape replaces special characters and wraps in Markup
>>> escape('<script>alert(document.cookie);</script>')
Markup(u'<script>alert(document.cookie);</script>')
>>> # wrap in Markup to mark text "safe" and prevent escaping
>>> Markup('<strong>Hello</strong>')
Markup('<strong>hello</strong>')
>>> escape(Markup('<strong>Hello</strong>'))
Markup('<strong>hello</strong>')
>>> # Markup is a text subclass (str on Python 3, unicode on Python 2)
>>> # methods and operators escape their arguments
>>> template = Markup("Hello <em>%s</em>")
>>> template % '"World"'
Markup('Hello <em>&#34;World&#34;</em>')
```

<br>

# 3  扩展模块

## 推荐模块

| 模块名              | 功能                                                                                                                                                                                                  | 文档                                                                                                                 | 源码                                              | 最后版本&更新           |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------- | ----------------- |
| flask_appbuilder | Flask-AppBuilder功能强大，同时需要依赖很多flask扩展，如`Flask-SQLAlchemy, Flask-JWT-Extended, Flask-Login, Flask, Flask-Babel, Flask-WTF, Flask-OpenID`                                                              | https://flask-appbuilder.readthedocs.io/en/latest/ or [flaskappbulder](http://flaskappbuilder.pythonanywhere.com/) | https://github.com/dpgaspar/flask-appbuilder/   | v3.3.3, 2021.9.14 |
| flask_migrate    | SQLAlchemy database migrations for Flask applications using Alembic.<br>[Change Log](https://github.com/miguelgrinberg/Flask-Migrate/blob/master/CHANGES.md)                                        | http://flask-migrate.readthedocs.io/en/latest/                                                                     | http://github.com/miguelgrinberg/flask-migrate/ | 3.0.1, 2021.8     |
| flask_caching    | Adds caching support to your Flask application                                                                                                                                                      | http://www.pythondoc.com/flask-cache/index.html                                                                    | https://github.com/sh4nks/flask-caching         | 1.10.1, 2021.3.18 |
| flask_cors       | A Flask extension adding a decorator for CORS support. Cross Origin Resource Sharing ( CORS ) support for Flask.<br>[Changelog](https://github.com/corydolphin/flask-cors/blob/master/CHANGELOG.md) | [flask-cors.corydolphin.com/](https://flask-cors.corydolphin.com/)                                                 | https://github.com/corydolphin/flask-cors       | 3.0.10, 2021.1.5  |
| flask_restx      | 使用 Flask 进行快速、简单和文档化的 API 开发的全功能框架。<BR>Flask-RESTX is a community driven fork of [Flask-RESTPlus](https://github.com/noirbizarre/flask-restplus)，于2020.1创建。                                         | [flask-restx.readthedocs.io/en/latest/](https://flask-restx.readthedocs.io/en/latest/)                             | https://github.com/python-restx/flask-restx     | 0.5.1, 2021.9.4   |

说明：受欢迎的模块会慢慢由一个组织来托管，不再放到个人仓库名下，这样更有利于社区协作。

## 废弃模块.deprecated

| 模块名                | 功能                                                                                            | 文档                                                         | 源码仓库                                                                               | 最后版本&更新           | 废弃原因                            |
| ------------------ | --------------------------------------------------------------------------------------------- | ---------------------------------------------------------- | ---------------------------------------------------------------------------------- | ----------------- | ------------------------------- |
| flask_restful      | 文档老旧，不可用。<br>添加了快速构建 REST APIs 的支持。它当然也是一个能够跟你现有的ORM/库协同工作的轻量级的扩展。Flask-RESTful 鼓励以最小设置的最佳实践。 | http://www.pythondoc.com/Flask-RESTful/index.html          | [flask-restful/flask-restful](https://www.github.com/flask-restful/flask-restful/) | v0.3.9, 2020      | 要求 Python 版本为 2.6, 2.7, 或者 3.3。 |
| ~~flask_restplus~~ | 增加了对快速构建 REST API 的支持。它提供了一系列连贯的装饰器和工具来描述您的 API 并正确公开其文档（使用 Swagger）。                         | https://flask-restplus.readthedocs.io/en/stable/index.html | [noirbizarre/flask-restplus](https://github.com/noirbizarre/flask-restplus)        | 0.13.0, 2020.1.13 | 被社区版flask-restx替换               |

## flask_appbuilder源码剖析

详见 《[flask_appbuilder源码剖析.md](./flask_appbuilder源码剖析.md)》

Flask-AppBuilder功能强大，同时需要依赖很多flask扩展，如`Flask-SQLAlchemy, Flask-JWT-Extended, Flask-Login, Flask, Flask-Babel, Flask-WTF, Flask-OpenID`

## flask_migrate

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

### 源码结构

* `/flask_migrate/__init__.py`    定义配置类

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

### db命令 cli.py

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

## flask_caching

http://www.pythondoc.com/flask-cache/index.html

```shell
$ pip show flask_caching
Name: Flask-Caching
Version: 1.10.1
Summary: Adds caching support to your Flask application
Home-page: https://github.com/sh4nks/flask-caching
Author: Peter Justin
Author-email: peter.justin@outlook.com
License: BSD
Location: ~\superset-py38-env\lib\site-packages
Requires: Flask
Required-by: apache-superset
```

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

## flask_cors

https://flask-cors.corydolphin.com/en/latest/index.html

CORS，跨域资源共享。

A Flask extension for handling Cross Origin Resource Sharing (CORS), making cross-origin AJAX possible.

```shell
$ pip show flask_cors
Name: Flask-Cors
Version: 3.0.10
Summary: A Flask extension adding a decorator for CORS support
Home-page: https://github.com/corydolphin/flask-cors
Author: Cory Dolphin
Author-email: corydolphin@gmail.com
License: MIT
Location: ~\superset-py38-env\lib\site-packages
Requires: Flask, Six
Required-by:
```

源文件

* core.py  用于扩展和装饰器的函数
* decoratory.py  装饰器1个是cross_origin
* extension.py

/flask_cors/core.py

```python
from six import string_types
from flask import request, current_app
from werkzeug.datastructures import Headers, MultiDict

def serialize_options(opts):
    """
    options序列化参数： origins allow_headers
        supports_credentials send_wildcard expose_headers methods max_age
    A helper method to serialize and processes the options dictionary.
    """
    options = (opts or {}).copy()

    for key in opts.keys():
        if key not in DEFAULT_OPTIONS:
            LOG.warning("Unknown option passed to Flask-CORS: %s", key)

    # Ensure origins is a list of allowed origins with at least one entry.
    options['origins'] = sanitize_regex_param(options.get('origins'))
    options['allow_headers'] = sanitize_regex_param(options.get('allow_headers'))

    # This is expressly forbidden by the spec. Raise a value error so people
    # don't get burned in production.
    if r'.*' in options['origins'] and options['supports_credentials'] and options['send_wildcard']:
        raise ValueError("Cannot use supports_credentials in conjunction with"
                         "an origin string of '*'. See: "
                         "http://www.w3.org/TR/cors/#resource-requests")



    serialize_option(options, 'expose_headers')
    serialize_option(options, 'methods', upper=True)

    if isinstance(options.get('max_age'), timedelta):
        options['max_age'] = str(int(options['max_age'].total_seconds()))

    return options
```

/flask_cors/decoratory.py

```python
from functools import update_wrapper
from flask import make_response, request, current_app
from .core import *

LOG = logging.getLogger(__name__)

def cross_origin(*args, **kwargs):
    """ 跨域，包装flask路由缺省参数以支持跨域 """
    _options = kwargs

    def decorator(f):
        LOG.debug("Enabling %s for cross_origin using options:%s", f, _options)

        # If True, intercept OPTIONS requests by modifying the view function,
        # replicating Flask's default behavior, and wrapping the response with
        # CORS headers.
        #
        # If f.provide_automatic_options is unset or True, Flask's route
        # decorator (which is actually wraps the function object we return)
        # intercepts OPTIONS handling, and requests will not have CORS headers
        if _options.get('automatic_options', True):
            f.required_methods = getattr(f, 'required_methods', set())
            f.required_methods.add('OPTIONS')
            f.provide_automatic_options = False

        def wrapped_function(*args, **kwargs):
            # Handle setting of Flask-Cors parameters
            options = get_cors_options(current_app, _options)

            if options.get('automatic_options') and request.method == 'OPTIONS':
                resp = current_app.make_default_options_response()
            else:
                resp = make_response(f(*args, **kwargs))

            set_cors_headers(resp, options)
            setattr(resp, FLASK_CORS_EVALUATED, True)
            return resp

        return update_wrapper(wrapped_function, f)
    return decorator
```

/falsk_cors/extension.py

```python
from flask import request
from .core import *

class CORS(object):
    """
    The settings for CORS are determined in the following order

    1. Resource level settings (e.g when passed as a dictionary)
    2. Keyword argument settings
    3. App level configuration settings (e.g. CORS_*)
    4. Default settings
    """
    def __init__(self, app=None, **kwargs):
        self._options = kwargs
        if app is not None:
            self.init_app(app, **kwargs)

    def init_app(self, app, **kwargs):
        # The resources and options may be specified in the App Config, the CORS constructor
        # or the kwargs to the call to init_app.
        options = get_cors_options(app, self._options, kwargs)

        # Flatten our resources into a list of the form
        # (pattern_or_regexp, dictionary_of_options)
        resources = parse_resources(options.get('resources'))

        # Compute the options for each resource by combining the options from
        # the app's configuration, the constructor, the kwargs to init_app, and
        # finally the options specified in the resources dictionary.
        resources = [
                     (pattern, get_cors_options(app, options, opts))
                     for (pattern, opts) in resources
                    ]

        # Create a human readable form of these resources by converting the compiled
        # regular expressions into strings.
        resources_human = {get_regexp_pattern(pattern): opts for (pattern,opts) in resources}
        LOG.debug("Configuring CORS with resources: %s", resources_human)

        cors_after_request = make_after_request_function(resources)
        app.after_request(cors_after_request)

        # Wrap exception handlers with cross_origin
        # These error handlers will still respect the behavior of the route
        if options.get('intercept_exceptions', True):
            def _after_request_decorator(f):
                def wrapped_function(*args, **kwargs):
                    return cors_after_request(app.make_response(f(*args, **kwargs)))
                return wrapped_function

            if hasattr(app, 'handle_exception'):
                app.handle_exception = _after_request_decorator(
                    app.handle_exception)
                app.handle_user_exception = _after_request_decorator(
                    app.handle_user_exception)

def make_after_request_function(resources):
    def cors_after_request(resp):
        # If CORS headers are set in a view decorator, pass
        if resp.headers is not None and resp.headers.get(ACL_ORIGIN):
            LOG.debug('CORS have been already evaluated, skipping')
            return resp
        normalized_path = unquote_plus(request.path)
        for res_regex, res_options in resources:
            if try_match(normalized_path, res_regex):
                LOG.debug("Request to '%s' matches CORS resource '%s'. Using options: %s",
                      request.path, get_regexp_pattern(res_regex), res_options)
                set_cors_headers(resp, res_options)
                break
        else:
            LOG.debug('No CORS rule matches')
        return resp
    return cors_after_request
```

## flask_restx

使用 Flask 进行快速、简单和文档化的 API 开发的全功能框架。

```python
$ pip show flask-restx
Name: flask-restx
Version: 0.5.1
Summary: Fully featured framework for fast, easy and documented API development with Flask
Home-page: https://github.com/python-restx/flask-restx
Author: python-restx Authors
Author-email: None
License: BSD-3-Clause
Location: d:\dev\langs\python\python37\lib\site-packages
Requires: Flask, six, jsonschema, aniso8601, werkzeug, pytz
Required-by:
```

说明：依赖于flask-2.0.0，flask-2.0.1则导入werkzeug出错。

### 源码结构及示例

表格 flask-restx源码结构

| 目录或文件              | 主要类或函数                                                         | 说明                  |
| ------------------ | -------------------------------------------------------------- | ------------------- |
| schemas/           | LazySchema validate                                            |                     |
| static/            |                                                                | 静态文件                |
| templates/         | swagger-ui.html swagger-ui-css.html  swagger-ui-libs.html      | 模板                  |
| api.py             | Api SwaggerView                                                | Api类管理API文档         |
| apidoc.py          | Apidoc swagger_static ui_for                                   | API文档蓝图             |
| cors.py            | crossdomain                                                    | 跨域                  |
| errors.py          | abort RestError ValidationError SpecsError                     | 错误或异常               |
| fields.py          | Raw String Url ...                                             | 字段。定义API参数          |
| inputs.py          | boolean date ...                                               | 高级类型解析              |
| marshaling.py      | 类：marshal_with marshal_with_field<br>函数：marshal make           | 接口返回结果              |
| mask.py            | Mask                                                           |                     |
| model.py           | ModelBase RawModel Model OrderedModel SchemaModel              | 模型                  |
| namespace.py       | Namespace                                                      | 名字空间                |
| postman.py         | Request  Folder PostmanCollectionV1                            | postman工具类          |
| representations.py | output_json                                                    | 输出JSON数据            |
| reqparse.py        | Argument ParseResult RequestParser                             | 请求解析                |
| resource.py        | Resource                                                       | 资源。每个路由是一个资源，有各种方法。 |
| swagger.py         | Swagger                                                        | Swagger文档           |
| utils.py           | merge camel_to_dash default_id not_none not_none_sorted unpack | 工具方法                |

示例DEMO:

```python
from flask import Flask
from flask_restx import Api, Resource, fields

app = Flask(__name__)
api = Api(app, version='1.0', title='TodoMVC API',
    description='A simple TodoMVC API', doc='/'
)
"""
Api类定义了API文档，其路由是参数doc, 路由函数调用缺省模板 apidoc.url_for()
"""

ns = api.namespace('todos', description='TODO operations')    # 第一个参数'todos'为路由前缀

todo = api.model('Todo', {
    'id': fields.Integer(readonly=True, description='The task unique identifier'),
    'task': fields.String(required=True, description='The task details')
})


class TodoDAO(object):
    def __init__(self):
        self.counter = 0
        self.todos = []

    def get(self, id):
        for todo in self.todos:
            if todo['id'] == id:
                return todo
        api.abort(404, "Todo {} doesn't exist".format(id))

    def create(self, data):
        todo = data
        todo['id'] = self.counter = self.counter + 1
        self.todos.append(todo)
        return todo

    def update(self, id, data):
        todo = self.get(id)
        todo.update(data)
        return todo

    def delete(self, id):
        todo = self.get(id)
        self.todos.remove(todo)


DAO = TodoDAO()
DAO.create({'task': 'Build an API'})
DAO.create({'task': '?????'})
DAO.create({'task': 'profit!'})


@ns.route('/')
class TodoList(Resource):
    '''Shows a list of all todos, and lets you POST to add new tasks'''
    @ns.doc('list_todos')
    @ns.marshal_list_with(todo)
    def get(self):
        '''List all tasks for keefe'''
        return DAO.todos

    @ns.doc('create_todo')
    @ns.expect(todo)
    @ns.marshal_with(todo, code=201)
    def post(self):
        '''Create a new task'''
        return DAO.create(api.payload), 201


@ns.route('/<int:id>')
@ns.response(404, 'Todo not found')
@ns.param('id', 'The task identifier')
class Todo(Resource):
    '''Show a single todo item and lets you delete them'''
    @ns.doc('get_todo')
    @ns.marshal_with(todo)
    def get(self, id):
        '''Fetch a given resource'''
        return DAO.get(id)

    @ns.doc('delete_todo')
    @ns.response(204, 'Todo deleted')
    def delete(self, id):
        '''Delete a task given its identifier'''
        DAO.delete(id)
        return '', 204

    @ns.expect(todo)
    @ns.marshal_with(todo)
    def put(self, id):
        '''Update a task given its identifier'''
        return DAO.update(id, api.payload)


if __name__ == '__main__':
    app.run(debug=True, port=5002)
```

说明：Api类管理Api文档。

* 按照REST规范，Resource为资源（每一个路由就是一个资源，每个路由有固定方法如get/post/put/delete/head）。
* Field定义了参数。
* Apidoc继承Blueprints，可以更自由地定义文档结构。
* Namespace可以很好地将资源进行隔离。

### Api对象 api.py

/flask_restx/api.py

```python
from . import apidoc
from .resource import Resource
from .swagger import Swagger

RE_RULES = re.compile("(<.*>)")

class Api(object):
    """
    The main entry point for the application.
    You need to initialize it with a Flask Application: ::

    >>> app = Flask(__name__)
    >>> api = Api(app)
    或者
    >>> api = Api()
    >>> api.init_app(app)
   """

    def __init__(
        self,
        app=None,
        version="1.0",
        title=None,
        description=None,
        terms_url=None,
        license=None,
        license_url=None,
        contact=None,
        contact_url=None,
        contact_email=None,
        authorizations=None,
        security=None,
        doc="/",  #文档路由
        default_id=default_id,
        default="default",
        default_label="Default namespace",
        validate=None,
        tags=None,
        prefix="",    #路由前缀
        ordered=False,
        default_mediatype="application/json",
        decorators=None,
        catch_all_404s=False,
        serve_challenge_on_401=False,
        format_checker=None,
        url_scheme=None,
        **kwargs
    ):
        self._validate = validate
        self._doc = doc            #文档路由str
        self._doc_view = None    #文档视图函数的名称str
        self._default_error_handler = None
        ...

        if app is not None:
            self.app = app
            self.init_app(app)  #初始化应用程序flask_app

    def init_app(self, app, **kwargs):
        self._register_specs(self.blueprint or app)
        self._register_doc(self.blueprint or app)
        ...

    def _register_specs(self, app_or_blueprint):
        """ 注册API文档视图 """
        if self._add_specs:
            endpoint = str("specs")
            self._register_view(
                app_or_blueprint,
                SwaggerView,
                self.default_namespace,
                "/swagger.json",
                endpoint=endpoint,
                resource_class_args=(self,),
            )
            self.endpoints.add(endpoint)

    def _register_doc(self, app_or_blueprint):
        """ 注册文档路由 """
        if self._add_specs and self._doc:
            # Register documentation before root if enabled
            app_or_blueprint.add_url_rule(self._doc, "doc", self.render_doc)
        app_or_blueprint.add_url_rule(self.prefix or "/", "root", self.render_root)

    def render_root(self):
        """ 根路由没找到的返回内容 """
        self.abort(HTTPStatus.NOT_FOUND)

    def render_doc(self):
        """Override this method to customize the documentation page"""
        if self._doc_view:
            return self._doc_view()
        elif not self._doc:
            self.abort(HTTPStatus.NOT_FOUND)
        return apidoc.ui_for(self)   # 渲染缺省模板
```

### apidoc.py

```python
from flask import url_for, Blueprint, render_template

class Apidoc(Blueprint):
    """
    Allow to know if the blueprint has already been registered
    until https://github.com/mitsuhiko/flask/pull/1301 is merged
    """

    def __init__(self, *args, **kwargs):
        self.registered = False
        super(Apidoc, self).__init__(*args, **kwargs)

    def register(self, *args, **kwargs):
        super(Apidoc, self).register(*args, **kwargs)
        self.registered = True

apidoc = Apidoc(
    "restx_doc",
    __name__,
    template_folder="templates",
    static_folder="static",
    static_url_path="/swaggerui",
)


@apidoc.add_app_template_global
def swagger_static(filename):
    return url_for("restx_doc.static", filename=filename)

def ui_for(api):
    """Render a SwaggerUI for a given API, 调用缺省模板 """
    return render_template("swagger-ui.html", title=api.title, specs_url=api.specs_url)
```

## flask_script

示例DEMO:

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

<br>

# 参考资料

**官网**

* [Jinja2 文档](http://jinja.pocoo.org/2/documentation/)

* [Werkzeug 文档](http://werkzeug.pocoo.org/documentation/)  http://werkzeug.pocoo.org/documentation/

**参考链接**

* FLask之Local、LocalStack和LocalProxy介绍 https://blog.csdn.net/weixin_45950544/article/details/103923191
* Jinja2中文文档  http://docs.jinkan.org/docs/jinja2/


