| 序号 | 修改时间   | 修改内容             | 修改人 | 审稿人 |
| ---- | ---------- | -------------------- | ------ | ------ |
| 1    | 2016-12-19 | 创建                 | Keefe | Keefe |
| 2    | 2016-12-28 | 增加jekyll编辑章节。 | 同上   |        |
|      |            |                      |        |        |






---

目录

[TOC]

[1    简介... 2](#_Toc470905021)

[2    安装搭建jekyll + github. 2](#_Toc470905022)

[2.1    Linux/bsd下安装... 3](#_Toc470905023)

[2.2    windows下安装... 3](#_Toc470905024)

[2.3    项目创建... 4](#_Toc470905025)

[2.4    文章导入... 4](#_Toc470905026)

[2.5    绑定域名CNAME. 4](#_Toc470905027)

[2.6    Jekyll站点实例... 5](#_Toc470905028)

[3    jekyll配置... 5](#_Toc470905029)

[3.1    网站目录结构... 5](#_Toc470905030)

[3.2    配置文件... 6](#_Toc470905031)

[3.2.1     _config.yml 6](#_Toc470905032)

[3.2.2     常用变量... 8](#_Toc470905033)

[3.2.3     常见问题... 9](#_Toc470905034)

[3.3    主题Theme. 10](#_Toc470905035)

[3.3.1     导航排列... 10](#_Toc470905036)

[3.4    插件 Plugin. 10](#_Toc470905037)

[3.4.1     语法高亮Pygments. 10](#_Toc470905038)

[3.4.2     评论：Disqus/suoshuo. 10](#_Toc470905039)

[3.4.3     统计分析：baidu/google. 11](#_Toc470905040)

[3.4.4     广告：baidu/alibaba/google/amazon. 12](#_Toc470905041)

[3.4.5     静态搜索... 12](#_Toc470905042)

[3.4.6     内容推荐：相关内容... 12](#_Toc470905043)

[3.5    网站推广... 13](#_Toc470905044)

[3.5.1     站点地图：sitemap/roadmap. 13](#_Toc470905045)

[3.5.2     订阅：atom /rss. 13](#_Toc470905046)

[3.5.3     分享share. 15](#_Toc470905047)

[3.5.4     微博/微信公众号... 15](#_Toc470905048)

[3.5.5     捐款：alipay/weixin. 15](#_Toc470905049)

[4    jekyll编辑... 15](#_Toc470905050)

[4.1    markdown语法... 15](#_Toc470905051)

[4.1.1    图片... 15](#_Toc470905052)

[4.2    Liquid模板语言... 16](#_Toc470905053)

[5    参考资料... 16](#_Toc470905054)



---

# 1 简介

What is Jekyll?

Jekyll is a parsing engine bundled as a ruby gem used to build static websites from dynamic components such as templates, partials, liquid code, markdown, etc. Jekyll is known as “a simple, blog aware, static site generator”.

[Jekyll](http://jekyllrb.com/)是一个静态站点生成器，它会根据网页源码生成静态文件。它提供了模板、变量、插件等功能，所以实际上可以用来编写整个网站。

为了支持HTML内容，GitHub Pages支持了Jekyll框架。Jekyll能够简单地在各个页面中使用全局的headers和footers。同时Jekyll也能提供一些其他的模版特性。



[markdown](http://wowubuntu.com/markdown/)是写文章的神器，可以用简单的文本格式代替html标记。markdown几乎支持常用的html标签。

[liquid](https://github.com/shopify/liquid/wiki/liquid-for-designers)是一个模版语言，是jekyll支持的一种，有点类似smarty，只不过是静态的模版语言，只能在编译的过程中进行替换。liquid除了支持变量替换外还支持逻辑语法。





# 2 安装搭建jekyll + github

构建github个人博客站：https://username.github.io/  （个人博客必须是https开头）

https://github.com/dennycn/dennycn.github.io

https://dennycn.github.io

http://127.0.0.1:4000/


安装环境：
*  ruby
*  RubyGems：ruby包管理工具
*  jekyll
*  pygments 代码高亮



jekyll**常用命令**
```sh
jekyll help # 查看帮助
jekyll help subcommand  # 查看子命令的帮助信息
jekyll new site-name  # 创建一个新的
jekyll build  # 构建，缺省把博客生成到 _site 目录下

jekyll server  # 开启本地服务器查看效果
jekyll server -P 4001  # 指定端口
jekyll server -w  s# 文件发生变化时，自动重新编译
```


**gem工具**

gem是ruby的包管理器。

**更换TAOBAO源**
```sh
gem sources --remove https://rubygems.org/
gem sources -a https://ruby.taobao.org/
gem sources -l
```

## 2.1   Linux/bsd下安装





## 2.2   windows下安装

[Jekyll](http://jekyllrb.com/) 是一个简单的网站静态页面生成工具。由于是用Ruby语音编写的，所以在Windows系统上配置起来还是稍微有点繁琐的。具体过程如下：

* 安装Ruby：在Windows系统上当然使用rubyinstaller了， [猛击我下载](http://rubyinstaller.org/downloads/) （笔者使用的版本是：Ruby 1.9.3-p545）
* 安装Ruby DevKit： [猛击我下载](https://github.com/downloads/oneclick/rubyinstaller/DevKit-tdm-32-4.5.2-20111229-1559-sfx.exe)
* 安装Jekyll
* 安装Python： [猛击我下载](http://portablepython.com/wiki/PortablePython3.2.1.1)
* 安装Pygments



以下是详细步骤：

1.从rubyinstaller下载安装包并安装到某个磁盘中，比如：E:\Ruby192，在安装界面把所有的选项都勾选上；

2.把下载的DevKit解压到某个目录，比如 E:\devkit , 在该目录中运行如下命令：
`> ruby dk.rb init`

来生成一个config.xml配置文件，该配置文件中包含了前面的Ruby安装目录 （E:\Ruby192） 然后运行如下命令
`> ruby dk.rb install`

3.然后运行如下命令安装Jekyll：
`> gem install jekyll --version=2.5.3`

现在可以开始使用jekyll了。如果您还需要使用代码高亮工具，则需要继续安装Pygments ，过程如下：

4.安装下载的Portable Python（笔者使用的是PortablePython_3.2.1.1.exe），安装目录为E:\Portable_Python_3.2.1.1

然后把E:\Portable_Python_3.2.1.1\App\Scripts和E:\Portable_Python_3.2.1.1\App目录分别添加到系统Path环境变量中

5.把下载的distribute-0.6.49.tar.gz解压的某个目录(比如：E:\distribute-0.6.28), [猛击我下载](http://pypi.python.org/pypi/distribute#downloads)

在该目录中运行如下命令：
`> python distribute_setup.py`

6.然后通过如下命令来安装pygments：
`> easy_install Pygments`

最后需要修改2处Bug：

Pygmentize中的Bug：修改如下文件 E:\Ruby192\lib\ruby\gems\1.9.1\gems\albino-1.3.3\lib\albino.rb 修改的内容参考 [这里](https://gist.github.com/1185645)

由于中文XP系统使用的GBK编码，GBK编码导致jekyll处理的bug，修改E:\Ruby192\lib\ruby\gems\1.9.1\gems\jekyll-0.11.2\lib\jekyll\convertible.rb这个文件，修改方式 [参考这里](https://github.com/imathis/octopress/issues/232#issuecomment-2480736)

然后就可以使用Jekyll了，在生成静态页面的时候 可能还会出现 GBK字符不能编码的问题，但是不影响生成网页了。



## 2.3   项目创建

第一步创建项目

jekyll new myjekyll

切换到myjekyll目录，运行下面的命令即可

jekyll server

然后打开浏览器的[127.0.0.1:4000](http://127.0.0.1:4000)，即可查看网站效果



## 2.4   文章导入

http://import.jekyllrb.com/

**RSS**

To import your posts from an RSS feed (local or remote), run:
```ruby
$ ruby -rubygems -e 'require "jekyll-import";
  JekyllImport::Importers::RSS.run({
   "source" => "my_file.xml"
  })'
```

## 2.5   绑定域名CNAME

**双向指定**：空间代码增加CNAME文件，域名管理商增加CNAME记录。

如果你不想用http://username.github.com/jekyll_demo/这个域名，可以换成自己的域名。

具体方法是在repo的根目录下面，新建一个名为CNAME的文本文件，里面写入你要绑定的域名，比如example.com或者xxx.example.com。

如果绑定的是顶级域名，则DNS要新建一条A记录，指向204.232.175.78。如果绑定的是二级域名，则DNS要新建一条CNAME记录，指向username.github.com（请将username换成你的用户名）。此外，别忘了将_config.yml文件中的baseurl改成根目录"/"。

至此，最简单的Blog就算搭建完成了。进一步的完善，请参考Jekyll创始人的[示例库](https://github.com/mojombo/tpw)，以及其他用Jekyll搭建的[blog](https://github.com/mojombo/jekyll/wiki/Sites)。



## 2.6   Jekyll站点实例

站点示例：https://github.com/jekyll/jekyll/wiki/Sites

[https:// jimenbian.github.io/](https://jeremywei.github.io/)  --> http://www.garvinli.com/ 工作室的项目博客

http://yanhaijing.com --> https://yanhaijing.github.com/ 带分类和存档的个人博客



https://jeremywei.github.io/  --> http://weizhifeng.net/

http://www.zhanxin.info



# 3 jekyll配置

## 3.1   网站目录结构

Jekyll expects your website directory to be laid out like so:
```
.
|-- _config.yml
|-- _includes
|-- _layouts
|  |-- default.html
|  |-- post.html
|-- _posts
|  |-- 2011-10-25-open-source-is-good.markdown
|  |-- 2011-04-26-hello-world.markdown
|-- _site
|-- index.html
|-- assets
  |-- css
    |-- style.css
  |-- javascripts
```
 (read more: https://github.com/mojombo/jekyll/wiki/Usage)


| 文件/目录   | 描述                                                         |
| ----------- | ------------------------------------------------------------ |
| _config.yml | 存储配置数据文件。很多全局的配置或者指令写在这里。           |
| _drafts     | 存放为发表的文章。这些是没有日期的文件。                     |
| _includes   | 目录，存放一些组件。可以通过{% include  file.ext %} 来引用。 |
| _layouts    | 目录，存放布局。一般有三个文件default.html、page.html、post.html |
| _posts      | 目录，存放文章，格式化为：YEAR-MONTH-DAY-title.md  或者 YEAR-MONTH-DATE-title.MARKUP |
| _site       | 最终生成的博客文件就在这里。                                 |
| index.html  | 博客的主页。                                                 |
| other       | 例如静态文件 CSS，Images 和其他。                            |
| assets      | This folder is not part of the standard  jekyll structure. The assets folder represents any generic folder you happen  to create in your root directory. Directories and files not properly  formatted for jekyll will be left untouched for you to serve normally. |

备注：只要我们把自己需要的文件放到博客目录下，通过jekyll build，该目录就会被复制到_site里面。明白了目录结构之后，我们在通过 git 提交博客到服务器的时候，就可以通过.gitignore来过滤掉_site目录，而在服务器端再执行命令生成。



## 3.2   配置文件

### 3.2.1 _config.yml

**全局的配置项**

| **设置**                              | **选项或者参数**          |
| ------------------------------------- | ------------------------- |
| Site Source   网站源文件的根目录      | source: DIR               |
| Site Destination   生成网站的目录地址 | destination: DIR          |
| Safe   是否使用自定义插件             | safe: BOOL                |
| Exclude   排除目录或者文件            | exclude: [DIR, FILE, ...] |
| Include   包含的目录或者文件          | include: [DIR, FILE, ...] |
| Time Zone   设置时区                  | timezone: TIMEZONE        |


**编译的命令选项**

| **设置**                                               | **选项或者参数**                     |
| ------------------------------------------------------ | ------------------------------------ |
| Regeneration   文件被修改时，启动自动生成              | -w, --watch                          |
| Configuration   指定一个配置文件，可以覆盖 _config.yml | --config FILE                        |
| Drafts   处理和渲染草稿文章                            | --drafts                             |
| Future   发布未来的文章                                | future: BOOL   --future              |
| LSI   发布相关的文章                                   | lsi: BOOL   --lsi                    |
| Limit Posts   限制文章发布的数量                       | limit_posts: NUM   --limit_posts NUM |


**服务器的命令选项**

| **设置**                                   | **选项或者参数**                 |
| ------------------------------------------ | -------------------------------- |
| Local Server Port   本地服务器启动的端口号 | port: PORT   --port PORT         |
| Local Server Hostname   服务器名称         | host: HOSTNAME   --host HOSTNAME |
| Base URL   基础链接                        | baseurl: URL                     |



_config.yml 示例

```yaml
markdown: redcarpet
pygments: true
paginate: 8
safe: false
```

Site config
```ini
title: Keefe Wu
description: Just another Jekyll theme design and code by Keefe Wu.
keywords: Jekyll Theme
url: http://dennycn.github.io
feed: /atom.xml
favicon: http://img.tongji.linezing.com/3488260/tongji.gif
```


Nav config
```yaml
nav:
 - text: 首页
  url: /index.html
 - text: 分类目录
  url: /categories.html
 - text: 项目归档
  url: /archives.html
 - text: 团队介绍
  url: /contact.html
 - text: 团队链接
  url: /links.html
```


Author config
```ini
author:
```


### 3.2.2 常用变量

了解完全局的配置之后，我们还需要了解 Jekyll 的变量。通过这些变量，可以输出文章的标题、内容、链接等等。

**全局变量**

| 变量      | 描述                                                         |
| ------------- | ------------------------------------------------------------ |
| site      | 设置整个站点的信息和全局配置，定义在_config.xml。            |
| page      | 设置页面信息和自定义的变量，定义在markdown的YAML Front Matter（*.md）。 |
| content   | 展示文章或者页面的内容。                                     |
| paginator | 当配置文件中设置了 paginator 的时候，这里可以读取分页的信息。 |



site站点变量

| 变量                      | 描述                                          |
| ------------------------- | --------------------------------------------- |
| site.time                 | 当你运行jekyll时候的时间。                    |
| site.pages                | 当前的页面列表。                              |
| site.posts                | 倒序列出所有的文章。                          |
| site.related_posts        | 相关的文章。   默认配置下最多 10 篇相关文章。 |
| site.categories.CATEGORY  | 某一个分类的文章列表。                        |
| site.tags.TAG             | 某一个标签的文章列表。                        |
| site.[CONFIGURATION_DATA] | 配置文件中的信息。                            |



page页面变量

| 变量            | 描述                     |
| --------------- | ------------------------ |
| page.content    | 页面渲染出来的内容。     |
| page.title      | 页面标题。               |
| page.excerpt    | 文章摘要。               |
| page.url        | 页面链接地址。           |
| page.date       | 页面或者文章的时间。     |
| page.id         | 页面或者文章的唯一标识。 |
| page.categories | 页面或者文章的分类。     |
| page.tags       | 页面或者文章的标签。     |
| page.path       | 页面的路径。             |
| page.CUSTOM     | 页面的自定义内容。       |



paginator**分页**

| 变量                         | 描述               |
| ---------------------------- | ------------------ |
| paginator.per_page           | 每个分页的文章数量 |
| paginator.posts              | 分页里的文章对象   |
| paginator.total_posts        | 文章的总数         |
| paginator.total_pages        | 分页的页数         |
| paginator.page               | 当前第几页         |
| paginator.previous_page      | 前一页的页码       |
| paginator.previous_page_path | 前一页的地址       |
| paginator.next_page          | 下一页的页码       |
| paginator.next_page_path     | 下一页的地址       |

有了这些变量，自定义一个 Jekyll 博客主题，应该不是一件难事。

### 3.2.3 常见问题

1. Build Warning: Layout 'nil' requested in atom.xml does not exist.

解决方法：将nil改为null


2. Deprecation: You appear to have pagination turned on, but you haven't included the `jekyll-paginate` gem. Ensure you have `gems: [jekyll-paginate]` in your configuration file.

解决方法：$ gem install --user-install --bindir ~/bin --no-document --pre jekyll-paginate

然后_config.yml修改如下，
```ymal
# PAGINATION
gems: [jekyll-paginate]
paginate: 5
paginate_path: "page:num"
```




## 3.3   主题Theme

那么在自定义博客的时候，需要注意些什么呢？这里有之前写过的一些总结：

- [Jekyll 的一些函数和技巧](http://www.zhanxin.info/jekyll/2012-04-26-some-tips-about-jekyll.html)
- [为 Jekyll 博客添加静态搜索](http://www.zhanxin.info/jekyll/2012-05-26-jekyll-static-search.html)
- [快速创建漂亮的项目页面](http://www.zhanxin.info/jekyll/2012-08-26-quick-create-a-jekyll-page.html)
- [优化 Jekyll      站点的 SEO 技巧](http://www.zhanxin.info/jekyll/2012-12-09-jekyll-seo.html)
- [Jekyll 菜单高亮](http://www.zhanxin.info/jekyll/2013-07-16-jekyll-highlight-nav.html)



### 3.3.1 导航排列
```
<ul>
 {% assign pages_list = site.pages %}
 {% include JB/pages_list %}
</ul>
```


## 3.4   插件 Plugin

### 3.4.1 语法高亮Pygments

Pygments代码高亮语法使用介绍： [点击这里](https://github.com/mojombo/jekyll/wiki/Liquid-Extensions)

具体例子效果如下：
```ruby
 public class HelloWorld {
   public static void main(String args[]) {
    System.out.println("Hello World!");
   }
 }
```

### 3.4.2 评论：Disqus/duoshuo

*备注：**2017.6**多说评论系统关闭。*

comment config: default Disqus
```ini
disqus:
 config: false
 id: piznblog

duoshuo:
 config: true
 id: dennycn
```

```js
<!-- 多说评论框 start -->
         <div class="ds-thread" data-thread-key="请将此处替换成文章在你的站点中的ID" data-title="请替换成文章的标题" data-url="请替换成文章的网址"></div>

<!-- 多说评论框 end -->

<!-- 多说公共JS代码 start (一个网页只需插入一次) -->

<script type="text/javascript">
var duoshuoQuery = {short_name:"keefe"};
     (function() {
          var ds = document.createElement('script');
          ds.type = 'text/javascript';ds.async = true;
          ds.src = (document.location.protocol == 'https:' ? 'https:' : 'http:') + '//static.duoshuo.com/embed.js';
          ds.charset = 'UTF-8';
          (document.getElementsByTagName('head')[0]
           || document.getElementsByTagName('body')[0]).appendChild(ds);
     })();
     </script>

<!-- 多说公共JS代码 end -->
```




### 3.4.3 统计分析：baidu/google

_config.yml
```yaml
 analytics :
  provider : baidu
// 如果上面provider对应值为空，即site.JB.analytics.provider为空，则不会包含统计代码。

// 选择统计代码 JB/analytics
 {% if site.safe and site.JB.analytics.provider and page.JB.analytics != false %}
{% case site.JB.analytics.provider %}
 {% include JB/analytics-providers/baidu %}
 {% include JB/analytics-providers/google %}
 {% include JB/analytics-providers/getclicky %}
 {% include JB/analytics-providers/mixpanel %}
 {% include JB/analytics-providers/piwik %}

 // baidu stat
var _hmt = _hmt || [];
(function() {
 var hm = document.createElement("script");
 hm.src = "https://hm.baidu.com/hm.js?64344d27a02ec2495c596aa115ebb540";
 var s = document.getElementsByTagName("script")[0];
 s.parentNode.insertBefore(hm, s);
})();
```


### 3.4.4 广告：baidu/alibaba/google/amazon

**google广告**

```js
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- 博客内部广告 -->
<ins class="adsbygoogle"
   style="display:inline-block;width:300px;height:250px"
   data-ad-client="ca-pub-4594322204962044"
   data-ad-slot="2622044211"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
```




### 3.4.5 静态搜索

需要使用jquery与bootstrap3框架。

原理：生成所有post带标题和url的search.xml，用ajax技术异步搜索此文件内容。



### 3.4.6 内容推荐：ujian
```js
<!-- UJian Button BEGIN -->
<script type="text/javascript">var ujian_config = {defaultPic:'http://wuqifu.cn/img/keefe.jpg'};</script>
<script type="text/javascript" src="http://v1.ujian.cc/code/ujian.js?type=slide&fade=1&uid=1908435"></script>
<a href="http://www.ujian.cc" style="border:0;"><img src="http://img.ujian.cc/pixel.png" alt="ujian" style="border:0;padding:0;margin:0;" /></a>
<!-- UJian Button END -->
```


## 3.5   网站推广

### 3.5.1 站点地图：sitemap/roadmap

sitemap：一堆URL的集合，提供给SPIDER方便抓取。

\---

\# Remember to set production_url in your _config.yml file!

title : 站点地图

\---

```jinja2
{% for page in site.pages %}
{{site.production_url}}{{ page.url }}{% endfor %}
{% for post in site.posts %}
{{site.production_url}}{{ post.url }}{% endfor %}
```



### 3.5.2 订阅：atom /rss

**atom.xml**
```xml
---
layout: default
comment: true
---

<div class="article article-post">
  <h2 class="title">{{ page.title }}</h2>
    <div class="info">
   <span class="info-title"><i class="icon-calendar"></i> Published: </span>
   <span class="info-date">{{ page.date | date_to_string }}</span>
   <span class="info-title"><i class="icon-folder-open"></i> Category: </span>
   <span class="info-link"><a href="{{ site.url }}/categories.html#{{ page.category }}-ref" >{{ page.category }}</a></span>
  </div>
  {{ content }}
  <nav class="article-previous fn-clear">
   {% if page.previous %}
        <a class="prev" href="{{ page.previous.url }}" rel="bookmark">&laquo;&nbsp;{{ page.previous.title | truncatewords:5 }}</a>
   {% endif %}
   {% if page.next %}
        <a class="next" href="{{ page.next.url }}" rel="bookmark">{{ page.next.title | truncatewords:5 }}&nbsp;&raquo;</a>
   {% endif %}
  </nav>
    <div class="comment">
   {% if site.disqus.config %}
        <div id="disqus_thread"></div>
   {% else %}
     {% if site.duoshuo.config %}
            <div class="ds-thread"></div>
     {% endif %}
   {% endif %}
  </div>
</div>
```


**rss.xml**

```xml
---
layout: null
title : RSS 订阅
---

<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0">
<channel>
   <title>{{ site.title }}</title>
   <description>{{ site.title }} - {{ site.author.name }}</description>
   <link>{{ site.production_url }}{{ site.rss_path }}</link>
   <link>{{ site.production_url }}</link>
   <lastBuildDate>{{ site.time | date_to_xmlschema }}</lastBuildDate>
   <pubDate>{{ site.time | date_to_xmlschema }}</pubDate>
   <ttl>1800</ttl>

{% for post in site.posts %}
   <item>
       <title>{{ post.title }}</title>
       <description>{{ post.content | xml_escape }}</description>
       <link>{{ site.production_url }}{{ post.url }}</link>
       <guid>{{ site.production_url }}{{ post.id }}</guid>
       <pubDate>{{ post.date | date_to_xmlschema }}</pubDate>
   </item>
{% endfor %}

</channel>
</rss>
```

### 3.5.3 分享share



### 3.5.4 微博/微信公众号

进入微信公众平台，可注册个人公众号。



### 3.5.5 捐款：alipay/weixin





# 4 jekyll编辑

## 4.1   markdown语法

[Markdown 语法说明 (简体中文版)](http://wowubuntu.com/markdown/)

[markdown在线编辑器](http://markable.in/editor/)

[markdownpad 2](http://markdownpad.com/)



### 4.1.1图片

很明显地，要在纯文字应用中设计一个「自然」的语法来插入图片是有一定难度的。

Markdown 使用一种和链接很相似的语法来标记图片，同样也允许两种样式： 行内式和参考式。

行内式的图片语法看起来像是：

* ![Alt text](/path/to/img.jpg)
* ![Alt text](/path/to/img.jpg "Optional title")

详细叙述如下：

一个惊叹号 !

接着一个方括号，里面放上图片的替代文字

接着一个普通括号，里面放上图片的网址，最后还可以用引号包住并加上 选择性的 'title' 文字。



参考式的图片语法则长得像这样：
* ![Alt text][id]  说明：「id」是图片参考的名称，图片参考的定义方式则和连结参考一样：
* [id]: url/to/image "Optional title attribute"

到目前为止， Markdown 还没有办法指定图片的宽高，如果你需要的话，你可以使用普通的 <img> 标签。



## 4.2   Liquid模板语言

[Liquid模板语言](https://github.com/shopify/liquid/wiki/liquid-for-designers)



{{ 变量名 }}

示例：
```jiajia2
//文件名 setup，在JB目录下
{% assign BLOG_IMG = "/blog/" %}
//使用：包含文件名，调用变量
{% include JB/setup %}

![原始排序]({{BLOG_IMG}}anchor_getanchor.png)
```



# 5 参考资料

[1].   [Running Jekyll on Windows](http://www.madhur.co.in/blog/2011/09/01/runningjekyllwindows.html)

[2].   [Jekyll 本地调试之若干问题](http://chxt6896.github.io/blog/2012/02/13/blog-jekyll-native.html)

[3].   [搭建一个免费的，无限流量的Blog](http://www.ruanyifeng.com/blog/2012/08/blogging_with_jekyll.html)

[4].   [jekyll中文站](http://jekyllcn.com/)

[5].   [Markdown 语法说明 (简体中文版)](http://wowubuntu.com/markdown/)

[6].   [markdown在线编辑器](http://markable.in/editor/)

[7].   [markdownpad 2](http://markdownpad.com/)

[8].   [Liquid模板语言](https://github.com/shopify/liquid/wiki/liquid-for-designers)

[9].   gitment https://imsun.net/posts/gitment-introduction/



