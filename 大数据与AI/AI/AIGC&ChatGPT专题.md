| 序号  | 修改时间     | 修改内容 | 修改人   | 审稿人 |
| --- | -------- | ---- | ----- | --- |
| 1   | 2023-4-1 | 创建   | Keefe |     |
|     |          |      |       |     |

<br><br><br>

---

# 目录

[TOC]

---

# 1 AIGC简介

AIGC全称为AI Generated Content，即人工智能生产的内容，认为是继PGC（专业化生产内容）、UGC（用户生产内容）之后的新型内容创作方式。

AIGC狭义概念是利用 AI 自动生产内 容的生产方式，但广义上 AIGC 已在实现人工智能从感知理解世界到生成创造世界的进击，AIGC 代表 AI 技术发展的新趋势，过去传统AI偏向分析能力，而现在AI正在生成新内容，通过大量的训练数据和生成算法模型，自动生成文本、图片、音乐、视频、3D 交互内容等各种形式的内容，换言之，AIGC 正在加速成为 AI 领域的商业新边界；AIGC 也 会带来内容创作的变革，如智能数字内容孪生能力、智能数字内容编辑能力、智能数字内 容传作能力。

## 技术场景

表格 AIGC技术场景

| 技术场景            | 内容                                                  |
| --------------- | --------------------------------------------------- |
| 文本生成            | 包括非交互式文本（结构化写作、非结构化写作和辅助性写作）和交互式文本（聊天机器人、文本交互游戏等）生成 |
| 音频生成            | 包括语音克隆、文本生成特定语音、生成乐曲、歌曲等                            |
| 图像生成            | 包括图像编辑工具和图像自主生成（即AI绘画）                              |
| 视频生成            | 包括视频属性编辑、视频自动剪辑和视频部分编辑                              |
| 文本、图像、视 频间跨模态生成 | 包括根据文字prompt生成创意图像、拼接图片素材生成视频、文字 生成视频、图像/视频转换为文本等   |
| 策略生成            | 以Game AI中的AI bot为代表                                 |
| Game AI         | 包括AI bot、NPC逻辑及剧情生成和数字资产生成                          |
| 虚拟人生成           | 包括虚拟人视频生成和虚拟人实时交互                                   |

## 应用领域

**AIGC 与元宇宙的关系**

将再造元宇宙的众创生产力每一次大革新都划分一个时代，生活、体验、价值认知均会被改变。

工业 2.0 时代，其核心是能源生产和传递方式的改变；互联网时代，变革是由无数技术、应用落地的节点 们组成；元宇宙时代维形已现，在元宇宙中人工智能以及数字孪生等也是其核心技术支撑，也是形成及完善元宇宙商业内容体系的重要推动力。元宇宙需要大量内容创作、填充，打造 Web3-AIGC 数字创作者经济联合体来赋能文化 消费品牌元创力。

表格 AI 落地项目分类

|      | 个人             | 团队             | 公司       | 企业        |
| ---- | -------------- | -------------- | -------- | --------- |
| 投资范围 | 1W-5W          | 5W-20W         | 20W-100W | 100W+     |
| 用户群体 | 个人或小规模用户       | 特定用户或企业        | 大规模用户或企业 | C端用户或大型企业 |
| 项目   | AI绘画小程序、LORA训练 | 企业AI服务、线上或线下活动 | AI行业应用   | AI产品      |
| 项目分类 | 服务             | 服务             | 项目       | 产品        |

## 商业模式

商业模式目前有二种，一是MAAS，模型作为服务；二是内容生成。

## 生产要素

参见 《[AI算法](./AI算法.md)》、《[AI算力](./AI算力.md)》、《[开放数据集说明](../开放数据集说明.md)》

AI大模型是算力、算法和算据（数据）的结合，其中算力是当前比较大的瓶颈。

作为通用人工智能技术的底座，训练一个大模型并不容易，有公开数据显示，一个大模型单次训练成本预计在百万美元到千万美元不等，随着构建一个大模型使用的参数越来越庞大，所需要的计算成本也将越来越高。

国盛证券估算，今年1月平均每天约有1300万独立访客使用ChatGPT，对应芯片需求为3万多片英伟达A100GPU，初始投入成本约为8亿美元，每日电费在5万美元左右。

