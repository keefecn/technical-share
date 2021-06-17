| 序号 | 修改时间  | 修改内容 | 修改人 | 审稿人 |
| ---- | --------- | -------- | ------ | ------ |
| 1    | 2021-6-11 | 创建     | Keefe  |        |









---

# 1 EA简介

Enterprise Architect （下面简称 EA）是用于软件系统的设计与开发、企业业务过程建模以及更广泛建模的可视化平台。Enterprise Architect 基于UML 2.3规范（参见www.omg.org）。UML是定义了用于特定领域或系统建
模的可视化语言。
Enterprise Architect 是一款不断进步和完善的工具，它覆盖了开发周期的所有方面，提供了从初始设计阶段到系统部署，维护，测试以及修改控制的全程可跟踪性。



**Enterprise Architect 与其它UML工具的区别**

* 全面基于UML 2.3的建模
* 内置的需求管理
* 充分的项目管理支持，包括资源，任务，项目日历和度量
* 内置测试管理：测试点管理，基于模型的测试执行，测试案例规范，支持集成测试和单元测试
* 灵活的文档生成：HTML报告和 RTF 报告
* 代码生成：支持多种语言的代码生成，可即插即用
* 集成可视化执行分析器用于分析，调试和执行Java 和.Net 应用程序，运行时生成模型对象的实例和从堆栈信息中记录对顺序图的操作
* 可扩展的建模环境，允许用户定义Profiles和Technologies
* 可使用性：Enterprise Architect 上手很容易并且可以快速掌握UML
* 速度：Enterprise Architect 的运行速度非常快
* 可扩展性：Enterprise Architect 能处理非常巨大的模型并且支持多个并行用户
* 价格：Enterprise Architect 为团队协作打造的合理价位，使团队开发及合作变得切实可行



Enterprise Architect 的功能简介
Enterprise Architect 使你能够：
* 建模复杂的信息和软件系统开发
* 建模，管理和跟踪所开发系统的需求
* 生成详细、高质量的RTF，PDF和HTML格式的报告
* 符合行业标准的企业架构
* 10多种语言的正向和反向代码工程1
* 数据库建模, DDL 脚本生成,和通过ODBC进行反向工程数据库模式
* 使用基线模型合并及审计功能来管理, 跟踪和控制修改
* 集中生成企业范围的信息系统和处理文档
* 建模元素间动态的、与状态相关的依赖关系
* 建模类层次结构，类的部署，组件和实现细节
* 记录项目中的问题，任务和系统术语
* 分配资源给模型元素，跟踪所用工时与所需工时
* 使用先进的XMI 2.1格式进行模型共享 (早期的版本也支持)
* 导入外部基于XMI 格式的数据到模型中
* 使用SCC，CVS以及子版本配置，通过XMI管理版本控制
* 使用 UML Profiles 来为特定领域建模创建定制扩展
* 保存并加载完整的图作为UML 模式
* 使用表状关系矩阵分析并跟踪元素间的关系
* 使用自动化接口和模型脚本来编写常用任务的插件
* 通过MS SQL Server, MySQL, Oracle 等连接到共享数据库和资源库*
* 通过控制的XMI包在一分布式环境中移植修改
* 使用MDA技术执行模型到模型的转换*
* 使用模型视图来创建并共享模型元素的动态视图
* 使用UML创建思维导图，业务过程模型和数据流图
* 自动地从业务过程模型用BPMN标注生成BPEL脚本*
* 从规则任务生成可执行的业务逻辑并跟踪自然语言业务规则*
* 使用可视化分析器来可视化正在运行的程序
* 将行为模型转换成可执行的源代码，用于诸如：Verilog, VHDL, 和 SystemC 等语言进行开发的系统*
* 模拟 SysML 参数模型



**企业架构的框架支持**
Sparx Systems 支持行业标准架构框架使得企业建模变得轻松。Enterprise Architect 中的架
构实现是基于UML及其相关规范，这使得架构的严密程度最大化，并让用户使用XMI 来交
换模型信息。下面的模型框架是Enterprise Architect 的可用插件。

