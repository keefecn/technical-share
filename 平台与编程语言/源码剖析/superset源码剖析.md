| 序号 | 修改时间 | 修改内容                                   | 修改人 | 审稿人 |
| ---- | -------- | ------------------------------------------ | ------ | ------ |
| 1   | 2021-6-11 | 创建。新增源码剖析篇章节。 | Keefe |   Keefe     |
| 2 | 2021-7-18 | 单独成文。 | Keefe |  |







----


# superset源码剖析

源码分析版本： superset-1.0

```shell
$ pip show superset
Name: superset
Version: 0.30.1
Summary: Superset has moved to apache-superset, as of 0.34.0 onwards, please pip install apache-superset
Home-page: https://superset.apache.org/
Author: Apache Software Foundation
Author-email: dev@superset.incubator.apache.org
License: Apache License, Version 2.0
Location: /home/keefe/venv/superset-py36-env/lib/python3.6/site-packages
Requires: flask, boto3, gunicorn, python-dateutil, simplejson, future, contextlib2, pandas, pyyaml, bleach, colorama, pydruid, flask-migrate, python-geohash, sq
lalchemy-utils, thrift, sqlparse, pathlib2, sqlalchemy, unidecode, celery, flask-compress, geopy, humanize, cryptography, parsedatetime, flower, flask-appbuilder, requests, six, unicodecsv, polyline, flask-testing, flask-wtf, markdown, thrift-sasl, pyhive, flask-script, idna, flask-caching
Required-by: 
```



 ## 1 源码结构 

表格  项目顶层目录结构

| 目录                  | 二级目录或文件                 | 简介                                                         |
| --------------------- | ------------------------------ | ------------------------------------------------------------ |
| dist                  | xx.tar.gz                      | 打包时`python setup.py sdist`自动生成                        |
| docker                |                                | docker相关的脚本                                             |
| helm                  |                                | helm镜像仓库的配置目录                                       |
| RELEASING             |                                | 发布日志                                                     |
| requirements          |                                | 各种安装方式的模块依赖文件                                   |
| tests                 |                                | 测试目录                                                     |
| docs                  |                                | 文档，使用spinx生成                                          |
| scripts               | pypi_push.sh   python_tests.sh | superset常用的脚本                                           |
|                       | setup.py setup.cfg             | 部署常用的一些文件。  requirement.txt 组件需求，pip freeze   README.md     CHANGELOG.md |
| **superset**          |                                | superse后端源码目录                                          |
| **superset-frontend** |                                | superset前端源码目录                                         |
| CHANGELOG.md          |                                | 版本更新日志                                                 |
| setup.py setup.cfg    |                                | 安装脚本，包括了依赖组件                                     |

 

表格  源码后端目录superset里的结构

| 目录或文件        | 次模块                                       | 简介                                                         |
| ----------------- | -------------------------------------------- | ------------------------------------------------------------ |
| annotation_layers |                                              | 锚点层                                                       |
| (弃) assets       |                                              | 前端依赖框架集成，这里存放了npm集成的依赖js框架，当你打开后会看到node_modules文件夹，由npm动态生成，命令是`$ npm run dev-fast`<br>1.x版本已将此目录移到外层，改为superset-frontend |
| async_events      |                                              | 异步事件                                                     |
| cachekeys         |                                              | 缓存键K-V                                                    |
| charts            | api.py dao.py filters.py schemas.py          | 图表的API，数据库操作、过滤处理、解析查询参数的JSON项        |
| commands          | BaseCommand ExportModelsCommand              | 支持的命令                                                   |
| common            |                                              |                                                              |
| connectors        |                                              | 数据库连接器，连接数据源有2种类型，通过ConnectorRegistry连接 |
| db_engines        |                                              | DB引擎                                                       |
| dao               | BaseDAO DAOException                         | 数据访问基类、数据访问异常类                                 |
| dashboards        |                                              | 看板。结构类似图表。                                         |
| databases         |                                              | 数据库dbs/数据源。结构类似图表。                             |
| datasets          |                                              | 数据集。结构类似图表。                                       |
| db_engines        |                                              | 0.x时就有的目录。连接其他数据库的engines 比如mysql，pgsql等  |
| db_engine_spec    |                                              | 同上                                                         |
| examples          |                                              | 17个示例数据集，用 superset load-examples加载，需从网络下载  |
| migrations        |                                              | 做数据迁移用的，比如更新数据库，更新ORM(model和表中字段的映射关系)。 |
| models            |                                              | 存放项目的model，如果要修改字段，优先到这里寻找。            |
| quaries           |                                              | 查询SQL相关。结构类似图表。                                  |
| reports           |                                              | 报表相关。结构类似图表。                                     |
| security          | SupersetSecurityManager  DBSecurityException | 安全权限管理                                                 |
| sql_validators    |                                              | SQL验证                                                      |
| **static**        | assets                                       | 存放静态文件的目录，比如我们用到的css、js、图片等静态文件都在这里。superset-frontend前端构建打包后生成的文件放到这。 |
| tasks             |                                              | celery 任务脚本                                              |
| **templates**     | appbuilder, email, slack, superset           | JinJa2模板目录，项目所有的HTML文件都在这里。<br>superset/basic.html提供web整体的样式风格。<br>appbuilder/navbar_menu.html导航菜单 |
| translations      | zh en ...                                    | 翻译文件，只需修改字段对应的名称。                           |
| utils             |                                              | 工具                                                         |
| views             | health.py  core.py                           | 视图文件，这里定义了url，来作为前端的入口。  <br>core.py中的函数在渲染页面时，都要指定basic.html模板为基础。 |
| app.py            | create_app                                   | WEB实例初始化，也是调试入口                                  |
| cli.py            |                                              | superset命令                                                 |
| viz.py            | BaseViz NVD3Viz viz_types                    | 可视化图表类型的基类及派生类。viz_sip38.py是替换版本。       |
| extensions.py     |                                              | 定义 celery， logger 等中间件                                |

 >superset后端用到的组件主要有：flask_appbuilder, flask_sqlalchemy, Jinja2, pandas



表格  前端目录superset-frontend源码结构

| 目录或文件        | 二级目录或文件 | 简介                                                         |
| ----------------- | -------------- | ------------------------------------------------------------ |
| .eslintrc.js      |                | eslint配置文件                                               |
| babel.config.js   |                | babel配置文件。可将jsx文件编译成js。                         |
| package.json      |                | 前端模块依赖，用npm/yarn管理                                 |
| webpack.config.js |                | webpack构建配置文件。前端入口文件。<br>定义了 以src文件夹去生成打包js文件。 |
| src               |                | 源码                                                         |
|                   | components     | 各个最小组件的详细布局和数据                                 |
|                   | chart          | 根据图表属性渲染具体图表页面，里面调用了**SuperChart**组件。<br>而此组件属于superset-ui前端库，会根据后台传入的属性，最终渲染出对应的图表组件。 |
|                   | explore        | 生成某个图表详情的页面，如表单项。<br>controls.jsx 表单项列表 |
|                   | filters        | 过滤器                                                       |
|                   | visualizations | 可视化图表类型实现                                           |
|                   | views          | 路由映射视图，各个页面的详细布局在此，如/welcome/是首页      |
|                   | ...            |                                                              |
| branding          |                | 存放项目logo                                                 |
| cypress-base      | cypress        | UI自动化测试框架                                             |
| images            |                | 图片                                                         |
| spec              |                |                                                              |
| stylesheets       |                |                                                              |

> superset前端用到的组件主要有：React, D3



## 2 前后端联动

前端指superset客户端，使用前端框架react实现。后端指superset服务端，python实现。

### 组件概述 

**依赖组件**：

前端组件

*  React：交互，包括tsx语法、过滤器、hook等
*  D3/NVD3：图表

后端组件

*  Flask：web服务框架,  flask模块依赖jinja2
*  Jinja2：模板引擎
*  SQLALchemy：数据访问
*  Pandas：数据结果展示



**架构**

* 服务端架构：MVTC，M-数据模型falsk_sqlalchemy，V-视图类flask_appbuilder，T-模板jinja2，C-路由分发、异步请求。

* 客户端架构：MVC，M-存储react-redux，V-视图组件react，C-路由分发react-dom-route

**国际化**

* 前端：依赖 @superset-ui，使用 t()
* 后端：依赖 flask_babel，使用 __()



### 前后端交互流程

**整体流程**

1. npm run dev --将每个模块打包成一个单独的js文件bundle（在webpack.config.js中配置）
2. superset run  --启动http服务
3. 浏览器登录  --记录cookie
4. 点击某一菜单
5. wsgi 将请求重定向到python侧，执行路由视图函数（多定义在 /superset/views/xx.py）
6. 视图函数用render_template构造html页面（render_templatec参数有jinja2模板和数据参数，数据参数一般包括entry和data-bootstrap）
7. 浏览器render后端返回的html页面



**前后端打包**： 

* 后端打包setup.py 取的版本号来自  前端superset-frontend/package.json:  `python setup.py sdist`
* 前端生成的包 在superset/static目录，打包配置文件是webpack.config.js： `npm run build`

**前后端分离不能彻底的原因**

superset使用了服务器端渲染HTML + 客户端渲染组件的组合方案。每个服务首页依赖于服务端渲染，superset大概有10个服务页。因此，前后端不能实现完全的分离。

* 服务端渲染HTML：服务首页只包括了基础数据、导航菜单和HTML框架。服务端导入JS/CSS文件通过js_bundle/css_bundle(name)定位到具体的react js/css文件。
* 客户端渲染：具体的组件渲染和交互由前端React来完成。

联调：前端调试时仍需superset支持，可本地安装部署superset。如果本地安装不便，可以直接使用测试环境，将前端构建生成目录覆盖superset/static下相应文件即可。



#### 前后端映射js/css文件

* /superset/extensions.py  包括ResultsBackendManager和UIManifestProcessor，UIManifestProcessort管理前端脚本文件（用到mainfest.json)。
* /superset/static/assets/manifest.json   前端脚本文件信息，前端构建成功后自动生成。
* /superset-frontend/webpack.config.js   前端构建脚本，有打包文件入口定义entry。 详见章节 `前端构建逻辑`

/superset/extensions.py

```python
import json
import os
from typing import Any, Callable, Dict, List, Optional

import celery
from cachelib.base import BaseCache
from flask import Flask
from flask_appbuilder import AppBuilder, SQLA
from flask_migrate import Migrate
from flask_talisman import Talisman
from flask_wtf.csrf import CSRFProtect
from werkzeug.local import LocalProxy

from superset.utils.async_query_manager import AsyncQueryManager
from superset.utils.cache_manager import CacheManager
from superset.utils.feature_flag_manager import FeatureFlagManager
from superset.utils.machine_auth import MachineAuthProviderFactory


class ResultsBackendManager:
    """ 后端结果管理 """
    def __init__(self) -> None:
        self._results_backend = None	#后端结果存储
        self._use_msgpack = False		#后端消息队列

    def init_app(self, app: Flask) -> None:
        self._results_backend = app.config["RESULTS_BACKEND"]
        self._use_msgpack = app.config["RESULTS_BACKEND_USE_MSGPACK"]

    @property
    def results_backend(self) -> Optional[BaseCache]:
        return self._results_backend

    @property
    def should_use_msgpack(self) -> bool:
        return self._use_msgpack

    
class UIManifestProcessor:
    """ UI mainfest文件处理器。
    虽然会将 get_manifest 函数注册到app，但这个函数似乎并未被使用过。那么本类似乎也从来没用过？
    """
    def __init__(self, app_dir: str) -> None:
        self.app: Optional[Flask] = None
        self.manifest: Dict[str, Dict[str, List[str]]] = {}
        self.manifest_file = f"{app_dir}/static/assets/manifest.json"

    def init_app(self, app: Flask) -> None:
        self.app = app
        # Preload the cache
        self.parse_manifest_json()
        
        @app.context_processor
        def get_manifest() -> Dict[  # pylint: disable=unused-variable
            str, Callable[[str], List[str]]
        ]:  """ 获取mainfest里的静态文件 """
            
   def parse_manifest_json(self) -> None:
        try:	# 读取json文件，取值entrypoints
            with open(self.manifest_file, "r") as f:
                full_manifest = json.load(f)
                self.manifest = full_manifest.get("entrypoints", {})
        except Exception:  # pylint: disable=broad-except
            pass
        
    def get_manifest_files(self, bundle: str, asset_type: str) -> List[str]:
        """ 通过bundle键从manifest.json获取值。如果是deubug模式，则从磁盘实时读取json文件 """
        if self.app and self.app.debug:
            self.parse_manifest_json()
        return self.manifest.get(bundle, {}).get(asset_type, [])
    
        
APP_DIR = os.path.dirname(__file__)
appbuilder = AppBuilder(update_perms=False)
# 异步查询管理、缓存管理
async_query_manager = AsyncQueryManager()  
cache_manager = CacheManager()
celery_app = celery.Celery()
csrf = CSRFProtect()
db = SQLA()
# 本地代理LocalProxy：事件日志、安全管理
_event_logger: Dict[str, Any] = {}
event_logger = LocalProxy(lambda: _event_logger.get("event_logger"))
feature_flag_manager = FeatureFlagManager()
machine_auth_provider_factory = MachineAuthProviderFactory()
manifest_processor = UIManifestProcessor(APP_DIR)
migrate = Migrate()
results_backend_manager = ResultsBackendManager()
security_manager = LocalProxy(lambda: appbuilder.sm)
talisman = Talisman()    
```



**/superset/static/assets/manifest.json  前端脚本文件管理**

前端构建时生成，罗列了前端用到的静态文件js/css。entrypoints是入口。

```json
{
  "app": "superset",
  "entrypoints": {
    "theme": {
      "css": [
        "/static/assets/theme.d2b6a75182b640fe1d54.entry.css"
      ],
      "js": [
        "/static/assets/theme.d2b6a75182b640fe1d54.entry.js"
      ]
    },
    "preamble": {
      "css": [],
      "js": [
        "/static/assets/62972ce831e91d2dca0d.chunk.js",
        "/static/assets/dc683cbf32f0aef035a1.chunk.js",
        "/static/assets/preamble.5e6f4a5179518c022dee.entry.js"
      ]
    },
    "addSlice": {
      "css": [
        "/static/assets/addSlice.d41169c29a209c310582.entry.css"
      ],
      "js": [
        "/static/assets/62972ce831e91d2dca0d.chunk.js",
        "/static/assets/1892de5deadee276f4a2.chunk.js",
        "/static/assets/b10f92a903cc38d8427a.chunk.js",
        "/static/assets/addSlice.d41169c29a209c310582.entry.js"
      ]
    },
    "explore": {
      "css": [
        "/static/assets/explore.3d9deffb55fed5cd873e.entry.css"
      ],
      "js": [
        "/static/assets/62972ce831e91d2dca0d.chunk.js",
        "/static/assets/1892de5deadee276f4a2.chunk.js",
        "/static/assets/b10f92a903cc38d8427a.chunk.js",
        "/static/assets/explore.3d9deffb55fed5cd873e.entry.js"
      ]
    },
    "dashboard": {
      "css": [
        "/static/assets/dashboard.ed6e450574e9c2b600ae.entry.css"
      ],
      "js": [
        "/static/assets/62972ce831e91d2dca0d.chunk.js",
        "/static/assets/1892de5deadee276f4a2.chunk.js",
        "/static/assets/b10f92a903cc38d8427a.chunk.js",
        "/static/assets/dashboard.ed6e450574e9c2b600ae.entry.js"
      ]
    },
    "sqllab": {
      "css": [
        "/static/assets/sqllab.3bf302f60a7d158e1af2.entry.css"
      ],
      "js": [
        "/static/assets/62972ce831e91d2dca0d.chunk.js",
        "/static/assets/dc683cbf32f0aef035a1.chunk.js",
        "/static/assets/sqllab.3bf302f60a7d158e1af2.entry.js"
      ]
    },
    "crudViews": {
      "css": [
        "/static/assets/crudViews.25fc76dd77af13aa3e2d.entry.css"
      ],
      "js": [
        "/static/assets/62972ce831e91d2dca0d.chunk.js",
        "/static/assets/1892de5deadee276f4a2.chunk.js",
        "/static/assets/b10f92a903cc38d8427a.chunk.js",
        "/static/assets/crudViews.25fc76dd77af13aa3e2d.entry.js"
      ]
    },
    "menu": {
      "css": [],
      "js": [
        "/static/assets/62972ce831e91d2dca0d.chunk.js",
        "/static/assets/dc683cbf32f0aef035a1.chunk.js",
        "/static/assets/menu.8f8be0ac12b9b0b96090.entry.js"
      ]
    },
    "profile": {
      "css": [
        "/static/assets/profile.be686dc9c5bf9d7c0496.entry.css"
      ],
      "js": [
        "/static/assets/62972ce831e91d2dca0d.chunk.js",
        "/static/assets/dc683cbf32f0aef035a1.chunk.js",
        "/static/assets/profile.be686dc9c5bf9d7c0496.entry.js"
      ]
    },
    "showSavedQuery": {
      "css": [
        "/static/assets/showSavedQuery.852d0a2e94dc0d585568.entry.css"
      ],
      "js": [
        "/static/assets/62972ce831e91d2dca0d.chunk.js",
        "/static/assets/showSavedQuery.852d0a2e94dc0d585568.entry.js"
      ]
    }
  }
}
```

