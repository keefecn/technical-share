| 序号  | 修改时间      | 修改内容          | 修改人   | 审稿人   |
| --- | --------- | ------------- | ----- | ----- |
| 1   | 2021-6-1  | 创建。新增源码剖析篇章节。 | Keefe | Keefe |
| 2   | 2021-7-18 | 单独成文。         | Keefe |       |
| 3   |           |               |       |       |

<br><br><br>

---

[TOC]

<br>

----

# superset源码剖析

源码分析版本： superset-1.0   superset-1.3

```shell
$ pip show apache-superset
Name: apache-superset
Version: 1.0.0
Summary: A modern, enterprise-ready business intelligence web application
Home-page: https://superset.apache.org/
Author: Apache Software Foundation
Author-email: dev@superset.apache.org
License: Apache License, Version 2.0
Location: ~\venv\superset-py38-env\lib\site-packages
Requires: backoff, bleach, cachelib, celery, click, colorama, contextlib2, croniter, cron-descriptor, cryptography, flask, flask-appbuilder, flask-caching, flask-compress, flask-talisman, flask-migrate, flask-wtf, geopy, gunicorn, humanize, isodate, markdown, msgpack, pandas, parsedatetime, pathlib2, pgsanity, polyline, python-dateutil, python-dotenv, python-geohash, pyarrow, pyyaml, redis, retry, selenium, simplejson, slackclient, sqlalchemy, sqlalchemy-utils, sqlparse, wtforms-json, pyparsing, holidays
Required-by:

$ pip show superset
Name: superset
Version: 0.30.1
Summary: Superset has moved to apache-superset, as of 0.34.0 onwards, please pip install apache-superset
Home-page: https://superset.apache.org/
Author: Apache Software Foundation
Author-email: dev@superset.incubator.apache.org
License: Apache License, Version 2.0
Location: ~/venv/superset-py36-env/lib/python3.6/site-packages
Requires: flask, boto3, gunicorn, python-dateutil, simplejson, future, contextlib2, pandas, pyyaml, bleach, colorama, pydruid, flask-migrate, python-geohash, sq
lalchemy-utils, thrift, sqlparse, pathlib2, sqlalchemy, unidecode, celery, flask-compress, geopy, humanize, cryptography, parsedatetime, flower, flask-appbuilder, requests, six, unicodecsv, polyline, flask-testing, flask-wtf, markdown, thrift-sasl, pyhive, flask-script, idna, flask-caching
Required-by:
```

> 特别说明： 本文目录结构中标题的源码路径跟标题级别有关，一般下级标题的源码路径前缀就是上级标题。

## 1 源码结构

表格  项目顶层目录结构

