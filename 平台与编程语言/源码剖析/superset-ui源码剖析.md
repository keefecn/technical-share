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
# 说明: 下面superset-ui版本是0.17.84（插件版本号同cahrt-controls），图表插件模块一般依赖core和chart-controls.
[ai@localhost superset-frontend]$ npm list |grep superset-ui
├─┬ @superset-ui/chart-controls@0.17.84
│ ├── @superset-ui/core@0.17.81 deduped
├─┬ @superset-ui/core@0.17.81
├─┬ @superset-ui/legacy-plugin-chart-calendar@0.17.84
├─┬ @superset-ui/legacy-plugin-chart-chord@0.17.84
├─┬ @superset-ui/legacy-plugin-chart-country-map@0.17.84
├─┬ @superset-ui/legacy-plugin-chart-event-flow@0.17.84
├─┬ @superset-ui/legacy-plugin-chart-force-directed@0.17.84
├─┬ @superset-ui/legacy-plugin-chart-heatmap@0.17.84
├─┬ @superset-ui/legacy-plugin-chart-histogram@0.17.84
├─┬ @superset-ui/legacy-plugin-chart-horizon@0.17.84
├─┬ @superset-ui/legacy-plugin-chart-map-box@0.17.84
├─┬ @superset-ui/legacy-plugin-chart-paired-t-test@0.17.84
├─┬ @superset-ui/legacy-plugin-chart-parallel-coordinates@0.17.84
├─┬ @superset-ui/legacy-plugin-chart-partition@0.17.84
├─┬ @superset-ui/legacy-plugin-chart-pivot-table@0.17.84
├─┬ @superset-ui/legacy-plugin-chart-rose@0.17.84
├─┬ @superset-ui/legacy-plugin-chart-sankey@0.17.84
├─┬ @superset-ui/legacy-plugin-chart-sankey-loop@0.17.84
├─┬ @superset-ui/legacy-plugin-chart-sunburst@0.17.84
├─┬ @superset-ui/legacy-plugin-chart-treemap@0.17.84
├─┬ @superset-ui/legacy-plugin-chart-world-map@0.17.84
├─┬ @superset-ui/legacy-preset-chart-big-number@0.17.84
├─┬ @superset-ui/legacy-preset-chart-deckgl@0.4.10
├─┬ @superset-ui/legacy-preset-chart-nvd3@0.17.84
├─┬ @superset-ui/plugin-chart-echarts@0.17.84
├─┬ @superset-ui/plugin-chart-pivot-table@0.17.84
│ └─┬ @superset-ui/react-pivottable@0.12.12
├─┬ @superset-ui/plugin-chart-table@0.17.84
├─┬ @superset-ui/plugin-chart-word-cloud@0.17.84
├─┬ @superset-ui/preset-chart-xy@0.17.84
```

**备注**：下面章节的模块路径会忽略前缀 @superset-ui。



### 源码结构

表格 模块包说明

| 一级目录 | 二级目录                   | 包.Package                                                   | 说明                                                         |
| -------- | -------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| packages | superset-ui-demo           |                                                              | demo，包括在线调试页面storybook                              |
| 同上     | superset-ui-core           | [@superset-ui/core](https://github.com/apache-superset/superset-ui/tree/master/packages/superset-ui-core) | 公共代码。                                                   |
| 同上     | superset-ui-chart-controls | [@superset-ui/chart-controls](https://github.com/apache-superset/superset-ui/tree/master/packages/superset-ui-chart-controls) | 图表控制项。                                                 |
| 同上     | generator-superset         | [@superset-ui/generator-superset](https://github.com/apache-superset/superset-ui/tree/master/packages/generator-superset) | 用来生成superset-ui包或插件。                                |
| plugins  | legacy-plugin-chart-xx     | `@superset-ui/legacy-*`                                      | 软件包从经典的中提取并转换为插件。 这些包的提取只需很小的更改（几乎保持原样）。<br>它们还依靠旧版API（ viz.py ）起作用。<br>图表有20个：calendar chord country-map event-flow force-directed heatmap histogram horizon map-box paired-t-test parallel-coordinates partition pivot-table rose sankey sankey-loop sunburst time-table treemap world-map |
| 同上     | legacy-preset-chart-xx     | 同上                                                         | 当前正在转化的包。<br>图表有2个：big-number nvd3             |
| 同上     | plugin-chart-xx            | `@superset-ui/plugin-*`                                      | 软件包通常较新且质量更高。 <br/>它们不依赖viz.py（包含可视化特定的python代码）并与/api/v1/query/交互的主要区别在于：新的通用终结点旨在提供所有可视化。 还应该用Typescript编写。<br>图表有：**echarts** (boxplot funnel gauge graph mixedTimeseries pie radar timeseries tree treemap)  hello-world  **table**  **pivot-table**  **word-cloud**  **xy** |
| scripts  | build.js                   |                                                              | build命令的实际执行脚本。                                    |
|          | commitlint.js              |                                                              |                                                              |
|          | copyAssets.js              |                                                              |                                                              |



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

说明：每个插件包都有类似的文件结构，都能单独构建。源码src，构建输出目录在lib和esm。

单个插件包的构建命令

```shell
$ cd packages/package1
$ npm ci
$ npm run build
```



### 贡献指南 Contributing guidelines

Please read the [contributing guidelines](CONTRIBUTING.md) which include development environment setup and other things you should know about coding in this repo.

`npm run`主要命令 （在package.json定义）

* build  构建打包
* demo
* storybook  生成不依赖superset的在线调试页面



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

Superset v1.3+前端用到的Pie来自于 plugin-chart-echarts.



## 2 核心模块 /core/





## 3 遗产模块 /legacy-*

### legacy-plugin-chart-country-map/

国家地图文档 [Legacy Chart Plugins / legacy-plugin-chart-country-map - Basic ⋅ Storybook (superset-ui.vercel.app)](https://superset-ui.vercel.app/?path=/story/legacy-chart-plugins-legacy-plugin-chart-country-map--basic)



**country-map 源码结构**

| 一级目录 | 目录或文件                                                   | 详述                                                         |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| scripts  | Country Map GeoJSON Generator.ipynb                          | 更新地图                                                     |
| src      | countries/*.geojson                                          | 各国（目前共44个）的geo数据，如将中国地名英文改为中文，可在china.geojson修改。 |
|          | images                                                       |                                                              |
|          | controlPanel.ts countries.ts<br>CountryMap.css CountryMap.js |                                                              |
|          | geojson.d.ts index                                           |                                                              |
|          | ReactCountryMap.tx transformProps.js                         |                                                              |



**使用**

```js
import CountryMapChartPlugin from '@superset-ui/legacy-plugin-chart-country-map';

