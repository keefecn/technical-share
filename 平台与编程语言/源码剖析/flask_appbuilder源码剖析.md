| 序号  | 修改时间      | 修改内容                 | 修改人   | 审稿人   |
| --- | --------- | -------------------- | ----- | ----- |
| 1   | 2021-8-24 | 创建。从《flask源码剖析》拆分成文。 | Keefe | Keefe |
|     |           |                      |       |       |

<br><br><br>

---

[TOC]

<br>

---

# 1 flask_appbuilder源码剖析

官网文档：https://flask-appbuilder.readthedocs.io/en/latest/

Flask-AppBuilder是基于Flask实现的一个用于快速构建Web后台管理系统的简单的框架。主要用于解决构建Web后台管理系统时避免一些重复而繁琐的工作，提高项目完成时间，它可以和 Flask/Jinja2自定义的页面进行无缝集成，并且可以进行高级的配置。这个框架还集成了一些CSS和JS库，包括以下内容：

* Google charts CSS and JS
* BootStrap CSS and JS
* BootsWatch Themes
* Font-Awesome CSS and FontsFlask-AppBuilder是基于Flask实现的一个用于快速构建Web后台管理系统的简单的框架。主要用于解决构建Web后台管理系统时避免一些重复而繁琐的工作，提高项目完成时间，它可以和 Flask/Jinja2自定义的页面进行无缝集成，并且可以进行高级的配置。这个框架还集成了一些CSS和JS库，包括以下内容：
  * Google charts CSS and JS
  * BootStrap CSS and JS
  * BootsWatch Themes
  * Font-Awesome CSS and Fonts

源码版本：Flask-AppBuilder-3.1.1

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

## 源码结构

表格 flask_appbuilder源码结构

| 目录或文件          | 主要类或函数                                                                                                                                                  | 说明                |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------- |
| api            | 文件：convert.py manager.py schemas.py<br>类：BaseApi BaseModelApi ModelRestApi OpenApi OpenApiManager SwaggerView  BaseModelSchema<br>装饰器：rison safe expose |                   |
| babel          | BabelManager LocaleView                                                                                                                                 | 依赖于flask_babel模块  |
| charts         | dict_to_json views.py widgets.py                                                                                                                        | 图表                |
| models         | generic/ mongoengine/ sqla/  filters.py groups.py mixins.py base.py                                                                                     | 模型                |
| security       | mongoengine/ sqla/  api.py decorators.py forms.py manager.py registerviews.py views.py                                                                  | 安全。               |
| static         | 目录：css datapicker fonts img js select2                                                                                                                  | 静态文件              |
| templates      | appbuilder/                                                                                                                                             | Jinja2模板          |
| tests          |                                                                                                                                                         | 测试                |
| translations   |                                                                                                                                                         | 翻译                |
| utils          | get_column_root_relation  get_column_leaf  is_column_dotted lazy_formatter_gettext                                                                      | 工具                |
| `__init__.py`  | BaseApi BaseModelApi ModelRestApi                                                                                                                       |                   |
| actions.py     | action ActionItem                                                                                                                                       |                   |
| base.py        | AppBuilder dynamic_class_import                                                                                                                         | app构建类（主类）        |
| basemanager.py | BaseManager                                                                                                                                             | 管理基类              |
| baseviews.py   | expose expose_api  <br>BaseView BaseFormView BaseModelView BaseCRUDView                                                                                 | 视图基类              |
| cli.py         | fab create_admin create_user...                                                                                                                         | 命令行，依赖click模块     |
| console.py     | cli_app                                                                                                                                                 | 控制台命令工具，依赖click模块 |
| const.py       |                                                                                                                                                         | 常量                |
| fields.py      | AJAXSelectField QuerySelectField QuerySelectMultipleField EnumField                                                                                     | 值域，依赖于wtforms模块   |
| filters.py     | app_template_filter TemplateFilters                                                                                                                     | 过滤器               |
| forms.py       | FieldConverter GeneralModelConverter DynamicForm                                                                                                        | 依赖于flask_wtf模块    |
| hooks.py       | before_request wrap_route_handler_with_hooks get_before_request_hooks                                                                                   | 勾子方法              |
| menu.py        | MenuItem Menu MenuApi MenuApiManager                                                                                                                    | 菜单管理              |
| views.py       | IndexView UtilView SimpleFormView PublicFormView...                                                                                                     | 各种视图              |
| widgets.py     | RenderTemplateWidget FormWidget FormVerticalWidget...                                                                                                   | 依赖于flask_wtf模块    |

## 核心模块

核心模块包括 APP构建、视图、API

### app构建 base.py

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

from .security.sqla.manager import SecurityManager

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

    menu = None            # 菜单对象
    indexview = None    # 首页视图

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
        """
        构建函数传参有app/session/menu/static/...
        security_manager_class -安全管理类，缺省是SecurityManager。用户可以自定义类。
        """
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
            self.indexview = self.indexview or IndexView    # 若无值，则为IndexView对象（/根视图）
        _menu = app.config.get("FAB_MENU", None)
        if _menu is not None:
            self.menu = dynamic_class_import(_menu)
        else:
            self.menu = self.menu or Menu()    # 若无值，则为Menu对象

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
        if self.app:    # 添加菜单权限
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

### 视图

视图包括 API视图和普通视图。

* `/flask_appbuilder/api/__init__.py `    API基类 BaseApi(object)  -> BaseModelApi -> ModelRestApi 。API视图详见下文 API视图章节

* /flask_appbuilder/baseview.py
  
  * 路由装饰器函数  expose expose_api
  * 视图基类  BaseView(object) ->  BaseFormView/BaseModelView  --> BaseCRUDView(BaseModelView)

* /flask_appbuilder/views.py  视图常见路由实现，如list/add/edit/download/...

```shell
# 视图的层次体系: 类名带Base的实现一般在baseview.py
RestAPI:   BaseApi(object)  -> BaseModelApi -> ModelRestApi
ModelView:
    BaseView(object)
        -> BaseModelView -> BaseCRUDView    (baseview.py)
            -> RestCRUDView -> ModelView    (views.py)
        -> BaseFormView
```

1. **路由扩展装饰器**：expose expose_api

作用：在原有路由基础上增加次级路由

示例：原路由/superset，调用 @expose('/welcome')

结果：/superset/welcome

代码实现： flask_appbuilder/baseview.py

```python
# expose这个装饰器重复定义，在baserview.py有，在 api/__init.py也有。
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

2. **基础视图**： 包括CRUD方法的真正实现
   
   flask_appbuilder/baseview.py
   
   BaseView类的公有方法有：create_blueprint  render_template  get_redirect  get_default_url

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

    route_base = None    # 此处基类根路由为空, 大create_blueprint中将类名作为根路由
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

    def create_blueprint(self, appbuilder, endpoint=None, static_folder=None):
        # Store appbuilder instance
        self.appbuilder = appbuilder

        # If endpoint name is not provided, get it from the class name
        self.endpoint = endpoint or self.__class__.__name__

        if self.route_base is None:    # 根路由为空时，用小写类名作为根路由。因此子类继承根路由就是子类的小写类名
            self.route_base = "/" + self.__class__.__name__.lower()

        self.static_folder = static_folder
        if not static_folder:  # 区分有无静态目录
            # Create blueprint and register rules
            self.blueprint = Blueprint(
                self.endpoint,
                __name__,
                url_prefix=self.route_base,
                template_folder=self.template_folder,
            )
        else:
            self.blueprint = Blueprint(
                self.endpoint,
                __name__,
                url_prefix=self.route_base,
                template_folder=self.template_folder,
                static_folder=static_folder,
            )
        self._register_urls()    # 注册urls
        return self.blueprint

    def _register_urls(self):
        ...

    def render_template(self, template, **kwargs):
        """
            Use this method on your own endpoints, will pass the extra_args
            to the templates.
            填充2个参数：base_teimplate, appbuilder，然后调用flask模块的render_template函数
            :param template: The template relative path
            :param kwargs: arguments to be passed to the template
        """
        kwargs["base_template"] = self.appbuilder.base_template
        kwargs["appbuilder"] = self.appbuilder
        return render_template(    # 渲染模板
            template, **dict(list(kwargs.items()) + list(self.extra_args.items()))
        )
```

3. 路由API实现  /flask_appbuilder/views.py

```python
from .baseviews import BaseCRUDView, BaseFormView, BaseView, expose, expose_api

class ModelView(RestCRUDView):
    """ 实现方法: list/add/edit/download/... """
    @expose("/list/")
    @has_access
    def list(self):

        widgets = self._list()    #实现在BaseView._list()
        return self.render_template(
            self.list_template, title=self.list_title, widgets=widgets
        )
```

### 菜单 menu.py

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
        self.menu = []    #列表存储MenuItem
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

## 命令行 cli.py

依赖模块click

flask_appbuilder 2.0版本之后 fabmanger脚本不再使用，换成 flask fab.

fab命令：

```shell
$ flask fab --help
Usage: flask fab [OPTIONS] COMMAND [ARGS]...

  FAB flask group commands

Options:
  --help  Show this message and exit.

Commands:
  babel-compile       Babel, Compiles all translations    #1.3.0之前相当于pybable compile
  babel-extract       Babel, Extracts and updates all messages marked for...    #相当于pybable extract
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

## 模型 /models/

## 安全 /security/

源文件：（忽略前缀/flask_appbuilder/security/）

* manager.py  类继承关系:   BaseSecurityManager ->  AbstractSecurityManager -> BaseManager
* sqla/manager.py   SecurityManager ->  BaseSecurityManager
* views.py  各种认证类如AuthDBView、AuthLDAPView、AuthOAuthView、AuthOIDView等
* decorators.py 装饰器如has_access, has_access_api, permission_name, protect
* api.py  API登陆认证

### 管理类 xx/manager.py

类体系：(sqla/manager.py)SecurityManager ->

​               (manager.py)BaseSecurityManager -> AbstractSecurityManager ->

​               (/flask_appbuilder/basemanager.py)BaseManager 管理类基类

/flask_appbuilder/basemanager.py

```python
class BaseManager(object):
    """
        The parent class for all Managers
    """

    def __init__(self, appbuilder):
        self.appbuilder = appbuilder

    def register_views(self):
        pass  # pragma: no cover

    def pre_process(self):
        pass  # pragma: no cover

    def post_process(self):
        pass  # pragma: no cover