* Zachman 框架 (参见
http://www.sparxsystems.cn/products/mdg/tech/zachman/index.html)
* DoDAF (参见h ttp://www.sparxsystems.cn/products/mdg/tech/dodaf modaf/
index.ht m l)
* MODAF (参见http://www.sparxsystems.cn/products/mdg/tech/dodafmodaf/
index.html)
* UPDM (参见 http://www.sparxsystems.cn/products/mdg/tech/updm)
* TOGAF (参见http://www.sparxsystems.cn/products/mdg/tech/togaf/index.html)



# 2 EA视图

EA支持包括TOGAF在内的多种架构框架，因此支持很多的视图。

下面只针对TOGAF框架的IT架构中用到的视图。

## 逻辑视图

**主要概念**

- 结点（Node）：结点是存在与运行时的代表计算机资源的物理元素，可以是硬件也可以是运行其上的软件系统，比如64主机、Windows server 2008操作系统、防火墙等。
- 结点实例（Node Instance）：结点实例名称格式：Node Instance : node  与结点的区别在于名称有下划线和结点类型前面有冒号，冒号前面可以有示例名称也可以没有示例名称。
- 执行环境（excute environment）：执行环境是一个节点，它以可执行工件的形式为部署在其上的特定类型的组件提供执行环境。
- 结点类型（Node Stereotypes）：结点类型有：«cdrom», «cd-rom», «computer», «disk array», «pc», «pc client», «pc server», «secure», «server», «storage», «unix server», «user pc»，并在结点的右上角用不同的图标表示。
- 物件（Artifact）：物件是软件开发过程中的产物，包括过程模型（比如用例图、设计图等等）、源代码、可执行程序、设计文档、测试报告、需求原型、用户手册等等。物件表示如下，带有关键字«artifact»和文档图标。
- 连接（Association）：结点之间的连线表示系统之间进行交互的通信路径，这个通信路径称为连接（Association）连接中有网络协议。
- 结点容器（Node as Container）：一个结点可以包括其他的结点，比如组件或者物件，则称此结点为结点容器（Node as Container）。如下图所示，结点（Node）包容了物件（Artifact）。





## 部署视图



## 组件视图





# 3 数据库建模

数据库建模, DDL 脚本生成,和通过ODBC进行反向工程数据库模式

## 数据库反向工程

以MySQL为例：  （数据源驱动要用 5.x版本，否则不兼容）

1. 安装MySQL数据源驱动程序

2. 配置ODBC用户DSN

控制面板---管理工具----ODBC数据源（32位）-----添加 用户DSN（注：EA无法访问系统DSN，且只能用MySQL数据源32位）

![image-20210618112609848](..\..\media\sf_reuse\tools\tools_ea_001.png)

3. 右击---源码工程----从ODBC中导入数据库
4. 导入所有表，达成目标。





# 4 模型代码双向工程

代码工程包括自动的代码生成，代码的反向工程以及源代码与模型间的同步。该功能仅在
Enterprise Architect的专业版和企业版中才有。
Enterprise Architect 使你能够从UML模型生成立即可用的源代码，并支持10多种开发语
言的代码生成，包括:
* ActionScript
* C
* C#
* C++
* Delphi
* Java
* PHP
* Python
* Visual Basic
* Visual Basic .NET
导入 .jar 文件和 .NET 汇编数据文件
Enterprise Architect 使你能够反向工程下列二进制模块：
* Java 文档(.jar)
* .Net PE 文件 (.exe, .dll)*
* 中间语言文件(.il).
* 不支持Windows 的 .dll 和可执行程序导入, 仅支持包含 .Net 汇编数据的PE文件。



**模板驱动的源代码生成**
你可以在UML 的正向工程中使用Enterprise Architect 代码模板框架。代码模板指定从
UML元素到给定语言不同部分的定制转换。
代码模板框架能够让你：

* 从UML模型生成源代码
* 定制生成代码的方式
* 对EA不支持的某些语言进行正向工程



**面向需求的灵活代码生成**
Enterprise Architect 提供一种灵活代码生成功能，当你修改模型时，它便立即自动更新你的
源代码。例如，当你为一个类创建新方法和属性时，它们将立即写到源代码文件中。

**内置的语法亮条以及动态的源代码轮廓线**
你可以使用内置的源代码编辑器来打开查看并修改源代码文件。如果你选择模型中的一个元
素并且它有一个相关联的源代码文件。那么它的源代码将显示在编辑窗口并带有适当的语法
亮条和可导航的结构轮廓线。代码浏览器提供工具条从而快速生成代码，以及与模型同步。

**可视化，调试，编译和分析可执行代码**
Enterprise Architect的可视化分析器提供了从建模环境中建模，开发，调试，配置和管理应
用程序的便利。可视化执行分析器给开发过程带来的好处是：

* 让你更好的理解系统是如何工作的
* 自动生成系统功能的文档
* 提供导致错误或异常系统行为事件顺序的有关信息
可视化执行分析器可以用来：
* 生成顺序图，记录应用程序的执行，或特定的堆栈调用
* 推导状态转换图，显示数据结构的变化
* 创建分析报告，显示应用程序序列和运行调用频率
* 优化现有的系统资源，并理解资源分配
* 确保系统遵从设计规范
* 生成准确地反映系统行为的高质量文档
* 理解系统和现有代码如何及怎样工作
* 针对系统的结构和功能培训新员工
* 识别高消耗及不必要的函数调用
* 示意系统内的相互作用，数据结构和重要关系
* 跟踪指定行代码，系统交互和事件的问题
* 对一个事件顺序为什么是重要的进行可视化
* 即时建立系统故障前事件发生的顺序



# FAQ

说明：文中使用的EA版本是13.0

1. 模型视图导出为图片

选择  publish  -> save Image—> Save to file， 选择路径保存。默认导出文件名：当前视图名.png

2. 边框怎么画

common里的boundary。



# 参考资料

[1]. EA官网教程  https://sparxsystems.cn/resources/index.html

[2]. 火龙果EA介绍 http://tool.uml.com.cn/ToolsEA/introduce.asp

[3]. EA数据库反向工程 https://blog.csdn.net/u013040472/article/details/69936108