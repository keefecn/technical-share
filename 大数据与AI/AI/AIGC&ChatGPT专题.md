| 序号 | 修改时间 | 修改内容 | 修改人 | 审稿人 |
| ---- | -------- | -------- | ------ | ------ |
| 1    | 2023-4-1 | 创建     | Keefe  |        |
|      |          |          |        |        |

<br><br><br>

---

# 目录

[TOC]

---

# 1 AIGC简介

AIGC全称为AI Generated Content，即人工智能生产的内容,认为是继PGC（专业化生产内容）、UGC（用户生产内容）之后的新型内容创作方式。

AIGC狭义概念是利用 AI 自动生产内 容的生产方式，但广义上 AIGC 已在实现人工智能从感知理解世界到生成创造世界的进击，AIGC 代表 AI 技术发展的新趋势，过去传统AI偏向分析能力，而现在AI正在生成新内容，通过大量的训练数据和生成算法模型，自动生成文本、图片、音乐、视频、3D 交互内容等各种形式的内容，换言之，AIGC 正在加速成为 AI 领域的商业新边界；AIGC 也 会带来内容创作的变革，如智能数字内容孪生能力、智能数字内容编辑能力、智能数字内 容传作能力。

## 技术场景

表格 AIGC技术场景

| 技术场景                      | 内容                                                         |
| ----------------------------- | ------------------------------------------------------------ |
| 文本生成                      | 包括非交互式文本（结构化写作、非结构化写作和辅助性写作）和交互式文本（聊天机器人、文本交互游戏等）生成 |
| 音频生成                      | 包括语音克隆、文本生成特定语音、生成乐曲、歌曲等             |
| 图像生成                      | 包括图像编辑工具和图像自主生成（即AI绘画）                   |
| 视频生成                      | 包括视频属性编辑、视频自动剪辑和视频部分编辑                 |
| 文本、图像、视 频间跨模态生成 | 包括根据文字prompt生成创意图像、拼接图片素材生成视频、文字 生成视频、图像/视频转换为文本等 |
| 策略生成                      | 以Game AI中的AI bot为代表                                    |
| Game AI                       | 包括AI bot、NPC逻辑及剧情生成和数字资产生成                  |
| 虚拟人生成                    | 包括虚拟人视频生成和虚拟人实时交互                           |

## 应用领域

**AIGC 与元宇宙的关系**

将再造元宇宙的众创生产力每一次大革新都划分一个时代，生活、体验、价值认知均会被改变。

工业 2.0 时代，其核心是能源生产和传递方式的改变；互联网时代，变革是由无数技术、应用落地的节点 们组成；元宇宙时代维形已现，在元宇宙中人工智能以及数字孪生等也是其核心技术支撑，也是形成及完善元宇宙商业内容体系的重要推动力。元宇宙需要大量内容创作、填充，打造 Web3-AIGC 数字创作者经济联合体来赋能文化 消费品牌元创力。

## 本章参考

* AIGC是什么？https://xueqiu.com/4593161361/241581649

<br><br>

# 2 ChatGPT

ChatGPT（全名：Chat Generative Pre-trained Transformer），美国OpenAI 研发的聊天机器人程序，于2022年11月30日发布。ChatGPT是人工智能技术驱动的自然语言处理工具，它能够通过理解和学习人类的语言来进行对话，还能根据聊天的上下文进行互动，真正像人类一样来聊天交流，甚至能完成撰写邮件、视频脚本、文案、翻译、代码，写论文等任务。

在OpenAI的官网上，ChatGPT被描述为优化对话的语言模型，是GPT-3.5架构的主力模型。