```

/flask_appbuilder/security/manager.py

```python
from ..basemanager import BaseManager


class AbstractSecurityManager(BaseManager):
    """ 抽象类，子类实现具体方法 """
    def add_permissions_view(self, base_permissions, view_menu):
    def add_permissions_menu(self, view_menu_name):
    def register_views(self):
    def is_item_public(self, permission_name, view_name):
    def has_access(self, permission_name, view_name):
    def security_cleanup(self, baseviews, menus):
        raise NotImplementedError


class BaseSecurityManager(AbstractSecurityManager):
    """
    支持预设角色，
    支持各种认证方式，认证类型变量为AUTH_TYPE，通过认证类型导入认证类，
    支持用户自注册
    """
    ...
    # 各认证的缺省视图，用户可以重载
    authdbview = AuthDBView
    """ Override if you want your own Authentication DB view """
    authldapview = AuthLDAPView
    """ Override if you want your own Authentication LDAP view """
    authoidview = AuthOIDView
    """ Override if you want your own Authentication OID view """
    authoauthview = AuthOAuthView
    """ Override if you want your own Authentication OAuth view """
    authremoteuserview = AuthRemoteUserView
    ...

    def __init__(self, appbuilder):
        super(BaseSecurityManager, self).__init__(appbuilder)
        app = self.appbuilder.get_app
        # Base Security Config
        app.config.setdefault("AUTH_ROLE_ADMIN", "Admin")
        app.config.setdefault("AUTH_ROLE_PUBLIC", "Public")
        app.config.setdefault("AUTH_TYPE", AUTH_DB)
        # Self Registration
        app.config.setdefault("AUTH_USER_REGISTRATION", False)
        app.config.setdefault("AUTH_USER_REGISTRATION_ROLE", self.auth_role_public)
        app.config.setdefault("AUTH_USER_REGISTRATION_ROLE_JMESPATH", None)
        # Role Mapping
        app.config.setdefault("AUTH_ROLES_MAPPING", {})
        app.config.setdefault("AUTH_ROLES_SYNC_AT_LOGIN", False)


    """
        ----------------------------------------
            PERMISSION ACCESS CHECK
        ----------------------------------------
    """
    def is_item_public(self, permission_name, view_name):
        """
            Check if view has public permissions
            检查视图是否有公共权限
            :param permission_name:
                the permission: can_show, can_edit...
            :param view_name:
                the name of the class view (child of BaseView)
        """
        permissions = self.get_public_permissions()
        if permissions:
            for i in permissions:
                if (view_name == i.view_menu.name) and (
                    permission_name == i.permission.name
                ):
                    return True
            return False
        else:
            return False

    def _has_access_builtin_roles(
        self, role, permission_name: str, view_name: str
    ) -> bool:
        """
            Checks permission on builtin role  检查权限是否是内建角色
        """
        builtin_pvms = self.builtin_roles.get(role.name, [])
        for pvm in builtin_pvms:
            _view_name = pvm[0]
            _permission_name = pvm[1]
            if re.match(_view_name, view_name) and re.match(
                _permission_name, permission_name
            ):
                return True
        return False

    def _has_view_access(
        self, user: object, permission_name: str, view_name: str
    ) -> bool:
        """ 检查视图是否可访问：遍历用户拥有的所有角色，
                先检查是否有内建角色并拥有权限，有则退出。
                再检查非内建角色的视图访问权限。
        """
        roles = user.roles
        db_role_ids = list()
        # First check against builtin (statically configured) roles
        # because no database query is needed
        for role in roles:  # 依次检查用户的每个角色
            if role.name in self.builtin_roles:    #检查内建角色（一般有5个如Admin）权限
                if self._has_access_builtin_roles(role, permission_name, view_name):
                    return True
            else: #非公共角色，添加角色到此
                db_role_ids.append(role.id)

        # If it's not a builtin role check against database store roles
        return self.exist_permission_on_roles(view_name, permission_name, db_role_ids)

    def has_access(self, permission_name, view_name):
        """
        Check if current user or public has access to view or menu
        检查当前用户或公共用户是否能够访问视图或菜单
        """
        if current_user.is_authenticated:    # 当前用户已认证
            return self._has_view_access(g.user, permission_name, view_name)
        elif current_user_jwt:    # 当前用户是JWT登陆
            return self._has_view_access(current_user_jwt, permission_name, view_name)
        else:    # 公共用户
            return self.is_item_public(permission_name, view_name)
```

/flask_appbuilder/security/sqla/manager.py

```python
from typing import List, Optional
import uuid

from sqlalchemy import and_, func, literal
from sqlalchemy.engine.reflection import Inspector
from sqlalchemy.orm import contains_eager
from sqlalchemy.orm.exc import MultipleResultsFound
from werkzeug.security import generate_password_hash

from .models import (
    assoc_permissionview_role,
    Permission,
    PermissionView,
    RegisterUser,
    Role,
    User,
    ViewMenu,
)
from ..manager import BaseSecurityManager


class SecurityManager(BaseSecurityManager):
    """ 安全管理类，BRAC基于角色的访问控制，通过用户所拥有的角色集得到相应权限集。
    主要就是查找DB里的权限相关6张表，判断用户要访问的资源view/menu是否有相应权限(read/write/list/...)
    """
    user_model = User                        # ab_user表
    role_model = Role                        # ab_role表
    permission_model = Permission            # ab_permisson表
    viewmenu_model = ViewMenu                # ab_view_menu表
    permissionview_model = PermissionView    # ab_permission_view表
    registeruser_model = RegisterUser        # ab_regitser_user表

    def __init__(self, appbuilder):

    def exist_permission_on_roles(
        self, view_name: str, permission_name: str, role_ids: List[int]
    ) -> bool:
        """
        查找DB权限关联的4张表，判断角色列表拥有的权限集里是否有此视图所需要的权限
        示例：用户test1拥有角色[gamma,datasource_sync]，需要查看的视图Datasets，权限是can_read
        """
       q = (
            self.appbuilder.get_session.query(self.permissionview_model)    # ab_permission_view表
            .join(
                assoc_permissionview_role,    # ab_permission_view_role表
                and_(
                    (
                        self.permissionview_model.id
                        == assoc_permissionview_role.c.permission_view_id
                    )
                ),
            )
            .join(self.role_model)            # ab_role表
            .join(self.permission_model)    # ab_permisson表
            .join(self.viewmenu_model)        # ab_view_menu表
            .filter(
                self.viewmenu_model.name == view_name,
                self.permission_model.name == permission_name,
                self.role_model.id.in_(role_ids),
            )
            .exists()
        )
        # Special case for MSSQL/Oracle (works on PG and MySQL > 8)
        if self.appbuilder.get_session.bind.dialect.name in ("mssql", "oracle"):
            return self.appbuilder.get_session.query(literal(True)).filter(q).scalar()
        return self.appbuilder.get_session.query(q).scalar()
```

### 认证视图类 views.py

```python
from flask import abort, current_app, flash, g, redirect, request, session, url_for
from flask_babel import lazy_gettext
from flask_login import login_user, logout_user
import jwt
from werkzeug.security import generate_password_hash
from wtforms import PasswordField, validators
from wtforms.validators import EqualTo

from ..baseviews import BaseView


class AuthView(BaseView):
    route_base = ""
    login_template = ""
    invalid_login_message = lazy_gettext("Invalid login. Please try again.")
    title = lazy_gettext("Sign In")

    @expose("/login/", methods=["GET", "POST"])
    def login(self):
        pass

    @expose("/logout/")
    def logout(self):
        """ 用户退出一系列操作，重定向到首页 """
        logout_user()
        return redirect(self.appbuilder.get_url_for_index)


class AuthDBView(AuthView):
    """ 对外提供'/login/'接口，读取HTTP POST里的用户名/密码，然后调用auth_user_db验证，验证通过调用login_user生成认证信息。"""
    login_template = "appbuilder/general/security/login_db.html"

    @expose("/login/", methods=["GET", "POST"])
    def login(self):
        if g.user is not None and g.user.is_authenticated: #如果当前用户未退出并且已认证，跳转到首页
            return redirect(self.appbuilder.get_url_for_index)
        form = LoginForm_db()
        if form.validate_on_submit():
            user = self.appbuilder.sm.auth_user_db(   #真正的认证操作：DB验证用户名和密码是否匹配
                form.username.data, form.password.data
            )
            if not user: #未获取到用户，弹框警告并跳转到登陆页
                flash(as_unicode(self.invalid_login_message), "warning")
                return redirect(self.appbuilder.get_url_for_login)
            login_user(user, remember=False)
            return redirect(self.appbuilder.get_url_for_index)
        return self.render_template(
            self.login_template, title=self.title, form=form, appbuilder=self.appbuilder
        )
```

### 安全装饰器 decorator.py

/flask_appbuilder/security/decorators.py

* protect 用户登陆判断，并作相应访问权限判断。浏览器登陆时接受cookie验证。
* has_access  判断方法有没相应权限
* has_access_api   类似has_access，但应用于API方法。缺省方法名就是权限名称。
* permission_name  重载权限名称

```python
from flask import current_app, flash, jsonify, make_response, redirect, request, url_for
from flask_jwt_extended import verify_jwt_in_request
from flask_login import current_user