说明:  maninfest.json里文件是最终生成js/css文件，源文件可以根据key值 如proflie到 webpack.config.js找到原始文件的入口。



#### 模板渲染

模板渲染是可读简易的模板通过模板引擎生成最终的可被浏览器加载的HTML网页内容。 

此处模板包括Python Jinja2模板 和 React jsx模板。

大致流程：python端渲染jinja2模板（页面整体布局）＋数据data-bootstrap；浏览器接收响应结果，判断数据有没更新，有则将数据填充到局部模板（局部模板在js端定义，只刷新本处数据）。

* 后端模板渲染 .html： 
  * flask.templating.render_template(template_path, entry, bootstrap-data,)   templates目录下查找template_path文件，js_bundle(entry)导入静态文件，传输数据 bootstrap-data
* 前端模板渲染 .tsx：
  * ReactDOM.render(template,  template_pos)  将模板(参数1)转为HTML语言，并插入指定的DOM节点(参数2)。



1. 后端模板渲染

   **调用示例**   视图BaseView、ModelView 调用的调用方式

   ```python
   # /superset/views/base.py
   from flask_appbuilder import BaseView, Model, ModelView
   
   def common_bootstrap_payload() -> Dict[str, Any]:
       """Common data always sent to the client """
       messages = get_flashed_messages(with_categories=True)
       # 语种：调用flask_babel模块上下文属性 ctx.babel_locale 或者 app.extensions['babel']
       locale = str(get_locale())	
   
       return {
           "flash_messages": messages,
           "conf": {k: conf.get(k) for k in FRONTEND_CONF_KEYS},
           "locale": locale,
           "language_pack": get_language_pack(locale),  #获取语言包，读取$locale/LC_MESSAGES/messages.json
           "feature_flags": get_feature_flags(),
           "extra_sequential_color_schemes": conf["EXTRA_SEQUENTIAL_COLOR_SCHEMES"],
           "extra_categorical_color_schemes": conf["EXTRA_CATEGORICAL_COLOR_SCHEMES"],
           "menu_data": menu_data(),	#菜单数据，国际化部分从flask_appbuilder取语言包
       }
   
   
   class SupersetModelView(ModelView):
       # ModelView视图：数据库CRUD相关
       page_size = 100
       list_widget = SupersetListWidget
   
       def render_app_template(self) -> FlaskResponse:
           payload = {
               "user": bootstrap_user_data(g.user),
               "common": common_bootstrap_payload(),	# common数据
           }
           # 最终调用 flask_appbuilder/ModelView.render_template()
           # 参数1-模板文件，参数2-entry用来加载静态文件；参数3-可选boostrap_data是数据
           return self.render_template(
               "superset/crud_views.html",  # jinja2模板
               entry="crudViews",  # 此处entry名crudViews 可在/superset/static/mainfest.json找到对应的最终js/css文件
               bootstrap_data=json.dumps(
                   payload, default=utils.pessimistic_json_iso_dttm_ser
               ),
           )
       
       
   class BaseSupersetView(BaseView):
       """ """
       
       
       
   # /superset/views/core.py
   from superset.views.base import BaseSupersetView
   class Superset(BaseSupersetView):      
       """ BaseView方式的路由视图函数  """
       ...
       
       @has_access
       @event_logger.log_this
       @expose("/request_access/")
       def request_access(self) -> FlaskResponse:    
           
           ...    
           # 最终调用 flask_appbuilder/BaseView.render_template()
           return self.render_template(
               "superset/request_access.html",
               datasources=datasources,
               datasource_names=", ".join([o.name for o in datasources]),
        )    
   ```
   
   
   
   **实现逻辑**  /flask/templating.py

```python
# flask_appbuilder.[BaseView|ModelView].render_template 最终都是调用 falsk.templating.render_template()
# /flask/templating.py
def _render(template, context, app):
    """Renders the template and fires the signal"""

    before_render_template.send(app, template=template, context=context)
    rv = template.render(context)
    template_rendered.send(app, template=template, context=context)
    return rv

def render_template(template_name_or_list, **context):
    """Renders a template from the template folder with the given context.
	调用示例:
	    return self.render_template(
            "superset/request_access.html",
            datasources=datasources,
            datasource_names=", ".join([o.name for o in datasources]),
        )
    :param template_name_or_list: the name of the template to be
                                  rendered, or an iterable with template names
                                  the first one existing will be rendered
    :param context: the variables that should be available in the
                    context of the template.
    """
    ctx = _app_ctx_stack.top
    ctx.app.update_template_context(context)
    return _render(
        ctx.app.jinja_env.get_or_select_template(template_name_or_list),
        context,
        ctx.app,
    )



# /flask_appbuilder/baseview.py
class BaseView(object):
	def render_template(self, template, **kwargs):
        
class ModelView(object):
	def render_template(self, template, **kwargs):
        """
            Use this method on your own endpoints, will pass the extra_args
            to the templates.

            :param template: The template relative path
            :param kwargs: arguments to be passed to the template
        """
        kwargs["base_template"] = self.appbuilder.base_template
        kwargs["appbuilder"] = self.appbuilder
        return render_template(
            template, **dict(list(kwargs.items()) + list(self.extra_args.items()))
        )
```



2. 前端模板渲染示例 

   见下文 《前端打包入口文件》
   
   

**ReactDOM.render渲染过程**

1. 首先我们写的JSX语法，都被Babel进行转义，然后使用React.creatElement进行创建，转换为React的元素
2. 使用ReactDom.render创建root对象，执行root.render。
3. 一系列函数调用之后，workLoop在一次渲染周期内，遍历虚拟DOM，将这些虚拟DOM传递给performUnitOfWork函数，performUnitOfWork函数开启一次workTime，将虚拟DOM传递给beginWork。
4. beginWork根据虚拟DOM的类型，进行不同的处理，将子元素处理为Fiber类型，为Fiber类型的虚拟DOM添加父节点、兄弟节点等（就是转换为Fiber树）。
5. beginWork处理完一次操作之后，返回需要处理的子元素再继续处理，直到沒有子元素（即返回null），
6. 此时performUnitOfWork调用completeUnitOfWork进行初始化生命周期的挂载，以及调用completeWork进行DOM的渲染。
7. completeWork对节点类型进行操作，发现是html相关的节点类型，添加渲染为真实的DOM。
8. 最后将所有的虚拟DOM，渲染为真实的DOM。



#### 服务端渲染

服务端渲染（Server-Side Rendering，以下简称 SSR ）是一个将通过前端框架构建的网站通过后端渲染模板的形式呈现的过程。

能够在服务端和客户端上渲染的应用称为 universal 应用。

首先在服务端上渲染你的 app（渲染首屏），接着再在客户端上使用 SPA（单页应用）。

SSR + SPA = Universal App



#### **参数传递：rison格式**

示例：/api/v1/chart/?q=(order_column:slice_name,order_direction:asc,page:0,page_size:25)

```tsx
  function handleBulkChartDelete(chartsToDelete: Chart[]) {
    SupersetClient.delete({
      endpoint: `/api/v1/chart/?q=${rison.encode(
        chartsToDelete.map(({ id }) => id),
      )}`,
    }).then(
      ({ json = {} }) => {
        refreshData();
        addSuccessToast(json.message);
      },
      createErrorHandler(errMsg =>
        addDangerToast(
          t('There was an issue deleting the selected charts: %s', errMsg),
        ),
      ),
    );
  }
```





### 首页 

首页指登陆后跳转页面 http://HOST:PORT/superset/welcome

* 首页接口  /superset/views/core.py
* 首页布局  /superset/templates/
* 首页交互逻辑  /superset-frontend/

#### 首页接口 

* 缺省登陆视图  / ->   /superset/welcome  	/superset/views/core.py

* 登陆接口    AuthDBView.login -> AuthView   /flask_appbuilder/security/views.py



/superset/views/core.py

```python
class Superset(BaseSupersetView): 
    ...
    
    @event_logger.log_this
    @expose("/welcome")
    def welcome(self) -> FlaskResponse:
        """Personalized welcome page"""
        if not g.user or not g.user.get_id():              
            if conf.get("PUBLIC_ROLE_LIKE_GAMMA", False) or conf["PUBLIC_ROLE_LIKE"]:
                # 允许匿名用户的欢迎首页
                return self.render_template("superset/public_welcome.html")
            # 重定向到登陆页
            return redirect(appbuilder.get_url_for_login)

        welcome_dashboard_id = (
            db.session.query(UserAttribute.welcome_dashboard_id)
            .filter_by(user_id=g.user.get_id())
            .scalar()
        )
        if welcome_dashboard_id:
            return self.dashboard(str(welcome_dashboard_id))

        payload = {
            "user": bootstrap_user_data(g.user),
            "common": common_bootstrap_payload(),
        }
		# 模板渲染：参数1指向jinja2模板文件，参数2是前端文件入口，参数3是要替换的数据
        return self.render_template(
            "superset/crud_views.html",	#此模板文件定义了首页布局，并用js_bundle($entry)绑定了构建后的前端静态文件
            entry="crudViews",			#通过entry名称定位到构建后的前端静态文件
            bootstrap_data=json.dumps(	#此数据替换模板里的相应内容
                payload, default=utils.pessimistic_json_iso_dttm_ser
            ),
        )  
```



/flask_appbuilder/security/views.py

```python
from ..baseviews import BaseView

class AuthView(BaseView):
    
class AuthDBView(AuthView):
    login_template = "appbuilder/general/security/login_db.html"

    @expose("/login/", methods=["GET", "POST"])
    def login(self):
```



#### 首页布局 /superset/templates/

首页组成五大块： 导航栏navbar  Recent  看板 已保存查询  图表

以下模板文件路径前缀省略 /superset/templates/,  

外部模板文件依赖：/superset/templates/appbuuilder目录下没有的模板文件，会到依赖模块 flask_appbuilder/templates/appbuilder/目录下查找。

* 首页   
  * 正常登陆后的页面(appbuilder)  appbuilder/baselayout.html  -> appbuilder/init.html  
  * **正常登陆后的页面(superset)**  superset/crud_views.html ->  superset/basic.html
  * 允许匿名用户的欢迎页面  superset/public_welcome.html  -> appbuilder/base.html
  * 登陆页  appbuilder/general/security/login_db.html  数据库认证方式模板
  
* 导航栏navbar    appbuilder/navbar.html  包括navbar_right.html  navbar_menu.html
* Recent
* 看板
* 已保存查询 
* 图表



superset/crud_views.html

```jinja2
{% extends "superset/basic.html" %}

{% block navbar %}
{% endblock %}

{% block tail_js %}
  {{ js_bundle("crudViews") }}   {# 此处导入前端文件，webpack_config.js:  crudViews: addPreamble('/src/views/index.tsx'), #}
  {% include "tail_js_custom_extra.html" %}
{% endblock %}
```

说明： `js_bundle/css_bundle` 可通过入参名在mainfest.json找到相应的打包文件xxx.bundle.js/css.



superset/basic.html

```jinja2
<!DOCTYPE html>
{% import 'appbuilder/general/lib.html' as lib %}
{% from 'superset/partials/asset_bundle.html' import css_bundle, js_bundle with context %}

{% set favicons = appbuilder.app.config['FAVICONS'] %}
<html>
  <head>
    <title>  {# 网页title内容取 title变量或者app_name #}
      {% block title %}
        {% if title %}
          {{ title }}
        {% elif appbuilder and appbuilder.app_name %}
          {{ appbuilder.app_name }}
        {% endif %}
      {% endblock %}
    </title>
    
    {% block head_meta %}{% endblock %}
    {% block head_css %}
      {% for favicon in favicons %}
        <link
          rel="{{favicon.rel if favicon.rel else "icon"}}"
          type="{{favicon.type if favicon.type else "image/png"}}"
          {% if favicon.sizes %}sizes={{favicon.sizes}}{% endif %}
          href="{{favicon.href}}"
        >
      {% endfor %}
      <link rel="stylesheet" type="text/css" href="/static/appbuilder/css/flags/flags16.css" />
      <link rel="stylesheet" type="text/css" href="/static/appbuilder/css/font-awesome.min.css">

      {{ css_bundle("theme") }}

      {% if entry %}   {# 根据传参entry，获取react打包文件  #}
        {{ css_bundle(entry) }}
      {% endif %}

    {% endblock %}

    {{ js_bundle("theme") }}

	{# CSRF_token隐藏框 #}
    <input
      type="hidden"
      name="csrf_token"
      id="csrf_token"
      value="{{ csrf_token() if csrf_token else '' }}"
    >
  </head>

  <body {% if standalone_mode %}class="standalone"{% endif %}>
    {% block navbar %}  {# 导航栏，如果非iframe模式，则包含导航栏 #}
      {% if not standalone_mode %}
        {% include 'appbuilder/navbar.html' %}
      {% endif %}
    {% endblock %}

    {% block body %}
      <div id="app" data-bootstrap="{{ bootstrap_data }}">
        <img src="/static/assets/images/loading.gif" style="width: 50px; position: absolute; top: 50%; left: 50%; transform: translate(-50%,-50%)">
      </div>
    {% endblock %}

    <!-- Modal for misc messages / alerts  -->
    <div class="misc-modal modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
      <div class="modal-dialog" role="document">
        <div class="modal-content" data-test="modal-content">
          <div class="modal-header" data-test="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close" data-test="modal-header-close-button">
              <span aria-hidden="true">&times;</span>
            </button>
            <h4 data-test="modal-title" class="modal-title"></h4>
          </div>
          <div data-test="modal-body" class="modal-body">
          </div>
          <div data-test="modal-footer" class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>

    {% block tail_js %}
      {% if not standalone_mode %}
        {{ js_bundle('menu') }}
      {% endif %}
      {% if entry %}
        {{ js_bundle(entry) }}
      {% endif %}
      {% include "tail_js_custom_extra.html" %}
    {% endblock %}
  </body>
</html>
```



#### 首页React组件 

/superset-frontend/src/views/  （以下文件名忽略文件前缀路径 /superset-frontend/src/views/  ）

* index.tsx   crudViews映射到的视图（从webpack.config.js Config.entry找到映射关系）
* App.tsx  全局路由，可以找到首页路由/superset/welcome/映射的组件Welcome
* CRUD/welcome/Welcome.tsx  首页组件Welcome

/src/views/index.tsx

```tsx
import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';

// 渲染效果： <div id="app"> 模板App的HTML文本 </div>
ReactDOM.render(<App />, document.getElementById('app'));
```



/superset-frontend/src/views/App.tsx

```tsx
import Welcome from './CRUD/welcome/Welcome';

const App = () => (
  <ReduxProvider store={store}>
    <ThemeProvider theme={supersetTheme}>
      <FlashProvider common={common}>
        <Router>
          <DynamicPluginProvider>
            <QueryParamProvider
              ReactRouterRoute={Route}
              stringifyOptions={{ encode: false }}
            >
              <Switch>
                <Route path="/superset/welcome/">
                  <ErrorBoundary>
                    <Welcome user={user} />
                  </ErrorBoundary>
                </Route>
                  ...
              </Switch>
              <ToastPresenter />
            </QueryParamProvider>
          </DynamicPluginProvider>
        </Router>
      </FlashProvider>
    </ThemeProvider>
  </ReduxProvider>
);                  
```



/superset-frontend/src/views/CRUD/welcome/Welcome.tsx

```tsx

```





#### 首页前端交互

/superset-frontend/src/views/CRUD/welcome/

* ActivityTable.tsx  Recents栏切换表格
* ChartTable.tsx
* DashboardTable.tsx
* SavedQueries.tsx
* Welcome.tsx  首页全局布局组件，会引用其它4个文件



1. Recents栏切换表格

/superset-frontend/src/views/CRUD/welcome/ActivityTable.tsx:127

