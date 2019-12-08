| 序号 | 修改时间  | 修改内容 | 修改人 | 审稿人 |
| ---- | --------- | -------- | ------ | ------ |
| 1    | 2016-5-12 | 创建     | 吴启福 | 吴启福 |
|      |           |          |        |        |
---

 

 

 

目录

[1    MediaWiki代码分析... 2](#_Toc469918271)

[1.1    代码目录文件结构... 2](#_Toc469918272)

[1.2    数据库结构... 2](#_Toc469918273)

[1.2.1     数据库表简述... 3](#_Toc469918274)

[1.2.2     数据库表的结构组成... 7](#_Toc469918275)

[1.3    Main.php分析... 8](#_Toc469918276)

[2    MediaWiki用户指南... 8](#_Toc469918277)

[2.1    MediaWiki语法... 8](#_Toc469918278)

[3    MediaWiki开发... 8](#_Toc469918279)

[3.1    配置项修改LocalSettings.php. 8](#_Toc469918280)

[3.2    首页修改... 11](#_Toc469918281)

[3.2.1     左侧导航MediaWiki:Sidebar. 11](#_Toc469918282)

[3.2.2     其它常用修改... 11](#_Toc469918283)

[3.3    清除页面缓存... 12](#_Toc469918284)

[3.4    多语言版如繁简共存版本... 12](#_Toc469918285)

[3.4.1     方案1：多个wiki、多个数据库、多语言文字外链导航... 12](#_Toc469918286)

[3.4.2     方案2：1个wiki、1个数据库、多语言文字内链导航... 13](#_Toc469918287)

[3.5    手机版... 13](#_Toc469918288)

[3.6    多站点共用程序... 13](#_Toc469918289)

[3.7    模块扩展... 13](#_Toc469918290)

[4    MediaWiki迁移和升级... 13](#_Toc469918291)

[4.1    WIKI文件的备份：拷贝... 14](#_Toc469918292)

[4.2    MediaWiki数据导入导出方法... 14](#_Toc469918293)

[4.3    数据库的迁移... 15](#_Toc469918294)

[4.4    MediaWiki的升级... 16](#_Toc469918295)

[4.4.1     升级前... 16](#_Toc469918296)

[4.4.2     升级中... 16](#_Toc469918297)

[4.4.3     升级后... 17](#_Toc469918298)

[5    参考资料... 17](#_Toc469918299)

[5.1    参考链接... 17](#_Toc469918300)

[5.2    各类wiki收录... 18](#_Toc469918301)

 

 

# 1 MediaWiki代码分析

Mediawiki分析版本v1-26.0

## 1.1   代码目录文件结构

表格 1 代码目录文件结构

| 目录名      | 典型文件   | 简介             | 备注                |
| ----------- | ---------- | ---------------- | ------------------- |
| cache       |            | 页面缓存         |                     |
| docs        |            | 文档             |                     |
| extensions  |            | 模块扩展         |                     |
| images      |            | 图片             | 保存用x/xx/文件原名 |
| includes    |            |                  |                     |
| languages   |            | 语言相关         |                     |
| maintenance |            | 维护相关         |                     |
|             | table.sql  | 数据库表创建脚本 |                     |
|             | update.php | 版本更新         |                     |
| mv-config   |            |                  |                     |
| resources   |            |                  |                     |
| serialized  |            |                  |                     |
| skins       |            |                  |                     |
| tests       |            |                  |                     |
| vendor      |            |                  |                     |
|             |            |                  |                     |

 

 

## 1.2   数据库结构

参见：https://www.mediawiki.org/wiki/Manual:Database_layout

​    ![image-20191208232311794](E:\project\technical-share\media\sf_reuse\tools\tools_mediawiki_001.png)                           

图表 1 按功能划分表格

注：功能分为users，

 

### 1.2.1 数据库表简述

表格 2按字母排序的数据库表

| 功能 | [表               ](http://192.168.0.220/phpmyadmin/db_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&pos=0&sort=table&sort_order=DESC) | [记录数](http://192.168.0.220/phpmyadmin/db_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&pos=0&sort=records&sort_order=DESC) 1 | [大小](http://192.168.0.220/phpmyadmin/db_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&pos=0&sort=size&sort_order=DESC) |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 1.   | archive                                                  | 1                                                            | [64.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_archive#showusage) |
| 2.   | category                                                 | 11                                                           | [48.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_category#showusage) |
| 3.   | categorylinks                                            | 121                                                          | [64.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_categorylinks#showusage) |
| 4.   | change_tag                                               | 0                                                            | [80.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_change_tag#showusage) |
| 5.   | externallinks                                            | 466                                                          | [224.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_externallinks#showusage) |
| 6.   | filearchive                                              | 0                                                            | [96.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_filearchive#showusage) |
| 7.   | image                                                    | 9                                                            | [96.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_image#showusage) |
| 8.   | imagelinks                                               | 21                                                           | [48.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_imagelinks#showusage) |
| 9.   | interwiki                                                | 74                                                           | [16.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_interwiki#showusage) |
| 10.  | ipblocks                                                 | 0                                                            | [112.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_ipblocks#showusage) |
| 11.  | iwlinks                                                  | 2                                                            | [48.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_iwlinks#showusage) |
| 12.  | job                                                      | 0                                                            | [96.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_job#showusage) |
| 13.  | l10n_cache                                               | 10,460                                                       | [4.3 MB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_l10n_cache#showusage) |
| 14.  | langlinks                                                | 0                                                            | [32.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_langlinks#showusage) |
| 15.  | logging                                                  | 334                                                          | [224.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_logging#showusage) |
| 16.  | log_search                                               | 0                                                            | [32.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_log_search#showusage) |
| 17.  | module_deps                                              | 41                                                           | [64.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_module_deps#showusage) |
| 18.  | msg_resource                                             | 66                                                           | [16.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_msg_resource#showusage) |
| 19.  | msg_resource_links                                       | 43                                                           | [16.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_msg_resource_links#showusage) |
| 20.  | objectcache                                              | 55                                                           | [336.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_objectcache#showusage) |
| 21.  | oldimage                                                 | 0                                                            | [80.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_oldimage#showusage) |
| 22.  | page                                                     | 126                                                          | [80.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_page#showusage) |
| 23.  | pagelinks                                                | 1,776                                                        | [336.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_pagelinks#showusage) |
| 24.  | page_props                                               | 0                                                            | [48.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_page_props#showusage) |
| 25.  | page_restrictions                                        | 0                                                            | [80.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_page_restrictions#showusage) |
| 26.  | protected_titles                                         | 0                                                            | [32.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_protected_titles#showusage) |
| 27.  | querycache                                               | 0                                                            | [32.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_querycache#showusage) |
| 28.  | querycachetwo                                            | 1                                                            | [64.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_querycachetwo#showusage) |
| 29.  | querycache_info                                          | 1                                                            | [16.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_querycache_info#showusage) |
| 30.  | recentchanges                                            | 334                                                          | [192.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_recentchanges#showusage) |
| 31.  | redirect                                                 | 2                                                            | [32.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_redirect#showusage) |
| 32.  | revision                                                 | 1,004                                                        | [512.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_revision#showusage) |
| 33.  | searchindex                                              | 126                                                          | [2.1 MB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_searchindex#showusage) |
| 34.  | sites                                                    | 0                                                            | [144.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_sites#showusage) |
| 35.  | site_identifiers                                         | 0                                                            | [48.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_site_identifiers#showusage) |
| 36.  | site_stats                                               | 1                                                            | [16.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_site_stats#showusage) |
| 37.  | tag_summary                                              | 0                                                            | [64.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_tag_summary#showusage) |
| 38.  | templatelinks                                            | 8                                                            | [48.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_templatelinks#showusage) |
| 39.  | text                                                     | 905                                                          | [9.5 MB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_text#showusage) |
| 40.  | transcache                                               | 0                                                            | [16.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_transcache#showusage) |
| 41.  | updatelog                                                | 6                                                            | [16.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_updatelog#showusage) |
| 42.  | uploadstash                                              | 0                                                            | [64.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_uploadstash#showusage) |
| 43.  | user                                                     | 2                                                            | [64.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_user#showusage) |
| 44.  | user_former_groups                                       | 2                                                            | [16.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_user_former_groups#showusage) |
| 45.  | user_groups                                              | 3                                                            | [32.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_user_groups#showusage) |
| 46.  | user_newtalk                                             | 0                                                            | [48.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_user_newtalk#showusage) |
| 47.  | user_properties                                          | 1                                                            | [32.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_user_properties#showusage) |
| 48.  | valid_tag                                                | 0                                                            | [16.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_valid_tag#showusage) |
| 49   | watchlist                                                | 196                                                          | [48.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_watchlist#showusage) |
|          | 49 个表                                              | 16,198                                                   | 19.6 MB                                                  |

注：2016_为表前缀。共49个表。

各表缺省存储引擎类型是InnoDB，**整理（排序）**是binary。

数据库的整理是**latin1_swedish_ci（系统缺省）。**

**Searchindex表**的引擎类型是MyISAM，整理是*utf8_general_ci。*

导出的SQL是UTF8编码，可以正常显示中文条目名称，但条目内容是用binary存储的。

 

表格 3 按功能排序的数据库表

| 1    | 功能           | 表                     | 简介                                        | 备注                           | [记录数](http://192.168.0.220/phpmyadmin/db_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&pos=0&sort=records&sort_order=DESC) | [大小 ](http://192.168.0.220/phpmyadmin/db_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&pos=0&sort=size&sort_order=DESC) |
| ---- | -------------- | ---------------------- | ------------------------------------------- | ------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 2    | caching tables | trans_cache            |                                             |                                | 0                                                            | [16.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_transcache#showusage) |
| 3    | caching tables | querycache_info    |                                             |                                | 1                                                            | [16.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_querycache_info#showusage) |
| 4    | caching tables | querycache         |                                             |                                | 0                                                            | [32.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_querycache#showusage) |
| 5    | caching tables | objectcache            |                                             |                                | 55                                                           | [336.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_objectcache#showusage) |
| 6    | caching tables | l10n_cache             | 多语言缓存项                                | 记录行最多                     | 10,460                                                       | [4.3 MB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_l10n_cache#showusage) |
| 7    | caching tables | querycachetwo      |                                             |                                | 1                                                            | [64.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_querycachetwo#showusage) |
| 8    | interwiki      | sites              |                                             |                                | 1                                                            | [16.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_site_stats#showusage) |
| 9    | interwiki      | interwikis             | 内部链接条目名称[]                          |                                | 74                                                           | [16.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_interwiki#showusage) |
| 10   | interwiki      | site_identifiers   |                                             |                                | 0                                                            | [48.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_site_identifiers#showusage) |
| 11   | Link tables    | externallinks      |                                             |                                | 466                                                          | [224.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_externallinks#showusage) |
| 12   | Link tables    | langlinks          |                                             |                                | 0                                                            | [32.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_langlinks#showusage) |
| 13   | Link tables    | pagelinks          | 页面外部链接                                |                                | 1,776                                                        | [336.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_pagelinks#showusage) |
| 14   | Link tables    | iwlinks            |                                             |                                | 2                                                            | [48.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_iwlinks#showusage) |
| 15   | Link tables    | templatelinks      | 模板链接                                    |                                | 8                                                            | [48.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_templatelinks#showusage) |
| 16   | Link tables    | imagelinks         | 上传的图片链接地址                          |                                | 21                                                           | [48.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_imagelinks#showusage) |
| 17   | Link tables    | categorylinks      | 分类指向的链接                              |                                | 121                                                          | [64.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_categorylinks#showusage) |
| 18   | logging        | logging            |                                             |                                | 334                                                          | [224.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_logging#showusage) |
| 19   | logging        | log_search         |                                             |                                | 0                                                            | [32.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_log_search#showusage) |
| 20   | mainterence    | updatelog              |                                             |                                | 6                                                            | [16.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_updatelog#showusage) |
| 21   | mainterence    | job                    |                                             |                                | 0                                                            | [96.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_job#showusage) |
| 22   | multimedia     | uploadslash            |                                             |                                | 0                                                            | [64.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_uploadstash#showusage) |
| 23   | multimedia     | oldimage               |                                             |                                | 0                                                            | [80.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_oldimage#showusage) |
| 24   | multimedia     | filearchive            |                                             |                                | 0                                                            | [96.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_filearchive#showusage) |
| 25   | multimedia     | image                  | 上传的图片名称                              |                                | 9                                                            | [96.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_image#showusage) |
| 26   | pages          | protected_titles   |                                             |                                | 0                                                            | [32.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_protected_titles#showusage) |
| 27   | pages          | redirect               | 重定向条目                                  |                                | 2                                                            | [32.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_redirect#showusage) |
| 28   | pages          | page_props         |                                             |                                | 0                                                            | [48.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_page_props#showusage) |
| 29   | pages          | category               | 分类名称                                    |                                | 11                                                           | [48.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_category#showusage) |
| 30   | pages          | revision               | 版本记录                                    |                                | 1,004                                                        | [512.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_revision#showusage) |
| 31   | pages          | archive            |                                             |                                | 1                                                            | [64.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_archive#showusage) |
| 32   | pages          | page_restrictions  |                                             |                                | 0                                                            | [80.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_page_restrictions#showusage) |
| 33   | pages          | page               | 条目名称，可以为中文,UTF8存储能正常显示     |                                | 126                                                          | [80.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_page#showusage) |
| 34   | pages          | text                   | 条目的实际 内容，binary存储，包括修改记录。 | 体积最大                       | 905                                                          | [9.5 MB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_text#showusage) |
| 35   | recent changes | recentchanges      | 最近更改                                    |                                | 334                                                          | [192.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_recentchanges#showusage) |
| 36   | recent changes | watchlist              |                                             |                                | 196                                                          | [48.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_watchlist#showusage) |
| 37   | resourceloader | msg_resource_links |                                             |                                | 43                                                           | [16.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_msg_resource_links#showusage) |
| 38   | resourceloader | msg_resource       |                                             |                                | 66                                                           | [16.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_msg_resource#showusage) |
| 39   | resourceloader | module_deps        |                                             |                                | 41                                                           | [64.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_module_deps#showusage) |
| 40   | search         | searchindex            | 检索索引                                    | 整理和存储类型与其它表不一样。 | 126                                                          | [2.1 MB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_searchindex#showusage) |
| 41   | statics        | sites_stats            |                                             |                                | 0                                                            | [144.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_sites#showusage) |
| 42   | tags           | valid_tag          |                                             |                                | 0                                                            | [16.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_valid_tag#showusage) |
| 43   | tags           | tag_summary        |                                             |                                | 0                                                            | [64.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_tag_summary#showusage) |
| 44   | tags           | change_tag         |                                             |                                | 0                                                            | [80.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_change_tag#showusage) |
| 45   | Users          | ipblocks               |                                             |                                | 0                                                            | [112.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_ipblocks#showusage) |
| 46   | Users          | user_former_groups |                                             |                                | 2                                                            | [16.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_user_former_groups#showusage) |
| 47   | Users          | user_properties    |                                             |                                | 1                                                            | [32.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_user_properties#showusage) |
| 48   | Users          | user_groups        |                                             |                                | 3                                                            | [32.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_user_groups#showusage) |
| 49   | Users          | user_newtalk       |                                             |                                | 0                                                            | [48.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_user_newtalk#showusage) |
| 50   | Users          | user               | 用户                                        |                                | 2                                                            | [64.0 KB](http://192.168.0.220/phpmyadmin/tbl_structure.php?db=2016_wiki&token=195a249bf25c526ef89117e2428c6442&goto=db_structure.php&table=2016_user#showusage) |

 

### 1.2.2 数据库表的结构组成

 

## 1.3   Main.php分析

 

 

 

# 2  MediaWiki用户指南

## 2.1   MediaWiki语法

 

 

 

# 3 MediaWiki开发

## 3.1   配置项修改LocalSettings.php 

参考：mediawiki源码分析-DefaultSettings变量说明 http://blog.csdn.net/fjgysai/article/details/2255246

将DefaultSettings.php的相应部分复制到LocalSettings.PHP，修改项可分为：

表格 4 DefaultSettings.PHP可设置变量

|                                               | 简介 | 典型字段                                              | 字段简介                         | 备注                                                         |
| --------------------------------------------- | ---- | ----------------------------------------------------- | -------------------------------- | ------------------------------------------------------------ |
| 通用设置                                      |      | $wgServer  L                                          | 服务器的UR                       | $wgServer最好改成IP，如果使用缺省localhost，会导致两台机器在同一台访问时重载出错。 |
|                                               |      | $wgServerName                                         |                                  |                                                              |
|                                               |      | $wgSitename                                           |                                  |                                                              |
| 路径                                          |      | $IP                                                   |                                  |                                                              |
|                                               |      |                                                       |                                  |                                                              |
| 共享上载                                      |      | $wgCacheSharedUploads                                 | 在memcached中缓存共享的元数据    |                                                              |
|                                               |      | $wgSharedUploadDirectory                              | 共享的上载目录所在的文件系统路径 |                                                              |
|                                               |      | $wgSharedUploadPath  $wgUseSharedUploads              |                                  |                                                              |
| Email 设置                                    |      | $wgEmergencyContact                                   | 站点管理员的email地址。          |                                                              |
|                                               |      | $wgEnableEmail  $wgEnableUserEmail                    |                                  |                                                              |
| [数据库](http://lib.csdn.net/base/14)设置 |      | $wgDBconnection                                       |                                  |                                                              |
|                                               |      | $wgDBname  $wgDBpassword                              | 名称、密码                       |                                                              |
|                                               |      | $wgDBprefix                                           |                                  |                                                              |
| 共享数据库设置                                |      | $wgSharedDB                                           | 多个wiki站点共享的数据库名称     |                                                              |
| 系统管理员SQL查询                             |      | $wgAllowSysopQueries   $wgDBsqlpassword  $wgDBsqluser |                                  |                                                              |
| memcached  的设置                             |      | $wgLinkCacheMemcached  $wgMemCachedServers  …         |                                  |                                                              |
| 本地化配置                                    |      | $wgInputEncoding                                      | 输入文本编码方式                 |                                                              |
| 调试/日志记录                                 |      |                                                       |                                  |                                                              |
| Profiling                                     |      |                                                       |                                  |                                                              |
| 网站定制                                      |      |                                                       |                                  |                                                              |
| 名称空间                                      |      |                                                       |                                  |                                                              |
| 皮肤                                          |      | $wgDefaultSkin   $wgSkipSkin                          |                                  |                                                              |
| 分类                                          |      |                                                       |                                  |                                                              |
| 缓存                                          |      |                                                       |                                  |                                                              |
| Persistent链接缓存                            |      |                                                       |                                  |                                                              |
| Interwiki                                     |      | $wgInterwikiExpiry  $wgLocalInterwiki                 | interwiki表的缓存有效期。        |                                                              |
| 权限设置                                      |      |                                                       |                                  |                                                              |
| 频率限制器                                    |      | $wgRateLimitLog   $wgRateLimits                       |                                  |                                                              |
| 代理                                          |      |                                                       |                                  |                                                              |
| Squid                                         |      |                                                       |                                  |                                                              |
| Cookies                                       |      |                                                       |                                  |                                                              |
| 缩减某些网站功能                              |      |                                                       |                                  |                                                              |
| 上载                                          |      |                                                       |                                  |                                                              |
| MIME类型                                      |      |                                                       |                                  |                                                              |
| 防止病毒                                      |      |                                                       |                                  |                                                              |
| 解释器                                        |      |                                                       |                                  |                                                              |
| HTML                                          |      |                                                       |                                  |                                                              |
| TeX                                           |      |                                                       |                                  |                                                              |
| Tidy                                          |      |                                                       |                                  |                                                              |
| 图像                                          |      |                                                       |                                  |                                                              |
| 最新更改                                      |      |                                                       |                                  |                                                              |
| UDP更新                                       |      |                                                       |                                  |                                                              |
| 版权                                          |      |                                                       |                                  |                                                              |
| 扩展                                          |      |                                                       |                                  |                                                              |
| HTCP  multicast purging                       |      |                                                       |                                  |                                                              |
| 其他设置                                      |      |                                                       |                                  |                                                              |
|                                               |      |                                                       |                                  |                                                              |

注：总共可分为三十九大设置，N多设置字段。

 

修改LocalSettings.php，可修改数据库相关配置项、网站路径等等。

- **服务器域名 $wgServer** 

```properties
# $wgServer - The base URL of the server. 
# 缺省值是$wgServer = "localhost"，此项如果本地和远程都安装有mediawiki下，远程的会跳转到本地，所以远程的需要修改为IP或者有效域名
$wgServer = "http://giprs.org";
```

- **修改数据库相关：数据库名称、用户、密码、表前缀**
- **禁止新用户注册：**

```ini
#Prevent new user registrations
$wgWhitelistAccount = array ( "user" => 0, "sysop" => 1, "developer" => 1 ); 
```

- **禁止匿名用户编辑**

```ini
#$wgGroupPermissions = array();
$wgGroupPermissions['*''createaccount']   = false;
$wgGroupPermissions['*']['read']            = true;
$wgGroupPermissions['*']['edit']            = false; 
```

- **用户组访问权限控制**

```ini
# access control, add by Denny, 2011.1.10
## usergroup: *, user, sysop
## right: read, edit, createaccount
$wgGroupPermissions['*'    ]['createaccount']   = false;
$wgGroupPermissions['*']['read'] = false;
$wgGroupPermissions['user']['read'] = true;
```

- **反垃圾留言**

以下带图片链接的留言将被禁止
```ini
$wgSpamRegex="/"."\[\[Image\:.*\.jpg\|thumb\|\]\]"."/";

# MediaWiki安装后切换英文版为汉字版
$wgLanguageCode = "zh";

# 支持HTML语言
$wgRawHtml = true;
```

 

## 3.2   首页修改

### 3.2.1 左侧导航[MediaWiki:Sidebar](http://localhost/mediawiki-1.26.0/index.php/MediaWiki:Sidebar)

在搜索框中直接输入：mediawiki:sidebar
 点击确定，你会看到左侧导航的设置的相关代码。可以用编辑普通条目的方式编辑， 下面是原始页面，二级分类下的每个词都是mediawiki预定义变量，可用mediawiki:xx编辑（xx如heppage)。 

```
* navigation
** mainpage|mainpage-description
** recentchanges-url|recentchanges
** randompage-url|randompage
** helppage|help
* SEARCH
* TOOLBOX
* LANGUAGES
```

### 3.2.2 其它常用修改

- 提示信息修改：编辑Special:Allmessages
- 首页的标题：     MediaWiki:Mainpage 
- 页脚的Privacy     policy： MediaWiki:Privacy ，网站的隐私政策
- 页脚的Disclaimers： MediaWiki:Disclaimers ，网站的免责声明
- 浏览器标题栏提示：     MediaWiki:pagetitle



## 3.3   清除页面缓存

- 网址链接加参数：     &action=purge，这可能需要几分钟之后才能见到效果。
- 清空数据库对应的表单：     objectcache，效果不明显
- 在LocalSettings.php中设置$wgCacheEpoch全局变量，强制现有缓冲过期

## 3.4   多语言版如繁简共存版本

参考：MediaWiki 设置：多语言文字方案http://www.cnblogs.com/sink_cup/archive/2013/04/11/2057127.html

 对于同一条提示信息应同时修改6个版本： 

```
   mediawiki:xxx
   mediawiki:xxx/zh
   mediawiki:xxx/zh-cn
   mediawiki:xxx/zh-tw
   mediawiki:xxx/zh-hk
   mediawiki:xxx/zh-sg 
```

### 3.4.1 方案1：多个wiki、多个数据库、多语言文字外链导航

效果：在左侧边栏下面出现多语言文字的外链导航，截图如下。

英文版wiki首页：http://localhost/wiki/en/index.php/

汉字版wiki首页：http://localhost/wiki/zh/index.php/

英文文章地址：http://localhost/wiki/en/index.php/Hello

汉字文章地址： http://localhost/wiki/zh/index.php/你好

优点：uri可任意，可以使用“Hello”、“你好”的格式。界面跟着uri变化，英文的文章界面也是英文的。

参考：http://www.mediawiki.org/wiki/Manual:Interwiki

 

**安装步骤：**

每种语言文字独立安装1套wiki、1套数据库。

比如安装了en和zh版的。

en版：http://localhost/wiki/en/

zh版：http://localhost/wiki/zh/

登录到en版的数据库中，在interwiki表中加入zh版的链接。命令如下：

```mysql
mysql -uwiki_en -p1 wiki_en
mysql> INSERT INTO `interwiki` VALUES('zh','http://localhost/wiki/zh/$1',0,0);
```

然后在en版中建立Hello页面，内容如下：

[[zh:你好]]

Hello



### 3.4.2 方案2：1个wiki、1个数据库、多语言文字内链导航

效果：在左侧边栏下面出现多语言文字的内链导航，截图如下。

wiki首页：http://localhost/wiki/test/index.php/

英文文章：http://localhost/wiki/test/index.php/Hello

汉字文章：http://localhost/wiki/test/index.php/你好

优点：不用安装扩展，不用安装多个wiki，融合了方案1和方案2的优点。uri可任意，可以使用“Hello”和“你好”，也可以使用“Hello”和“Hello/zh”。

todo：界面随着文章内容变化，比如Hello的界面是英文的，Hello/zh的界面是汉字的。需要自己修改一下mediawiki的代码。

 

**步骤：**

```sql
mysql -uwiki_test -p1 wiki_test
mysql> INSERT INTO `interwiki` VALUES('zh','./$1',0,0);
mysql> INSERT INTO `interwiki` VALUES('en','./$1',0,0);
```

然后建立“Hello”页面，内容如下：

[[zh:你好]]

Hello World.

然后建立“你好”页面，内容如下：

[[en:Hello]]

你好，世界。

```
 
```

## 3.5   手机版

先去http://www.mediawiki.org 下载最新的版本

需求：Release for **MediaWiki ≤ 1.24** of MobileFrontend requires the extension [Mantle](https://www.mediawiki.org/wiki/Special:MyLanguage/Extension:Mantle).

再去下载移动版插件MobileFrontend，http://www.mediawiki.org/wiki/Extension:MobileFrontend

将名为MobileFrontend的文件夹解压缩后上传到你的wiki网站根目录下的extensions文件夹下

将你wiki根目录下的文件LocalSettings.php打开，在该文件的底部加入代码：

```php
require_once __DIR__ . "/extensions/MobileFrontend/MobileFrontend.php";
$wgMFAutodetectMobileView = true;
```

基本上就完成了。

打开你的wiki网站域名，http://xxxx.com/index.php?title=Special:Version，看看是否已经启用。

不过这个时候使用手机访问时还不能自动跳转，需要手动切换，如果想自动跳转到手机版，可以在wiki根目录下的文件LocalSettings.php加入代码

`$wgMFAutodetectMobileView = true;`

OK，可以用了。

 

## 3.6   多站点共用程序 

 

## 3.7   模块扩展

# 4 MediaWiki迁移和升级

## 4.1   WIKI文件的备份：拷贝

- 文件的必要备份：包括图片、icon、skin等等

  localsetting.php：这是mediawiki的配置文件，里面包含数据库帐号信息、mediawiki部分参数的设置等

  skins/common/images/wiki.png：这是老版本首页的LOGO，MediaWiki 1.26后缺省四个皮肤分别是CologneBlue、Modern、MonoBook和Vector

  /images/目录：这是所有上传图片的存放目录，还包括自动生成的缩略图。图片路径包含数字。

  AdminSetting.php：Template:? 

以下部分仅对使用了该特性的用户需要备份。

  /extensions/目录：如果你使用了外部扩展程序，那么需要备份下来。

  /skins/目录：如果你扩展了皮肤，那么应备份相应文件及子目录

  .htaccess文件：如果你使用了路径改写，应备份此文件。

## 4.2   MediaWiki数据导入导出方法

1. 使用MediaWiki的特殊页面：你的网站域名/Special:Import。

2. 使用MediaWiki自带的php命令：importDump.php。 

3. 1. 使用SSH登录服务器。比如常用的SSH软件：PuTTY。
   2. 进入maintenance目录。
   3. 上传你的xml文件到maintenance目录中。
   4. 使用命令：php      importDump.php 文件名.xml。
   5. 使用命令：php rebuildrecentchanges.php，刷新特殊页面 Special:RecentChanges，可以看到最新导入的文章情况。（更多php命令请参见：MediaWiki      Maintenance）

4. 使用MediaWiki自带的php命令：mwdumper。

 

**WIKI条目页面的备份：导入导出**

本备份针对WIKI编辑员，可通过特殊页面的[特殊:导出页面](http://localhost/mediawiki-1.26.0/index.php/特殊:导出页面)来获得内容。然后在另外一个WIKI用导入页面来生成内容。

一是分类页面：如本WIKI的分类只有四种，分别是导航（包括导航、帮助和计划）、项目、知识和设计文档。

二是链入页面：对部分重要条目，可以利用链接导出文件的XML格式。如[特殊:导出页面/首页](http://localhost/mediawiki-1.26.0/index.php/特殊:导出页面/首页)、[USER:denny](http://localhost/mediawiki-1.26.0/index.php/用户:Denny)

 

## 4.3   数据库的迁移

可在LocalSettings修改数据库的名称、用户名、密码和表前缀。

* 数据库表名修改：可在导出的SQL语句中修改表名。DROP TABLE 旧表名；CREATE TABLE 新表名

 

数据库的备份恢复
* 数据库备份： mysqldump -h [host] -u [user] -p[pwd] [dbname]
* 数据库恢复： mysql -u[user] -p [dbname] < [xxx.sql]

 

**mediawiki数据库的安装配置选项**

详见:http://www.mediawiki.org/wiki/Manual:$wgDBmysql5 
 缺省参数(首项):　Mysql(InnoDB), BIN 

$wgDBTableOptions  = "TYPE=InnoDB";

$wgDBmysql5: Set to true to set MySQL connection into UTF-8 encoding

- 数据库连接编码选项有三:　binary, utf8, 向后兼容mysql4.

如果是true,则是binary/utf8, SET NAMES=utf8;　如果是false, 则是向后兼容mysql4, SET NAMES binary; NOTE: 本wiki考虑到早期在mysql4环境,选择了向后兼容. 所以要此选择为$wgDBmysql5=false. 如果此选择出现问题,则条目标题将会乱码,但条目内容編碼正常. 有修改项:在include/db/DatabaseMysql.php doQuery函数头设置 set NAMES utf8;效果不佳. 

- 条目乱码问题　(未彻底解决，供参考）

Storage Engine：InnoDB, MyISAM

Database character set：MySQL 4.1/5.0 binary, MySQL 4.1/5.0 UTF-8, MySQL 4.0 backwards-compatible UTF-8

if : 

InnoDB + MySQL 4.1/5.0 binary

--> $wgDBTableOptions  = "ENGINE=InnoDB"; $wgDBmysql5 = true;

InnoDB + MySQL 4.1/5.0 UTF-8

--> $wgDBTableOptions  = "ENGINE=InnoDB, DEFAULT CHARSET=utf8"; $wgDBmysql5 = true;

InnoDB + MySQL 4.0 backwards-compatible UTF-8

--> $wgDBTableOptions  = "ENGINE=InnoDB"; $wgDBmysql5 = false;



==sodenny.com

```sql
$show variables;
character_set_client    utf8mb4
character_set_connection   utf8mb4
character_set_database     latin1
character_set_filesystem    binary
character_set_results  utf8mb4
character_set_server   latin1
character_set_system  utf8
character_sets_dir     /usr/share/mysql/charsets/
```

==ubuntu

character_set_system  utf8

其它：latin1

```
 
```

## 4.4   MediaWiki的升级

### 4.4.1 升级前

进行下面系列操作：

1） 备份WIKI文件、图片等等。

2） 备份WIKI条目内容（可需）

3） 备份数据库

 

### 4.4.2 升级中

在Linux命令行下操作：
```sh
vi oldpath/LocalSettings.php  ; 修改老目录配置文件，增加$wgReadOnly="Read Only Now"，老网站改为只读方式

cp newpath/AdminSettings.sample newpath/AdminSettings.php ; 复制生成AdminSetting.php文件供maintenance程序使用

vi newpath/AdminSettings.php ; 设置数据库用户名、密码

cd newpath/maintenance ; 进入升级程序所在的维护目录

php update.php ; 运行升级程序（如果遇到DPL扩展报错，也可以Web方式使用重新安装的办法来进行升级）

rm -fdr newpath/images ; 删除新目录中的images目录及其下面的所有子目录、文件

mv oldpath/images newpath ; 移动老目录中的images目录到新目录

vi /usr/local/apache2/conf/httpd.conf ; 修改Apache配置文件中站点对应的目录从老目录改为新目录

cd /usr/local/apache2/bin ; 进入Apache运行程序目录

./httpd -k restart ; 重启Apache程序，启用新目录中的mediawiki新版本
```


### 4.4.3 升级后

- 根据需要，将MediaWiki重新生成的首页恢复为以前的内容
- 用showJobs.php查看工作队列，runJobs.php进行运行处理
- 根据需要运行refreshLinks.php,     rebuildrecentchanges.php等
- 复制、修改robots.txt
- 升级完成后全面检查新网站
- 重点检查扩展程序使用是否正常，是否需要跟踪升级
- 查看各菜单项目，检查一些语言设置文件是否变化
- 查看网站的各种代表性页面，及时发现版本之间的不同点
- 注意查看页面源文件的对比，包括是否正确使用文件缓存等
- 反复修改、检查，直到确认完全升级成功

 

# 5 参考资料

## 5.1   参考链接

[1].   [MediaWike用户指南](http://localhost/mediawiki-1.26.0/index.php/MediaWike用户指南) 

[2].   [MediaWiki升级步骤](http://localhost/mediawiki-1.26.0/index.php/MediaWiki升级步骤)

[3].   如何快速的为你的Mediawiki增加内容http://www.uedsc.com/how-fast-add-content-to-mediawiki.html

 

官网帮助指南：

·     [Category:帮助文档](http://zh.wikipedia.org/wiki/Category:帮助文档)

·     [Help](https://www.mediawiki.org/wiki/Special:MyLanguage/Help:Contents) [Help:目录](http://zh.wikipedia.org/wiki/Help:目录) 

·     [MediaWiki 配置设置列表](http://www.mediawiki.org/wiki/Manual:Configuration_settings)

·     [MediaWiki 常见问题解答](http://www.mediawiki.org/wiki/Manual:FAQ)

·     [MediaWiki 发布邮件列表](http://lists.wikimedia.org/mailman/listinfo/mediawiki-announce)

·     https://dumps.wikimedia.org/zhwiki/20160501/

 

## 5.2   各类wiki收录

综合类 

- [Denny in wikipedia](http://zh.wikipedia.org/wiki/User:Denny-cn)　维基百科,最大最全的百科. 
- [网络天书](http://www.cnic.org) http://www.cnic.org     
- [维库](http://www.wikilib.com) 口号为“知识与思想的自由文库”，内容比较小资。

IT类 

- [啄木鸟Python社区](http://wiki.woodpecker.org.cn)
- [xoops](http://xoops.org.cn/modules/mediawiki/index.php/首页)     xoops中文站点wiki 
- [opencv中文站点](http://www.opencv.org.cn) 中科院自动化所自由软件协会维护。
- [TransWiki      ](http://zh.transwiki.org)W3CHINA.ORG组织的开放翻译计划，利用wiki协作特性开展W3C及其他重要标准的中文翻译。 
- [台湾Mozilla知识库](http://wiki.moztw.org) 
- [香港开源维基](http://wiki.linux.org.hk) 由香港的三家Linux网站共同维护的中文Open Source及Linux的知识库。（繁体）

专题类 

- [实用查询](http://cn18dao.jamesqi.com/) 
- [背包攻略](http://www.backpackers.com.tw/guide/) 为全球华人旅游爱好者建立的免费网上导引。“背包客栈”志愿者制做。
- [wikihow](http://www.wikihow.com/)      Ｔhe How to Manual 一个提供做一件事步骤的专题站点，蛮有创意的。

 