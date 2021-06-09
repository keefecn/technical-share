| 序号 | 修改时间   | 修改内容            | 修改人 | 审稿人 |
| ---- | ---------- | -------------------------------- | ------ | ------ |
| 1    | 2021-6-11 | 创建。从《python开发》迁移同名章节 | Keefe | Keefe |







---

## 1 源码结构

源码下载

*  [Python 2.7.14rc1 - 2017-08-27](https://www.python.org/downloads/release/python-2714rc1/) 
   Download [XZ compressed source tarball](https://www.python.org/ftp/python/2.7.14/Python-2.7.14rc1.tar.xz)
   Download [Gzipped source tarball](https://www.python.org/ftp/python/2.7.14/Python-2.7.14rc1.tgz)
*  [Python 3.4.7 - 2017-08-09](https://www.python.org/downloads/release/python-347/) 
   Download [XZ compressed source tarball](https://www.python.org/ftp/python/3.4.7/Python-3.4.7.tar.xz)
   Download [Gzipped source tarball](https://www.python.org/ftp/python/3.4.7/Python-3.4.7.tgz)

   ![1574530890814](E:/project/technical-share/media/program_lang/lang_python_003.png)
图  python总体结构
说明：python解释器由四个部分组成，分别是Scanner（行扫描及句法分析）、Parser（语法分析，构建AST）、Compiler（编译生成PYC文件)和Code Evaluator（代码执行器）。 

表格 源代码主要目录结构

| 目录    | 简述                                                |
| ------- | --------------------------------------------------- |
| Demo    | python的示例程序                                    |
| Doc     | 文档                                                |
| Grammar | 用BNF的语法定义了Python的全部语法，提供给解析器使用 |
| Include | 头文件，在用c/c++编写扩展模块时使用                 |
| Lib     | Python自带的标准库，用python编写的                  |
| Modules | 用c编写的内建模块的实现，zlib，md5等                |
| Objects | 内建对象类型的实现list，dict                        |
| PC      | windows平台相关文件                                 |
| PCbuild | Microsoft Visual C++ 项目工程目录                   |
| Parser  | 对Python代码进行词法分析和语法分析的代码            |
| Python  | 字节码编译器和解释器                                |
| Tools   | 一些用 Python开发的工具                             |



表格  cpython中对象的C和python级别对照

| 源码中C对象      | Python对象                | 用途                                                         |
| ---------------- | ------------------------- | ------------------------------------------------------------ |
| PyObject         | object                    | 对象基类。是所有python对象的基类。                           |
| PyTypeObject     | type,__class__            | 对象类型基类                                                 |
| PyIntObject      |                           | 整数对象                                                     |
| PyStringObject   |                           | 字符串对象                                                   |
| PyListObject     | list()                    | List对象，列表结构                                           |
| PyDictObject     | dict()                    | Dict对象，字典结构                                           |
| PyCodeObject     | code                      | 字节码在PVM上的表现形式。   source=open('demo.py').read()   co=compile(source,   'demo.py', 'exec')   type(co) |
| PyFrameObject    | sys._getframe()           | 栈帧，程序运行时环境信息。                                   |
| PyFunctionObject | __module__                | 函数对象。                                                   |
| PyModuleObject   | module,   sys,__builtin__ | sys和__builtin__是两个内置初始模块。                         |
| PyThreadState    |                           | 线程状态                                                     |
| PyInterpreter    |                           | 进程                                                         |
|                  |                           |                                                              |

备注：可用type函数或者xxx.__class__来查看对象类型。__bases__用来查看父类类型。



表格  python内置对象组成

| 对象           | 成员                                           | 备注 |
| -------------- | ---------------------------------------------- | ---- |
| PyObject       | int refConut;   type                           |      |
| PyTypeObject   | PyObject_HEAD;   char* name；   若干函数指针。 |      |
| PyIntObject    |                                                |      |
| PyStringObject |                                                |      |
| PyListObject   |                                                |      |
| PyDictObject   |                                                |      |



## 2 Python对象实现

python对象：

*  PyObject  对象（成员=引用计数int + 类型对象指针）
*  PyTypeObject-->(type int str dict)  类型对象（成员=PyObject + 名称name + 函数指针）
*  PyIntObject PyStringObject PyDictObject ...

在Python的世界里，一切都是对象。在Python中，对象就是C中的结构体在堆上申请的一块内存。

Python 中的对象有定长对象PyObject (如 int 对象)，变长对象PyVarObject（如 list 对象）， Python 的对象都属于这两种之一。对象中包含引用计数和类型信息，管理和创建对象需要用到。还包含属性值的存储空间。

PyObject 对象在内存中的结构类似下面代码：

```C
// 在 Include/object.h 中
// 定长对象
typedef struct _object {
   int ob_refcnt; // 用于内存管理的引用计数
   struct _typeobject *ob_type; // 类型对象，包含类型信息
} PyObject;
 
// 变长对象
typedef struct {
   int ob_refcnt; // 用于内存管理的引用计数
   struct _typeobject *ob_type; // 类型对象，包含类型信息
   Py_ssize_t ob_size; // 变长对象（容器类: list等）容纳元素的个数
} PyVarObject;
 
#define PyObject_HEAD_INIT(typePtr) 
   0,typePtr
// 函数指针
typedef void (*PrintFun)(PyObject*object);
typedef PyObject* (*AddFun)(PyObject* left,PyObject*right);
typedef long (*HashFun)(PyObject* object);
 
#define PyObject_HEAD            \
   int refCount; \   //对象的引用计数
   struct tagPyTypeObject *type    #　对象类型指针　
 
typedef struct tagPyObject
{
   PyObject_HEAD;
}PyObject;
 
typedef struct tagPyTypeObject
{
   PyObject_HEAD;
   char* name;
   PrintFun print;
   AddFun add;
   HashFun hash;
}PyTypeObject;
```



## 3  python虚拟机PVM

### 3.1  虚拟机执行流程

**虚拟机它是怎么执行脚本的：**

*  完成模块的加载和链接；
*  将源代码翻译为PyCodeObject对象，并将其写入内存当中（方便CPU读取，起到加速程序运行的作用）；
*  从上述内存空间中读取指令并执行；
*  程序结束后，根据命令行调用情况（即运行程序的方式）决定是否将PyCodeObject写回硬盘当中（也就是直接复制到.pyc或.pyo文件中）；
*  之后若再次执行该脚本，则先检查本地是否有上述字节码文件。有则执行，否则重复上述步骤。
   说明：.pyc或.pyo文件是否生成，是取决于我们如何运行程序的。模块在每次导入前总会检查其字节码文件的修改时间是否与自身的一致。若是则直接从该字节码文件读取内容，否则源模块重新导入，并在最后生成同名文件覆盖当前已有的字节码，从而完成内容的更新（详见import.py）。这样，就避免了修改源代码后与本地字节码文件产生冲突。

```shell
$ python -m hello.py  # 可以显式生成pyc
$ python hello.py  # 不生成pyc
```



### 3.2  pyc文件和code对象

**字节码bytecode**
python源代码在执行前会编译成python的字节码指令序列，PVM根据这些字节码来进行一系列操作。在python2.5中，一共规定了104条字节码指令。
pyc文件和PyCodeObject都是字节码的表现形式，前者存储在磁盘里，后者在python虚拟机中。

**pyc文件**
pyc文件包括了三部分独立的信息，分别是python的magic number（整数值，用来保证python的兼容性）、pyc文件创建的时间信息，以及PyCodeObject对象。

*  直接执行python test.py并不会产生pyc文件，import语句会触发生成pyc文件（执行到import语句时，先查看有没有对应的pyc文件，如果没有，会创建PyCodeObject对象，将对象写入文件中，接下来Python重新从pyc文件执行import动作）
*  py_compile、compiler标准库也可以生成pyc文件

 ```C
typedef struct {
   PyObject_HEAD
   int co_argcount;        /*Code Block位置参数的个数 #arguments, except *args */
   int co_nlocals;     /*Code Block中局部变量的个数，包括位置参数的个数 #local variables */
   int co_stacksize;       /*执行该段Code Block需要的栈空间 #entries needed for evaluation stack */
   int co_flags;       /* CO_..., see below */
   PyObject *co_code;      /*Code Block编译得到的字节码指令序列 instruction opcodes */
   PyObject *co_consts;    /*Code Block中的所有常量 list (constants used) */
   PyObject *co_names;     /*Code Block中的所有符号 list of strings (names used) */
   PyObject *co_varnames;  /*Code Block中局部变量名集合 tuple of strings (local variable names) */
   PyObject *co_freevars;  /*实现闭包需要的对象 tuple of strings (free variable names) */
   PyObject *co_cellvars;      /*Code Block中内部嵌套函数所引用的局部变量名集合 tuple of strings (cell variable names) */
   /* The rest doesn't count for hash/cmp */
   PyObject *co_filename;  /*Code Block对应的py文件的完整路径 string (where it was loaded from) */
   PyObject *co_name;      /*Code Block的名字，通常是函数名或类名 string (name, for reference) */
   int co_firstlineno;     /*Code Block在对应的py文件中的起始行 first source line number */
   PyObject *co_lnotab;    /*字节码指令与py文件中源代码行号的对应关系 string (encoding addr<->lineno mapping) */
   void *co_zombieframe;     /* for optimization only (see frameobject.c) */
} PyCodeObject;
 ```



表格 35 PyCodeObject各个域的含义

| co_argcount    | 未知参数个数                   |
| -------------- | ------------------------------ |
| co_nlocals     | 局部变量个数                   |
| co_stacksize   | 栈空间                         |
| co_flags       | 标志位                         |
| co_code        | 字节码                         |
| co_consts      | 常量信息                       |
| co_names       | 符号信息                       |
| co_varnames    | 局部变量名集合                 |
| co_freevars    | 闭包需要用到的信息             |
| co_cellvars    | 嵌套函数所引用的局部变量名集合 |
| co_filename    | 源文件完整路径                 |
| co_name        | 该CodeBlock的名字              |
| co_firstlineno | 源文件中对应起始行             |
| co_lnotab      | 字节码与源文件中行号对应关系   |



### 3.3  python访问PyCodeObject: compile/dis

```
In [6]: help(compile)
Help on built-in function compile in module builtins:
 
compile(source, filename, mode, flags=0, dont_inherit=False, optimize=-1)
   Compile source into a code object that can be executed by exec() or eval().
 
   The source code may represent a Python module, statement or expression.
   The filename will be used for run-time error messages.
   The mode must be 'exec' to compile a module, 'single' to compile a
   single (interactive) statement, or 'eval' to compile an expression.
   The flags argument, if present, controls which future statements influence
   the compilation of the code.
   The dont_inherit argument, if true, stops the compilation inheriting
   the effects of any future statements in effect in the code calling
   compile; if absent or false these statements do influence the compilation,
   in addition to any features explicitly specified.
 
示例：
In [1]: file1='debug_demo.py'
In [2]: source=open(file1).read()
In [4]: co=compile(source,file1,'exec')
In [5]: type(co)
Out[5]: code
In [9]: import dis
In [10]: dis.dis(co)
  8           0 LOAD_CONST  0 ('\n@filename debug_demo.py\n@author: keefe\n@created: 2017/8/30\n@see:\n')
 2 STORE_NAME  0 (__doc__)
 
 10           4 LOAD_CONST  1 (True)
 6 STORE_NAME  1 (_DEBUG)
 
 13           8 LOAD_CONST  2 (<code object debug_demo at 0x0000002910865E40, file "debug_demo.py", line 13>)
            10 LOAD_CONST  3 ('debug_demo')
            12 MAKE_FUNCTION            0
            14 STORE_NAME  2 (debug_demo)
 
 32          16 LOAD_NAME   3 (__name__)
            18 LOAD_CONST  4 ('__main__')
            20 COMPARE_OP  2 (==)
            22 POP_JUMP_IF_FALSE       32
 
 33          24 LOAD_NAME   2 (debug_demo)
            26 LOAD_CONST  5 (4500)
            28 CALL_FUNCTION            1
            30 POP_TOP
           32 LOAD_CONST  6 (None)
 34 RETURN_VALUE
```





## 参考资料

[1]. 《python源码剖析》 2008
[2]. 《python源码剖析》之实现small python https://blog.csdn.net/wangyuquanliuli/article/details/8654478
[3]. Python2.7.7源码分析  http://www.linuxidc.com/Linux/2015-08/121168.htm
[4]. Python什么情况下会生成pyc文件？https://www.zhihu.com/question/30296617/answer/112564303 
[5]. Python源码剖析笔记 http://www.jianshu.com/nb/3703820
[6]. Python解释器简介 http://blog.jobbole.com/56761/ 