结合ChatGPT的底层技术逻辑，有媒体曾列出了中短期内ChatGPT的潜在产业化方向：归纳性的文字类工作、代码开发相关工作、[图像生成](https://baike.baidu.com/item/图像生成/22073368?fromModule=lemma_inlink)领域、[智能客服](https://baike.baidu.com/item/智能客服/8124098?fromModule=lemma_inlink)类工作。

ChatGPT受到关注的重要原因是引入新技术RLHF (Reinforcement Learning with Human Feedback，即基于人类反馈的强化学习)。RLHF 解决了生成模型的一个核心问题，即如何让人工智能模型的产出和人类的常识、认知、需求、价值观保持一致。ChatGPT是AIGC（AI- Generated Content，人工智能生成内容）技术进展的成果。该模型能够促进利用人工智能进行内容创作、提升内容生产效率与丰富度。

ChatGPT是生成式AI的一种形式，Gartner（一家技术研究及分析公司）将其作为《2022年度重要战略技术趋势》的第一位。Gartner预测，到2025年，生成式AI将占到所有生成数据的10%，但目前这个比例还不足1%。

## ChatGPT技术发展

2012年，深度学习元年，以ImageNet中引入深度学习算法为重要节点，通过构建深度神经网络AlexNet成功将图片识别错误率降低了10.8pcts，证明了深度学习的发展潜力。

2017年，谷歌发布大模型（Transformer）技术路线，将降低边际成本，开始被业界和国内外巨头的关注，逐渐成为发展共识。以当前热门预训练模型为例，BERT(仅使用了Transformer的Encoder部分)，GPT-2、GPT-3(使用的是Decoder部分)等，都是基于Transformer模型而构建。

2022年，10月Stable Diffusion、DALL-E 2、Midjourney等可以生成图片的AIGC模型风行一时。OpenAI推出DALL·E 2，实现文生图创作，并将分辨率提升；11月30日ChatGPT-3.5发布之后，短短5天，注册用户数就超过100万，60天后月活用户超过1亿人，成为历史上增长最快的消费者应用程序。

2023年2月，微软宣布数十亿美元投资OpenAI公司，后者估值高达290亿美元，创下 AIGC 行业单笔融资新高。此后两个月内，谷歌、阿里、百度、Adobe等中美科技巨头陆续公布大模型或类ChatGPT技术，应用于文本、图像生成等领域。

## ChatGPT技术篇

**关键技术**

* Transformer模型：Transformer模型中没有RNN，完全基于Attention。在大型数据集上的效果可以完全
  碾压RNN模型(即使RNN中加入Attention机制)。Transformer的架构使得建立词与词之间的复杂关系成为了可能, 显著提
  高了模型的表达能力。
* GTP模型：生成式预训练（Generative Pre-Training，GPT) 是一种新的训练范式，通过对海量数据的无监督学习来训练语言模型。

ChatGPT团队关键项目有RLHF, CodeX, GPT-1/2/3, ChatGPT等。

表格 OpenAI的ChatGPT版本变化

| 版本        | 时间       | 模型特点                                                     | 模型参数                               |
| ----------- | ---------- | ------------------------------------------------------------ | -------------------------------------- |
| GPT-1       | 2018-6     | 包括预训练+FineTuning两阶段，采取Transformer的decoder作为特征抽取器。 | 其规模和数据量都比较小。               |
| GPT-2       | 2019-2     | 使用了更多参数的模型和更多的训练数据, 且使用zero-shot设定实现仅通过一次预训练的就能完成多种任务，减少了下游微调的频率。 | 15亿参数，模型容量和数据量进一步增大。 |
| GPT-3       | 2020-7     | 拓展了之前创建的基于15亿参数的GPT-2语言模型，微软于9月22日取得独家授权。<br>GPT3的缺陷是存在预训练模型的偏见性，由于预训练模型都是通过海量数据在超大参数量级的模型上训练出来的，其生成的内容无法被保证，会存在包括种族歧视，暴力血腥等危险内容。 | 1750亿参数                             |
| **GPT-3.5** | 2022-11-30 | InstructGPT和ChatGPT。能够回答问题、生成代码、构思剧本和小说。成为历史上增长最快的消费者应用程序。 | 千亿参数                               |
| GPT-4       | 2023-2     |                                                              |                                        |

说明：ChatGPT是由最初的GPT迭代而来：基于文本预训练的GPT-1，GPT-2，GPT-3都是采用的以Transformer为核心结构的模型。

InstructGPT和ChatGPT, 即GPT3.5, 采用了GPT-3的网络结构，通过指示学习构建训练样本来训练一个反应预测内容效果的奖励模型（RM），最后通过这个奖励模型的打分来指导强化学习模型的训练。
训练任务分为3步：

1. 根据采集的SFT数据集对GPT-3进行有监督的微调（Supervised FineTune，SFT）：了解如何回答查询。
2. 收集人工标注的对比数据，训练奖励模型（Reword Model，RM）：构建用于对查询进行排名的模型。
3. 使用RM作为强化学习的优化目标，利用PPO算法微调SFT模型 ： 学习人类的说话方式。

GPT3.5的优势：

