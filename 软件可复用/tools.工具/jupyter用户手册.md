| 序号 | 修改时间  | 修改内容 | 修改人 | 审稿人 |
| ---- | --------- | -------- | ------ | ------ |
| 1    | 2021-4-23 | 创建     | Keefe  |        |
|      |           |          |        |        |







<br>
---

[TOC]



<br>
---

# 简介

## Ipython

Ipython是一个加强版的python解释器。

- %run 命令运行python文件

- 使用Ctrl+C终端代码的执行
- 使用%paste和%cpaste魔术函数粘贴代码
- Ipython终端快捷键

```shell
Ctrl+p 或 向上箭头              以当前输入内容开始，向后搜索历史命令
Ctrl+N 或 向下箭头              以当前输入内容开始，向前搜索历史命令
Ctrl+R                         按行读取的反向历史搜索(部分匹配)
Ctrl+shift+v                   从剪切板粘贴文本
Ctrl+c                         中断当前正在执行的代码
Ctrl+a                         将光标移动到本行起始位置
Ctrl+e                         将光标移动到本行结束位置
Ctrl+k                         删除光标后本行的内容
Ctrl+u                         删除本行内容
Ctrl+f                         将光标向前移动一个字符
Ctrl+b                         将光标向后移动一个字符
Ctrl+l                         清楚本屏内容
```

- 魔术命令: Ipython的特殊命令称为魔术命令。

```shell
%quickref     显示魔术命令快速参照
%magic        显示所有可用魔术命令的详细文档
%pwd          输出当前路径
%debug        从最后发生报错的底部进入交互式调试器
%hist         打印命令输入历史
%paste        从剪切板中执行已经预先格式化的python代码
%cpaste       打开一个特殊提示符，并粘贴python代码
%reset        删除交互式命令空间里的所有变量/名称
%page object  使用分页器打印显示一个对象
%run xxxx.py  运行python文件
%prun         使用Cprofile执行语句，并报告输出
%time         报告单个语句的执行时间
%timeit      多次运行单个语句，计算平均代码执行时间
%who, %who_ls, %whos     根据不同级别的信息/详细程度，展示交互命令空间中定义的变量
%xdel variable            在Ipython内部删除一个变量，清除相关引用
```

- matplotlib继承
   %matplotlib魔术函数可以设置matplotlib与Ipython命令行或Jupyter notebook的集成

```python
%matplotlib            在Ipython中输入
%matplotlib inline     在Jupyter notebook中输入
```



## Jupyter Notebook

Jupyter是一个科学计算IDE，由Anaconda公司开发并将其开源。

2014年，Ipython Notebook升级到4.0，改名Jupyter。Jupyter Notebook是一个基于WEB的交互式笔记本，支持运行 40 多种编程语言。
Jupyter Notebook 的本质是一个 Web 应用程序，便于创建和共享文学化程序文档，支持实时代码，数学方程，可视化和 markdown。用途包括：数据清理和转换，数值模拟，统计建模，机器学习等等。Jupyter Notebook是基于网页的用于交互计算的应用程序。其可被应用于全过程计算：开发、文档编写、运行代码和展示结果。

**Jupyter Notebook的主要特点**

1. 编程时具有**语法高亮**、*缩进*、*tab补全*的功能。
2. 可直接通过浏览器运行代码，同时在代码块下方展示运行结果。
3. 以富媒体格式展示计算结果。富媒体格式包括：HTML，LaTeX，PNG，SVG等。
4. 对代码编写说明文档或语句时，支持Markdown语法。
5. 支持使用LaTeX编写数学性说明。



```shell
# 安装
$ pip3 install jupyter

# 启动
$ jupyter notebook
```

**网络访问：缺省端口8888**

```
http://localhost:8888/?token=c8de56fa...
```



## Jupyter Lab

JupyterLab是Jupyter主打的最新数据科学生产工具，某种意义上，它的出现是为了取代Jupyter Notebook。不过不用担心Jupyter Notebook会消失，JupyterLab包含了Jupyter Notebook所有功能。