// 注册key值定向到 国家地图插件, key值可以是任意值，下面是country-map
new CountryMapChartPlugin().configure({ key: 'country-map' }).register();

<SuperChart
  chartType="country-map"
  width={600}
  height={600}
  formData={...}
  queriesData={[{
    data: {...},
  }]}
/>
```



###  legacy-plugin-chart-xx/





## 4 优质模块 /plugin-*





## 5 脚本 /scripts/

### build.js

从传参中获取是否执行lint, babel, clean（清除缓存）, tsc（ts类型检测）。调用fastGlob同步模式匹配到的文件。再根据传参参数执行相应操作。

```js
#!/bin/env node
/* eslint-disable no-console */
/**
 * Build packages/plugins filtered by globs
 */
process.env.PATH = `./node_modules/.bin:${process.env.PATH}`;

const rimraf = require('rimraf');
const { spawnSync } = require('child_process');
const fastGlob = require('fast-glob');
const { argv } = require('yargs')	//解析传参
  .option('lint', {
    describe: 'whether to run ESLint',
    type: 'boolean',
    // lint is slow, so not turning it on by default
    default: false,
  })
  .option('babel', {
    describe: 'Whether to run Babel',
    type: 'boolean',
    default: true,
  })
  .option('clean', {
    describe: 'Whether to clean cache',
    type: 'boolean',
    default: false,
  })
  .option('type', {
    describe: 'Whether to run tsc',
    type: 'boolean',
    default: true,
  });

const {
  _: globs,
  lint: shouldLint,
  babel: shouldRunBabel,
  clean: shouldCleanup,
  type: shouldRunTyping,
} = argv;	//从传参中获取各变量的值
const glob = globs.length > 1 ? `{${globs.join(',')}}` : globs[0] || '*';

const BABEL_CONFIG = '--config-file=../../babel.config.js';

// packages that do not need tsc
const META_PACKAGES = new Set(['demo', 'generator-superset']);

function run(cmd, options) {
  console.log(`\n>> ${cmd}\n`);
  const [p, ...args] = cmd.split(' ');
  const runner = spawnSync;
  const { status } = runner(p, args, { stdio: 'inherit', ...options });
  if (status !== 0) {
    process.exit(status);
  }
}

function getPackages(packagePattern, tsOnly = false) {
  let pattern = packagePattern;
  if (pattern === '*' && !tsOnly) {
    return `@superset-ui/!(${[...META_PACKAGES].join('|')})`;
  }
  if (!pattern.includes('*')) {
    pattern = `*${pattern}`;
  }
  const packages = [
    ...new Set(
      fastGlob
        .sync([
          `./node_modules/@superset-ui/${pattern}/src/**/*.${
            tsOnly ? '{ts,tsx}' : '{ts,tsx,js,jsx}'
          }`,
        ])
        .map(x => x.split('/')[3])
        .filter(x => !META_PACKAGES.has(x)),
    ),
  ];
  if (packages.length === 0) {
    throw new Error('No matching packages');
  }
  return `@superset-ui/${packages.length > 1 ? `{${packages.join(',')}}` : packages[0]}`;
}

let scope = getPackages(glob);  //调用fastGlob同步模式匹配到的文件

if (shouldLint) {
  run(`npm run lint --fix {packages,plugins}/${scope}/{src,test}`);
}

if (shouldCleanup) {
  // these modules will be installed by `npm link` but not useful for actual build
  const dirtyModules = 'node_modules/@types/react,node_modules/@superset-ui';
  const cachePath = `./node_modules/${scope}/{lib,esm,tsconfig.tsbuildinfo,${dirtyModules}}`;
  console.log(`\n>> Cleaning up ${cachePath}`);
  rimraf.sync(cachePath);
}

if (shouldRunBabel) {
  console.log('--- Run babel --------');
  const babelCommand = `lerna exec --stream --concurrency 10 --scope ${scope}
         -- babel ${BABEL_CONFIG} src --extensions ".ts,.tsx,.js,.jsx" --copy-files`;
  run(`${babelCommand} --out-dir lib`);

  console.log('--- Run babel esm ---');
  // run again with
  run(`${babelCommand} --out-dir esm`, { env: { ...process.env, BABEL_OUTPUT: 'esm' } });
}

if (shouldRunTyping) {
  // only run tsc for packages with ts files
  scope = getPackages(glob, true);
  run(`lerna exec --stream --concurrency 3 --scope ${scope} \
       -- ../../scripts/tsc.sh --build`);
}
```







## 参考资料

**参考网站**

* lerna  https://www.lernajs.cn/



**参考链接**

