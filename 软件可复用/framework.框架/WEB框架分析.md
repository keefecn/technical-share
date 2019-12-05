| 序号 | 修改时间   | 修改内容                   | 修改人 | 审稿人 |
| ---- | ---------- | -------------------------- | ------ | ------ |
| 1    | 2016-12-21 | 创建                       | 吴启福 | 吴启福 |
| 2    | 2017-1-15  | 补充各大WEB框架内容。      | 同上   |        |
| 3    | 2018-3-25  | 更新node.js                | 同上   |        |
| 4    | 2018-4-25  | 补充更新前端框架           | 同上   |        |
| 5    | 2018-7-3   | 增加Python WEB程序部署章节 | 同上   |        |
| 6    | 2018-11-18 | 汇总python web框架         | 同上   |        |
|      |            |                            |        |        |
---

 

 

 

# 目录

 

[目录... 1](#_Toc530263898)

[1       WEB框架概述... 3](#_Toc530263899)

[1.1        WEB框架列表... 3](#_Toc530263900)

[1.2        python WEB框架... 4](#_Toc530263901)

[1.3        Python WEB程序部署方式... 5](#_Toc530263902)

[1.4        本章参考... 6](#_Toc530263903)

[2       前端框架... 6](#_Toc530263904)

[2.1        模板引擎... 7](#_Toc530263905)

[2.1.1         Smarty（PHP）... 7](#_Toc530263906)

[2.1.2         Jiaja2 (Python) 8](#_Toc530263907)

[2.2        AJAX.. 8](#_Toc530263908)

[2.2.1         Prototype. 8](#_Toc530263909)

[2.2.2         JQuery. 9](#_Toc530263910)

[2.3        Bootstrap. 10](#_Toc530263911)

[2.4        View层-数据可视化... 10](#_Toc530263912)

[2.4.1         React 10](#_Toc530263913)

[2.4.2         Vue. 11](#_Toc530263914)

[2.4.3         D3/nvd3. 12](#_Toc530263915)

[2.4.4         Echarts 12](#_Toc530263916)

[2.5        本章参考... 12](#_Toc530263917)

[3       php-yil 13](#_Toc530263918)

[3.1        本章参考... 13](#_Toc530263919)

[4       node.js 13](#_Toc530263920)

[4.1        简介... 13](#_Toc530263921)

[4.2        入门实例... 14](#_Toc530263922)

[4.2.1         安装篇... 14](#_Toc530263923)

[4.2.2         示例1：hello world. 15](#_Toc530263924)

[4.2.3         示例2：sacdl-project 16](#_Toc530263925)

[4.3        技术原理篇... 16](#_Toc530263926)

[4.3.1         并发处理：事件和回调... 16](#_Toc530263927)

[4.3.2         全局对象和模块... 17](#_Toc530263928)

[4.4        相关框架：Express 18](#_Toc530263929)

[4.5        本章参考... 18](#_Toc530263930)

[5       ruby-on-rails 18](#_Toc530263931)

[5.1        入门实例... 18](#_Toc530263932)

[5.1.1         安装rails 18](#_Toc530263933)

[5.1.2         创建 Blog 程序... 19](#_Toc530263934)

[5.2        本章参考... 20](#_Toc530263935)

[6       python-Tornado. 21](#_Toc530263936)

[6.1        本章参考... 21](#_Toc530263937)

[7       python-Django. 21](#_Toc530263938)

[7.1        入门实例... 21](#_Toc530263939)

[7.2        架构分析... 23](#_Toc530263940)

[7.3        本章参考... 25](#_Toc530263941)

[8       python-Flask. 25](#_Toc530263942)

[8.1        简介... 25](#_Toc530263943)

[8.2        flask使用篇... 25](#_Toc530263944)

[8.2.1         入门实例... 25](#_Toc530263945)

[8.2.2         项目结构... 27](#_Toc530263946)

[8.3        flask开发篇... 27](#_Toc530263947)

[8.4        flask架构篇... 28](#_Toc530263948)

[9       python-flask扩展... 28](#_Toc530263949)

[9.1        flask-appbuilder 28](#_Toc530263950)

[9.1.1         fabmanger 29](#_Toc530263951)

[9.1.2         配置 config.py. 30](#_Toc530263952)

[9.1.3         路由定制... 34](#_Toc530263953)

[9.1.4         类图... 36](#_Toc530263954)

[9.2        flask-cache. 37](#_Toc530263955)

[9.3        flask-login. 37](#_Toc530263956)

[9.4        flask-script 37](#_Toc530263957)

[9.5        本章参考... 38](#_Toc530263958)

[参考资料... 38](#_Toc530263959)

[附录... 39](#_Toc530263960)

 








# 1       WEB框架概述

## 1.1     WEB框架列表

表格 1 WEB常用框架列表

| 开发   语言 | 框架   名称 | 简介                                                         | 优点                               | 缺点            |
| ----------- | ----------- | ------------------------------------------------------------ | ---------------------------------- | --------------- |
| php         | yii         | 一个基于组件、用于开发大型 Web 应用的高性能 PHP 框架，是一个 MVC 的框架。Yii是创始人薛强的心血结晶，于2008年1月1日开始开发。 | 优异的性能，丰富的功能和清晰的文档 |                 |
| php         | symfony     | 一个基于MVC模式的面向对象的PHP5[框架](http://baike.so.com/doc/1863840-1971314.html)。Symfony允许在一个web应用中分离事务控制，服务逻辑和表示层。 |                                    |                 |
| php         | codeigniter | 一套给PHP网站开发者使用的应用程序开发框架和工具包。在最小化，最轻量级的开发包中得到最大的执行效率、功能和灵活性。   CodeIgniter是由Ellislab公司的CEO RickEllis开发的。 | 动态实例化。松耦合。组件专一性。   |                 |
| javascript  | nodejs      | Node.js是建立在谷歌Chrome的JavaScript引擎(V8引擎)的Web应用程序框架。 | 数据密集型。                       | CPU密集型慎用。 |
| js          | express     | Express是一个最小的，灵活的Node.js Web应用程序框架，它提供了一套强大的功能来开发Web和移动应用程序。 它有助于基于Node Web应用程序的快速开发。 |                                    |                 |
| js          | **JXcore**  | 引入了包装和源文件和其他资源加密成JX包一个独特的功能。       |                                    |                 |
| ruby        | rails       | Rails 是使用 Ruby 语言编写的网页程序开发框架，目的是为开发者提供常用组件，简化网页程序的开发。只需编写较少的代码，就能实现其他编程语言或框架难以企及的功能。 |                                    |                 |
| ruby        | jekyll      | 一个支持markdown和liquid模板语言的静态站点生成器，作为github项目的标配页面。 | 很适合作BLOG。                     |                 |
| java        | grails      | 基于Groovy编程语言，并构建于Spring、Hibernate等开源框架之上，是一个高[生产](http://baike.so.com/doc/5381738-5618075.html)力一站式框架。 | 插件系统                           |                 |
| java        | scooter     |                                                              |                                    |                 |
| java        | jsp/servlet |                                                              |                                    |                 |
| java        | SSH         | (spring/structs/hibernate)                                   |                                    |                 |
| java        | struts      |                                                              |                                    |                 |
| java        | spring MVC  |                                                              |                                    |                 |
| perl        | catalyst    | 一个用 Perl 语言开发的 MVC 框架。                            |                                    |                 |
| scala       | lift        | 一个非常优雅的web框架，基于Scala编程语言，使用Apache 2.0 license许可发布。 | 可伸缩应用服务器                   |                 |
| scala       | scalatra    |                                                              |                                    |                 |

**说明**：当前有许多框架可用，敏捷开发中有时并不需自己设计框架，利用已知框架或者在编程过程重构代码中产生框架。这听起来有些荒谬，事实上这正是大多数公司在开发中所采用的模式。

 

表格 2 WEB框架列表

| softwareName  | Desc                                                         | currnet   version                                            | Copyright(c)                                                | License                                                   | Note                    |
| ------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ----------------------------------------------------------- | --------------------------------------------------------- | ----------------------- |
| Ruby On Rails | an [open source](http://en.wikipedia.org/wiki/Open_source) [web application framework](http://en.wikipedia.org/wiki/Web_application_framework) | [2.3.8 released May 25,   2010](http://rubyonrails.org/download) | 2005…,   [Rails Core Team](http://www.rubyonrails.com/core) | [MIT](http://www.opensource.org/licenses/mit-license.php) | http://rubyonrails.org/ |

 

## 1.2     python WEB框架

表格 3 python WEB框架列表

| 框架                                                         | 简介                                                         | 特性                               |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ---------------------------------- |
| [Django](https://www.djangoproject.com/download/)            | 一个开源的重量级Web框架，并且采用MVC设计模式。它源自一个在线新闻 Web 站点，于 2005 年以开源的形式被释放出来。 | 简便、快速的开发数据库驱动的网站。 |
| [flask](http://flask.pocoo.org/)                             | 使用 [Python](http://baike.so.com/doc/1790119-1892991.html) 编写的轻量级 Web 应用框架。其 [WSGI](http://baike.so.com/doc/1142343-1208497.html) 工具箱采用 Werkzeug ，[模板引擎](http://baike.so.com/doc/5846906-6059743.html)则使用 Jinja2 。Flask使用 BSD 授权。 | 使用简单的核心。                   |
| tornado                                                      | 使用Python编写出来的一个极轻量级、高可伸缩性和非阻塞IO的Web服务器软件。   著名的Friendfeed 网站就是使用它搭建的。 |                                    |
| [Zope 2](http://zope2.zope.org/releases)                     | 一款基于Python的Web应用框架，是所有Python Web应用程序、工具的鼻祖，是Python家族一个强有力的分支。Zope 2的“对象发布”系统非常适合面向对象开发方法，并且可以减轻开发者的学习曲线，还可以帮助你发现应用程序里一些不好的功能。 |                                    |
| [Web2py](http://web2py.com/examples/default/download)        | 一个用Python语言编写的免费的开源Web框架，旨在敏捷快速的开发Web应用，具有快速、可扩展、安全以及可移植的数据库驱动的应用，遵循LGPLv3开源协议。   　　Web2py提供一站式的解决方案，整个开发过程都可以在浏览器上进行，提供了Web版的在线开发，HTML模版编写，静态文件的上传，数据库的编写的功能。其它的还有日志功能，以及一个自动化的admin接口。 | 推荐                               |
| [Web.py](http://webpy.org/install)                           | 一个轻量级的开源Python Web框架，小巧灵活、简单并且非常强大，在使用时没有任何限制。目前Web.py被广泛运用在许多大型网站，如西班牙的社交网站Frinki、主页日平均访问量达7000万次的Yandex等。 |                                    |
| [Pyramid](http://www.pylonsproject.org/projects/pyramid/download) | 一款轻量级的开源Python Web框架，是Pylons项目的一部分。Pyramid只能运行在Python 2.x或2.4以后的版本上。在使用后端数据库时无需声明，在开发时也不会强制使用一些特定的模板系统。 |                                    |
| pylons                                                       | 对WSGI标准进行了扩展应用，提升了重用性且将功能分割到独立的模块中。 |                                    |
| [CubicWeb](http://docs.cubicweb.org/admin/setup)             | 不仅是一个Web开发框架，而且还是一款语义Web开发框架。CubicWeb使用关系查询语言（RQL Relation Query Language）与数据库之间进行通信。 |                                    |
| [turbogears](http://www.turbogears.org/)                     | 一个可以扩展为全栈解决方案的微型框架。                       |                                    |

 

表格 4 python WEB框架比较

|                  |          | 性能 nums/sec |         | 依赖组件                                            | 启动方式                       |
| ---------------- | -------- | ------------- | ------- | --------------------------------------------------- | ------------------------------ |
| 框架名           | 代码行数 | 单进程        | 并发100 |                                                     |                                |
| Django           | 120K     | 255           | x       | babel(10k)                                          | python manger.py runserver     |
| Tornago          | 42K      | 387           | 918     |                                                     |                                |
| Flask            | 6.5K     | 342           | 1694    | Jinjia2(12k), <br>MarkupSafe(22k),  <br>click(6.6k) | python xx.py                   |
| uwsgi + Django   |          | 280           | 2947    |                                                     |                                |
| uwsgi + Flask    |          | 343           | 4651    |                                                     | uwsgi --wsgi-file <file>       |
| gunicorn + Flask |          |               |         |                                                     | gunicorn -w 2 <filename.Flask> |

备注：uwsgi启动4个工作进程。uwsgi使用C实现性能更高，gunicorn更易使用。

 

## 1.3     Python WEB程序部署方式

表格 5 Python WEB程序部署方式比较

| 部署方式                                       | 简介                                                         | 优缺点                                                       | 备注   |
| ---------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------ |
| mod_python                                     | apache内置的模块。                                           | 很严重的依赖于mod_python编译使用的python版本。               | 不推荐 |
| cgi                                            |                                                              | nginx不支持。                                                | 太老   |
| fastcgi                                        | 通过flup模块支持。                                           | 长连接方式。                                                 |        |
| spawn-fcgi                                     | fastcgi多进程管理程序，lighttpd安装包附带的。                | spawn-fcgi用途很广，可以支持任意语言开发的代码。             |        |
| scgi                                           | 全名是Simple   Common Gateway Interface，也是cgi的替代版本。 | 没推广。                                                     |        |
| http                                           | nginx使用proxy_pass转发。                                    | 这个要求后端appplication必须内置一个能处理高并发的http server |        |
| uwsgi                                          | nginx从0.8.4开始内置支持uwsgi协议。                          | 自带的进程控制程序。                                         | 推荐   |
| [gunicorn](http://gunicorn.org/)               | 类似uwsgi, 从rails的部署工具(Unicorn)移植过来的。            | python2.5时定义的官方标准([PEP 333](http://lutaf.com/j?u=http://www.python.org/dev/peps/pep-0333/) )。 | 推荐   |
| [mod_wsgi](https://code.google.com/p/modwsgi/) | apache的一个module，也是支持WSGI协议。                       |                                                              |        |

备注：

## 1.4     本章参考

[1].    6种Web框架测评 http://www.alrond.com/en/2007/jan/25/performance-test-of-6-leading-frameworks/ 

[2].    全面解读python web 程序的9种部署方式 https://www.cnblogs.com/flish/p/5267902.html 

# 2       前端框架

前端框架主要指HTML+CSS+JS组成的框架库。此外还包括模板引擎。

表格 6 前端框架列表

| 语言   | 框架名称                                              | 简介                                                         | 特性                                                         |
| ------ | ----------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| php    | Smarty                                                | 一个php模板引擎。更准确的说,它分开了逻辑程序和外在的内容,提供了一种易于管理的方法。 |                                                              |
| python | Jinja2                                                | 设计思想来源于[Django](https://baike.baidu.com/item/Django/61531)的模板引擎，并扩展了其语法和一系列强大的功能。 | 完全支持[unicode](https://baike.baidu.com/item/unicode)，并具有集成的沙箱执行环境 |
| J2EE   | [Freemarker](https://baike.baidu.com/item/Freemarker) |                                                              |                                                              |
| JS     | Bootstrap                                             | 来自 Twitter，目前最受欢迎的前端框架。                       |                                                              |
| JS     | JQuery                                                | 轻量级好用的AJAX开发框架。                                   |                                                              |
| JS     | Prototype                                             | 轻量级好用的AJAX开发框架。                                   | 功能实用而且尺寸较小，适合中小型的Web应用。                  |
| JS     | D3                                                    | Data-Driven Documents，数据可视化框架。                      |                                                              |
| JS     | React                                                 | 起源于 Facebook，用来构建UI。                                |                                                              |
| JS     | Vue                                                   | 构建用户界面的渐进式框架。                                   | 只关注视图层， 采用自底向上增量开发的设计。                  |
| JS     | ECharts                                               | 百度开源的商业级数据图表。缩写来自Enterprise Charts。        |                                                              |

 

## 2.1     前端框架概述

前端开发模式的演进，觉得主要有四个阶段。

1)    基于模板渲染的动态页面：此阶段无前后端的分离。

2)    基于 AJAX 的前后端分离：2005~。20015年AJAX出现，开始出现前端工程师职位。

3)    基于 Node.js 的前端工程化：2009~。2009年Node.js出现，随着 Node.js 一同出现的还有 CommonJS 规范和 npm 包管理机制。随后也出现了 Grunt、Gulp、Webpack 等一系列基于 Node.js 的前端开发构建工具。2013 年前后，前端三大框架 React.js/Angular/Vue.js 相继发布第一个版本。前端开发开始变得规范化、标准化、工程化。

4)   基于 Node.js 的全栈开发。随着微服务的兴起，在微服务和前端中间，加了一个 BFFF（Backend For Frontend） 层，由 BFF 对接口进行聚合、裁剪后，再输出给前端。

 

## 2.2     模板引擎

### 2.2.1   Smarty（PHP）

  Smarty的特点之一是"模板编译"。意思是Smarty读取模板文件然后用他们创建php脚本。这些脚本创建以后将被执行。因此并没有花费模板文件的语法解析,同时每个模板可以享受到诸如Zend加速器(http://www.zend.com ) 或者PHP加速器(http://www.php-accelerator.co.uk )。这样的php编译器高速缓存解决方案。

Smaty的一些特点:

*  非常非常的快!

*  用php分析器干这个苦差事是有效的

*  不需要多余的模板语法解析,仅仅是编译一次
*  仅对修改过的模板文件进行重新编译
*  可以编辑'自定义函数'和自定义'变量',因此这种模板语言完全可以扩展
*  可以自行设置模板定界符,所以你可以使用{}, {{}}, <!--{}-->, 等等
*  诸如 if/elseif/else/endif 语句可以被传递到php语法解析器,所以 {if ...} 表达式是简单的或者是复合的,随你喜欢啦
*  如果允许的话,section之间可以无限嵌套
*  引擎是可以定制的.可以内嵌php代码到你的模板文件中,虽然这可能并不需要(不推荐)
*  内建缓存支持
*  独立模板文件
*  可自定义缓存处理函数
*  插件体系结构

 

安装Smarty发行版在/libs/目录

**Smarty库文件**

Smarty.class.php

Smarty_Compiler.class.php

Config_File.class.php

debug.tpl

/core/*.php (all of them)

/plugins/*.php (all of them)

 

**一个smarty的应用实例：**

法1：使用全路径

`require('/usr/local/lib/php/Smarty/Smarty.class.php');`

法2：使用'SMARTY_DIR'的php常量作为它的系统库目录

```php
define('SMARTY_DIR','/usr/local/lib/php/Smarty/');
require(SMARTY_DIR.'Smarty.class.php');
```

法3：使用库路径

```php
require('Smarty.class.php');
$smarty = new Smarty;
```

创建index.tpl文件让smarty载入.这个文件放在 $template_dir目录里

{* Smarty *}

Hello, {$name}!

说明：{* *}为注释。

实例：

```php
require('Smarty.class.php');
$smarty = new Smarty;
$smarty->assign('name','Ned');
$smarty->display('index.tpl');
```

结果：

在浏览器打开 index.php,你应该看到"Hello, Porky!"

### 2.2.2   Jiaja2 (Python)

Jinja2是基于[python](https://baike.baidu.com/item/python)的[模板引擎](https://baike.baidu.com/item/模板引擎)，功能比较类似于于[PHP](https://baike.baidu.com/item/PHP/9337)的[smarty](https://baike.baidu.com/item/smarty)，[J2ee](https://baike.baidu.com/item/J2ee)的[Freemarker](https://baike.baidu.com/item/Freemarker)和[velocity](https://baike.baidu.com/item/velocity)。 它能完全支持[unicode](https://baike.baidu.com/item/unicode)，并具有集成的沙箱执行环境，应用广泛。jinja2使用[BSD](https://baike.baidu.com/item/BSD)授权。

Jinja2是Python下一个被广泛应用的模版引擎，他的设计思想来源于[Django](https://baike.baidu.com/item/Django/61531)的模板引擎，并扩展了其语法和一系列强大的功能。其中最显著的一个是增加了沙箱执行功能和可选的自动转义功能，这对大多应用的安全性来说是非常重要的。

 

Jinja is Beautiful

```jinja2
{% extends "layout.html" %}
{% block body %}
  <ul>
  {% for user in users %}
    <li><a href="{{ user.url }}">{{ user.username }}</a></li>
  {% endfor %}
  </ul>
{% endblock %}
```

 

## 2.3     AJAX

### 2.3.1   Prototype

Prototype是目前应用广泛的AJAX开发框架，其的特点是功能实用而且尺寸较小，非常适合在中小型的Web应用中使用。

[Prototype.js](http://baike.baidu.com/view/1112205.htm)是由Sam Stephenson写的一个javascript类库。该框架的设计思路巧妙，而且兼容标准的类库，能够帮助开发人员轻松建立有[交互性](http://baike.baidu.com/subview/4889540/4890306.htm)良好的web2.0特性[富客户端](http://baike.baidu.com/view/1330363.htm)页面。

开发Ajax应用需要编写大量的客户端JavaScript脚本，而Prototype框架可以大大地简化JavaScript代码的编写工作。更难得的是，Prototype具备兼容各个浏览器的优秀特性，使用该框架可以不必考虑[浏览器兼容性](http://baike.baidu.com/subview/6746126/6874381.htm)的问题。

Prototype对JavaScript的内置对象（如“String”对象、“[Array](http://baike.baidu.com/subview/120900/120900.htm)”对象等）进行了很多有用的扩展，同时该框架中也新增了不少自定义的对象，包括对Ajax开发的支持等都是在自定义对象中实现的。Prototype可以帮助开发人员实现以下的目标：

（1）对字符串进行各种处理

（2）使用枚举的方式访问集合对象

（3）以更简单的方式进行常见的DOM操作

（4）使用[CSS选择符](http://baike.baidu.com/subview/1414548/1414548.htm)定位页面元素

（5）发起Ajax方式的[HTTP请求](http://baike.baidu.com/subview/641736/641736.htm)并对响应进行处理

（6）监听DOM事件并对事件进行处理
 　　“Prototype”框架功能详解—使用实用函数，“Prototype”框架的实现仅仅包含一个JavaScript即可，1.6版本的“[Prototype.js](http://baike.baidu.com/subview/1112205/1112205.htm)”的文件大小为127K字节，约4220行。在页面中应用的语法类似于：

<script
type=”text/javascript” src=”inc"js"Prototype.js” ></script>

然后就可以在后继的脚本中享受该框架带来的便利了。

 

该框架中有很多预定义的对象和实用函数，可以将程序员从重复的打字中解放出来。

（1）使用“$()”函数。

（2）使用“$F()”函数。此函数是另一个大受欢迎的“快捷键”，能用于返回任何表单输入控件的值，比如[多行文本框](http://baike.baidu.com/subview/3144766/3144766.htm)和下拉[列表框](http://baike.baidu.com/subview/1143828/1143828.htm)等控件。此个方法也能用元素id或元素本身做为参数。

（3）使用“$A()”函数。此函数能将其接收到的单个的参数转换成一个Array对象。

（4）使用“$H()”函数。此函数把一些对象转换成一个可枚举的和联合数组类似的[Hash](http://baike.baidu.com/subview/20089/20089.htm)对象。

（5）使用“$R()”函数。此函数是“new ObjectRange(lowBound,upperBound,excludeBounds)”的缩写，用于建立一个范围对象。

（6）使用“Try.these()”函数。“Try.these()” 方法用于调用不同的方法直到其中的一个成功。此函数把一系列的方法作为参数，并且按顺序的一个一个的执行这些方法，直到其中的一个成功执行。返回成功执行 的那个方法的返回值。“Try.these()”函数可以用于处理兼容性问题。

 

### 2.3.2   JQuery

JQuery是继[Prototype](http://baike.baidu.com/view/1217697.htm)之后又一个优秀的[Javascript](http://baike.baidu.com/view/16168.htm)库。它是轻量级的js库 ，它兼容[CSS3](http://baike.baidu.com/view/1713027.htm)，还兼容各种浏览器（[IE](http://baike.baidu.com/subview/703/10271308.htm) 6.0+, [FF](http://baike.baidu.com/subview/31049/5089479.htm) 1.5+, [Safari](http://baike.baidu.com/subview/110484/5036395.htm) 2.0+, [Opera](http://baike.baidu.com/subview/10019/7098372.htm) 9.0+），JQuery2.0及后续版本将不再支持IE6/7/8浏览器。JQuery使用户能更方便地处理[HTML](http://baike.baidu.com/view/692.htm)（[标准通用标记语言](http://baike.baidu.com/view/5286041.htm)下的一个应用）、events、实现动画效果，并且方便地为网站提供[AJAX](http://baike.baidu.com/subview/1641/5762264.htm)交互。JQuery还有一个比较大的优势是，它的文档说明很全，而且各种应用也说得很详细，同时还有许多成熟的[插件](http://baike.baidu.com/view/18979.htm)可供选择。JQuery能够使用户的html页面保持代码和html内容分离，也就是说，不用再在html里面插入一堆js来调用命令了，只需要定义id即可。

JQuery是一个兼容多浏览器的[javascript](http://baike.baidu.com/view/16168.htm)库，核心理念是write less,do more(写得更少,做得更多)。JQuery在2006年1月由美国人[John Resig](http://baike.baidu.com/view/3141971.htm)在纽约的[barcamp](http://baike.baidu.com/view/1135515.htm)发布，吸引了来自世界各地的众多JavaScript高手加入，由Dave Methvin率领团队进行开发。如今，JQuery已经成为最流行的javascript库，在世界前10000个访问最多的网站中，有超过55%在使用JQuery。

JQuery是免费、开源的，使用[MIT](http://baike.baidu.com/subview/74918/8382747.htm)许可协议。JQuery的语法设计可以使开发更加便捷，例如操作[文档](http://baike.baidu.com/view/55621.htm)对象、选择[DOM](http://baike.baidu.com/view/14806.htm)元素、制作动画效果、事件处理、使用[Ajax](http://baike.baidu.com/view/1641.htm)以及其他功能。除此以外，JQuery提供API让开发者编写插件。其模块化的使用方式使开发者可以很轻松的开发出功能强大的静态或动态网页。

JQuery，顾名思义，也就是JavaScript和查询（Query），即是辅助JavaScript开发的库。

 

## 2.4     Bootstrap 

Bootstrap来自 Twitter，是目前最受欢迎的前端框架。Bootstrap 是基于 HTML、CSS、JAVASCRIPT 的，它简洁灵活，使得 Web 开发更加快捷。

 

 

## 2.5     View层-数据可视化

### 2.5.1   React

React 是一个用于构建用户界面的 JAVASCRIPT 库。React主要用于构建UI，很多人认为 React 是 MVC 中的 V（视图）。

React 起源于 Facebook 的内部项目，用来架设 Instagram 的网站，并于 2013 年 5 月开源。

React 拥有较高的性能，代码逻辑非常简单，越来越多的人已开始关注和使用它。

 

**React** **特点**

1.声明式设计  −React采用声明范式，可以轻松描述应用。

2.高效  −React通过对DOM的模拟，最大限度地减少与DOM的交互。

3.灵活  −React可以与已知的库或框架很好地配合。

4.JSX  −JSX 是 JavaScript 语法的扩展。React 开发不一定使用 JSX ，但我们建议使用它。

5.组件Component   −通过 React 构建组件，使得代码更加容易得到复用，能够很好的应用在大项目的开发中。

6.单向响应的数据流  −React 实现了单向响应（父组件流向子组件）的数据流，从而减少了重复代码，这也是它为什么比传统数据绑定更简单。通过prop和state来实现。

 

\# 第一个例子

```xml
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Hello React!</title>
    <script src="https://cdn.bootcss.com/react/15.4.2/react.min.js"></script>
    <script src="https://cdn.bootcss.com/react/15.4.2/react-dom.min.js"></script>
    <script src="https://cdn.bootcss.com/babel-standalone/6.22.1/babel.min.js"></script>
  </head>
  <body>
    <div id="example"></div>
    <script type="text/babel">
      ReactDOM.render(
        <h1>Hello world!</h1>,
        document.getElementById('example')
      );
    </script>
  </body>
</html>
```



### 2.5.2   Vue

Vue.js（读音 /vjuː/, 类似于 view） 是一套构建用户界面的渐进式框架。

Vue 只关注视图层， 采用自底向上增量开发的设计。

Vue 的目标是通过尽可能简单的 API 实现响应的数据绑定和组合的视图组件。



第一个例子

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Vue 测试实例 - 菜鸟教程(runoob.com)</title>
<script src="https://cdn.bootcss.com/vue/2.2.2/vue.min.js"></script>
</head>
<body>
<div id="app">
  <p>{{ message }}</p>
</div>

<script>
new Vue({
  el: '#app',
  data: {
    message: 'Hello Vue.js!'
  }
})
</script>
</body>
</html>
```



### 2.5.3   D3/nvd3

D3 的全称是（Data-Driven Documents），顾名思义可以知道是一个**被数据驱动的文档**。听名字有点抽象，说简单一点，其实就是一个 JavaScript 的函数库，使用它主要是用来做数据可视化的。

D3 是一个开源项目，作者是纽约时报的工程师。D3 项目的代码托管于 GitHub。

\# 引用D3

<script src="http://d3js.org/d3.v3.min.js"
charset="utf-8"></script>

 

nvd3就基于D3的实现。

 

### 2.5.4   Echarts

http://echarts.baidu.com/echarts2/doc/doc.html

ECharts，缩写来自Enterprise Charts，商业级数据图表，一个纯Javascript的图表库，可以流畅的运行在PC和移动设备上，兼容当前绝大部分浏览器（IE6/7/8/9/10/11，chrome，firefox，Safari等），底层依赖轻量级的Canvas类库[ZRender](http://ecomfe.github.io/zrender/)，提供直观，生动，可交互，可高度个性化定制的数据可视化图表。创新的拖拽重计算、数据视图、值域漫游等特性大大增强了用户体验，赋予了用户对数据进行挖掘、整合的能力。

支持折线图（区域图）、柱状图（条状图）、散点图（气泡图）、K线图、饼图（环形图）、雷达图（填充雷达图）、和弦图、力导向布局图、地图、仪表盘、漏斗图、事件河流图等12类图表，同时提供标题，详情气泡、图例、值域、数据区域、时间轴、工具箱等7个可交互组件，支持多图表、组件的联动和混搭展现。

 ![1574518011899](../../media/sf_reuse/framework/frame_web_ehart_01.png)

​                                                  

 

## 2.6     Serverless

Serverless = FaaS + BaaS。
*  FaaS（Function as a Service） 就是一些运行函数的平台，比如阿里云的函数计算、AWS 的 Lambda 等。
*  BaaS（Backend as a Service）则是一些后端云服务，比如云数据库、对象存储、消息队列等。利用 BaaS，可以极大简化我们的应用开发难度。

Serverless 的主要特点有：
*  事件驱动
*  函数在 FaaS 平台中，需要通过一系列的事件来驱动函数执行。
*  无状态
*  因为每次函数执行，可能使用的都是不同的容器，无法进行内存或数据共享。如果要共享数据，则只能通过第三方服务，比如 Redis 等。
*  无运维
*  使用 Serverless 我们不需要关心服务器，不需要关心运维。这也是 Serverless 思想的核心。
*  低成本
*  使用 Serverless 成本很低，因为我们只需要为每次函数的运行付费。函数不运行，则不花钱，也不会浪费服务器资源

   ![1574518037319](../../media/sf_reuse/framework/frame_web_001.png)

图 1 Serverless 服务中的前端解决方案架构图

 

 

## 2.7     本章参考

*  Bootstrap  [http://www.runoob.com/try/Bootstrap](http://www.runoob.com/try/bootstrap) 
*  http://react-china.org/ 
*  React 教程 http://www.runoob.com/react/react-tutorial.html 
*  vue http://www.runoob.com/vue2/vue-tutorial.html 
*  知乎ServerLess https://zhuanlan.zhihu.com/p/65914436

# 3       php-yil

Yii 的很多想法来自其他著名 Web 编程框架和应用程序。下面是一个简短的清单。

*  [Prado](http://baike.so.com/doc/6747126-6961672.html):这是 Yii 的主要思想来源。Yii 采用了基于组件和[事件驱动](http://baike.so.com/doc/357634-378877.html)编程模式，[数据库抽象层](http://baike.so.com/doc/1667709-1763258.html)，模块化的应用架构，国际化和本地化，和许多它的其他特点和功能。
*  Ruby on Rails:Yii 继承它的配置的思想。还引用它的 [Active Record](http://baike.so.com/doc/1518150-1605059.html)的 ORM设计模式。
*  JQuery:这是集成在 Yii 为基础的 JavaScript 框架。
*  Symfony:Yii 引用它的过滤设计和[插件](http://baike.so.com/doc/1483288-1568456.html)架构。
*  Joomla:Yii 引用其模块化设计和信息翻译方案。


## 3.1     本章参考

 

# 4       node.js

## 4.1     简介

Node.js是建立在谷歌Chrome的JavaScript引擎(V8引擎)的Web应用程序框架。Node.js在[官方网站](https://nodejs.org/)的定义文件内容如下：

Node.js® is a platform built on [Chrome's JavaScript runtime](http://code.google.com/p/v8/) for easily building fast, scalable network applications. Node.js uses an event-driven, non-blocking I/O model that makes it lightweight and efficient, perfect for data-intensive real-time applications that run across distributed devices.

Node.js自带运行时环境可在Javascript脚本的基础上可以解释和执行(这类似于JVM的Java字节码)。这个运行时允许在浏览器以外的任何机器上执行JavaScript代码。由于这种运行时在Node.js上，所以JavaScript现在可以在服务器上执行。

Node.js还提供了各种丰富的JavaScript模块库，它极大简化了使用Node.js来扩展Web应用程序的研究与开发。

**Node.js =** **运行环境+ JavaScript库**

 

下图描述了 Node.js 的一些重要组成部分

   ![1574518074852](../../media/sf_reuse/framework/frame_web_nodejs_01.png)

图 2 Node.js Concept

 

**在哪里可以使用Node.js？**

以下是Node.js证明自己完美的技术的合作伙伴的领域。
*  I/O 绑定应用程序
*  数据流应用
*  数据密集型实时应用(DIRT)
*  JSON API的应用程序
*  单页面应用

 

**在哪些地方不要使用Node.js？**

不建议使用Node.js的就是针对CPU密集型应用。

 

**与node.js** **相关的工具**

*  gulp 基于 node 实现 Web 前端自动化开发的工具，利用它能够极大的提高开发效率。

*  ghost  node.js和ghost安装配置工具

*  grunt  node.js自动化项目构建工具

## 4.2     入门实例

### 4.2.1   安装篇

linux用nvm安装和管理Node.js

表格 7 node.js常用工具列表

| 工具        | 简介                                                         | 安装                                                         | 使用                                    |
| ----------- | ------------------------------------------------------------ | ------------------------------------------------------------ | --------------------------------------- |
| node.js     | 建立在谷歌Chrome的JavaScript引擎(V8引擎)的Web应用程序框架。最新版本8.11.3 | `nvm install 5.1.0`   或者<br>`apt-get install nodejs`       | node -v                                 |
| npm/   cnpm | 用来安装npm包。cnpm为中国区。                                |                                                              | npm -v   npm install   [xxx]            |
| nvm         | node.js的包管理工具。                                        | curl  -o https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh \|   bash | nvm  --version   nvm install [version]  |
| bower       | npm包，前端管理工具，专门用来管理WEB前端依赖包（JS/CSS/IMAGES/fonts） | npm  install bower                                           | # 初始化生成bower.json   $ bower   init |
| gulp        | nodejs代码部署发布工具。                                     | npm install gulp --global  npm install gulp --save-dev       | gulp [js_pipe]   gulp deploy            |

备注：cnpm类似npm，只是源在中国。

 

表格 8 node.js常用插件或npm包

| 工具    | 简介                        | 安装                          | 使用 |
| ------- | --------------------------- | ----------------------------- | ---- |
| D3.js   | 数据可视化前端开发包。      | bower install d3 --save       |      |
| Express | 基于node.js的框架。脚手架。 | npm install express--save-dev |      |
| ejs     | 模板引擎                    |                               |      |
| github  | github   api                |                               |      |
|         |                             |                               |      |
|         |                             |                               |      |

备注：参数选项--save-dev为保存到开发目录。

1. npm包安装： npm/cnpm install [npm]--save-dev

2. 前端相关的包安装:  bower install [npm] --save

 

### 4.2.2   示例1：hello world

Node.js应用程序由以下三个重要部分组成：
*  导入所需模块: 使用require指令来加载javascript模块
*  创建一个服务器: 服务器这将听监听在Apache HTTP服务器客户端的请求。
*  读取请求并返回响应： 在前面的步骤中创建的服务器将响应读取由客户机发出的HTTP请求(可以是一个浏览器或控制台)并返回响应。

 文件 helloworld.js

```javascript
var http = require("http")
http.createServer(function (request, response) {  
   response.writeHead(200, {'Content-Type': 'text/plain'});  
   response.end('Hello World\n');
}).listen(8081);
console.log('Server running at http://127.0.0.1:8081/');
```



现在执行helloworld.js来启动服务器，如下：

`$ node helloworld.js`

在任何浏览器中打开地址：http://127.0.0.1:8081/，看看下面的结果。

 

### 4.2.3   示例2：sacdl-project

源码：https://github.com/imfly/sacdl-project 

演示：http://imfly.github.io/sacdl-project/ 

SDCDL是加密货币开发语言统计分析, Statistical Analysis of Cryptocurrency Development Languages，是[《Nodejs开发加密货币》](https://github.com/imfly/bitcoin-on-nodejs) 入门部门实例程序。是一个基于gihub的Api进行二次开发的统计分析工具。

 

**功能**

*  自定义搜索。可以代替github针对版本库的高级搜索，自定义搜索任何关键字（不限于加密货币）;

*  数据可视化。可以输出列表、柱状图、矩阵图等交互性视图，方便、直观;

*  扩展性能好。集成了d3.js，可以根据自己喜好，添加和定制任何视图样式; ...

*  开发

 ```shell
# 安装依赖包
git clone https://github.com/imfly/sacdl-project.git
cd sacdl-project
npm install   # 自动查找package.json里依赖包并安装
bower install

# 构建代码
gulp 
# 部署到 gh-pages
gulp deploy
 ```



## 4.3     技术原理篇

### 4.3.1   并发处理：事件和回调

Node JS是单线程应用程序，但它通过事件和回调概念，支持并发。 由于Node JS每一个API是异步的，作为一个单独的线程，它使用异步函数调用，以保持并发性。Node JS使用观察者模式。Node线程保持一个事件循环，每当任何任务得到完成，它触发这标志着该事件侦听器函数执行相应的事件。

 

**什么是回调?**

回调是一个异步等效的功能。在完成特定任务回调函数被调用。 Node大量使用了回调。Node的所有的API都支持回调这样的一种方式。

 

**事件**

Node.js运行在一个单线程模式，但它使用一个事件驱动范例来处理并发。它还有助于创建子进程，以充分利用并行处理的多核CPU系统。

子进程总是有三个流child.stdin，child.stdout和child.stderr这可能与父进程stdio流共享。

Node提供child_process模块，该模块具有以下三个主要的方法来创建子进程。
*  exec - child_process.exec方法在shell/控制台运行一个命令并缓冲输出。
*  spawn - child_process.spawn启动一个新的过程，一个给定的指令
*  fork - child_process.fork方法是指定spawn()来创建子进程的一个特例。

 

### 4.3.2   全局对象和模块

Node.js的全局对象是具有全局性的，它们可在所有的模块中应用。我们并不需要包括这些对象在应用中，而可以直接使用它们。这些对象的模块，函数，字符串和对象本身，如下所述。

表格 9 node.js全局对象列表

| 全局对象            | 简介                                                         | 备注 |
| ------------------- | ------------------------------------------------------------ | ---- |
| __filename          | 表示正在执行的代码的文件名，解析绝对路径。                   |      |
| __dirname           | 表示当前正在执行的脚本所在目录的名称。                       |      |
| setTimeout(cb, ms)  | 用于至少毫秒毫秒后运行回调cb。实际延迟取决于外部因素，如OS计时器粒度和系统负载。计时器不能跨越超过24.8天。 |      |
| clearTimeout(t)     | 用来停止以前用的setTimeout()创建一个定时器。这里t是由setTimeout()函数返回的计时器。 |      |
| setInterval(cb, ms) | 用来至少毫秒后重复运行回调cb。实际延迟取决于外部因素，如OS计时器粒度和系统负载。计时器不能跨越超过24.8天。 |      |
|                     |                                                              |      |

 

表格 10 node.js内置模块列表

| 模块    | 简介                                                        | 备注 |
| ------- | ----------------------------------------------------------- | ---- |
| Console | 用于打印输出和错误信息                                      |      |
| Process | 用于获取当前进程的信息。提供处理活动有关的多个事件          |      |
| OS      | 提供基本的操作系统相关的实用功能                            |      |
| Path    | 提供工具，用于处理和转换文件的路径                          |      |
| NET     | 提供服务器和客户端的数据流。充当网络包装                    |      |
| DNS     | 提供做实际DNS查询的功能，以及使用底层操作系统的名称解析功能 |      |
| Domain  | 提供一个方式来处理多个不同的I/O操作，作为一个组             |      |

 

## 4.4     相关框架：Express

**Express**

Express是一个最小的，灵活的Node.js Web应用程序框架，它提供了一套强大的功能来开发Web和移动应用程序。 它有助于基于Node Web应用程序的快速开发。下面是一些Express框架的核心功能：

*  允许设立中间件响应HTTP请求

*  定义了用于执行基于HTTP方法和URL不同动作的路由表

*  允许动态渲染基于参数传递给模板HTML页面

 

## 4.5     本章参考

[1].Node.js 教程 https://www.runoob.com/nodejs/nodejs-tutorial.html

 

# vue

## vue-cli

Vue CLI 是一个基于 Vue.js 进行快速开发的完整系统，提供：

- 通过 `@vue/cli` 搭建交互式的项目脚手架。
- 通过 `@vue/cli` + `@vue/cli-service-global` 快速开始零配置原型开发。
- 一个运行时依赖 (@vue/cli-service)，该依赖：
  - 可升级；
  - 基于 webpack 构建，并带有合理的默认配置；
  - 可以通过项目内的配置文件进行配置；
  - 可以通过插件进行扩展。
- 一个丰富的官方插件集合，集成了前端生态中最好的工具。
- 一套完全图形化的创建和管理 Vue.js 项目的用户界面。

CLI 服务是构建于 [webpack](http://webpack.js.org/)[ ](http://webpack.js.org/) 和 [webpack-dev-server](https://github.com/webpack/webpack-dev-server)[ ](https://github.com/webpack/webpack-dev-server) 之上的。它包含了：

- 加载其它 CLI 插件的核心服务；
- 一个针对绝大部分应用优化过的内部的 webpack 配置；
- 项目内部的 `vue-cli-service` 命令，提供 `serve`、`build` 和 `inspect` 命令。



![img](E:\project\technical-share\media\sf_reuse\framework\frame_vue_001.png)

vue生命周期示意图



## vue项目结构      

**package.json** :  npm init产生。本地项目的包定义文件。

```json
{ 
 "author": "keefe <wuqifu@gmail.com>", 
 "name": "hello", 
 "description": "A example for write a module", 
 "version": "0.0.1", 
 "repository": { 
 "url": ""
 }, 
 "main": "hello.js", 
 "engines": { 
 "node": "*"
 }, 
 "dependencies": {}, 
 "devDependencies": {} 
} 
```

nodejs/vue项目典型结构如下图

![https://www.runoob.com/wp-content/uploads/2016/10/1476690721-1278-854231-ea029fb82e865d5d.jpg](E:\project\technical-share\media\sf_reuse\framework\frame_nodejs_01.png)

vue项目结构说明表

| 一级目录或文件    | 二级目录或文件 | 说明                                                         |
| ----------------- | -------------- | ------------------------------------------------------------ |
| node_modules      |                | 项目全局模块目录 -g                                          |
| src               |                |                                                              |
|                   | assets         | 静态资源目录                                                 |
|                   | component      | 组件目录，里面文件类似app.vue格式                            |
|                   | app.vue        | 项目入口文件。定义vue的template、script、style               |
|                   | main.js        | 项目的核心文件                                               |
| .babelrc          |                |                                                              |
| package.json      |                | 项目的包定义文件，包括依赖组件、脚本等。npm init [proj] 时初始化。 |
| package-lock.json |                | `npm install`时候生成一份文件，用以记录当前状态下实际安装的各个npm package的具体来源和版本号。不能update依赖组件。 |
| webpack.config.js |                |                                                              |
|                   |                |                                                              |
|                   |                |                                                              |

```vue
# App.uve, 导入其它地方定义的vue组件 
<script>
import firstcomponent from './component/firstcomponent.vue'
</script>
```



## 本章参考

[1]: Vue2.0 新手入门 — 从环境搭建到发布 https://www.runoob.com/w3cnote/vue2-start-coding.html



# 5. ruby-on-rails

## 5.1     入门实例

### 5.1.1   安装rails

必需安装软件

·         [Ruby](https://www.ruby-lang.org/en/downloads) 1.9.3 及以上版本

·         包管理工具 [RubyGems](https://rubygems.org/)，随 Ruby 1.9+ 安装。想深入了解 RubyGems，请阅读 [RubyGems 指南](http://guides.rubygems.org/)

·         [SQLite3](https://www.sqlite.org/) 数据库

 

安装：

```shell
$ sudo apt-get install ruby sqlite
$ gem install rails
```

### 5.1.2   创建 Blog 程序

Rails 提供了多个被称为“生成器”的脚本，可以简化开发，生成某项操作需要的所有文件。其中一个是新程序生成器，生成一个 Rails 程序骨架，不用自己一个一个新建文件。

打开终端，进入有写权限的文件夹，执行以下命令生成一个新程序：

// 1.会在文件夹 blog 中新建一个Rails 程序

$ rails new blog

// 2.安装 Gemfile 中列出的 gem。

$ bundle install 

// 3.生成 blog 程序后，进入该文件夹：



执行 rails new -h 可以查看新程序生成器的所有命令行选项。

blog 文件夹中有很多自动生成的文件和文件夹，组成一个 Rails 程序。本文大部分时间都花在 app 文件夹上。下面简单介绍默认生成的文件和文件夹的作用：

| 文件/文件夹           | 作用                                                         |
| --------------------- | ------------------------------------------------------------ |
| app/                  | 存放程序的控制器、模型、视图、帮助方法、邮件和静态资源文件。本文主要关注的是这个文件夹。 |
| bin/                  | 存放运行程序的 rails 脚本，以及其他用来部署或运行程序的脚本。 |
| config/               | 设置程序的路由，数据库等。详情参阅“[设置   Rails 程序](http://guides.ruby-china.org/configuring.html)”一文。 |
| config.rl             | 基于 Rack 服务器的程序设置，用来启动程序。                   |
| db/                   | 存放当前数据库的模式，以及数据库迁移文件。                   |
| Gemfile, Gemfile.lock | 这两个文件用来指定程序所需的 gem 依赖件，用于 Bundler gem。关于 Bundler 的详细介绍，请访问 [Bundler 官网](http://bundler.io/)。 |
| lib/                  | 程序的扩展模块。                                             |
| log/                  | 程序的日志文件。                                             |
| public/               | 唯一对外开放的文件夹，存放静态文件和编译后的资源文件。       |
| Rakefile              | 保存并加载可在命令行中执行的任务。任务在 Rails 的各组件中定义。如果想添加自己的任务，不要修改这个文件，把任务保存在 lib/tasks 文件夹中。 |
| README.rdoc           | 程序的简单说明。你应该修改这个文件，告诉其他人这个程序的作用，如何安装等。 |
| test/                 | 单元测试，固件等测试用文件。详情参阅“[测试   Rails 程序](http://guides.ruby-china.org/testing.html)”一文。 |
| tmp/                  | 临时文件，例如缓存，PID，会话文件。                          |
| vendor/               | 存放第三方代码。经常用来放第三方 gem。                       |

 

**启动服务器**

$ rails server

上述命令会启动 WEBrick，这是 Ruby 内置的服务器。要查看程序，请打开一个浏览器窗口，访问[http://localhost:3000](http://localhost:3000/)。应该会看到默认的 Rails 信息页面。

   ![1574518237085](../../media/sf_reuse/framework/frame_web_002.png)

 

## 5.2     本章参考

 

# 6       python-Tornado

## 6.1     本章参考

 

# 7       python-Django

Django是一个开放源代码的Web应用框架，由Python写成。 

Django遵守BSD版权，初次发布于2005年7月, 并于2008年9月发布了第一个正式版本1.0 。

Django采用了MVC的软件设计模式，即模型M，视图V和控制器C。

框架本身集成了ORM、模型绑定、模板引擎、缓存、Session等诸多功能。

 

## 7.1     入门实例

**Django安装**

```shell
$ pip install django          #安装最新版本的Django
$ pip install -v django==1.7.1   #或者指定安装版本
```



**命令行创建项目** (示例项目名mysite)

`$ django-admin.py startproject mysite`

Django将自动生成下面的目录结构：

```shell
mysite/
├── manage.py           # Django管理主程序
├── mysite
│   ├── __init__.py
│   ├── settings.py     # 主配置文件
│   ├── urls.py        	# URL路由系统文件
│   └── wsgi.py       	# 网络通信接口
└── template            # 该目录放置HTML文件模板
```

**创建APP** （示例app名为cmdb）

在每个Django项目中可以包含多个APP，相当于一个大型项目中的分系统、子模块、功能部件等等，相互之间比较独立，但也有联系，所有的APP共享项目资源。

```shell
$ python manage.py startapp cmdb
cmdb/
├── admin.py      
├── apps.py       
├── __init__.py
├── migrations
│   └── __init__.py
├── models.py    
├── tests.py	
└── views.py	# 页面

```

**4、编写路由规则**

路由都在urls文件里，它将浏览器的URL映射到响应的业务处理逻辑。

```python
# urls.py
from django.conf.urls import url
from django.contrib import admin
from cmdb import views
 
urlpatterns = [
    #url(r'^admin/', admin.site.urls),
    url(r'^index/', views.index),
]
```

 

**5、编写业务处理逻辑views**

```python
# views.py
from django.shortcuts import render
#首先导入HttpResponse模块
from django.shortcuts import HttpResponse
# Create your views here.
def index(request):
    """
    :param request: 这个参数必须有，类似self的默认规则，可以改，它封装了用户请求的所有内容
    :return: 不能直接返回字符串，必须有HttpResponse这个类封装起来，这是Django的规则
    """
    return HttpResponse("Hello,World")

```

**运行Web服务**

$ python manage.py runserver 127.0.0.1 8080

访问地址：http://127.0.0.1:8000/index/ 可以看到我们定义的返回结果"Hello,World"。

 django服务启动的同时，会启动两个进程，一个负责监控文件的变化，一个是主进程，如果文件发生变化，则会将退出当前进程，重新启动一个子进程。要想避免监控文件变化，加参数--noreload。



## 7.2     架构分析

   

   ![1574518389091](../../media/sf_reuse/framework/frame_web_003.png)

图 3 django组件视图

![1574518414753](../../media/sf_reuse/framework/frame_web_003_02.png)

备注：核心在于 middleware（中间件），django 所有的请求、返回都由中间件来完成。中间件，就是处理 HTTP 的 request 和 response 的，类似插件，比如有 Request 中间件、view 中间件、response 中间件、exception 中间件等，Middleware 都需要在 “project/settings.py” 中 MIDDLEWARE_CLASSES 的定义。

## 7.3     本章参考

[1]:  Django教程 https://www.runoob.com/django/django-tutorial.html



# 8       python-Flask 

## 8.1     简介

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

 

## 8.2     flask使用篇

### 8.2.1   入门实例

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

1)        首先，我们导入了 [Flask](http://docs.jinkan.org/docs/flask/api.html#flask.Flask) 类。这个类的实例将会是我们的 WSGI 应用程序。

2)        接下来，我们创建一个该类的实例，第一个参数是应用模块或者包的名称。 如果你使用单一的模块（如本例），你应该使用 __name__ ，因为模块的名称将会因其作为单独应用启动还是作为模块导入而有不同（ 也即是 '__main__' 或实际的导入名）。这是必须的，这样 Flask 才知道到哪去找模板、静态文件等等。详情见 [Flask](http://docs.jinkan.org/docs/flask/api.html#flask.Flask) 的文档。

3)        然后，我们使用 [route()](http://docs.jinkan.org/docs/flask/api.html#flask.Flask.route) 装饰器告诉 Flask 什么样的URL 能触发我们的函数。

4)        这个函数的名字也在生成 URL 时被特定的函数采用，这个函数返回我们想要显示在用户浏览器中的信息。

5)        最后我们用 [run()](http://docs.jinkan.org/docs/flask/api.html#flask.Flask.run) 函数来让应用运行在本地服务器上。 其中 if __name__ == '__main__': 确保服务器只会在该脚本被 Python 解释器直接执行的时候才会运行，而不是作为模块导入的时候。

 

### 8.2.2   项目结构

   ![1574518502921](../../media/sf_reuse/framework/frame_web_flask_001.png)

备注：

 

## 8.3     flask开发篇

使用实例文件夹
 我们使用 app.config.from_pyfile() 来从一个实例文件夹中加载配置变量。当我们调用 Flask() 来创建我们的应用的时候，如果我们设置了 instance_relative_config=True， app.config.from_pyfile() 将会从 instance/ 目录加载指定文件。

```python
# app.py or app/__init__.py
app = Flask(__name__, instance_relative_config=True)
app.config.from_object('config')
app.config.from_pyfile('config.py')
```



## 8.4     flask架构篇

 

# 9       python-flask扩展

| 扩展组件         | 简介                                                         | 主要功能                                                     |
| ---------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| flask-appbuilder | 基于Flask实现的一个用于快速构建Web后台管理系统的简单的框架。 | fabmanager [OPTIONS] COMMAND [ARGS]...                       |
| flask-login      | 登陆。                                                       |                                                              |
| flask-migrate    | 数据库迁移、升级。                                           | $python manage.py db migrate   $python manage.py db upgrade  |
| flask-cache      | 缓存，支持redis/memcache/filesystem                          |                                                              |
| flask-script     | 命令行脚本                                                   | from flask-script import Manager   Manager().run()           |
| flask-sqlalchemy | DB的ORM模型。                                                | from flask_sqlalchemy   import SQLAlchemy   db =   SQLAlchemy(app) |
| flask-cors       | 跨域资源共享                                                 | CORS(app, resources=r'/*')                                   |
|                  |                                                              |                                                              |
|                  |                                                              |                                                              |

 

## 9.1     flask-appbuilder

Flask-AppBuilder是基于Flask实现的一个用于快速构建Web后台管理系统的简单的框架。主要用于解决构建Web后台管理系统时避免一些重复而繁琐的工作，提高项目完成时间，它可以和 Flask/Jinja2自定义的页面进行无缝集成，并且可以进行高级的配置。这个框架还集成了一些CSS和JS库，包括以下内容：
*  Google charts CSS and JS
*  BootStrap CSS and JS
*  BootsWatch Themes
*  Font-Awesome CSS and Fonts

 

### 9.1.1   fabmanger

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
  babel-compile     Babel, Compiles all translations
  babel-extract     Babel, Extracts and updates all messages...
  collect-static    Copies flask-appbuilder static files to your...
  create-addon      Create a Skeleton AddOn (needs internet...
  create-admin      Creates an admin user
  create-app        Create a Skeleton application (needs internet...
  create-db         Create all your database objects (SQLAlchemy...
  list-users        List all users on the database
  list-views        List all registered views
  reset-password    Resets a user's password
  run               Runs Flask dev web server.
  security-cleanup  Cleanup unused permissions from views and...
  version           Flask-AppBuilder package version

```



**#** **创建app目录结构**

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



### 9.1.2   配置 config.py

#### 数据库配置

如果使用SQLAlchemy可以通过配置SQLALCHEMY_DATABASE_URI的值来指定数据库连接。如果使用Mongdb可以配置MONGODB_SETTINGS的值。默认使用Sqlite数据库，SQLALCHEMY_DATABASE_URI的值为'sqlite:///' + os.path.join(basedir, 'app.db')。

 

#### Base Configuration

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

 

#### 主题配置

Flask-AppBuilder集成了bootwatch，只需要配置APP_THEME的值就可以改变应用的主题风格。下面是config.py文件中可供选择的主题：

 

### 9.1.3   路由定制

| 路由                         | 功能详述           | 代码文件                                   | 代码实现                                                     |
| ---------------------------- | ------------------ | ------------------------------------------ | ------------------------------------------------------------ |
| @expose(uri)                 | 在现路由上扩展路径 |                                            |                                                              |
| Baseview.   create_blueprint |                    | flask_appbuilder/baseview.py               | route_base = None   if self.route_base is None:     self.route_base = '/' + self.__class__.__name__.lower() |
| route_base                   | 路由根路径         | flask_appbuilder/views.py                  | route_base = ''                                              |
|                              |                    | flask_appbuilder/security/registerviews.py | route_base = '/register'                                     |
|                              |                    | flask_appbuilder/security/views.py         | route_base = '/users'   roles permissions viewmenus permissionviews   resetmypassword resetpassword registeruser |
|                              |                    | flask_appbuilder/babel/views.py            | route_base = '/lang'                                         |
|                              |                    |                                            |                                                              |

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



### 9.1.4   类图

   ![1574518633167](../../media/sf_reuse/framework/frame_web_flask_002.png)

图 4 flask-appbuilder view

 

## 9.2     flask-cache

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



## 9.3     flask-login

[flask-login](https://github.com/maxcountryman/flask-login)跟Flask app是一一对应关系，即一个app内只可能存在一个login manager，所以为了运行多个login manager，只能运行多个app.

 

**app dispatch技术**

[Application Dispatching](http://flask.pocoo.org/docs/0.12/patterns/appdispatch/#app-dispatch)是WSGI工具箱[werkzeug](http://werkzeug.pocoo.org/)提供的一种技术，目的是将多个Flask应用按URL前缀组合成一个应用

```python
class DispatcherMiddleware(__builtin__.object)
 |  Allows one to mount middlewares or applications in a WSGI application.
 |  This is useful if you want to combine multiple WSGI applications::
 |      app = DispatcherMiddleware(app, {
 |          '/app2':        app2,
 |          '/app3':        app3
 |      })
```

小结：app dispatch技术实现了app的隔离（独立的login manager、secret_key等），同时让每层业务系统都能模块化（只关心自己的URL部分），很有用。

 

## 9.4     flask-script

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

 

## 9.5     本章参考

[1]      [Jinja2 文档](http://jinja.pocoo.org/2/documentation/)

[2]      [Werkzeug 文档](http://werkzeug.pocoo.org/documentation/)

 

# 参考资料

**官网**

*  [node.js](https://nodejs.org/)官方网站 https://nodejs.org/ 
*  [Ruby 语言官方网站](https://www.ruby-lang.org/zh_cn/documentation/)
*  flask 官网 http://flask.pocoo.org/ 
*  Ruby on Rails 指南 http://guides.ruby-china.org/
*  [RubyGems 指南](http://guides.rubygems.org/)
*  django https://www.djangoproject.com/ 


**前端框架官网**

*  [Twitter Bootstrap](http://getbootstrap.com/) - Bootstrap 的官方网站 http://getbootstrap.com/ 
*  JQuery  [http://JQuery.com/](http://jquery.com/)  
*  jinja  http://jinja.pocoo.org/ 
*  React https://reactjs.org/ 
*  Prototypejs  [http://www.Prototypejs.org/](http://www.prototypejs.org/) 
*  D3 https://d3js.org/ 
*  nvd3 http://nvd3.org/examples/
*  echarts  http://echarts.baidu.com/echarts2/doc/doc.html 

 

**参考文献**

[1].    W3shools http://www.w3school.com.cn/

[2].    菜鸟教程 http://www.runoob.com/ 

[3].    Node.js快速入门 http://www.yiibai.com/nodejs/nodejs-quick-start.html

[4].    Smarty教程http://www.yiibai.com/smarty/ 

[5].    https://github.com/jobbole/awesome-python-cn 

[6].    flask中文文档 http://docs.jinkan.org/docs/flask  

[7].    [Less](http://www.w3cschool.cc/manual/lessguide/) - Less 快速入门

[8].    初识Django框架 https://www.cnblogs.com/phennry/p/5849445.html 

 

# 附录

 