> 英伟达DGXA100服务器单机搭建8片A100GPU，AI算力性能约为5PetaFLOP/s，单机最大功率约为6.5kw，售价约为19.9万美元/台。一个标准机柜能放7个DGXA100服务器，售价为140万美元。

国盛证券基于参数数量和token数量估算，GPT-3训练一次的成本约为140万美元；对于一些更大的LLM模型采用同样的计算公式，训练成本介于200万美元至1200万美元之间。

华为公布AI大模型开发训练成本：一次1200万美元。

<br>

## 本章参考

* AIGC是什么？https://xueqiu.com/4593161361/241581649
* 大模型训练一次200-1200万美元！ChatGPT多烧钱？  https://baijiahao.baidu.com/s?id=1757766297952462884&
* 小公司玩不起 华为公布AI大模型开发训练成本：一次1200万美元  https://baijiahao.baidu.com/s?id=1762603244500714429

<br><br>

# 2 ChatGPT

ChatGPT（全名：Chat Generative Pre-trained Transformer），美国<u>OpenAI</u> 研发的聊天机器人程序，于2022年11月30日发布。ChatGPT是人工智能技术驱动的自然语言处理工具，它能够通过理解和学习人类的语言来进行对话，还能根据聊天的上下文进行互动，真正像人类一样来聊天交流，甚至能完成撰写邮件、视频脚本、文案、翻译、代码，写论文等任务。

**OpenAI**

2015 年12月11日OpenAI成立。OpenAI，在美国成立的人工智能研究公司，核心宗旨在于“实现安全的通用人工智能(AGI)”，使其有益于人类。OpenAI由一群科技领袖，包括[山姆·阿尔特曼](https://baike.baidu.com/item/山姆·阿尔特曼/15957359?fromModule=lemma_inlink)（Sam Altman）、[彼得·泰尔](https://baike.baidu.com/item/彼得·泰尔/3103049?fromModule=lemma_inlink)（Peter Thiel）、[里德·霍夫曼](https://baike.baidu.com/item/里德·霍夫曼/4757094?fromModule=lemma_inlink)（Reid Hoffman）和[埃隆·马斯克](https://baike.baidu.com/item/埃隆·马斯克/3776526?fromModule=lemma_inlink)（Elon Musk）等人创办。2017年马斯克退出；2018年微软给OpenAI 投资10亿美元。

在OpenAI的官网上，ChatGPT被描述为优化对话的语言模型，是GPT-3.5架构的主力模型。

结合ChatGPT的底层技术逻辑，有媒体曾列出了中短期内ChatGPT的潜在产业化方向：归纳性的文字类工作、代码开发相关工作、图像生成领域、智能客服类工作。

ChatGPT是AIGC（AI- Generated Content，人工智能生成内容）技术进展的成果。该模型能够促进利用人工智能进行内容创作、提升内容生产效率与丰富度。

ChatGPT是生成式AI的一种形式，Gartner（一家技术研究及分析公司）将其作为《2022年度重要战略技术趋势》的第一位。Gartner预测，到2025年，生成式AI将占到所有生成数据的10%，但目前这个比例还不足1%。

## ChatGPT技术发展

2012年，深度学习元年，以ImageNet中引入深度学习算法为重要节点，通过构建深度神经网络<u>AlexNet</u>成功将图片识别错误率降低了10.8pcts，证明了深度学习的发展潜力。

2017年，6月谷歌发布大模型（<u>Transformer</u>）技术路线，将降低边际成本，开始被业界和国内外巨头的关注，逐渐成为发展共识。以当前热门预训练模型为例，BERT(仅使用了Transformer的Encoder部分)，GPT-2、GPT-3(使用的是Decoder部分)等，都是基于Transformer模型而构建。

2022年，10月Stable Diffusion、DALL-E 2、Midjourney等可以生成图片的AIGC模型风行一时。**OpenAI**推出DALL·E 2，实现文生图创作，并将分辨率提升；11月30日ChatGPT-3.5发布之后，短短5天，注册用户数就超过100万，60天后月活用户超过1亿人，成为历史上增长最快的消费者应用程序。

2023年2月，微软宣布数十亿美元投资OpenAI公司，后者估值高达290亿美元，创下 AIGC 行业单笔融资新高。此后两个月内，谷歌、阿里、百度、Adobe等中美科技巨头陆续公布大模型或类ChatGPT技术，应用于文本、图像生成等领域。

## ChatGPT技术篇

**关键技术**

* Transformer模型：Transformer模型中没有RNN，完全基于Attention。在大型数据集上的效果可以完全
  碾压RNN模型(即使RNN中加入Attention机制)。Transformer的架构使得建立词与词之间的复杂关系成为了可能, 显著提
  高了模型的表达能力。
* GTP模型：生成式预训练（Generative Pre-Training，GPT) 是一种新的训练范式，通过对海量数据的无监督学习来训练语言模型。
* RLHF (Reinforcement Learning with Human Feedback，即基于人类反馈的强化学习)。RLHF 解决了生成模型的一个核心问题，即如何让人工智能模型的产出和人类的常识、认知、需求、价值观保持一致。