JupyterLab作为一种基于web的集成开发环境，你可以使用它编写notebook、操作终端、编辑markdown文本、打开交互模式、查看csv文件及图片等功能。

JupyterLab有以下特点：

- **交互模式：**Python交互式模式可以直接输入代码，然后执行，并立刻得到结果，因此Python交互模式主要是为了调试Python代码用的

- **内核支持的文档：**使你可以在可以在Jupyter内核中运行的任何文本文件（Markdown，Python，R等）中启用代码

- **模块化界面：**可以在同一个窗口同时打开好几个notebook或文件（HTML, TXT, Markdown等等），都以标签的形式展示，更像是一个IDE

- **镜像notebook输出：**让你可以轻易地创建仪表板

- **同一文档多视图：**使你能够实时同步编辑文档并查看结果

- **支持多种数据格式：**你可以查看并处理多种数据格式，也能进行丰富的可视化输出或者Markdown形式输出

- **云服务：**使用Jupyter Lab连接Google Drive等服务，极大得提升生产力



```shell
# 安装
$ pip3 install jupyterlab

# 启动: jupyter lab 或者 jupyter-lab
$ jupyter lab
```

网络访问：缺省端口8888。如果端口被占用，则端口数量渐增。



# 入门篇

调用shell命令： 可以在notebook里 !符号 调用 shell命令，如 `!pip install rpy2`



## 密码管理和远程访问

**查询密码**

```sh
$ jupyter notebook list
Currently running servers:
http://localhost:8888/?token=7c9064bfb5139e72eb8774248df75d0564f450b09a13d57a :: E:\dev\python\bin\python36\Scripts
```



**设置密码**

法1：在jupyter notebook正常开的文件 或 ipython里输入

```python
in[1] from notebook.auth import passwd
in[2] passwd()
Enter password:
Verify password:
Out[2]: ‘sha1:f704b702aea2:01e2bd991f9c7208ba177b46f4d10b6907810927‘
```

法2: 直接命令行设置：

```shell
$ jupyter notebook password
Enter password:
Verify password:
```

说明：Ipython把输入的密码转换成sha，并用于认证JupyterLab，如果在Ipython输入密码和确认密码时直接回车，相当于不设密码，因此登录JupyterLab时可以不输入密码直接点击登录。



**jupyterlab配置文件**

产生配置文件：`$ jupyter lab --generate-config`

修改配置文件：~/.jupyter/jupyter_notebook_config.py

```ini
# 允许修改代码，缺省为False
c.NotebookApp.allow_password_change=False
# 将ip设置为*，意味允许任何IP访问
c.NotebookApp.ip = ‘*‘
# 这里的密码就是上边我们生成的那一串
c.NotebookApp.password = ‘sha1:f704b702aea2:01e2bd991f9c7208ba177b46f4d10b6907810927‘
# 服务器上并没有浏览器可以供Jupyter打开
c.NotebookApp.open_browser = False
# 监听端口设置为8888或其他自己喜欢的端口
c.NotebookApp.port = 8888
# 允许远程访问
c.NotebookApp.allow_remote_access = True
```

如果以root身份启动需要加入--allow-root

```shell
$ jupyter notebook --ip=127.0.0.1 --port 8000 --allow-root
```



# 进阶篇

## 多内核支持

notebook里魔术命令： %%

在每个cell的开头使用相关的魔法命令来声明你想使用的 kernel：

- `%%bash`
- `%%HTML`
- `%%python2`
- `%%python3`
- `%%ruby`
- `%%perl`

### 同时支持python2和python3

Jupyter Notebook 与 IPython终端 共享同一个内核。

需在python2/3的各自安装目录下再分别安装ipykernel

```shell
$ pip install ipykernel
$ python -m ipykernel install --user
```



内核配置查看