| 一级目录或文件                | 二级目录或文件                         | 简介                                                   |
| ---------------------- | ------------------------------- | ---------------------------------------------------- |
| dist/                  | xx.tar.gz                       | 打包时`python setup.py sdist`自动生成                       |
| docker/                |                                 | docker相关的脚本。里面脚本基础OS环境要换yum源，不然安装软件慢得让人绝望。           |
| helm/                  |                                 | helm镜像仓库的配置目录                                        |
| RELEASING/             |                                 | 跟发布相关的脚本等                                            |
| RESOURCES/             | FEATURE_FLAGS.md INTHEWILD.md   | v1.2新增目录。放特性标识和产品用户文件。                               |
| requirements/          |                                 | 各种安装方式的模块依赖文件，requirement.txt 组件需求                   |
| tests/                 | integration_tests/ unit_tests/  | 测试目录。v1.2调整了目录结构。                                    |
| docs/                  |                                 | 文档，使用spinx生成                                         |
| scripts/               | pypi_push.sh   python_tests.sh  | superset常用的脚本                                        |
| **superset/**          | static/ charts/ dashboards/ ... | superse后端源码目录                                        |
| **superset-frontend**/ | src/ imgaes/ branding/ ...      | superset前端源码目录                                       |
| **superset-websock/**  |                                 | v1.2新增目录。websock实现。                                  |
| setup.py setup.cfg     |                                 | 安装脚本，包括了依赖组件                                         |
| README.md              |                                 | 用户指南                                                 |
| CHANGELOG.md           |                                 | 版本更新日志。细粒度（PR)级的更改                                   |
| UPDATING.md            |                                 | 更新新版本相关。该文件记录了 Superset 中任何向后不兼容的更改，并在人们迁移到新版本时提供帮助。 |

表格  源码后端目录superset里的结构

| 目录或文件             | 次模块                                                                  | 简介                                                                                                                        |
| ----------------- | -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| annotation_layers |                                                                      | 锚点层                                                                                                                       |
| (弃~~) assets~~    |                                                                      | 前端依赖框架集成，这里存放了npm集成的依赖js框架，当你打开后会看到node_modules文件夹，由npm动态生成，命令是`$ npm run dev-fast`<br>1.x版本已将此目录移到外层，改为superset-frontend |
| async_events      |                                                                      | 异步事件                                                                                                                      |
| cachekeys         |                                                                      | 缓存键K-V                                                                                                                    |
| > charts          | api.py dao.py filters.py schemas.py                                  | 图表的API，数据库操作、过滤处理、解析查询参数的JSON项                                                                                            |
| commands          | BaseCommand ExportModelsCommand                                      | 支持的命令。命令基类/命令异常类                                                                                                          |
| common            |                                                                      | 查询对象和查询上下文                                                                                                                |
| connectors        |                                                                      | 数据库连接器，数据源连接类型2种分别是物理表和虚表。所有连接器注册到ConnectorRegistry。                                                                      |
| dao               | BaseDAO DAOException                                                 | 数据访问基类、数据访问异常类                                                                                                            |
| > dashboards      |                                                                      | 看板。结构类似图表。                                                                                                                |
| > databases       |                                                                      | 数据库dbs/数据源。结构类似图表。                                                                                                        |
| > datasets        |                                                                      | 数据集。结构类似图表。                                                                                                               |
| db_engines        |                                                                      | 0.x时就有的目录。连接其他数据库的engines 比如mysql，pgsql等。等待废弃。                                                                            |
| db_engine_spec    |                                                                      | DB引擎实现，各种数据源实现都放到这。数据源可分为普通源和druid源。                                                                                      |
| examples          |                                                                      | 17+个示例数据集，用 superset load-examples加载，需从网络下载                                                                               |
| migrations        |                                                                      | 做数据迁移用的，比如更新数据库，更新ORM(model和表中字段的映射关系)。                                                                                   |
| models            |                                                                      | 存放项目的model，如果要修改字段，优先到这里寻找。                                                                                               |
| > quaries         |                                                                      | 查询SQL相关。结构类似图表。                                                                                                           |
| > reports         |                                                                      | 报表相关。结构类似图表。                                                                                                              |
| security          | SupersetSecurityManager  DBSecurityException                         | 安全权限管理。包括用户认证                                                                                                             |
| sql_validators    |                                                                      | SQL验证                                                                                                                     |
| **static**        | assets                                                               | 存放静态文件的目录，比如我们用到的css、js、图片等静态文件都在这里。superset-frontend前端构建打包后生成的文件放到这。                                                     |
| tasks             |                                                                      | celery 任务脚本                                                                                                               |
| **templates**     | appbuilder, email, slack, superset                                   | JinJa2模板目录，项目所有的HTML文件都在这里。<br>superset/basic.html提供web整体的样式风格。<br>appbuilder/navbar_menu.html导航菜单                        |
| translations      | zh en ...                                                            | 翻译文件，babel生成。message.json才是实际加载文件。                                                                                        |
| utils             |                                                                      | 工具                                                                                                                        |
| views             | /chart /dashboard /database /log base.py core.py health.py api.py... | 视图文件，这里定义了url，来作为前端的入口。  <br>core.py中的函数在渲染页面时，都要指定basic.html模板为基础。                                                       |
| app.py            | create_app                                                           | WEB实例初始化，也是调试入口                                                                                                           |
| cli.py            |                                                                      | superset命令                                                                                                                |
| extensions.py     |                                                                      | 定义 celery， logger 等中间件                                                                                                    |
| viz.py            | BaseViz NVD3Viz viz_types                                            | 可视化图表类型的基类及派生类。viz_sip38.py是替换版本(v1.3已移除）。                                                                                |

> superset后端用到的组件主要有：flask_appbuilder, flask_sqlalchemy, Jinja2, pandas

表格  前端目录superset-frontend源码结构

| 目录或文件                   | 二级目录或文件                                                   | 简介                                                                                     |
| ----------------------- | --------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| .eslintrc.js            |                                                           | eslint配置文件。可编辑文件修改自己的规则。                                                               |
| babel.config.js         |                                                           | babel配置文件。可将jsx文件编译成js。                                                                |
| package.json            |                                                           | 前端模块依赖，用npm/yarn管理                                                                     |
| webpack.config.js       |                                                           | webpack构建配置文件。前端入口文件。<br>定义了 以src文件夹去生成打包js文件。                                         |
| webpack.proxy-config.js |                                                           | 执行 `npm run dev-server` 远程调试时会启用的配置文件                                                  |
| src                     |                                                           | 源码                                                                                     |
|                         | chart/                                                    | 根据图表属性渲染具体图表页面，里面调用了**SuperChart**组件。<br>而此组件属于superset-ui前端库，会根据后台传入的属性，最终渲染出对应的图表组件。 |
|                         | components/                                               | 各个最小组件的详细布局和数据                                                                         |
|                         | CRUD/                                                     | 页面操作CRUD涉及到的组件                                                                         |
|                         | dashboard/                                                | 仪表盘                                                                                    |
|                         | datasource/                                               | 数据集                                                                                    |
|                         | explore/                                                  | 生成某个图表详情的页面，如表单项。<br>controls.jsx 表单项列表                                                |
|                         | filters/                                                  | 过滤器                                                                                    |
|                         | visualizations/                                           | 可视化图表类型实现                                                                              |
|                         | views/                                                    | 路由映射视图，各个页面的详细布局在此，如/welcome/是首页                                                       |
|                         | constants.ts, reduxUtils.ts,<br>featureFlags.tx, theme.ts | 常量、常用函数、特性标识、主题。                                                                       |
|                         | preamble.ts                                               | 导言，定义了页面引导数据bootstrapData，安装客户端                                                        |
|                         |                                                           |                                                                                        |
|                         | ...                                                       |                                                                                        |
| branding                |                                                           | 存放项目logo                                                                               |
| cypress-base            | cypress                                                   | UI自动化测试框架                                                                              |
| images                  |                                                           | 图片，包括favicon.png, loading.git                                                          |
| spec                    |                                                           |                                                                                        |
| stylesheets             |                                                           |                                                                                        |

> superset前端用到的组件主要有：React, D3

## 2 前后端联动

前端指superset客户端，使用前端框架 React+D3+Echart实现。后端指superset服务端，python+flask-appbuilder实现。

### 组件概述

**依赖组件**：

前端组件

* React：交互，包括tsx语法、过滤器、hook等
* D3/NVD3：图表

后端组件

* Flask：web服务框架,  flask模块依赖jinja2
* Jinja2：模板引擎
* SQLALchemy：数据访问
* Pandas：数据结果展示

**架构**

* 服务端架构：MVTC，M-数据模型falsk_sqlalchemy，V-视图类flask_appbuilder，T-模板jinja2，C-路由分发、异步请求。

* 客户端架构：MVC，M-存储react-redux，V-视图组件react，C-路由分发react-dom-route

**国际化**

* 前端：依赖 @superset-ui，使用 t()
* 后端：依赖 flask_babel，使用 __()

### 前后端交互流程

**整体流程**

1. npm run dev --将每个模块打包成一个单独的js文件bundle（在webpack.config.js中配置）。dev是开发模式打包，build或prod是生产模式打包，文件更小。
2. superset run  --启动服务端http服务
3. 浏览器登录  --记录cookie
4. 点击某一菜单
5. wsgi 将请求重定向到python侧，执行路由视图函数（多定义在 /superset/views/xx.py）。
6. 视图函数用render_template构造html页面（返回HTML只是提供HTML大布局和启动数据，并不包括具体组件的渲染。render_templatec参数有jinja2模板和数据参数，数据参数一般包括entry和data-bootstrap）。
7. 浏览器render后端返回的html页面（通过启动数据和API数据 渲染具体的组件）。

**前后端打包**：

* 后端打包setup.py 取的版本号来自  前端superset-frontend/package.json:  `python setup.py sdist`
* 前端生成的包 在superset/static目录，打包配置文件是webpack.config.js： `npm run build`

**前后端分离不能彻底的原因**

superset使用了服务器端渲染HTML + 客户端渲染组件的组合方案。每个服务首页依赖于服务端渲染，superset大概有10个服务页。因此，前后端不能实现完全的分离。

* 服务端渲染HTML：服务首页只包括了基础数据、导航菜单和HTML框架。服务端导入JS/CSS文件通过js_bundle/css_bundle(name)定位到具体的react js/css文件。
* 客户端渲染：具体的组件渲染和交互由前端React来完成。

联调：前端调试时仍需superset支持。

* 前后端一体调试：可本地安装部署superset。如果本地安装不便，可以直接使用测试环境，将前端构建生成目录覆盖superset/static下相应文件即可。
* 启用web-dev-server本地调试前端：服务器指定代理使用远程，前端使用本地文件。启动命令是`npm run dev-server`。

#### 前后端映射js/css文件

* /superset/extensions.py  包括ResultsBackendManager和UIManifestProcessor，UIManifestProcessort管理前端脚本文件（用到mainfest.json)。
* /superset/static/assets/manifest.json   前端脚本文件信息，前端构建成功后自动生成。
* /superset-frontend/webpack.config.js   前端构建脚本，有打包文件入口定义entry。 详见章节 `前端打包逻辑`

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
        self._results_backend = None    #后端结果存储
        self._use_msgpack = False        #后端消息队列

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
        try:    # 读取json文件，取值entrypoints
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

因此，如果一个变量影响到多个文件，重新build生成的js文件名称可能不一样了（具体规则详见webpack.config.js），这时也需要 *重启服务端* 才能得到正确的文件映射。

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
   
   /superset/views/base.py
   
   ```python
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
           "menu_data": menu_data(),    #菜单数据，国际化部分从flask_appbuilder取语言包
       }
   
   class SupersetModelView(ModelView):
       # ModelView视图：数据库CRUD相关
       page_size = 100
       list_widget = SupersetListWidget
   
       def render_app_template(self) -> FlaskResponse:
             payload = {
               "user": bootstrap_user_data(g.user),
               "common": common_bootstrap_payload(),    # common数据
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
   ```

/superset/views/core.py

```python
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
   
   见下文 《前端打包入口文件》章节

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

客户端传递，传化成json格式

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

服务端判断 传参rison是否为有效python数据格式

装饰器 rison:

```python
# /flask_appbuilder/api/__init__.py
def rison(schema=None):
    """ 调用示例：
            schema = {
                "type": "object",
                "properties": {"arg1": {"type": "integer"}}
            }

            class ExampleApi(BaseApi):
                    @expose('/risonjson')
                    @rison(schema)
                    def rison_json(self, **kwargs):
                        return self.response(200, result=kwargs['rison'])
    """
    def _rison(f):
        def wraps(self, *args, **kwargs):
            value = request.args.get(API_URI_RIS_KEY, None)
            kwargs["rison"] = dict()
            if value:
                try:
                    kwargs["rison"] = prison.loads(value)
                except prison.decoder.ParserException:
                    if current_app.config.get("FAB_API_ALLOW_JSON_QS", True):
                        # Rison failed try json encoded content
                        try:
                            kwargs["rison"] = json.loads(
                                urllib.parse.parse_qs(f"{API_URI_RIS_KEY}={value}").get(
                                    API_URI_RIS_KEY
                                )[0]
                            )
                        except Exception:
                            return self.response_400(
                                message="Not a valid rison/json argument"
                            )
                    else:
                        return self.response_400(message="Not a valid rison argument")
            if schema:
                try:
                    jsonschema.validate(instance=kwargs["rison"], schema=schema)
                except jsonschema.ValidationError as e:
                    return self.response_400(message=f"Not a valid rison schema {e}")
            return f(self, *args, **kwargs)

        return functools.update_wrapper(wraps, f)

    return _rison
```

#### 页面引导数据 data-bootstrap

数据格式说明：

* user:  用户登陆基本信息
* common：基本配置项，包括 语言包（数据量最大）、配置项Conf、特征标识feature_flags、菜单menu_data
  * common.language_pack 语言包
  * common.menu_data 导航菜单

示例数据如下：

```json
{
    "user": {
        "username": "keefe",
        "firstName": "keefe",
        "lastName": "数据探索",
        "userId": 4,
        "isActive": true,
        "createdOn": "2021-07-28T06:51:23",
        "email": "keefe@163.com"
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
                "superset": {
                    "": {
                        "domain": "superset",
                        "plural_forms": "nplurals=1; plural=0;",
                        "lang": "zh"
                    },
                    "Home": ["首页"],
                    "Edit chart metadata": ["编辑图表元数据"],
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
            "ALERT_REPORTS": false,
            "OMNIBAR": false,
            "DASHBOARD_RBAC": false
        },
        "extra_sequential_color_schemes": [],
        "extra_categorical_color_schemes": [],
        "menu_data": {
            "menu": [
                {
                    "name": "Security",
                    "icon": "fa-cogs",
                    "label": "用户权限",
                    "childs": [
                        {"name":"List Users","icon":"fa-user","label":"用户列表","url":"/users/list/"},
                        {"name":"List Roles","icon":"fa-group","label":"角色列表","url":"/roles/list/"},"-",
                        {"name":"Action Log","icon":"fa-list-ol","label":"操作日志","url":"/logmodelview/list/"}
                    ]
                },
                {
                    "name":"Data","icon":"fa-database","label":"数据",
                    "childs":[
                        {"name":"Databases","icon":"fa-database","label":"数据库","url":"/databaseview/list/"},
                        {"name":"Datasets","icon":"fa-table","label":"数据集","url":"/tablemodelview/list/?_flt_1_is_sqllab_view=y"},"-",
                        {"name":"Upload a CSV","icon":"fa-upload","label":"上传CSV文件","url":"/csvtodatabaseview/form"}]
                },
                {
                    "name": "Charts",
                    "icon": "fa-bar-chart",
                    "label": "图表",
                    "url": "/chart/list/"
                }
            ],
            "brand": {
                "path": "/",
                "icon": "/static/assets/images/superset-logo-horiz.png",
                "alt": "DataLab",
                "width": 126
            },
            "navbar_right": {
                "bug_report_url": null,
                "documentation_url": null,
                "version_string": "1.0.6",
                "version_sha": "6b55a222",
                "languages": {
                    "en":{"flag":"us","name":"English","url":"/lang/en"},
                },
                "show_language_picker": false,
                "user_is_anonymous": false,
                "user_info_url": "/users/userinfo/",
                "user_logout_url": "/logout/",
                "user_login_url": "/login/",
                "user_profile_url": "/superset/profile/keefe",
                "locale": "zh"
            }
        }
    }
}
```

### 会话管理

服务器和客户端(浏览器)之间的会话管理，包括session, cookie, csrf-token。

服务端

* /superset/config.py  配置session/cookie/csrf/cors
* /superset/app.py  根据配置信息create_app
* /superset/views/core.py   /csrf_token/ 接口

客户端

* /superset-frontend/src/utils/parseCookie.tsx   parseCookie方法实现读取cookie字段
* /superset-frontend/src/setup/setupClients.tsx  从页面提取csrf_token和相关信息，来创建客户端

cookie示例：主要字段有_xsrf, session, csrf_access_token

示例如下：

```shell
_xsrf=5|032f42b4|e86b7b403d2166b24cd7bd243e6d0cdd|1628748122;remember_token=5|5e16c92420f51b33c4c3b7dc2eccf46ace6963402024dabc35afc3dd54aaeab3ebcdf29de906cfdbd48e8e9390508c86050ddc5ae573945b5c3298a40435caec; session=.eJztlMFqxDAMRH8l6ByKnNiWnV8pS7AtuQmbbJY4C6XL_ntd2k_oMafRXB4zh9ETxryEMkmB4f0JzVEFViklfAi0kCZJ1_HYrnIb5fM-78LNXJq_s20eRfahOaQcCi6v9gScgBPwP4BLW6e5S5lgOPaHVDczDJBt6LxwFPbISBiVUqnXSOysZh0o-tB7pSSTZQrE3gmz80aR06bL3nuy0cXskFxInZDFaJCTxl5nmzuxKSBpRlTWSTIuK6JkOKocnYm1x7KlsEjN8jVVt8sqa5R9LJK2G9c_ohziG7bw0-c3tIHXN6m5fks.YVV-gQ.Dq6CqLfFfqoP4sxkzVai2ovKUD4
```

* session：flask模块支持，定义在app.py Flask.SESSION_COOKIE_NAME；cookie数据依赖 itdangerous模块的哈希签名序列化生成。
* _xsrf：flask_wtf模块支持，值结构为`{user_id}|{}|{}`
* remember_token:  flask_login模块支持，当user_login时记录user_id及摘要信息。值结构为`{user_id}|{user_id_digest}`，user_id_digest是用user_id生成hmac摘要供服务端验证，防止数据user_id被修改。

```python
import hashlib
from itsdangerous import URLSafeTimedSerializer
from flask.json.tag import TaggedJSONSerializer

token = ".eJx9kMtqxDAMRf_F61DLlp-B0g8pxdiW3AQCGRLPojP03-u2m26maHXhHF2hu0jt4HMRcz-uPIm0kphF1i6YGrlBsBRVUZoDMMVsLHpnIgLpYlRrVQHFYku1zgVmdMplj9YYJo0eswUsCM5ydW2sjMYWj8ahNyagrhWiL6zBO6TGOjRdgJiUmMS217zxuOW2jHTJ75yW9ez78SHmV7H0fpmlVNo_wRg1WwAlj33jU24Dk8P5j2FauwwPoevJxykz0UtqW0-Qfqznx8Lf5rdJfPu_n7Ti8wt3-WTT.YTGVAA.3AdM1VXeDFIRvDcZC_HrZomSVK8"
secret_key = b'xxx'
salt = b'xxx'
serializer = TaggedJSONSerializer()
signer_kwargs = {'key_derivation': 'hmac', 'digest_method': hashlib.sha1}
auth_s = URLSafeTimedSerializer(secret_key, salt=salt, serializer=serializer, signer_kwargs=signer_kwargs)
data = auth_s.loads(token)
print(data)

# 结果
{
    "_fresh": true,
    "_id": "a2684c9ef085d91b12e80ed9a453764930d2b41ffc10d9b5bc5668ee3616a73544ed2373a503b3065ec6f684945b73463744832cc097be20763dfe28f2b0ded1",
    "locale": "zh",
    "page_history": [
        "http://127.0.0.1:5001/roles/list/",
        "http://127.0.0.1:5001/roles/edit/8",
        "http://127.0.0.1:5001/users/add?_flt_0_roles=8",
        "http://127.0.0.1:5001/roles/list/"
    ],
    "user_id": "5"
}
```

#### 服务端会话

session管理 详见 《[flask源码剖析](./flask源码剖析.md)》

csrf&cors 见下文 安全权限管理 章节。

/superset/config.py

```python
#
# Flask session cookie options
#
# See https://flask.palletsprojects.com/en/1.1.x/security/#set-cookie-options
# for details
#
SESSION_COOKIE_HTTPONLY = True  # Prevent cookie from being read by frontend JS?
SESSION_COOKIE_SECURE = False  # Prevent cookie from being transmitted over non-tls?
SESSION_COOKIE_SAMESITE = "Lax"  # One of [None, 'None', 'Lax', 'Strict']

# CORS Options
ENABLE_CORS = True
CORS_OPTIONS: Dict[Any, Any] = {"supports_credentials": True}
SUPERSET_WEBSERVER_DOMAINS= None

# Flask-WTF flag for CSRF
WTF_CSRF_ENABLED = True
# CSRF token timeout, set to None for a token that never expires
WTF_CSRF_TIME_LIMIT = 60 * 60 * 24 * 7
# Add endpoints that need to be exempt from CSRF protection
WTF_CSRF_EXEMPT_LIST = ["superset.views.core.log", "superset.charts.api.data"]
```

#### 客户端会话

/superset-frontend/src/utils/parseCookie.tsx

```tsx
// 解析cookie字符串的字段值
type CookieMap = { [cookieId: string]: string };

export default function parseCookie(cookie = document.cookie): CookieMap {
  return Object.fromEntries(
    cookie
      .split('; ')
      .filter(x => x)
      .map(x => x.split('=')),
  );
}
```

/superset-frontend/src/setup/setupClients.tsx

从网页中提取csrf_token，创建客户端

```tsx
import { SupersetClient, logging } from '@superset-ui/core';
import parseCookie from 'src/utils/parseCookie';

export default function setupClient() {
  const csrfNode = document.querySelector<HTMLInputElement>('#csrf_token');
  const csrfToken = csrfNode?.value;

  // when using flask-jwt-extended csrf is set in cookies
  const cookieCSRFToken = parseCookie().csrf_access_token || '';

  SupersetClient.configure({
    protocol: ['http:', 'https:'].includes(window?.location?.protocol)
      ? (window?.location?.protocol as 'http:' | 'https:')
      : undefined,
    host: (window.location && window.location.host) || '',
    csrfToken: csrfToken || cookieCSRFToken,
  })
    .init()
    .catch(error => {
      logging.warn('Error initializing SupersetClient', error);
    });
}
```

### 首页 Index

首页指登陆后跳转页面 http://HOST:PORT/superset/welcome

* 首页接口  /superset/views/core.py
* 首页布局  /superset/templates/
* 首页React组件   /superset-frontend/src/views/
* 首页交互逻辑  /superset-frontend/src/views/CRUD/welcome/

#### 首页接口

* 缺省登陆视图  / ->   /superset/welcome      /superset/views/core.py

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
            "superset/crud_views.html",    #此模板文件定义了首页布局，并用js_bundle($entry)绑定了构建后的前端静态文件
            entry="crudViews",            #通过entry名称定位到构建后的前端静态文件
            bootstrap_data=json.dumps(    #此数据替换模板里的相应内容
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
              <span aria-hidden="true">×</span>
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

略

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

### 导航栏 Navbar

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

{% if documentation_url %}        {# 文档链接判断块 #}
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
    <i class="fa fa-question"></i> 
  {% endif %}
  </a>
</li>
{% endif %}

{% if bug_report_url %}        {# BUG报告判断块 #}
<li>
  <a
    tabindex="-1"
    href="{{ bug_report_url }}"
    target="_blank"
    title="Report a bug"
  >
    <i class="fa fa-bug"></i> 
  </a>
</li>
{% endif %}

{% if languages.keys()|length > 1 %}    {# 多语种支持判断块 #}
<li class="dropdown">
    <a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">
       <div class="f16"><i class="flag {{languages[locale].get('flag')}}"></i> <b class="caret"></b>
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
    <li class="dropdown">    {# 登陆用户显示块 #}
      <a
        class="dropdown-toggle"
        data-toggle="dropdown"
        title="{{g.user.get_full_name()}}"
        href="javascript:void(0)"
      >
        <i class="fa fa-user"></i> <b class="caret"></b>
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
{% else %}    {# 未登陆用户显示登陆链接 #}
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
  // ...

  // 入参为MenuProps, 返回HTML. id为main-menu
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

**前端的菜单数据示例**

下面菜单数据的结构 同服务器传过来的启动数据 data-bootstrap.menu。如果要修改静态菜单，可以参照成员结构修改。

```json
# 说明： 列表成员包括以下字段：label,name,url,icon,childs,index,isFrontendRoute. 其中label必需，其它可选。
var selfmenu =
    [{label: '总览', childs: undefined, url: hostname+'/main/overview', index: undefined, isFrontendRoute: true},
    {label: '数据源', childs: undefined, url: hostname+'/main/database', index: undefined, isFrontendRoute: true},
    {label: '数据集', childs: undefined, url: hostname+'/main/datatable', index: undefined, isFrontendRoute: true},
    {label: '数据探索', childs: undefined, url: hostname+'/main/explore', index: undefined, isFrontendRoute: true},
    {label: '数据可视化', childs: [{name: 'Chart', icon: 'fa-chart', label: '图表', url: '/chart/list/', isFrontendRoute: true},{name: 'Dashboard', icon: 'fa-dashboard', label: '看板', url: '/dashboard/list/', isFrontendRoute: true}], url: undefined, index: undefined, isFrontendRoute: false},]
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
              <Menu data={menu} />   <!-- 组件Menu和从后端传来的数据menu -->
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
        appbuilder.add_separator("Data")  # 可选，Data菜单下添加分隔符
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
        if not is_feature_enabled("ENABLE_REACT_CRUD_VIEWS"): # ENABLE_REACT_CRUD_VIEWS缺省打开特性，在FAB里实现视图。
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

### 列表页&图表列表页

列表页主要有4种，分别是database, dataset, chart 和dashboard。

下面以图表列表页作为示例。

#### 列表页服务端API

详见 《[superset二次开发](superset二次开发.md)》API章节 中列出的API。

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

* pageIndex    页码，缺省从0开始
* sortColumn 排序字段，缺省Changed_on
* sortOrder   排序方向，缺省desc降序
* viewMode   前端默认填充缺省值table

#### 列表页布局

服务端渲染：/chart/list/  返回HTML。调用 SupersetModelView.render_app_template()，同首页布局模板 superset/crud_views.html

客户端渲染：路由/chart/list/  ->  组件ChartList (/superset-frontend/src/views/chart/ChartList.tsx)

#### 列表页交互

* 排序Order、过滤Filter、分页Pagination：GET方法时用到
* 搜索：GET方法的filter参数的opr指向的过滤类

### 可视化图表 Viz

#### 服务端

客户端获取图表数据是通过 /superset/explore_json接口，需要从表单数据里获取数据源ID（即数据集ID）和图表类型，根据这二个参数构造相应的图表类型类`get_viz()`。

* /superset/viz.py 定义了可视化基类BaseViz及各个子类，可视化列表viz_types。
* /superset/viz_sip38.py  类似viz.py，只用在特性SIP_38_VIZ_REARCHITECTURE。v1.3已删，替换了viz.py。
* /superset/models/slice.py   图表模型
* /superset/superset_config.py  此处变量VIZ_TYPE_DENYLIST会被 viz_types用到
* /superset/views/utils.py  get_viz()会根据传参类型返回BaseViz的实际子类。

##### 图表类型类 viz.py

/superset/viz.py  可视化图表类型的基类BaseViz 和子类，典型图表类型过滤盒FilterBoxViz

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

   def get_df_payload(
        self, query_obj: Optional[QueryObjectDict] = None, **kwargs: Any
    ) -> Dict[str, Any]:
        """Handles caching around the df payload retrieval 通过查询对象获取查询结果 """
        if not query_obj:
            query_obj = self.query_obj()    #获取查询对象，结果为{}. 从请求表单数据获取生成
        cache_key = self.cache_key(query_obj, **kwargs) if query_obj else None    #将查询对象转化成一个MD5字符串
        cache_value = None
        logger.info("Cache key: {}".format(cache_key))
        is_loaded = False    #用来标识是否有查询结果数据
        stacktrace = None
        df = None
        if cache_key and cache_manager.data_cache and not self.force:    #不强制刷新情况下，从缓存里获取查询结果
            cache_value = cache_manager.data_cache.get(cache_key)
            if cache_value:
                stats_logger.incr("loading_from_cache")
                try:
                    df = cache_value["df"]
                    self.query = cache_value["query"]    #查询结果
                    self.status = utils.QueryStatus.SUCCESS
                    is_loaded = True
                    stats_logger.incr("loaded_from_cache")
                except Exception as ex:
                    logger.exception(ex)
                    logger.error(
                        "Error reading cache: " + utils.error_msg_from_exception(ex)
                    )
                logger.info("Serving from cache")

        if query_obj and not is_loaded:
            if self.force_cached:    # 强制从缓存取时报错
                logger.warning(
                    f"force_cached (viz.py): value not found for cache key {cache_key}"
                )
                raise CacheLoadError(_("Cached value not found"))
            try:
                invalid_columns = [
                    col
                    for col in (query_obj.get("columns") or [])
                    + (query_obj.get("groupby") or [])
                    + utils.get_column_names_from_metrics(
                        cast(
                            List[Union[str, Dict[str, Any]]], query_obj.get("metrics"),
                        )
                    )
                    if col not in self.datasource.column_names
                ]
                if invalid_columns:    #存在无效列，抛出异常
                    raise QueryObjectValidationError(
                        _(
                            "Columns missing in datasource: %(invalid_columns)s",
                            invalid_columns=invalid_columns,
                        )
                    )
                df = self.get_df(query_obj)    #获取查询结果的DF数据格式
                if self.status != utils.QueryStatus.FAILED:
                    stats_logger.incr("loaded_from_source")
                    if not self.force:
                        stats_logger.incr("loaded_from_source_without_force")
                    is_loaded = True
            except QueryObjectValidationError as ex:
                error = dataclasses.asdict(
                    SupersetError(
                        message=str(ex),
                        level=ErrorLevel.ERROR,
                        error_type=SupersetErrorType.VIZ_GET_DF_ERROR,
                    )
                )
                self.errors.append(error)
                self.status = utils.QueryStatus.FAILED
            except Exception as ex:
                logger.exception(ex)

                error = dataclasses.asdict(
                    SupersetError(
                        message=str(ex),
                        level=ErrorLevel.ERROR,
                        error_type=SupersetErrorType.VIZ_GET_DF_ERROR,
                    )
                )
                self.errors.append(error)
                self.status = utils.QueryStatus.FAILED
                stacktrace = utils.get_stacktrace()

            if is_loaded and cache_key and self.status != utils.QueryStatus.FAILED:
                set_and_log_cache(    # 缓存查询结果
                    cache_manager.data_cache,
                    cache_key,
                    {"df": df, "query": self.query},
                    self.cache_timeout,
                    self.datasource.uid,
                )
        return {
            "cache_key": cache_key,
            "cached_dttm": cache_value["dttm"] if cache_value is not None else None,
            "cache_timeout": self.cache_timeout,
            "df": df,    #查询结果的DF格式
            "errors": self.errors,
            "form_data": self.form_data,
            "is_cached": cache_value is not None,
            "query": self.query,
            "from_dttm": self.from_dttm,
            "to_dttm": self.to_dttm,
            "status": self.status,
            "stacktrace": stacktrace,
            "rowcount": len(df.index) if df is not None else 0,
        }

    def get_df(self, query_obj: Optional[QueryObjectDict] = None) -> pd.DataFrame:
       """将查询对象转化成 pd.DataFrame Returns a pandas dataframe based on the query object"""
        if not query_obj:
            query_obj = self.query_obj()
        if not query_obj:    # 无查询对象，直接返回空对象
            return pd.DataFrame()

        self.error_msg = ""

        timestamp_format = None
        if self.datasource.type == "table":
            granularity_col = self.datasource.get_column(query_obj["granularity"])
            if granularity_col:    # 获取时间粒度列，然后转化时间格式
                timestamp_format = granularity_col.python_date_format

        # The datasource here can be different backend but the interface is common
        self.results = self.datasource.query(query_obj)    # 从数据库里查询，获取查询结果
        self.query = self.results.query
        self.status = self.results.status
        self.errors = self.results.errors

        df = self.results.df    #将SQL查询结果转化成DF格式
        # Transform the timestamp we received from database to pandas supported
        # datetime format. If no python_date_format is specified, the pattern will
        # be considered as the default ISO date format
        # If the datetime format is unix, the parse will use the corresponding
        # parsing logic.
        if not df.empty:
            if DTTM_ALIAS in df.columns:    # 处理时间列
                if timestamp_format in ("epoch_s", "epoch_ms"):
                    # Column has already been formatted as a timestamp.
                    dttm_col = df[DTTM_ALIAS]
                    one_ts_val = dttm_col[0]

                    # convert time column to pandas Timestamp, but different
                    # ways to convert depending on string or int types
                    try:
                        int(one_ts_val)
                        is_integral = True
                    except (ValueError, TypeError):
                        is_integral = False
                    if is_integral:
                        unit = "s" if timestamp_format == "epoch_s" else "ms"
                        df[DTTM_ALIAS] = pd.to_datetime(
                            dttm_col, utc=False, unit=unit, origin="unix"
                        )
                    else:
                        df[DTTM_ALIAS] = dttm_col.apply(pd.Timestamp)
                else:
                    df[DTTM_ALIAS] = pd.to_datetime(
                        df[DTTM_ALIAS], utc=False, format=timestamp_format
                    )
                if self.datasource.offset:
                    df[DTTM_ALIAS] += timedelta(hours=self.datasource.offset)
                df[DTTM_ALIAS] += self.time_shift

            if self.enforce_numerical_metrics:
                self.df_metrics_to_num(df)

            df.replace([np.inf, -np.inf], np.nan, inplace=True)
        return df


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


viz_types = {    # 此处用到了配置参数里的一个约束
    o.viz_type: o
    for o in get_subclasses(BaseViz)
    if o.viz_type not in config["VIZ_TYPE_DENYLIST"]
}
```

**过滤盒实现 FilterBoxViz**

FilterBoxViz每个过滤条件都会生成一个df格式的查询结果，get_data需要将多个查询结果进行合并后输出最终结果。

```python
class BaseViz:

class FilterBoxViz(BaseViz):

    viz_type = "filter_box"
    verbose_name = _("Filters")
    is_timeseries = False
    credits = 'a <a href="https://github.com/airbnb/superset">Superset</a> original'
    cache_type = "get_data"
    filter_row_limit = 1000

    def query_obj(self) -> QueryObjectDict:
        return {}

    def run_extra_queries(self) -> None:
        """ 扩展查询：过滤条件、行限制。调用了基类方法query_obj, get_df_payload """
        qry = super().query_obj()
        filters = self.form_data.get("filter_configs") or []
        qry["row_limit"] = self.filter_row_limit
        self.dataframes = {}
        for flt in filters:    # 每个过滤条件会产生一条查询结果
            col = flt.get("column")
            if not col:
                raise QueryObjectValidationError(
                    _("Invalid filter configuration, please select a column")
                )
            qry["groupby"] = [col]
            metric = flt.get("metric")
            qry["metrics"] = [metric] if metric else []
            df = self.get_df_payload(query_obj=qry).get("df")      # 调用基类的获取查询结果
            self.dataframes[col] = df

    def get_data(self, df: pd.DataFrame) -> VizData:
        """ 合并多个查询条件的查询结果 """
        filters = self.form_data.get("filter_configs") or []
        d = {}
        for flt in filters:
            col = flt.get("column")        #普通列
            metric = flt.get("metric")    #指标列
            df = self.dataframes.get(col)
            if df is not None and not df.empty:
                if metric:    # 缺省按指标列排序
                    df = df.sort_values(
                        utils.get_metric_name(metric), ascending=flt.get("asc")
                    )
                    d[col] = [
                        {"id": row[0], "text": row[0], "metric": row[1]}
                        for row in df.itertuples(index=False)
                    ]
                else:
                    df = df.sort_values(col, ascending=flt.get("asc"))
                    d[col] = [
                        {"id": row[0], "text": row[0]}
                        for row in df.itertuples(index=False)
                    ]
            else:
                df[col] = []
        return d
```

##### 切片模型 /models/slice.py

/superset/models/slice.py  二张表定义，分别是slice_user和slices表

```python
from flask_appbuilder import Model
from superset.models.helpers import AuditMixinNullable, ImportExportMixin


# 根据特征标识，从不同文件加载图表类型类
if is_feature_enabled("SIP_38_VIZ_REARCHITECTURE"):
    from superset.viz_sip38 import BaseViz, viz_types
else:
    from superset.viz import BaseViz, viz_types  # type: ignore

if TYPE_CHECKING:
    from superset.connectors.base.models import BaseDatasource

metadata = Model.metadata  # pylint: disable=no-member
slice_user = Table(
    "slice_user",
    metadata,
    Column("id", Integer, primary_key=True),
    Column("user_id", Integer, ForeignKey("ab_user.id")),
    Column("slice_id", Integer, ForeignKey("slices.id")),
)
logger = logging.getLogger(__name__)


class Slice(
    Model, AuditMixinNullable, ImportExportMixin
):  # pylint: disable=too-many-public-methods
    __tablename__ = "slices"
    # 以下定义表字段
    id = Column(Integer, primary_key=True)
    slice_name = Column(String(250))
    datasource_id = Column(Integer)
    datasource_type = Column(String(200))
    datasource_name = Column(String(2000))
    viz_type = Column(String(250))
    params = Column(Text)
    description = Column(Text)
    cache_timeout = Column(Integer)
    perm = Column(String(1000))
    schema_perm = Column(String(1000))
    owners = relationship(security_manager.user_model, secondary=slice_user)
    table = relationship(
        "SqlaTable",
        foreign_keys=[datasource_id],
        primaryjoin="and_(Slice.datasource_id == SqlaTable.id, "
        "Slice.datasource_type == 'table')",
        remote_side="SqlaTable.id",
        lazy="subquery",
    )
    token = ""

    export_fields = [
        "slice_name",
        "datasource_type",
        "datasource_name",
        "viz_type",
        "params",
        "cache_timeout",
    ]
    export_parent = "table"

    @property  # type: ignore
    @utils.memoized
    def viz(self) -> Optional[BaseViz]:
        form_data = json.loads(self.params)
        viz_class = viz_types.get(self.viz_type)
        if viz_class:
            return viz_class(datasource=self.datasource, form_data=form_data)
        return None

    @property
    def data(self) -> Dict[str, Any]:
```

/supetset/superset_config.py

```python
# 设置不处理的图表类型，这里只是后端不处理报错；前端仍然会显示此图表
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

#### 客户端交互

详见下文 《前端-可视化》章节。

/superset-frontend/src/visualizations/

### 下钻及交叉过滤

#### 下钻 drilldown

尚未实现

#### 看板交叉过滤 x-filter

1. 服务端
   
   服务端只是打开了过滤标识DASHBOARD_CROSS_FILTERS，并将此标识作为启动数据传给了客户端。客户端触发交叉过滤时，只是在页面上向其它图表发送请求，可以复用原有图表接口请求。

superset_config.py

打开特性标识开头 DASHBOARD_CROSS_FILTERS

```python
FEATURE_FLAGS = {
    "DASHBOARD_CROSS_FILTERS" : True
}
```

2. UI

支持交叉过滤的图表有一个选项 `▢ EMIT DASHBOARD CROSS FILTERS`,  选中才会在看板里触发交叉过滤。此选项的布尔值保存在 slices表里的params字段JSON值里的emit_filter。params格式示例如下，

```json
{
  "adhoc_filters": [],
  "all_columns": [],
  "color_pn": true,
  "conditional_formatting": [],
  "datasource": "2__table",
  "emit_filter": true,   #是否发起交叉过滤
  "extra_form_data": {},
  "granularity_sqla": "year",
  "groupby": [
    "country_name",
    "region"
  ],
  "include_search": false,
  "metrics": [
    "sum__SP_POP_TOTL"
  ],
  "order_by_cols": [],
  "order_desc": true,
  "percent_metrics": [],
  "query_mode": "aggregate",
  "row_limit": 50000,
  "server_page_length": 10,
  "show_cell_bars": true,
  "slice_id": 88,
  "table_timestamp_format": "smart_date",
  "time_grain_sqla": "P1D",
  "time_range": "2014-01-01 : 2014-01-02",
  "time_range_endpoints": [
    "inclusive",
    "exclusive"
  ],
  "url_params": {},
  "viz_type": "table"
}
```

前端实现 /src/dashboard/components/SliceHeaderControls/index.tsx

```tsx
// 图表控制数据
export interface SliceHeaderControlsProps {
  slice: {
    description: string;
    viz_type: string;
    slice_name: string;
    slice_id: number;
    slice_description: string;
    form_data?: { emit_filter?: boolean };
  };
```

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
# click.group装饰器会生成脚本组(组名是函数名即superset)，触发函数create_app, 并且将方法名作归一化处理normalize_token,
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
  update-api-docs           Regenerate the openapi.json file in docs  #重新生成 openai.json文件
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

/superset/cli.py  superset具体命令定义和实现

```python
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

#### 配置文件 config.py

**配置文件的优先级**:  superset_config.py >  config.py

1. superset_config.py 用环境变量SUPERSET_CONFIG_PATH定义，在config.py文件尾会重载这个文件。

需要定义了环境变量才会启用。

**推荐所有需要个性化定制的变量都放到 superset_config.py进行修改，统一管理。**

```python
# superset/config.py
CONFIG_PATH_ENV_VAR = "SUPERSET_CONFIG_PATH"
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
        self.pre_init()        #初始化前，创建DATA_DIR
        self.setup_db()        # APP和数据库绑定
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

#### 扩展 extensions.py

```python
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
    def __init__(self) -> None:
        self._results_backend = None
        self._use_msgpack = False

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


APP_DIR = os.path.dirname(__file__)
appbuilder = AppBuilder(update_perms=False)
async_query_manager = AsyncQueryManager()
cache_manager = CacheManager()
celery_app = celery.Celery()
csrf = CSRFProtect()
db = SQLA()
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

### 视图逻辑 /views/

Views可分为二大类

* CBV，类实现视图，通常与数据库CRUD密切相关的 ModelView.
* FBV，函数实现视图，通常不涉及到数据库操作。

superset视图可以分为3类，菜单视图，普通视图(不生成菜单的视图，只添加链接)，资源视图（主要数据库，数据表相关）。

前2类视图是flaskappbuilder控制生成的，后一种视图是sqlalchemy控制生成的。

* base.py  2个视图基类SupersetModelView和BaseSupersetView
* core.py  普通视图，Superset类里实现 /superset开头的路由。
* /xx/view.py  资源视图
* base_api.py API基类

#### 视图基类  base.py

/superset/views/base.py

定义了superset视图基类 SupersetModelView和BaseSupersetView。

* 2视图的模板指向 superset/crud_views.html, 入口名为crudViews。
* 2视图的路由前缀不一样：SupersetModelView派生类通常定义了自己的route_base；BaseSupersetView派生类路由前缀缺省是类名小写，如/superset。
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

此文件的路由都是 /superset/开头，共有63个API。继承自BaseView的route_base是类名称。

* 类关系:   Superset -> BaseSupersetView  -> BaseView(object)（来自flask_appbuilder）

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

依赖类：

```python
# /superset/views/base.py
class BaseSupersetView(BaseView):


# /flask_appbuilder/baseview.py
class BaseView(object):

    route_base = None

    def create_blueprint(self, appbuilder, endpoint=None, static_folder=None):
        ...
        if self.route_base is None:    # 继承自BaseView的route_base是/类名称。
            self.route_base = "/" + self.__class__.__name__.lower()
```

#### ModelView逻辑 xx/views.py

**ModelView层次体系**：

*flask_appbuilders模块*：BaseView(object)  -> BaseModelView -> BaseCRUDView-> RestCRUDView -> ModelView

*superset模块*：                     -> SupersetModelView  (/superset/views/base.py)

​                                                        -> DashboardModelView  (/superset/views/dashboard/views.py)

​                                                        -> SliceModelView /superset/views/chart/views.py)

​                                                        -> DatabaseView/superset/views/database/views.py)

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
    route_base = "/chart"    # 路由路径前缀
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

* commands/  元数据CRUD操作命令，包括create/update/delete。
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

*superset模块*：                     -> BaseSupersetModelRestApi (/superset/views/base_api.py)

​                                                        -> ChartRestApi (/superset/charts/api.py)

​                                                        -> DashboardRestApi (/superset/dashboards/api.py)

说明：RestApi类有一个关键属性resource_name。本处路由前缀是`{route_base}` or  `/api/{version}/{resource_name}/`

charts API列表

| route                            | method | 实现模块                                 | 实现过程                                                                         |
| -------------------------------- | ------ | ------------------------------------ | ---------------------------------------------------------------------------- |
| /chart/                          | GET    | flask_appbuilder py:BaseApi:get_list | 查询参数q -> rison转化,  <br>依次处理filter, order, pagination, query, <br>-> response |
|                                  | POST   |                                      |                                                                              |
|                                  | DELETE |                                      |                                                                              |
| /chart/_info                     | GET    |                                      |                                                                              |
| /chart/data                      | POST   |                                      |                                                                              |
| /chart/data/{cache_key}          | GET    | flask_appbuilder                     |                                                                              |
| /chart/export/                   | GET    |                                      |                                                                              |
| /chart/favorite_status/          | GET    |                                      |                                                                              |
| /chart/import/                   | POST   |                                      |                                                                              |
| /chart/related/{column_name}     | GET    | flask_appbuilder                     |                                                                              |
| /chart/{pk}                      | GET    |                                      |                                                                              |
|                                  | POST   |                                      |                                                                              |
|                                  | DELETE |                                      |                                                                              |
| /chart/{pk}/cache_screenshot/    | GET    |                                      |                                                                              |
| /chart/{pk}/screenshot/{digest}/ | GET    |                                      |                                                                              |
| /chart/{pk}/thumbnail/{digest}/  | GET    |                                      |                                                                              |

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
    class_permission_name = "Chart"    # 类权限名
    method_permission_name = MODEL_API_RW_METHOD_PERMISSION_MAP    #方法权限名，定义在constants.py
    show_columns = [...]    #图表页时的展示字段
    show_select_columns = show_columns + ["table.id"]
    list_columns = [...]   #图表列表页时的展示字段
    list_select_columns = list_columns + ["changed_by_fk", "changed_on"]
    order_columns = [...]  #排序字段
    search_columns = [...] #搜索字段
    base_order = ("changed_on", "desc")
    base_filters = [["id", ChartFilter, lambda: []]]
    search_filters = {    # 搜索过滤器，此处注册了才会加载，否则只会跳转到flask_appbuilder的13个过滤器里
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

    order_rel_fields = {    # 排序字段的缺省规则
        "slices": ("slice_name", "asc"),
        "owners": ("first_name", "asc"),
    }

    related_field_filters = {    # 相关项字段的缺省过滤规则
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

map_args_filter = {}    # 全局数据

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
        if self.arg_name:    # 填充map_args_filter
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
    search_filters = {    # 搜索过滤器，此处注册了才会加载，否则只会跳转到flask_appbuilder的13个过滤器里
        "id": [ChartFavoriteFilter],
        "slice_name": [ChartAllTextFilter],
    }
```

### 数据源

#### 连接器 /connectors/

* connector_registry.py  ConnectorRegistry类实现连接器注册，保存到一个字典sources里。
* /base 普通数据源的基类
  * /base/models.py  数据源BaseDatasource、列BaseColumn、指标BaseMetric的基类。都有继承二个工具类AuditMixinNullable, ImportExportMixin。
  * /base/views.py   二个视图类分别是DatasourceModelView和BS3TextFieldROWidget。
* /druid/   druid数据源实现。目录下二个文件分别是models.py和views.py ，
* /sqla/  supreset数据源实现，有继承常规数据源基类。目录下3个文件分别是utils.py, models.py和views.py

/superset/connectors/connector_registry.py

```python
from sqlalchemy import or_
from sqlalchemy.orm import Session, subqueryload
from sqlalchemy.orm.exc import NoResultFound

if TYPE_CHECKING:
    from collections import OrderedDict

    from superset.connectors.base.models import BaseDatasource
    from superset.models.core import Database


class ConnectorRegistry:
    """ Central Registry for all available datasource engines"""

    sources: Dict[str, Type["BaseDatasource"]] = {}   # 存储所有数据源

    @classmethod
    def register_sources(cls, datasource_config: "OrderedDict[str, List[str]]") -> None:
```

/superset/connectors/base/models.py

```python
from flask_appbuilder.security.sqla.models import User
from sqlalchemy import and_, Boolean, Column, Integer, String, Text
from sqlalchemy.ext.declarative import declared_attr
from sqlalchemy.orm import foreign, Query, relationship, RelationshipProperty, Session


class DatasourceKind(str, Enum):
    VIRTUAL = "virtual"
    PHYSICAL = "physical"


class BaseDatasource(
    AuditMixinNullable, ImportExportMixin
):  # pylint: disable=too-many-public-methods
    """A common interface to objects that are queryable
    (tables and datasources)"""
    __tablename__: Optional[str] = None  # {connector_name}_datasource
    baselink: Optional[str] = None  # url portion pointing to ModelView endpoint

    @property
    def column_class(self) -> Type["BaseColumn"]:
        # link to derivative of BaseColumn
        raise NotImplementedError()

    @property
    def metric_class(self) -> Type["BaseMetric"]:
        # link to derivative of BaseMetric
        raise NotImplementedError()

    owner_class: Optional[User] = None

    # Used to do code highlighting when displaying the query in the UI
    query_language: Optional[str] = None

    # Only some datasources support Row Level Security
    is_rls_supported: bool = False

    @property
    def name(self) -> str:
        # can be a Column or a property pointing to one
        raise NotImplementedError()


class BaseColumn(AuditMixinNullable, ImportExportMixin):


class BaseMetric(AuditMixinNullable, ImportExportMixin):
```

/superset/connectors//base/views.py

```python
from superset.views.base import SupersetModelView

class DatasourceModelView(SupersetModelView):
    """ 删除之前，先判断是否有图表关联 """
    def pre_delete(self, item: BaseDatasource) -> None:
        if item.slices:
            raise SupersetException(
                Markup(
                    "Cannot delete a datasource that has slices attached to it."
                    "Here's the list of associated charts: "
                    + "".join([i.slice_name for i in item.slices])
                )
            )
```

#### DB引擎  /db_engine_specs/

/db_engines/  目录只有hive.py 此目录基本不用。

/db_engine_specs包括了各种数据库引擎的实现。新增数据源需要在此目录下添加文件。

* base.py  定义引擎和引擎参数基类
* exceptions.py  异常

表格  各种数据库引擎的实现方式列表

| 文件名              | 厂商        | DB引擎名称                                                                    | engine     | default_driver | 加入版本及时间            |
| ---------------- | --------- | ------------------------------------------------------------------------- | ---------- | -------------- | ------------------ |
| ascend.py        |           | ascend                                                                    |            |                | v1.3.0 2021-08-13  |
| athena.py        | Amazon    | [Amazon Athena](https://superset.apache.org/docs/databases/athena)        |            |                | 0.17               |
| bigquery.py      | Google    | bigquery                                                                  |            |                | 0.19.0 (2018-8-2)  |
| clickhouse.py    |           | clickhouse                                                                |            |                | 0.18.0             |
| cockroachdb.py   |           | cockroachdb                                                               |            |                | 0.36.0             |
| crate.py         |           | crate                                                                     |            |                | 1.2.0 (2021-06-04) |
| databricks.py    |           | databricks                                                                |            |                | 1.2.0 (2021-06-04) |
| db2.py           | IBM       | db2                                                                       |            |                | 0.17.4             |
| dremio.py        |           | dremio                                                                    |            |                | 0.36.0             |
| drill.py         | Apache    | Apache drill                                                              |            |                | 0.34.0             |
| druid.py         | Apache    | [Apache Druid](https://superset.apache.org/docs/databases/druid)          |            |                | 0.4.0              |
| elasticsearch.py |           | elasticsearch                                                             |            |                | 0.37.0             |
| exasol.py        |           | exasol                                                                    |            |                | 0.35.0             |
| firebird.py      |           | firebird                                                                  |            |                | 1.2.0              |
| gsheets.py       | Google    | [Google Sheets](https://superset.apache.org/docs/databases/google-sheets) |            |                | 0.29.0             |
| hana.py          | SAP       | [SAP Hana](https://superset.apache.org/docs/databases/hana)               |            |                | 1.1                |
| hive.py          | Apache    | Apache hive                                                               |            |                | 0.17.1             |
| impala.py        | Apache    | Apache impala                                                             |            |                | 0.19.1             |
| kylin.py         | Apache    | Apache kylin                                                              |            |                | 0.23.0             |
| mssql.py         | Microsoft | Microsoft SQL Server                                                      | mssql      |                | 0.11.0             |
| mysql.py         | Apache    | [Apache MySQL](https://superset.apache.org/docs/databases/mysql)          | mysql      | mysqldb        | 0.5.3              |
| netezza.py       |           | netezza                                                                   |            |                | 1.3.1              |
| oracle.py        | Oracle    | [Oracle](https://superset.apache.org/docs/databases/oracle)               | oracle     |                | 0.13.0             |
| pinot.py         | Apache    | Apache pinot                                                              |            |                | 0.31               |
| postgres.py      | Apache    | [PostgreSQL](https://superset.apache.org/docs/databases/postgresql)       | postgresql | psycopg2       | 0.8.6              |
| presto.py        |           | presto                                                                    |            |                | 0.32               |
| redshift.py      | Amazon    | Amazon redshift                                                           |            |                | 0.8.6              |
| rockset.py       |           | rockset                                                                   |            |                | 1.2.0              |
| shillelagh.py    | Apache    | shillelagh                                                                |            |                | 1.3.0              |
| snowflake.py     |           | snowflake                                                                 |            |                | 1.3.1              |
| solr.py          | Apache    | Apache solr                                                               |            |                | 1.0.0              |
| sqlite.py        |           | sqlite                                                                    |            |                | 缺省                 |
| teradata.py      | Teradata  | teradata                                                                  |            |                | 0.28.0             |
| trino.py         |           | trino                                                                     |            |                | 1.1                |
| vertica.py       |           | vertica                                                                   |            |                | 0.9.1              |

备注：v0.24.0在2018-03-27，v1.0.0在2021-01-15，v1.3.0在2021-08-13。

##### 引擎基类 base.py

/superset/db_engine_specs/base.py

BaseEngineSpec类定义 了DB引擎的元数据，BasicParametersType定义了sqlalchemy_uri连接串的各个连接要素。

BasicParametersMixin工具类定义了sqlalchemy_uri模板及读写的类方法。

```python
if TYPE_CHECKING:
    # prevent circular imports
    from superset.connectors.sqla.models import TableColumn
    from superset.models.core import Database


class TimeGrain(NamedTuple):  # pylint: disable=too-few-public-methods
    """ 时间粒度名称 """
    name: str  # TODO: redundant field, remove
    label: str
    function: str
    duration: Optional[str]


class BaseEngineSpec:  # pylint: disable=too-many-public-methods
    """Abstract class for database engine specific configurations

    Attributes:
        allows_alias_to_source_column: Whether the engine is able to pick the
                                       source column for aggregation clauses
                                       used in ORDER BY when a column in SELECT
                                       has an alias that is the same as a source
                                       column.
        allows_hidden_orderby_agg:     Whether the engine allows ORDER BY to
                                       directly use aggregation clauses, without
                                       having to add the same aggregation in SELECT.
    """

    engine = "base"  # str as defined in sqlalchemy.engine.engine
    engine_aliases: Set[str] = set()
    engine_name: Optional[
        str
    ] = None  # used for user messages, overridden in child classes
    _date_trunc_functions: Dict[str, str] = {}
    _time_grain_expressions: Dict[Optional[str], str] = {}

    ...


# schema for adding a database by providing parameters instead of the
# full SQLAlchemy URI
class BasicParametersSchema(Schema):
    username = fields.String(required=True, allow_none=True, description=__("Username"))
    password = fields.String(allow_none=True, description=__("Password"))
    host = fields.String(required=True, description=__("Hostname or IP address"))
    port = fields.Integer(
        required=True,
        description=__("Database port"),
        validate=Range(min=0, max=2 ** 16, max_inclusive=False),
    )
    database = fields.String(required=True, description=__("Database name"))
    query = fields.Dict(
        keys=fields.Str(), values=fields.Raw(), description=__("Additional parameters")
    )
    encryption = fields.Boolean(
        required=False, description=__("Use an encrypted connection to the database")
    )


class BasicParametersType(TypedDict, total=False):
    """ 类似BasicParametersSchema的结构 """
    username: Optional[str]
    password: Optional[str]
    host: str
    port: int
    database: str
    query: Dict[str, Any]
    encryption: bool


class BasicParametersMixin:
   """
    DB参数工具类，负责sqlalchemy_uri的构建，参数解析和验证
    Mixin for configuring DB engine specs via a dictionary.

    With this mixin the SQLAlchemy engine can be configured through
    individual parameters, instead of the full SQLAlchemy URI. This
    mixin is for the most common pattern of URI:

        engine+driver://user:password@host:port/dbname[?key=value&key=value...]

    """
    # schema describing the parameters used to configure the DB
    parameters_schema = BasicParametersSchema()
    # recommended driver name for the DB engine spec
    default_driver = ""

    # placeholder with the SQLAlchemy URI template
    # sqlalchemy_uri模板，?来自自于query参数
    sqlalchemy_uri_placeholder = (
        "engine+driver://user:password@host:port/dbname[?key=value&key=value...]"
    )

    # query parameter to enable encryption in the database connection
    # for Postgres this would be `{"sslmode": "verify-ca"}`, eg.
    encryption_parameters: Dict[str, str] = {}

    @classmethod
    def build_sqlalchemy_uri(
        cls,
        parameters: BasicParametersType,
        encryted_extra: Optional[Dict[str, str]] = None,
    ) -> str:
        # make a copy so that we don't update the original
        query = parameters.get("query", {}).copy()
        if parameters.get("encryption"):
            if not cls.encryption_parameters:
                raise Exception("Unable to build a URL with encryption enabled")
            query.update(cls.encryption_parameters)

        return str(
            URL(
                f"{cls.engine}+{cls.default_driver}".rstrip("+"),  # 如果driver无值，则移除尾部符号+
                username=parameters.get("username"),
                password=parameters.get("password"),
                host=parameters["host"],
                port=parameters["port"],
                database=parameters["database"],
                query=query,
            )
        )

    @classmethod
    def get_parameters_from_uri(
        cls, uri: str, encrypted_extra: Optional[Dict[str, Any]] = None
    ) -> BasicParametersType:

    @classmethod
    def validate_parameters(
        cls, parameters: BasicParametersType
    ) -> List[SupersetError]:

    @classmethod
    def parameters_json_schema(cls) -> Any:
```

##### mysql.py

```python
from sqlalchemy.dialects.mysql import (
    BIT,
    DECIMAL,
    DOUBLE,
    FLOAT,
    INTEGER,
    LONGTEXT,
    MEDIUMINT,
    MEDIUMTEXT,
    TINYINT,
    TINYTEXT,
)


class MySQLEngineSpec(BaseEngineSpec, BasicParametersMixin):
    engine = "mysql"
    engine_name = "MySQL"
    max_column_name_length = 64

    default_driver = "mysqldb"
    sqlalchemy_uri_placeholder = (
        "mysql://user:password@host:port/dbname[?key=value&key=value...]"
    )
    encryption_parameters = {"ssl": "1"}
```

##### postgres.py

```python
from sqlalchemy.dialects.postgresql import ARRAY, DOUBLE_PRECISION, ENUM, JSON
from sqlalchemy.dialects.postgresql.base import PGInspector
from sqlalchemy.types import String, TypeEngine

from superset.db_engine_specs.base import BaseEngineSpec, BasicParametersMixin


class PostgresBaseEngineSpec(BaseEngineSpec):
    """ Abstract class for Postgres 'like' databases """
    # 基类
    engine = ""
    engine_name = "PostgreSQL"

    _time_grain_expressions = {
        None: "{col}",
        "PT1S": "DATE_TRUNC('second', {col})",
        "PT1M": "DATE_TRUNC('minute', {col})",
        "PT1H": "DATE_TRUNC('hour', {col})",
        "P1D": "DATE_TRUNC('day', {col})",
        "P1W": "DATE_TRUNC('week', {col})",
        "P1M": "DATE_TRUNC('month', {col})",
        "P0.25Y": "DATE_TRUNC('quarter', {col})",
        "P1Y":
        "DATE_TRUNC('year', {col})",
    }


class PostgresEngineSpec(PostgresBaseEngineSpec, BasicParametersMixin):
    engine = "postgresql"
    engine_aliases = {"postgres"}

    default_driver = "psycopg2"
    sqlalchemy_uri_placeholder = (
        "postgresql://user:password@host:port/dbname[?key=value&key=value...]"
    )
    # https://www.postgresql.org/docs/9.1/libpq-ssl.html#LIBQ-SSL-CERTIFICATES
    encryption_parameters = {"sslmode": "require"}

    max_column_name_length = 63
    try_remove_schema_from_table_name = False
```

#### 元数据操作 /dao/和/models/

依赖sqlalchemy模块。RestAPI逻辑里涉及到的元数据库操作，主要在 /xxx/dao.py

* /superset/dao/base.py   基类BaseDAO
* /superset/dao/exceptions.py   定义异常类DAOException DAOCreateFailedError DAOUpdateFailedError DAODeleteFailedError DAOConfigError
* /superset/models/xx.py  数据库模型定义和操作

/superset/dao/base.py

基类BaseDAO。定义了常规的DAO查询类静态方法@classmethod，CRUD。

```python
from typing import Any, Dict, List, Optional, Type

from flask_appbuilder.models.filters import BaseFilter
from flask_appbuilder.models.sqla import Model
from flask_appbuilder.models.sqla.interface import SQLAInterface
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import Session

from superset.dao.exceptions import (
    DAOConfigError,
    DAOCreateFailedError,
    DAODeleteFailedError,
    DAOUpdateFailedError,
)
from superset.extensions import db


class BaseDAO:
    """
    Base DAO, implement base CRUD sqlalchemy operations
    """

    model_cls: Optional[Type[Model]] = None
    base_filter: Optional[BaseFilter] = None

    @classmethod
    def find_by_id(cls, model_id: int, session: Session = None) -> Model:

    @classmethod
    def find_by_ids(cls, model_ids: List[int]) -> List[Model]:

    @classmethod
    def find_all(cls) -> List[Model]:

    @classmethod
    def create(cls, properties: Dict[str, Any], commit: bool = True) -> Model:

    @classmethod
    def update(
        cls, model: Model, properties: Dict[str, Any], commit: bool = True
    ) -> Model:

    @classmethod
    def delete(cls, model: Model, commit: bool = True) -> Model:
```

/sueprset/models/core.py

```python
import sqlalchemy as sqla
import sqlparse
from flask import g, request
from flask_appbuilder import Model
from sqlalchemy import (
    Boolean,
    Column,
    create_engine,
    DateTime,
    ForeignKey,
    Integer,
    MetaData,
    String,
    Table,
    Text,
)
from sqlalchemy.engine import Dialect, Engine, url
from sqlalchemy.engine.reflection import Inspector
from sqlalchemy.engine.url import make_url, URL
from sqlalchemy.exc import ArgumentError
from sqlalchemy.ext.hybrid import hybrid_property
from sqlalchemy.orm import relationship
from sqlalchemy.pool import NullPool
from sqlalchemy.schema import UniqueConstraint
from sqlalchemy.sql import expression, Select
from sqlalchemy_utils import EncryptedType


class Database(
    Model, AuditMixinNullable, ImportExportMixin
):  # pylint: disable=too-many-public-methods
    """An ORM object that stores Database related information
    数据库操作
    """

    __tablename__ = "dbs"
    type = "table"
    __table_args__ = (UniqueConstraint("database_name"),)

    id = Column(Integer, primary_key=True)
    verbose_name = Column(String(250), unique=True)
    # short unique name, used in permissions
    database_name = Column(String(250), unique=True, nullable=False)
    sqlalchemy_uri = Column(String(1024), nullable=False)
    password = Column(EncryptedType(String(1024), config["SECRET_KEY"]))
    cache_timeout = Column(Integer)
    select_as_create_table_as = Column(Boolean, default=False)
    expose_in_sqllab = Column(Boolean, default=True)
    allow_run_async = Column(Boolean, default=False)
    allow_csv_upload = Column(Boolean, default=False)
    allow_ctas = Column(Boolean, default=False)
    allow_cvas = Column(Boolean, default=False)
    allow_dml = Column(Boolean, default=False)
    force_ctas_schema = Column(String(250))
    allow_multi_schema_metadata_fetch = Column(  # pylint: disable=invalid-name
        Boolean, default=False
    )
    extra = Column(
        Text,
        default=textwrap.dedent(
            """\
    {
        "metadata_params": {},
        "engine_params": {},
        "metadata_cache_timeout": {},
        "schemas_allowed_for_csv_upload": []
    }
    """
        ),
    )
    encrypted_extra = Column(EncryptedType(Text, config["SECRET_KEY"]), nullable=True)
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

    def __repr__(self) -> str:
        return self.name

    @property
    def name(self) -> str:
        """ 获取数据库名称，优先从versose_name。默认verbose_name为空。"""
        return self.verbose_name if self.verbose_name else self.database_name

    @property
    def allows_subquery(self) -> bool:
        return self.db_engine_spec.allows_subqueries

    @property
    def function_names(self) -> List[str]:
        try:
            return self.db_engine_spec.get_function_names(self)
        except Exception as ex:  # pylint: disable=broad-except
            # function_names property is used in bulk APIs and should not hard crash
            # more info in: https://github.com/apache/superset/issues/9678
            logger.error(
                "Failed to fetch database function names with error: %s", str(ex)
            )
        return []

    @property
    def allows_cost_estimate(self) -> bool:
        extra = self.get_extra() or {}
        cost_estimate_enabled: bool = extra.get("cost_estimate_enabled")  # type: ignore

        return (
            self.db_engine_spec.get_allow_cost_estimate(extra) and cost_estimate_enabled
        )

    @property
    def allows_virtual_table_explore(self) -> bool:
        extra = self.get_extra()

        return bool(extra.get("allows_virtual_table_explore", True))

    @property
    def explore_database_id(self) -> int:
        return self.get_extra().get("explore_database_id", self.id)

    @property
    def data(self) -> Dict[str, Any]:
        return {
            "id": self.id,
            "name": self.database_name,
            "backend": self.backend,
            "allow_multi_schema_metadata_fetch": self.allow_multi_schema_metadata_fetch,
            "allows_subquery": self.allows_subquery,
            "allows_cost_estimate": self.allows_cost_estimate,
            "allows_virtual_table_explore": self.allows_virtual_table_explore,
            "explore_database_id": self.explore_database_id,
        }

    @property
    def unique_name(self) -> str:
        return self.database_name

    @property
    def url_object(self) -> URL:
        return make_url(self.sqlalchemy_uri_decrypted)

    @property
    def backend(self) -> str:
        sqlalchemy_url = make_url(self.sqlalchemy_uri_decrypted)
        return sqlalchemy_url.get_backend_name()  # pylint: disable=no-member

    @property
    def metadata_cache_timeout(self) -> Dict[str, Any]:
        return self.get_extra().get("metadata_cache_timeout", {})

    @property
    def schema_cache_enabled(self) -> bool:
        return "schema_cache_timeout" in self.metadata_cache_timeout

    @property
    def schema_cache_timeout(self) -> Optional[int]:
        return self.metadata_cache_timeout.get("schema_cache_timeout")

    @property
    def table_cache_enabled(self) -> bool:
        return "table_cache_timeout" in self.metadata_cache_timeout

    @property
    def table_cache_timeout(self) -> Optional[int]:
        return self.metadata_cache_timeout.get("table_cache_timeout")

    @property
    def default_schemas(self) -> List[str]:
        return self.get_extra().get("default_schemas", [])

    @property
    def connect_args(self) -> Dict[str, Any]:
        return self.get_extra().get("engine_params", {}).get("connect_args", {})

    @classmethod
    def get_password_masked_url_from_uri(  # pylint: disable=invalid-name
        cls, uri: str
    ) -> URL:
        sqlalchemy_url = make_url(uri)
        return cls.get_password_masked_url(sqlalchemy_url)

    @classmethod
    def get_password_masked_url(cls, masked_url: URL) -> URL:
        url_copy = deepcopy(masked_url)
        if url_copy.password is not None:
            url_copy.password = PASSWORD_MASK
        return url_copy

    def set_sqlalchemy_uri(self, uri: str) -> None:
        conn = sqla.engine.url.make_url(uri.strip())
        if conn.password != PASSWORD_MASK and not custom_password_store:
            # do not over-write the password with the password mask
            self.password = conn.password
        conn.password = PASSWORD_MASK if conn.password else None
        self.sqlalchemy_uri = str(conn)  # hides the password

    def get_effective_user(
        self, object_url: URL, user_name: Optional[str] = None,
    ) -> Optional[str]:
        """
        Get the effective user, especially during impersonation.
        :param object_url: SQL Alchemy URL object
        :param user_name: Default username
        :return: The effective username
        """
        effective_username = None
        if self.impersonate_user:
            effective_username = object_url.username
            if user_name:
                effective_username = user_name
            elif (
                hasattr(g, "user")
                and hasattr(g.user, "username")
                and g.user.username is not None
            ):
                effective_username = g.user.username
        return effective_username

    @utils.memoized(watch=("impersonate_user", "sqlalchemy_uri_decrypted", "extra"))
    def get_sqla_engine(
        self,
        schema: Optional[str] = None,
        nullpool: bool = True,
        user_name: Optional[str] = None,
        source: Optional[utils.QuerySource] = None,
    ) -> Engine:
```

说明：数据库名称优化从verbose_name中获取，因此

### 数据查询

#### 原始数据查询

数据的查询和展示是superset的核心功能，前端用D3.js来渲染各种图标，后端用pandas来处理各种数据。

* /superset/views/core.py  查询接口  /superset/explore_json/

**superset数据查询过程**：

1.将前端的配置信息form_data传给explore_json函数  /superset/views/core.py
2.根据所选的图表类型，找到对应的图表类    /superset/viz.py
3.根据过滤条件生成sql查询语句    /superset/charts/filters.py
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

#### 异步查询

celery使用

#### 缓存

强制刷新字段 force=true|false

缓存：依赖模块flask_caching

### 安全权限管理

安全权限大致可分为四类：

* 基本权限：依赖于flask_appbuilder的安全管理，属于用户认证权限。
  * /flask_appbuilder/security/   fab安全管理实现，包括用户登陆认证和JWT认证。详见《[flask_appbuilder源码剖析.md](./flask_appbuilder源码剖析.md)》
  * /superset/security/   superset安全管理
  * /superset/app.py  在这里可导入配置文件里配置变量CUSTOM_SECURITY_MANAGER 定义的管理类
* 菜单权限：依赖于flask_appbuilder的菜单管理
  * /flask_appbuilder/menu.py  fab的菜单对象
  * /superset/app.py    superset添加菜单视图add_view 和菜单链接add_link
* 资源权限：单个数据库管理， /superset/migrations/
* API访问权限：superset某个API访问实现  /superset/xxx/api.py

#### 用户认证

##### superset安全管理  /superset/security/

用户认证支持主流认证方式，如DB认证，Oauth，LDAP和openAPI等。fab的用户认证实现 详见《[flask_appbuilder源码剖析.md](./flask_appbuilder源码剖析.md)》

/superset/app.py

配置文件里可用变量CUSTOM_SECURITY_MANAGER 配置安全管理类

```python
class SupersetAppInitializer:
    def init_app_in_ctx(self) -> None:
        """
        Runs init logic in the context of the app
        """
        self.configure_feature_flags()
        self.configure_fab()    #配置fab
        self.configure_url_map_converters()
        self.configure_data_sources()
        self.configure_auth_provider()
        self.configure_async_queries()

        # Hook that provides administrators a handle on the Flask APP
        # after initialization
        flask_app_mutator = self.config["FLASK_APP_MUTATOR"]
        if flask_app_mutator:
            flask_app_mutator(self.flask_app)

        self.init_views()

    def configure_fab(self) -> None:
        """ 配置安全管理类，缺省是SupersetSecurityManager """
        if self.config["SILENCE_FAB"]:
            logging.getLogger("flask_appbuilder").setLevel(logging.ERROR)

        custom_sm = self.config["CUSTOM_SECURITY_MANAGER"] or SupersetSecurityManager
        if not issubclass(custom_sm, SupersetSecurityManager):
            raise Exception(
                """Your CUSTOM_SECURITY_MANAGER must now extend SupersetSecurityManager,
                 not FAB's security manager.
                 See [4565] in UPDATING.md"""
            )

        appbuilder.indexview = SupersetIndexView
        appbuilder.base_template = "superset/base.html"
        appbuilder.security_manager_class = custom_sm
        appbuilder.init_app(self.flask_app, db.session)
```

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
    READ_ONLY_MODEL_VIEWS = {"Database", "DruidClusterModelView", "DynamicPlugin"}    # 只读视图

    # 用户认证视图： DB/LDAP/Oauth/OID/
    USER_MODEL_VIEWS = {
        "UserDBModelView",
        "UserLDAPModelView",
        "UserOAuthModelView",
        "UserOIDModelView",
        "UserRemoteUserModelView",
    }
    ...

    def can_access(self, permission_name: str, view_name: str) -> bool:
        """ 判断当前用户是否能访问视图 """
        user = g.user
        if user.is_anonymous:  # 匿名访问，看公开权限的视图里是否有入参视图和相应权限
            return self.is_item_public(permission_name, view_name)
        return self._has_view_access(user, permission_name, view_name)

    def _has_view_access(
        self, user: object, permission_name: str, view_name: str
    ) -> bool:
        """
        此函数是父类实现：flask_builder:SecurityManager::_has_view_access()
        先用用户的内建角色看有无权限；如果无，再用其它角色看是否有数据源角色权限
        """
        roles = user.roles
        db_role_ids = list()
        # First check against builtin (statically configured) roles
        # because no database query is needed
        for role in roles:
            if role.name in self.builtin_roles:
                if self._has_access_builtin_roles(role, permission_name, view_name):
                    return True
            else:
                db_role_ids.append(role.id)

        # If it's not a builtin role check against database store roles
        return self.exist_permission_on_roles(view_name, permission_name, db_role_ids)
```

##### JWT

对于API用户，更适合于用JWT方式进行用户认证。flask_appbuilder模块提供此接口实现，详见《[flask_appbuilder源码剖析.md](./flask_appbuilder源码剖析.md)》

支持 Bearer Token认证。

接口：/api/v1/security/login/

```shell
curl -X 'POST' \
  'http://127.0.0.1:5000/api/v1/security/login' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "password": "XXXX",
  "provider": "db",
  "refresh": true,
  "username": "test1"
}'

# show result
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.xx.RdOkZywyIslLj_9AfLb_7qn_zRGFIYdkTywE4H0PryY",
  "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.xx.ntEKT8a6t1h4qzvvATyktyqPxbmo3Ahl1zv7pNNFJ-A"
}
```

#### 资源权限

##### **菜单资源 menu**

使用flask_appbuilder模块的AppBuilder 来处理菜单权限。

##### superset资源

superset资源主要包括数据源、数据集、图表和看板，此外还包括一些静态资源。

/superset/migrations/

表格 各资源权限字段 perm/schema_perm 组成

| 资源（表名）   | 元数据表名       | perm                                               | schem_perm                    |
| -------- | ----------- | -------------------------------------------------- | ----------------------------- |
| druid数据源 | datasources | [{cluster_name}].(id:{id})                         | 无                             |
| 数据库      | dbs         | 无                                                  | 无                             |
| 数据集      | tables      | [{database_name}].[{table_name}] (id:{table_id})') | [database_name].[schema_name] |
| 图表       | slices      | [{database_name}].[{table_name}] (id:{table_id})') | [database_name].[schema_name] |
| 看板       | dashboards  | 无                                                  | 无                             |

权限方法：get_perm,  set_perm

/superset/connectors/sqla/models.py

```python
class SqlaTable(  # pylint: disable=too-many-public-methods,too-many-instance-attributes
    Model, BaseDatasource
):

    """An ORM object for SqlAlchemy table references"""
    type = "table"
    __tablename__ = "tables"    # 元数据表名称
    __table_args__ = (UniqueConstraint("database_id", "table_name"),)

    table_name = Column(String(250), nullable=False)    #表名字段，不可重命名
    main_dttm_col = Column(String(250))
    database_id = Column(Integer, ForeignKey("dbs.id"), nullable=False)    #外键，映射到dbs.id
    fetch_values_predicate = Column(String(1000))
    owners = relationship(owner_class, secondary=sqlatable_user, backref="tables")
    database = relationship(
        "Database",
        backref=backref("tables", cascade="all, delete-orphan"),
        foreign_keys=[database_id],
    )    # 数据库对象
    schema = Column(String(255))
    sql = Column(Text)
    is_sqllab_view = Column(Boolean, default=False)
    template_params = Column(Text)
    extra = Column(Text)

    @property
    def datasource_name(self) -> str:
        return self.table_name

    @property
    def datasource_type(self) -> str:
        return self.type

    @property
    def connection(self) -> str:
        return str(self.database)

    @property
    def database_name(self) -> str:
        """ 获取数据库名，调用 database.name """
        return self.database.name

    def get_schema_perm(self) -> Optional[str]:
        """Returns schema permission if present, database one otherwise."""
        return security_manager.get_schema_perm(self.database, self.schema)

    def get_perm(self) -> str:
        """ 获取表权限-关联到数据库 """
        return f"[{self.database}].[{self.table_name}](id:{self.id})"

    @property
    def name(self) -> str:
        if not self.schema:
            return self.table_name
        return "{}.{}".format(self.schema, self.table_name)

    @property
    def full_name(self) -> str:
        return utils.get_datasource_full_name(
            self.database, self.table_name, schema=self.schema
        )
```

数据库查找/授权示例：

```python
# /superset/database/commands/create.py
# adding a new database we always want to force refresh schema list，
schemas = database.get_all_schema_names(cache=False)
for schema in schemas:
    security_manager.add_permission_view_menu(
        "schema_access", security_manager.get_schema_perm(database, schema)
    )
    security_manager.add_permission_view_menu("database_access", database.perm)


# 查找获取权限ID, database_access指权限名permission_name, database.perm指视图名view_menu_name
perm = security_manager.find_permission_view_menu(
    "database_access", database.perm
)
security_manager.add_permission_role(role, perm)   #给角色增加权限ID


# 基类：/flask_appbuilder/security/manager.py
# 实现：/flask_appbuilder/security/sqla/manager.py
from ..manager import BaseSecurityManager

class SecurityManager(BaseSecurityManager):
    def get_schema_perm(  # pylint: disable=no-self-use
        self, database: Union["Database", str], schema: Optional[str] = None
    ) -> Optional[str]:
        """ 如果数据库存在schema,返回`database.schema`; 否则返回为空 """
        if schema:
            return f"[{database}].[{schema}]"

        return None

    def find_permission_view_menu(self, permission_name, view_menu_name):
        """ 通过权限名、视图名查找 是否有相关权限； 返回非空有权限 """
        permission = self.find_permission(permission_name)    # ab_permission表通过name找id
        view_menu = self.find_view_menu(view_menu_name)        # ab_view_menu表通过name找id
        if permission and view_menu:
            return (
                self.get_session.query(self.permissionview_model)    # ab_permission_view表查询过滤permission和view_menu
                .filter_by(permission=permission, view_menu=view_menu)
                .one_or_none()
            )

    def find_permissions_view_menu(self, view_menu):
        """ 通过视图名获取所有权限 """
```

#### **API访问权限**

API访问权限体现在二个方面，

* 一是用户认证：主要有二种，分别是登陆认证和 JWT认证。
* 二是API资源权限：REST模式中，一个API路由就是一个资源。资源可以对应到某个类的方法里。需要对这个方法进行鉴权。这个过程主要是查询数据库，查询 认证用户所拥有的资源权限是否包括了本API资源权限。

##### 示例1：图表API

/superset/charts/api.py

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

* expose: API路由扩展
* **protect**:  判断API权限。
* rison  捕捉入参的Rison参数
* safe 捕捉异常，返回异常时的JSON
* has_access_api

##### 示例2：新增数据源操作

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

* 数据源密码和加密字段：AES加密保存，依赖cryptography库。密钥SECURITY_KEY来自于用户配置文件。 实现：/superset/models/core.py -> sqlalchemy_utils模块
* 用户密码：密码HASH值保存，检验时按照相同规则生成HASH值和数据库中的比对。实现：/flask_appbuilder/security/sqla/manager.py -> werkzeug模块

/superset/models/core.py

EncryptedType用于数据库表字段加密保存，实现依赖cryptography库，缺省AES加密。密钥来自于config["SECRET_KEY"]。

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
    # EncryptedType(type_in, key) 输入类型，key
    encrypted_extra = Column(EncryptedType(Text, config["SECRET_KEY"]), nullable=True)    # 加密保存字段
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
            padding_mechanism = 'naive'    # 自然补位

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
    impl = String    #缺省实现是字符串

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
        if not engine:    # 缺省AES引擎
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


# /sqlalchemy_utils/type/encrypted/padding.py
# 补位机制，缺省 naive
PADDING_MECHANISM = {
    'pkcs5': PKCS5Padding,
    'oneandzeroes': OneAndZeroesPadding,
    'zeroes': ZeroesPadding,
    'naive': NaivePadding
}
```

 /flask_appbuilder/security/sqla/manager.py

用户密码，HASH值保存，依赖模块werkzeug。HASH生成方法默认pbkdf2:sha256，盐值salt随机生成保存到DB里。

用户注册:  用户提供密码+随机盐值，生成HASH密码。用上面内容用$分割保存成`method$salt$hash_pwd` 写入到DB的密码项。

身份验证：先从DB取出密码项HASH，分别获取到方法、盐值和HASH密码；使用用户传输密码和获取到的盐值生成HASH密码，再比对二者的HASH密码是否一致。

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

#### CSRF & CORS

**CSRF**:  跨站/域请求中转，依赖模块flask_wtf。需要检查 csrf_token，防止请求造假。

关键配置项：

* WTF_CSRF_ENABLED  缺省false不启用
* WTF_CSRF_EXEMPT_LIST 类型列表。免于CSRF检验的视图模块列表

```python
# /superset/extensions.py
from flask_wtf.csrf import CSRFProtect
csrf = CSRFProtect()


# /superset/app.py
from superset.extensions import csrf
class SupersetAppInitializer:
    def configure_wtf(self) -> None:
        if self.config["WTF_CSRF_ENABLED"]:
            csrf.init_app(self.flask_app)
            csrf_exempt_list = self.config["WTF_CSRF_EXEMPT_LIST"]
            for ex in csrf_exempt_list:
                csrf.exempt(ex)


# /flask_wtf/csrf.py
def generate_csrf(secret_key=None, token_key=None):
    """ 产生一个token 放到最近请求的缓存里 """

def validate_csrf(data, secret_key=None, time_limit=None, token_key=None):
    """ 验证给的token是否有效 """

class CSRFProtect(object):
    def init_app(self, app):
        @app.before_request
        def csrf_protect():

    def exempt():
```

**CORS**： 跨域资源共享 Cross Origin Resource sharing

依赖模块 flask_cors

关键配置项：

* ENABLE_CORS  True启用
* CORS_OPTIONS  类型是Dict[Any, Any]
* SUPERSET_WEBSERVER_DOMAINS  类型列表。允许的域名列表，chrome允许一个域6个并发连接，超过则需要排队

```python
# /superset/config.py
# cors示例值
ENABLE_CORS = True
CORS_OPTIONS: Dict[Any, Any] = {"supports_credentials": True}
SUPERSET_WEBSERVER_DOMAINS= None


# /superset/app.py
class SupersetAppInitializer:
        def configure_middlewares(self) -> None:
        if self.config["ENABLE_CORS"]:
            from flask_cors import CORS

            CORS(self.flask_app, **self.config["CORS_OPTIONS"])


# /flask_cors/extensions.py
class CORS(object):
```

### 模板 /templates/

* 模板渲染 /flask_appbuilder/baseviews.py:render_template
* 组件渲染 render

/superset/templates/superset/basic.html

### 工具 /utils/

 /superset/utils/machine_auth.py

```python
from flask import current_app, Flask, request, Response, session
from flask_login import login_user
from selenium.webdriver.remote.webdriver import WebDriver
from werkzeug.http import parse_cookie

from superset.utils.urls import headless_url

if TYPE_CHECKING:
    from flask_appbuilder.security.sqla.models import User


class MachineAuthProvider:
    def __init__(
        self, auth_webdriver_func_override: Callable[[WebDriver, "User"], WebDriver]
    ):
        self._auth_webdriver_func_override = auth_webdriver_func_override

    def authenticate_webdriver(self, driver: WebDriver, user: "User",) -> WebDriver:
        """
            Default AuthDriverFuncType type that sets a session cookie flask-login style
            :return: The WebDriver passed in (fluent)
        """
        # Short-circuit this method if we have an override configured
        if self._auth_webdriver_func_override:
            return self._auth_webdriver_func_override(driver, user)

        # Setting cookies requires doing a request first
        driver.get(headless_url("/login/"))

        if user:  # 获取用户cookie
            cookies = self.get_auth_cookies(user)
        elif request.cookies:
            cookies = request.cookies
        else:
            cookies = {}

        for cookie_name, cookie_val in cookies.items():
            driver.add_cookie(dict(name=cookie_name, value=cookie_val))

        return driver

    @staticmethod
    def get_auth_cookies(user: "User") -> Dict[str, str]:
        # Login with the user specified to get the reports，用户登陆成功后保存当前会话
        with current_app.test_request_context("/login"):
            login_user(user)
            # A mock response object to get the cookie information from
            response = Response()
            current_app.session_interface.save_session(current_app, session, response)

        cookies = {}

        # Grab any "set-cookie" headers from the login response
        for name, value in response.headers:
            if name.lower() == "set-cookie":
                # This yields a MultiDict, which is ordered -- something like
                # MultiDict([('session', 'value-we-want), ('HttpOnly', ''), etc...
                # Therefore, we just need to grab the first tuple and add it to our
                # final dict
                cookie = parse_cookie(value)
                cookie_tuple = list(cookie.items())[0]
                cookies[cookie_tuple[0]] = cookie_tuple[1]

        return cookies


class MachineAuthProviderFactory:
    def __init__(self) -> None:
        self._auth_provider = None

    def init_app(self, app: Flask) -> None:
        auth_provider_fqclass = app.config["MACHINE_AUTH_PROVIDER_CLASS"]
        auth_provider_classname = auth_provider_fqclass[
            auth_provider_fqclass.rfind(".") + 1 :
        ]
        auth_provider_module_name = auth_provider_fqclass[
            0 : auth_provider_fqclass.rfind(".")
        ]
        auth_provider_class = getattr(
            importlib.import_module(auth_provider_module_name), auth_provider_classname
        )

        self._auth_provider = auth_provider_class(app.config["WEBDRIVER_AUTH_FUNC"])

    @property
    def instance(self) -> MachineAuthProvider:
        return self._auth_provider  # type: ignore
```

### 日志

DATA_DIR： 用来存放元数据文件（缺省sqlite是superset.db）、日志文件（superset.log）。依赖环境变量SUPERSET_HOME，缺省~/.superset/

* /superset/config.py 定义日志：STATS_LOGGER  EVENT_LOGGER QUERY_LOGGER，日志配置参数有ENABLE_TIME_ROTATE  TIME_ROTATE_LOG_LEVEL  FILENAME  LOG_FORMAT  LOG_LEVEL
* /superset/utils/logging_configurator.py   DefaultLoggingConfigurator 缺省日志配置，会使用LOG_*配置项
* /superset/utils/log.py   DBEventLogger -> AbstractEventLogger  -> ABC，DBEventLogger.log实现日志批量保存到DB
* /superset/stats_logger.py  STATS_LOGGER的实现类
* /superset/extensions.py   全局日志 event_logger

**几种logger**

* STATS_LOGGER   实时统计的日志，方法有incr, decr, timing计时, gauge。
* EVENT_LOGGER  操作DB的日志（会记录入到内部数据库-元数据log表）。通过装饰器调用，会记录每个API操作。内容会出现在操作日志页面（Security > Action Log）。
* QUERY_LOGGER  查询SQL日志，需要用户自己实现相关接口。可以用来分析SQL

/superset/config.py

```python
from superset.stats_logger import DummyStatsLogger
from superset.utils.log import DBEventLogger
from superset.utils.logging_configurator import DefaultLoggingConfigurator

STATS_LOGGER = DummyStatsLogger()    # 统计日志
EVENT_LOGGER = DBEventLogger()    # 事件日志，会将日志写入到内部数据库
QUERY_LOGGER = None

# Default configurator will consume the LOG_* settings below 会使用下面LOG_*配置项
LOGGING_CONFIGURATOR = DefaultLoggingConfigurator()

# Console Log Settings
LOG_FORMAT = "%(asctime)s:%(levelname)s:%(name)s:%(message)s"
LOG_LEVEL = "DEBUG"

# ---------------------------------------------------
# Enable Time Rotate Log Handler: 每天生成一个文件，保存最近30天。
# 注意：不是进程安全的。多进程要使用gunicorn的日志体系。
# ---------------------------------------------------
# LOG_LEVEL = DEBUG, INFO, WARNING, ERROR, CRITICAL
ENABLE_TIME_ROTATE = False
TIME_ROTATE_LOG_LEVEL = "DEBUG"
FILENAME = os.path.join(DATA_DIR, "superset.log")
ROLLOVER = "midnight"
INTERVAL = 1
BACKUP_COUNT = 30
```

/superset/utils/logging_configurator.py

DefaultLoggingConfigurator 缺省日志配置，会使用LOG_*配置项

```python
import abc
import logging
from logging.handlers import TimedRotatingFileHandler

import flask.app
import flask.config

logger = logging.getLogger(__name__)


# pylint: disable=too-few-public-methods
class LoggingConfigurator(abc.ABC):
    @abc.abstractmethod
    def configure_logging(self, app_config: flask.config.Config, debug_mode: bool) -> None:
        pass


class DefaultLoggingConfigurator(LoggingConfigurator):
    """ 设置各种日志器的日志级别、日志格式 """
    def configure_logging(
        self, app_config: flask.config.Config, debug_mode: bool
    ) -> None:
        if app_config["SILENCE_FAB"]:
            logging.getLogger("flask_appbuilder").setLevel(logging.ERROR)

        # configure superset app logger： superset_logger应用日志
        superset_logger = logging.getLogger("superset")
        if debug_mode:
            superset_logger.setLevel(logging.DEBUG)
        else:
            # In production mode, add log handler to sys.stderr.
            superset_logger.addHandler(logging.StreamHandler())
            superset_logger.setLevel(logging.INFO)

        logging.getLogger("pyhive.presto").setLevel(logging.INFO)

        logging.basicConfig(format=app_config["LOG_FORMAT"])
        logging.getLogger().setLevel(app_config["LOG_LEVEL"])

        if app_config["ENABLE_TIME_ROTATE"]:  # 时间滚动日志
            # logging.getLogger()不传参时返回根日志RootLogger，这样其它日志器的记录都会打印到RootLogger指向的文件
            # 如果getLogger('xx') 有传值，那只有这个称呼的日志器才能指向文件
            logging.getLogger().setLevel(app_config["TIME_ROTATE_LOG_LEVEL"])
            handler = TimedRotatingFileHandler(
                app_config["FILENAME"],
                when=app_config["ROLLOVER"],
                interval=app_config["INTERVAL"],
                backupCount=app_config["BACKUP_COUNT"],
            )
            logging.getLogger().addHandler(handler)

        logger.info("logging was configured successfully")
```

>  说明：这里日志格式<u>LOG_FORMAT</u>死活都不起作用。

/superset/utils/log.py

DBEventLogger.log实现日志批量保存到DB

```python
from abc import ABC, abstractmethod

class AbstractEventLogger(ABC):

class DBEventLogger(AbstractEventLogger):
    def log(  # pylint: disable=too-many-arguments,too-many-locals
        self,
        user_id: Optional[int],
        action: str,
        dashboard_id: Optional[int],
        duration_ms: Optional[int],
        slice_id: Optional[int],
        referrer: Optional[str],
        *args: Any,
        **kwargs: Any,
    ) -> None:
        from superset.models.core import Log     # 表名为 logs
```

/superset/stats_logger.py

实时统计的日志，方法有incr, decr, timing计时, gauge测量（容器长度）。

* DummyStatsLogger，依赖模块logging，通过缺省日志器输出到终端或文件
* StatsdStatsLogger  依赖模块 statsd，socket客户端实时发送数据

```python
import logging
from typing import Optional

from colorama import Fore, Style  # 颜色，可以在终端根据编号显示相应颜色

logger = logging.getLogger(__name__)

class BaseStatsLogger:
    """Base class for logging realtime events"""

    def __init__(self, prefix: str = "superset") -> None:
        self.prefix = prefix

    def key(self, key: str) -> str:
        if self.prefix:
            return self.prefix + key
        return key

    def incr(self, key: str) -> None:
        """Increment a counter"""
        raise NotImplementedError()

    def decr(self, key: str) -> None:
        """Decrement a counter"""
        raise NotImplementedError()

    def timing(self, key: str, value: float) -> None:
        raise NotImplementedError()

    def gauge(self, key: str, value: float) -> None:
        """Setup a gauge"""
        raise NotImplementedError()


class DummyStatsLogger(BaseStatsLogger):
    """ Fore Style 带颜色的日志 """
    def incr(self, key: str) -> None:
        logger.debug(Fore.CYAN + "[stats_logger] (incr) " + key + Style.RESET_ALL)

    def decr(self, key: str) -> None:
        logger.debug((Fore.CYAN + "[stats_logger] (decr) " + key + Style.RESET_ALL))

    def timing(self, key: str, value: float) -> None:
        logger.debug(
            (Fore.CYAN + f"[stats_logger] (timing) {key} | {value} " + Style.RESET_ALL)
        )

    def gauge(self, key: str, value: float) -> None:
        logger.debug(
            (Fore.CYAN + "[stats_logger] (gauge) " + f"{key}" + f"{value}"+ Style.RESET_ALL)
        )
```

日志调用&示例

```python
# /superset/extensions.py
# event_logger其实不是日志，是一个本地代理
_event_logger: Dict[str, Any] = {}
event_logger = LocalProxy(lambda: _event_logger.get("event_logger"))

# xx.py 控制台日志
logger = logging.getLogger(__name__)

# stats_logger调用示例
stats_logger = config["STATS_LOGGER"]
stats_logger.incr(f"{self.__class__.__name__}.select_star")
# 日志打印结果示例
DEBUG:superset.stats_logger:[stats_logger] (incr) DashboardRestApi.get_list.success

# event_logger调用示例： 通常用在API，调用装饰器log_this, log_this_with_context
@event_logger.log_this
@expose("/available_domains/", methods=["GET"])
def available_domains(self) -> FlaskResponse:  # pylint: disable=no-self-use
    return Response(json.dumps(conf.get("SUPERSET_WEBSERVER_DOMAINS")), mimetype="text/json")

@expose("/favorite_status/", methods=["GET"])
@statsd_metrics    #统计指标
@rison(get_fav_star_ids_schema)    #解析并验证参数rison为有效的python数据结构
@event_logger.log_this_with_context(
    action=lambda self, *args, **kwargs: f"{self.__class__.__name__}"
    f".favorite_status",
    log_to_statsd=False,
)
def favorite_status(self, **kwargs: Any) -> Response:
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
  * 部署参数：mode(对应到脚本命令里的--mode)  devserverPort
  * 其它：module模块和plugin插件。
* webpack.proxy-config.js   webpack代理配置。当启用了web-dev-server时使用。
* manifest.json   webpack打包后生成的模块详细信息，可以通过模块标识符找到对应的模块(xx.js/xx.css)。构建成生成到superset/static/asset/mainfest.json
* src/{xx}/index.tsx  某个目录下的入口文件，可对照webpack.config.js的entry

#### package.json

主要配置项：scripts engines dependencies devDependencies stylelint

```json
{
  "name": "DataLab",
  "version": "0.999.0dev",
  "description": "Superset is a data exploration platform designed to be visual, intuitive, and interactive.",
  "license": "Apache-2.0",
  "directories": {
    "doc": "docs",
    "test": "spec"
  },
  "scripts": {  #脚本命令，可用npm run xx启动
    "tdd": "NODE_ENV=test jest --watch",
    "test": "NODE_ENV=test jest",
    "type": "tsc --noEmit",
    "cover": "NODE_ENV=test jest --coverage",
    "dev": "webpack --mode=development --colors --debug --watch",
    "dev-server": "NODE_ENV=development BABEL_ENV=development node --max_old_space_size=4096 ./node_modules/webpack-dev-server/bin/webpack-dev-server.js --mode=development",
    "prod": "npm run build",
    "build-instrumented": "cross-env NODE_ENV=development BABEL_ENV=instrumented webpack --mode=development --colors",
    "build": "cross-env NODE_OPTIONS=--max_old_space_size=8192 NODE_ENV=production BABEL_ENV=production webpack --mode=production --colors",
    "lint": "eslint --ignore-path=.eslintignore --ext .js,.jsx,.ts,.tsx . && npm run type",
    "prettier-check": "prettier --check '{src,stylesheets}/**/*.{css,less,sass,scss}'",
    "lint-fix": "eslint --fix --ignore-path=.eslintignore --ext .js,.jsx,.ts,tsx . && npm run clean-css && npm run type",
    "clean-css": "prettier --write '{src,stylesheets}/**/*.{css,less,sass,scss}'",
    "format": "prettier --write './{src,spec,stylesheets,cypress-base}/**/*{.js,.jsx,.ts,.tsx,.css,.less,.scss,.sass}'",
    "prettier": "npm run format",
    "check-translation": "prettier --check ../superset/translations/**/LC_MESSAGES/*.json",
    "clean-translation": "prettier --write ../superset/translations/**/LC_MESSAGES/*.json",
    "storybook": "NODE_ENV=development BABEL_ENV=development start-storybook -p 6006",
    "build-storybook": "build-storybook"
  },
  "repository": {
    "type": "git",
    "url": "git+https://github.com/apache/superset.git"
  },
  "keywords": [ "react","d3","flask"],
  "author": "Apache",
  "bugs": {
    "url": "https://github.com/apache/superset/issues"
  },
  "browserslist": [
    "last 3 chrome versions",
    "last 3 firefox versions",
    "last 3 safari versions",
    "last 3 edge versions"
  ],
  "engines": {
    "node": ">= 12.18.3 < 13",
    "npm": ">= 6.14.8"
  },
  "homepage": "https://superset.apache.org/",
  "dependencies": {  #运行依赖
    "@ant-design/icons": "^4.2.2",
    "@babel/runtime-corejs3": "^7.12.5",
    "@superset-ui/chart-controls": "^0.16.7",
    "@superset-ui/core": "^0.16.7",
    ...
  },
  "devDependencies": {  #开发依赖
    "@babel/cli": "^7.12.10",
    "webpack": "^4.42.0",
    "webpack-bundle-analyzer": "^3.6.1",
    "webpack-cli": "^3.3.11",
    "webpack-dev-server": "^3.11.0",
    ...
  },
  "stylelint": {
    "rules": {
      "block-opening-brace-space-before": "always",
      "no-missing-end-of-source-newline": "never",
      "rule-empty-line-before": [
        "always",
        {"except": ["first-nested"], "ignore": ["after-comment"]}
      ]
    }
  }
}
```

#### webpack.config.js

* mode：模式，有development production 等，对应到package.json脚本命令里的--mode。根据模式不同，打包文件名、使用插件会有所不同。build/prod命令模式为production ，dev/dev-server/build-instrumented命令模式为development。
* isDevMode：当mode不是production 时为True。True时会启用本地端口、js/css/less等sourceMap，配置devServer； 否则加载 MiniCssExtractPlugin，TerserPlugin。
* isDevServer：传参有webpack-dev-server 就是启用了本地开发服务器。isDevServer不为true时，会启用清除插件CleanWebpackPlugin。

**/superset-frontend/webpack.config.js  **

```js
const fs = require('fs');
const path = require('path');
const webpack = require('webpack');                                        //webpack工具
const { BundleAnalyzerPlugin } = require('webpack-bundle-analyzer');    //打包插件
const { CleanWebpackPlugin } = require('clean-webpack-plugin');        //清理旧包插件，isDevServer=false时启用
const CopyPlugin = require('copy-webpack-plugin');                    //复制旧包插件
const MiniCssExtractPlugin = require('mini-css-extract-plugin');    //CSS优化，isDevMode=true
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin'); //CSS优化，isDevMode=true
const SpeedMeasurePlugin = require('speed-measure-webpack-plugin');  //合并加速
const TerserPlugin = require('terser-webpack-plugin');            //TerserPlugin移除开发时调试信息如debugger、console.log、注释
const ManifestPlugin = require('webpack-manifest-plugin');        //ManifestPlugin生成mainfest.json
const ForkTsCheckerWebpackPlugin = require('fork-ts-checker-webpack-plugin');  //多进程合并插件
const parsedArgs = require('yargs').argv;                    //解析命令行参数
const getProxyConfig = require('./webpack.proxy-config');    //NOTE: 本地代理配置，启用了webpack-dev-server时导入，会读入文件webpack-proxy.config.js
const packageConfig = require('./package.json');            //读取package.json里dependencies，导入依赖模块源码

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