ChatGPT团队关键项目有RLHF, CodeX, GPT-1/2/3, ChatGPT等。

表格 OpenAI的ChatGPT版本变化

| 版本          | 时间         | 模型特点                                                                                                                                   | 参数量   |
| ----------- | ---------- | -------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| GPT-1       | 2018-6     | 无监督学习。包括预训练+FineTuning两阶段，采取Transformer的decoder作为特征抽取器。<br>其规模和数据量都比较小。                                                                | 1.17亿 |
| GPT-2       | 2019-2     | 多任务学习。使用了更多参数的模型和更多的训练数据, 且使用zero-shot设定实现仅通过一次预训练的就能完成多种任务，减少了下游微调的频率。                                                                | 15亿   |
| GPT-3       | 2020-7     | 海量参数。拓展了之前创建的基于15亿参数的GPT-2语言模型，微软于9月22日取得独家授权。<br>GPT3的缺陷是存在预训练模型的偏见性，由于预训练模型都是通过海量数据在超大参数量级的模型上训练出来的，其生成的内容无法被保证，会存在包括种族歧视，暴力血腥等危险内容。 | 1750亿 |
| **GPT-3.5** | 2022-11-30 | 针对对话场景优化。InstructGPT和ChatGPT。极强的语言理解和语言生成能力。<br>能够回答问题、生成代码、构思剧本和小说。成为历史上增长最快的消费者应用程序。                                                 | 1750亿 |
| GPT-4       | 2023-3     | 拥有多模态能力，可接受图像输入并理解图像内容。                                                                                                                | 100万亿 |
| GPT-5       | ？          |                                                                                                                                        |       |

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

### 入门

openai注册：

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
* 3分钟教你用Python搭建ChatGPT  https://www.jianshu.com/p/14eaedbbca17

<br><br>

# 3 业界大模型

大模型通常是在无标注的大数据集上，采用自监督学习的方法进行训练。之后，在其他场景的应用中，开发者只需要对模型进行微调，或采用少量数据进行二次训练， 就可以满足新应用场景的需要。

ChatGPT使用的核心技术之一是Transformer，它是近几年人工智能技术最大的亮点之一，它是Google于2017年提出的一种采用注意力机制的深度学习模型，可以按输入数据各部分重要性的不同，而分配不同的权重。

## 大模型技术布局和应用场景

表格 国外科技公司Chatgpt技术布局和应用场景

| 公司  | 芯片  | 深度学习框架     | AI大模型              | ChtGPT自应用场景    | AIGC应用场景         |
| --- | --- | ---------- | ------------------ | -------------- | ---------------- |
| 微软  | /   | CNTK       | MT-NLG             | BING搜索、OFFICE  | AI歌词创作、定制语音技术    |
| 谷歌  | TPU | Tensorflow | Switch Transformer | 自动驾驶、智能搜索、智能地图 | AI作画、AI生成视频、AI编曲 |

表格 国内科技公司Chatgpt技术布局和应用场景