```shell
$ jupyter kernelspec list
Available kernels:
  python2    C:\Users\keefe\AppData\Roaming\jupyter\kernels\python2
  python3    C:\Users\keefe\AppData\Roaming\jupyter\kernels\python3

$ cat ~/AppData/Roaming/jupyter/kernels/python3/kernel.json
{
 "argv": [
  "E:\\dev\\python\\bin\\python36\\python.exe",
  "-m",
  "ipykernel_launcher",
  "-f",
  "{connection_file}"
 ],
 "display_name": "Python 3",
 "language": "python"
}
```

如果上面Python编译器的路径不正确，则修改为正确路径。

如果仍然不行，则重装内核。

最后重启jupyter-lab服务即可。



### R内核

- 快捷选择：使用anaconda安装 R kernel

```shell
$pip install r r-essentials
```

- 不那么快捷的方式：手动安装 R kernel

如果你不是使用 anaconda, 这个过程可能稍显复杂。如果你还没有安装的话, 你需要从 [CRAN](https://cloud.r-project.org/)安装。(译者: 也可使用 `brew cask install r-gui`)

安装 R 完毕后，打开 R console 并运行如下命令：

```R
install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools'))
devtools::install_github('IRkernel/IRkernel')
IRkernel::installspec() # to register the kernel in the current R installation
```



开始一个新的R环境，只需要运行Jupyterlab后选择“New -> R”即可！熟悉的界面加入了新的成员。



### 同一个notebook里使用Python和R

```shell
$ pip install rpy2
```



## 调试器debugger

### pdb

安装：`pip install pdb`

ipython调试示例：

```python
import pdb
pdb.set_trace()
def f1():
    return 1

s=f1()
print(s)
```



表格 pdb命令

| 完整命令  | 简写命令  | 描述                               |
| --------- | --------- | ---------------------------------- |
| args      | a         | 打印当前函数的参数                 |
| break     | b         | 设置断点                           |
| clear     | cl        | 清除断点                           |
| condition | 无        | 设置条件断点                       |
| continue  | c或者cont | 继续运行，知道遇到断点或者脚本结束 |
| disable   | 无        | 禁用断点                           |
| enable    | 无        | 启用断点                           |
| help      | h         | 查看pdb帮助                        |
| ignore    | 无        | 忽略断点                           |
| jump      | j         | 跳转到指定行数运行                 |
| list      | l         | 列出脚本清单                       |
| next      | n         | 执行下条语句，遇到函数不进入其内部 |
| p         | p         | 打印变量值，也可以用print          |
| quit      | q         | 退出 pdb                           |
| return    | r         | 一直运行到函数返回                 |
| tbreak    | 无        | 设置临时断点，断点只中断一次       |
| step      | s         | 执行下一条语句，遇到函数进入其内部 |
| where     | w         | 查看所在的位置                     |
| !         | 无        | 在pdb中执行语句                    |



### xeus-python





# FAQ

1) pylab支持
\# 在开头添加pylab的内嵌语句，pylab是 Matplotlib 和Ipython提供的一个模块，提供了类似Matlab的语法。
%pylab inline
%matplotlib inline



2) No module named xxx但在命令行中可以导入

这是因为jupyter的默认路径和python默认路径不一致的问题，可用下面命令查看

```python
import sys
print(sys.path)
print(sys.executable)
```





<br>

# 附录

## 参考资料

**官网 **

https://jupyter.readthedocs.io/

https://jupyterlab.readthedocs.io/en/stable/

https://jupyter-notebook.readthedocs.io/en/stable/notebook.html



**参考链接**

[1]. Ipython和Jupyter notebook https://www.jianshu.com/p/88afa84e9765

[2]. Jupyter Notebook ：调试程序 https://blog.csdn.net/wangyuankl123/article/details/90349070

[3]. 27 个Jupyter Notebook的小提示与技巧 https://www.cnblogs.com/lvdongjie/p/11231648.html



## 插件plugins

安装插件

```shell
$ jupyter labextension install @jupyterlab/
```