```tsx
import React from 'react';
import moment from 'moment';
import { styled, t } from '@superset-ui/core';

import Loading from 'src/components/Loading';
import ListViewCard from 'src/components/ListViewCard';
import SubMenu from 'src/components/Menu/SubMenu';
import { ActivityData } from './Welcome';
import { mq, CardStyles } from '../utils';
import EmptyState from './EmptyState';

// 函数-活动表格
export default function ActivityTable({
  loading,
  activeChild,
  setActiveChild,
  activityData,
}: ActivityProps) {
  const getFilterTitle = (e: ActivityObjects) => {
    if (e.dashboard_title) return e.dashboard_title;
    if (e.label) return e.label;
    if (e.url && !e.table) return e.item_title;
    if (e.item_title) return e.item_title;
    return e.slice_name;
  };
    
 // 三个tab: Viewed Edited Created   
 const tabs = [
    {
      name: 'Edited',
      label: t('Edited'),
      onClick: () => {
        setActiveChild('Edited');
      },
    },
    {
      name: 'Created',
      label: t('Created'),
      onClick: () => {
        setActiveChild('Created');
      },
    },
  ];

  if (activityData?.Viewed) {
    tabs.unshift({
      name: 'Viewed',
      label: t('Viewed'),
      onClick: () => {
        setActiveChild('Viewed');
      },
    });
  } else {
    tabs.unshift({
      name: 'Examples',
      label: t('Examples'),
      onClick: () => {
        setActiveChild('Examples');
      },
    });
  }
```



### 导航栏

导航栏指 页面顶层的一排导航菜单项，导航栏进入到各个页面都保持不变。

导航栏的数据来自于后端，但导航栏的布局在前后端都有。



#### 导航栏布局

导航栏navbar： `nav_brand  菜单nav_menu 导航栏右侧navbar_right`

导航栏菜单nav_menu沿用了flask_appbuilder的布局和实现方式。superset派生模板是navbar 和 navbar_right。

* /superset/templates/appbuilder/navbar.html 导航栏
* /superset/templates/appbuilder/navbar_right.html  导航右侧，用户非匿名登陆时增加下拉菜单等。 
* /superset-frontend/src/components/menu/Menu.tsx  菜单组件Ｍenu和菜单数据转化函数MenuWrapper
* /superset-frontend/src/views/App.tsx   这里有使用组件Ｍenu和从后端传来的数据data-bootstrap.menu。



**/superset/templates/appbuilder/navbar.html  **

这个模板只重新定义了 navbar-brand。

```jinja2
{% set menu = appbuilder.menu %}
{% set app_icon_width = appbuilder.app.config['APP_ICON_WIDTH'] %}
{% set logo_target_path = appbuilder.app.config['LOGO_TARGET_PATH'] or '/profile/{}/'.format(current_user.username) %}
{% set root_path = logo_target_path if not logo_target_path.startswith('/') else '/superset' + logo_target_path if current_user.username is defined else '#'  %}

{% block navbar %}
  <div id="app-menu">
    <div class="navbar navbar-static-top {{menu.extra_classes}}" role="navigation">
      <div class="container-fluid">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="{{ root_path }}">
            <img
              width="{{ app_icon_width }}"
              src="{{ appbuilder.app_icon }}"
              alt="{{ appbuilder.app_name }}"
            />
          </a>
        </div>
      </div>
    </div>
  </div>
{% endblock %}
```



/superset/templates/appbuilder/navbar_right.html  

导航栏右侧。主要有下面修改：

* 非匿名用户时，增加下拉菜单项。

* 判断是否有文档链接、BUG报告链接、多语种支持，从而展现相应内容。

* 判断用户是否登陆 展现不同内容。

```jinja2
{% set bug_report_url = appbuilder.app.config['BUG_REPORT_URL'] %}
{% set documentation_url = appbuilder.app.config['DOCUMENTATION_URL'] %}
{% set documentation_text = appbuilder.app.config['DOCUMENTATION_TEXT'] %}
{% set documentation_icon = appbuilder.app.config['DOCUMENTATION_ICON'] %}
{% set version_string = appbuilder.app.config['VERSION_STRING'] %}
{% set version_sha = appbuilder.app.config['VERSION_SHA'] %}

{% set locale = session['locale'] %}
{% if not locale %}
    {% set locale = 'en' %}
{% endif %}

{% if not current_user.is_anonymous %}   {# 非匿名用户增加下拉菜单 #}
    <li class="dropdown">
        <button type="button" style="margin-top: 12px; margin-right: 30px;" data-toggle="dropdown" class="dropdown-toggle btn btn-sm btn-primary">
          <i class="fa fa-plus"></i> {{ _("New") }}
        </button>
        <ul class="dropdown-menu">
            <li><a href="/superset/sqllab"><span class="fa fa-fw fa-search"></span> {{_("SQL Query")}}</a></li>
            <li><a href="/chart/add"><span class="fa fa-fw fa-bar-chart"></span> {{_("Chart")}}</a></li>
            <li><a href="/dashboard/new/"><span class="fa fa-fw fa-dashboard"></span> {{_("Dashboard")}}</a></li>
        </ul>
    </li>
{% endif %}

{% if documentation_url %}		{# 文档链接判断块 #}
<li>
  <a
    tabindex="-1"
    href="{{ documentation_url }}"
    title="{{ documentation_text }}"
    target="_blank"
  >
  {% if documentation_icon %}
    <img
      width="100%"
      src="{{ documentation_icon }}"
      alt="{{ documentation_text }}"
    />
  {% else %}
    <i class="fa fa-question"></i>&nbsp;
  {% endif %}
  </a>
</li>
{% endif %}

{% if bug_report_url %}		{# BUG报告判断块 #}
<li>
  <a
    tabindex="-1"
    href="{{ bug_report_url }}"
    target="_blank"
    title="Report a bug"
  >
    <i class="fa fa-bug"></i>&nbsp;
  </a>
</li>
{% endif %}

{% if languages.keys()|length > 1 %}	{# 多语种支持判断块 #}
<li class="dropdown">
    <a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">
       <div class="f16"><i class="flag {{languages[locale].get('flag')}}"></i>&nbsp;<b class="caret"></b>
       </div>
    </a>
    <ul class="dropdown-menu" id="language-picker">
      <li class="dropdown">
        {% for lang in languages %}
            {% if lang != locale %}
                <a tabindex="-1" href="{{appbuilder.get_url_for_locale(lang)}}">
                  <div class="f16">
                    <i class="flag {{languages[lang].get('flag')}}"></i> - {{languages[lang].get('name')}}
                  </div>
                </a>
            {% endif %}
        {% endfor %}
      </li>
    </ul>
</li>
{% endif %}

{% if not current_user.is_anonymous %}  
    <li class="dropdown">	{# 登陆用户显示块 #}
      <a
        class="dropdown-toggle"
        data-toggle="dropdown"
        title="{{g.user.get_full_name()}}"
        href="javascript:void(0)"
      >
        <i class="fa fa-user"></i>&nbsp;<b class="caret"></b>
      </a>
        <ul class="dropdown-menu">
            <li><a href="/superset/profile/{{g.user.username}}"><span class="fa fa-fw fa-user"></span>{{_("Profile")}}</a></li>
            <li><a href="{{appbuilder.get_url_for_userinfo}}"><span class="fa fa-fw fa-user"></span>{{_("Info")}}</a></li>
            <li><a href="{{appbuilder.get_url_for_logout}}"><span class="fa fa-fw fa-sign-out"></span>{{_("Logout")}}</a></li>
            {% if version_string or version_sha %}
              <li class="fineprint">
                {% if version_string %}
                  <div>Version: {{version_string}}</div>
                {% endif %}
                {% if version_sha %}
                  <div>SHA: {{version_sha}}</div>
                {% endif %}
              </li>
            {% endif %}
        </ul>
    </li>
{% else %}	{# 未登陆用户显示登陆链接 #}
    <li><a href="{{appbuilder.get_url_for_login}}">
    <i class="fa fa-fw fa-sign-in"></i>{{_("Login")}}</a></li>
{% endif %}
```



/superset-frontend/src/components/menu/Menu.tsx  

定义２个导出函数／组件：Menu 和MenuWrapper。div id值为main-menu。

```tsx
import React, { useState } from 'react';
import { t, styled } from '@superset-ui/core';
import { Nav, Navbar, NavItem } from 'react-bootstrap';
import NavDropdown from 'src/components/NavDropdown';
import { Menu as DropdownMenu } from 'src/common/components';
import MenuObject, {
  MenuObjectProps,
  MenuObjectChildProps,
} from './MenuObject';
import LanguagePicker, { Languages } from './LanguagePicker';
import NewMenu from './NewMenu';

interface BrandProps {
  path: string;
  icon: string;
  alt: string;
  width: string | number;
}

interface NavBarProps { }
export interface MenuProps {
  data: {
    menu: MenuObjectProps[];
    brand: BrandProps;
    navbar_right: NavBarProps;
    settings: MenuObjectProps[];
  };
}

// header css定义
const StyledHeader = styled.header`	 
...  
`;

export function Menu({
  data: { menu, brand, navbar_right: navbarRight, settings },
}: MenuProps) {
  const [dropdownOpen, setDropdownOpen] = useState(false);

  return (
    <StyledHeader className="top" id="main-menu">
      <Navbar inverse fluid staticTop role="navigation">
        <Navbar.Header>
          <Navbar.Brand>
            <a className="navbar-brand" href={brand.path}>
              <img width={brand.width} src={brand.icon} alt={brand.alt} />
            </a>
          </Navbar.Brand>
          <Navbar.Toggle />
        </Navbar.Header>
        <Nav data-test="navbar-top">
          {menu.map((item, index) => (
            <MenuObject {...item} key={item.label} index={index + 1} />
          ))}
        </Nav>
        <Nav className="navbar-right">
        </Nav>    
        ...
          
      </Navbar>
    </StyledHeader>
  );
}       

// 菜单数据转换：data -> newMenuData
export default function MenuWrapper({ data }: MenuProps) {
  const newMenuData = {
    ...data,
  };
  // ...
    
  return <Menu data={newMenuData} />;
}    
```



/superset-frontend/src/views/App.tsx

这里有调用组件Menu 和从后端传来的数据menu。

```tsx
import Menu from 'src/components/Menu/Menu';
...

const container = document.getElementById('app');
const bootstrap = JSON.parse(container?.getAttribute('data-bootstrap') ?? '{}');
const menu = { ...bootstrap.common.menu_data };

const App = () => (
  <ReduxProvider store={store}>
    <ThemeProvider theme={supersetTheme}>
      <FlashProvider common={common}>
        <Router>
          <DynamicPluginProvider>
            <QueryParamProvider
              ReactRouterRoute={Route}
              stringifyOptions={{ encode: false }}
            >
              <Menu data={menu} />   //组件Menu和从后端传来的数据menu
              ...

          </DynamicPluginProvider>
        </Router>
      </FlashProvider>
    </ThemeProvider>
  </ReduxProvider>
);                
```



#### 导航菜单更改

菜单更改 要涉及到 Jinja2模板的更改，appbuilder菜单权限的管控等。

* (略) /superset/templates/appbuilder/navbar.html  导航栏整体布局，可以不改动
* /superset/app.py  添加菜单链接或视图，调用flask_appbuilder.add_link 或者 add_view
* /superset/views/core.py  添加菜单视图函数
* /superset-frontend/webpack.config.js   前端构建脚本添加入口文件
* /superset-frontend/src/xxx/index.tsx    前端某菜单脚本实现逻辑



添加一个菜单要做的改动，如添加菜单 NEWMENU 

1. 后端在app.py 里 add_view/add_link 新菜单项
2. 后端添加菜单视图函数 一般在/superset/views/core.py
3. 前端webpack.config.js增加入口entry对应的newmenu
4. 前端/src/newmenu/目录下增加index.tsx, App.jsx
5. 前端/src/views/App.jsx 增加NEWMENU 路由指向组件



以菜单Data的下拉项 Databases、Datasets为例

/superset/app.py  `SupersetAppInitializer.init_views()`

```python
class SupersetAppInitializer
	def init_views():
        ...
        
        # add_link/add_view 类似效果，给category指向菜单添加菜单下拉项
        # Databases、Datasets这二个菜单项的父级菜单是 Data 菜单
        appbuilder.add_view(
            DatabaseView,
            "Databases",
            label=__("Databases"),
            icon="fa-database",
            category="Data",
            category_label=__("Data"),
            category_icon="fa-database",
        )
        appbuilder.add_link(
            "Datasets",
            label=__("Datasets"),
            href="/tablemodelview/list/?_flt_1_is_sqllab_view=y",  #add_link有href，可提取视图tablemodelview 
            icon="fa-table",
            category="Data",
            category_label=__("Data"),
            category_icon="fa-table",
        )
        appbuilder.add_separator("Data")  # 可选，Data菜单结束分隔符
```



/superset/views/database/views.py  某个视图类实现路由

```python
class DatabaseView(
    DatabaseMixin, SupersetModelView, DeleteMixin, YamlExportMixin
):  # pylint: disable=too-many-ancestors
    datamodel = SQLAInterface(models.Database)

    class_permission_name = "Database"
    method_permission_name = MODEL_VIEW_RW_METHOD_PERMISSION_MAP

    include_route_methods = RouteMethod.CRUD_SET

    add_template = "superset/models/database/add.html"
    edit_template = "superset/models/database/edit.html"
    validators_columns = {
        "sqlalchemy_uri": [sqlalchemy_uri_form_validator],
        "server_cert": [certificate_form_validator],
    }
    
    @expose("/list/")
    @has_access
    def list(self) -> FlaskResponse:
        if not is_feature_enabled("ENABLE_REACT_CRUD_VIEWS"):
            return super().list()

        return super().render_app_template()    
```



/superset/views/core.py  Superset类添加路由函数

```python
class Superset(BaseSupersetView):
    """The base views for Superset!"""

    logger = logging.getLogger(__name__)
    
    @has_access_api
    @event_logger.log_this
    @expose("/datasources/")  # 实际指向 /superset/datasources/
    def datasources(self) -> FlaskResponse:
        return self.json_response(
            sorted(
                [
                    datasource.short_data
                    for datasource in ConnectorRegistry.get_all_datasources(db.session)
                    if datasource.short_data.get("name")
                ],
                key=lambda datasource: datasource["name"],
            )
        ) 
```



/superset-frontend/webpack.config.js  添加入口文件

 ```js
const config = {
  node: {
    fs: 'empty',
  },
  // entry, 指定src目录下各目录的打包入口, { name : 脚本路径 }
  entry: {
    theme: path.join(APP_DIR, '/src/theme.ts'),
    preamble: PREAMBLE,
    addSlice: addPreamble('/src/addSlice/index.tsx'),
    explore: addPreamble('/src/explore/index.jsx'),
    dashboard: addPreamble('/src/dashboard/index.jsx'),
    sqllab: addPreamble('/src/SqlLab/index.tsx'),
    crudViews: addPreamble('/src/views/index.tsx'),
    menu: addPreamble('src/views/menu.tsx'),
    profile: addPreamble('/src/profile/index.tsx'),
    showSavedQuery: [path.join(APP_DIR, '/src/showSavedQuery/index.jsx')],
  },
}    
 ```



/superset-frontend/src/views/index.js  

```js
import React from "react";
import ReactDOM from "react-dom";
import App from "./App";

ReactDOM.render(<App />, document.getElementById("app"));
```

说明：上面是在DOM文档里寻找id为app的元素，然后填充 App。



### 图表列表页

列表页主要有4种，分别是database, dataset, chart 和dashboard。

下面以图表列表页作为示例。

#### 列表页服务端API

详见 3.2章节 中列出的API。

* 图表列表页  /chart/list/   SliceModelView调用父类ModelView.list() ，最终实现在BaseView._list()
  * SliceModelView.list()   /superset/views/chart/views.py
  * ModelView.list()   /flask_appbuilder/views.py 实际调用BaseView._list() 实现list方法
* 图表ChartRestApi  /superset/charts/api.py ChartRestApi(BaseSupersetModelRestApi)  13个API
  * /  图表列表 方法有GET
  * /<pk>/   单个图表   方法有GET/PUT/DELETE， POST-新建图表
  * import  export   导入导出 
  * data favorite_status
* 图表父类BaseSupersetModelRestApi方法：  /superset/views/base_api.py  BaseSupersetModelRestApi
  * expose("/related/<column_name>")  获取相关字段的值，比如owners, created_by
  * expose("/distinct/<column_name>")   获取字段唯一值



/chart/list -->  /chart/list/?pageIndex=0&sortColumn=changed_on_delta_humanized&sortOrder=desc&viewMode=table

