| 序号 | 修改时间  | 修改内容                                           | 修改人 | 审稿人 |
| ---- | --------- | -------------------------------------------------- | ------ | ------ |
| 1    | 2009.10   | 创建                                               | Keefe  | Keefe  |
| 2    | 2010-3-25 | 增加BSD socket实现                                 | 同上   |        |
| 3    | 2018-3-30 | 更新内核工具。                                     | 同上   |        |
| 4    | 2021-6-28 | 将《Linux内核开发系列》改名为《Linux内核源码分析》 | 同上   |        |









---

[TOC]



---

目录

[前言................................................................................................................................. 2](#_Toc510137724)

[内核专题系列................................................................................................................... 2](#_Toc510137725)

[1.   linux的引导过程？............................................................................................ 2](#_Toc510137726)

[2.   kernel编译流程？.............................................................................................. 2](#_Toc510137727)

[3.   module编程知识(LKM)...................................................................................... 3](#_Toc510137728)

[4.   内核初始化init.................................................................................................. 3](#_Toc510137729)

[5.   proc文件系统编程............................................................................................. 4](#_Toc510137730)

[6.   glibc编程........................................................................................................... 4](#_Toc510137731)

[7.   内核变动因素.................................................................................................... 4](#_Toc510137732)

[8.   自定义系统调用syscall....................................................................................... 5](#_Toc510137733)

[9.   linux内核同步机制............................................................................................ 6](#_Toc510137734)

[10.  BSD socket实现............................................................................................. 7](#_Toc510137735)

[11.  IO机制实现.................................................................................................. 9](#_Toc510137736)

[内核常用宏.................................................................................................................... 10](#_Toc510137737)

[内核工具........................................................................................................................ 11](#_Toc510137738)

[1) vim + ctag + taglist + cscope.................................................................................. 11](#_Toc510137739)

[2) How to install and use lxr...................................................................................... 12](#_Toc510137740)

[3) man kernel api...................................................................................................... 13](#_Toc510137741)

[4) 查看系统信息..................................................................................................... 13](#_Toc510137742)

[5) 内核探测工具..................................................................................................... 14](#_Toc510137743)

[Solaris......................................................................................................................................... 15](#_Toc510137744)

[6) 其它工具............................................................................................................ 16](#_Toc510137745)

[FAQ............................................................................................................................... 16](#_Toc510137746)

[参考资料........................................................................................................................ 17](#_Toc510137747)











# 1 简介

Linux官网：https://kernel.org/

源码版本：Linux-2.6.0

## 前言

**学习的目的：**

1）通过优秀的代码prety code来提高increase编程经验；

2）能够胜任更高要求的linux相关开发；



**Preface** **基础知识**

1 Makefile文件的制作

2 diff, patch的使用

3 shell脚本的书写

4 代码阅读：vim, ctags, sourcenav, lxr



## Linux的引导过程

1) 开机：cpu跳转到BIOS，由BIOS执行

2) BIOS：自检，检查外部设备，总线加入到系统资源表，选择引导设备，最后跳转到硬盘MBR。

3) Bootloader: bootsector, setup, system模块

* bootsector: 加载setup, system模块到内存, 执行完跳转到setup模块

* setup: 利用BIOS的中断机制,获取系统信息，移动system模块位置到0地址.

* system: head.s为system的首部，执行初始化IDT、GDT，初始化内存目录表等，然后跳转到本模块的内核初始化程序main/init.c中继续执行。



## 内核源码结构



![GNU/Linux 操作系统的基本体系结构](../../media/code/code_linux_000.png)

图  GNU/Linux 操作系统的基本体系结构

linux体系结构说明：user mode 进程需要通过`glibc`作一个到kernel mode 的转换。



# 2 内核知识

## 内核版本

说明：下面涉及到的Linux内核代码版本是 2.6.0

Linux内核版本详见 《[操作系统实现原理](../platform.平台/操作系统实现原理.md)》内核版本章节。



## 内核变动因素

1 ) 硬件平台: 硬件架构

表格 1 Linux内核支持的架构列表

| General architecture   dependent options（arch) | 描述                                                         |
| ----------------------------------------------- | ------------------------------------------------------------ |
| alpha                                           | DEC公司1992年推出的完全RISC指令集的64位架构                  |
| i386                                            | 属于x86体系，此目录下只有boot的一个压缩文件(基本合并到x86目录下了） |
| ia64  (ia:Intel Architecture)                   | Intel公司开发出的新一代64位微处理器体系结构，它的设计思想介于传统的RISC  (精简指令集计算机)和并行处理器之间。采用清晰并行指令计算(EPIC)，在此基础上定义了新的64位指令架构(ISA).基于IA-64架构的是Itanium系列处理器. |
| x86                                             | Intel cpu的架构，为当前最主流的cpu架构.使用x86指令集，64位处理使用扩展内存方式。（多核实现方式：1cpu2计算器）。 |
| arm  (Advanced RISC Machine)                    | 进阶精简指令集机器，是一个32位RISC指令集处理器，广泛使用于嵌入式系统中 。Acorn电脑公司（Acorn Computers Ltd）于1983年开始开发的。 |
| 其余：                                          | avr32 blackfin cris frv h8300 m32r m68k  m68knommu microblaze mips mn10300 parisc powerpc s390 sh sparc um xtensa |

备注：

* 指令集ISC：(Instruction Set Computing cpu)cpu的一种设计模式，用以加快处理器响应速度，传统上分为CISC和RISC。但64位机目前新增了二种指令集，一是Intel IA架构的EPIC（Explicitly Parallel Instruction Computers）精确并行指令计算机；另一个是AMD支持的x86-64，即支持32位x86指令，也增加了新的64位处理指令。支持RISC的有arm，alpha等。

* Asm: 1）Assembly Language,一种汇编语言; 2)Automatic Storage Management自动存储管理，oracle数据库支持的存储特性。3)一家德国公司缩写名。



## 内核编译流程

```shell
# step1: clean all generate file include .config
make mrproper

make menuconfig/xconfig/oldconfig
make
make modules

# cp modules to /usr/lib/$version
make modules_install
# cp vmlinuz, System.map to /boot
make install

# generate the initrd.img
mkinitramfs -o [dest_dir] [version]
```

说明：以上步骤是为了生成initrd.img, vmlinuz, System.map，然后在grub的menulist修改启动配置.

vmlinuz内核映象文件，支持虚拟内存vm，引导程序中的bootsector+setup+system+..组合而成,可被压缩。

System.map内核符号表，用”nm vmlinuz”产生。作用类似/proc/ksyms.

Initrd.img是initial ramdisk, 一般是来临时引导硬件到实际内核vmlinuz能够接管并继续引导的状态。

// grub boot sequence

```shell
kernel   //use linuz
initrd    //use initrd.img， 首先被执行
boot    //start boot
```



## 内核常用宏

| 宏名称                                                       | 用途                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| weak_alias                                                   | 弱符号连接                                                   |
| likely, unlikely                                             | 调用gcc的内嵌函数__builtin_expect,用来比较值，常用来与某个互斥变量比较。 |
| barrier                                                      | 优化屏障 （Optimization barrier）避免编译器的重排序优化操作，保证编译程序时在优化屏障之前的指令不会在优化屏障之后执行。 |
| container_of                                                 | 依据ptr取得type的指针                                        |
| SYSCALL_DEFINE2                                              | 系统调用宏                                                   |
| [cond_syscall](http://lxr.linux.no/linux+*/+code=cond_syscall)([x](http://lxr.linux.no/linux+*/+code=x)) | 有条件的系统调用                                             |
| asm                                                          | 汇编语言关键字，内联汇编                                     |
| const                                                        | C语言关键字，只读                                            |
| inline                                                       | C语言关键字，将函数代码合并到调用程序中，类似macro,但有类型参数检测。 |
| static                                                       | C语言关键字，修饰变量时只在本文件/类/函数有效。              |
| volatile                                                     | 告诉编译器不要编译优化，修饰变量时从内存中直接读写而不是寄存器。 |
| UL                                                           | unsigned long, 在不同的arch有不同的规定。                    |
| Asmlinkage                                                   | 告诉编译程序使用局部堆栈来传递参数，涉及到宏FASTCALL.     |



1) **weak_alias**

```assembly
15.	weak_alias (__socket, socket)
16.	#  define weak_alias(name, aliasname) _weak_alias (name, aliasname)
17.	#  define _weak_alias(name, aliasname) \
18.	  extern __typeof (name) aliasname __attribute__ ((weak, alias (#name)));
```

weak_alias用来弱符号连接。另外有强符号连接. 用来重命名，{name}={__#name}



**2)**  **likely, unlikely** (from: [include/linux/compiler.h](http://lxr.linux.no/linux+*/include/linux/compiler.h#L107))

这是调用gcc的内嵌函数__builtin_expect,用来比较值. likely(x)是指x=1时做某事, unlikely(x)指若x=1时不做某事。常用来与某个互斥变量比较。



**3)**  优化屏障barrier

编译器编译源代码时，会将源代码进行优化，将源代码的指令进行重排序，以适合于CPU的并行执行。然而，内核同步必须避免指令重新排序，优化屏障 （Optimization barrier）避免编译器的重排序优化操作，保证编译程序时在优化屏障之前的指令不会在优化屏障之后执行。
    Linux用宏barrier实现优化屏障，gcc编译器的优化屏障宏定义列出如下（在include/linux/compiler-gcc.h中）

`#define barrier() _asm__volatile_("": : :"memory") `



**4)**   container_of

```c
#define container_of(ptr, type, member) ({          \
    const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
(type *)( (char *)__mptr - offsetof(type,member) );})
```

其主要作用是依据ptr取得type的指针



**5)**  系统调用宏 [SYSCALL_DEFINE2](http://lxr.linux.no/linux+*/+code=SYSCALL_DEFINE2)

from: include/linux/syscalls.h

```c
#define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
#define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
#define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
#define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
#define SYSCALL_DEFINE5(name, ...) SYSCALL_DEFINEx(5, _##name, __VA_ARGS__)
#define SYSCALL_DEFINE6(name, ...) SYSCALL_DEFINEx(6, _##name, __VA_ARGS__)
#define SYSCALL_DEFINEx(x, sname, ...)              \
    static const char *types_##sname[] = {          \
        __SC_STR_TDECL##x(__VA_ARGS__)          \
    };                          \
    static const char *args_##sname[] = {           \
        __SC_STR_ADECL##x(__VA_ARGS__)          \
    };                          \
    SYSCALL_METADATA(sname, x);             \
    __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
```

这宏的主要作用是：告诉内核要传入的参数个数， x表示个数。

如：

```c
2096 SYSCALL_DEFINE2(socketcall, int, call, unsigned long __user *, args)
1266 SYSCALL_DEFINE3(socket, int, family, int, type, int, protocol)
```



**6)**   [cond_syscall](http://lxr.linux.no/linux+*/+code=cond_syscall)([x](http://lxr.linux.no/linux+*/+code=x))

declare: [kernel/sys_ni.c](http://lxr.linux.no/linux+*/kernel/sys_ni.c#L59)

[ 377](http://lxr.linux.no/linux+*/arch/x86/include/asm/unistd_32.h#L377)#define [cond_syscall](http://lxr.linux.no/linux+*/+code=cond_syscall)([x](http://lxr.linux.no/linux+*/+code=x)) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall")

[cond_syscall](http://lxr.linux.no/linux+*/+code=cond_syscall)([x](http://lxr.linux.no/linux+*/+code=x))宏用来有条件的系统调用。



## 内核初始化init

include/linux/init.h

```c
 153#ifndef MODULE
 167#define __define_initcall(level,fn,id) \
 168        static initcall_t __initcall_##fn##id __used \
 169        __attribute__((__section__(".initcall" level ".init"))) = fn

 //文件系统初始化
 194#define fs_initcall(fn)              __define_initcall("5",fn,5)

 269#else /* MODULE */

 276#define fs_initcall(fn)                 module_init(fn)

 296#endif
```



## module编程知识(LKM)

1)module出入口函数：module_init, module_exit

2)module使用相关命令：insmod, rmmod, lsmod, dmesg

3)module_parama,

符号导出宏:

```shell
MODULE_LICENSE(),
MODULE_DESCRIPTION(),
MODULE_AUTHOR(),
MODULE_SUPPORTED_DEVICE()
```

说明：将代码生成模块是为了动态可加载，在linux1.2后引入模块机制。内核函数库如fork, malloc的实现就是这种机制的体现。



# 3 内核源码

## CPU调度子系统

### 调度算法

原则: 公平, 高效.

衡量因素: 响应时间, 周转时间, 吞吐量

常见算法:

* 先进先出进程调度算法（FIFO）

* **基于优先数的调度（HPF—Highest Priority First**）

* **时间片轮转调度算 (RR—Round Robin)**

* **时间片选择问题：固定时间片,可变时间片**

* **多级队列反馈调度算法**



各操作系统调度实现

* **UNIX** 动态优先数法

* **5.3BSD** **多级反馈队列法**

* **Windows** **基于优先级的抢占式多任务调度**

* **Linux** **抢占式调度**

* **Solaris** **综合调度算法**



## 内存管理子系统

1）**32位内存寻址 (2^32=4G)**

**内核空间分配1G**:  映射到物理内存, 是连续的. 其中用到两种内存分配方式，整页分配_get_free_page（大内存）、slab分配kmalloc（小内存）。此外vmalloc也是在内核空间分配,只是分配的是内核虚拟空间,然后通过内核页表分配到分散的内存中,因此是不连续的,通常用于大于128kb空间时的分配.

**用户空间分配3G**: 每个进程都有自己的页表, CR3记录当前的进程页表首地址. 进程访问内存通过逻辑地址+CR3来得到物理地址. 此处主要通过mmap来分配内存, 一开始并不直接分配只是个虚拟地址, 只是要使用时发生缺页中断才真正分配物理页面.

**linux查看进程虚拟地址空间方法**

```shell
# 反汇编目标程序，查看程序静态结构
$ objdump -d [proc]

# 查看运行进程的虚拟地址空间
$ cat /proc/{pid}/maps
```



**glibc malloc实现:**

 ```c
//malloc.c
 ```





## 进程/线程管理子系统

进程是资源分配的最小单位。

Linux线程是CPU调度的最小单位。

LinuxThread:

* NPTL: Native POSIX Thread Library, 主流linux线程库的实现方式。



查看进程的地址空间：

1)   `$ cat /proc/{pid}/maps`

2)   vmstat

linux 通过二级页表来管理物理页面。

虚拟地址格式： 32bit {段地址，段偏移}



 表格   Linux进程地址空间

| **地址**       | **作用**                      | **说明**                               |
| -------------- | ----------------------------- | -------------------------------------- |
| >=0xc000  0000 | 内核虚拟存储器                | 用户代码不可见区域                     |
| <0xc000 0000   | Stack（用户栈）               | ESP指向栈顶                            |
|                | ↓  ↑                          | 空闲内存                               |
| >=0x4000  0000 | 文件映射区                    |                                        |
| <0x4000 0000   | ↑                             | 空闲内存                               |
|                | Heap(运行时堆)                | 通过brk/sbrk系统调用扩大堆，向上增长。 |
|                | .data、.bss(读写段)           | 从可执行文件中加载                     |
| >=0x0804 8000  | .init、.text、.rodata(只读段) | 从可执行文件中加载                     |
| <0x0804  8000  | 保留区域                      |                                        |





## 文件管理子系统

**进程与文件的关联数据结构**:

* fs_struct结构，它包含两个指向VFS索引节点的指针，分别指向root(即根目录节点)和pwd(即当前目录节点)；

* files_struct结构，它保存该进程打开文件的有关信息, 如下图所示

  ​         ![Linux文件系统的逻辑结构](../../media/code/code_linux_005.png)                      S

  图 Linux文件系统的逻辑结构



### /proc文件系统

用于用户进程与内核进程的通信。

1）proc文件的读写（应用）

2)

variable：struct proc_dir_entry

function: create_proc_entry(), mod_read()...

使用/proc文件系统来访问Linux内核的内容 http://www.ibm.com/developerworks/cn/linux/l-proc.html

探索/proc文件系统中的文件和子目录 http://www.comptechdoc.org/os/linux/howlinuxworks/linux_hlproc.html



## 驱动设备管理

源码:  /linux/drives

查看主设备号: `$cat /proc/devices`

Linux系统采用设备文件统一管理硬件设备，从而将硬件设备的特性及管理细节对用户隐藏起来，实现用户程序与设备无关性。

在Linux系统中，硬件设备分为两种，即块设备block和字符设备char。

|              | 块设备                                                       | 字符设备                      |
| ------------ | ------------------------------------------------------------ | ----------------------------- |
| 设计目的     | 主要针对磁盘等慢速设备设计的，以免耗费过多的CPU时间来等待    | 为了快速响应                  |
| 读写<bt>请求 | 利用一块系统内存作缓冲区。当用户进程对设备请求能满足用户的要求，就返回请求的数据；如果不能,就调用请求函数来进行实际I/O。 | 实际硬件I/O一般就紧接着发生了 |
| 读写单位     | 块（512bye)                                                  | 字节                          |
| 数据结构     | blk_dev_struct                                               | device_struct                 |

事实上，linux作为网络OS,还有一种loop设备用127.0.0.1来访问本地机器。

所有设备都作为特别文件, 可按照文件的方式来打开open,read,write, ioctl等操作。



![linux设备驱动分层结构示意图](../../media/code/code_linux_002.png)

图  linux设备驱动分层结构示意图



**设备驱动程序的数据结构组成**

device_struct结构由两项构成，一个是指向已登记的设备驱动程序名的指针(name)，另一个是指向file_operations结构的指针(fpos)。而 file_operations结构的成分几乎全是函数指针，分别指向实现文件操作的入口函数。设备的主设备号用来对`chrdevs数组`进行索引，如图7 所示。

 ![ linux字符设备驱动程序数据结构示意图](../../media/code/code_linux_003.png)

图 linux字符设备驱动程序数据结构示意图



![linux块设备驱动程序数据结构示意图](../../media/code/code_linux_004.png)

图 linux块设备驱动程序数据结构示意图



**设备驱动程序工作流程**:

用户进程利用*系统调用*在对设备文件进行诸如read/write操作时，系统调用通过设备文件的主设备号找到相应的设备驱动程序，然后读取这个数据结构相应的函数指针，接着把控制权交给该函数。



## 标准库glibc实现

glibc增加函数：在C标准函数库中增加新函数，然后重新编译glibc，最后用户include相应文件，直接使用新函数。（不推荐，为了程序的可用性，标准库不要去动它）



### 自定义系统调用syscall

**原理**：系统调用是用户程序通过 门机制 来进入内核执行。

环境： ubuntu9.01, linux kernel version 2.6.30, cpu i386

Step1: 实现自定义系统调用原函数如mysyscall, 添加对应源文件如mysyscall.c在/linux/kernel.  在makefile中增加 obj-y+=mysyscall.o

​       也可将新函数放在/linux/kernel/sys.c中，此时无需修改makefile文件.

Step2: 添加系统调用号于unistd.h. Linux2.6.30中路径为 arch/x86/include/asm/unistd_32.h.

```c
	#define ＿NR＿mysyscall	xxx
	#define __NR__syscalls	xxx+1		//此宏可选
```

step3: 注册函数指针到sys_call_table, linux2.6.30中路径为arch/x86/kernel/syscall_table_32.S

`.long sys_mysyscall`



step4: 用户空间测试函数, 使用`syscall(__NR__XX)`, 注意，需定义long errno, `＿NR＿XX`。

**Tips**：Linux的系统调用通过int 80h实现，用系统调用号来区分入口函数。

操作系统实现系统调用的基本过程是：

1. 应用程序调用库函数（API）；

2. API将系统调用号存入EAX，然后通过中断调用使系统进入内核态；

3. 内核中的中断处理函数根据系统调用号，调用对应的内核函数（系统调用）；

4. 系统调用完成相应功能，将返回值存入EAX，返回到中断处理函数；

5. 中断处理函数返回到API中；

6. API将EAX返回给应用程序。

应用程序调用系统调用的过程是：

* 把系统调用的编号存入EAX

* 把函数参数存入其它通用寄存器

* 触发0x80号中断（int 0x80）



示例：Linux中原系统调用实现(sys_unlink为例）

1) 声明declaration or prototype：include/linux/syscalls.h#L425

```c
asmlinkage long sys_unlink(const char __user *pathname);
```

2）实现implement (???)

/arch/x86/kernel/sys_?.c



3) 注册到sys_call_table:   arch/x86/kernel/syscall_table_32.S#L12

```assembly
ENTRY(sys_call_table)
.long sys_unlink        /* 10 */
```

4) 声明系统调用号

from: arch/x86/include/asm/unistd_32.h

```c
#define __NR_unlink              10
```

from:  arch/x86/include/asm/unistd_64.h#L200

```assembly
#define __NR_unlink                             87
__SYSCALL(__NR_unlink, sys_unlink)
//function declare or prototype at x86
  43#define __SYSCALL(nr, sym) extern asmlinkage void sym(void) ;
```



系统调用小结：

**用户空间函数使用系统调用**：如glibc函数使用系统调用。

* 通过自定义系统调用号 `NR_XXX` 传入内核，内核通过NR_XXX 找到对应的内核实现函数，通常是`sys_XXX`。自定义系统调用号需在内核 sys_call_table 中注册。
* Linux的系统调用通过 int 80h实现，用系统调用号来区分入口函数。

**内核空间系统调用实现**：

 * unistd.h 定义系统调用号`_NR_XX`；
 * /linux/kernel/sys.c 源文件中写系统调用函数xx；
 * /linux/sys.h 将函数名加放到 sys_call_table[]；
 * 用户空间使用 `syscallx( ＿NR＿XX)`调用。



### BSD socket实现

  ![image-20210702110142397](../../media/code/code_linux_001.png)

图  Linux 网络栈结构

**系统调用接口**: 大部分使用网络专用调用接口, 少部分使用普通文件操作接口如read/write.

**协议无关接口**: socket层, Linux 中的 socket 结构是 `struct sock`，这个结构是在 linux/include/net/sock.h 中定义的。

**网络协议:**

* linux/net/ipv4/af_inet.c     //定义inet协议,使用inet_inità `proto_register`

* linux/net/ipv4/udp.c, raw.c   //标识协议, proto, inetsw_array数组

**设备无关接口:** 调用 `register_netdevice` 或 `unregister_netdevice` 在内核中进行注册或注销

**设备驱动程序:**  `net_device` 结构

```c
//define:  glibc-2.9/socket/socket.c 38L
{__set_errno (ENOSYS);	}
11.	weak_alias (__socket, socket)
12.	#  define weak_alias(name, aliasname) _weak_alias (name, aliasname)
13.	#  define _weak_alias(name, aliasname) \
14.	  extern __typeof (name) aliasname __attribute__ ((weak, alias (#name)));

//implement:  sysdeps/unix/sysv/linux/sh/socket.S  90L
90 .globl __socket
91 ENTRY (__socket)
```

以上经过系统调用0x80 enter kernel, 在sys_call_table中有对应调用号，对应系统调用函数sys_socketcall, 由此函数根据socket调用号调用不同的实现如sys_socket, sys_bind.

调用号定义： arch/x86/include/asm/unistd_32.h.

```c
sys_call_table:  arch/x86/kernel/syscall_table_32.S
sys_socketcall:  net/socket.c, line 2205
sys_socket: 	kernel/sys_ni.c		//系统调用函数所调用的函数入口Non-implemented
```



**2) sys_socketcall (kernel)**

系统调用函数： sys_socketcall

```c
#define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
2096 SYSCALL_DEFINE2(socketcall, int, call, unsigned long __user *, args)

304 static struct file_system_type sock_fs_type = {
 305     .name =     "sockfs",
 306     .get_sb =   sockfs_get_sb,
 307     .kill_sb =  kill_anon_super,
 308 };
```



**3）sys_socket等函数的实现**

调用关系： sys_socketcall()-->sys_socket()-->socketàsock_create()-->__sock_create()

```c
//sys_socket( )的实现函数
1266 SYSCALL_DEFINE3(socket, int, family, int, type, int, protocol)

//kernel/sys_ni.c
42 cond_syscall(sys_socket);
```



**4）主要的数据结构**

file system : [include](http://lxr.linux.no/linux+*/include)/[linux](http://lxr.linux.no/linux+*/include/linux)/[fs.h](http://lxr.linux.no/linux+*/include/linux/fs.h)

```c
 899struct file {	};
713 struct inode {	};
1484struct file_operations {	};
1730struct file_system_type {	};
//示例：socket对应到相应的文件系统类型，操作socket就像操作file
304 static struct file_system_type sock_fs_type = {
 305     .name =     "sockfs",
 306     .get_sb =   sockfs_get_sb,
 307     .kill_sb =  kill_anon_super,
 308 };
```



socket: [include](http://lxr.linux.no/linux+*/include)/[linux](http://lxr.linux.no/linux+*/include/linux)/[net.h](http://lxr.linux.no/linux+*/include/linux/net.h)

```c
  90enum sock_type {	};		//socket类型
 130struct socket {	};		//BSD通用的socket结构
 156struct proto_ops {	};	//协议相关的操作函数

//代表具体协议内容的Sock结构:  include/net/sock.h, line 219
 219struct sock {	};
//tcp_sock: include/linux/tcp.h, line 247
 247struct tcp_sock {	};
//sk_buff: include/linux/skbuff.h, line 313
 313struct sk_buff {	};


 130struct socket {
 131        socket_state            state;
 132
 133        kmemcheck_bitfield_begin(type);
 134        short                   type;
 135        kmemcheck_bitfield_end(type);
 136
 137        unsigned long           flags;
 138        /*
 139         * Please keep fasync_list & wait fields in the same cache line
 140         */
 141        struct fasync_struct    *fasync_list;
 142        wait_queue_head_t       wait;
 143
 144        struct file             *file;
 145        struct sock             *sk;
 146        const struct proto_ops  *ops;
 147};
```



**5)** **主要的函数**

// 内核初始化socket网络文件系统：

kernel_init()-->do_basic_setup()-->do_initcalls()-->do_one_initcall()-->sock_init()



// 结点分配

__sock_create()-->sock_alloc()-->new_inode()-->alloc_inode()-->sock_alloc_inode()



// 协议族注册 net/ipv4/af_inet.c

`1625 fs_initcall(inet_init);`

调用关系：inet_init()-- >sock_register()



// 协议检测

__sock_create()--> inet_create()-- >



### IO机制实现

1）poll

poll -- > sys_poll -- > do_sys_poll

poll系统调用：

`int poll(struct pollfd *fds, nfds_t nfds, int timeout);`



内核2.6.30对应的实现代码为： [fs/select.c -->do_sys_poll]

```
 771int do_sys_poll(struct pollfd __user *ufds, unsigned int nfds,
 772                struct timespec *end_time)
```



流程简述：先注册回调函数__poll_wait，再初始化table变量（类型为struct poll_wqueues)，接着拷贝用户传入的struct pollfd（其实主要是fd），然后轮流调用所有fd对应的poll（把current挂到各个fd对应的设备等待队列上）。在设备收到一条消息（网络 设备）或填写完文件数据（磁盘设备）后，会唤醒设备等待队列上的进程，这时current便被唤醒了。current醒来后离开sys_poll的操作相对简单，这里就不逐行分析了。

http://www.pub4.com/?post=36



**2) epoll**

与poll/select不同，epoll不再是一个单独的系统调用，而是epoll_create/epoll_ctl/epoll_wait三个系统调用组成。 epoll是做为一个虚拟文件系统来实现的, 是个module，所以先看看module的入口eventpoll_init
 [fs/eventpoll.c-->evetpoll_init()]

```
1440fs_initcall(eventpoll_init);
```

流程简述： 略



## 其它

### Linux内核同步机制

详见文档 《[linux内核同步机制分析](linux内核同步机制分析.md)》



## 本章参考

* linux线程模型  http://www.ibm.com/developerworks/cn/linux/l-threading.html
* 使用/proc文件系统来访问Linux内核的内容 http://www.ibm.com/developerworks/cn/linux/l-proc.html
* 探索/proc文件系统中的文件和子目录 http://www.comptechdoc.org/os/linux/howlinuxworks/linux_hlproc.html
* MODULE编程 http://www.ibm.com/developerworks/cn/linux/l-lkm/?ca=drs-tp3208





# FAQ

**1)**   **如何生成全局变量**

头文件声明前＋extern 表示为全局变量。

如果是模块内的全局变量, 还需要用EXPORT_SYMBOL导出符号。



**2)**    **内核函数库生成**?

内核函数库：直接写函数，可供内核或用户使用的函数，最后链入到lib.a



**3)**    **shell程序如何实现**

shell: 支持管道可重定向,|,>,<,>> use dup(),pipe()实现



**4)   Linux防火墙**

 只需实现函数，生成内核模块，内核中提供了结构体变量struct nf_hook_ops进行回调。



