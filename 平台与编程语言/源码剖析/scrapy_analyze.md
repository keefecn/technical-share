| 序号 | 修改时间  | 修改内容 | 修改人 | 审稿人 |
| ---- | --------- | -------- | ------ | ------ |
| 1    | 2017-1-16 | 创建     | Keefe  |        |
|      |           |          |        |        |





## 1 简介



## 2 应用篇

### Scrapy爬虫启动

打开CMD，切换到存储爬虫项目的目录下，输入：
 $scrapy  startproject  qsbkauto

![http://ww4.sinaimg.cn/mw690/63918611gw1fbjeuj23t5j20fe025mx7.jpg](..\..\media\code\code_scrapy_001.png)

 

**项目结构说明** 

l spiders.qsbkspd.py：爬虫文件

l items.py：项目实体，要提取的内容的容器，如当当网商品的标题、评论数等

l pipelines.py：项目管道，主要用于数据的后续处理，如将数据写入Excel和db等

l settings.py：项目设置，如默认是不开启pipeline、遵守robots协议等

l scrapy.cfg：项目配置

 

**创建爬虫**

进入创建的爬虫项目，输入：
 scrapy genspider -t crawl qsbkspd qiushibaie=ke.com（域名）

 

## 3 框架篇

Scrapy是一个基于Twisted，纯Python实现的爬虫框架，用户只需要定制开发几个模块就可以轻松的实现一个爬虫，用来抓取网页内容以及各种图片，非常之方便。

整体架构大致如下

![Scrapy架构.jpg](..\..\media\code\code_scrapy_002.png)

图 1 Scrapy框架

**说明**：绿线是数据流向，首先从初始URL 开始，Scheduler 会将其交给 Downloader 进行下载，下载之后会交给 Spider 进行分析，Spider分析出来的结果有两种：一种是需要进一步抓取的链接，例如之前分析的“下一页”的链接，这些东西会被传回 Scheduler ；另一种是需要保存的数据，它们则被送到Item Pipeline 那里，那是对数据进行后期处理（详细分析、过滤、存储等）的地方。另外，在数据流动的通道里还可以安装各种中间件，进行必要的处理。

 

 

# 参考资料

[1].   Scrapy https://scrapy.org/

[2].   [Scrapy：Python的爬虫框架](http://hao.jobbole.com/python-scrapy/)

[3].   Python网络爬虫二三事 http://python.jobbole.com/87234/ 

 