| 公司   | 芯片       | 深度学习框架     | AI大模型                 | ChtGPT自应用场景             | AIGC应用场景         |
| ---- | -------- | ---------- | --------------------- | ----------------------- | ---------------- |
| 百度   | 昆仑芯      | 飞浆         | 文心-NLP大模型、文心-CV大模型    | 智能搜索、智能云、自动驾驶、智能地图、智能家居 |                  |
| 阿里巴巴 | 含光800    | EPL XDL    | ~~AI模型M6~~、通义千问       | 阿里云、钉钉                  | AI报 设计           |
| 腾讯   | 紫宵       | PockerFlow | 混元大模型                 | 内容创作、检索、推荐              | AI写稿             |
| 华为   | 昇腾       |            | 盘古大模型（基础L0+行业L1+细分L2） |                         |                  |
| 商汤   |          |            | 日日新（SenseNova）        | 秒画、如影、琼宇、格物             |                  |
| 科大讯飞 | CSK400X  | /          | 中文预训练模型               | 同声传译、内容审核、内容分发          | 智慧音效             |
| 字节跳动 | /        | LightSeq   | DA-Transformer        | 文本分析、PICO               | AI视频创作、AI语音      |
| 360  | KAMIN018 | XLearning  | 360智脑                 | 智能搜索                    | AI框架安全检测         |
| 京东   | /        | Optimus    | 领域性大模型K-PLUG、ChatJD   | 智能城市、智能零售、智能客服、供应链管理    | AI语音、AI写作、数字人    |
| 网易   | /        | /          | 子曰                    | 在线教育                    | AI作文、AI口译老师、AI翻译 |

说明：AIGC相关企业还有微软小冰团队、启元世界（2017年成立，通用人工智能）、创新奇智（2018）、硅基智能（数字人业务）、拓尔思TRS（1993，语义智能）、云舶科技（2017，游戏 AI）、联汇科技、一览科技（2017，视频业务）、视拓云（AI算力）、智源研究院（2018）、出门问问。

2023.3.16，百度发布"文心一言"，成为中国第一个类ChatGPT产品。

2023.4.7，阿里巴巴类ChatGPT产品"通义千问"官宣正式对外开放企业邀测。

2023.4.10，商汤正式发布自研类ChatGPT产品"商量（SenseChat）"。

2023.5.6日，科大讯飞发布了讯飞星火认知大模型。



表格  国内四大巨头大模型比较 

|       | 阿里                                                                                | 百度                                                                                                                                    | 商汤                                                                                                                                                                            | 华为                                                                                                  |
| ----- | --------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| 大模型名称 | 通义千问                                                                              | 文心千帆                                                                                                                                  | 日日新（SenseNova）                                                                                                                                                                | 盘古大模型（基础L0+行业L1+细分L2）                                                                               |
| 应用场景  | 多轮对话、文案创作、逻辑推理、多模 态理解、多语言支持等功能，以及外部增强API。                                         | 智能对话、智能输入法等通用场景以及电销领域商品介绍、推广文章等特定场景。具体功能包括对话沟通（匹配智能营销、智能客服、情感沟通等需要沟通对话的场景）、内容创作（匹配剧本、故事、诗歌等文本创作场景）、分析控制（匹配代码生成、数据报表、内容分析等深度学习的文本场景）等。 | 包括自然语言大模型“商量”、中文医疗语言大模型“商量·大医”、编程助手 “商量·AI 代码助手”三个平台，并进一步推出了四款生成式AI应用，包括“秒画 SenseMirage”文生图创作平台、“如影SenseAvatar”AI数字人视频生成平台、“琼宇 SenseSpace”3D场景生成平台和“格物 SenseThings” 3D内容生成平台。 |                                                                                                     |
| 生态链   | 未来阿里所有产品未来将接入大模型全面升级，目前钉钉、天猫精灵等产品已率先接入通义千问测试， 高德地图、饿了么、盒马、优酷、淘票票等产品也将有序接入通义千问大模型。 | 文心千帆大模型平台不仅包括文心一言，还包括百度全套文心大模型、相应的开发工具链。未来还将支持第三方大模型。                                                                                 |                                                                                                                                                                               | 盘古大模型聚焦AI for Industry，过去几年的AI项目应用已超过 1,000 个，其中30%用户用于客户的核心生产体系中，平均推动客户盈利提升18%，且目前在工业B端领域发力效果尤为显著。 |
| 影响    |                                                                                   |                                                                                                                                       |                                                                                                                                                                               | 华为盘古大模型有望推动人工智能开发从“作坊化”到“工业化“升级。                                                                    |