下面这些参数是前端发送请求时默认填充的   /superset-frontend/src/views/CRUD/chartlist/ChartList.tsx

* pageIndex	页码，缺省从0开始
* sortColumn 排序字段，缺省Changed_on
* sortOrder   排序方向，缺省desc降序
* viewMode   前端默认填充缺省值table



#### 列表页布局

服务端渲染：/chart/list/  返回HTML。调用 SupersetModelView.render_app_template()，同首页布局模板 superset/crud_views.html

客户端渲染：路由/chart/list/  ->  组件ChartList (/superset-end/src/views/chart/ChartList.tsx)



#### 列表页交互

* 排序Order、过滤Filter、分页Pagination：GET方法时用到
* 搜索：GET方法的filter参数的opr指向的过滤类



## 3 后端 /superset/

### 命令行处理 cli.py

启动命令： `falsk run xxx`  或者  `superset run xxx`

```shell
# superset/releasing/from_tarball_entrypoint.sh
FLASK_ENV=development FLASK_APP="superset.app:create_app()" \
flask run -p 8088 --with-threads --reload --debugger --host=0.0.0.0
```

说明： flask, superset这二个脚本都要在$PATH路径下。

导出 SUPERSET_CONFIG_PATH时，

* flask 若未指定FLASK_APP，将会启用自动搜索识别APP路径（先当前目录，其次SUPSET_CONFIG_PATH所在目录，再site-packages。）。建议使用flask命令前先要 `export FLASK_APP=superset`

* superset run 只能识别 site-packages下的superset目录。



flask 或者 superset 脚本

```python
# -*- coding: utf-8 -*-
import re
import sys

# flask脚本  
from flask.cli import main  # flask脚本入口
if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw|\.exe)?$', '', sys.argv[0])
    sys.exit(main())
    
# 或者 superset脚本    
from superset.cli import superset  # superset脚本入口
if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw|\.exe)?$', '', sys.argv[0])
    sys.exit(superset())
```



superset命令将会触发 app.py::create_app()

superset/cli.py

```python
from flask.cli import FlaskGroup, with_appcontext

# 此处superset函数用了二个装饰器，
# click.groupu装饰器会生成脚本组，触发函数create_app, 并且将方法名作归一化处理normalize_token
# with_appcontextu装饰器会使用应用上下文
@click.group(
    cls=FlaskGroup,
    create_app=create_app,
    context_settings={"token_normalize_func": normalize_token}, #此处将方法名里的_替换成-
)
@with_appcontext
def superset() -> None:
    """This is a management script for the Superset application."""

    @app.shell_context_processor
    def make_shell_context() -> Dict[str, Any]:  # pylint: disable=unused-variable
        return dict(app=app, db=db)    
```



superset支持命令

```shell
$ superset --help
logging was configured successfully
INFO:superset.utils.logging_configurator:logging was configured successfully
Usage: superset [OPTIONS] COMMAND [ARGS]...

  This is a management script for the Superset application.

Options:
  --version  Show the flask version
  --help     Show this message and exit.

Commands:
  alert                     Run the alert scheduler loop
  compute-thumbnails        Compute thumbnails
  db                        Perform database migrations.
  export-dashboards         Export dashboards to JSON
  export-datasource-schema  Export datasource YAML schema to stdout
  export-datasources        Export datasources to YAML
  fab                       FAB flask group commands
  flower                    Runs a Celery Flower web server Celery Flower is...

  import-dashboards         Import dashboards from ZIP file
  import-datasources        Import datasources from YAML
  init                      Inits the Superset application
  load-examples             Loads a set of Slices and Dashboards and a...
  load-test-users           Loads admin, alpha, and gamma user for testing...
  refresh-druid             Refresh druid datasources
  routes                    Show the routes for the app.
  run                       Run a development server.
  set-database-uri          Updates a database connection URI
  shell                     Run a shell in the app context.
  sync-tags                 Rebuilds special tags (owner, type, favorited...
  update-api-docs           Regenerate the openapi.json file in docs
  update-datasources-cache  Refresh sqllab datasources cache
  version                   Prints the current version number
  worker                    Starts a Superset worker for async SQL query...
```

说明：1. 上面命令属于flask模块命令组的有run/shell/routes/version，属于flask_appbuild模块命令组有fab，属于flask_migrate模块命令组有db，其它命令属于superset本身命令组。

2. 命令方法名里的_会替换成-，如load_examples替换成load-examples



#### superset load-examples命令

load_examples 加载测试数据，需要从网络上下载数据。

* /superset/cli.py  命令定义
* /superset/examples/helpers.py  实际的样例加载方法

**下载网络失败的解决办法** （官方例子网站不稳定，经常挂）

- 在github上下载官方例子文件 网址：https://github.com/apache-superset/examples-data

- npm安装http-server： `npm install http-server`

- 在examples-data所在的文件下下开启服务，即：http-server

- 修改superset/examples/helpers.py文件，修改 BASE_URL

  ```python
  #根据实际情况填写ip:port
  BASE_URL = "http://ip:8080/examples-data-master/"
  ```

- 最后执行命令： `superset load-examples`

```python
# /superset/cli.py

# superset.command()装饰说明是superset这个命令组的次级命令
@with_appcontext
@superset.command()
@click.option("--load-test-data", "-t", is_flag=True, help="Load additional test data")
@click.option(
    "--only-metadata", "-m", is_flag=True, help="Only load metadata, skip actual data"
)
@click.option(
    "--force", "-f", is_flag=True, help="Force load data even if table already exists"
)
def load_examples(
    load_test_data: bool, only_metadata: bool = False, force: bool = False
) -> None:
    """Loads a set of Slices and Dashboards and a supporting dataset """
    load_examples_run(load_test_data, only_metadata, force)
    
    
def load_examples_run(
    load_test_data: bool, only_metadata: bool = False, force: bool = False
) -> None:
    """ 实际执行的加载样例方法 """
    if only_metadata:
        print("Loading examples metadata")
    else:
        examples_db = utils.get_example_database()  #创建或加载数据库examples 
        print(f"Loading examples metadata and related data into {examples_db}")

    from superset import examples  #导入examples样例

    examples.load_css_templates()   #从表css_templates加载数据
    
    print("Loading energy related dataset")
	#从表energy_usage获取数据，如果没有，则从网络上下载数据    
    examples.load_energy(only_metadata, force)  
    ...
```



`/superset/examples/__init__.py`    导入了所有的样例数据加载方法 

```python
from .bart_lines import load_bart_lines
from .birth_names import load_birth_names
from .country_map import load_country_map_data
from .css_templates import load_css_templates
from .deck import load_deck_dash
from .energy import load_energy
from .flights import load_flights
from .long_lat import load_long_lat_data
from .misc_dashboard import load_misc_dashboard
from .multi_line import load_multi_line
from .multiformat_time_series import load_multiformat_time_series
from .paris import load_paris_iris_geojson
from .random_time_series import load_random_time_series_data
from .sf_population_polygons import load_sf_population_polygons
from .tabbed_dashboard import load_tabbed_dashboard
from .utils import load_from_configs
from .world_bank import load_world_bank_health_n_pop
```



/superset/examples/helpers.py

```python
from superset import app, db
from superset.connectors.connector_registry import ConnectorRegistry
from superset.models import core as models
from superset.models.slice import Slice

BASE_URL = "https://github.com/apache-superset/examples-data/blob/master/"


# 示例：加载能源数据集，表名energy_usage，数据集energy.json.gz
def load_energy(
    only_metadata: bool = False, force: bool = False, sample: bool = False
) -> None:
    """Loads an energy related dataset to use with sankey and graphs"""
    tbl_name = "energy_usage"
    database = utils.get_example_database()
    table_exists = database.has_table_by_name(tbl_name)

    if not only_metadata and (not table_exists or force):
        data = get_example_data("energy.json.gz")
        pdf = pd.read_json(data)
        pdf = pdf.head(100) if sample else pdf
        pdf.to_sql(
            tbl_name,
            database.get_sqla_engine(),
            if_exists="replace",
            chunksize=500,
            dtype={"source": String(255), "target": String(255), "value": Float()},
            index=False,
            method="multi",
        )
     ...
 

""" 从 BASE_URL下载样例数据 """    
def get_example_data(    
    filepath: str, is_gzip: bool = True, make_bytes: bool = False
) -> BytesIO:
    content = request.urlopen(f"{BASE_URL}{filepath}?raw=true").read()
    if is_gzip:
        content = zlib.decompress(content, zlib.MAX_WBITS | 16)
    if make_bytes:
        content = BytesIO(content)
    return content  
```



### 全局实例或变量

/superset/`__init__.py`

```python
from flask import current_app, Flask
from werkzeug.local import LocalProxy

from superset.app import create_app
from superset.connectors.connector_registry import ConnectorRegistry
from superset.extensions import (
    appbuilder,
    cache_manager,
    db,
    event_logger,
    feature_flag_manager,
    manifest_processor,
    results_backend_manager,
    security_manager,
    talisman,
)
from superset.security import SupersetSecurityManager

#  All of the fields located here should be considered legacy(遗留的，传统的).  
#  The correct way to declare "global" dependencies is to define it in extensions.py,
#  then initialize it in app.create_app(). These fields will be removed
#  in subsequent PRs as things are migrated towards the factory pattern
app: Flask = current_app
cache = cache_manager.cache

# LocalProxy本地代理数据：conf results_backend data_cache数据缓存、缩略图缓存
conf = LocalProxy(lambda: current_app.config)
get_feature_flags = feature_flag_manager.get_feature_flags
get_manifest_files = manifest_processor.get_manifest_files  #实际未使用？
is_feature_enabled = feature_flag_manager.is_feature_enabled
results_backend = LocalProxy(lambda: results_backend_manager.results_backend)
results_backend_use_msgpack = LocalProxy(
    lambda: results_backend_manager.should_use_msgpack
)
data_cache = LocalProxy(lambda: cache_manager.data_cache)
thumbnail_cache = LocalProxy(lambda: cache_manager.thumbnail_cache)
```



#### 配置文件

**配置文件的优先级**:  superset_config.py >  config.py  

1. superset_config.py 用环境变量SUPERSET_CONFIG_PATH定义，在config.py文件尾会重载这个文件。

需要定义了环境变量才会启用。

**推荐所有需要个性化定制的变量都放到 superset_config.py进行修改，统一管理。**

```python
# superset/config.py
if CONFIG_PATH_ENV_VAR in os.environ:
    # Explicitly import config module that is not necessarily in pythonpath; useful
    # for case where app is being executed via pex.
    try:
        cfg_path = os.environ[CONFIG_PATH_ENV_VAR]
        module = sys.modules[__name__]
        override_conf = imp.load_source("superset_config", cfg_path)
        for key in dir(override_conf):
            if key.isupper():
                setattr(module, key, getattr(override_conf, key))

        print(f"Loaded your LOCAL configuration at [{cfg_path}]")
    except Exception:
        logger.exception(
            "Failed to import config for %s=%s", CONFIG_PATH_ENV_VAR, cfg_path
        )
```

2. superset.config:  superset.app:create_app方法内加载。一般很少用到。使用环境变量SUPERSET_CONFIG或者缺省文件 superset.config (即superset/config.py)

```python
# superset/app.py
def create_app() -> Flask:
    app = Flask(__name__)

    try:
        # Allow user to override our config completely 
        config_module = os.environ.get("SUPERSET_CONFIG", "superset.config")
        # Config.from_object可以加载一个字符串或者一个对象（py文件也是一个对象）
        app.config.from_object(config_module)  
```



#### WEB实例 app.py

/superset/app.py

```python
# 加载配置文件，初始化app(调用init_app)
def create_app() -> Flask:
    app = Flask(__name__)

    try:
        # Allow user to override our config completely 允许用户重载自己的配置文件
        config_module = os.environ.get("SUPERSET_CONFIG", "superset.config")
        app.config.from_object(config_module)

        # app初始化类，调用init_app	
        app_initializer = app.config.get("APP_INITIALIZER", SupersetAppInitializer)(app)
        app_initializer.init_app()

        return app
    # Make sure that bootstrap errors ALWAYS get logged
    except Exception as ex:
        logger.exception("Failed to create app")
        raise ex    

        
class SupersetIndexView(IndexView):
    """ 首页视图 / --> /superset/welcome """
    @expose("/")
    def index(self) -> FlaskResponse:
        return redirect("/superset/welcome")
  

class SupersetAppInitializer:
    """ APP初始化类 """
    init_flag = False

    def __init__(self, app: Flask) -> None:
        super().__init__()

        self.flask_app = app
        self.config = app.config
        self.manifest: Dict[Any, Any] = {}     
            
    def init_app(self) -> None:
        """
        Main entry point which will delegate to other methods in
        order to fully init the app
        """
        self.pre_init()		#初始化前，创建DATA_DIR
        self.setup_db()		# APP和数据库绑定
        self.configure_celery()
        self.setup_event_logger()
        self.setup_bundle_manifest()
        self.register_blueprints()
        self.configure_wtf()
        self.configure_logging()
        self.configure_middlewares()
        self.configure_cache()
        
        with self.flask_app.app_context():  # type: ignore
            self.init_app_in_ctx()  #更新APP上下文，包括更新视图init_views()

        self.post_init()        
              
    def init_views(self) -> None:
        """ 初始化视图
        添加无菜单API和菜单API视图，
        调用 flask_appbuilder.add_api, add_link, add_view
        """
        # 给无菜单API添加视图 add_api,实质调用 add_view_no_menu 
        appbuilder.add_api(AnnotationRestApi)
        appbuilder.add_api(AnnotationLayerRestApi)    
        ...
        
        # 给菜单添加视图 add_link,add_view
        if appbuilder.app.config["LOGO_TARGET_PATH"]:
            appbuilder.add_link(
                "Home", label=__("Home"), href="/superset/welcome",
            )
        appbuilder.add_view(
            AnnotationLayerModelView,
            "Annotation Layers",
            label=__("Annotation Layers"),
            icon="fa-comment",
            category="Manage",  # Manager菜单
            category_label=__("Manage"),
            category_icon="",
        )
        ...
        # 添加无菜单API视图 add_view_no_menu
        appbuilder.add_view_no_menu(Api)
        appbuilder.add_view_no_menu(CssTemplateAsyncModelView)
        ...
```



#### 抽象类ABC

* /superset/commands/base.py  ORM CRUD命令抽象类，抽象方法有run, validate
* /superset/utils/log.py   日志抽象类，抽象方法有log
* /superset/utils/log_configurator.py 日志配置抽象类， 抽象方法有configure_logging

```python
# /superset/commands/base.py
from abc import ABC, abstractmethod
from typing import Any

class BaseCommand(ABC):
    @abstractmethod
    def run(self) -> Any:
        """
        Run executes the command. Can raise command exceptions
        :raises: CommandException
        """

    @abstractmethod
    def validate(self) -> None:
        """
        Validate is normally called by run to validate data.
        Will raise exception if validation fails
        :raises: CommandException
        """    
        

# /superset/utils/log.py        
class AbstractEventLogger(ABC): 
    @abstractmethod 
    def log( self, user_id: Optional[int], action: str, dashboard_id: Optional[int], duration_ms: Optional[int], slice_id: Optional[int], referrer: Optional[str], *args: Any, **kwargs: Any, ) -> None: pass  
    
class DBEventLogger(AbstractEventLogger):
    def log(,,,,)      
    
# /superset/utils/log_configurator.py
class LoggingConfigurator(abc.ABC):
    @abc.abstractmethod
    def configure_logging(
        self, app_config: flask.config.Config, debug_mode: bool
    ) -> None:
        pass
```



### 视图逻辑 /views/

Views可分为二大类

* CBV，类实现视图，通常与数据库CRUD密切相关的 ModelView.  
* FBV，函数实现视图，通常不涉及到数据库操作。

superset视图可以分为3类，菜单视图，普通视图(不生成菜单的视图，只添加链接)，资源视图（主要数据库，数据表相关）。

前2类视图是flaskappbuilder控制生成的，后一种视图是sqlalchemy控制生成的。

* base.py  2个视图基类
* core.py  普通视图
* /xx/view.py  资源视图
* base_api.py API基类



#### 视图基类  base.py

/superset/views/base.py

定义了superset视图基类 SupersetModelView和BaseSupersetView，

* 2视图的模板指向 superset/crud_views.html, 入口名为crudViews。
* 2视图的路由前缀不一样：SupersetModelView派生类通常定义了自己的route_base；BaseSupersetView派生类路由前缀一般是/superset。
* 2视图的派生类实现文件不一样：SupersetModelView派生类集中在/superset/xx/views.py；BaseSupersetView派生类集中在/superset/views/core.py。

