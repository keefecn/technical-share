| 序号 | 修改时间   | 修改内容                             | 修改人 | 审稿人 |
| ---- | ---------- | ------------------------------------ | ------ | ------ |
| 1    | 2020-12-16 | 创建。                               | 吴启福 |        |
| 2    | 2021-6-9   | 从《WEB框架分析》迁移WEB框架相关章节 | 同上   |        |















---




# 1 Python框架

表格 1 Python框架列表

| **框架名称** | **简介** | **介绍** |
| ------------ | -------- | -------- |
| Celery          | 多任务队列 |          |
| gunicorn | 多工作进程并发 | |

 

## python web框架列表

表格 3 python WEB框架列表

| 框架                                                         | 简介                                                         | 特点                     | 优点                                                         | 缺点               | 推荐       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------ | ------------------------------------------------------------ | ------------------ | ---------- |
| [Django](https://www.djangoproject.com/download/)            | 它源自一个在线新闻 Web 站点，于 2005 年开源。<br>一个开源的重量级Web框架，并且采用MVC设计模式。 | 全能型，重量级           | 自带ORM/template/view，全自动全功能的管理后台。              | 容易 臃肿          | 管理态后端 |
| [flask](http://flask.pocoo.org/)                             | 使用 [Python](http://baike.so.com/doc/1790119-1892991.html) 编写的轻量级 Web 应用框架。其 [WSGI](http://baike.so.com/doc/1142343-1208497.html) 工具箱采用 Werkzeug ，[模板引擎](http://baike.so.com/doc/5846906-6059743.html)则使用 Jinja2 。Flask使用 BSD 授权。 | 轻量级，原生组件几乎没有 | 简单；配置灵活；入门简单；低耦合                             | 不适用大网站，路由 | 微服务     |
| tornado                                                      | 著名的Friendfeed 网站就是使用它搭建的。<br>在IO密集性和多任务上性能很好。 | 轻量、异步非阻塞         | 异步非阻塞。高可伸缩性（单线程异步）；websocket长连接。自定义模块。 |                    | 微服务     |
| [Zope 2](http://zope2.zope.org/releases)                     | 一款基于Python的Web应用框架，是所有Python Web应用程序、工具的鼻祖，是Python家族一个强有力的分支。<br>Zope 2的“对象发布”系统非常适合面向对象开发方法，并且可以减轻开发者的学习曲线，还可以帮助你发现应用程序里一些不好的功能。 |                          |                                                              |                    |            |
| [Web2py](http://web2py.com/examples/default/download)        | 一个用Python语言编写的免费的开源Web框架，旨在敏捷快速的开发Web应用，具有快速、可扩展、安全以及可移植的数据库驱动的应用，遵循LGPLv3开源协议。   Web2py提供一站式的解决方案，整个开发过程都可以在浏览器上进行，提供了Web版的在线开发，HTML模版编写，静态文件的上传，数据库的编写的功能。其它的还有日志功能，以及一个自动化的admin接口。 |                          |                                                              |                    |            |
| [Web.py](http://webpy.org/install)                           | 一个轻量级的开源Python Web框架，小巧灵活、简单并且非常强大，在使用时没有任何限制。目前Web.py被广泛运用在许多大型网站，如西班牙的社交网站Frinki、主页日平均访问量达7000万次的Yandex等。 |                          |                                                              |                    |            |
| [Pyramid](http://www.pylonsproject.org/projects/pyramid/download) | 一款轻量级的开源Python Web框架，是Pylons项目的一部分。Pyramid只能运行在Python 2.x或2.4以后的版本上。在使用后端数据库时无需声明，在开发时也不会强制使用一些特定的模板系统。 |                          |                                                              |                    |            |
| pylons                                                       | 对WSGI标准进行了扩展应用，提升了重用性且将功能分割到独立的模块中。 |                          |                                                              |                    |            |
| [CubicWeb](http://docs.cubicweb.org/admin/setup)             | 不仅是一个Web开发框架，而且还是一款语义Web开发框架。CubicWeb使用关系查询语言（RQL Relation Query Language）与数据库之间进行通信。 |                          |                                                              |                    |            |
| [turbogears](http://www.turbogears.org/)                     | 一个可以扩展为全栈解决方案的微型框架。                       |                          |                                                              |                    |            |

 

# 2  python WEB三大框架

## 简述

### 性能比较

表格 4 python WEB框架性能比较

|                  | 性能 nums/sec |         | 依赖组件                                            | 启动方式                       |
| ---------------- | ------------- | ------- | --------------------------------------------------- | ------------------------------ |
| 框架名           | 单进程        | 并发100 |                                                     |                                |
| Django           | 255           | x       | babel(10k)                                          | python manger.py runserver     |
| Tornago          | 387           | 918     |                                                     |                                |
| Flask            | 342           | 1694    | Jinjia2(12k), <br>MarkupSafe(22k),  <br>click(6.6k) | python xx.py                   |
| uwsgi + Django   | 280           | 2947    |                                                     |                                |
| uwsgi + Flask    | 343           | 4651    |                                                     | uwsgi --wsgi-file <file>       |
| gunicorn + Flask |               |         |                                                     | gunicorn -w 2 <filename.Flask> |

备注：测试环境4U8G。uwsgi启动4个工作进程。uwsgi使用C实现性能更高，gunicorn更易使用。Django/Falsk/Tornago都是单进程，可以搭配gunicorn/uwsgi才能发挥多核CPU性能。



## 2.1 Django

### 简介

Django是一个开放源代码的Web应用框架，遵守BSD版权，由Python写成。 

框架本身集成了ORM、模型绑定、模板引擎、缓存、Session等诸多功能。

django3.0之前django的Web服务器网关接口一直用的是WSGI，ASGI的A就是Async，也就是异步的意思，ASGI简单的来说就是异步的WSGI。



表格 Django版本说明

| 版本号 | 发布时间 | 功能或更新说明                                               |
| ------ | -------- | ------------------------------------------------------------ |
| v0.x   | 2005.7   |                                                              |
| v1.0   | 2008.9   | 正式版本。                                                   |
| v2.0   | 2018     | 不再支持python2.x。2.x系列最后版本是v.2.2.24                 |
| v3.0   | 2020     | 新增三个特性：ASGI、支持MariaDB10.1+和自定义枚举类型（TextChoices，IntegerChoices）。 |
| v3.2.4 | 2021     |                                                              |





### django开发篇

#### 入门实例

**Django安装**

```shell
$ pip install django  #安装最新版本的Django
$ pip install -v django==1.7.1   #或者指定安装版本
```

流程小结： xx开头表示这是用户自己命名的变量。

* 创建项目（全局定义，生成settings.py, urls.ppy）：`django-admin.py startproject xxproject`
* 创建APP（具体业务应用，xxapp目录下会生成models.py, views.py）:  `python manage.py startapp xxapp`
* 编辑 xxapp/models.py：完成数据库表结构创建。
* 编辑 xxapp/views.py：完成业务处理逻辑。此处可引入DRF框架进行数据序列化和反序列化。
* 编辑 xxproject/urls.py：处理URL路由，支持path/repath，path又支持视图-FBV和CBV。



**1. 命令行创建项目** (示例项目名mysite)

`$ django-admin.py startproject mysite`

Django将自动生成下面的目录结构：

```shell
mysite/		# startproject生成的站点目录
├── manage.py   # Django管理主程序
├── mysite
│   ├── __init__.py
│   ├── settings.py  # 主配置文件
│   ├── urls.py   	# URL路由系统文件，相当于MVC中的C
│   └── asgi.py  	# 网络通信接口, djaongo3.0之前是wsgi.py
└── template  # 该目录放置HTML文件模板
```



**2. 创建APP** （示例app名为cmdb）

在每个Django项目中可以包含多个APP，相当于一个大型项目中的分系统、子模块、功能部件等等，相互之间比较独立，但也有联系，所有的APP共享项目资源。

```shell
$ python manage.py startapp cmdb
cmdb/	# startapp生成的app目录
├── admin.py     # 管理页面里需要管理的数据库表 可以注册到这
├── apps.py  	 #
├── __init__.py  # 
├── migrations	 # migrate命令自动生成的ORM操作文件
│   └── __init__.py
├── models.py   # 模型，负责业务对象和数据对象的ORM映射
├── tests.py	
└── views.py	# 视图，业务处理逻辑

```

**project 和 app 的区别**

* project包含一些全局配置，这些配置构成一个全局的运行平台，各个APP都运行在这个全局的运行平台上.
* APP代表的是一个相对独立的功能模块，所以程序的逻辑都在APP中。



**3.  manger.py命令**

```
$ python manage.py --help

Type 'manage.py help <subcommand>' for help on a specific subcommand.

Available subcommands:

[auth]
    changepassword
    createsuperuser

[contenttypes]
    remove_stale_contenttypes

[django]
    check
    compilemessages
    createcachetable
    dbshell
    diffsettings
    dumpdata
    flush	#清空数据库数据
    inspectdb
    loaddata
    makemessages
    makemigrations	#生成数据库文件
    migrate
    sendtestemail
    shell
    showmigrations
    sqlflush
    sqlmigrate
    sqlsequencereset
    squashmigrations
    startapp
    startproject
    test
    testserver

[sessions]
    clearsessions

[staticfiles]
    collectstatic
    findstatic
    runserver	#启动监听服务

```

1).  数据库表和表字段的创建、更新

可通过 makemigrations, migrate来管理。

数据库表的创建或更新

```shll
$ python3 manage.py migrate   # 创建表结构 或 更新
$ python3 manage.py makemigrations xxapp  # 新增加app时，才执行此步
$ python3 manage.py migrate xxapp   # 创建xxapp的表结构
```



**4、编写路由规则**

路由都在urls文件里，它将浏览器的URL映射到响应的业务处理逻辑。

* 路由映射函数： url(废弃), path, re_path(正则)
* 视图函数2种：一是直接函数名，二是 xxView.as_view()转化。

```python
# urls.py
from django.conf.urls import url
from django.contrib import admin
from cmdb import views
 
urlpatterns = [
    url(r'admin/', admin.site.urls),	# FBV，django默认的管理界面,超级用户要通过命令创建
    path(index', Indexview.as_view()),	# CBV基于类的视图
]
```

 

**5、编写业务处理逻辑 views或者template** 

Django原生的视图使用View，请求响应是HttpRequest/HttpResponse

```python
from django.views.generic import View
from django.shortcuts import HttpResponse 
```



视图实现二种方法： FBV和CBV

* **FBV（function base views）** 基于函数的视图，就是在视图里使用函数处理请求。

* **CBV（class base views）** 基于类的视图，就是在视图里使用类处理请求。

视图实现 FBV

```python
# urls.py
urlpatterns = [
    path("/login", views.login),
]

# views.py
from django.shortcuts import render
from django.shortcuts import HttpResponse  #首先导入HttpResponse模块

# Create your views here.
def login(request):
    """
    :param request: 这个参数必须有，类似self的默认规则，可以改，它封装了用户请求的所有内容
    :return: 不能直接返回字符串，必须有HttpResponse这个类封装起来，这是Django的规则
    """
    if request.method == "GET":
        return HttpResponse("GET 方法")
    if request.method == "POST":
        user = request.POST.get("user")
        pwd = request.POST.get("pwd")  
        if user == "runoob" and pwd == "123456":
            return HttpResponse("POST 方法")
        else:
            return HttpResponse("POST 方法1")
    return HttpResponse("other method")
```



视图实现 CBV

```python
# urls.py
urlpatterns = [
    path("login/", xxView.as_view()),
]

# views.py
from django.shortcuts import render,HttpResponse
from django.views import View  # django原生类视图

class Login(View):
    def get(self,request):
        return HttpResponse("GET 方法")

    def post(self,request):
        user = request.POST.get("user")
        pwd = request.POST.get("pwd")
        if user == "runoob" and pwd == "123456":
            return HttpResponse("POST 方法")
        else:
            return HttpResponse("POST 方法 1")
```



**运行Web服务**

$ python manage.py runserver 127.0.0.1 8080

访问地址：http://127.0.0.1:8000/index/ 可以看到我们定义的返回结果"Hello,World"。

 django服务启动的同时，会启动两个进程，一个负责监控文件的变化，一个是主进程，如果文件发生变化，则会将退出当前进程，重新启动一个子进程。要想避免监控文件变化，加参数--noreload。



####  配置项 settings.py

```python
# 调试项，prod环境要改为False
DEBUG = True

# 配置APP
INSTALLED_APPS = [
    ...
    'rest_framework',
    'drf_yasg'
]

# 配置数据库： engine支持sqlite3,mysql, oracle, mongodb
DATABASES = {
    'default':
        {
            'ENGINE': 'django.db.backends.mysql',  # 数据库引擎
            'NAME': 'content_review',  # 数据库名称
            'HOST': '127.0.0.1',  # 数据库地址，本机 ip 地址  59.110.14.234
            'PORT': 3306,  # 端口
            'USER': 'ai_user',  # 数据库用户名
            'PASSWORD': '',  # 数据库密码
        }
}

# 配置中间件
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

# 配置swagger

```



#### Django权限管理

Django自带权限管理是基于角色的权限管理模型。

django自带表分为二类，

* 一类是auth开头的，需要激活了认证应用auth才生效，这些表是权限管理表，可管理用户、用户组、权限，内容对象。
* 另一类是django开头的表，功能是app管理、会话管理、管理日志、数据迁移记录。

表格 django自带表

| 表名                  | 表字段                                                       | 功能说明     | 备注       |
| --------------------- | ------------------------------------------------------------ | ------------ | ---------- |
| auth_group            | id,name                                                      | 认证组名称   | 创建时空组 |
| auth_group_permission | id,group_id,permission_id                                    | 组和权限关联 |            |
| auth_permission       | id,name,content_type_id,code_name                            | 权限项名称   | 预创建     |
| auth_user             | id, password, last_login, is_superuser,<br/>username， first_name, last_name,email,<br/>is_staff, is_active, date_joined | 认证用户     |            |
| auth_user_groups      | id,user_id,group_id                                          | 用户和组关联 |            |
| django_admin_log      | active_time,object_id,user_id,,,                             | 管理日志     |            |
| django_content_type   | id, app_label, model                                         | 内容对象     | app>model  |
| django_migrations     | id, app,name, applied                                        | ORM记录      |            |
| django_session        | session_key, session_date, expire_date                       | 会话管理     |            |



激活认证应用-auth

```python
from django.contrib.auth.models import User, Group  #models

class UserViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows users to be viewed or edited.
    """
    queryset = User.objects.all().order_by('-date_joined')
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]
```



创建超级用户 admin（普通用户创建可以通过接口或页面上操作 ）

```shell
python manage.py createsuperuser --email admin@example.com --username admin
```



#### WSGI/ASGI部署

**WSGI部署**

```shell
# 安装gunicron
pip install gunicorn

# 启动项目
gunicorn xxxproject.wsgi
```



**ASGI部署**

ASGI服务器组件，我们有两种应用服务器可以来启动它，一种是用Uvicorn，Uvicorn是基于uvloop和httptools的ASGI服务器，它理论上是Python中最高性能的框架了。另一种是Daphne，Daphne是Django软件基金会开发的一个基于ASGI (HTTP/WebSocket)的服务器。

```SHELL
# 安装uvicorn 或者 daphne，用 daphne 代替相应的uvicorn即可。
pip install uvicorn

# 安装好之后我们用下面的命令来启动我们的项目
uvicorn django_cn.asgi:application
```



### django进阶篇

#### **1. 架构分析**

Django支持二种设计模式：MVC和MTV。这二种差别在于前端展现的template和视图view的差异，另外MTV少了URL分发的逻辑。

* MVC：Model-View-Control

* MTC: Model-Templaate-Control,  T-Tempalte模板

* MVVM:  Model-View-ViewModel

各个组件主要的职责

* Model: 模型，负责业务对象和数据对象的绑定。ORM

* View： 视图，负责业务逻辑处理，从请求中获取参数，通过ORM方式操作Model数据，将结果反馈。

* Control：控制器，负责URL路由分发，逻辑和数据转换。

* Template: 模板，用来渲染页面。

* ViewModel，视图模型，Model层之上，用来在视图里传递和处理数据的模型。


  ![1574518389091](E:/project/technical-share/media/sf_reuse/framework/frame_web_003.png)

图  django运行视图



#### 2.中间件 middleware

Django 中间件是修改 Django request 或者 response 对象的钩子，可以理解为是介于 HttpRequest 与 HttpResponse 处理之间的一道处理过程。

浏览器从请求到响应的过程中，Django 需要通过很多中间件来处理，可以看如下图所示：

![1574518414753](E:/project/technical-share/media/sf_reuse/framework/frame_web_003_02.png)

备注：核心在于 middleware（中间件），django 所有的请求、返回都由中间件来完成。中间件，就是处理 HTTP 的 request 和 response 的，类似插件，比如有 Request 中间件、view 中间件、response 中间件、exception 中间件等，Middleware 都需要在 “project/settings.py” 中 MIDDLEWARE_CLASSES 的定义。



Django 中间件作用：

- 修改请求，即传送到 view 中的 HttpRequest 对象。
- 修改响应，即 view 返回的 HttpResponse 对象。

中间件组件配置在 settings.py 文件的 MIDDLEWARE 选项列表中。

配置中的每个字符串选项都是一个类，也就是一个中间件。

Django 默认的中间件配置：

```python
MIDDLEWARE = [
  'django.middleware.security.SecurityMiddleware',
  'django.contrib.sessions.middleware.SessionMiddleware',
  'django.middleware.common.CommonMiddleware',
  'django.middleware.csrf.CsrfViewMiddleware',
  'django.contrib.auth.middleware.AuthenticationMiddleware',
  'django.contrib.messages.middleware.MessageMiddleware',
  'django.middleware.clickjacking.XFrameOptionsMiddleware',
]
```



中间件可以定义四个方法，分别是：

```python
process_request(self,request)
process_view(self, request, view_func, view_args, view_kwargs)
process_exception(self, request, exception)
process_response(self, request, response)
```



### django扩展（第三方库）

django-debug-toolbar：提供DEBUG信息，必备

django-crispy-forms：美化表单

django-extensions：各种扩展（shell、server等）

django-taggit：提供简单的打标签功能

django-braces：为类视图提供一系列Mixin

django-embed-video：为页面嵌入视频

djangorestframework：大名鼎鼎的drf，为django提供RESTful API支持

django-xadmin：一个更强大的admin后台

django-ckeditor：为表单提供富文本编辑器

django-cors-headers：为CORS提供支持



表格 Django第三方模块说明

| django模块       | 最新版本 | 功能                                                         |
| ---------------- | -------- | ------------------------------------------------------------ |
| Django自身       | 3.2.4    | 模式：MVC、MTC、MVVM<br>权限管理：                           |
| DRF              | 3.12.4   | `pip install djangorestframework` <BR>APIView、序列化和反序列化、ORM、认证和鉴权 |
| drf-yasg/coreapi | 1.20.0   | swagger标准文档。官方已废弃django-rest-swagger。             |
| gunicorn/uwsgi   |          | WSGI部署，并发支持                                           |
| uvicorn/daphne   | 0.13.4/  | ASGI部署                                                     |

> 最新版本的截止时间是2021.6



#### DRF框架 -djangorestframework

https://www.django-rest-framework.org/

简介：DRF能简化REST操作。包括序列化和反序列化操作、分页处理、认证等。

* DRF视图：继承自Django.views.View，增加了一些特殊操作，更容易管理。

* 序列化类 serialize.Serializer：序列化类可限定输出字段，可对输入字段进行检验。可用 xxserialize.is_valid()来检查序列化是否成功可用。

* 分页pagination: 根据查询参数页号和页数量，获取查询集结果，并可定制分页的响应结果。

* 认证鉴权：

  

安装：`pip install djangorestframework`

1. **DFR视图**

djangorestframework视图:   DRF提供的视图都是View的子类，特性是请求响应用DRF封装的Request/Response

```python
# django.views.generic/__init__.py
from django.views.generic.base import RedirectView, TemplateView, View
from django.views.generic.dates import (
    ArchiveIndexView, DateDetailView, DayArchiveView, MonthArchiveView,
    TodayArchiveView, WeekArchiveView, YearArchiveView,
)
from django.views.generic.detail import DetailView
from django.views.generic.edit import (
    CreateView, DeleteView, FormView, UpdateView,
)
from django.views.generic.list import ListView

__all__ = [
    'View', 'TemplateView', 'RedirectView', 'ArchiveIndexView',
    'YearArchiveView', 'MonthArchiveView', 'WeekArchiveView', 'DayArchiveView',
    'TodayArchiveView', 'DateDetailView', 'DetailView', 'FormView',
    'CreateView', 'UpdateView', 'DeleteView', 'ListView', 'GenericViewError',
]
```



**类视图的体系**

`View -> APIView -> GenericAPIView -> GenericViewSet`

* APIView:  通常会定义get/put/delete/put等方法。

* 视图集ViewSet：将操作同一组资源的处理函数放在同一个类中，这个类就是视图集。视图集中的处理函数不再以请求方式（比如：get,post等）命名，而是以对应的action操作命名，常见操作如下：list/create/retrieve/update/destory。



**序列化类的体系**

`Field ->  BaseSerializer -> Serializer -> ModelSerializer -> HyperlinkedModelSerializer`



DRF视图使用示例：

```python
# DRF视图导入 
from rest_framework.views import APIView, ViewSet
from rest_framework.response import Response
from rest_framework import serializers  # 序列化

# 1.APIView实现示例
# 三步：ORM、序列化、返回响应
class SnippetList(APIView):
	
    def get(self, request, format=None):
        snippets = Snippet.objects.all()
        serializer = SnippetSerializer(snippets, many=True)
        return Response(serializer.data)

    def post(self, request, format=None):
        serializer = SnippetSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        
        
# 2.GenericAPIView实现示例: 更简洁，继承3个类
class SnippetList(mixins.ListModelMixin,
                  mixins.CreateModelMixin,
                  generics.GenericAPIView,
                  ):
    # 通过继承GenericAPIView，对类的queryset与serializer_class属性赋值，get/post等操作就不用ORM和序列化调用了
    queryset = Snippet.objects.all()
    serializer_class = SnippetSerializer

    def get(self, request, *args, **kwargs):
        return self.list(*args, **kwargs)

    def post(self, request, *args, **kwargs):
        return self.create(*args, **kwargs)
    
# 3.ListCreateAPIView更简洁，只用继承一个类，连get/post都不用写了。
class SnippetList(generics.ListCreateAPIView):

    queryset = Snippet.objects.all()
    serializer_class = SnippetSerializer
    
# 4.ViewSet示例
class SnippetViewSet(viewsets.ModelViewSet):
    """
    This viewset automatically provides `list`, `create`, `retrieve`,
    `update` and `destroy` actions.

    Additionally we also provide an extra `highlight` action.
    """
    queryset = Snippet.objects.all()
    serializer_class = SnippetSerializer
```



2. **分页处理**

```python
from rest_framework.pagination import PageNumberPagination
# 自定义分页类
class StandardResultPagination(PageNumberPagination):
    page_size = 2  # 每页数目
    page_size_query_param = 'size'  # 每页数量的查询词
    page_query_param = 'page'  # 页号的查询词
    max_page_size = 5  # 前端最多能设置的每页数量

#使用
class OpenSceneView(APIView):
    """
    场景视图，场景列表或单个场景
    """
    pagination_class = StandardResultPagination
    def get(self, request):   
        scene = Scene.objects.all().orderby()  # 得到Queryset对象
        page_obj = StandardResultPagination()
        scene = page_obj.paginate_queryset(scene, request, view=self)
```



3. **DRF认证和鉴权 **

DRF内置的四种API认证方式：

* [BasicAuthentication](https://link.zhihu.com/?target=https%3A//www.django-rest-framework.org/api-guide/authentication/%23basicauthentication)   **每次提交请求的时候附加用户名和密码来进行认证**
* [TokenAuthentication ](https://link.zhihu.com/?target=https%3A//www.django-rest-framework.org/api-guide/authentication/%23tokenauthentication) 每次提交请求的时候在HTTP headers里附加Token进行认证
* **[SessionAuthentication](https://link.zhihu.com/?target=https%3A//www.django-rest-framework.org/api-guide/authentication/%23sessionauthentication)**  用户登录之后系统在cookies存入sessionid  进行认证
* **[RemoteUserAuthentication](https://link.zhihu.com/?target=https%3A//www.django-rest-framework.org/api-guide/authentication/%23remoteuserauthentication)**   通过web服务器认证(apache/nginx这些)



第三方认证

**[Django OAuth Toolkit](https://link.zhihu.com/?target=https%3A//www.django-rest-framework.org/api-guide/authentication/%23django-oauth-toolkit)**

**[Django REST framework OAuth](https://link.zhihu.com/?target=https%3A//www.django-rest-framework.org/api-guide/authentication/%23django-rest-framework-oauth)**

**[JSON Web Token Authentication](https://link.zhihu.com/?target=https%3A//www.django-rest-framework.org/api-guide/authentication/%23json-web-token-authentication)**



认证方式配置 settings.py

```python
REST_FRAMEWORK = {
    # 身份验证
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework.authentication.BasicAuthentication',
        'rest_framework.authentication.TokenAuthentication',
        'rest_framework.authentication.SessionAuthentication',
    )
}
```



**授权**

DRF的接口权限有以下几种：

- **[AllowAny](https://link.zhihu.com/?target=https%3A//www.django-rest-framework.org/api-guide/permissions/%23allowany)**：允许所有，登不登录无所谓
- **[IsAuthenticated](https://link.zhihu.com/?target=https%3A//www.django-rest-framework.org/api-guide/permissions/%23isauthenticated)**：登录了才能访问
- **[IsAdminUser](https://link.zhihu.com/?target=https%3A//www.django-rest-framework.org/api-guide/permissions/%23isadminuser)**：管理员才能访问
- **[IsAuthenticatedOrReadOnly](https://link.zhihu.com/?target=https%3A//www.django-rest-framework.org/api-guide/permissions/%23isauthenticatedorreadonly)**：顾名思义，不登录只读，登录才能写入
- **[DjangoModelPermissions](https://link.zhihu.com/?target=https%3A//www.django-rest-framework.org/api-guide/permissions/%23djangomodelpermissions)**：根据Django Auth的配置（权限细化到每个model）
- **[DjangoModelPermissionsOrAnonReadOnly](https://link.zhihu.com/?target=https%3A//www.django-rest-framework.org/api-guide/permissions/%23djangomodelpermissionsoranonreadonly)**
- **[DjangoObjectPermissions](https://link.zhihu.com/?target=https%3A//www.django-rest-framework.org/api-guide/permissions/%23djangoobjectpermissions)**：配合第三方权限控制，细化到每个对象



4. 路由

   使用Drf框架可以有两种路由方式，一种是Drf的路由，一直是Django的路由，两种搭配使用。



#### Django接入Swgger

Swagger是一个规范和完整的框架，用于生成、描述、调用和可视化RESTful风格的Web服务。总体目标是使客户端和文件系统源代码作为服务器以同样的速度来更新。当接口有变动时，对应的接口文档也会自动更新。

一般有3种方法：

* ~~django-rest-swagger~~（只支持djangorestframework<=3.9.2 django<3.0），2019.6起，django官方废弃。
* coreapi：比较简单的swagger， DRF默认支持。
* [drf-yasg](https://drf-yasg.readthedocs.io) (Yet another Swagger generator)，推荐使用，django推荐替换django-rest-swagger。



drf-yasg使用示例： `pip install drf-yasg`

```python
#step2: settings.py, 添加APP
INSTALLED_APPS = ['drf_yasg',]  

#step3: urls.py, 增加路径映射 get_schema_view
from rest_framework import permissions
from drf_yasg.views import get_schema_view
from drf_yasg import openapi

schema_view = get_schema_view(
    openapi.Info(
        title="平台API文档",
        default_version='v1',
        description="Welcome to ***",
        # terms_of_service="https://www.tweet.org",
        # contact=openapi.Contact(email="demo@tweet.org"),
        # license=openapi.License(name="Awesome IP"),
    ),
    public=True,
    # 我也添加了此处但是还是有权限问题
    permission_classes=(permissions.AllowAny,),
)

path('doc/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'), 
# 对开发人员更友好
path('redoc/', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),
```



API文档定义： openapi, swagger_auto_schema

```python
# 类视图需继承APIView或其子类，函数视图可用 @api_view来转化 
from drf_yasg import openapi	# 可提供自定义参数
from drf_yasg.utils import swagger_auto_schema	#用装饰器@swagger_auto_schema 来填充文档

class PolygonView(APIView):
    """ apiview return xxx """
    test_param = openapi.Parameter('test', openapi.IN_QUERY, description="test manual param", type=openapi.TYPE_BOOLEAN)	#自定义参数1
    user_response = openapi.Response('response description', UserSerializer) #响应结果 

    # 'method' can be used to customize a single HTTP method of a view
    @swagger_auto_schema(method='get', manual_parameters=[test_param], responses={200: user_response})
    def get(self, request, generate_id):
    	pass

```

swagger_auto_schema生成

```python
def swagger_auto_schema(method=None, methods=None, auto_schema=unset, request_body=None, query_serializer=None,
                        manual_parameters=None, operation_id=None, operation_description=None, operation_summary=None,
                        security=None, deprecated=None, responses=None, field_inspectors=None, filter_inspectors=None,
                        paginator_inspectors=None, tags=None, **extra_overrides):
    """Decorate a view method to customize the :class:`.Operation` object generated from it.
    request_body: 当参数位置是 in_body，要传入schema，一般用于GET方法之外
    manual_parameters：swaager里用来输入的参数，一般用于GET方法
    """
```



开放参数定义:  openapi.Parameter

```python
from drf_yasg.openapi import Parameter

class Parameter(SwaggerDict):
    def __init__(self, name, in_, description=None, required=None, schema=None,
                 type=None, format=None, enum=None, pattern=None, items=None, default=None, **extra):
     """        
     name:参数名称
     in_:参数位置，值有body, path, query, formData, header   
     type:类型，值有object ,string ,number ,integer ,boolean ,array ,file 
     format:格式，值有date, date-time, password, binary, bytes, float, double, int32, int64, email, ipv4, ipv6, uri, uuid, slug, decimal等     
     description：参数描述
     required：是否必须
     schema：当in_是body时，schema对象
     enum：(列表)  列举参数的请求值(请求值只在这几个值中)
     pattern：当 format为 string是才填此项
     items：
     default：
     """   
```





### FAQ 常见问题

1. Django2.x版本与MySQL5.6以下版本不适配！

解决方法1：修改 /site-packages/django/db/backends/mysql/operations.py

将其中的`query = query.decode(errors='replace')`改为 `query = query.encode(errors='replace')`

解决方法2：将django升级到3.x。



2. 当app目录下自动生成目录migrates里的文件过多时，可进行重置回0001__init.py

情景1： 不需要原有数据库的数据时。

```
step1. 首先删除数据库中的相关APP下的数据表
step2. 然后删除APP下的migration模块中的所有 文件，除了init.py 文件
step3. 执行下面的命令: 
python manage.py makemigrations
python manage.py migrate
```

情景2： 要保持原有数据，只想重新生成 migrates文件

```shell
#1.同步migrates文件和数据库
python manage.py makemigrations
#2.确认是否已同步, 执行后列出的文件名前面会有 [x]标记
python manage.py showmigrations
#3.重置某个app
python manage.py migrate --fake [xxapp] zero
#4.重新检查，看 app下列出的文件名前面 是否已变成 []，是则操作成功。
#另外，如果别的app表也有文件从[x]变成[]，则此app也要重置（外键的原因）
python manage.py showmigrations

#5. 上面步骤成功后，执行下面操作
#删除xxapp的migrates目录下除__init__.py的文件
rm 00*auto_*.py
python manage.py makemigrations
python manage.py migrate --fake-initial
```



### 本章参考

[1]:  Django官网	"https://docs.djangoproject.com/"

[2]:  https://www.django-rest-framework.org/	"DRF"

[3]:  Django教程 https://www.runoob.com/django/django-tutorial.html

[4]:  DRF框架知识点总结 https://blog.csdn.net/weixin_44143222/article/details/88878072

[5]:  drf-yasg官网(https://drf-yasg.readthedocs.io/)	"https://drf-yasg.readthedocs.io/"

[6]: Python3+ Django3：自动生成Swagger接口文档 https://cloud.tencent.com/developer/article/1576613

[7]: 一小时完成后台开发：DjangoRestFramework开发实践 https://zhuanlan.zhihu.com/p/113367282



## 2.2 python-Flask 

### 简介

**特性**

*  内置开发用服务器和debugger
*  集成单元测试（unit testing）
*  RESTful request dispatching
*  使用Jinja2模板引擎
*  支持secure cookies（client side sessions）
*  100% WSGI 1.0兼容
*  Unicode based
*  详细的文件、教学
*  Google App Engine兼容
*  可用Extensions增加其他功能

备注： *fabmanager*是flask的权限管理命令。

 

### flask开发篇

#### 入门实例

**安装使用**

Flask 依赖两个外部库： [Jinja2](http://jinja.pocoo.org/2/) 模板引擎和 [Werkzeug](http://werkzeug.pocoo.org/) WSGI 工具集。

**Werkzeug:** Werkzeug is an HTTP and WSGI utility library for Python. 

 ```shell
$sudo pip install flask flask-login flask-mail flask-sqlalchemy flask-wtf flask-babel flup
$ pip install Flask
$ python hello.py
* Running on http://localhost:5000/
 ```

示例：hello.py

```python
from flask import Flask
app = Flask(__name__)

@app.route("/")    # URL目录
def hello():
    return "Hello World!"

if __name__ == "__main__":
    app.run()
	# 监听所有公网IP
	app.run(host='0.0.0.0')
```

那么，这段代码做了什么？

1. 首先，我们导入了 [Flask](http://docs.jinkan.org/docs/flask/api.html#flask.Flask) 类。这个类的实例将会是我们的 WSGI 应用程序。
2. 接下来，我们创建一个该类的实例，第一个参数是应用模块或者包的名称。 如果你使用单一的模块（如本例），你应该使用 __name__ ，因为模块的名称将会因其作为单独应用启动还是作为模块导入而有不同（ 也即是 '__main__' 或实际的导入名）。这是必须的，这样 Flask 才知道到哪去找模板、静态文件等等。详情见 [Flask](http://docs.jinkan.org/docs/flask/api.html#flask.Flask) 的文档。

3. 然后，我们使用 [route()](http://docs.jinkan.org/docs/flask/api.html#flask.Flask.route) 装饰器告诉 Flask 什么样的URL 能触发我们的函数。
4. 这个函数的名字也在生成 URL 时被特定的函数采用，这个函数返回我们想要显示在用户浏览器中的信息。

5. 最后我们用 [run()](http://docs.jinkan.org/docs/flask/api.html#flask.Flask.run) 函数来让应用运行在本地服务器上。 其中 if __name__ == '__main__': 确保服务器只会在该脚本被 Python 解释器直接执行的时候才会运行，而不是作为模块导入的时候。

 

**项目结构如下**

   ![1574518502921](E:/project/technical-share/media/sf_reuse/framework/frame_web_flask_001.png)

备注：

 

### flask进阶篇

#### 路由映射原理 

flask/app.py

```python
class Flask(_PackageBoundObject): 
	def route(self, rule, **options):	#装饰器route
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
```



使用示例：

```python
@[xxapp|blureprint].route('/xx')  # 装饰器route调用，实质调用 add_url_rule
def func():
  pass
或者
def func():
  pass
xxapp.add_url_rule('/xx',viewfunc=func)  # 函数
```



#### 蓝图 Blureprint

Blueprint 是一个存储视图方法的容器，这些操作在这个Blueprint 被注册到一个应用之后就可以被调用，Flask 可以通过Blueprint来组织URL以及处理请求。

Flask使用Blueprint让应用实现模块化，在Flask中，Blueprint具有如下属性：

- 一个项目可以具有多个Blueprint
- 可以将一个Blueprint注册到任何一个未使用的URL下比如 “/”、“/sample”或者子域名
- 在一个应用中，一个模块可以注册多次
- Blueprint可以单独具有自己的模板、静态文件或者其它的通用操作方法，它并不是必须要实现应用的视图和函数的
- 在一个应用初始化时，就应该要注册需要使用的Blueprint

但是一个Blueprint并不是一个完整的应用，它不能独立于应用运行，而必须要注册到某一个应用中。

Blueprint对象用起来和一个应用/Flask对象差不多，最大的区别在于一个 蓝图对象没有办法独立运行，必须将它注册到一个应用对象上才能生效

```python
from flask import Flask, Blueprint
from rest_api_demo.database import db

flask_app = Flask(__name__)
blueprint = Blueprint('api', __name__, url_prefix='/api')
flask_app.register_blueprint(blueprint)

if __name__ == "__main__":
	flask_app.run(debug=True)
```





#### 其它

**1. 使用实例文件夹**
我们使用 app.config.from_pyfile() 来从一个实例文件夹中加载配置变量。当我们调用 Flask() 来创建我们的应用的时候，如果我们设置了 instance_relative_config=True， app.config.from_pyfile() 将会从 instance/ 目录加载指定文件。

```python
# app.py or app/__init__.py
app = Flask(__name__, instance_relative_config=True)
app.config.from_object('config')
app.config.from_pyfile('config.py')
```



### flask扩展

| 扩展组件         | 简介                                                         | 使用示例                                                     |
| ---------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| flask_restplus   | 构建restful标准的API，包含swagger UI                         |                                                              |
| flask-appbuilder | 基于Flask实现的一个用于快速构建Web后台管理系统的简单的框架。 | fabmanager [OPTIONS] COMMAND [ARGS]...                       |
| flask-login      | 登陆。                                                       |                                                              |
| flask-migrate    | 数据库迁移、升级。                                           | `$python manage.py db migrate   $python manage.py db upgrade` |
| flask-cache      | 缓存，支持redis/memcache/filesystem                          |                                                              |
| flask-script     | 命令行脚本                                                   | from flask-script import Manager   Manager().run()           |
| flask-sqlalchemy | DB的ORM模型。                                                | from flask_sqlalchemy   import SQLAlchemy<br>db =   SQLAlchemy(app) |
| flask-cors       | 跨域资源共享                                                 | CORS(app, resources=r'/*')                                   |

 

#### flask-appbuilder

Flask-AppBuilder是基于Flask实现的一个用于快速构建Web后台管理系统的简单的框架。主要用于解决构建Web后台管理系统时避免一些重复而繁琐的工作，提高项目完成时间，它可以和 Flask/Jinja2自定义的页面进行无缝集成，并且可以进行高级的配置。这个框架还集成了一些CSS和JS库，包括以下内容：

*  Google charts CSS and JS
*  BootStrap CSS and JS
*  BootsWatch Themes
*  Font-Awesome CSS and Fonts

 

1. fabmanger

Superset中的安全性由Flask AppBuilder（FAB）处理。 FAB是一个“简单快速的应用程序开发框架，构建在Flask之上”。 FAB提供身份验证，用户管理，权限和角色。

```shell
$ fabmanager --help
Usage: fabmanager [OPTIONS] COMMAND [ARGS]...

  This is a set of commands to ease the creation and maintenance of your
  flask-appbuilder applications.
  All commands that import your app will assume by default that you're
  running on your projects directory just before the app directory. They
  will also assume that __init__.py initializes AppBuilder like this (using
  a var named appbuilder) just like the skeleton app::
  appbuilder = AppBuilder(......)
  If you're using different namings use app and appbuilder parameters.

Options:
  --help  Show this message and exit.

Commands:
  babel-compile  Babel, Compiles all translations
  babel-extract  Babel, Extracts and updates all messages...
  collect-static    Copies flask-appbuilder static files to your...
  create-addon   Create a Skeleton AddOn (needs internet...
  create-admin   Creates an admin user
  create-app   Create a Skeleton application (needs internet...
  create-db    Create all your database objects (SQLAlchemy...
  list-users   List all users on the database
  list-views   List all registered views
  reset-password    Resets a user's password
  run  Runs Flask dev web server.
  security-cleanup  Cleanup unused permissions from views and...
  version   Flask-AppBuilder package version

```



**创建app目录结构**

```shell
keefe@LENOVO-PC /e/Workspaces/python.ws/flask_project
$ fabmanager create-app
Your new app name: test
Your engine type, SQLAlchemy or MongoEngine [SQLAlchemy]:
Downloaded the skeleton app, good coding!
$ find test
test
test/.gitignore
test/app
test/app/models.py
test/app/templates
test/app/templates/404.html
test/app/translations
test/app/translations/pt
test/app/translations/pt/LC_MESSAGES
test/app/translations/pt/LC_MESSAGES/messages.mo
test/app/translations/pt/LC_MESSAGES/messages.po
test/app/views.py
test/app/__init__.py
test/babel
test/babel/babel.cfg
test/babel/messages.pot
test/config.py
test/README.rst
test/run.py

# 创建管理员
fabmanager create-admin --app superset

# 运行脚本
我们可以通过fabmanager来运行生成的脚本 ，目录下缺省名称为run.py
$ fabmanager run
也可以通过Python解释器来运行
$ python3 run.py
```



1). **配置 config.py**

数据库配置

如果使用SQLAlchemy可以通过配置SQLALCHEMY_DATABASE_URI的值来指定数据库连接。如果使用Mongdb可以配置MONGODB_SETTINGS的值。默认使用Sqlite数据库，SQLALCHEMY_DATABASE_URI的值为'sqlite:///' + os.path.join(basedir, 'app.db')。

 

2). **Base Configuration**

**Configuration keys**

Use config.py to configure the following parameters. By default it will use SQLLITE DB, and bootstrap’s default theme:

| Key                                                          | Description                                                  | Mandatory |
| ------------------------------------------------------------ | ------------------------------------------------------------ | --------- |
| SQLALCHEMY_DATABASE_URI                                      | DB connection string (flask-sqlalchemy)                      | Cond.     |
| MONGODB_SETTINGS                                             | DB connection string (flask-mongoengine)                     | Cond.     |
| AUTH_TYPE   = 0 \| 1 \| 2 \| 3 \| 4   or   AUTH_TYPE   = AUTH_OID, AUTH_DB,   AUTH_LDAP,    AUTH_REMOTE   AUTH_OAUTH | This is the authentication type   0 = Open ID   1 = Database style (user/password)   2 = LDAP, use AUTH_LDAP_SERVER also   3 = uses web server environ var   REMOTE_USER   4 = USE ONE OR MANY OAUTH PROVIDERS | Yes       |
| AUTH_USER_REGISTRATION   = True\|False                       | Set to True to enable user self registration                 | No        |
| AUTH_USER_REGISTRATION_ROLE                                  | Set role name, to be assign when a user   registers himself. This role must already exist. Mandatory when using user   registration | Cond.     |
| AUTH_LDAP_SERVER                                             | define your ldap server when AUTH_TYPE=2   example:   AUTH_TYPE = 2   AUTH_LDAP_SERVER = “[ldap://ldapserver.new](ldap://ldapserver.new)” | Cond.     |
| AUTH_LDAP_BIND_USER                                          | Define the DN for the user that will be   used for the initial LDAP BIND. This is necessary for OpenLDAP and can be   used on MSFT AD.   AUTH_LDAP_BIND_USER =   “cn=queryuser,dc=example,dc=com” | No        |
| AUTH_LDAP_BIND_PASSWORD                                      | Define password for the bind user.                           | No        |
| AUTH_LDAP_SEARCH                                             | Use search with self user registration or   when using AUTH_LDAP_BIND_USER.   AUTH_LDAP_SERVER = “[ldap://ldapserver.new](ldap://ldapserver.new)”   AUTH_LDAP_SEARCH = “ou=people,dc=example” | No        |
| AUTH_LDAP_UID_FIELD                                          | if doing an indirect bind to ldap, this   is the field that matches the username when searching for the account to bind   to. example:   AUTH_TYPE = 2   AUTH_LDAP_SERVER = “[ldap://ldapserver.new](ldap://ldapserver.new)”   AUTH_LDAP_SEARCH = “ou=people,dc=example”   AUTH_LDAP_UID_FIELD = “uid” | No        |
| AUTH_LDAP_FIRSTNAME_FIELD                                    | sets the field in the ldap directory that   stores the user’s first name. This field is used to propagate user’s first   name into the User database. Default is “givenName”. example:   AUTH_TYPE = 2   AUTH_LDAP_SERVER = “[ldap://ldapserver.new](ldap://ldapserver.new)”   AUTH_LDAP_SEARCH = “ou=people,dc=example”   AUTH_LDAP_FIRSTNAME_FIELD = “givenName” | No        |
| AUTH_LDAP_LASTNAME_FIELD                                     | sets the field in the ldap directory that   stores the user’s last name. This field is used to propagate user’s last name   into the User database. Default is “sn”. example:   AUTH_TYPE = 2   AUTH_LDAP_SERVER = “[ldap://ldapserver.new](ldap://ldapserver.new)”   AUTH_LDAP_SEARCH = “ou=people,dc=example”   AUTH_LDAP_LASTNAME_FIELD = “sn” | No        |
| AUTH_LDAP_EMAIL_FIELD                                        | sets the field in the ldap directory that   stores the user’s email address. This field is used to propagate user’s emai*   address into the User database. Default is “mail”. example:   AUTH_TYPE = 2   AUTH_LDAP_SERVER = “[ldap://ldapserver.new](ldap://ldapserver.new)”   AUTH_LDAP_SEARCH = “ou=people,dc=example”   AUTH_LDAP_EMAIL_FIELD = “mail” | No        |
| AUTH_LDAP_ALLOW_SELF_SIGNED                                  | Allow LDAP authentication to use self   signed certificates  | No        |
| AUTH_LDAP_APPEND_DOMAIN                                      | Append a domain to all logins. No need to   use [john@domain.local](mailto:john%40domain.local). Set it like:   AUTH_LDAP_APPEND_DOMAIN = ‘domain.local’   And the user can login using just ‘john’ | No        |
| AUTH_LDAP_USERNAME_FORMAT                                    | It converts username to specific format   for LDAP authentications. For example,   username = “userexample”   AUTH_LDAP_USERNAME_FORMAT=”format-%s”.   It authenticates with   “format-userexample”. | No        |
| AUTH_ROLE_ADMIN                                              | Configure the name of the admin role.                        | No        |
| AUTH_ROLE_PUBLIC                                             | Special Role that holds the public   permissions, no authentication needed. | No        |
| APP_NAME                                                     | The name of your application.                                | No        |
| APP_THEME                                                    | Various themes for you to choose from   (bootwatch).         | No        |
| APP_ICON                                                     | path of your application icons will be   shown on the left side of the menu | No        |
| ADDON_MANAGERS                                               | A list of addon manager’s classes Take a   look at addon chapter on docs. | No        |
| UPLOAD_FOLDER                                                | Files upload folder. Mandatory for file   uploads.           | No        |
| FILE_ALLOWED_EXTENSIONS                                      | Tuple with allower extensions.   FILE_ALLOWED_EXTENSIONS = (‘txt’,’doc’) | No        |
| IMG_UPLOAD_FOLDER                                            | Image upload folder. Mandatory for image   uploads.          | No        |
| IMG_UPLOAD_UR*                                               | Image relative URL. Mandatory for image   uploads.           | No        |
| IMG_SIZE                                                     | tuple to define default image resize.   (width, height, True\|False). | No        |
| BABEL_DEFAULT_LOCALE                                         | Babel’s default language.                                    | No        |
| LANGUAGES                                                    | A dictionary mapping the existing   languages with th        |           |



3). 主题配置

Flask-AppBuilder集成了bootwatch，只需要配置APP_THEME的值就可以改变应用的主题风格。下面是config.py文件中可供选择的主题：

 

2. 路由定制

| 路由                         | 功能详述           | 代码文件                                   | 代码实现                                                     |
| ---------------------------- | ------------------ | ------------------------------------------ | ------------------------------------------------------------ |
| @expose(uri)                 | 在现路由上扩展路径 |                                            |                                                              |
| Baseview.   create_blueprint |                    | flask_appbuilder/baseview.py               | route_base = None   if self.route_base is None:  self.route_base = '/' + self.__class__.__name__.lower() |
| route_base                   | 路由根路径         | flask_appbuilder/views.py                  | route_base = ''                                              |
|                              |                    | flask_appbuilder/security/registerviews.py | route_base = '/register'                                     |
|                              |                    | flask_appbuilder/security/views.py         | route_base = '/users'   roles permissions viewmenus permissionviews   resetmypassword resetpassword registeruser |
|                              |                    | flask_appbuilder/babel/views.py            | route_base = '/lang'                                         |

示例：@expose('/welcome')

结果：/superset/welcome

代码实现：

```python
# superset/flask_appbuilder/baseview.py
def expose(url='/', methods=('GET',)):
    """
   Use this decorator to expose views on your view classes.
   :param url:  Relative URL for the view
   :param methods:  Allowed HTTP methods. By default only GET is allowed.
    """
    def wrap(f):
   if not hasattr(f, '_urls'):
  f._urls = []
   f._urls.append((url, methods))
   return f
    return wrap

def expose_api(name='', url='', methods=('GET',), description=''):
    def wrap(f):
   api_name = name or f.__name__
   api_url = url or "/api/{0}".format(name)
   if not hasattr(f, '_urls'):
  f._urls = []
  f._extra = {}
   f._urls.append((api_url, methods))
   f._extra[api_name] = (api_url, f.__name__, description)
   return f
    return wrap

```



3. 类图

   ![1574518633167](E:/project/technical-share/media/sf_reuse/framework/frame_web_flask_002.png)

图 4 flask-appbuilder view

 

#### flask-cache

Flask-Cache支持多个缓存后端（Redis，Memcached，SimpleCache（内存中）或本地文件系统）。

```python
# flask_cache/__init__.py
Cache()
    def init_app(self, app, config=None):
		...
   config.setdefault('CACHE_DEFAULT_TIMEOUT', 300)  # 缓存过期时间缺省300秒
   config.setdefault('CACHE_DIR', None)   # 设置缓存路径
		# null改为'filesystem'，如果是redis/memache，则需要相应的服务器支持和安装python客户端模块
   config.setdefault('CACHE_TYPE', 'null')  

```



#### flask-login

[flask-login](https://github.com/maxcountryman/flask-login)跟Flask app是一一对应关系，即一个app内只可能存在一个login manager，所以为了运行多个login manager，只能运行多个app.

 

**app dispatch技术**

[Application Dispatching](http://flask.pocoo.org/docs/0.12/patterns/appdispatch/#app-dispatch)是WSGI工具箱[werkzeug](http://werkzeug.pocoo.org/)提供的一种技术，目的是将多个Flask应用按URL前缀组合成一个应用

```python
class DispatcherMiddleware(__builtin__.object)
 |  Allows one to mount middlewares or applications in a WSGI application.
 |  This is useful if you want to combine multiple WSGI applications::
 |   app = DispatcherMiddleware(app, {
 |  '/app2':   app2,
 |  '/app3':   app3
 |   })
```

小结：app dispatch技术实现了app的隔离（独立的login manager、secret_key等），同时让每层业务系统都能模块化（只关心自己的URL部分），很有用。

 

#### flask-script

```python
# flask-script/__init__.py: Manager
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

python manage.py print
> hello

```

 

### 本节参考

[1]   [Jinja2 文档](http://jinja.pocoo.org/2/documentation/)

[2]   [Werkzeug 文档](http://werkzeug.pocoo.org/documentation/)

[3].  Building beautiful REST APIs using Flask, Swagger UI and Flask-RESTPlus https://michal.karzynski.pl/blog/2016/06/19/building-beautiful-restful-apis-using-flask-swagger-ui-flask-restplus/ 

 

## 2.3 python-Tornado

### 简介

表格 tornado版本说明

| 版本号 | 发布时间  | 功能或更新说明 |
| ------ | --------- | -------------- |
| 1.0    | 2010.7.22 |                |
| 2.0    | 2011.6.21 |                |
| 3.0    | 2013.3.29 |                |
| 4.0    | 2014.7.15 |                |
| 5.0    | 2018.3.5  |                |
| 6.0    | 2019.3.1  |                |

备注：最新版本 6.1.0，发布于2020.10.30.



### 入门篇

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



### 本节参考



# 3 Celery 异步多任务队列

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



## 入门篇

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





## 应用篇

默认情况下，默认的配置项没有针对吞吐量进行优化，默认的配置比较合适大量短任务和比较少的长任务。 如果需要优化吞吐量，请参考[`优化：Optimizing`]()。

**task**

task状态state:  PENDING  STARTED  RETRY  SUCCESS 

重试二次的状态变迁如下所示： 

PENDING -> STARTED -> RETRY -> STARTED -> RETRY -> STARTED -> SUCCESS



**故障自愈**

* worker:  *CELERY*D_MAX_TASKS_*PER_CH*ILD  重启进程
* task:  软超时soft_time_limit 和 硬超时time_limit 



## 原理篇



## 本章参考

[1]. https://www.celerycn.io/ celery中文手册



# 参考资料

**官网**

django https://www.djangoproject.com/ 

flask 官网 http://flask.pocoo.org/ 



参考链接：

[1]:  https://www.celerycn.io/  "celery中文手册"

[2]. 全面解读python web 程序的9种部署方式 https://www.cnblogs.com/flish/p/5267902.html

[3].  Flask, Tornado, GEvent组合运行与性能比较 https://blog.csdn.net/lcylln/article/details/33731183

[4].  flask中文文档 http://docs.jinkan.org/docs/flask  

[5].  初识Django框架 https://www.cnblogs.com/phennry/p/5849445.html 