<br>

## 各家大模型

### 华为盘古大模型

**华为盘古大模型：深耕大模型的行业应用**

华为云团队于2020 年立项AI 大模型，并且于2021 年4 月发布“盘古大模型”。受益于华为的全栈式AI 解决方案，大 模型与昇腾（Ascend）芯片、昇思（MindSpore）语言、ModelArts 平台深度结合。盘古大模型已经发展出包括基础大模型（L0）、行业大模型（L1）、行业细分场景模型（L2）三大阶段的成熟体系。 

2022年11月，在华为全联接大会2022中国站上，华为云进一步迭代盘古大模型的技术能力，扩展盘古大模型的服务范围，发布 盘古气象大模型、盘古矿山大模型、盘古OCR大模型三项重磅服务。

**ModelArts：大模型研发的平台支持**

ModelArts 是面向开发者的一站式AI平台，为机器学习与深度学习提供海量数据预处理及交互式智能 标注、大规模分布式训练、自动化模型生成，及端-边-云模型按需部署能力，帮助用户快速创建和部 署模型，管理全周期 AI 工作流。 ModelArts的主要能力包括数据处理、算法开发、模型训练、AI应用管理和部署；功能模块涵盖了强化学习、天筹(OptVerse)AI求 解器、盘古大模型、AI Gallery（人工智能知识与实训专区）、IDE（云原生 Notebook）等。

**基础大模型：将Transformer应用于各模态**

盘古语音语义大模型：语义模型是业界首个千亿中文大模型；语音模型拥有超过4 亿参数,是当前最大的中文语音模型之一。 语义部分，基于Transformer搭建基础架构，针对理解能力，使用类似BERT的MLM方式训练；针对生成能力，使用回归语言模型作为训练目标，即给定一句 话的上半部分，让模型预测下半部分。2022年，华为在鹏城云脑Ⅱ上训练了全球首个全开源2000亿参数的自回归中文预训练语言大模型——鹏程·盘古。

语音部分，使用卷积与Transformer 结合的网络结构，解码器与文本类似；音频编码器部分，预训练时采取将音频中挖掉一个片段，再随机采样一些片段作为 负例，让模型从中找出正确的被挖掉的片段。

盘古视觉大模型：最大拥有30亿参数，兼顾判别与生成能力；在小样本学习性能领先。 融合了卷积网络和Transformer 架构，分开或按需结合达到更好效果；业界首创基于等级化语义聚集的对比度自监督学习，以减少样本选取过程中的噪声影响。

盘古多模态大模型：使用LOUPE 算法预训练所得的模型，在多项下游任务中表现出了更好的精度。 采用了双塔架构，利用不同的神经网络来完成不同模态的信息抽取，然后仅在最后一层做信息交互和融合，具有模型独立性强、训练效率高等优势。 实现方式为：分别抽取图像和文本特征，然后将一个批次的图像和文本特征送入判别器，使得配对的跨模态特征聚集在一起，而不配对跨模态特征被拉远，大 数据充分迭代后，模型就能学会将图像和文本对齐到同一空间。此时，图像和文本的编码器可以独立用于各自下游任务，或协同用于跨模态理解类下游任务。

<br>

## 业界大模型评测

### 典型问题

## 本章参考

* 拆解华为盘古大模型：与ChatGPT有何不同？  https://baijiahao.baidu.com/s?id=1762619118352444565 2023.4.8
* 【德邦证券2023-03-08】AIGC行业专题报告：国内大模型概览  https://baijiahao.baidu.com/s?id=1759763595359185241
* 【国金证券2023-04-12】华为盘古大模型研究：盘古开天，AI落地 https://baijiahao.baidu.com/s?id=1762938971407815759
* 国产AI大模型之战：得技术者胜，得市场者强  https://baijiahao.baidu.com/s?id=1765690288023828253
* 盘点！华为、阿里等国内科技四巨头旗下AI大模型生态链（名单）  http://www.360doc.com/content/12/0121/07/1075695397_1075695397.shtml
* 5000字阿里腾讯华为AI大模型最新战略 HR实名俱乐部