```python
from flask_appbuilder import BaseView, Model, ModelView


def common_bootstrap_payload() -> Dict[str, Any]:
    """Common data always sent to the client 返回给客户端的数据 """
    messages = get_flashed_messages(with_categories=True)
    locale = str(get_locale())

    return {
        "flash_messages": messages,
        "conf": {k: conf.get(k) for k in FRONTEND_CONF_KEYS},
        "locale": locale,
        "language_pack": get_language_pack(locale),
        "feature_flags": get_feature_flags(),
        "extra_sequential_color_schemes": conf["EXTRA_SEQUENTIAL_COLOR_SCHEMES"],
        "extra_categorical_color_schemes": conf["EXTRA_CATEGORICAL_COLOR_SCHEMES"],
        "menu_data": menu_data(),   # 菜单数据，菜单内容来自于flask_appbuild的Menu类
    }


class SupersetModelView(ModelView):
    # 数据库CRUD相关
    page_size = 100
    list_widget = SupersetListWidget

    def render_app_template(self) -> FlaskResponse:
        payload = { # 要返回给前端的数据
            "user": bootstrap_user_data(g.user), 
            "common": common_bootstrap_payload(),
        }
        return self.render_template(
            "superset/crud_views.html",
            entry="crudViews",
            bootstrap_data=json.dumps(
                payload, default=utils.pessimistic_json_iso_dttm_ser
            ),
        )
    
def common_bootstrap_payload() -> Dict[str, Any]:
    """Common data always sent to the client"""
    messages = get_flashed_messages(with_categories=True)
    locale = str(get_locale())

    return {
        "flash_messages": messages,
        "conf": {k: conf.get(k) for k in FRONTEND_CONF_KEYS},
        "locale": locale,
        "language_pack": get_language_pack(locale),
        "feature_flags": get_feature_flags(),
        "extra_sequential_color_schemes": conf["EXTRA_SEQUENTIAL_COLOR_SCHEMES"],
        "extra_categorical_color_schemes": conf["EXTRA_CATEGORICAL_COLOR_SCHEMES"],
        "menu_data": menu_data(),
    }    
    
class BaseSupersetView(BaseView):
    """ 二种返回格式：JSON或HTML """
    @staticmethod
    def json_response(
        obj: Any, status: int = 200
    ) -> FlaskResponse:  # pylint: disable=no-self-use
        return Response(
            json.dumps(obj, default=utils.json_int_dttm_ser, ignore_nan=True),
            status=status,
            mimetype="application/json",
        )

    def render_app_template(self) -> FlaskResponse:
        payload = {
            "user": bootstrap_user_data(g.user),
            "common": common_bootstrap_payload(),
        }
        return self.render_template(
            "superset/crud_views.html",
            entry="crudViews",
            bootstrap_data=json.dumps(
                payload, default=utils.pessimistic_json_iso_dttm_ser
            ),
        )    
```



#### API基类 base_api.py

见下文  RestAPI逻辑 

/superset/views/base_api.py

```python
from flask_appbuilder import AppBuilder, Model, ModelRestApi

class BaseSupersetModelRestApi(ModelRestApi):
    
    def __init__(self) -> None:
        # Setup statsd
        self.stats_logger = BaseStatsLogger()
        # Add base API spec base query parameter schemas
        if self.apispec_parameter_schemas is None:  # type: ignore
            self.apispec_parameter_schemas = {}
        self.apispec_parameter_schemas["get_related_schema"] = get_related_schema
        if self.openapi_spec_component_schemas is None:
            self.openapi_spec_component_schemas = ()
        self.openapi_spec_component_schemas = self.openapi_spec_component_schemas + (
            RelatedResponseSchema,
            DistincResponseSchema,
        )
        super().__init__()
        
    def create_blueprint(
        self, appbuilder: AppBuilder, *args: Any, **kwargs: Any
    ) -> Blueprint:  # 创建蓝图
        self.stats_logger = self.appbuilder.get_app.config["STATS_LOGGER"]
        return super().create_blueprint(appbuilder, *args, **kwargs)        
```





#### 普通视图 core.py

此文件的路由都是 /superset/开头，共有63个API。

```python
from flask import abort, flash, g, Markup, redirect, render_template, request, Response
from flask_appbuilder import expose
from flask_appbuilder.models.sqla.interface import SQLAInterface
from flask_appbuilder.security.decorators import (
    has_access,
    has_access_api,
    permission_name,
)
from flask_appbuilder.security.sqla import models as ab_models
from flask_babel import gettext as __, lazy_gettext as _, ngettext
from jinja2.exceptions import TemplateError
from jinja2.meta import find_undeclared_variables


class Superset(BaseSupersetView): 

    logger = logging.getLogger(__name__)

    @has_access_api
    @event_logger.log_this
    @expose("/datasources/")
    def datasources(self) -> FlaskResponse:
```



#### ModelView逻辑 xx/views.py

**ModelView层次体系**：

*flask_appbuilders模块*：BaseView(object)  -> BaseModelView -> BaseCRUDView-> RestCRUDView -> ModelView

*superset模块*：		 			-> SupersetModelView  (/superset/views/base.py)

​														-> DashboardModelView  (/superset/views/dashboard/views.py)

​										    			-> SliceModelView /superset/views/chart/views.py)

​										    			-> DatabaseView/superset/views/database/views.py)

说明：ModelView的路由前缀是 `{route_base}`,  实现API常用方法 list/show/get/post/add/edit/download

主要实现在 /superset/views/chart、datashboard、database三个目录里。



/superset/views/chart/views.py

```python
import json

from flask import g
from flask_appbuilder import expose, has_access
from flask_appbuilder.models.sqla.interface import SQLAInterface
from flask_babel import lazy_gettext as _

from superset import db, is_feature_enabled
from superset.connectors.connector_registry import ConnectorRegistry
from superset.constants import MODEL_VIEW_RW_METHOD_PERMISSION_MAP, RouteMethod
from superset.models.slice import Slice
from superset.typing import FlaskResponse
from superset.utils import core as utils
from superset.views.base import (
    check_ownership,
    common_bootstrap_payload,
    DeleteMixin,
    SupersetModelView,
)
from superset.views.chart.mixin import SliceMixin
from superset.views.utils import bootstrap_user_data


class SliceModelView(
    SliceMixin, SupersetModelView, DeleteMixin
):  # pylint: disable=too-many-ancestors
    """
    SliceMixin:  Slice的数据成员类，不涉及到方法。 导入在同级目录下的 mixin.py
    DeleteMixin： 定义了删除方法。导入在上级目录的../base.py
    SupersetModelView： 此类实现render_app_template方法
    """    
    route_base = "/chart"	# 路由路径前缀
    datamodel = SQLAInterface(Slice)
    include_route_methods = RouteMethod.CRUD_SET | {
        RouteMethod.DOWNLOAD,
        RouteMethod.API_READ,
        RouteMethod.API_DELETE,
    }
    class_permission_name = "Chart"
    method_permission_name = MODEL_VIEW_RW_METHOD_PERMISSION_MAP

    def pre_add(self, item: "SliceModelView") -> None:
        utils.validate_json(item.params)

    def pre_update(self, item: "SliceModelView") -> None:
        utils.validate_json(item.params)
        check_ownership(item)

    def pre_delete(self, item: "SliceModelView") -> None:
        check_ownership(item)

    @expose("/add", methods=["GET", "POST"])
    @has_access
    def add(self) -> FlaskResponse:
        datasources = [
            {"value": str(d.id) + "__" + d.type, "label": repr(d)}
            for d in ConnectorRegistry.get_all_datasources(db.session)
        ]
        payload = {
            "datasources": sorted(datasources, key=lambda d: d["label"]),
            "common": common_bootstrap_payload(),
            "user": bootstrap_user_data(g.user),
        }
        # render_template方法是在此项目根路径下的 templates目录再取相应模块页面, 
        # 实际调用 /suserset/templates/superset/add_slice.html
        return self.render_template(
            "superset/add_slice.html", bootstrap_data=json.dumps(payload)
        )

    @expose("/list/")
    @has_access
    def list(self) -> FlaskResponse:
        """ /charts/list/ 调用 父类的list和render_app_template方法 """
        if not is_feature_enabled("ENABLE_REACT_CRUD_VIEWS"):
            return super().list()

        return super().render_app_template()
```





### 图表逻辑 /charts/

图表charts、看板dashboards、databases和datasets 这4个的代码结构和处理逻辑类似。

* commands/  元数据CRUD操作命令
* api.py RestAPI接口
* dao.py 更复杂的SQL语句实现，如bulk_delete
* filters.py  过滤条件
* schemas.py  定义了元数据对象属性，如表字段。可用来作字段类型和值检验



#### 元数据CRUD命令 /commands/

**示例1：图表创建命令**

/superset/charts/commands/create.py

```python
import logging
from typing import Any, Dict, List, Optional

from flask_appbuilder.models.sqla import Model
from flask_appbuilder.security.sqla.models import User
from marshmallow import ValidationError

from superset.charts.commands.exceptions import (
    ChartCreateFailedError,
    ChartInvalidError,
    DashboardsNotFoundValidationError,
)
from superset.charts.dao import ChartDAO
from superset.commands.base import BaseCommand
from superset.commands.utils import get_datasource_by_id, populate_owners
from superset.dao.exceptions import DAOCreateFailedError
from superset.dashboards.dao import DashboardDAO


class CreateChartCommand(BaseCommand):
    def __init__(self, user: User, data: Dict[str, Any]):
        self._actor = user
        self._properties = data.copy()

    def run(self) -> Model:
        self.validate()
        try:
            chart = ChartDAO.create(self._properties)
        except DAOCreateFailedError as ex:
            logger.exception(ex.exception)
            raise ChartCreateFailedError()
        return chart

    def validate(self) -> None:
```



#### RestApi逻辑 api.py

**RestApi层次体系**：

*flask_appbuilders模块*：BaseApi(object)  -> BaseModelApi -> ModelRestApi 

*superset模块*：		 			-> BaseSupersetModelRestApi (/superset/views/base_api.py)

​														-> ChartRestApi (/superset/charts/api.py)

​										    			-> DashboardRestApi (/superset/dashboards/api.py)

说明：RestApi类有一个关键属性resource_name。本处路由前缀是`{route_base}` or  `/api/{version}/{resource_name}/`

charts API列表

| route                            | method | 实现模块                             | 实现过程                                                     |
| -------------------------------- | ------ | ------------------------------------ | ------------------------------------------------------------ |
| /chart/                          | GET    | flask_appbuilder py:BaseApi:get_list | 查询参数q -> rison转化,  <br>依次处理filter, order, pagination, query, <br>-> response |
|                                  | POST   |                                      |                                                              |
|                                  | DELETE |                                      |                                                              |
| /chart/_info                     | GET    |                                      |                                                              |
| /chart/data                      | POST   |                                      |                                                              |
| /chart/data/{cache_key}          | GET    | flask_appbuilder                     |                                                              |
| /chart/export/                   | GET    |                                      |                                                              |
| /chart/favorite_status/          | GET    |                                      |                                                              |
| /chart/import/                   | POST   |                                      |                                                              |
| /chart/related/{column_name}     | GET    | flask_appbuilder                     |                                                              |
| /chart/{pk}                      | GET    |                                      |                                                              |
|                                  | POST   |                                      |                                                              |
|                                  | DELETE |                                      |                                                              |
| /chart/{pk}/cache_screenshot/    | GET    |                                      |                                                              |
| /chart/{pk}/screenshot/{digest}/ | GET    |                                      |                                                              |
| /chart/{pk}/thumbnail/{digest}/  | GET    |                                      |                                                              |

说明：上面共16个API，其中3个是调用是调用基类方法(`flask_appbuilder/api/__init__.py:BaseApi`，都是GET方法)实现的。

示例：图表列表页搜索

/api/v1/chart/?q=(filters:!((col:slice_name,opr:chart_all_text,value:test)),order_column:changed_on_delta_humanized,order_direction:desc,page:0,page_size:25)

* filters 过滤参数: col过滤字段，opr映射到过滤类，value查询值
* order_column: 排序字段， order_direction：排序方向
* page页号，page_size一页大小

```python
from flask import g, make_response, redirect, request, Response, send_file, url_for
from flask_appbuilder.api import expose, protect, rison, safe
from flask_appbuilder.models.sqla.interface import SQLAInterface


class ChartRestApi(BaseSupersetModelRestApi):
    """ 成员变量详细定义了路由、权限和字段的使用场景
    1.路由
    2.权限：类名、方法名
    3.字段：单面和列表页时的显示、排序、搜索字段名。排序，refer字段的缺省规则。
    """
    datamodel = SQLAInterface(Slice)

    resource_name = "chart"
    allow_browser_login = True
    include_route_methods = RouteMethod.REST_MODEL_VIEW_CRUD_SET | {
        RouteMethod.EXPORT,
        RouteMethod.IMPORT,
        RouteMethod.RELATED,
        "bulk_delete",  # not using RouteMethod since locally defined
        "data",
        "data_from_cache",
        "viz_types",
        "favorite_status",
    }
    class_permission_name = "Chart"	# 类权限名
    method_permission_name = MODEL_API_RW_METHOD_PERMISSION_MAP	#方法权限名，定义在constants.py
    show_columns = [...]	#图表页时的展示字段
    show_select_columns = show_columns + ["table.id"]
    list_columns = [...]   #图表列表页时的展示字段
    list_select_columns = list_columns + ["changed_by_fk", "changed_on"]    
    order_columns = [...]  #排序字段    
    search_columns = [...] #搜索字段
    base_order = ("changed_on", "desc")
    base_filters = [["id", ChartFilter, lambda: []]]
    search_filters = {	# 搜索过滤器，此处注册了才会加载，否则只会跳转到flask_appbuilder的13个过滤器里
        "id": [ChartFavoriteFilter],
        "slice_name": [ChartAllTextFilter],
    }
    edit_columns = ["slice_name"]
    add_columns = edit_columns

    add_model_schema = ChartPostSchema()
    edit_model_schema = ChartPutSchema()

    openapi_spec_tag = "Charts"
    """ Override the name set for this collection of endpoints """
    openapi_spec_component_schemas = CHART_SCHEMAS

    apispec_parameter_schemas = {
        "screenshot_query_schema": screenshot_query_schema,
        "get_delete_ids_schema": get_delete_ids_schema,
        "get_export_ids_schema": get_export_ids_schema,
        "get_fav_star_ids_schema": get_fav_star_ids_schema,
    }
    """ Add extra schemas to the OpenAPI components schema section """
    openapi_spec_methods = openapi_spec_methods_override
    """ Overrides GET methods OpenApi descriptions """

    order_rel_fields = {	# 排序字段的缺省规则 
        "slices": ("slice_name", "asc"),
        "owners": ("first_name", "asc"),
    }

    related_field_filters = {	# 相关项字段的缺省过滤规则 
        "owners": RelatedFieldFilter("first_name", FilterRelatedOwners),
        "created_by": RelatedFieldFilter("first_name", FilterRelatedOwners),
    }

    allowed_rel_fields = {"owners", "created_by"}
    
    def __init__(self) -> None:
        if is_feature_enabled("THUMBNAILS"):
            self.include_route_methods = self.include_route_methods | {
                "thumbnail",
                "screenshot",
                "cache_screenshot",
            }
        super().__init__()    
    
    @expose("/export/", methods=["GET"])
    @protect()
    @safe
    @statsd_metrics
    @rison(get_export_ids_schema)
    @event_logger.log_this_with_context(
        action=lambda self, *args, **kwargs: f"{self.__class__.__name__}.export",
        log_to_statsd=False,
    )
    def export(self, **kwargs: Any) -> Response:
        
```



#### **dao逻辑 dao.py**

dao逻辑实现了 操作数据库的事务方法，如bulk_delete, save, overwrite等等

```python
from superset.charts.filters import ChartFilter
from superset.dao.base import BaseDAO


class ChartDAO(BaseDAO):
    model_cls = Slice
    base_filter = ChartFilter

    @staticmethod
    def bulk_delete(models: Optional[List[Slice]], commit: bool = True) -> None:
```



#### **过滤逻辑 filters.py**

