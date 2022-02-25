| 序号 | 修改时间   | 修改内容    | 修改人 | 审稿人 |
| ---- | ---------- | -------------------------- | ------ | ------ |
| 1    | 2016-12-21 | 创建   | Keefe | Keefe |
| 2    | 2017-1-15  | 补充各大WEB框架内容。   | 同上   |   |
| 3    | 2018-3-25  | 更新node.js   | 同上   |   |
| 4    | 2018-4-25  | 补充更新前端框架   | 同上   |   |
| 5    | 2018-7-3   | 增加Python WEB程序部署章节 | 同上   |   |
| 6    | 2018-11-18 | 汇总python web框架    | 同上   |   |
| 7    | 2019-12-15 | 迁移前端框架/Nodejs另文    | 同上   |   |
| 8 | 2021-6-8 | 补充django/flask/tornado章节内容 | 同上 | |









<br>

---

# 目录

[TOC]



<br>

---


# 1  WEB框架概述

## 1.1  WEB框架列表

表格 1 WEB常用框架列表

| 开发   语言 | 框架   名称 | 简介    | 优点   | 缺点  |
| ----------- | ----------- | ------------------------------------------------------------ | ---------------------------------- | --------------- |
| php    | yii    | 一个基于组件、用于开发大型 Web 应用的高性能 PHP 框架，是一个 MVC 的框架。Yii是创始人薛强的心血结晶，于2008年1月1日开始开发。 | 优异的性能，丰富的功能和清晰的文档 |  |
| php    | symfony  | 一个基于MVC模式的面向对象的PHP5[框架](http://baike.so.com/doc/1863840-1971314.html)。Symfony允许在一个web应用中分离事务控制，服务逻辑和表示层。 |   |  |
| php    | codeigniter | 一套给PHP网站开发者使用的应用程序开发框架和工具包。在最小化，最轻量级的开发包中得到最大的执行效率、功能和灵活性。   CodeIgniter是由Ellislab公司的CEO RickEllis开发的。 | 动态实例化。松耦合。组件专一性。   |  |
| javascript  | nodejs   | Node.js是建立在谷歌Chrome的JavaScript引擎(V8引擎)的Web应用程序框架。 | 数据密集型。   | CPU密集型慎用。 |
| js  | express  | Express是一个最小的，灵活的Node.js Web应用程序框架，它提供了一套强大的功能来开发Web和移动应用程序。 它有助于基于Node Web应用程序的快速开发。 |   |  |
| js  | **JXcore**  | 引入了包装和源文件和其他资源加密成JX包一个独特的功能。  |   |  |
| ruby   | rails  | Rails 是使用 Ruby 语言编写的网页程序开发框架，目的是为开发者提供常用组件，简化网页程序的开发。只需编写较少的代码，就能实现其他编程语言或框架难以企及的功能。 |   |  |
| ruby   | jekyll   | 一个支持markdown和liquid模板语言的静态站点生成器，作为github项目的标配页面。 | 很适合作BLOG。   |  |
| java   | grails   | 基于Groovy编程语言，并构建于Spring、Hibernate等开源框架之上，是一个高[生产](http://baike.so.com/doc/5381738-5618075.html)力一站式框架。 | 插件系统    |  |
| java   | scooter  |    |   |  |
| java   | jsp/servlet |    |   |  |
| java   | SSH    | (spring/structs/hibernate)  |   |  |
| java   | struts   |    |   |  |
| java   | spring MVC  |    |   |  |
| perl   | catalyst    | 一个用 Perl 语言开发的 MVC 框架。   |   |  |
| scala  | lift   | 一个非常优雅的web框架，基于Scala编程语言，使用Apache 2.0 license许可发布。 | 可伸缩应用服务器    |  |
| scala  | scalatra    |    |   |  |

**说明**：当前有许多框架可用，敏捷开发中有时并不需自己设计框架，利用已知框架或者在编程过程重构代码中产生框架。这听起来有些荒谬，事实上这正是大多数公司在开发中所采用的模式。



表格 2 WEB框架详细信息

| softwareName  | Desc    | currnet   version    | Copyright(c)     | License   | Note  |
| ------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ----------------------------------------------------------- | --------------------------------------------------------- | ----------------------- |
| Ruby On Rails | an [open source](http://en.wikipedia.org/wiki/Open_source) [web application framework](http://en.wikipedia.org/wiki/Web_application_framework) | [2.3.8 released May 25,   2010](http://rubyonrails.org/download) | 2005…,   [Rails Core Team](http://www.rubyonrails.com/core) | [MIT](http://www.opensource.org/licenses/mit-license.php) | http://rubyonrails.org/ |



### python WEB框架

详见 《[python框架分析](python框架分析.md)》web框架章节。



## 1.2  WEB程序部署方式

表格 5 Python WEB程序部署方式比较

| 部署方式    | 简介    | 优缺点    | 备注   |
| ---------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------ |
| mod_python    | apache内置的模块。     | 很严重的依赖于mod_python编译使用的python版本。  | 不推荐 |
| cgi    |    | nginx不支持。     | 太老   |
| fastcgi  | 通过flup模块支持。     | 长连接方式。    |   |
| spawn-fcgi    | fastcgi多进程管理程序，lighttpd安装包附带的。   | spawn-fcgi用途很广，可以支持任意语言开发的代码。   |   |
| scgi     | 全名是Simple   Common Gateway Interface，也是cgi的替代版本。 | 没推广。     |   |
| http     | nginx使用proxy_pass转发。   | 这个要求后端appplication必须内置一个能处理高并发的http server |   |
| uwsgi    | nginx从0.8.4开始内置支持uwsgi协议。   | 自带的进程控制程序。   | 推荐   |
| [gunicorn](http://gunicorn.org/)  | 类似uwsgi, 从rails的部署工具(Unicorn)移植过来的。  | python2.5时定义的官方标准([PEP 333](http://lutaf.com/j?u=http://www.python.org/dev/peps/pep-0333/) )。 | 推荐   |
| [mod_wsgi](https://code.google.com/p/modwsgi/) | apache的一个module，也是支持WSGI协议。   |    |   |

备注：



## 1.3 WEB框架性能

[Web Framework Benchmarks](https://www.techempower.com/benchmarks/)

表格 性能排名前20的WEB框架（2021.2， https://www.techempower.com/benchmarks/）

| Rnk  | Framework              | Best performance (higher is better) | Errors | Cls  | Lng  | Plt  | FE   | Aos  | DB   | Dos  | Orm  | IA   |      |
| ---- | ---------------------- | ----------------------------------- | ------ | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| 1    | drogon-core            | 666,737                             | 100.0% | 0    | Ful  | C++  | Non  | Non  | Lin  | Pg   | Lin  | Raw  | Rea  |
| 2    | lithium-postgres-batch | 659,850                             | 99.0%  | 0    | Mcr  | C++  | Non  | Non  | Lin  | Pg   | Lin  | Ful  | Rea  |
| 3    | ntex [sailfish]        | 655,964                             | 98.4%  | 0    | Mcr  | rs   | Non  | nte  | Lin  | Pg   | Lin  | Raw  | Rea  |
| 4    | ntex [db]              | 654,073                             | 98.1%  | 0    | Mcr  | rs   | Non  | nte  | Lin  | Pg   | Lin  | Raw  | Rea  |
| 5    | actix-core             | 653,529                             | 98.0%  | 0    | Plt  | rs   | Non  | act  | Lin  | Pg   | Lin  | Raw  | Rea  |
| 6    | actix-pg               | 612,258                             | 91.8%  | 0    | Mcr  | rs   | Non  | act  | Lin  | Pg   | Lin  | Raw  | Rea  |
| 7    | drogon                 | 552,293                             | 82.8%  | 0    | Ful  | C++  | Non  | Non  | Lin  | Pg   | Lin  | Mcr  | Rea  |
| 8    | may-minihttp           | 489,691                             | 73.4%  | 0    | Mcr  | rs   | rs   | may  | Lin  | Pg   | Lin  | Raw  | Rea  |
| 9    | just-js                | 467,321                             | 70.1%  | 0    | Plt  | JS   | jus  | Non  | Lin  | Pg   | Lin  | Raw  | Rea  |
| 10   | jooby-pgclient         | 423,234                             | 63.5%  | 0    | Ful  | Jav  | Utw  | Non  | Lin  | Pg   | Lin  | Raw  | Rea  |
| 11   | h2o                    | 405,560                             | 60.8%  | 0    | Plt  | C    | Non  | h2o  | Lin  | Pg   | Lin  | Raw  | Rea  |
| 12   | aspcore-ado-pg         | 400,987                             | 60.1%  | 0    | Plt  | C#   | .NE  | kes  | Lin  | Pg   | Lin  | Raw  | Rea  |
| 13   | lithium-postgres-beta  | 398,773                             | 59.8%  | 0    | Mcr  | C++  | Non  | Non  | Lin  | Pg   | Lin  | Ful  | Rea  |
| 14   | lithium-postgres       | 398,258                             | 59.7%  | 0    | Mcr  | C++  | Non  | Non  | Lin  | Pg   | Lin  | Ful  | Rea  |
| 15   | atreugo-prefork        | 393,762                             | 59.1%  | 0    | Plt  | Go   | Non  | Non  | Lin  | Pg   | Lin  | Raw  | Rea  |
| 16   | fasthttp-prefork       | 392,188                             | 58.8%  | 0    | Plt  | Go   | Non  | Non  | Lin  | Pg   | Lin  | Raw  | Rea  |
| 17   | fiber-prefork          | 379,787                             | 57.0%  | 0    | Plt  | Go   | Non  | Non  | Lin  | Pg   | Lin  | Raw  | Rea  |
| 18   | beetlex-core           | 371,228                             | 55.7%  | 0    | Plt  | C#   | .NE  | bee  | Lin  | Pg   | Lin  | Raw  | Rea  |
| 19   | hyper-db               | 364,707                             | 54.7%  | 0    | Mcr  | rs   | rs   | hyp  | Lin  | Pg   | Lin  | Raw  | Rea  |
| 20   | php-ngx-pgsql          | 362,947                             | 54.4%  | 0    | Plt  | PHP  | ngx  | ngx  | Lin  | Pg   | Lin  | Raw  | Rea  |

备注： 框架分类-Fullstack/Micro/none/Platform.





<br>

## 本章参考

[1]. [Web Framework Benchmarks](https://www.techempower.com/benchmarks/#section=data-r17&hw=ph&test=fortune) https://www.techempower.com/benchmarks/

[2]. 6种Web框架测评 http://www.alrond.com/en/2007/jan/25/performance-test-of-6-leading-frameworks/



<br>

# 2 前端框架

详见 《[前端框架分析](前端框架分析.md)》



<br>

# 3   php-yil

Yii 的很多想法来自其他著名 Web 编程框架和应用程序。下面是一个简短的清单。

*  [Prado](http://baike.so.com/doc/6747126-6961672.html):这是 Yii 的主要思想来源。Yii 采用了基于组件和[事件驱动](http://baike.so.com/doc/357634-378877.html)编程模式，[数据库抽象层](http://baike.so.com/doc/1667709-1763258.html)，模块化的应用架构，国际化和本地化，和许多它的其他特点和功能。
*  Ruby on Rails:Yii 继承它的配置的思想。还引用它的 [Active Record](http://baike.so.com/doc/1518150-1605059.html)的 ORM设计模式。
*  JQuery:这是集成在 Yii 为基础的 JavaScript 框架。
*  Symfony:Yii 引用它的过滤设计和[插件](http://baike.so.com/doc/1483288-1568456.html)架构。
*  Joomla:Yii 引用其模块化设计和信息翻译方案。



<br>

## 本章参考



# 4 ruby-on-rails

## 入门实例

### 安装rails

必需安装软件

* [Ruby](https://www.ruby-lang.org/en/downloads) 1.9.3 及以上版本
* 包管理工具 [RubyGems](https://rubygems.org/)，随 Ruby 1.9+ 安装。想深入了解 RubyGems，请阅读 [RubyGems 指南](http://guides.rubygems.org/)
* [SQLite3](https://www.sqlite.org/) 数据库

 安装：

```shell
$ sudo apt-get install ruby sqlite
$ gem install rails
```



### 创建 Blog 程序

Rails 提供了多个被称为“生成器”的脚本，可以简化开发，生成某项操作需要的所有文件。其中一个是新程序生成器，生成一个 Rails 程序骨架，不用自己一个一个新建文件。

打开终端，进入有写权限的文件夹，执行以下命令生成一个新程序：

```shell
# 1.会在文件夹 blog 中新建一个Rails 程序
$ rails new blog

# 2.安装 Gemfile 中列出的 gem。
$ bundle install

# 3.生成 blog 程序后，进入该文件夹, 查看新程序生成器的所有命令行选项。
$ rails new -h
```

blog 文件夹中有很多自动生成的文件和文件夹，组成一个 Rails 程序。本文大部分时间都花在 app 文件夹上。下面简单介绍默认生成的文件和文件夹的作用：

| 文件/文件夹   | 作用    |
| --------------------- | ------------------------------------------------------------ |
| app/   | 存放程序的控制器、模型、视图、帮助方法、邮件和静态资源文件。本文主要关注的是这个文件夹。 |
| bin/   | 存放运行程序的 rails 脚本，以及其他用来部署或运行程序的脚本。 |
| config/  | 设置程序的路由，数据库等。详情参阅“[设置   Rails 程序](http://guides.ruby-china.org/configuring.html)”一文。 |
| config.rl   | 基于 Rack 服务器的程序设置，用来启动程序。    |
| db/    | 存放当前数据库的模式，以及数据库迁移文件。    |
| Gemfile, Gemfile.lock | 这两个文件用来指定程序所需的 gem 依赖件，用于 Bundler gem。关于 Bundler 的详细介绍，请访问 [Bundler 官网](http://bundler.io/)。 |
| lib/   | 程序的扩展模块。  |
| log/   | 程序的日志文件。  |
| public/  | 唯一对外开放的文件夹，存放静态文件和编译后的资源文件。  |
| Rakefile    | 保存并加载可在命令行中执行的任务。任务在 Rails 的各组件中定义。如果想添加自己的任务，不要修改这个文件，把任务保存在 lib/tasks 文件夹中。 |
| README.rdoc   | 程序的简单说明。你应该修改这个文件，告诉其他人这个程序的作用，如何安装等。 |
| test/  | 单元测试，固件等测试用文件。详情参阅“[测试   Rails 程序](http://guides.ruby-china.org/testing.html)”一文。 |
| tmp/   | 临时文件，例如缓存，PID，会话文件。   |
| vendor/  | 存放第三方代码。经常用来放第三方 gem。   |



**启动服务器**

$ rails server

上述命令会启动 WEBrick，这是 Ruby 内置的服务器。要查看程序，请打开一个浏览器窗口，访问[http://localhost:3000](http://localhost:3000/)。应该会看到默认的 Rails 信息页面。

   ![1574518237085](../../media/sf_reuse/framework/frame_web_002.png)



<br>

## 本章参考







<br>

# 参考资料

**官网**

*  [node.js](https://nodejs.org/)官方网站 https://nodejs.org/
*  [Ruby 语言官方网站](https://www.ruby-lang.org/zh_cn/documentation/)
*  Ruby on Rails 指南 http://guides.ruby-china.org/
*  [RubyGems 指南](http://guides.rubygems.org/)
*  django https://www.djangoproject.com/
*  flask 官网 http://flask.pocoo.org/


**前端框架官网**

*  [Twitter Bootstrap](http://getbootstrap.com/) - Bootstrap 的官方网站 http://getbootstrap.com/
*  JQuery  [http://JQuery.com/](http://jquery.com/)
*  jinja  http://jinja.pocoo.org/
*  React https://reactjs.org/
*  Prototypejs  [http://www.Prototypejs.org/](http://www.prototypejs.org/)
*  D3 https://d3js.org/
*  nvd3 http://nvd3.org/examples/
*  echarts  http://echarts.baidu.com/echarts2/doc/doc.html



**参考站点**

* TODOMVC框架 https://todomvc.com/
* WEB框架性能基准 https://www.techempower.com/benchmarks/
* W3shools http://www.w3school.com.cn/
*  菜鸟教程 http://www.runoob.com/



**参考链接**

[1].  [Less](http://www.w3cschool.cc/manual/lessguide/) - Less 快速入门

[2]. https://github.com/jobbole/awesome-python-cn

[3].  Node.js快速入门 http://www.yiibai.com/nodejs/nodejs-quick-start.html

[4].  Smarty教程http://www.yiibai.com/smarty/



<br>

# 附录