**5)**   **Linux性能优化**

内核参数配置：/proc, sysctl



# 参考资料

* http://lxr.linux.no/

* /proc文件系统全面观 http://blog.csdn.net/wqf363/archive/2006/10/31/1359189.aspx

* 从2.x到4.x，Linux内核这十年经历了哪些重要变革 https://blog.csdn.net/sheji105/article/details/79558522?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromBaidu~default-6.base&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromBaidu~default-6.base



# 附录

## 内核工具

包括阅读源码, 使用内核帮助文档, 调试内核, 查看内核信息等.

### 1) vim + ctag + taglist + cscope

vi tags

a): ctags -R   //to create tags

b): help TlistToggle //to show tag list windows

switch window: ctrl+ww,

switch content: Enter

goto variable,function: ctrl+],ctl+g+], ctrl+t

tags kind: ctags --list-kinds

c): ts //ts = tselect, show the same tags

 :tags //show tag stack

其它：lxr, snavigator, source sight.



### 2) How to install and use lxr

step 1: install

a)install apache and start.

b)install or download linux source in /usr/src/

c)install perl and lxr

d)install glimpse   http://webglimpse.net/download.php



step 2: modify config

a)about lxr

path: /usr/share/lxr

modify config: /usr/share/lxr/http/lxr.conf

 sourceroot: xxxx

 dbdir: xxx

 glimpsebin:



b)apache

/etc/apache2/httpd.conf

```nginx
# add by denny, for lxr
Alias /lxr /usr/share/lxr
<Directory /usr/share/lxr>
Options All
AllowOverride All
</Directory>
```



/usr/share/lxr/http add .htaccess

```nginx
<Files ~ (search|source|ident|diff|find)$>
SetHandler cgi-script
</Files>
```



step 3: generate index

```shell
# get index at dbdir: xref, fileldx
$/var/www/html/lxr/bin/genxref /usr/src/linux-xxx

# get glimpse index at dbdir: .glimpse_*
$glimpseindex -H .  /usr/share/lxr/source/2.6.11/linux/
```



step 4: last show

 $/etc/init.d/apache restart

 http://localhost/lxr/http/blurb.html

### 3) man kernel api

http://www.kernel.org/doc/man-pages/index.html

```shell
$sudo apt-get install xmlto
$make mandocs      #编译出kernel API的man手册页
$make installmandocs     #安装kernel API手册页到man手册的第9部分
$make install mandocs	//from /Document
```



**man手册使用指南**

http://kernel.org/doc/man-pages/

http://linuxmanpages.com/

[**1. General Commands**](http://linuxmanpages.com/man1/)
 [**2. System Calls**](http://linuxmanpages.com/man2/)
 [**3. Subroutines**](http://linuxmanpages.com/man3/)

provided by the standard C library (with particular focus on [glibc](http://www.gnu.org/software/libc/), the [GNU](http://www.gnu.org) C library).
 [**4. Special Files**](http://linuxmanpages.com/man4/)

which documents details of various devices, most of which reside in **/dev****.**

[**5. File Formats**](http://linuxmanpages.com/man5/)

which describes various file formats, and includes [proc(5)](http://kernel.org/doc/man-pages/online/pages/man5/proc.5.html), which documents the **/proc** file system.
 [**6. Games**](http://linuxmanpages.com/man6/)
 [**7. Macros and Conventions**](http://linuxmanpages.com/man7/)
 [**8. Maintenence Commands**](http://linuxmanpages.com/man8/)



经典推荐：

top(1)   ps(1)

[syscalls(2)](http://kernel.org/doc/man-pages/online/pages/man2/syscalls.2.html)   [_syscall(2)](http://kernel.org/doc/man-pages/online/pages/man2/_syscall.2.html)   [alarm(2)](http://kernel.org/doc/man-pages/online/pages/man2/alarm.2.html)

[sleep(3)](http://kernel.org/doc/man-pages/online/pages/man3/sleep.3.html)

[initrd(4)](http://kernel.org/doc/man-pages/online/pages/man4/initrd.4.html) [mem(4)](http://kernel.org/doc/man-pages/online/pages/man4/mem.4.html)

[proc(5)](http://kernel.org/doc/man-pages/online/pages/man5/proc.5.html)  [fs(5)](http://kernel.org/doc/man-pages/online/pages/man5/fs.5.html)

[standards(7)](http://kernel.org/doc/man-pages/online/pages/man7/standards.7.html)  [unicode(7)](http://kernel.org/doc/man-pages/online/pages/man7/unicode.7.html)   [utf-8(7)](http://kernel.org/doc/man-pages/online/pages/man7/utf-8.7.html)

[pthreads(7)](http://kernel.org/doc/man-pages/online/pages/man7/pthreads.7.html)   [regex(7)](http://kernel.org/doc/man-pages/online/pages/man7/regex.7.html) [time(7)](http://kernel.org/doc/man-pages/online/pages/man7/time.7.html)  [sem_overview(7)](http://kernel.org/doc/man-pages/online/pages/man7/sem_overview.7.html)  [shm_overview(7)](http://kernel.org/doc/man-pages/online/pages/man7/shm_overview.7.html)  [signal(7)](http://kernel.org/doc/man-pages/online/pages/man7/signal.7.html)

[socket(7)](http://kernel.org/doc/man-pages/online/pages/man7/socket.7.html)    [tcp(7)](http://kernel.org/doc/man-pages/online/pages/man7/tcp.7.html)   [udp(7)](http://kernel.org/doc/man-pages/online/pages/man7/udp.7.html)   [ip(7)](http://kernel.org/doc/man-pages/online/pages/man7/ip.7.html)       [epoll(7)](http://kernel.org/doc/man-pages/online/pages/man7/epoll.7.html)



### 4) 查看系统信息

1 查看内核版本信息

$ uname -a

$ cat /proc/version



2 查看cpu

$ cat /proc/cpuinfo



3 查看内存

$ cat /proc/meminfo



4 查看gcc版本

$ gcc -v



5 查看glibc版本

```shell
$ ls -l /lib/libc.so.*
# 或者
$ ldd glibc
# 或者
$ apt-cache dkgnames |grep glibc
```



6 查看线程库

$ getconf GNU_LIBPTHREAD_VERSION

NPTL 2.9



7 others

```shell
$env //环境变量
$locale  //本地化信息locale-specific infomation
$getconf -a
```



### 5) 内核探测工具

#### Linux

**1 objdump/readelf**

Usage: objdump <option(s)> <file(s)>

Display information from object <file(s)>.

readelf - Displays information about ELF files.



**2 hexdump**

hexdump, hd - ASCII, decimal, hexadecimal, octal dump



**3 nm/ar**

nm - list symbols from object files

 显示目标文件中符号，值等。在调试库文件中有大用。

ar - create, modify, and extract from archives 将文件链接到库中。



**4 printk/dmesg**

* printk 打印内核信息到/var/log/message

* dmesg 显示内核信息



**5** **调试工具**

Solaris: mdb, dtrace

Linux: kdb



**6** **查看工具**

generic: time, strace, dmesg, pgrep, pmap...

strace: 跟踪进程的系统调用函数和信号trace system calls and signals.

dmesg: 显示内核打印信息printk

pgrep: 用来查看进程信息

pmap: 查看进程地址空间

gdb: 用户态程序调试工具.

代码查看工具：snavigator, source insight, lxr, vim+ctags



#### Solaris

**查看进程状态**

| pargs  | 查看进程或core的参数、环境变量等 |
| ------ | -------------------------------- |
| pflags | 查看进程标志位值                 |
| pcred  | 查看进程权限（credentials）      |
| pldd   | 查看进程链接的动态链接库         |
| psig   | signal的处理方式                 |
| pstack | 打印调用栈                       |
| pmap   | 打印进程地址空间                 |
| pfiles | 打开的文件                       |
| plimit | 打印或设置进程的资源限制         |
| prstat | 交互式打印所有进程的状态         |
| ptree  | 进程树                           |
| ptime  | 时间                             |
| pwdx   | 工作目录                         |



**进程控制**

| pgrep | 根据程序名或其他属性找到进程ID |
| ----- | ------------------------------ |
| pkill | 发信号（signal）给指定的进程   |
| pstop | 暂停进程                       |
| prun  | 继续被pstop的进程              |
| prctl | 查看/设置进程资源              |
| pwait | 等待进程结束                   |
| preap | 清理僵尸（zombie）进程         |



**进程跟踪调试/核心跟踪调试**

| mdb    | 调试进程或core文件         |
| ------ | -------------------------- |
| truss  | 跟踪函数和系统调用         |
| dtrace | 几乎无所不能的动态跟踪工具 |
| mdb    | 调试核心或核心core文件     |



**查看系统状态**

| busstat | 总线硬件计数   |
| ------- | -------------- |
| cpustat | cpu硬件计数    |
| iostat  | IO/NFS状态统计 |
| kstat   | 核心状态统计   |
| mpstat  | 处理器状态统计 |
| netstat | 网络状态统计   |
| nfsstat | nfs状态        |