* 效果更加真实：ChatGPT在GPT-3之上进行根据人类反馈的微调，引入了不同的labeler进行提示编写和生成结果排序，这使得训练奖励模型时对更加真实的数据会有更高的奖励。
* 无害性提升：由于指示微调的引入，使语言模型与人类意图保持一致，大大降低危害内容生成的概率。
* 具有更强的Coding能力：基于GPT-3制作的API积累了更多的Coding代码，通过Coding相关的大量数据以及人工标注训练出来的GPT3.5模型具备更强大的Coding能力。

## ChatGPT应用篇

chatgpt行业影响：搜索引擎、泛娱乐、自媒体、教育行业。

### 麻瓜+AI混合工作流试验

文章链接

* [麻瓜+AI混合工作流试验 2：文章周边的生成，以及一些思考](https://blog.csdn.net/iamsujie/article/details/129761010)
* 麻瓜+AI混合工作流试验 3：周末瞎想，一切都在赋能AI  https://blog.csdn.net/iamsujie/article/details/129774649
* [麻瓜+AI混合工作流试验 4：咨询顾问向客户讲解，如何全面提升组织的产品能力...](https://blog.csdn.net/iamsujie/article/details/129828262)
* [麻瓜+AI混合工作流试验 5：原创一个方法论，以及AI对中年人的积极一面](https://blog.csdn.net/iamsujie/article/details/129869903)
* [麻瓜+AI混合工作流试验 7：Prompt Engineer与产品经理，以及如何给小学生上一堂AI](https://blog.csdn.net/iamsujie/article/details/130002475)
* [麻瓜+AI混合工作流试验 8：周末瞎想…… 如何跨界学习/知识迁移](https://blog.csdn.net/iamsujie/article/details/130050849)

## 本章参考

* 也许是史上最清晰的一份ChatGPT资源清单  https://mp.weixin.qq.com/s/6l999HlngOvLRdfokHJECA

<br><br>

# 3 业界大模型

**大模型**

大模型通常是在无标注的大数据集上，采用自监督学习的方法进行训练。之后，在其他场景的应用中，开发者只需要对模型进行微调，或采用少量数据进行二次训练， 就可以满足新应用场景的需要。

ChatGPT使用的核心技术之一是Transformer，它是近几年人工智能技术最大的亮点之一，它是Google于2017年提出的一种采用注意力机制的深度学习模型，可以按输入数据各部分重要性的不同，而分配不同的权重。

AI大模型是算力、算法和数据的结合，其中算力是当前比较大的瓶颈。

## 大模型技术布局和应用场景

表格 各大科技公司Chatgpt技术布局和应用场景

| 公司     | 芯片     | 深度学习框架 | AI大模型                      | ChtGPT自应用场景                               | AIGC应用场景               |
| -------- | -------- | ------------ | ----------------------------- | ---------------------------------------------- | -------------------------- |
| 微软     | /        | CNTK         | MT-NLG                        | BING搜索、OFFICE                               | AI歌词创作、定制语音技术   |
| 谷歌     | TPU      | Tensorflow   | Switch Transformer            | 自动驾驶、智能搜索、智能地图                   | AI作画、AI生成视频、AI编曲 |
| 百度     | 昆仑芯   | 飞浆         | 文心-NLP大模型、文心-CV大模型 | 智能搜索、智能云、自动驾驶、智能地图、智能家居 |                            |
| 阿里巴巴 | 含光800  | EPL XDL      | AI模型M6                      | 阿里云、钉钉                                   | AI报 设计                  |
| 腾讯     | 紫宵     | PockerFlow   | 混元大模型                    | 内容创作、检索、推荐                           | AI写稿                     |
| 360      | KAMIN018 | XLearning    | /                             | 智能搜索                                       | AI框架安全检测             |
| 字节跳动 | /        | LightSeq     | DA-Transformer                | 文本分析、PICO                                 | AI视频创作、AI语音         |
| 科大讯飞 | CSK400X  | /            | 中文预训练模型                | 同声传译、内容审核、内容分发                   | 智慧音效                   |
| 京东     | /        | Optimus      | 领域性大模型K-PLUG            | 智能城市、智能零售、智能客服、供应链管理       | AI语音、AI写作、数字人     |
| 网易     | /        | /            | /                             | 在线教育                                       | AI作文、AI口译老师、AI翻译 |
| 华为     | 海思     |              | 盘古大模型                    |                                                |                            |

说明：

2023.3，百度发布文心一言，成为中国第一个类ChatGPT产品。

2023.4，阿里巴巴发布类ChatGPT产品通义千问。。

<br>

## 华为盘古大模型

2021年4月，盘古大模型正式对外发布。

盘古大模型发布以来，已经发展出L0、L1、L2三大阶段的成熟体系持续进化。所谓L0，是指NLP大模型、CV大模型等五大水平领域的基础大模型；而L1指行业大模型，比如气象、矿山、电力等行；L2指面向各行业中细分场景的模型，比如电力行业的无人机巡检。

<br>

## 本章参考

* 拆解华为盘古大模型：与ChatGPT有何不同？  https://baijiahao.baidu.com/s?id=1762619118352444565 2023.4.8

<br><br>

# 参考资料

* 百度百科-ChatGPT  https://baike.baidu.com/item/ChatGPT/62446358?fr=aladdin
* ChatGPT 调研报告--哈工大自然语言处理研究所 https://blog.csdn.net/weixin_55366265/article/details/129458091
* ChatGPT为啥能火？ https://mp.weixin.qq.com/s?__biz=MzI1MDU4OTA0Mg==&mid=2247698025&idx=2&sn=43f5b001ef0e6ddd0a3fefaa27bf7189
* ChatGPT“狂飙”：从它能做什么到为什么引发巨头竞赛  https://www.shifair.com/informationDetails/81632.html
* ChatGPT革命！尝鲜者的喜与忧  https://baijiahao.baidu.com/s?id=1762388879959150439
* ChatGPT：美国围堵中国芯片业的最后一块砖  https://www.huaweipai.com/zmt/show-24617.html
* 争夺AI核心算力市场，国产GPU进化得怎么样了？  https://www.cqcb.com/shuzijingji/2023-03-17/5204026.html

<br>

# 附录

## chatgpt资源清单 

官方资源

- ChatGPT - 这是一个由 OpenAI 提供的官方在线聊天工具，它允许你与 ChatGPT 进行 AI 对话。
- ChatGPT blog - 这是 OpenAI 官方博客上的一篇介绍 ChatGPT 的文章。
- OpenAI API - OpenAI API，一个允许任何人访问 OpenAI 开发的新 AI 模型的平台。
- OpenAI API Documentation - OpenAI API 的文档，它提供了关于 API 的基本概念、模型、端点和应用的详细信息。它还包含一些教程，教你如何使用该 API 构建真正的人工智能应用。这个页面是学习和使用 OpenAI API 的重要资源。

开源资源 

* https://github.com/OpenMindClub/awesome-chatgpt

行研报告

* 2023-03-11 哈尔滨工业大学自然语言处理研究所  ChatGPT 调研报告
* 2023-02-21 ChatGPT 团队背景研究报告
* 2023-02-12  华福证券  [AIGC & ChatGPT 发展报告.pdf](https://file.digitaling.com/eImg/uimages/20230315/1678850891384221.pdf)

**学术分析**

1、技术原理论文

- 2014 Neural Machine Translation by Jointly Learning to Align and Translate - 这篇论文在 RNN 中引入了注意力机制，提升 RNN 的长序列建模能力。这使得 RNN 能够更准确地翻译更长的句子。
- 2017 Attention Is All You Need - 这篇论文介绍了原始的 Transformer 的结构，是 Transformer 系列的基础。
- 2018 BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding - 这篇论文开启了 NLP 领域的预训练时代。BERT 横空出世。
- 2018 Improving language understanding by generative pre-training - 这篇论文介绍了另一个流行的预训练模型，也就是被后人所熟知的 GPT-1。
- 2019 Language models are unsupervised multitask learners - 这篇论文引入了 GPT-2。
- 2020 Language Models are Few-Shot Learners - 这篇论文引入了 GPT-3。
- 2022 Training lanquage models to follow instructions with human feedback - 这篇论文提出了一种 RLHF 的方式，使用监督学习对模型进行微调。这篇论文也被称为阐述 ChatGPT 思想内核的论文。

2、Prompt engineering 的最近进展

- 2021 Generated Knowledge Prompting for Commonsense Reasoning
- 2021 Multitask Prompted Training Enables Zero-Shot Task Generalization
- 2021 Pre-train, Prompt, and Predict: A Systematic Survey of Prompting Methods in Natural Language Processing
- 2021 Prompt Programming for Large Language Models: Beyond the Few-Shot Paradigm
- 2022 Chain-of-Thought Prompting Elicits Reasoning in Large Language Models
- 2022 Self-Consistency Improves Chain of Thought Reasoning in Language Models