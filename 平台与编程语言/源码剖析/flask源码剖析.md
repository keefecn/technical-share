| 序号 | 修改时间  | 修改内容                                                     | 修改人 | 审稿人 |
| ---- | --------- | ------------------------------------------------------------ | ------ | ------ |
| 1    | 2021-8-23 | 创建。从《python_web框架源码剖析》拆分成文。另拆分flask_appbuilder章节另文。 | Keefe  | Keefe  |
|      |           |                                                              |        |        |







---

#  1 flask源码剖析

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

类方法： run  create_app  register_blueprint  register_db  route/add_url_route

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
        :param add_default_commands True时添加run/shell命令，1.1.4时增加routes命令
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
            self.add_command(routes_command)
            
        self._loaded_plugin_commands = False	#是否加载插件命令，如fab/db
        
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



# 2 flask依赖模块

## werkzeug

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



### 请求处理方式 serving.py

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

```python
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



### 本地代理/数据栈 local.py 

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



## jinja2

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



# 3 扩展模块

## flask_appbuilder源码剖析

详见 《[flask_appbuilder源码剖析.md](./flask_appbuilder源码剖析.md)》

Flask-AppBuilder功能强大，同时需要依赖很多flask扩展，如`Flask-SQLAlchemy, Flask-JWT-Extended, Flask-Login, Flask, Flask-Babel, Flask-WTF, Flask-OpenID`



## flask_restful

http://www.pythondoc.com/Flask-RESTful/index.html



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



## flask_csrf





## flask_cors

https://flask-cors.corydolphin.com/en/latest/index.html

CORS，跨域资源共享。

A Flask extension for handling Cross Origin Resource Sharing (CORS), making cross-origin AJAX possible.



## flask_script

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





# 参考资料

* FLask之Local、LocalStack和LocalProxy介绍 https://blog.csdn.net/weixin_45950544/article/details/103923191

