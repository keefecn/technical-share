| 序号 | 修改时间 | 修改内容                                   | 修改人 | 审稿人 |
| ---- | -------- | ------------------------------------------ | ------ | ------ |
| 1   | 2021-11-17 | 创建。 | Keefe |   Keefe     |
|      |            |          |        |        |







<br>

---

[TOC]



<br>

----

# 1 简述

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



## 源码结构

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
      lib/   # commonjs output  公共js输出
      esm/   # es module output es模块输出
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



## 贡献指南 Contributing guidelines

Please read the [contributing guidelines](CONTRIBUTING.md) which include development environment setup and other things you should know about coding in this repo.

`npm run`主要命令 （在package.json定义）

* build  构建打包
* demo
* storybook  生成不依赖superset的在线调试页面



## 二次开发示例

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



<br>

# 2 核心模块 /core/

表格  core的源码结构

| 一级目录&文件      | 二级目录或文件 | 主要类&函数 | 说明       |
| ------------------ | -------------- | ----------- | ---------- |
| chart/             |                |             | 图表       |
| chart-composition/ |                |             |            |
| color/             |                |             | 颜色       |
| components/        |                |             | 组件       |
| connection/        |                |             | 连接       |
| dimension/         |                |             | 尺寸       |
| dynamic-plugins/   |                |             | 动态插件   |
| math-expression    |                |             | 数学表达式 |
| models/            |                |             | 模型       |
| number-format/     |                |             | 数字格式   |
| query/             |                |             | 查询       |
| style/             |                |             | 风格       |
| time-format/       |                |             | 时间格式   |
| translation/       |                |             | 翻译       |
| types/             |                |             |            |
| utils/             |                |             | 工具库     |
| validator/         |                |             | 验证器     |
| index.ts           |                |             | 全局导入   |





<br>

# 3  遗产模块 /legacy-*

## legacy-plugin-chart-country-map/

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



##  legacy-plugin-chart-xx/





# 4 优质模块 /plugin-*

## 4.1 plugin-chart-echarts/

表格  plugin-chart-echarts的源码结构

| 一级目录&文件    | 二级目录或文件 | 说明         |
| ---------------- | -------------- | ------------ |
| BoxPlot/         |                | 箱图         |
| components/      | Echarts.tsx    | 公共组件     |
| Funnel/          |                | 漏斗         |
| Gauge/           |                | 仪表         |
| Graph/           |                | 图           |
| MixedTimeseries/ |                | 混合时间序列 |
| Pie/             |                | 饼图         |
| Radar/           |                | 雷达图       |
| Timeseries/      |                | 时间序列     |
| Tree/            |                | 树           |
| Treemap/         |                | 树           |
| utils/           |                | 工具库       |
| test/            |                |              |
| types/           |                |              |
| package.json     |                |              |
| tsconfig.json    |                |              |



### components/Echarts.tsx

```tsx
import React, { useRef, useEffect, useMemo, forwardRef, useImperativeHandle } from 'react';
import { styled } from '@superset-ui/core';
import { ECharts, init } from 'echarts';
import { EchartsHandler, EchartsProps, EchartsStylesProps } from '../types';

const Styles = styled.div<EchartsStylesProps>`
  height: ${({ height }) => height};
  width: ${({ width }) => width};
`;

function Echart(
  {
    width,
    height,
    echartOptions,
    eventHandlers,
    zrEventHandlers,
    selectedValues = {},
  }: EchartsProps,
  ref: React.Ref<EchartsHandler>,
) {
  const divRef = useRef<HTMLDivElement>(null);
  const chartRef = useRef<ECharts>();
  const currentSelection = useMemo(() => Object.keys(selectedValues) || [], [selectedValues]);
  const previousSelection = useRef<string[]>([]);

  ...
}

export default forwardRef(Echart);
```







### Pie/ 饼图

表格  饼图插件的源码结构

| 目录&文件         | 主要类&函数                                                  | 说明                                       |
| ----------------- | ------------------------------------------------------------ | ------------------------------------------ |
| images/           | 图片6张                                                      | 示例图                                     |
| buildQuery.ts     | buildQuery                                                   | 构建查询数据：查询对象、排序指标           |
| controlPanel.tsx  | config                                                       | 图表控制页板配置的参数（出现在图表详情页） |
| EchartsPie.tsx    | EchartsPie                                                   | pie数据/事件更改时的处理逻辑               |
| index.ts          | EchartsPieChartPlugin                                        | 定义Pie插件                                |
| transformProps.ts | formatPieLabel transformProps                                | 数据转换：格式化饼图标签、全局数据         |
| types.tx          | EchartsPieFormData EchartsPieLabelType<br>EchartsPieChartProps  DEFAULT_FORM_DATA <br>PieChartTransformedProps | 导出表单数据、标签类型、全局数据           |



