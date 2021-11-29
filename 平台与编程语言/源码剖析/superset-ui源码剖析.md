| 序号 | 修改时间 | 修改内容                                   | 修改人 | 审稿人 |
| ---- | -------- | ------------------------------------------ | ------ | ------ |
| 1   | 2021-11-17 | 创建。 | Keefe |   Keefe     |
|      |            |          |        |        |







---

[TOC]



----

## 1 简述

官网： https://apache-superset.github.io/superset-ui/

文档： https://superset-ui.now.sh/  



```shell
# 说明: 下面superset-ui版本是0.17.84,图表插件模块一般基于core版本构建.
[ai@localhost superset-frontend]$ npm list |grep superset-ui
├─┬ @superset-ui/chart-controls@0.17.84
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/core@0.17.81
├─┬ @superset-ui/legacy-plugin-chart-calendar@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/legacy-plugin-chart-chord@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/legacy-plugin-chart-country-map@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/legacy-plugin-chart-event-flow@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/legacy-plugin-chart-force-directed@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/legacy-plugin-chart-heatmap@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/legacy-plugin-chart-histogram@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/legacy-plugin-chart-horizon@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/legacy-plugin-chart-map-box@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/legacy-plugin-chart-paired-t-test@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/legacy-plugin-chart-parallel-coordinates@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/legacy-plugin-chart-partition@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/legacy-plugin-chart-pivot-table@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/legacy-plugin-chart-rose@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/legacy-plugin-chart-sankey@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/legacy-plugin-chart-sankey-loop@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/legacy-plugin-chart-sunburst@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/legacy-plugin-chart-treemap@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/legacy-plugin-chart-world-map@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/legacy-preset-chart-big-number@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/legacy-preset-chart-deckgl@0.4.10
├─┬ @superset-ui/legacy-preset-chart-nvd3@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/plugin-chart-echarts@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/plugin-chart-pivot-table@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
│ └─┬ @superset-ui/react-pivottable@0.12.12
├─┬ @superset-ui/plugin-chart-table@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/plugin-chart-word-cloud@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/preset-chart-xy@0.17.84
│ ├── @superset-ui/chart-controls@0.17.84 deduped
│ ├── @superset-ui/core@0.17.81 deduped
```

**备注**：下面章节的模块路径会忽略前缀 @superset-ui。



### 源码结构 

表格 模块包说明

| 包类别     | 包.Package                                                   | 说明                                                         |
| ---------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Core       | [@superset-ui/core](https://github.com/apache-superset/superset-ui/tree/master/packages/superset-ui-core) |                                                              |
| Core       | [@superset-ui/chart-controls](https://github.com/apache-superset/superset-ui/tree/master/packages/superset-ui-chart-controls) |                                                              |
| Core       | [@superset-ui/generator-superset](https://github.com/apache-superset/superset-ui/tree/master/packages/generator-superset) |                                                              |
| 图表插件包 | `@superset-ui/legacy-*`                                      | 软件包从经典的中提取并转换为插件。 这些包的提取只需很小的更改（几乎保持原样）。<br>它们还依靠旧版API（ viz.py ）起作用。<br>图表有： |
| 图表插件包 | `@superset-ui/plugin-*`                                      | 软件包通常较新且质量更高。 <br/>它们不依赖viz.py （包含可视化特定的python代码）并与/api/v1/query/交互的主要区别在于：新的通用终结点旨在提供所有可视化。 还应该用Typescript编写。<br>图表有： |



**文件组织结构**

[lerna](https://github.com/lerna/lerna/) and [npm](https://www.npmjs.com/) 用来管理版本和包之间依赖。

```shell
superset-ui/
  lerna.json
  package.json
  ...
  packages/
    package1/
      package.json
      ...
      src/
      test/  # unit tests
      types/ # typescript type declarations
      ...
      lib/   # commonjs output
      esm/   # es module output
      ...
    ...
```



### 贡献指南 Contributing guidelines

Please read the [contributing guidelines](CONTRIBUTING.md) which include development environment setup and other things you should know about coding in this repo.



### 二次开发示例

以饼图pie 为例, 涉及以下文件:

```shell
[ai@localhost node_modules]$ find -iname "*pie"
./@superset-ui/legacy-preset-chart-nvd3/esm/Pie
./@superset-ui/legacy-preset-chart-nvd3/lib/Pie
./@superset-ui/plugin-chart-echarts/esm/Pie
./@superset-ui/plugin-chart-echarts/lib/Pie
./echarts/lib/chart/pie
./echarts/types/src/chart/pie
```

Superset v1.3前端用到的Pie来自于 plugin-chart-echarts.



## 2 核心模块 /core



## 3 遗产模块 /legacy-*



## 4 优质模块 /plugin-*





## 参考资料

**参考网站**

* lerna  https://www.lernajs.cn/



**参考链接**

