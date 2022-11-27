# technical-share

Personal Technical Share,  个人技术分享

```
版权所有，若需要转载文章，请标明出处。
来源：https://github.com/keefecn/technical-share
```

**通用写作技巧**

1. [Markdown 公式指导手册](https://www.zybuluo.com/codeep/note/163962)
2. 如果单个md文件超过100KB，一般需要拆分内容另文。
3. `数字+空格` 会变成有序符号且不需额外换行；仅数字开头仍需换行。
4. 路径符号要用unix或url符号/，不能用\，否则图片链接在github上不能正确显示。
5. 空行：markdown语法中空行要用`<br> 或者 <br/>`来表示，二个换行符的空行模式不是所有markdown编辑器都支持。比如Typora支持二换行符空行，Marktext就不支持。

<br/>

**目录**

```cmd
│   LICENSE
│   README.md
│
├─media
│  ├─ai
│  │    ai_001.jpg
│  │    ai_002.png
│  ├─bigdata
│  │    bigdata_001.png
│  │    bigdata_002.png
│  │    bigdata_003.png
│  ...
│
├─science
│      哲学笔记.md
│      地理学通识.md
│      心理学通识.md
│      数学的应用实践.md
│      科学史.md
│      艺术欣赏.md
│      运动笔记.md
│
├─大数据与AI
│  │  BI专题.md
│  │  SUMMARY.md
│  │  开放数据集说明.md
│  │  数字化转型.md
│  │  数据可视化.md
│  │  数据分析及案例.md
│  │
│  ├─AI
│  │      AI框架分析.md
│  │      AI笔记.md
│  │      AI算法.md
│  │      AI中台.md
│  │      NLP-中文分词技术.md
│  │      RPA技术.md
│  │      自然语言处理.md
│  │      计算机视觉.md
│  │
│  ├─bigdata
│  │      Hadoop体系.md
│  │      数据中台.md
│  │      大数据开发.md
│  │      大数据计算框架.md
│  │      大数据集群管理.md
│  │
│  ├─cloud
│  │      云原生平台.md
│  │      云服务商比较.md
│  │      云计算专题cloud.md
│  │      云原生架构.md
│  │      CNCF云原生框架分析.md
│  │
│  └─storage.存储
│          MySQL使用指南.md
│          MongoDB用户手册.md
│          memcache用户手册.md
│          redis用户手册.md
│          postgres用户手册.md
│          OLAP分析型数据库.md
│          元数据分析.md
│          数据库技术.md
│          数据库架构.md
│
├─平台与编程语言
│  │  C++开发.md
│  │  Java开发.md
│  │  Python开发.md
│  │  中文化专题.md
│  │  基准测试.md
│  │  多语言开发.md
│  │  性能优化.md
│  │  前端技术.md
│  │
│  ├─platform.平台
│  │      操作系统实现原理.md
│  │      开放平台.md
│  │      开源生态.md
│  │      开源软件可复用技术.md
│  │      跨平台开发系列.md
│  │      企业协同办公生态.md
│  │      搜索引擎开发资源.md
│  │      小程序开发.md
│  │      移动应用开发.md
│  │
│  ├─源码剖析
│  │      apache_analyze.md
│  │      flask_appbuilder源码剖析.md
│  │      flask源码剖析.md
│  │      gunicorn源码剖析.md
│  │      Hadoop体系源码剖析.md
│  │      heritrix_analyze.md
│  │      linux内核同步机制分析.md
│  │      linux内核源码剖析.md
│  │      lucene_analyze.md
│  │      mysql源码分析.md
│  │      python_web框架源码剖析.md
│  │      python源码剖析.md
│  │      redash源码剖析.md
│  │      scrapy_analyze.md
│  │      superset二次开发.md
│  │      superset源码剖析.md
│  │      tse_analyze.md
│  │
│  └─编程
│          64位开发.md
│          后台服务进程.md
│          编程经验小结.md
│          网络通讯编程实例.md
│
├─软件可复用
│  │  软件设计系列.md
│  │
│  ├─algo
│  │      基础算法与数据结构小结.md
│  │      算法分析与设计.md
│  │      非数值和工业界领域算法.md
│  │      安全算法.md
│  │
│  ├─architecture.架构
│  │      分布式架构.md
│  │      微服务架构.md
│  │      网站架构设计与开发.md
│  │      软件架构实例.md
│  │      软件架构设计.md
│  │
│  ├─framework.框架
│  │      Java框架分析.md
│  │      Python框架分析.md
│  │      SpringCloud系列框架分析.md
│  │      WEB框架分析.md
│  │      分布式框架分析.md
│  │      前端框架分析.md
│  │      服务器框架设计分析.md
│  │      测试框架分析.md
│  │
│  ├─library.函数库
│  │      stl学习笔记.md
│  │      using_libxml2.md
│  │
│  └─tools.工具
│          docker用户手册.md
│          EA用户手册.md
│          git用户手册.md
│          jekyll开发手册.md
│          jenkins用户手册.md
│          jupyter用户手册.md
│          kubernetes用户手册.md
│          mediawiki开发手册.md
│          nginx用户手册.md
│          Office办公软件高级教程.md
│          rose建模视图指导.md
│          自动化测试工具.md
│          项目开发环境工具.md
│          网站优化工具.md
│          数据可视化工具.md
│          前端工程化工具.md
│
├─软件工程
│      测试管理.md
│      敏捷开发.md
│      软件工程可信.md
│      运维专题.md
│      DevOps指南.md
│      IT管理.md
│
│  ├─产品岗
│          产品管理.md
│          产品管理-B端.md
│          产品和解决方案.md
│          互联网经济.md
│          竞品分析案例.md
│          行业数字化转型.md
│          运营专题.md
│          TMT行业指南.md
|
└─领域开发
        IOT物联网技术.md
        区块链技术.md
        安全技术.md
        黑客技术.md
        浏览器开发.md
```