buildQuery.ts

构建查询数据：查询对象、排序指标

```tsx
import { buildQueryContext, QueryFormData } from '@superset-ui/core';

export default function buildQuery(formData: QueryFormData) {
  const { metric, sort_by_metric } = formData;
  return buildQueryContext(formData, baseQueryObject => [
    {
      ...baseQueryObject,
      ...(sort_by_metric && { orderby: [[metric, false]] }),
    },
  ]);
}
```



controlPanel.tsx

控制面板的配置数据

```tsx
import React from 'react';
import { t, validateNonEmpty } from '@superset-ui/core';
import {
  ControlPanelConfig,
  ControlPanelsContainerProps,
  D3_FORMAT_DOCS,
  D3_FORMAT_OPTIONS,
  D3_TIME_FORMAT_OPTIONS,
  sections,
  emitFilterControl,
} from '@superset-ui/chart-controls';
import { DEFAULT_FORM_DATA } from './types';
import { legendSection } from '../controls';

// 表单数据
const {
  donut,
  innerRadius,
  labelsOutside,
  labelType,
  labelLine,
  outerRadius,
  numberFormat,
  showLabels,
} = DEFAULT_FORM_DATA;

const config: ControlPanelConfig = {
  controlPanelSections: [
    sections.legacyRegularTime,
      // 数据项
      // 自定义项
    ],  //控制面板选项

  controlOverrides: {  // 可重载项
    series: {
      validators: [validateNonEmpty],
      clearable: false,
    },
    row_limit: {
      default: 100,
    },
  },
};

export default config;
```



EchartsPie.tsx

```tsx
import React, { useCallback } from 'react';
import { PieChartTransformedProps } from './types';
import Echart from '../components/Echart';
import { EventHandlers } from '../types';

export default function EchartsPie({
  height,
  width,
  echartOptions,
  setDataMask,
  labelMap,
  groupby,
  selectedValues,
  formData,
}: PieChartTransformedProps) {
  // 数据更改时的处理回调函数
  const handleChange = useCallback(
        ...
        );

  // 事件处理器
  const eventHandlers: EventHandlers = {
    click: props => {
      const { name } = props;
      const values = Object.values(selectedValues);
      if (values.includes(name)) {
        handleChange(values.filter(v => v !== name));
      } else {
        handleChange([name]);
      }
    },
  };

  return (
    <Echart
      height={height}
      width={width}
      echartOptions={echartOptions}
      eventHandlers={eventHandlers}
      selectedValues={selectedValues}
    />
  );
}
```



index.ts

饼图插件定义

```tsx
import { Behavior, ChartMetadata, ChartPlugin, t } from '@superset-ui/core';
import buildQuery from './buildQuery';
import controlPanel from './controlPanel';
import transformProps from './transformProps';
import thumbnail from './images/thumbnail.png';
import example1 from './images/Pie1.jpg';
import example2 from './images/Pie2.jpg';
import example3 from './images/Pie3.jpg';
import example4 from './images/Pie4.jpg';
import { EchartsPieChartProps, EchartsPieFormData } from './types';

export default class EchartsPieChartPlugin extends ChartPlugin<
  EchartsPieFormData,
  EchartsPieChartProps
> {
  constructor() {
    super({
      buildQuery,
      controlPanel,
      loadChart: () => import('./EchartsPie'),
      metadata: new ChartMetadata({
        behaviors: [Behavior.INTERACTIVE_CHART],
        category: t('Part of a Whole'),
        credits: ['https://echarts.apache.org'],
        description:
          t(`The classic. Great for showing how much of a company each investor gets, what demographics follow your blog, or what portion of the budget goes to the military industrial complex.

        Pie charts can be difficult to interpret precisely. If clarity of relative proportion is important, consider using a bar or other chart type instead.`),
        exampleGallery: [
          { url: example1 },
          { url: example2 },
          { url: example3 },
          { url: example4 },
        ],
        name: t('Pie Chart'),
        tags: [
          t('Aesthetic'),
          t('Categorical'),
          t('Circular'),
          t('Comparison'),
          t('Percentages'),
          t('Popular'),
          t('Proportional'),
          t('ECharts'),
        ],
        thumbnail,
      }),
      transformProps,
    });
  }
}
```



transformProps.ts

数据转化

