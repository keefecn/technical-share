| 序号 | 修改时间  | 修改内容 | 修改人 | 审稿人 |      |
| ---- | --------- | -------- | ------ | ------ | ---- |
| 1    | 2021-4-23 | 创建     | Keefe  |        |      |
---









# 简介

官网：http://jupyter.org/ 
2014年出现的科学计算IDE。
Jupyter Notebook（此前被称为 IPython notebook）是一个交互式笔记本，支持运行 40 多种编程语言。
Jupyter Notebook 的本质是一个 Web 应用程序，便于创建和共享文学化程序文档，支持实时代码，数学方程，可视化和 markdown。用途包括：数据清理和转换，数值模拟，统计建模，机器学习等等。Jupyter Notebook是基于网页的用于交互计算的应用程序。其可被应用于全过程计算：开发、文档编写、运行代码和展示结果。



**Jupyter Notebook的主要特点**

1. 编程时具有**语法高亮**、*缩进*、*tab补全*的功能。
2. 可直接通过浏览器运行代码，同时在代码块下方展示运行结果。
3. 以富媒体格式展示计算结果。富媒体格式包括：HTML，LaTeX，PNG，SVG等。
4. 对代码编写说明文档或语句时，支持Markdown语法。
5. 支持使用LaTeX编写数学性说明。



# 用户篇

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



# 配置篇

## jupyter同时支持python2和python3
Jupyter Notebook 与 IPython终端 共享同一个内核。

需在python2/3的各自安装目录下再分别安装ipykernel
pip install ipykernel
python -m ipykernel install --user 



## 密码管理

查询密码

```sh
$ jupyter notebook list
```

Currently running servers:
http://localhost:8888/?token=7c9064bfb5139e72eb8774248df75d0564f450b09a13d57a :: E:\dev\python\bin\python36\Scripts

设置密码：在jupyter notebook正常开的文件里输入 

```python
in[1] from notebook.auth import passwd
in[2] passwd()
```



# FAQ

1）pylab支持
\# 在开头添加pylab的内嵌语句，pylab是 Matplotlib 和Ipython提供的一个模块，提供了类似Matlab的语法。
%pylab inline
%matplotlib inline



# 附录

## 参考资料

**官网 **

https://jupyter.readthedocs.io/

https://jupyter-notebook.readthedocs.io/en/stable/notebook.html



## 快捷键





