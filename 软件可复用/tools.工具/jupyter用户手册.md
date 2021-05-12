| 序号 | 修改时间  | 修改内容 | 修改人 | 审稿人 |
| ---- | --------- | -------- | ------ | ------ |
| 1    | 2021-4-23 | 创建     | Keefe  |        |





---

# 简介

## Jupyter Notebook

2014年出现的科学计算IDE。
Jupyter Notebook（此前被称为 IPython notebook）是一个交互式笔记本，支持运行 40 多种编程语言。
Jupyter Notebook 的本质是一个 Web 应用程序，便于创建和共享文学化程序文档，支持实时代码，数学方程，可视化和 markdown。用途包括：数据清理和转换，数值模拟，统计建模，机器学习等等。Jupyter Notebook是基于网页的用于交互计算的应用程序。其可被应用于全过程计算：开发、文档编写、运行代码和展示结果。

**Jupyter Notebook的主要特点**

1. 编程时具有**语法高亮**、*缩进*、*tab补全*的功能。
2. 可直接通过浏览器运行代码，同时在代码块下方展示运行结果。
3. 以富媒体格式展示计算结果。富媒体格式包括：HTML，LaTeX，PNG，SVG等。
4. 对代码编写说明文档或语句时，支持Markdown语法。
5. 支持使用LaTeX编写数学性说明。



```
# 安装
pip3 install jupyter

# 启动
jupyter notebook
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

  

```
# 安装
pip3 install jupyterlab

# 启动: jupyter lab 或者 jupyter-lab
jupyter lab
```

网络访问：缺省端口8888。如果端口被占用，则端口数量渐增。



# 用户篇



# 配置篇

## jupyter同时支持python2和python3
Jupyter Notebook 与 IPython终端 共享同一个内核。

需在python2/3的各自安装目录下再分别安装ipykernel

```
pip install ipykernel
python -m ipykernel install --user 
```



内核配置查看

```
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



## 密码管理和远程访问

查询密码

```sh
$ jupyter notebook list
```

Currently running servers:
http://localhost:8888/?token=7c9064bfb5139e72eb8774248df75d0564f450b09a13d57a :: E:\dev\python\bin\python36\Scripts

设置密码：

法1：在jupyter notebook正常开的文件 或 ipython里输入 

```python
in[1] from notebook.auth import passwd
in[2] passwd()
Enter password: 
Verify password: 
Out[2]: ‘sha1:f704b702aea2:01e2bd991f9c7208ba177b46f4d10b6907810927‘
```

法2: 直接命令行设置：

```
jupyter notebook password
Enter password: 
Verify password: 
```

说明：Ipython把输入的密码转换成sha，并用于认证JupyterLab，如果在Ipython输入密码和确认密码时直接回车，相当于不设密码，因此登录JupyterLab时可以不输入密码直接点击登录。



产生jupyterlab配置文件：

```
jupyter lab --generate-config
```

修改配置文件：

```
vi ~/.jupyter/jupyter_notebook_config.py
```

更改内容如下：

```
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

```
jupyter notebook --ip=127.0.0.1 --port 8000 --allow-root
```



## 调试器





# FAQ

1) pylab支持
\# 在开头添加pylab的内嵌语句，pylab是 Matplotlib 和Ipython提供的一个模块，提供了类似Matlab的语法。
%pylab inline
%matplotlib inline



2) No module named xxx但在命令行中可以导入

这是因为jupyter的默认路径和python默认路径不一致的问题，可用下面命令查看

```
import sys
print(sys.path)
print(sys.executable)
```





# 附录

## 参考资料

**官网 **

https://jupyter.readthedocs.io/

https://jupyterlab.readthedocs.io/en/stable/

https://jupyter-notebook.readthedocs.io/en/stable/notebook.html



## 快捷键





## 插件plugins