```tsx
import {
  CategoricalColorNamespace,
  DataRecordValue,
  getMetricLabel,
  getNumberFormatter,
  getTimeFormatter,
  NumberFormats,
  NumberFormatter,
} from '@superset-ui/core';
import { CallbackDataParams } from 'echarts/types/src/util/types';
import { EChartsCoreOption, PieSeriesOption } from 'echarts';
import {
  DEFAULT_FORM_DATA as DEFAULT_PIE_FORM_DATA,
  EchartsPieChartProps,
  EchartsPieFormData,
  EchartsPieLabelType,
  PieChartTransformedProps,
} from './types';
import { DEFAULT_LEGEND_FORM_DATA } from '../types';
import {
  extractGroupbyLabel,
  getChartPadding,
  getColtypesMapping,
  getLegendProps,
  sanitizeHtml,
} from '../utils/series';
import { defaultGrid, defaultTooltip } from '../defaults';
import { OpacityEnum } from '../constants';

const percentFormatter = getNumberFormatter(NumberFormats.PERCENT_2_POINT);

export function formatPieLabel({  // 格式化饼图标签
  params,
  labelType,
  numberFormatter,
  sanitizeName = false,
}: {
  params: Pick<CallbackDataParams, 'name' | 'value' | 'percent'>;
  labelType: EchartsPieLabelType;
  numberFormatter: NumberFormatter;
  sanitizeName?: boolean;
}): string {
  const { name: rawName = '', value, percent } = params;
  const name = sanitizeName ? sanitizeHtml(rawName) : rawName;
  const formattedValue = numberFormatter(value as number);
  const formattedPercent = percentFormatter((percent as number) / 100);

  switch (labelType) {  //根据标签类型返回 相应名称
    case EchartsPieLabelType.Key:
      return name;
    case EchartsPieLabelType.Value:
      return formattedValue;
    case EchartsPieLabelType.Percent:
      return formattedPercent;
    case EchartsPieLabelType.KeyValue:
      return `${name}: ${formattedValue}`;
    case EchartsPieLabelType.KeyValuePercent:
      return `${name}: ${formattedValue} (${formattedPercent})`;
    case EchartsPieLabelType.KeyPercent:
      return `${name}: ${formattedPercent}`;
    default:
      return name;
  }
}

export default function transformProps(chartProps: EchartsPieChartProps): PieChartTransformedProps {
  const { formData, height, hooks, filterState, queriesData, width } = chartProps;
  const { data = [] } = queriesData[0];
  const coltypeMapping = getColtypesMapping(queriesData[0]);
  ...

}
```



### Timeseries/ 时间序列图

时间序列图包括多种图表类型：面积图、直方图、线图、平滑线图、离散图等。

表格  时间序列图插件的源码结构

| 目录&文件             | 主要类&函数                                                  | 说明                                       |
| --------------------- | ------------------------------------------------------------ | ------------------------------------------ |
| Area/                 | images/ controlPanel.tsx index.tsx                           | 时间序列面积图                             |
| images/               | 图片2张                                                      | 示例图片                                   |
| Regular/              | Bar/ Line/ Scatter/  <br>SmoothLine/  controlPanel.tsx       | 常规时间序列图，包括4种                    |
| Step/                 | images/  controlPanel.tsx index.tsx                          |                                            |
| buildQuery.ts         | buildQuery                                                   | 构建查询数据：查询对象、排序指标           |
| controlPanel.tsx      | config                                                       | 图表控制页板配置的参数（出现在图表详情页） |
| EchartsTimeseries.tsx | EchartsTimeseries                                            | 数据/事件更改时的处理逻辑                  |
| index.ts              | EchartsTimeseriesChartPlugin                                 | 定义插件                                   |
| transformers.ts       | transformSeries  transformFormulaAnnotation   <br/>transformIntervalAnnotation  transformEventAnnotation  <br/>transformTimeseriesAnnotation  getPadding getTooltipTimeFormatter  <br/>getXAxisFormatter |                                            |
| transformProps.ts     | transformProps                                               | 数据转换：格式化标签、全局数据             |
| types.tx              | EchartsTimeseriesContributionType  EchartsTimeseriesSeriesType<br>EchartsTimeseriesFormData  EchartsTimeseriesFormData <br>EchartsTimeseriesChartProps TimeseriesChartTransformedProps | 导出表单数据、标签类型、全局数据           |



## 4.2 plugin-chart-table/



## 4.3 plugin-chart-pivot-table/



## 4.4 plugin-chart-xy/





# 5 脚本 /scripts/

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





<br>

# 参考资料

**参考网站**

* lerna  https://www.lernajs.cn/



**参考链接**

* superset 二次开发之看板渲染为深色大屏 https://juejin.cn/post/7004462914765586445