def protect(allow_browser_login=False):
    """
        浏览器登陆时，如果已经登陆，可以从session中取出相关数据作访问权限判断；若未登陆，需同下方非浏览器登陆。
        非浏览器登陆，需JWT验证，然后验证成功后作访问权限判断。
        Use this decorator to enable granular security permissions
        to your API methods (BaseApi and child classes).
        Permissions will be associated to a role, and roles are associated to users.

        allow_browser_login will accept signed cookies obtained from the normal MVC app::

            class MyApi(BaseApi):
                @expose('/dosonmething', methods=['GET'])
                @protect(allow_browser_login=True)
                @safe
                def do_something(self):
                    ....

                @expose('/dosonmethingelse', methods=['GET'])
                @protect()
                @safe
                def do_something_else(self):
                    ....

        By default the permission's name is the methods name.
    """

    def _protect(f):
        # permission_str赋值
        if hasattr(f, "_permission_name"):
            permission_str = f._permission_name
        else:
            permission_str = f.__name__

        def wraps(self, *args, **kwargs):
            # Apply method permission name override if exists,
            # 赋值permission_str PERMISSION_PREFIX="can_", f._permission_name="read|write|list"
            permission_str = "{}{}".format(PERMISSION_PREFIX, f._permission_name)
            if self.method_permission_name:    # dict={'method':"permisson_name"}
                _permission_name = self.method_permission_name.get(f.__name__)
                if _permission_name:
                    permission_str = "{}{}".format(PERMISSION_PREFIX, _permission_name)
            class_permission_name = self.class_permission_name    # 要作权限控制的类，如Dataset
            if permission_str not in self.base_permissions:  #判断当前权限是否在基础权限范围
                return self.response_401()
            if current_app.appbuilder.sm.is_item_public(    #判断是否在公共权限内，是则正常执行
                permission_str, class_permission_name
            ):
                return f(self, *args, **kwargs)
            if not (self.allow_browser_login or allow_browser_login):
                verify_jwt_in_request()    #非浏览器登陆，验证请求里的JWT
            if current_app.appbuilder.sm.has_access(    #判断是否可访问
                permission_str, class_permission_name
            ):
                return f(self, *args, **kwargs)
            elif self.allow_browser_login or allow_browser_login:    #浏览器登陆
                if not current_user.is_authenticated:    #用户未认证，验证JWT
                    verify_jwt_in_request()
                if current_app.appbuilder.sm.has_access(
                    permission_str, class_permission_name
                ):
                    return f(self, *args, **kwargs)
            log.warning(
                LOGMSG_ERR_SEC_ACCESS_DENIED.format(
                    permission_str, class_permission_name
                )
            )
            return self.response_401()

        f._permission_name = permission_str
        return functools.update_wrapper(wraps, f)

    return _protect


def has_access(f):
    """
        Use this decorator to enable granular security permissions to your methods.
        Permissions will be associated to a role, and roles are associated to users.

        By default the permission's name is the methods name.
    """
    if hasattr(f, "_permission_name"):
        permission_str = f._permission_name
    else:
        permission_str = f.__name__

    def wraps(self, *args, **kwargs):
        permission_str = "{}{}".format(PERMISSION_PREFIX, f._permission_name)
        if self.method_permission_name:
            _permission_name = self.method_permission_name.get(f.__name__)
            if _permission_name:
                permission_str = "{}{}".format(PERMISSION_PREFIX, _permission_name)
        if permission_str in self.base_permissions and self.appbuilder.sm.has_access(
            permission_str, self.class_permission_name
        ):
            return f(self, *args, **kwargs)
        else:
            log.warning(
                LOGMSG_ERR_SEC_ACCESS_DENIED.format(
                    permission_str, self.__class__.__name__
                )
            )
            flash(as_unicode(FLAMSG_ERR_SEC_ACCESS_DENIED), "danger")
        return redirect(
            url_for(
                self.appbuilder.sm.auth_view.__class__.__name__ + ".login",
                next=request.url,
            )
        )

    f._permission_name = permission_str
    return functools.update_wrapper(wraps, f)


def has_access_api(f):


def permission_name(name):
```

### api登陆 api.py

/flask_appbuilder/security/api.py

API安全登陆实现，JWT方式。JWT实现依赖于flask_jwt_extended模块。

提供接口

* /security/login  登陆获取2个token分别是access_token 和 refresh_token。access_token用来JWT验证，有时效要求。
* /security/refresh  更新token，用refresh_token获取新的access_token

```python
from ..api import BaseApi, safe


