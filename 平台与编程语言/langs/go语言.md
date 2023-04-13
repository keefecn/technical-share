| 序号 | 修改时间  | 修改内容                               | 修改人 | 审稿人 |
| ---- | --------- | -------------------------------------- | ------ | ------ |
| 1    | 2023-4-12 | 创建。从《多语言开发》迁移GO章节成文。 | Keefe  | Keefe  |
|      |           |                                        |        |        |

<br><br><br>

---

[TOC]

---

## GO语言简介

​      Go 是一个开源的编程语言，它能让构造简单、可靠且高效的软件变得容易。
​      Go是从2007年末由Robert Griesemer, Rob Pike, Ken Thompson主持开发，后来还加入了Ian Lance Taylor, Russ Cox等人，并最终于2009年11月开源，在2012年早些时候发布了Go 1稳定版本。现在Go的开发已经是完全开放的，并且拥有一个活跃的社区。

​      Go语言是一种新的语言，一种并发的、带垃圾回收的、快速编译的语言。它具有以下特点：

1. 它可以在一台计算机上用几秒钟的时间编译一个大型的Go程序。

2. Go语言为软件构造提供了一种模型，它使依赖分析更加容易，且避免了大部分C风格include文件与库的开头。

3. Go语言是静态类型的语言，它的类型系统没有层级。因此用户不需要在定义类型之间的关系上花费时间，这样感觉起来比典型的面向对象语言更轻量级。

4. Go语言完全是垃圾回收型的语言，并为并发执行与通信提供了基本的支持。

​      Go的目标是希望提升现有编程语言对程序库等依赖性(dependency)的管理，这些软件元素会被应用程序反复调用。由于存在[并行编程模式](http://baike.baidu.com/item/并行编程模式)，因此这一语言也被设计用来解决多处理器的任务。

Go 语言最主要的特性：

- 自动垃圾回收
- 更丰富的内置类型
- 函数多返回值
- 错误处理
- 匿名函数和闭包
- 类型和接口
- **并发编程** ： goroutime, chan
- 反射
- 语言交互性

示例项目：[pupuk/addr: 收货地址智能解析 Written in Go，可解析出：姓名+电话+邮编+身份证号+省+市+区+街道地址 超高性能（1s能解1.6w条） (github.com)](https://github.com/pupuk/addr)

<br>

## 入门篇

**安装环境**

* Linux/ubuntu: `$ sudo apt-get install golang`
* windows: 用msi安装，安装后设置环境变量 set (GOPATH, GOROOT, GOARCH, GOOS)

**go命令**

```shell
$ go version
go version go1.2.1 linux/amd64
$ go
Go is a tool for managing Go source code.
Usage:
     go command [arguments]
The commands are:
    build    compile packages and dependencies #编译成二进制
    clean    remove object files
    env      print Go environment information
    fix      run go tool fix on packages
    fmt      run gofmt on package sources
    get      download and install packages and dependencies
    install  compile and install packages and dependencies
    list     list packages or modules
    run      compile and run Go program  #编译+运行
    test     test packages
    tool     run specified go tool
    version  print Go version
    vet      run go tool vet on packages
Use "go help [command]" for more information about a command.
Additional help topics:
    c     calling between Go and C
    gopath   GOPATH environment variable
    importpath  import path syntax
    packages    description of package lists
    testflag    description of testing flags
    testfunc    description of testing functions
```

说明：go get下载的依赖包缺省放在 ~/go/

**第一个 Go程序**
接下来我们来编写第一个 Go 程序 hello.go（Go 语言源文件的扩展是 .go），代码如下：

```go
// test.go
package main    //包名，都需要一个main包
import "fmt"

func main() {
    /* 这是我的第一个简单的程序 */
   fmt.Println("Hello, World!")
}
```

执行以上代码输出：

```shell
$ go run hello.go
Hello, World!
```

**语法**

**运算符**：分算术、关系、逻辑、位、赋值和其它。

**控制语句**： 条件 循环

**特殊语法**：指针  range  slice map

* 数组：

  ```go
  // 数组声明
  var variable_name [SIZE] variable_type
  var variable_name [SIZE1][SIZE2]...[SIZEN] variable_type
  // 示例：一维、三维数组
  var balance [10] float32
  var threedim [5][10][4]int
  
  // 数组初始化
  var balance = [5]float32{1000.0, 2.0, 3.4, 7.0, 50.0}
  balance := [5]float32{1000.0, 2.0, 3.4, 7.0, 50.0}
  ```

* slice：切片是对数组的抽象。

  ```go
  // 直接声明 或者 make生成切片
  var identifier []type
  var slice1 []type = make([]type, len)
  slice1 := make([]type, len)
  ```

* map:  Map 是一种无序的键值对的集合。

  ```go
  /* 声明变量，默认 map 是 nil */
  var map_variable map[key_data_type]value_data_type
  /* 使用 make 函数 */
  map_variable := make(map[key_data_type]value_data_type)
  ```

<br>

## 高级篇

**GO并发**

Go 语言支持并发，我们只需要通过 go 关键字来开启 goroutine 即可。

<u>goroutine </u>是轻量级线程，goroutine 的调度是由 Golang 运行时进行管理的。同一个程序中的所有 goroutine 共享同一个地址空间。

Go 允许使用 go 语句开启一个新的运行期线程， 即 goroutine，以一个不同的、新创建的 goroutine 来执行一个函数。

goroutine 语法格式：

```go
go 函数名( 参数列表 )
```

**通道（channel）**

通道（channel）是用来传递数据的一个数据结构。

通道可用于两个 goroutine 之间通过传递一个指定类型的值来同步运行和通讯。操作符 `<-` 用于指定通道的方向，发送或接收。如果未指定方向，则为双向通道。

```go
ch <- v    // 把 v 发送到通道 ch
v := <-ch  // 从 ch 接收数据，并把值赋给 v
```

声明一个通道很简单，我们使用chan关键字即可，通道在使用前必须先创建：

```go
ch := make(chan int)
```

**工程化 go modul**

```shell
# go mod init 初始化，生成文件go.mod，列出依赖的 
$ go mod init github.com/mohuishou/go-mod-example

# go.mod 文件正常情况会包含module和require 模块，
# 除此之外还可以包含 replace 和 exclude 模块。
$ cat go.mod
module github.com/mohuishou/go-mod-example
go 1.16

# go get 下载依赖模块，生成文件go.sum
$ go get github.com/sirupsen/logrus@v1.7.0

# 清理依赖
$ go mod tidy
```

<br><br>

## 参考资料

* go语言官网 https://golang.org/   https://golang.google.cn/
* go语言教程 http://www.runoob.com/go/go-tutorial.html
* 解读Go语言的2021：稳定为王  https://mp.weixin.qq.com/s/oIpbtKiCyKKWPd4pXaYAEg
* Go工程化--Go module  https://www.cnblogs.com/failymao/articles/15159394.html