const babelLoader = {    // babel加载器，负责国际化
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

const config = {    //配置信息，最终导出的配置项
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

let proxyConfig = getProxyConfig();        //读入配置文件webpack.proxy-config.js

if (isDevMode) {  //开发模式 配置项： devServer,导入依赖模块源码
 config.devtool = 'eval-cheap-module-source-map';
 config.devServer = {
   before(app, server, compiler) {
     // load proxy config when manifest updates
     const hook = compiler.hooks.webpackManifestPluginAfterEmit;
     hook.tap('ManifestPlugin', manifest => {
       proxyConfig = getProxyConfig(manifest);
     });
   },
   historyApiFallback: true,
   hot: true,
   injectClient: false,
   injectHot: true,
   inline: true,
   stats: 'minimal',
   overlay: true,
   port: devserverPort,
   // Only serves bundled files from webpack-dev-server
   // and proxy everything else to Superset backend
   proxy: [
     // functions are called for every request
     () => proxyConfig,
   ],
   contentBase: path.join(process.cwd(), '../static/assets'),
 };
// find all the symlinked plugins and use their source code for imports
 let hasSymlink = false;
 ...
 if (hasSymlink) {
   console.log(''); // pure cosmetic new line
 }
} else { //移除注释
 config.optimization.minimizer = [
   new TerserPlugin({
     cache: '.terser-plugin-cache/',
     parallel: true,
     extractComments: true,
   }),
 ];
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

/superset-frontend/src/views/index.tsx

```tsx
import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';

// 渲染效果： <div id="app"> 模板App的HTML语言 </div>
// 模板App在Vue框架里一般称叫组件
ReactDOM.render(<App />, document.getElementById('app'));
```

下面2个实现一致:  dashboard, explorer

/superset-frontend/src/dashboard/index.tsx

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

#### mainfest.json

前端打包时生成到/superset/static/asset/mainfest.json

```json
{
  "app": "superset",
  "entrypoints": {
    "theme": {
      "css": ["/static/assets/theme.c09e69015dec6f34dc60.entry.css"],
      "js": ["/static/assets/theme.c09e69015dec6f34dc60.entry.js"]
    },
    "preamble": { "css": [], "js": [], },
    "addSlice": { "css": [], "js": [], },
    "explore": { "css": [], "js": [], },
    "dashboard": { "css": [], "js": [], },
    "sqllab": { "css": [], "js": [], },
    "menu": { "css": [], "js": [], },
    "profile": { "css": [], "js": [], },
    "showSavedQuery": { "css": [], "js": [], },
    "crudViews": {
      "css": [
        "/static/assets/crudViews.47f4be1346a1c3abadb1.entry.css"
      ],
      "js": [
        "/static/assets/6cf67bc805d2009a9391.chunk.js",
        "/static/assets/39f91e8503ddfcb94b8f.chunk.js",
        "/static/assets/88770ecce227232995f9.chunk.js",
        "/static/assets/crudViews.47f4be1346a1c3abadb1.entry.js"
      ]
    },
  }
}
```

打包文件名生成定义在 webpack-config.js

文件名里带entry表示是入口文件，带chunk是依赖模块文件（可能是多个tsx/js合并生成）。

* 开发模式：使用hash，`npm run dev`， 每次构建hash值都不一样，因此浏览器缓存无效。
* 生产模式：使用chunkhash，`npm run build/prod`，如果某个文件改变，其对应的chunk文件名称也变化。只影响到改动文件的缓存。

```js
const output = {  //打包输出路径
  path: BUILD_DIR,
  publicPath: '/static/assets/', // necessary for lazy-loaded chunks
};
// 打包输出文件命名: chunkhash-模块hash值（只针对本模块更改生成），hash:8-hash值前8位(hash值生成依赖编译对象，即文件更改或重新编译都会重新计算生成整个项目hash)
// name：指打包模块名，如crudviews, dashboard，
if (isDevMode) {        // isDevMode=True开发模式使用hash，使浏览器缓存失效
  output.filename = '[name].[hash:8].entry.js';
  output.chunkFilename = '[name].[hash:8].chunk.js';
} else if (nameChunks) {  // nameChunks=True使用 chunkhash
  output.filename = '[name].[chunkhash].entry.js';
  output.chunkFilename = '[name].[chunkhash].chunk.js';
} else {
  output.filename = '[name].[chunkhash].entry.js';
  output.chunkFilename = '[chunkhash].chunk.js';
}
```

### React组件  /src/components/

此处组件是指最小粒度的React组件。

#### 菜单 Menu/

见上文 《导航栏布局》

### 视图 /src/views/

* /src/views/App.tsx  定义了全局路由，主要依赖于组件 react-router-dom

* /src/views/index.tsx  视图打包    `crudViews: addPreamble('/src/views/index.tsx'),`

* /src/views/menu.tsx  菜单打包   `menu: addPreamble('src/views/menu.tsx'),`

* /src/views/CRUD/xx    具体的视图组件。如图表chart，看板dashboard

#### !全局路由和组件 App.tsx

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
            ...
        },
        "locale": "zh",
        "language_pack": {
            "domain": "superset",
            "locale_data": {
        },
        "feature_flags": {
            "ALLOW_DASHBOARD_DOMAIN_SHARDING": true,
            "CLIENT_CACHE": false,
            ...
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

#### !打包视图模块 index.tsx

/superset-frontend/src/views/index.tsx

依赖组件 App。App定义全局路由和主要的组件如数据源datasource、数据集dataset、图表chart和看板dashboard。

```tsx
import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';

ReactDOM.render(<App />, document.getElementById('app'));
```

#### !打包菜单模块 menu.tsx

/superset-frontend/src/views/menu.tsx

依赖组件 Menu来自于src/components/Menu/Menu。

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

#### 图表 CRUD/chart/

目录：/superset-frondend/src/views/CRUD/chart/

* ChartList.tsx   图表列表、
* ChartCard.tsx  图表卡片
* types.ts

/superset-frondend/src/views/CRUD/chart/ChartList.tsx

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

### 探索 explorer /src/explorer/

* actions/
* components/
* controlPannels/
* exploreUtils/
* reducers/

#### 控制按钮 controls.jsx

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

### 可视化 /src/visualizations/

客户端的图表类型组件多来自外部模块@superset-ui。superset只是重新组织了图表组件的展示 。

过滤盒的每个选项，会从数据源group by相应选项字段，得到选项下拉菜单的值。

看板过滤盒对看板内图表的影响，是通过点击确认键时，重新向每个图表触发过滤参数改变的新请求。v1.3实现了过滤映射（新增图形界面，以前是配置参数），可以只向指定的若干图表触发请求。

* FilterBox/  过滤盒  v1.3疑废弃，换用看板原生过滤器
* presets/  预设，图表插件导入
* TimeTable/  时间表格
* constants.js  只定义一个常量 TIME_CHOICES

#### 预设 /presets/MainPreset.jsx

/superset-frontend/src/visualizations/presets/MainPreset.jsx

图表插件导入，多是直接从@superset-ui导入。因此若@superset-ui模块增加了新图表类型插件，多数情况下可直接使用到superset里。

```jsx
import { Preset } from '@superset-ui/core';
import {
  BigNumberChartPlugin,
  BigNumberTotalChartPlugin,
} from '@superset-ui/legacy-preset-chart-big-number';
import CalendarChartPlugin from '@superset-ui/legacy-plugin-chart-calendar';
...

export default class MainPreset extends Preset {
  constructor() {
    super({
      name: 'Legacy charts',
      presets: [new DeckGLChartPreset()],
      plugins: [
        new AreaChartPlugin().configure({ key: 'area' }),
        new BarChartPlugin().configure({ key: 'bar' }),
        new BigNumberChartPlugin().configure({ key: 'big_number' }),
        new BigNumberTotalChartPlugin().configure({ key: 'big_number_total' }),
        new EchartsBoxPlotChartPlugin().configure({ key: 'box_plot' }),
        new BubbleChartPlugin().configure({ key: 'bubble' }),
        new BulletChartPlugin().configure({ key: 'bullet' }),
        new CalendarChartPlugin().configure({ key: 'cal_heatmap' }),
        new ChordChartPlugin().configure({ key: 'chord' }),
        new CompareChartPlugin().configure({ key: 'compare' }),
        new CountryMapChartPlugin().configure({ key: 'country_map' }),
        new DistBarChartPlugin().configure({ key: 'dist_bar' }),
        new DualLineChartPlugin().configure({ key: 'dual_line' }),
        new EventFlowChartPlugin().configure({ key: 'event_flow' }),
        new FilterBoxChartPlugin().configure({ key: 'filter_box' }),
        new ForceDirectedChartPlugin().configure({ key: 'directed_force' }),
        new HeatmapChartPlugin().configure({ key: 'heatmap' }),
        new HistogramChartPlugin().configure({ key: 'histogram' }),
        new HorizonChartPlugin().configure({ key: 'horizon' }),
        new LineChartPlugin().configure({ key: 'line' }),
        new LineMultiChartPlugin().configure({ key: 'line_multi' }),
        new MapBoxChartPlugin().configure({ key: 'mapbox' }),
        new PairedTTestChartPlugin().configure({ key: 'paired_ttest' }),
        new ParallelCoordinatesChartPlugin().configure({ key: 'para' }),
        new PartitionChartPlugin().configure({ key: 'partition' }),
        new EchartsPieChartPlugin().configure({ key: 'pie' }),
        new PivotTableChartPlugin().configure({ key: 'pivot_table' }),
        new RoseChartPlugin().configure({ key: 'rose' }),
        new SankeyChartPlugin().configure({ key: 'sankey' }),
        new SunburstChartPlugin().configure({ key: 'sunburst' }),
        new TableChartPlugin().configure({ key: 'table' }),
        new TimePivotChartPlugin().configure({ key: 'time_pivot' }),
        new TimeTableChartPlugin().configure({ key: 'time_table' }),
        new TreemapChartPlugin().configure({ key: 'treemap' }),
        new WordCloudChartPlugin().configure({ key: 'word_cloud' }),
        new WorldMapChartPlugin().configure({ key: 'world_map' }),
        new EchartsTimeseriesChartPlugin().configure({
          key: 'echarts_timeseries',
        }),
        new AntdSelectFilterPlugin().configure({ key: 'filter_select' }),
        new AntdRangeFilterPlugin().configure({ key: 'filter_range' }),
      ],
    });
  }
}
```

### 看板 /src/dashboard/

看板布局和交互逻辑

* actions/
* components/  看板涉及到的各种组件，如CssEditor、menu、filterscope、FilterBadge....
* containers/
* fixtures/  只有一个文件emptyDashboardLayout.js
* reducers/
* stylesheets/  样式表
* utils/

## 5 /superset-websock/

## 依赖模块

* 服务端依赖模块 flask及flask扩展模块 详见 《[flask源码剖析](flask源码剖析.md)》《[flask_appbuilder源码剖析](flask_appbuilder源码剖析.md)》

* 前端依赖 @superset-ui 详见 《[superset-ui源码剖析](superset-ui源码剖析.md)》

* 前端依赖 React  详见 《[前端框架分析](前端框架分析.md)》

<br>

## 本章参考

* 知乎专栏-superset开发 https://zhuanlan.zhihu.com/c_100045590
* superset二次开发及汉化、图标等 https://blog.csdn.net/qq_34521526/article/details/116708025
* Superset 代码结构分析(前后端如何联动) https://zhuanlan.zhihu.com/p/163495199
* 从前端角度记录superset二次开发 http://sunjl729.cn/2020/08/07/superset二次开发/
* Superset安装及汉化 https://www.jianshu.com/p/c751278996f8

<br>

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

<br>

# 附录