class SecurityApi(BaseApi):

    resource_name = "security"
    version = API_SECURITY_VERSION
    openapi_spec_tag = "Security"

    def add_apispec_components(self, api_spec):
        """ 添加API文档scheme """
        super(SecurityApi, self).add_apispec_components(api_spec)
        jwt_scheme = {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"}
        api_spec.components.security_scheme("jwt", jwt_scheme)
        api_spec.components.security_scheme("jwt_refresh", jwt_scheme)

    @expose("/login", methods=["POST"])
    @safe
    def login(self):
        if not request.is_json:
            return self.response_400(message="Request payload is not JSON")
        # 从json串获取相应数据
        username = request.json.get(API_SECURITY_USERNAME_KEY, None)
        password = request.json.get(API_SECURITY_PASSWORD_KEY, None)
        provider = request.json.get(API_SECURITY_PROVIDER_KEY, None)
        refresh = request.json.get(API_SECURITY_REFRESH_KEY, False)
        if not username or not password or not provider:
            return self.response_400(message="Missing required parameter")
        # AUTH： 根据认证方式选择不同的认证途径
        if provider == API_SECURITY_PROVIDER_DB:
            user = self.appbuilder.sm.auth_user_db(username, password)
        elif provider == API_SECURITY_PROVIDER_LDAP:
            user = self.appbuilder.sm.auth_user_ldap(username, password)
        else:
            return self.response_400(
                message="Provider {} not supported".format(provider)
            )
        if not user:
            return self.response_401()

        # Identity can be any data that is json serializable
        resp = dict()
        resp[API_SECURITY_ACCESS_TOKEN_KEY] = create_access_token(
            identity=user.id, fresh=True
        )
        if refresh:
            resp[API_SECURITY_REFRESH_TOKEN_KEY] = create_refresh_token(
                identity=user.id
            )
        return self.response(200, **resp)

    @expose("/refresh", methods=["POST"])
    @jwt_refresh_token_required
    @safe
    def refresh(self):
        """ 通过refresh_token 刷新 aceess_token, 避免token过期导致需重新登陆 """
        resp = {
            API_SECURITY_ACCESS_TOKEN_KEY: create_access_token(
                identity=get_jwt_identity(), fresh=False
            )
        }
        return self.response(200, **resp)
```

## 模板 /templates/

依赖模块Jinja2。

**首页相关的模板**：（说明：下面模板忽略路径前缀 /flask_appbuilder/templates/）

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

head实体定义3块，分别是head_meta、head_css、head_js。

body实体定义4块，分别是body、tail_js、add_tail_js、tail。

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
                <i class="fa {{item1.icon}}"></i> 
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
        <i class="fa fa-fw {{item.icon}}"></i> 
    {% endif %}
    {{_(item.label)}}</a>
{% endmacro %}


{% for item1 in menu.get_list() %}
    {% if item1 | is_menu_visible %}
        {% if item1.childs %}
            <li class="dropdown">
            <a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">
            {% if item1.icon %}
                <i class="fa {{item1.icon}}"></i> 
            {% endif %}
            {{_(item1.label)}}<b class="caret"></b></a>
            <ul class="dropdown-menu">
            {% for item2 in item1.childs %}
                {% if item2 %}
                    {% if item2.name == '-' %}   {# 名称为-时，添加菜单分隔符- #}
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

## API  /api/

* `/flask_appbuilder/api/__init__.py `   API视图基类和装饰器
* /flask_appbuilder/api/manager.py  API文档

### API视图和权限

`/flask_appbuilder/api/__init__.py`

* API视图基类：BaseApi(object)  -> BaseModelApi -> ModelRestApi 。
* 装饰器：expose  safe  rison
  * expose: API路由扩展
  * safe: 捕捉异常，返回异常时的JSON
  * rison: 捕捉入参的Rison参数

```python
class BaseApi(object):
    appbuilder = None
    blueprint = None
    endpoint: Optional[str] = None
    version: Optional[str] = "v1"         # 此处定义了API版本，若有版本升级，继承类可重新赋值，如v2
    route_base: Optional[str] = None     # 有值，则是路由根前缀
    resource_name: Optional[str] = None  # 若route_base无值，则用来构建路由根前缀。若本变量值为空，则赋值为当前类名小写。

    """ 蓝图路径是 self.route_base or /api/vi/{resource_name.lower()} """
    def create_blueprint(self, appbuilder, endpoint=None, static_folder=None):
        # Store appbuilder instance
        self.appbuilder = appbuilder
        # If endpoint name is not provided, get it from the class name
        self.endpoint = endpoint or self.__class__.__name__
        self.resource_name = self.resource_name or self.__class__.__name__.lower()

        if self.route_base is None:
            self.route_base = "/api/{}/{}".format(
                self.version, self.resource_name.lower()
            )
        self.blueprint = Blueprint(self.endpoint, __name__, url_prefix=self.route_base)
        # Exempt API from CSRF protect
        if self.csrf_exempt:
            csrf = self.appbuilder.app.extensions.get("csrf")
            if csrf:
                csrf.exempt(self.blueprint)

        self._register_urls()
        return self.blueprint


class BaseModelApi(BaseApi):
    datamodel = None

class ModelRestApi(BaseModelApi):


def expose(url="/", methods=("GET",)):
    """
        Use this decorator to expose API endpoints on your API classes.

        :param url:
            Relative URL for the endpoint
        :param methods:
            Allowed HTTP methods. By default only GET is allowed.
    """

    def wrap(f):
        if not hasattr(f, "_urls"):
            f._urls = []
        f._urls.append((url, methods))
        return f

    return wrap


def safe(f):
    """
    A decorator that catches uncaught exceptions and
    return the response in JSON format (inspired on Superset code)
    """

    def wraps(self, *args, **kwargs):
        try:
            return f(self, *args, **kwargs)
        except BadRequest as e:
            return self.response_400(message=str(e))
        except Exception as e:
            logging.exception(e)
            return self.response_500(message=get_error_msg())

    return functools.update_wrapper(wraps, f)


def rison(schema=None):
"""
    示例：
            schema = {
                "type": "object",
                "properties": {
                    "arg1": {
                        "type": "integer"
                    }
                }
            }

            class ExampleApi(BaseApi):
                    @expose('/risonjson')
                    @rison(schema)
                    def rison_json(self, **kwargs):
                        return self.response(200, result=kwargs['rison'])
"""
```

### API文档

API文档依赖于 apispec和marshmallow模块，文档传参字段类型要用到marshmallow的字段类型, 字段定义要继承marshmallow模块的Schema。

新生成的API类（继承BaseApi或其派生类）需要调用 `appbuilder.add_api(xxAPI)`才能注册路由。

API文档schema定义在/docs/src/resources.openapi.json。

openapi和swagger二种格式的API页面

* `/api/<version>`     返回JSON格式，涉及配置项FAB_ADD_SECURITY_VIEWS 和 FAB_API_SWAGGER_UI

* `/swagger/<version>`    返回HTML格式，涉及配置项FAB_API_SWAGGER_TEMPLATE
  
  /flask_appbuilder/api/manager.py

```python
from apispec import APISpec
from apispec.ext.marshmallow import MarshmallowPlugin
from apispec.ext.marshmallow.common import resolve_schema_cls
from flask import current_app
from flask_appbuilder.api import BaseApi
from flask_appbuilder.api import expose, protect, safe
from flask_appbuilder.basemanager import BaseManager
from flask_appbuilder.baseviews import BaseView
from flask_appbuilder.security.decorators import has_access


def resolver(schema):
    schema_cls = resolve_schema_cls(schema)
    name = schema_cls.__name__
    if name == "MetaSchema":
        if hasattr(schema_cls, "Meta"):
            return (
                f"{schema_cls.Meta.parent_schema_name}.{schema_cls.Meta.model.__name__}"
            )
    if name.endswith("Schema"):
        return name[:-6] or name
    return name

class OpenApi(BaseApi):
    route_base = "/api"
    allow_browser_login = True

    @expose("/<version>/_openapi")
    @protect()
    @safe
    def get(self, version):
        """ Endpoint that renders an OpenApi spec for all views that belong
            to a certain version
        ---
        get:
          description: >-
            Get the OpenAPI spec for a specific API version
          parameters:
          - in: path
            schema:
              type: string
            name: version
          responses:
            200:
              description: The OpenAPI spec
              content:
                application/json:
                  schema:
                    type: object
            404:
              $ref: '#/components/responses/404'
            500:
              $ref: '#/components/responses/500'
        """
        version_found = False
        api_spec = self._create_api_spec(version)
        for base_api in current_app.appbuilder.baseviews:
            if isinstance(base_api, BaseApi) and base_api.version == version:
                base_api.add_api_spec(api_spec)
                version_found = True
        if version_found:
            return self.response(200, **api_spec.to_dict())
        else:
            return self.response_404()

    @staticmethod
    def _create_api_spec(version):
        return APISpec(
            title=current_app.appbuilder.app_name,
            version=version,
            openapi_version="3.0.2",
            info=dict(description=current_app.appbuilder.app_name),
            plugins=[MarshmallowPlugin(schema_name_resolver=resolver)],
            servers=[{"url": "/api/{}".format(version)}],
        )


class SwaggerView(BaseView):

    route_base = "/swagger"
    default_view = "ui"
    openapi_uri = "/api/{}/_openapi"

    @expose("/<version>")
    @has_access
    def show(self, version):
        return self.render_template(
            self.appbuilder.app.config.get(
                "FAB_API_SWAGGER_TEMPLATE", "appbuilder/swagger/swagger.html"
            ),
            openapi_uri=self.openapi_uri.format(version),
        )


class OpenApiManager(BaseManager):
    def register_views(self):
        if not self.appbuilder.app.config.get("FAB_ADD_SECURITY_VIEWS", True):
            return
        if self.appbuilder.get_app.config.get("FAB_API_SWAGGER_UI", False):
            self.appbuilder.add_api(OpenApi)    #添加API类
            self.appbuilder.add_view_no_menu(SwaggerView)    #添加视图类
```

/flask_appbuilder/template/appbuilder/swagger/swagger.html

```html
{% extends "appbuilder/base.html" %}

{% block head_css %}
{{ super() }}
<link type="text/css" rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3/swagger-ui.css">
<link rel="shortcut icon" href="https://fastapi.tiangolo.com/img/favicon.png">
{% endblock %}

{% block content %}
<div id="swagger-ui">
</div>
<script src="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3/swagger-ui-bundle.js"></script>
<!-- `SwaggerUIBundle` is now available on the page -->
<script>
    const ui = SwaggerUIBundle({
        url: '{{openapi_uri}}',
        dom_id: '#swagger-ui',
        presets: [
            SwaggerUIBundle.presets.apis,
            SwaggerUIBundle.SwaggerUIStandalonePreset
        ],
        layout: "BaseLayout"
    })
    </script>
{% endblock %}
```

<br>

# 2 flask_appbuild依赖模块

## SQLAlchemy

```shell
$ pip show SQLalchemy
Name: SQLAlchemy
Version: 1.3.24
Summary: Database Abstraction Library
Home-page: http://www.sqlalchemy.org
Author: Mike Bayer
Author-email: mike_mp@zzzcomputing.com
License: MIT
Location: d:\dev\venv\superset-py38-env\lib\site-packages
Requires:
Required-by: SQLAlchemy-Utils, marshmallow-sqlalchemy, Flask-SQLAlchemy, Flask-AppBuilder, apache-superset, alembic
```

表格 sqlalchemy源码结构

| 目录或文件         | 主要类或函数                                                     | 说明                                              |
| ------------- | ---------------------------------------------------------- | ----------------------------------------------- |
| connectors    | Connector MxODBCConnector PyODBCConnector ZxJDBCConnector  | 连接器                                             |
| databases     | `__all__`                                                  | 数据库。导入dialects目录下各种数据库名字空间。                     |
| dialects      | 目录：firebird mssql mysql oracle postgresql sqlite sybase    | 数据库方言，指符合SQL规范的数据库语言实现。<br>比如分页、限流等的关键字和实现方式不同。 |
| engine        | create_engine engine_from_config  Engine<br>文件：base.py ... | 引擎                                              |
| event         | api.py attr.py base.py legacy.py registry.py               | 事件处理                                            |
| ext           |                                                            | 扩展                                              |
| orm           | 重要                                                         | ORM模型                                           |
| pool          |                                                            | 数据库连接池的实现。                                      |
| sql           | 重要                                                         |                                                 |
| testing       |                                                            | 测试目录                                            |
| util          |                                                            | 工具                                              |
| events.py     | ConnectionEvents DDLEvents DialectEvents PoolEvents        | 事件。继承自event/base.py:Events                      |
| exc.py        |                                                            | 定义各种异常。                                         |
| inspection.py | inspect                                                    |                                                 |
| interfaces.py | ConnectionProxy PoolListener                               | 接口                                              |
| log.py        | InstanceLogger echo_property Identified                    | 日志                                              |
| processors.py |                                                            | 处理器。定义通用类型转化成函数。                                |
| schema.py     | `__all__`                                                  | 模式。导入sql目录下模式相关各种类。                             |
| types.py      | `__all__`                                                  | 定义可以导出的类/函数符号。                                  |

![sqlalchemy](../../media/sf_reuse/framework/frame_sqlalchema.png)

图  SQLAlchemy architecture

说明：ORM框架在上层实现了无差别调用，归一化各种数据库连接参数Connection、查询语句关键字Dialect，屏蔽了数据库底层实现逻辑。

* DBAPI: 第三方插件。如pymysql, mysqldb等等。

* Dialect： 方言。指符合SQL语言规范的数据库语言实现，如不同数据库的分页关键字不一样。

* Engine：

**Database Urls**
dialect[+driver]://username:password@host:port/database

示例**：MySQL**
The MySQL dialect uses mysql-python as the default DBAPI. There are many MySQL DBAPIs available, including MySQL-connector-python and OurSQL:

```python
# default: pip install mysql-python
engine = create_engine('mysql://scott:tiger@localhost/foo')
# mysql-python
engine = create_engine('mysql+mysqldb://scott:tiger@localhost/foo')
# MySQL-connector-python
engine = create_engine('mysql+mysqlconnector://scott:tiger@localhost/foo')
# OurSQL
engine = create_engine('mysql+oursql://scott:tiger@localhost/foo')
```

### 引擎 /engine/

| 文件             | 主要类或函数                                                                                                                       | 说明                                                      |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| __`init__.py`  | create_engine engine_from_config                                                                                             | 定义了2个供外部使用的方法                                           |
| base.py        | Connection Engine ExceptionContextImpl  Transaction <br/>NestedTransaction RootTransaction OptionEngine  TwoPhaseTransaction | 定义基类：连接、引擎、事务                                           |
| default.py     |                                                                                                                              |                                                         |
| interface.py   | Connectable CreateEnginePlugin Dialect  <br/>ExceptionContext ExecutionContext                                               | 定义接口类                                                   |
| reflection.py  |                                                                                                                              |                                                         |
| result.y       |                                                                                                                              |                                                         |
| strategirs.py  | EngineStrategy  DefaultEngineStrategy PlainEngineStrategy ThreadLocalEngineStrategy MockEngineStrategy                       | 引擎策略。                                                   |
| threadlocal.py |                                                                                                                              | 线程本地数据                                                  |
| url.py         |                                                                                                                              | eingine组成 (RFC1738)： name://user:pwd@host:port/database |
| utils.py       |                                                                                                                              | 工具                                                      |

`/sqlalchemy/engine/__init__.py`

```python
default_strategy = "plain"


def create_engine(*args, **kwargs):
    """ 创建引擎，参数里获取引擎策略，跳转到相应的策略执行器 """
    strategy = kwargs.pop("strategy", default_strategy)
    strategy = strategies.strategies[strategy]
    return strategy.create(*args, **kwargs)


def engine_from_config(configuration, prefix="sqlalchemy.", **kwargs):
    """Create a new Engine instance using a configuration dictionary. """
    options = dict(
        (key[len(prefix) :], configuration[key])
        for key in configuration
        if key.startswith(prefix)
    )
    options["_coerce_config"] = True
    options.update(kwargs)
    url = options.pop("url")
    return create_engine(url, **options)


__all__ = ("create_engine", "engine_from_config")
```

/sqlalchemy/engine/strategies.py

```python
strategies = {}


class EngineStrategy(object):
    """子类重载 create方法
    """
    def __init__(self):
        strategies[self.name] = self

    def create(self, *args, **kwargs):
        raise NotImplementedError()



class DefaultEngineStrategy(EngineStrategy):
    """Base class for built-in strategies."""

    def create(self, name_or_url, **kwargs):
        """
        要从传参中 获取完整的connect_args, pool，plugin
        然后创建出相应的dialect对象，pool对象，插件
        最终返回 Engine实例
        """
        # create url.URL object
        u = url.make_url(name_or_url)    #根据uri生成URL对象实例

        plugins = u._instantiate_plugins(kwargs)    #插件初始化

        u.query.pop("plugin", None)
        kwargs.pop("plugins", None)

        entrypoint = u._get_entrypoint()    #根据传入url中的数据库类型(mysql)和驱动库(pymysql),来注册插件，返回dialect类
        dialect_cls = entrypoint.get_dialect_cls(u)    #获取 dialect实例

        if kwargs.pop("_coerce_config", False):

            def pop_kwarg(key, default=None):
                value = kwargs.pop(key, default)
                if key in dialect_cls.engine_config_types:
                    value = dialect_cls.engine_config_types[key](value)
                return value

        else:
            pop_kwarg = kwargs.pop

        dialect_args = {}
        # consume dialect arguments from kwargs  #从传参中获取创建dialect对象所需的完整参数
        for k in util.get_cls_kwargs(dialect_cls):
            if k in kwargs:
                dialect_args[k] = pop_kwarg(k)

        dbapi = kwargs.pop("module", None)
        if dbapi is None:
            dbapi_args = {}
            for k in util.get_func_kwargs(dialect_cls.dbapi):
                if k in kwargs:
                    dbapi_args[k] = pop_kwarg(k)
            dbapi = dialect_cls.dbapi(**dbapi_args)

        dialect_args["dbapi"] = dbapi

        for plugin in plugins:
            plugin.handle_dialect_kwargs(dialect_cls, dialect_args)

        # create dialect
        dialect = dialect_cls(**dialect_args)

        # assemble connection arguments  创建连接参数connect_args
        (cargs, cparams) = dialect.create_connect_args(u)
        cparams.update(pop_kwarg("connect_args", {}))
        cargs = list(cargs)  # allow mutability

        # look for existing pool or create  查找或创建连接池 pool
        pool = pop_kwarg("pool", None)
        if pool is None:

            def connect(connection_record=None):
                if dialect._has_events:
                    for fn in dialect.dispatch.do_connect:
                        connection = fn(
                            dialect, connection_record, cargs, cparams
                        )
                        if connection is not None:
                            return connection
                return dialect.connect(*cargs, **cparams)

            creator = pop_kwarg("creator", connect)

            poolclass = pop_kwarg("poolclass", None)
            if poolclass is None:
                poolclass = dialect_cls.get_pool_class(u)
            pool_args = {"dialect": dialect}

            # consume pool arguments from kwargs, translating a few of
            # the arguments
            translate = {
                "logging_name": "pool_logging_name",
                "echo": "echo_pool",
                "timeout": "pool_timeout",
                "recycle": "pool_recycle",
                "events": "pool_events",
                "use_threadlocal": "pool_threadlocal",
                "reset_on_return": "pool_reset_on_return",
                "pre_ping": "pool_pre_ping",
                "use_lifo": "pool_use_lifo",
            }
            for k in util.get_cls_kwargs(poolclass):
                tk = translate.get(k, k)
                if tk in kwargs:
                    pool_args[k] = pop_kwarg(tk)

            for plugin in plugins:
                plugin.handle_pool_kwargs(poolclass, pool_args)

            pool = poolclass(creator, **pool_args)
        else:
            if isinstance(pool, poollib.dbapi_proxy._DBProxy):
                pool = pool.get_pool(*cargs, **cparams)
            else:
                pool = pool

            pool._dialect = dialect

        # create engine. 获取引擎参数 engine
        engineclass = self.engine_cls
        engine_args = {}
        for k in util.get_cls_kwargs(engineclass):
            if k in kwargs:
                engine_args[k] = pop_kwarg(k)

        _initialize = kwargs.pop("_initialize", True)

        # all kwargs should be consumed
        if kwargs:
            raise TypeError(
                "Invalid argument(s) %s sent to create_engine(), "
                "using configuration %s/%s/%s.  Please check that the "
                "keyword arguments are appropriate for this combination "
                "of components."
                % (
                    ",".join("'%s'" % k for k in kwargs),
                    dialect.__class__.__name__,
                    pool.__class__.__name__,
                    engineclass.__name__,
                )
            )

        engine = engineclass(pool, dialect, u, **engine_args)

        if _initialize:
            do_on_connect = dialect.on_connect()
            if do_on_connect:

                def on_connect(dbapi_connection, connection_record):
                    conn = getattr(
                        dbapi_connection, "_sqla_unwrap", dbapi_connection
                    )
                    if conn is None:
                        return
                    do_on_connect(conn)

                event.listen(pool, "first_connect", on_connect)
                event.listen(pool, "connect", on_connect)

            def first_connect(dbapi_connection, connection_record):
                c = base.Connection(
                    engine, connection=dbapi_connection, _has_events=False
                )
                c._execution_options = util.immutabledict()
                dialect.initialize(c)
                dialect.do_rollback(c.connection)

            event.listen(
                pool,
                "first_connect",
                first_connect,
                _once_unless_exception=True,
            )

        dialect_cls.engine_created(engine)
        if entrypoint is not dialect_cls:
            entrypoint.engine_created(engine)    #创建引擎

        for plugin in plugins:
            plugin.engine_created(engine)        #创建插件

        return engine


class PlainEngineStrategy(DefaultEngineStrategy):
    """Strategy for configuring a regular Engine."""

    name = "plain"
    engine_cls = base.Engine    #指定引擎类


PlainEngineStrategy()


class ThreadLocalEngineStrategy(DefaultEngineStrategy):
    """Strategy for configuring an Engine with threadlocal behavior."""

    name = "threadlocal"
    engine_cls = threadlocal.TLEngine


ThreadLocalEngineStrategy()

class MockEngineStrategy(EngineStrategy):
    """Strategy for configuring an Engine-like object with mocked execution.
    """
    name = "mock"
    def create(self, name_or_url, executor, **kwargs):
        ...
```

/sqlalchemy/engine/url.py

### 方言 /dialects/

Dialect就是用来操作不同数据库的行为，对应接口调用dbapi操作。

### ORM /orm/

### SQL /sql/

## apispec

插件式API规格书生成器。

```shell
$ pip show apispec
Name: apispec
Version: 3.3.2
Summary: A pluggable API specification generator. Currently supports the OpenAPI Specification (f.k.a. the Swagger specification).
Home-page: https://github.com/marshmallow-code/apispec
Author: Steven Loria
Author-email: sloria1@gmail.com
License: MIT
Location: d:\dev\venv\superset-py38-env\lib\site-packages
Requires:
Required-by: Flask-AppBuilder
```

## colorama

跨平台的彩色终端文本支持。定义了颜色代码。

```shell
$ pip show colorama
Name: colorama
Version: 0.4.4
Summary: Cross-platform colored terminal text.
Home-page: https://github.com/tartley/colorama
Author: Jonathan Hartley
Author-email: tartley@tartley.com
License: BSD
Location: /home/keefe/venv/superset-py38-env/lib/python3.8/site-packages
Requires:
Required-by: Flask-AppBuilder, apache-superset
```

表格 colorama源码结构说明

| 目录或文件          | 主要类或函数                                           | 说明           |
| -------------- | ------------------------------------------------ | ------------ |
| ansi.py        | AnsiCodes AnsiBack AnsiCursor AnsiFore AnsiStyle | 定义name和数值的对照 |
| ansitowin32.py | StreamWrapper AnsiToWin32                        |              |
| initialise.py  | reset_all                                        |              |
| win32.py       | CONSOLE_SCREEN_BUFFER_INFO                       |              |
| winterm.py     | WinColor WinStyle WinTerm                        | 定义windows终端  |
| `__init__.py`  | __`version__ = '0.4.4'`                          | 导入模块和版本定义    |

## jsonschema

JSON Schema验证器实现。

```shell
$ pip show jsonschema
Name: jsonschema
Version: 3.2.0
Summary: An implementation of JSON Schema validation for Python
Home-page: https://github.com/Julian/jsonschema
Author: Julian Berman
Author-email: Julian@GrayVines.com
License: UNKNOWN
Location: d:\dev\venv\superset-py38-env\lib\site-packages
Requires: attrs, pyrsistent, setuptools, six
Required-by: flask-restx, Flask-AppBuilder
```

## marshmallow

用于将复杂数据类型与原生 Python 数据类型相互转换的轻量级库。

```shell
$ pip show marshmallow
Name: marshmallow
Version: 3.10.0
Summary: A lightweight library for converting complex datatypes to and from native Python datatypes.
Home-page: https://github.com/marshmallow-code/marshmallow
Author: Steven Loria
Author-email: sloria1@gmail.com
License: MIT
Location: /home/keefe/venv/superset-py38-env/lib/python3.8/site-packages
Requires:
Required-by: marshmallow-sqlalchemy, marshmallow-enum, Flask-AppBuilder
```

表格 marshmallow源码结构说明

| 目录或文件             | 主要类或函数                                        | 说明                   |
| ----------------- | --------------------------------------------- | -------------------- |
| base.py           | FieldABC SchemaABC                            | 基类                   |
| class_registry.py | get_class register                            | 类注册，通过schema字符串找到类   |
| decorators.py     | validates validates_schema ...                | 装饰器                  |
| error_store.py    | ErrorStore  merge_errors                      | 错误存储                 |
| exceptions.py     |                                               | 异常                   |
| fields.py         | Field AwareDateTime Boolean Constant Date ... | 将各种复杂字段转化成python原生类型 |
| orderedset.py     | OrderedSet                                    | 排序set                |
| py.typed          |                                               |                      |
| schema.py         | Schema SchemaMeta SchemaOpts                  | 模式                   |
| types.py          | StrSequenceOrSet Tag Validator                | 定义3种类型的成员组成          |
| utils.py          |                                               | 工具                   |
| validate.py       | Validator And ContainsNoneOf ...              | 验证                   |
| warnings.py       | RemovedInMarshmallow4Warning                  | 警告。空文件。              |

fields.py

```python
# 支持的类型，api文档的schema类型要用到
__all__ = [
    "Field",
    "Raw",
    "Nested",
    "Mapping",
    "Dict",
    "List",
    "Tuple",
    "String",
    "UUID",
    "Number",
    "Integer",
    "Decimal",
    "Boolean",
    "Float",
    "DateTime",
    "NaiveDateTime",
    "AwareDateTime",
    "Time",
    "Date",
    "TimeDelta",
    "Url",
    "URL",
    "Email",
    "IP",
    "IPv4",
    "IPv6",
    "IPInterface",
    "IPv4Interface",
    "IPv6Interface",
    "Method",
    "Function",
    "Str",
    "Bool",
    "Int",
    "Constant",
    "Pluck",
]
```

## prison

Rison编解码。

```shell
$pip show prison
Name: prison
Version: 0.1.3
Summary: Rison encoder/decoder
Home-page: https://github.com/betodealmeida/python-rison
Author: Beto Dealmeida
Author-email: beto@dealmeida.net
License: MIT
Location: d:\dev\venv\superset-py38-env\lib\site-packages
Requires: six
Required-by: Flask-AppBuilder
```

## PyJWT

python的JWT实现。

```shell
$ pip show pyjwt
Name: PyJWT
Version: 1.4.2
Summary: JSON Web Token implementation in Python
Home-page: http://github.com/jpadilla/pyjwt
Author: Jos?? Padilla
Author-email: hello@jpadilla.com
License: MIT
Location: d:\dev\venv\superset-py38-env\lib\site-packages
Requires:
Required-by: Flask-JWT, Flask-JWT-Extended, Flask-AppBuilder
```

表格 pyjwt源码结构说明 /jwt/

| 目录或文件         | 主要类或函数 | 说明  |
| ------------- | ------ | --- |
| contrib/      |        |     |
| `__init__.py` |        |     |
| `__main__.py` |        |     |
| algorithms.py |        | 算法  |
| api_jws.py    |        |     |
| api_jwt.py    |        |     |
| compat.py     |        | 兼容  |
| exceptions.py |        | 异常  |
| help.py       |        | 帮助  |
| utils.py      |        | 工具  |

<br>

# 3  flask_appbuild依赖模块-flask系列

## flask | click 模块

详见 《[flask源码剖析.md](./flask源码剖析.md)》

## flask_babel

详见 《[中文化专题](../中文化专题.md)》babel章节

## flask_login

http://www.pythondoc.com/flask-login/index.html

[flask-login](https://github.com/maxcountryman/flask-login)跟Flask app是一一对应关系，即一个app内只可能存在一个login manager，所以为了运行多个login manager，只能运行多个app.

```shell
$ pip show flask_login
Name: Flask-Login
Version: 0.4.1
Summary: User session management for Flask
Home-page: https://github.com/maxcountryman/flask-login
Author: Matthew Frazier
Author-email: leafstormrush@gmail.com
License: MIT
Location: d:\dev\venv\superset-py38-env\lib\site-packages
Requires: Flask
Required-by: Flask-AppBuilder
```

Flask-Login 为 Flask 提供了用户会话管理。它处理了日常的登入，登出并且长时间记住用户的会话。

它会:

- 在会话中存储当前活跃的用户 ID，让你能够自由地登入和登出。
- 让你限制登入(或者登出)用户可以访问的视图。login_view
- 处理让人棘手的 “记住我” 功能。remeber_me默认是365天，可以自己设置duration。
- 帮助你保护用户会话免遭 cookie 被盗的牵连。_create_identifier()
- 可以与以后可能使用的 Flask-Principal 或其它认证扩展集成。

但是，它不会:

- 限制你使用特定的数据库或其它存储方法。如何加载用户完全由你决定。
- 限制你使用用户名和密码，OpenIDs，或者其它的认证方法。
- 处理超越 “登入或者登出” 之外的权限。
- 处理用户注册或者账号恢复。

**源码**

* config.py  配置项如COOKIE_DURATION, COOKIE_SECURE, COOKIE_HTTPONLY, SESSION_PROTECTION等
* login_manager.py  LoginManager类
* mixins.py   2个类UserMixin和AnonymousUserMixin
* signals.py  定义了一些信号
* utils.py  工具类如user_login, user_logout, login_required

**小结**：

* flask-login 使用 Flask 提供的 session 来保存用户信息，通过 user_id 来记录用户身份，_id 来防止攻击者对 session 的伪造。
* 通过 _request_ctx_stack.top.user，flask-login 实现了线程安全。
* 通过 cookie 来实现 remember 功能。

### 配置项 config.py

/flask_login/config.py

```python
# -*- coding: utf-8 -*-
'''
    flask_login.config
    ------------------
    This module provides default configuration values.
'''
from datetime import timedelta

#: The default name of the "remember me" cookie (``remember_token``)
COOKIE_NAME = 'remember_token'

#: The default time before the "remember me" cookie expires (365 days).
# cookie默认保存365天, 在浏览器HTTP响应头部显示 `Cache-Control: public, max-age=31536000`
COOKIE_DURATION = timedelta(days=365)

#: Whether the "remember me" cookie requires Secure; defaults to ``None``
COOKIE_SECURE = None

#: Whether the "remember me" cookie uses HttpOnly or not; defaults to ``False``
COOKIE_HTTPONLY = False

#: The default flash message to display when users need to log in.
LOGIN_MESSAGE = u'Please log in to access this page.'

#: The default flash message category to display when users need to log in.
LOGIN_MESSAGE_CATEGORY = 'message'

#: The default flash message to display when users need to reauthenticate.
REFRESH_MESSAGE = u'Please reauthenticate to access this page.'

#: The default flash message category to display when users need to
#: reauthenticate.
REFRESH_MESSAGE_CATEGORY = 'message'

#: The default attribute to retreive the unicode id of the user
ID_ATTRIBUTE = 'get_id'

#: Default name of the auth header (``Authorization``)  基本认证
AUTH_HEADER_NAME = 'Authorization'

#: A set of session keys that are populated by Flask-Login. Use this set to
#: purge keys safely and accurately.  会话KEY
SESSION_KEYS = set(['user_id', 'remember', '_id', '_fresh', 'next'])

#: A set of HTTP methods which are exempt from `login_required` and
#: `fresh_login_required`. By default, this is just ``OPTIONS``.
EXEMPT_METHODS = set(['OPTIONS'])

#: If true, the page the user is attempting to access is stored in the session
#: rather than a url parameter when redirecting to the login view; defaults to
#: ``False``.

USE_SESSION_FOR_NEXT = False

# 以下是隐藏的可配置项
# 会话保存：basic strong
SESSION_PROTECTION = "basic"
```

### 登陆管理 login_manager.py

/flask_login/login_manager.py

```python
from datetime import datetime, timedelta

from flask import (_request_ctx_stack, abort, current_app, flash, redirect,
                   request, session)

from ._compat import text_type
from .config import (COOKIE_NAME, COOKIE_DURATION, COOKIE_SECURE,
                     COOKIE_HTTPONLY, LOGIN_MESSAGE, LOGIN_MESSAGE_CATEGORY,
                     REFRESH_MESSAGE, REFRESH_MESSAGE_CATEGORY, ID_ATTRIBUTE,
                     AUTH_HEADER_NAME, SESSION_KEYS, USE_SESSION_FOR_NEXT)
from .mixins import AnonymousUserMixin
from .signals import (user_loaded_from_cookie, user_loaded_from_header,
                      user_loaded_from_request, user_unauthorized,
                      user_needs_refresh, user_accessed, session_protected)
from .utils import (_get_user, login_url as make_login_url, _create_identifier,
                    _user_context_processor, encode_cookie, decode_cookie,
                    make_next_param, expand_login_view)


class LoginManager(object):
    def __init__(self, app=None, add_context_processor=True):

    def init_app(self, app, add_context_processor=True):
        '''
        Configures an application. This registers an `after_request` call, and
        attaches this `LoginManager` to it as `app.login_manager`.

        :param app: The :class:`flask.Flask` object to configure.
        :type app: :class:`flask.Flask`
        :param add_context_processor: Whether to add a context processor to
            the app that adds a `current_user` variable to the template.
            Defaults to ``True``.
        :type add_context_processor: bool
        '''
        app.login_manager = self
        # Flask 实例的 after_request 钩子上添加了一个用户更新 remember_me cookie 的函数
        app.after_request(self._update_remember_cookie)

        self._login_disabled = app.config.get('LOGIN_DISABLED', False)

        if add_context_processor:    # Flask的上下文处理器中添加了一个用户上下文处理器， _user_context_processor为当前用户
            app.context_processor(_user_context_processor)

    def unauthorized(self):
       """ 未登陆的处理过程 """
       user_unauthorized.send(current_app._get_current_object())

        if self.unauthorized_callback:    # 调用 未登陆回调函数
            return self.unauthorized_callback()

        if request.blueprint in self.blueprint_login_views:    # 定义登陆视图
            login_view = self.blueprint_login_views[request.blueprint]
        else:
            login_view = self.login_view

        if not login_view:
            abort(401)

        if self.login_message:    # 登陆消息本地化显示回调函数
            if self.localize_callback is not None:
                flash(self.localize_callback(self.login_message),
                      category=self.login_message_category)
            else:
                flash(self.login_message, category=self.login_message_category)

        config = current_app.config
        # 登陆URL生成：支持重定向
        if config.get('USE_SESSION_FOR_NEXT', USE_SESSION_FOR_NEXT):
            login_url = expand_login_view(login_view)
            session['next'] = make_next_param(login_url, request.url)
            redirect_url = make_login_url(login_view)
        else:
            redirect_url = make_login_url(login_view, next_url=request.url)

        return redirect(redirect_url)

    def _load_user(self):
       """处理登陆： remember_token(cookie), Authorization(header)"""
       user_accessed.send(current_app._get_current_object())

       config = current_app.config
       if config.get('SESSION_PROTECTION', self.session_protection):
           deleted = self._session_protection()    # 配置项受保护会话，则需重新登陆用户
           if deleted:
               return self.reload_user()

       is_missing_user_id = 'user_id' not in session
       if is_missing_user_id:    # 会话中没有user_id，尝试从cookie或者header里获取用户信息
           cookie_name = config.get('REMEMBER_COOKIE_NAME', COOKIE_NAME)
           header_name = config.get('AUTH_HEADER_NAME', AUTH_HEADER_NAME)
           has_cookie = (cookie_name in request.cookies and
                         session.get('remember') != 'clear')
           if has_cookie:          # 有cookie 从cookie获取用户信息
               return self._load_from_cookie(request.cookies[cookie_name])
           elif self.request_callback:            # 从request_callback获取用户信息
               return self._load_from_request(request)
           elif header_name in request.headers: # 从认证头获取用户信息
               return self._load_from_header(request.headers[header_name])

       return self.reload_user()

    ...
```

### 工具函数 utils.py

/flask_login/utils.py

需要用户登入 的视图可以用 [`login_required`](http://www.pythondoc.com/flask-login/index.html#flask.ext.login.login_required) 装饰器来装饰。

RememberMe也就是记住密码，可以让用户登录成功后，关闭浏览器再重新打开浏览器访问应用时不需要再次登录。原理是通过cookie来访问。

```python
from flask import (_request_ctx_stack, current_app, request, session, url_for,
                   has_request_context)

from .signals import user_logged_in, user_logged_out, user_login_confirmed

# 当前用户数据，_get_user未登陆时调用_load_user
current_user = LocalProxy(lambda: _get_user())


def logout_user():
    '''
    Logs a user out. (You do not need to pass the actual user.) This will
    also clean up the remember me cookie if it exists.
    用户退出：会话出弹出 user_id, _fresh; cookie清除，给当前app发出logout信号，当前app重载为匿名用户
    '''

    user = _get_user()

    if 'user_id' in session:
        session.pop('user_id')

    if '_fresh' in session:
        session.pop('_fresh')

    cookie_name = current_app.config.get('REMEMBER_COOKIE_NAME', COOKIE_NAME)
    if cookie_name in request.cookies:
        session['remember'] = 'clear'
        if 'remember_seconds' in session:
            session.pop('remember_seconds')

    user_logged_out.send(current_app._get_current_object(), user=user)

    current_app.login_manager.reload_user()
    return True


def login_user(user, remember=False, duration=None, force=False, fresh=True):
    """用户登陆数据放到APP全局数据，给APP发送login信号 """
    if not force and not user.is_active:  # 不强制刷新 或 用户不活跃，退出
        return False

    user_id = getattr(user, current_app.login_manager.id_attribute)()
    session['user_id'] = user_id
    session['_fresh'] = fresh
    session['_id'] = current_app.login_manager._session_identifier_generator()

    if remember:  # remember为ture并且duration有值，则需要处理cookie有效期。否则就是永久的会话。
        session['remember'] = 'set'
        if duration is not None:
            try:
                # equal to timedelta.total_seconds() but works with Python 2.6
                session['remember_seconds'] = (duration.microseconds +
                                               (duration.seconds +
                                                duration.days * 24 * 3600) *
                                               10**6) / 10.0**6
            except AttributeError:
                raise Exception('duration must be a datetime.timedelta, '
                                'instead got: {0}'.format(duration))

    _request_ctx_stack.top.user = user
    user_logged_in.send(current_app._get_current_object(), user=_get_user())
    return True

def login_url(login_view, next_url=None, next_field='next'):
    """
    创建一个重定向到登陆页面login_view的 url。
    示例：http://domain?next={next_url}
    :param login_view: str, The name of the login view. (缺省登陆URL指向此页面.)
    :param next_url: str 如果有，则提供了跳转链接
    :param next_field: 指向next_url的参数名称，默认为next
    """
    base = expand_login_view(login_view)

    if next_url is None:
        return base

    parsed_result = urlparse(base)
    md = url_decode(parsed_result.query)
    md[next_field] = make_next_param(base, next_url)
    netloc = current_app.config.get('FORCE_HOST_FOR_REDIRECTS') or \
        parsed_result.netloc
    parsed_result = parsed_result._replace(netloc=netloc,
                                           query=url_encode(md, sort=True))
    return urlunparse(parsed_result)


def login_required(func):
    """ 登陆需要装饰器，判断当前用户是否已验证 """
    @wraps(func)
    def decorated_view(*args, **kwargs):
        if request.method in EXEMPT_METHODS:    # 例外方法
            return func(*args, **kwargs)
        elif current_app.login_manager._login_disabled:    # 不登陆
            return func(*args, **kwargs)
        elif not current_user.is_authenticated:    # 判断当前用户是否已验证，若未验证，跳转到未验证函数
            return current_app.login_manager.unauthorized()
        return func(*args, **kwargs)
    return decorated_view

def _create_identifier():
    """ 创建防篡改的cookie ID：根据连接IP和header里的User-Agent生成base作为盐值，生成一个hash值 """
    user_agent = request.headers.get('User-Agent')
    if user_agent is not None:
        user_agent = user_agent.encode('utf-8')
    base = '{0}|{1}'.format(_get_remote_addr(), user_agent)
    if str is bytes:  #正常执行是false，不执行下行
        base = text_type(base, 'utf-8', errors='replace')  # pragma: no cover
    h = sha512()
    h.update(base.encode('utf8'))
    return h.hexdigest()
```

### cookie里的session信息破解

浏览器端的header信息

```shell
# cookie：主要2个KEY，分别是remember_token 和 session
# 1.remember_token:由flask_login模块生成，记录的是remember_me功能的user_id，格式是 user_id|user_id摘要。user_id摘要使用将user_id和security_key组合采用sha512算法生成。user_id摘要的目的是给服务器验证此cookie是否被人修改过，以保证user_id值是正确的。
# 2.session: cookie名称在flask模块Flask类里定义，cookie值生成依赖itdangerous模块的签名序列化算法。 详见《flask源码剖析》sessions.py章节。
remember_token=5|5e16c92420f51b33c4c3b7dc2eccf46ace6963402024dabc35afc3dd54aaeab3ebcdf29de906cfdbd48e8e9390508c86050ddc5ae573945b5c3298a40435caec; session=.eJztlM1uhDAMhF8F-YwqB5I44VWqFUpip6CFZUVYqepq373pz2NwGs_l08xh_IQxL6FMUmB4f0JzVIFVSgkfAi2kSdJ1PLar3Eb5vM-7cDOX5v9sm0eRfWgOKYeCy6s9ASfgBPwCLm1d1i5lguHYH1LdzDBAtqHzwlHYIyNhVEqlXiOxs5p1oOhD75WSTJYpEHsnzM4bRU6bLnvvyUYXs0NyIXVCFqNBThp7nW3uxKaApBlRWSfJuKyIkuGocnQm1h7LlsIiNcvXVN0uq6xR9rFI2m5c34ByiG_Ywk-fv9AGXt9POWeT.YVVWXA.t2LDcxYyDTneCl6w5yCNyGd89L4

# User-Agent:
Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36 Edg/93.0.961.47
```

说明：浏览器端的cookie保存的是JWT token信息，组成格式是`header.payload.signature`，完整格式是` f"{Base64URL(header)}.{Base64URL(payload)}.{signature}"`。

session生成过程

```python
# session._id 生成: 调用 _create_identifier， 结果示例如 'f6a29edbed90d070b111c3407d864d4a7b9a3911ef76d7a7d98edd895178452f99976b8bf8078ac2e760b50dc4034f6f2e6ca074d00168ec58f177c5db1fb85b'
ident = self._session_identifier_generator()


# /flask_login/utils.py
# _create_identifier： base是作为哈希的盐值。示例：base = 'b\'127.0.0.1\'|b\'PostmanRuntime/7.28.1\''
base = '{0}|{1}'.format(_get_remote_addr(), user_agent)
```

cookie的操作

```python
# /falsk_login/login_manager.py
from .utils import encode_cookie, decode_cookie

class LoginManager(object):

    def _load_from_cookie(self, cookie):
        """ 用户登陆过程中，获取 user_id """
        user_id = decode_cookie(cookie)
        if user_id is not None:
            session['user_id'] = user_id
            session['_fresh'] = False

        self.reload_user()

        if _request_ctx_stack.top.user is not None:
            app = current_app._get_current_object()
            user_loaded_from_cookie.send(app, user=_get_user())

    def _update_remember_cookie(self, response):
        """ user_login成功时 更新cookie：清除会话旧session['remember'], 根据要求set或clear cookie """
        # Don't modify the session unless there's something to do.
        if 'remember' not in session and \
                current_app.config.get('REMEMBER_COOKIE_REFRESH_EACH_REQUEST'):
            session['remember'] = 'set'

        if 'remember' in session:
            operation = session.pop('remember', None)

            if operation == 'set' and 'user_id' in session:
                self._set_cookie(response)
            elif operation == 'clear':
                self._clear_cookie(response)

        return response

   def _set_cookie(self, response):
        # cookie settings
        config = current_app.config
        cookie_name = config.get('REMEMBER_COOKIE_NAME', COOKIE_NAME)
        domain = config.get('REMEMBER_COOKIE_DOMAIN')
        path = config.get('REMEMBER_COOKIE_PATH', '/')

        secure = config.get('REMEMBER_COOKIE_SECURE', COOKIE_SECURE)
        httponly = config.get('REMEMBER_COOKIE_HTTPONLY', COOKIE_HTTPONLY)

        if 'remember_seconds' in session:    # 记住秒数
            duration = timedelta(seconds=session['remember_seconds'])
        else:    # 默认365天
            duration = config.get('REMEMBER_COOKIE_DURATION', COOKIE_DURATION)

        # prepare data: 生成cookie数据，实际数据是 f"{user_id}|{user_id的摘要数据}""
        data = encode_cookie(text_type(session['user_id']))

        if isinstance(duration, int):
            duration = timedelta(seconds=duration)

        try:
            expires = datetime.utcnow() + duration
        except TypeError:
            raise Exception('REMEMBER_COOKIE_DURATION must be a ' +
                            'datetime.timedelta, instead got: {0}'.format(
                                duration))

        # actually set it，重新设置返回给浏览器端的cookie，更新了过期时间expires
        response.set_cookie(cookie_name,
                            value=data,
                            expires=expires,
                            domain=domain,
                            path=path,
                            secure=secure,
                            httponly=httponly)

    def _clear_cookie(self, response):
        # 调用 delete_cookie 清除cookie
        config = current_app.config
        cookie_name = config.get('REMEMBER_COOKIE_NAME', COOKIE_NAME)
        domain = config.get('REMEMBER_COOKIE_DOMAIN')
        path = config.get('REMEMBER_COOKIE_PATH', '/')
        response.delete_cookie(cookie_name, domain=domain, path=path)


# /flask_login/utils.py
import hmac
from hashlib import sha512


def _secret_key(key=None):
    """ 安全KEY类型转化，返回为字节类型 """
    if key is None:
        key = current_app.config['SECRET_KEY']
    if isinstance(key, text_type):  # pragma: no cover
        key = key.encode('latin1')  # ensure bytes

    return key

def _cookie_digest(payload, key=None):
    key = _secret_key(key)
    return hmac.new(key, payload.encode('utf-8'), sha512).hexdigest()

def encode_cookie(payload):
    '''
    This will encode a ``unicode`` value into a cookie, and sign that cookie
    with the app's secret key.

    :param payload: The value to encode, as `unicode`.
    :type payload: unicode
    '''
    return u'{0}|{1}'.format(payload, _cookie_digest(payload))


def decode_cookie(cookie):
    '''
    This decodes a cookie given by `encode_cookie`. If verification of the
    cookie fails, ``None`` will be implicitly returned.

    :param cookie: An encoded cookie.
    :type cookie: str
    '''
    try:
        payload, digest = cookie.rsplit(u'|', 1)
        if hasattr(digest, 'decode'):
            digest = digest.decode('ascii')  # pragma: no cover
    except ValueError:
        return

    if safe_str_cmp(_cookie_digest(payload), digest):
        # 比较 cookie_digest是否一致。一致，说明未被修改
        return payload
```

## flask_sqlalchemy

http://www.pythondoc.com/flask-sqlalchemy/index.html

Flask-SQLAlchemy 是一个为您的 [Flask](http://flask.pocoo.org/) 应用增加 [SQLAlchemy](http://www.sqlalchemy.org/) 支持的扩展。它需要 SQLAlchemy 0.6 或者更高的版本。它致力于简化在 Flask 中 SQLAlchemy 的使用，提供了有用的默认值和额外的助手来更简单地完成常见任务。

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

源文件如下 ：

* `__init__.py`  导入兼容类的declarative_base和DeclarativeMeta，兼容协程的线程函数 _ident_func，定义类BaseQuery(orm.Query)
* _compat.py   py2&py3的兼容
* model.py    定义3个新类型有NameMetaMixin, BindMetaMixin, DefaultMeta。定义Model基类。
* utils.py 3个函数分别是parse_version, sqlalchemy_version, engine_config_warning

/flask_sqlalchemy/model.py

定义3个新类型有NameMetaMixin, BindMetaMixin, DefaultMeta。定义Model基类。

```python
import sqlalchemy as sa
from sqlalchemy import inspect
from sqlalchemy.ext.declarative import DeclarativeMeta, declared_attr
from sqlalchemy.schema import _get_table_key

from ._compat import to_str

def should_set_tablename(cls):


def camel_to_snake_case(name):


class NameMetaMixin(type):
    """ 名称元数据 """

class BindMetaMixin(type):
    def __init__(cls, name, bases, d):
        bind_key = (
            d.pop('__bind_key__', None)
            or getattr(cls, '__bind_key__', None)
        )

        super(BindMetaMixin, cls).__init__(name, bases, d)

        if bind_key is not None and getattr(cls, '__table__', None) is not None:
            cls.__table__.info['bind_key'] = bind_key


class DefaultMeta(NameMetaMixin, BindMetaMixin, DeclarativeMeta):
    pass

class Model(object):
    query_class = None
    query = None

    def __repr__(self):
        identity = inspect(self).identity
        if identity is None:
            pk = "(transient {0})".format(id(self))
        else:
            pk = ', '.join(to_str(value) for value in identity)
        return '<{0} {1}>'.format(type(self).__name__, pk)
```

## flask_wtf

http://www.pythondoc.com/flask-wtf/

**Flask-WTF** 提供了简单地 [WTForms](http://wtforms.simplecodes.com/docs/) 的集成。

```shell
$ pip show flask_wtf
Name: Flask-WTF
Version: 0.14.3
Summary: Simple integration of Flask and WTForms.
Home-page: https://github.com/lepture/flask-wtf
Author: Dan Jacob
Author-email: danjac354@gmail.com
License: BSD
Location: /home/keefe/venv/superset-py38-env/lib/python3.8/site-packages
Requires: itsdangerous, WTForms, Flask
Required-by: Flask-AppBuilder
```

**功能**

- 集成 wtforms。

- 带有 csrf 令牌的安全表单。

- 全局的 csrf 保护。

- 支持验证码（Recaptcha）。

- 与 Flask-Uploads 一起支持文件上传。

- 国际化集成。

源文件

* /flask_wtf/csrf.py  CSRFProtect类，产生和验证token方法
  
  /flask_wtf/csrf.py

```python
# /flask_wtf/csrf.py
def generate_csrf(secret_key=None, token_key=None):
    """ 产生一个token 放到最近请求的缓存里 """

def validate_csrf(data, secret_key=None, time_limit=None, token_key=None):
    """ 验证给的token是否有效 """


class CSRFProtect(object):
    def init_app(self, app):
        @app.before_request
        def csrf_protect():

            view = app.view_functions.get(request.endpoint)
            dest = '{0}.{1}'.format(view.__module__, view.__name__)

            if dest in self._exempt_views:
                return

            self.protect()
```

## flask-openid

```shell
$ pip show flask-openid
Name: Flask-OpenID
Version: 1.2.5
Summary: OpenID support for Flask
Home-page: http://github.com/mitsuhiko/flask-openid/
Author: Armin Ronacher, Patrick Uiterwijk
Author-email: armin.ronacher@active-4.com, puiterwijk@redhat.com
License: BSD
Location: d:\dev\venv\superset-py38-env\lib\site-packages
Requires: Flask, python3-openid
Required-by: Flask-AppBuilder
```

导入模块

```python
if self.auth_type == AUTH_OID:
    from flask_openid import OpenID

    self.oid = OpenID(app)
```

## flask-jwt

依赖模块 PyJWT.

```shell
$ pip show flask-jwt
Name: Flask-JWT
Version: 0.3.2
Summary: JWT token authentication for Flask apps
Home-page: https://github.com/mattupstate/flask-jwt
Author: Matt Wright
Author-email: matt@nobien.net
License: MIT
Location: d:\dev\venv\superset-py38-env\lib\site-packages
Requires: PyJWT, Flask
Required-by:
```

仅一个源文件 `/flask_jwt/__init__.py`

```python
import jwt

from flask import current_app, request, jsonify, _request_ctx_stack
from werkzeug.local import LocalProxy


current_identity = LocalProxy(lambda: getattr(_request_ctx_stack.top, 'current_identity', None))

_jwt = LocalProxy(lambda: current_app.extensions['jwt'])

CONFIG_DEFAULTS = {
    'JWT_DEFAULT_REALM': 'Login Required',
    'JWT_AUTH_URL_RULE': '/auth',
    'JWT_AUTH_ENDPOINT': 'jwt',
    'JWT_AUTH_USERNAME_KEY': 'username',
    'JWT_AUTH_PASSWORD_KEY': 'password',
    'JWT_ALGORITHM': 'HS256',
    'JWT_LEEWAY': timedelta(seconds=10),
    'JWT_AUTH_HEADER_PREFIX': 'JWT',
    'JWT_EXPIRATION_DELTA': timedelta(seconds=300),
    'JWT_NOT_BEFORE_DELTA': timedelta(seconds=0),
    'JWT_VERIFY_CLAIMS': ['signature', 'exp', 'nbf', 'iat'],
    'JWT_REQUIRED_CLAIMS': ['exp', 'iat', 'nbf']
}


def jwt_required(realm=None):
    """View decorator that requires a valid JWT token to be present in the request

    :param realm: an optional realm
    """
    def wrapper(fn):
        @wraps(fn)
        def decorator(*args, **kwargs):
            _jwt_required(realm or current_app.config['JWT_DEFAULT_REALM'])
            return fn(*args, **kwargs)
        return decorator
    return wrapper


class JWTError(Exception):
    def __init__(self, error, description, status_code=401, headers=None):
        self.error = error
        self.description = description
        self.status_code = status_code
        self.headers = headers

    def __repr__(self):
        return 'JWTError: %s' % self.error

    def __str__(self):
        return '%s. %s' % (self.error, self.description)


def encode_token():
    return _jwt.encode_callback(_jwt.header_callback(), _jwt.payload_callback())


class JWT(object):

    def __init__(self, app=None, authentication_handler=None, identity_handler=None):
        self.authentication_callback = authentication_handler
        self.identity_callback = identity_handler

        self.auth_response_callback = _default_auth_response_handler
        self.auth_request_callback = _default_auth_request_handler
        self.jwt_encode_callback = _default_jwt_encode_handler
        self.jwt_decode_callback = _default_jwt_decode_handler
        self.jwt_headers_callback = _default_jwt_headers_handler
        self.jwt_payload_callback = _default_jwt_payload_handler
        self.jwt_error_callback = _default_jwt_error_handler
        self.request_callback = _default_request_handler

        if app is not None:
            self.init_app(app)

    def init_app(self, app):
```

## flask-jwt-extended

依赖模块 PyJWT.

```shell
$ pip show flask_jwt-extended
Name: Flask-JWT-Extended
Version: 3.25.1
Summary: Extended JWT integration with Flask
Home-page: https://github.com/vimalloc/flask-jwt-extended
Author: Landon Gilbert-Bland
Author-email: landogbland@gmail.com
License: MIT
Location: d:\dev\venv\superset-py38-env\lib\site-packages
Requires: Werkzeug, Flask, PyJWT, six
Required-by: Flask-AppBuilder
```

源文件：

* config.py
* default_callbacks.py
* exceptions.py
* jwt_manager.py
* tokens.py
* utils.py
* view_decorators.py

<br>

# 参考资料

* python之Marshmallow https://www.cnblogs.com/xingxia/p/python_Marshmallow.html