示例：filters:!((col:slice_name,opr:chart_all_text,value:test)

filters 过滤参数:  col过滤字段，opr映射到过滤类(arg_name -> class_name)，value查询值(部分匹配查询2张表的4个字段)

```python
from typing import Any

from flask_babel import lazy_gettext as _
from sqlalchemy import or_
from sqlalchemy.orm.query import Query

from superset import security_manager
from superset.connectors.sqla.models import SqlaTable
from superset.models.slice import Slice
from superset.views.base import BaseFilter
from superset.views.base_api import BaseFavoriteFilter


class ChartAllTextFilter(BaseFilter):  # pylint: disable=too-few-public-methods
    """ 在4个字符串字段里查找 部分匹配内容 """
    name = _("All Text")
    arg_name = "chart_all_text"

    def apply(self, query: Query, value: Any) -> Query:
        if not value:
            return query
        ilike_value = f"%{value}%"
        # 部分匹配：图表名、描述、可视化类型、表名
        return query.filter(
            or_(
                Slice.slice_name.ilike(ilike_value),
                Slice.description.ilike(ilike_value),
                Slice.viz_type.ilike(ilike_value),
                SqlaTable.table_name.ilike(ilike_value),
            )
        )


class ChartFavoriteFilter(BaseFavoriteFilter):  # pylint: disable=too-few-public-methods
    """
    Custom filter for the GET list that filters all charts that a user has favored
    """

    arg_name = "chart_is_favorite"
    class_name = "slice"
    model = Slice


class ChartFilter(BaseFilter):  # pylint: disable=too-few-public-methods
    """ 图表API过滤器，检查有无权限 """
    def apply(self, query: Query, value: Any) -> Query:
        if security_manager.can_access_all_datasources():
            return query
        perms = security_manager.user_view_menu_names("datasource_access")
        schema_perms = security_manager.user_view_menu_names("schema_access")
        return query.filter(  # 检查model或schema有没相应权限
            or_(self.model.perm.in_(perms), self.model.schema_perm.in_(schema_perms))
        )

    
    
# /flask_appbuilder/models/filter.py
from typing import Any, Dict, List, Optional, Tuple, Type

map_args_filter = {}	# 全局数据

class BaseFilter(object):
    """ 所有过滤器的基类 """
    column_name = ""
    datamodel = None
    model = None
    name = ""
    is_related_view = False    
    arg_name = None
    
    def __init__(self, column_name, datamodel, is_related_view=False):
        self.column_name = column_name
        self.datamodel = datamodel
        self.model = datamodel.obj  #模型对象
        self.is_related_view = is_related_view
        if self.arg_name:	# 填充map_args_filter
            map_args_filter[self.arg_name] = self.__class__       
            
    def apply(self, query, value):   
        raise NotImplementedError

    def __repr__(self):
        return self.name        
```

说明： map_args_filter={arg_name: class_name}，在初始化时构建。flask_appbuilder里缺省有13个过滤器会装载到map_args_filter。

superset过滤类需要在api.py里注册 search_filter填入相应过滤器才会注册，示例如下：

```python
# /sueprset/charts/api.py
class ChartRestApi(BaseSupersetModelRestApi):
    base_filters = [["id", ChartFilter, lambda: []]]
    search_filters = {	# 搜索过滤器，此处注册了才会加载，否则只会跳转到flask_appbuilder的13个过滤器里
        "id": [ChartFavoriteFilter],
        "slice_name": [ChartAllTextFilter],
    }
```





### 数据操作

#### 元数据查询 

RestAPI逻辑里涉及到的元数据库操作，主要在 /xxx/dao.py



#### 原始数据查询 

数据的查询和展示是superset的核心功能，前端用D3.js来渲染各种图标，后端用pandas来处理各种数据。

**superset数据查询过程**：

1.将前端的配置信息form_data传给explore_json函数  /superset/views/core.py
2.根据所选的图表类型，找到对应的图表类	/superset/viz.py
3.根据过滤条件生成sql查询语句	/superset/charts/filters.py
4.根据数据库的连接条件找到对应的数据库engine，创建engine	
5.使用pandas的read_sql函数获取查询结果，并生成一个dataframe



/superset/views/core.py

```python
class Superset(BaseSupersetView): 
    
	@api
    @has_access_api
    @handle_api_exception
    @event_logger.log_this
    @expose(
        "/explore_json/<datasource_type>/<int:datasource_id>/",
        methods=EXPLORE_JSON_METHODS,
    )
    @expose("/explore_json/", methods=EXPLORE_JSON_METHODS)
    @etag_cache()
    @check_resource_permissions(check_datasource_perms)
    def explore_json(
        self, datasource_type: Optional[str] = None, datasource_id: Optional[int] = None
    ) -> FlaskResponse:
        response_type = utils.ChartDataResultFormat.JSON.value
        responses: List[
            Union[utils.ChartDataResultFormat, utils.ChartDataResultType]
        ] = list(utils.ChartDataResultFormat)
        responses.extend(list(utils.ChartDataResultType))
        for response_option in responses:
            if request.args.get(response_option) == "true":
                response_type = response_option
                break
		# 获取form数据
        form_data = get_form_data()[0]

        try:
            datasource_id, datasource_type = get_datasource_info(
                datasource_id, datasource_type, form_data
            )

            force = request.args.get("force") == "true"

            # TODO: support CSV, SQL query and other non-JSON types  异步处理支持
            if (
                is_feature_enabled("GLOBAL_ASYNC_QUERIES")
                and response_type == utils.ChartDataResultFormat.JSON
            ):
                try: # 异步查询
                    async_channel_id = async_query_manager.parse_jwt_from_request(
                        request
                    )["channel"]
                    job_metadata = async_query_manager.init_job(async_channel_id)
                    load_explore_json_into_cache.delay(
                        job_metadata, form_data, response_type, force
                    )
                except AsyncQueryTokenException:
                    return json_error_response("Not authorized", 401)

                return json_success(json.dumps(job_metadata), status=202)

            # 获取图表类型
            viz_obj = get_viz(
                datasource_type=cast(str, datasource_type),
                datasource_id=datasource_id,
                form_data=form_data,
                force=force,
            )
			# 返回数据JSON格式
            return self.generate_json(viz_obj, response_type)
        except SupersetException as ex:
            return json_error_response(utils.error_msg_from_exception(ex), 400)   
        
    def generate_json(
        self, viz_obj: BaseViz, response_type: Optional[str] = None
    ) -> FlaskResponse:
        if response_type == utils.ChartDataResultFormat.CSV:
            return CsvResponse(
                viz_obj.get_csv(),
                status=200,
                headers=generate_download_headers("csv"),
                mimetype="application/csv",
            )

        if response_type == utils.ChartDataResultType.QUERY:
            return self.get_query_string_response(viz_obj)

        if response_type == utils.ChartDataResultType.RESULTS:
            return self.get_raw_results(viz_obj)

        # 数据采样返回，调用了 get_df_payload (pandas)
        if response_type == utils.ChartDataResultType.SAMPLES:
            return self.get_samples(viz_obj)

        payload = viz_obj.get_payload()
        return data_payload_response(*viz_obj.payload_json_and_has_error(payload))        
```



#### 可视化图表

* /superset/viz.py 定义了可视化基类BaseViz及各个子类，可视化列表viz_types
* /superset/superset_config.py  此处变量VIZ_TYPE_DENYLIST会被 viz_types用到
* /superset/views/utils.py  get_viz()会根据传参类型返回BaseViz的实际子类。



/superset/viz.py  可视化图表类型的基类和子类

```python
from flask_babel import lazy_gettext as _


class BaseViz:

    """All visualizations derive this base class"""

    viz_type: Optional[str] = None
    verbose_name = "Base Viz"
    credits = ""
    is_timeseries = False
    cache_type = "df"
    enforce_numerical_metrics = True

    def __init__(
        self,
        datasource: "BaseDatasource",
        form_data: Dict[str, Any],
        force: bool = False,
        force_cached: bool = False,
    ) -> None:
        if not datasource:
            raise QueryObjectValidationError(_("Viz is missing a datasource"))

        self.datasource = datasource
        self.request = request
        self.viz_type = form_data.get("viz_type")
        self.form_data = form_data

        self.query = ""
        self.token = utils.get_form_data_token(form_data)

        self.groupby: List[str] = self.form_data.get("groupby") or []
        self.time_shift = timedelta()

        self.status: Optional[str] = None
        self.error_msg = ""
        self.results: Optional[QueryResult] = None
        self.errors: List[Dict[str, Any]] = []
        self.force = force
        self._force_cached = force_cached
        self.from_dttm: Optional[datetime] = None
        self.to_dttm: Optional[datetime] = None
        self._extra_chart_data: List[Tuple[str, pd.DataFrame]] = []

        self.process_metrics()

        self.applied_filters: List[Dict[str, str]] = []
        self.rejected_filters: List[Dict[str, str]] = []

          
class NVD3Viz(BaseViz):

    """Base class for all nvd3 vizs"""

    credits = '<a href="http://nvd3.org/">NVD3.org</a>'
    viz_type: Optional[str] = None
    verbose_name = "Base NVD3 Viz"
    is_timeseries = False
        

class BubbleViz(NVD3Viz):

    """Based on the NVD3 bubble chart"""

    viz_type = "bubble"
    verbose_name = _("Bubble Chart")
    is_timeseries = False

    def query_obj(self) -> QueryObjectDict:
        
        
def get_subclasses(cls: Type[BaseViz]) -> Set[Type[BaseViz]]:
    return set(cls.__subclasses__()).union(
        [sc for c in cls.__subclasses__() for sc in get_subclasses(c)]
    )


viz_types = {
    o.viz_type: o
    for o in get_subclasses(BaseViz)
    if o.viz_type not in config["VIZ_TYPE_DENYLIST"]
}            
```



/supetset/superset_config.py 

```python
设置不处理的图表类型，这里只是后端不处理报错；前端仍然会显示此图表
VIZ_TYPE_DENYLIST = ['pivot_table', 'treemap']
```



/superset/views/utils.py 

get_viz()根据传参viz_type返回相应的图表类。

```python
if is_feature_enabled("SIP_38_VIZ_REARCHITECTURE"):
    from superset import viz_sip38 as viz
else:
    from superset import viz  # type: ignore
    
def get_viz(
    form_data: FormData,
    datasource_type: str,
    datasource_id: int,
    force: bool = False,
    force_cached: bool = False,
) -> BaseViz:
    viz_type = form_data.get("viz_type", "table")
    datasource = ConnectorRegistry.get_datasource(
        datasource_type, datasource_id, db.session
    )
    viz_obj = viz.viz_types[viz_type](  # 如果viz_types不存在或配置文件里的限制类型，将返回KeyError
        datasource, form_data=form_data, force=force, force_cached=force_cached
    )
    return viz_obj
```



#### 异步查询 

celery使用



#### 缓存

强制刷新字段 force=true|false

缓存：flask_caching





### 安全权限管理

安全权限大致可分为四类：

* 基本权限：依赖于flask_appbuilder的权限管理
  * /flask_appbuilder/security/   fab的权限管理实现
  * /superset/security/   superset的权限管理
* 菜单权限：依赖于flask_appbuilder的菜单管理
  * /flask_appbuilder/menu.py  fab的菜单对象
  *  /superset/app.py    superset添加菜单视图add_view 和菜单链接add_link
* 资源权限：单个数据库管理， /superset/migrations/  
* API访问权限：superset某个API访问实现  /superset/xxx/api.py   



#### **基本权限**

/superset/security/manager.py

每个页面对应一个视图View。

```python
from flask import current_app, g
from flask_appbuilder import Model
from flask_appbuilder.security.sqla.manager import SecurityManager
from flask_appbuilder.security.sqla.models import (
    assoc_permissionview_role,
    assoc_user_role,
    PermissionView,
    User,
)
from flask_appbuilder.security.views import (
    PermissionModelView,
    PermissionViewModelView,
    RoleModelView,
    UserModelView,
    ViewMenuModelView,
)


class SupersetSecurityManager(SecurityManager):
    userstatschartview = None
    READ_ONLY_MODEL_VIEWS = {"Database", "DruidClusterModelView", "DynamicPlugin"}

    USER_MODEL_VIEWS = {
        "UserDBModelView",
        "UserLDAPModelView",
        "UserOAuthModelView",
        "UserOIDModelView",
        "UserRemoteUserModelView",
    }
    ...
```



#### **菜单视图权限**

使用flask_appbuilder模块的AppBuilder 来处理菜单权限。



#### 资源权限

/superset/migrations/

数据库/表权限字段 perm 组成：

* 数据库：`[{database_name}].(id:{database_id}))`
* 数据表：`[{database_name}].[{table_name}] (id:{table_id})')`

权限方法：get_perm,  set_perm



#### **API访问权限**

API示例 /superset/charts/api.py

```python
from flask_appbuilder.api import expose, protect, rison, safe  # 都是在API实现中直接使用的装饰器

from superset.views.base_api import (
    BaseSupersetModelRestApi,
    RelatedFieldFilter,
    statsd_metrics,
)


class ChartRestApi(BaseSupersetModelRestApi):
    ...
    
    def __init__(self) -> None:
        if is_feature_enabled("THUMBNAILS"):
            self.include_route_methods = self.include_route_methods | {
                "thumbnail",
                "screenshot",
                "cache_screenshot",
            }
        super().__init__()

    @expose("/", methods=["POST"])
    @protect()
    @safe
    @statsd_metrics
    @event_logger.log_this_with_context(
        action=lambda self, *args, **kwargs: f"{self.__class__.__name__}.post",
        log_to_statsd=False,
    )
    def post(self) -> Response:
        """ 以上装饰器分别是路由、权限检查、异常处理、API统计、日志处理 """
        
```

* expose: API路由
* **protect**:  判断API权限
* rison  捕捉入参的Rison参数
* safe 捕捉异常，返回异常时的JSON
* has_access_api  



#### 示例：新增数据源

新增数据源，需要在元数据表中操作的数据和权限

* dbs: 数据库表，添加1条记录，包括数据源连接参数等信息
* ab_permission_view  权限视图表，添加1+N条（取决于此数据库有多少schema）记录
  * 添加 此数据源的database_access权限 
  * 添加 数据源所有schema的 schema_access权限 

* ab_role_permission_view 正常情况下，数据源创建者所在的角色应该有此数据源的database_access权限（**superset似乎并未默认实现？或者是说有database_access_all权限的用户才能创建数据源？**）

```python
# /superset/databases/commands/create.py
from flask_appbuilder.models.sqla import Model
from flask_appbuilder.security.sqla.models import User
from marshmallow import ValidationError

from superset.commands.base import BaseCommand


class CreateDatabaseCommand(BaseCommand):
    def __init__(self, user: User, data: Dict[str, Any]):
        self._actor = user
        self._properties = data.copy()

    def run(self) -> Model:
        self.validate()
        try:  # 操作 dbs表
            database = DatabaseDAO.create(self._properties, commit=False)
            database.set_sqlalchemy_uri(database.sqlalchemy_uri)

            try:
                TestConnectionDatabaseCommand(self._actor, self._properties).run()
            except Exception:
                db.session.rollback()
                raise DatabaseConnectionFailedError()

            # 操作 ab_permisson_view表， 增加1+N条记录
            # adding a new database we always want to force refresh schema list
            schemas = database.get_all_schema_names(cache=False)
            for schema in schemas:
                security_manager.add_permission_view_menu(
                    "schema_access", security_manager.get_schema_perm(database, schema)
                )
            security_manager.add_permission_view_menu("database_access", database.perm)
            db.session.commit()
        except DAOCreateFailedError as ex:
            logger.exception(ex.exception)
            raise DatabaseCreateFailedError()
        return database
```



#### 加密保存

* 数据源密码和加密字段：AES加密保存，依赖cryptography库  /superset/models/core.py -> sqlalchemy_utils模块
* 用户密码：密码HASH值保存，检验时按照相同规则生成HASH值和数据库中的比对  /flask_appbuilder/security/sqla/manager.py -> werkzeug模块



/superset/models/core.py

EncryptedType用于数据库表字段加密保存，实现依赖cryptography库，缺省AES加密。

```python
from flask_appbuilder import Model
from sqlalchemy_utils import EncryptedType


class Database(Model, AuditMixinNullable, ImportExportMixin):  

    __tablename__ = "dbs"
    type = "table"
    __table_args__ = (UniqueConstraint("database_name"),)

    id = Column(Integer, primary_key=True)
    verbose_name = Column(String(250), unique=True)
    # short unique name, used in permissions
    database_name = Column(String(250), unique=True, nullable=False)
    sqlalchemy_uri = Column(String(1024), nullable=False)
    password = Column(EncryptedType(String(1024), config["SECRET_KEY"]))  #密码加密保存
	...
    encrypted_extra = Column(EncryptedType(Text, config["SECRET_KEY"]), nullable=True)	# 加密保存字段
    impersonate_user = Column(Boolean, default=False)
    server_cert = Column(EncryptedType(Text, config["SECRET_KEY"]), nullable=True)
    export_fields = [
        "database_name",
        "sqlalchemy_uri",
        "cache_timeout",
        "expose_in_sqllab",
        "allow_run_async",
        "allow_ctas",
        "allow_cvas",
        "allow_csv_upload",
        "extra",
    ]
    extra_import_fields = ["password"]
    export_children = ["tables"]
```



/sqlalchemy_utils/type/encrypted/encrypted_type.py  

AES加密保存，依赖模块 cryptography, sqlalchemy_utils模块

```python
import six
from sqlalchemy.types import LargeBinary, String, TypeDecorator

from sqlalchemy_utils.exceptions import ImproperlyConfigured
from sqlalchemy_utils.types.encrypted.padding import PADDING_MECHANISM
from sqlalchemy_utils.types.json import JSONType
from sqlalchemy_utils.types.scalar_coercible import ScalarCoercible

cryptography = None
try:
    import cryptography
    from cryptography.hazmat.backends import default_backend
    from cryptography.hazmat.primitives import hashes
    from cryptography.hazmat.primitives.ciphers import (
        Cipher, algorithms, modes
    )
    from cryptography.fernet import Fernet
    from cryptography.exceptions import InvalidTag
except ImportError:
    pass


class AesEngine(EncryptionDecryptionBaseEngine):
    BLOCK_SIZE = 16
    def _initialize_engine(self, parent_class_key):
        self.secret_key = parent_class_key
        self.iv = self.secret_key[:16]
        self.cipher = Cipher(
            algorithms.AES(self.secret_key),
            modes.CBC(self.iv),
            backend=default_backend()
        )

    def _set_padding_mechanism(self, padding_mechanism=None):
        """Set the padding mechanism. 补位机制 """
        if isinstance(padding_mechanism, six.string_types):
            if padding_mechanism not in PADDING_MECHANISM.keys():
                raise ImproperlyConfigured(
                    "There is not padding mechanism with name {}".format(
                        padding_mechanism
                    )
                )

        if padding_mechanism is None:
            padding_mechanism = 'naive'

        padding_class = PADDING_MECHANISM[padding_mechanism]
        self.padding_engine = padding_class(self.BLOCK_SIZE)
        
   def encrypt(self, value):
    	""" 加密 """
        if not isinstance(value, six.string_types):
            value = repr(value)
        if isinstance(value, six.text_type):
            value = str(value)
        value = value.encode()
        value = self.padding_engine.pad(value)
        encryptor = self.cipher.encryptor()
        encrypted = encryptor.update(value) + encryptor.finalize()
        encrypted = base64.b64encode(encrypted)
        return encrypted.decode('utf-8')

    def decrypt(self, value):
        """ 解密 """
        if isinstance(value, six.text_type):
            value = str(value)
        decryptor = self.cipher.decryptor()
        decrypted = base64.b64decode(value)
        decrypted = decryptor.update(decrypted) + decryptor.finalize()
        decrypted = self.padding_engine.unpad(decrypted)
        if not isinstance(decrypted, six.string_types):
            try:
                decrypted = decrypted.decode('utf-8')
            except UnicodeDecodeError:
                raise ValueError('Invalid decryption key')
        return decrypted
    
    
class StringEncryptedType(TypeDecorator, ScalarCoercible):
    """ EncryptedType needs Cryptography_ library in order to work. 
    _Cryptography: https://cryptography.io/en/latest/
    """
    impl = String	#缺省实现是字符串

    def __init__(self, type_in=None, key=None,
                 engine=None, padding=None, **kwargs):
        """Initialization."""
        if not cryptography:
            raise ImproperlyConfigured(
                "'cryptography' is required to use EncryptedType"
            )
        super(StringEncryptedType, self).__init__(**kwargs)
        # set the underlying type
        if type_in is None:
            type_in = String()
        elif isinstance(type_in, type):
            type_in = type_in()
        self.underlying_type = type_in
        self._key = key
        if not engine:	# 缺省AES引擎
            engine = AesEngine
        self.engine = engine()
        if isinstance(self.engine, AesEngine):
            self.engine._set_padding_mechanism(padding)
            
            
class EncryptedType(StringEncryptedType):
    impl = LargeBinary
    def __init__(self, *args, **kwargs):
        warnings.warn(
            "The 'EncryptedType' class will change implementation from "
            "'LargeBinary' to 'String' in a future version. Use "
            "'StringEncryptedType' to use the 'String' implementation.",
            DeprecationWarning)
        super().__init__(*args, **kwargs)    
```



 /flask_appbuilder/security/sqla/manager.py

用户密码，HASH值保存，依赖模块werkzeug

```python
from werkzeug.security import generate_password_hash

from ..manager import BaseSecurityManager


class SecurityManager(BaseSecurityManager):    
    """ 成员函数：添加用户 """
	def add_user(
        self,
        username,
        first_name,
        last_name,
        email,
        role,
        password="",
        hashed_password="",
    ):
        """
            Generic function to create user
        """
        try:
            user = self.user_model()
            user.first_name = first_name
            user.last_name = last_name
            user.username = username
            user.email = email
            user.active = True
            user.roles = role if isinstance(role, list) else [role]
            if hashed_password:
                user.password = hashed_password
            else:
                user.password = generate_password_hash(password)
            self.get_session.add(user)
            self.get_session.commit()
            log.info(c.LOGMSG_INF_SEC_ADD_USER.format(username))
            return user
        except Exception as e:
            log.error(c.LOGMSG_ERR_SEC_ADD_USER.format(str(e)))
            self.get_session.rollback()
            return False
        
        
# /werkzeug/security.py
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
```



### 模板 /templates/

* 模板渲染 /flask_appbuilder/baseviews.py:render_template
* 组件渲染 render

/superset/templates/superset/basic.html



### 日志

DATA_DIR： 用来存放元数据文件（缺省sqlite是superset.db）、日志文件（superset.log）。依赖环境变量SUPERSET_HOME，缺省~/.superset/

几种logger

* STATS_LOGGER   实时统计的日志，方法有incr, decr, timing计时, gauge。会记录入到元数据log表
* EVENT_LOGGER  操作DB的日志
* QUERY_LOGGER  查询日志

常用logger的定义如下

```python
# /superset/config.py
STATS_LOGGER = DummyStatsLogger()
EVENT_LOGGER = DBEventLogger()
QUERY_LOGGER = None

# /superset/extensions.py 
# 其实不是日志，是一个本地代理
_event_logger: Dict[str, Any] = {}
event_logger = LocalProxy(lambda: _event_logger.get("event_logger"))

# xx.py
logger = logging.getLogger(__name__)

# /superset/utils/log.py
# /superset/stats_logger.py
```



## 4  前端 /superset-frontend/

前端文件格式有：jsx（JS扩展）、ts/tsx（typescript扩展）、js



### 前端打包逻辑 

* `package.json`    npm命令脚本和前端依赖模块及模块版本管理，各种前端框架如vue/react/bootstrap都需要这个json文件。
* `webpack.config.js`  webpack构建配置文件， 可以单页面应用程序SAP也可多页面MAP。主要定义了以下内容，
  * entry入口：指示 webpack 应该使用哪个模块，来作为构建其内部*依赖图*的开始。生成的最终文件js/css路径存放在mainfest.json，被后端渲染模板时识别。
  * output出口：告诉 webpack 在哪里输出它所创建的 *bundles*，以及如何命名这些文件。MAP时输出无需指定filename。
  * loader加载器：让 webpack 能够去处理那些html/js之外的文件格，需要定义解析器才能正确解析。
  * resolve解析器：比如babel_loader
  * optimization优化项、
  * 打包参数：APP_DIR  BUILD_DIR
  * 部署参数：mode  devserverPort 
  * 其它：module模块和plugin插件。
* manifest.json   webpack打包后生成的模块详细信息，可以通过模块标识符找到对应的模块(xx.js/xx.css)。
* src/{xx}/index.tsx  某个目录下的入口文件，可对照webpack.config.js的entry



#### webpack.config.js

**/superset-frontend/webpack.config.js  **

 ```js
const packageConfig = require('./package.json');

// input dir
const APP_DIR = path.resolve(__dirname, './');
// output dir
const BUILD_DIR = path.resolve(__dirname, '../superset/static/assets');

const {
  mode = 'development',
  devserverPort = 9000,
  measure = false,
  analyzeBundle = false,
  analyzerPort = 8888,
  nameChunks = false,
} = parsedArgs;
const isDevMode = mode !== 'production';
const isDevServer = process.argv[1].includes('webpack-dev-server');

const output = {
  path: BUILD_DIR,
  publicPath: '/static/assets/', // necessary for lazy-loaded chunks
};

function addPreamble(entry) {  // 生成入口文件的前缀路径
  return PREAMBLE.concat([path.join(APP_DIR, entry)]);
}

const babelLoader = {	// babel加载器，负责国际化
  loader: 'babel-loader',
  options: {
    cacheDirectory: true,
    // disable gzip compression for cache files
    // faster when there are millions of small files
    cacheCompression: false,
    plugins: ['emotion'],
    presets: [
      [
        '@emotion/babel-preset-css-prop',
        {
          autoLabel: 'dev-only',
          labelFormat: '[local]',
        },
      ],
    ],
  },
};

const config = {
  node: {
    fs: 'empty',
  },
  // entry, 指定src目录下各目录的打包入口
  entry: {
    theme: path.join(APP_DIR, '/src/theme.ts'),
    preamble: PREAMBLE,
    addSlice: addPreamble('/src/addSlice/index.tsx'),
    explore: addPreamble('/src/explore/index.jsx'),
    dashboard: addPreamble('/src/dashboard/index.jsx'),
    sqllab: addPreamble('/src/SqlLab/index.tsx'),
    crudViews: addPreamble('/src/views/index.tsx'),
    menu: addPreamble('src/views/menu.tsx'),
    profile: addPreamble('/src/profile/index.tsx'),
    showSavedQuery: [path.join(APP_DIR, '/src/showSavedQuery/index.jsx')],
  },
  optimization: {  },
  resolve: { },    
  context: APP_DIR, // to automatically find tsconfig.json
  module: {  //模块定义文件格式对应的loader
    rules: [
      { test: /\.txt$/, use: 'raw-loader' }
    ]
  },
  plugins: [  //插件
    new HtmlWebpackPlugin({template: './src/index.html'})
  ]  
}   

const smp = new SpeedMeasurePlugin({
  disable: !measure,
});
// 模块导出目标即部署目标、构建目标
module.exports = smp.wrap(config);
 ```

说明：Jinja2模板使用js_bundle，css_bundle函数 传递name在 webpack.config.js寻找对应的tsx文件。如 `{{ js_bundle("theme") }}`



#### 前端打包入口文件

superset-frontend用到 `ReactDOM.render() `共8个tsx文件。也可以参照 webpack.config.js的entry。

文件名格式：/superset-frontend/src/{目录}/index.tsx

下面4个实现一致:  views, addslice, SqlLab,  profile

```tsx
import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';

// 渲染效果： <div id="app"> 模板App的HTML语言 </div>
// 模板App在Vue框架里一般称叫组件 
ReactDOM.render(<App />, document.getElementById('app'));
```



下面2个实现一致:  dashboard, explorer

```tsx
import React from 'react';
import ReactDOM from 'react-dom';
import thunk from 'redux-thunk';
import { createStore, applyMiddleware, compose } from 'redux';
import { initFeatureFlags } from 'src/featureFlags';
import { initEnhancer } from '../reduxUtils';
import getInitialState from './reducers/getInitialState';
import rootReducer from './reducers/index';
import initAsyncEvents from '../middleware/asyncEvent';
import logger from '../middleware/loggerMiddleware';
import * as actions from '../chart/chartAction';

import App from './App';

const appContainer = document.getElementById('app');
const bootstrapData = JSON.parse(appContainer.getAttribute('data-bootstrap'));
initFeatureFlags(bootstrapData.common.feature_flags);
const initState = getInitialState(bootstrapData);

// 异步事件中间件
const asyncEventMiddleware = initAsyncEvents({
  config: bootstrapData.common.conf,
  getPendingComponents: ({ charts }) =>
    Object.values(charts).filter(c => c.chartStatus === 'loading'),
  successAction: (componentId, componentData) =>
    actions.chartUpdateSucceeded(componentData, componentId),
  errorAction: (componentId, response) =>
    actions.chartUpdateFailed(response, componentId),
});

// 定义Store：传参Reducer、initState、中间件
const store = createStore(
  rootReducer,
  initState,
  compose(
    //applyMiddleware将传参中间件组成一个数组，依次执行。如下面3个中间件依次执行store.dispatch
    applyMiddleware(thunk, logger, asyncEventMiddleware),
    initEnhancer(false),
  ),
);

ReactDOM.render(<App store={store} />, document.getElementById('app'));
```



/superset-frontend/src/views/menu.tsx

```tsx
import React from 'react';
import ReactDOM from 'react-dom';
import { supersetTheme, ThemeProvider } from '@superset-ui/core';
import Menu from 'src/components/Menu/Menu';

const container = document.getElementById('app');
const bootstrapJson = container?.getAttribute('data-bootstrap') ?? '{}';
const bootstrap = JSON.parse(bootstrapJson);
const menu = { ...bootstrap.common.menu_data };
const app = (
  <ThemeProvider theme={supersetTheme}>
    <Menu data={menu} />
  </ThemeProvider>
);
ReactDOM.render(app, document.getElementById('app-menu'));
```





### React全局路由

* /src/views/App.tsx  定义了全局路由，主要依赖于组件 react-router-dom

* /src/views/CRUD/xx    具体的视图组件

  

**/src/views/App.tsx**

Route path匹配到的路由映射到相应的组件视图。

```tsx
import React from 'react';
import { hot } from 'react-hot-loader/root';
import thunk from 'redux-thunk';
import { createStore, applyMiddleware, compose, combineReducers } from 'redux';
import { Provider as ReduxProvider } from 'react-redux';
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';
import { QueryParamProvider } from 'use-query-params';
import { initFeatureFlags } from 'src/featureFlags';
import { supersetTheme, ThemeProvider } from '@superset-ui/core';
import { DynamicPluginProvider } from 'src/components/DynamicPlugins';
import ErrorBoundary from 'src/components/ErrorBoundary';
import Menu from 'src/components/Menu/Menu';
import FlashProvider from 'src/components/FlashProvider';
import AlertList from 'src/views/CRUD/alert/AlertList';
import ExecutionLog from 'src/views/CRUD/alert/ExecutionLog';
import AnnotationLayersList from 'src/views/CRUD/annotationlayers/AnnotationLayersList';
import AnnotationList from 'src/views/CRUD/annotation/AnnotationList';
import ChartList from 'src/views/CRUD/chart/ChartList';
import CssTemplatesList from 'src/views/CRUD/csstemplates/CssTemplatesList';
import DashboardList from 'src/views/CRUD/dashboard/DashboardList';
import DatabaseList from 'src/views/CRUD/data/database/DatabaseList';
import DatasetList from 'src/views/CRUD/data/dataset/DatasetList';
import QueryList from 'src/views/CRUD/data/query/QueryList';
import SavedQueryList from 'src/views/CRUD/data/savedquery/SavedQueryList';

import messageToastReducer from '../messageToasts/reducers';
import { initEnhancer } from '../reduxUtils';
import setupApp from '../setup/setupApp';
import setupPlugins from '../setup/setupPlugins';
import Welcome from './CRUD/welcome/Welcome';
import ToastPresenter from '../messageToasts/containers/ToastPresenter';

setupApp();
setupPlugins();

const container = document.getElementById('app');
const bootstrap = JSON.parse(container?.getAttribute('data-bootstrap') ?? '{}');
const user = { ...bootstrap.user };
const menu = { ...bootstrap.common.menu_data };
const common = { ...bootstrap.common };
initFeatureFlags(bootstrap.common.feature_flags);

const store = createStore(
  combineReducers({
    messageToasts: messageToastReducer,
  }),
  {},
  compose(applyMiddleware(thunk), initEnhancer(false)),
);

const App = () => (
  <ReduxProvider store={store}>
    <ThemeProvider theme={supersetTheme}>
      <FlashProvider common={common}>
        <Router>
          <DynamicPluginProvider>
            <QueryParamProvider
              ReactRouterRoute={Route}
              stringifyOptions={{ encode: false }}
            >
              <Menu data={menu} />
              <Switch>
                <Route path="/superset/welcome/">
                  <ErrorBoundary>
                    <Welcome user={user} />
                  </ErrorBoundary>
                </Route>
                <Route path="/dashboard/list/">
                  <ErrorBoundary>
                    <DashboardList user={user} />
                  </ErrorBoundary>
                </Route>                  
              </Switch>
              <ToastPresenter />
            </QueryParamProvider>
          </DynamicPluginProvider>
        </Router>
      </FlashProvider>
    </ThemeProvider>
  </ReduxProvider>
);     

// App组件模板热更新 
export default hot(App);
```

上面是全局的路由映射，Route path匹配值对应相应的组件如 Welcome。



后端传输给前段的数据  （这部分数据是通用的，包括用户信息、语言包，基本配置等等）

```html
<div id="app" data-bootstrap=""></div>
```

data-bootstrap内容如下

```json
{
	"user": {
		"username": "admin",
		"firstName": "admin",
		"lastName": "user",
		"userId": 1,
		"isActive": true,
		"createdOn": "2021-07-13T13:54:08.783379",
		"email": "admin@fab.org"
	},
	"common": {
		"flash_messages": [],
		"conf": {
			"SUPERSET_WEBSERVER_TIMEOUT": 60,
			"SUPERSET_DASHBOARD_POSITION_DATA_LIMIT": 65535,
			"SUPERSET_DASHBOARD_PERIODICAL_REFRESH_LIMIT": 0,
			"SUPERSET_DASHBOARD_PERIODICAL_REFRESH_WARNING_MESSAGE": null,
			"DISABLE_DATASET_SOURCE_EDIT": null,
			"ENABLE_JAVASCRIPT_CONTROLS": false,
			"DEFAULT_SQLLAB_LIMIT": 1000,
			"SQL_MAX_ROW": 100000,
			"SUPERSET_WEBSERVER_DOMAINS": null,
			"SQLLAB_SAVE_WARNING_MESSAGE": null,
			"DISPLAY_MAX_ROW": 10000,
			"GLOBAL_ASYNC_QUERIES_TRANSPORT": "polling",
			"GLOBAL_ASYNC_QUERIES_POLLING_DELAY": 500
		},
		"locale": "zh",
		"language_pack": {
			"domain": "superset",
			"locale_data": {
		},
		"feature_flags": {
			"ALLOW_DASHBOARD_DOMAIN_SHARDING": true,
			"CLIENT_CACHE": false,
			"DISABLE_DATASET_SOURCE_EDIT": false,
			"DYNAMIC_PLUGINS": false,
			"ENABLE_EXPLORE_JSON_CSRF_PROTECTION": false,
			"ENABLE_TEMPLATE_PROCESSING": false,
			"KV_STORE": false,
			"PRESTO_EXPAND_DATA": false,
			"THUMBNAILS": false,
			"DASHBOARD_CACHE": false,
			"REMOVE_SLICE_LEVEL_LABEL_COLORS": false,
			"SHARE_QUERIES_VIA_KV_STORE": false,
			"SIP_38_VIZ_REARCHITECTURE": false,
			"TAGGING_SYSTEM": false,
			"SQLLAB_BACKEND_PERSISTENCE": false,
			"LISTVIEWS_DEFAULT_CARD_VIEW": false,
			"ENABLE_REACT_CRUD_VIEWS": true,
			"DISPLAY_MARKDOWN_HTML": true,
			"ESCAPE_MARKDOWN_HTML": false,
			"DASHBOARD_NATIVE_FILTERS": false,
			"GLOBAL_ASYNC_QUERIES": false,
			"VERSIONED_EXPORT": false,
			"ROW_LEVEL_SECURITY": false,
			"ALERT_REPORTS": false
		},
		"extra_sequential_color_schemes": [],
		"extra_categorical_color_schemes": [],
		"menu_data": {
			"menu": [{},],
			"brand": {
				"path": "/",
				"icon": "/static/assets/images/superset-logo-horiz.png",
				"alt": "Superset",
				"width": 126
			},
			"navbar_right": {
				"bug_report_url": null,
				"documentation_url": null,
				"version_string": "1.0.0",
				"version_sha": "",
				"languages": {
					"en": {
						"flag": "us",
						"name": "English",
						"url": "/lang/en"
					}
				},
				"show_language_picker": false,
				"user_is_anonymous": false,
				"user_info_url": "/users/userinfo/",
				"user_logout_url": "/logout/",
				"user_login_url": "/login/",
				"user_profile_url": "/superset/profile/admin",
				"locale": "zh"
			}
		}
	}
}
```



### React组件  /src/components/

此处组件是指最小粒度的React组件。

#### 菜单 Menu/

见上文 《导航栏布局》



### 视图布局 /src/views/

#### 图表 chart/

* ChartList.tsx
* ChartCard.tsx
* types.ts



/superset-frondend/src/views/chart/ChartList.tsx

```tsx
function ChartList(props: ChartListProps) {
  const { addDangerToast, addSuccessToast } = props;
    
  // ChartCard 图表卡片  
  function renderCard(chart: Chart) {
    return (
      <ChartCard
        chart={chart}
        hasPerm={hasPerm}
        openChartEditModal={openChartEditModal}
        bulkSelectEnabled={bulkSelectEnabled}
        addDangerToast={addDangerToast}
        addSuccessToast={addSuccessToast}
        refreshData={refreshData}
        loading={loading}
        favoriteStatus={favoriteStatus[chart.id]}
        saveFavoriteStatus={saveFavoriteStatus}
      />
    );
  }

  // ChartList的返回HTML
  return (
    <>
      <SubMenu name={t('Charts')} buttons={subMenuButtons} />
      {sliceCurrentlyEditing && (
        <PropertiesModal
          onHide={closeChartEditModal}
          onSave={handleChartUpdated}
          show
          slice={sliceCurrentlyEditing}
        />
      )}
      <ConfirmStatusChange
        title={t('Please confirm')}
        description={t('Are you sure you want to delete the selected charts?')}
        onConfirm={handleBulkChartDelete}
      >
        {confirmDelete => {
          const bulkActions: ListViewProps['bulkActions'] = [];
          if (canDelete) {
            bulkActions.push({
              key: 'delete',
              name: t('Delete'),
              type: 'danger',
              onSelect: confirmDelete,
            });
          }
          if (canExport) {
            bulkActions.push({
              key: 'export',
              name: t('Export'),
              type: 'primary',
              onSelect: handleBulkChartExport,
            });
          }
          return (
            <ListView<Chart>
              bulkActions={bulkActions}
              bulkSelectEnabled={bulkSelectEnabled}
              cardSortSelectOptions={sortTypes}
              className="chart-list-view"
              columns={columns}
              count={chartCount}
              data={charts}
              disableBulkSelect={toggleBulkSelect}
              fetchData={fetchData}
              filters={filters}
              initialSort={initialSort}
              loading={loading}
              pageSize={PAGE_SIZE}
              renderCard={renderCard}
              defaultViewMode={
                isFeatureEnabled(FeatureFlag.LISTVIEWS_DEFAULT_CARD_VIEW)
                  ? 'card'
                  : 'table'
              }
            />
          );
        }}
      </ConfirmStatusChange>

      <ImportModelsModal
        resourceName="chart"
        resourceLabel={t('chart')}
        passwordsNeededMessage={PASSWORDS_NEEDED_MESSAGE}
        confirmOverwriteMessage={CONFIRM_OVERWRITE_MESSAGE}
        addDangerToast={addDangerToast}
        addSuccessToast={addSuccessToast}
        onModelImport={handleChartImport}
        show={importingChart}
        onHide={closeChartImportModal}
        passwordFields={passwordFields}
        setPasswordFields={setPasswordFields}
      />
    </>
  );
}
                
export default withToasts(ChartList);                
```





### explorer /src/explorer/

####  控制按钮 controls.jsx

/superset-frontend/src/explorer/controls.jsx

```jsx
import React from 'react';
import {
  t,
  getCategoricalSchemeRegistry,
  getSequentialSchemeRegistry,
  legacyValidateInteger,
  validateNonEmpty,
} from '@superset-ui/core';
import { ColumnOption } from '@superset-ui/chart-controls';
import { formatSelectOptions, mainMetric } from 'src/modules/utils';
import { TIME_FILTER_LABELS } from './constants';

const categoricalSchemeRegistry = getCategoricalSchemeRegistry();
const sequentialSchemeRegistry = getSequentialSchemeRegistry();

export const PRIMARY_COLOR = { r: 0, g: 122, b: 135, a: 1 };

// groupby控制按键
const groupByControl = {
  type: 'SelectControl',
  multi: true,
  freeForm: true,
  label: t('Group by'),
  default: [],
  includeTime: false,
  description: t('One or many controls to group by'),
  optionRenderer: c => <ColumnOption column={c} showType />,
  valueRenderer: c => <ColumnOption column={c} />,
  valueKey: 'column_name',
  allowAll: true,
  filterOption: ({ data: opt }, text) =>
    (opt.column_name &&
      opt.column_name.toLowerCase().indexOf(text.toLowerCase()) >= 0) ||
    (opt.verbose_name &&
      opt.verbose_name.toLowerCase().indexOf(text.toLowerCase()) >= 0),
  promptTextCreator: label => label,
  mapStateToProps: (state, control) => {
    const newState = {};
    if (state.datasource) {
      newState.options = state.datasource.columns.filter(c => c.groupby);
      if (control && control.includeTime) {
        newState.options.push(timeColumnOption);
      }
    }
    return newState;
  },
  commaChoosesOption: false,
};
```





## 5 依赖模块

### 后端依赖 Jinja2

参见  《python web框架源码分析》jinja2章节



### 后端依赖 sqlalchemy

* /sqlalchemy/engine/url.py  eingine组成 (RFC1738)： name://user:pwd@host:port/database





### 前端依赖 @superset-ui

前端依赖这个项目 superset-ui。

@superset-ui/legacy-*软件包从经典的中提取并转换为插件。 这些包的提取只需很小的更改（几乎保持原样）。 它们还依靠旧版API（ viz.py ）起作用。 

*@superset-ui/plugin-*软件包通常较新且质量更高。 它们不依赖viz.py （包含可视化特定的python代码）并与/api/v1/query/交互的主要区别在于：新的通用终结点旨在提供所有可视化。 还应该用Typescript编写。



### 前端依赖 React

参见   React学习笔记--程序调试 https://www.cnblogs.com/tom-lau/p/8032323.html



React体系：React + react-dom ＋ react-redux + 

**React组件**

React 组件是可复用的小的代码片段，它们返回要在页面中渲染的 React 元素。JS函数和React.Component派生类都是组件。

React 组件从概念上类似于 JavaScript 函数。它接受任意的入参（即 “props”），并返回用于描述页面展示内容的 React 元素。

React规范里以小写字母开头的组件视为原生 DOM 标签，如<div />代表 HTML 的 div 标签；大写字母开头的为React组件，如<App />。

React 组件基本由三个部分组成，

1. 属性 props： React 组件的输入。它们是从父组件向下传递给子组件的数据。不可被修改。
2. 状态 state：当组件中的一些数据在某些时刻发生变化时，这时就需要使用 `state` 来跟踪状态。
3. 生命周期方法：用于在组件不同阶段执行自定义功能。组件的生命周期阶段包括挂载、更新、卸载和错误处理。参见 [React组件生命周期图谱](https://projects.wojtekmaj.pl/react-lifecycle-methods-diagram/)
   * 挂载时调用顺序： constructor() static getDerivedStateFromProps() render() componentDidMount()
   * 更新时调用顺序：static getDerivedStateFromProps() shouldComponentUpdate() render() getSnapshotBeforeUpdate() componentDidUpdate()
   * 卸载：componentWillUnmount()
   * 错误处理：static getDerivedStateFromError() componentDidCatch()



tic-tac-toe(三连棋)游戏代码: **[最终成果](https://codepen.io/gaearon/pen/gWWZgR?editors=0010)**.



#### **react-redux**

2014年 Facebook 提出了 [Flux](https://www.ruanyifeng.com/blog/2016/01/flux.html) 架构的概念，引发了很多的实现。2015年，[Redux](https://github.com/reactjs/redux) 出现，将 Flux 与函数式编程结合一起，很短时间内就成为了最热门的前端架构。

Flux将一个应用分成四个部分。

> - **View**： 视图层
> - **Action**（动作）：视图层发出的消息（比如mouseClick）
> - **Dispatcher**（派发器）：用来接收Actions、执行回调函数
> - **Store**（数据层）：用来存放应用的状态，一旦发生变动，就提醒Views要更新页面

![img](https://www.ruanyifeng.com/blogimg/asset/2016/bg2016011503.png)

Flux 的最大特点，就是数据的"单向流动"。任何相邻的部分都不会发生数据的"双向流动"。这保证了流程的清晰。这就是React的单向数据绑定，区别于Vue的双向绑定。数据单向流动流程详细说明如下：

```shell
1. 用户访问 View
2. View 发出用户的 Action
3. Dispatcher 收到 Action，要求 Store 进行相应的更新
4. Store 更新后，发出一个"change"事件
5. View 收到"change"事件后，更新页面
```

Redux思想：WEB应用是一个状态机，视图(View) 与状态(State) 一一对应。所有的状态保存在一个对象（Store）里。reducer是生成新状态。

![img](https://www.ruanyifeng.com/blogimg/asset/2016/bg2016091802.jpg)

Redux数据流向过程：
1）用户发出Action（进行点击click、输入input等事件，子组件通过callback调用最外层组件的自定义事件。

2）callback中执行Dispatcher（actions creators(data)）。 或者 `store.dispatch(action);`

3）Store监听到action被触发，执行相应的Reducer，State被改变。监听函数listener `store.subscribe(listener);`

4）页面render

React-Redux 将所有组件分成两大类：UI 组件（presentational component）和容器组件（container component）。UI 组件负责 UI 的呈现，容器组件负责管理数据和逻辑。

React-Redux 规定，所有的 UI 组件都由用户提供，容器组件则是由 React-Redux 自动生成。也就是说，用户负责视觉层，状态管理则是全部交给它。

实现方式：

* connect： 用于从 UI 组件生成容器组件。`function connect(mapStateToProps, mapDispatchToProps, mergeProps)`
* Provider组件：让容器组件拿到`state`。



**react-router**

`Router`组件本身只是一个容器，真正的路由要通过`Route`组件定义。

```
import { Router, Route, hashHistory } from 'react-router';

render((
  <Router history={hashHistory}>
    <Route path="/" component={App}/>
  </Router>
), document.getElementById('app'));
```



**react-router-dom**

React Router附带了一些HOOK，可让您访问路由器的状态并从组件内部执行导航。

```tsx
import React from "react";
import ReactDOM from "react-dom";
import { BrowserRouter as Router, Route } from "react-router-dom";

ReactDOM.render(
  <Router>
    <div>
      <Route exact path="/">
        <Home />
      </Route>
      <Route path="/news">
        <NewsFeed />
      </Route>
    </div>
  </Router>,
  node
);
```





## 本章参考

* 知乎专栏-superset开发 https://zhuanlan.zhihu.com/c_100045590
* superset二次开发及汉化、图标等 https://blog.csdn.net/qq_34521526/article/details/116708025
* Superset 代码结构分析(前后端如何联动) https://zhuanlan.zhihu.com/p/163495199
* 从前端角度记录superset二次开发 http://sunjl729.cn/2020/08/07/superset二次开发/
* Superset安装及汉化 https://www.jianshu.com/p/c751278996f8
* Jinja2中文文档  http://docs.jinkan.org/docs/jinja2/
* [译]揭秘 React 服务端渲染 https://juejin.cn/post/6844903604453654536
* Flux 架构入门教程 https://www.ruanyifeng.com/blog/2016/01/flux.html
* React 入门实例教程(删) https://www.ruanyifeng.com/blog/2015/03/react.html
* [Redux - A predictable state container for JavaScript apps. | Redux](https://redux.js.org/)   https://redux.js.org/





# 参考资料

官网

* babel中文文档  https://www.babeljs.cn/  
* Vue JS  https://cli.vuejs.org 
* react官网中文文档  https://zh-hans.reactjs.org
* [Flask-AppBuilder官方文档](http://flask-appbuilder.readthedocs.io/en/latest/index.html)  http://flask-appbuilder.readthedocs.io/
* boostrap中文网  https://www.bootcss.com/
* webpack中文文档 https://www.webpackjs.com/concepts/



开发站点

* 中文文档  https://docschina.org/
* 前端代码在线验证  https://codepen.io/



# 附录

## ES６语法

es6之扩展运算符 三个点（…）:   对象中的扩展运算符(...)用于取出参数对象中的所有可遍历属性，拷贝到当前对象之中。