* 阿里版ChatGPT突然上线邀测！大模型热战正剧开始，这是第一手体验实录  https://www.qbitai.com/2023/04/43517.html
* 商汤版ChatGPT「商量」来了！开放API，基于千亿参数大模型，体验实录在此  https://www.qbitai.com/2023/04/43615.html

<br><br>

# 参考资料

参考网站

* 量子位智库   https://www.qbitai.com/   追踪人工智能新趋势，报道科技行业新突破
* 稀土掘金  https://juejin.cn/  面向全球中文开发者的技术内容分享与交流平台
* OSCHINA
* 分布式实验室
* Segmentfault  技术问答
* 思否

参考链接

* 百度百科-ChatGPT  https://baike.baidu.com/item/ChatGPT/62446358?fr=aladdin
* ChatGPT 调研报告--哈工大自然语言处理研究所 https://blog.csdn.net/weixin_55366265/article/details/129458091
* ChatGPT为啥能火？ https://mp.weixin.qq.com/s?__biz=MzI1MDU4OTA0Mg==&mid=2247698025&idx=2&sn=43f5b001ef0e6ddd0a3fefaa27bf7189
* ChatGPT“狂飙”：从它能做什么到为什么引发巨头竞赛  https://www.shifair.com/informationDetails/81632.html
* ChatGPT革命！尝鲜者的喜与忧  https://baijiahao.baidu.com/s?id=1762388879959150439
* ChatGPT：美国围堵中国芯片业的最后一块砖  https://www.huaweipai.com/zmt/show-24617.html
* 学会这些超实用的AI工具，一个人也能开公司  https://zhuanlan.zhihu.com/p/621654383

<br>

# 附录

## Chatgpt资源清单

官方资源

- [ChatGPT](http://chat.openai.com/) - 这是一个由 OpenAI 提供的官方在线聊天工具，它允许你与 ChatGPT 进行 AI 对话。 http://chat.openai.com/
- ChatGPT blog - 这是 OpenAI 官方博客上的一篇介绍 ChatGPT 的文章。
- OpenAI API - OpenAI API，一个允许任何人访问 OpenAI 开发的新 AI 模型的平台。
- OpenAI API Documentation - OpenAI API 的文档，它提供了关于 API 的基本概念、模型、端点和应用的详细信息。它还包含一些教程，教你如何使用该 API 构建真正的人工智能应用。这个页面是学习和使用 OpenAI API 的重要资源。

开源资源 

* https://github.com/OpenMindClub/awesome-chatgpt  GPT资源汇集
* https://github.com/Significant-Gravitas/Auto-GPT  Auto-GPT 基于GPT-4的自动决策
* https://github.com/reworkd/AgentGPT   AgentGPT 号称网页版的Auto-GPT
* https://github.com/Moonvy/OpenPromptStudio   AIGC 提示词可视化编辑器
* https://github.com/tatsu-lab/stanford_alpaca  GPT 3.5 平替开源项目

工具

* 抠图工具  [Remove Background from Image, Free HD, No Signup - Pixian.AI](https://pixian.ai/)

* gpt-4套壳网站（但网速极慢近乎无法访问）  [chat.forefront.ai](https://chat.forefront.ai/)

## 大模型相关文章

行研报告

* 202305-27  AI大模型专题一：从阿里/商汤/华为大模型看应用趋势
* 2023-03-11 哈尔滨工业大学自然语言处理研究所  [ChatGPT 调研报告](https://blog.csdn.net/weixin_55366265/article/details/129458091)
* 2023-02-21 [ChatGPT 团队背景研究报告](https://www.sohu.com/a/656714447_410617)
* 2023-02-12  华福证券  [AIGC & ChatGPT 发展报告.pdf](https://file.digitaling.com/eImg/uimages/20230315/1678850891384221.pdf)
* 【量子位智库】2023中国AIGC产业全景报告 

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

参考链接

* AI 这是要杀疯啦！  https://blog.csdn.net/weixin_47080540/article/details/130397672

* 国产版ChatGPT大盘点，你最看好谁？  https://www.eet-china.com/mp/a216246.html

* 人类生产力的解放？揭晓从大模型到AIGC的新魔法  https://zhuanlan.zhihu.com/p/624278914