| 序号 | 修改时间   | 修改内容 | 修改人 | 审稿人 |
| ---- | ---------- | -------- | ------ | ------ |
| 1    | 2009-12-26 | 创建     | Keefe  | Keefe  |

 



 

摘要：本文从linux同步机制引入的机制开始, 讲述了同步机制的变化过程. 并着重分析了原子量,自旋锁spinlock,信号量的实现, 最后将各种同步机制作了整体比较.

关键词: SMP,内核抢占, 原子量,atomic,自旋锁,spinlock,信号量,semaphore

Tips: 研究选定的内核版本linux 2.6.30, CPU arch x86, SMP

 



[一 引言................................................................................................................................................ 2](#_Toc465081840)

[二 linux内核同步机制发展情况....................................................................................................... 2](#_Toc465081841)

[1 单CPU的同步机制................................................................................................................... 2](#_Toc465081842)

[2 SMP的同步机制........................................................................................................................ 3](#_Toc465081843)

[3 内核可抢占时的同步机制....................................................................................................... 4](#_Toc465081844)

[三 常见的同步机制实现分析............................................................................................................ 4](#_Toc465081845)

[linux内核支持的架构.................................................................................................................. 4](#_Toc465081846)

[同步机制实现需要的基础知识................................................................................................... 5](#_Toc465081847)

[1 原子运算符（原子量）的实现............................................................................................... 7](#_Toc465081848)

[*1)**原子量实现的架构相关性*................................................................................................ 8](#_Toc465081849)

[2)原子量类型atomic_t定义................................................................................................ 9](#_Toc465081850)

[3)原子量操作函数................................................................................................................ 9](#_Toc465081851)

[4)原子量加法操作函数实现分析...................................................................................... 10](#_Toc465081852)

[2自旋锁spinlock....................................................................................................................... 11](#_Toc465081853)

[1)自旋锁spinlock_t类型定义............................................................................................ 11](#_Toc465081854)

[2)自旋锁操作函数.............................................................................................................. 12](#_Toc465081855)

[3)函数实现.......................................................................................................................... 13](#_Toc465081856)

[3 读/写锁.................................................................................................................................... 17](#_Toc465081857)

[1)读写锁rwlock_t类型定义............................................................................................ 17](#_Toc465081858)

[2)读写锁操作函数.............................................................................................................. 18](#_Toc465081859)

[4 内核信号量............................................................................................................................. 18](#_Toc465081860)

[1)信号量semaphore类型定义........................................................................................... 18](#_Toc465081861)

[2)信号量操作函数.............................................................................................................. 18](#_Toc465081862)

[3)信号量函数实现.............................................................................................................. 19](#_Toc465081863)

[四 各种同步机制比较分析.............................................................................................................. 20](#_Toc465081864)

[1 同步机制列表......................................................................................................................... 20](#_Toc465081865)

[2 spinlock与semaphore比较.................................................................................................... 21](#_Toc465081866)

[3 其它......................................................................................................................................... 22](#_Toc465081867)

[五 结尾.............................................................................................................................................. 22](#_Toc465081868)

[参考文献............................................................................................................................................ 22](#_Toc465081869)





 

# 一 引言

  早期linux版本是没有现在这么复杂的同步机制的，那么现在Linux内核为什么要引入同步机制呢？

  同步机制用来保护数据或代码。当存在并发特性时，必须使用同步方法。如当在同一时间段出现两个或更多进程并且这些进程彼此交互（例如，共享相同的资源）时，就存在*并发* 现象。下表是并发的重要定义；

| 术语     | 定义                                                         |      |
| -------- | ------------------------------------------------------------ | ---- |
| 竞态条件 | 两个或更多线程同时操作资源时将会导致不一致的结果。           |      |
| 临界段   | 用于协调对共享资源的访问的代码段。                           |      |
| 互斥锁   | 确保对共享资源进行排他访问的软件特性。                       |      |
| 死锁     | 由两个或更多进程和资源锁导致的一种特殊情形，将会降低进程的工作效率。 |      |

**表 1. 并发中的重要定义**

 

  在单处理器（uniprocessor，UP）主机上可能发生并发，在这种主机中多个线程共享同一个 CPU 并且抢占（preemption）创建竞态条件。*抢占* 通过临时中断一个线程以执行另一个线程的方式来实现 CPU 共享。*竞态条件* 发生在两个或更多线程操纵一个共享数据项时，其结果取决于执行的时间。在多处理器（MP）计算机中也存在并发，其中每个处理器中共享相同数据的线程同时执 行。注意在 MP 情况下存在真正的并行（parallelism），因为线程是同时执行的。而在 UP 情形中，并行是通过抢占创建的。两种模式中实现并发都较为困难.

​    当出现多处理器或者单处理器内核可抢占时，同步机制就显得很有必要。

# 二 linux内核同步机制发展情况

​    linux内核早期版本是单处理器，不支持内核抢占。后来硬件发展到了多处理器（多核），内核中加入了对MP的支持。再后来为了增强linux内核的实时性，加入了内核抢占机制，由此形成了现在的同步机制。Linux的同步机制由下面的两个宏密切相关。

| 配置宏         | 含义               | 出现版本                  |      |
| -------------- | ------------------ | ------------------------- | ---- |
| CONFIG_SMP     | 是否SMP机器        | V1.3.42开始支持，不断完善 |      |
| CONFIG_PREEMPT | 配置内核是否可抢占 | V2.5.4开始支持            |      |

表2 linux kernel对并发的支持宏

## 1 单CPU的同步机制

单处理器的操作系统上在下面几种情况下可能出现竞争条件.一是内核短临界区资源；

二是与中断共享的数据结构；三是慢速设备的长期占用如磁盘IO操作某个文件. 根据这三种情况得到对应三种同步机制: 短期互斥、中断互斥和长期互斥[4]。

**1) 短期互斥**

短期互斥是指防止发生在短临界区上的竞争。当内存处于更新其数据结构时，就会出现这样的临界区。由于内核数据结构被所有止在执行的进程共享，如果多个以内核态运行的进程同时更新内核数据结构时，就可能出现竞争。由于单处理器系统一次只能执行一个进程，所以只有在抢占式内核中才可能出现这样竞争。为了避免这种情况的发生，Linux的内核被设计为不可抢占，用户态进程以分时的方式执行，而内核态进程没有分时执行，不能被抢占。囚此当一个内核态进程主动放弃处理器时，它已经离开了临界区，释放了临界资源，从而不会产生竟争。

**2)** **中断互斥**

如果一个正在执行的进程被中断，而中断处理程序访问了该进程还没有释放的数据结构，那么就可能会产生竞争条件。

因此，如果进程要访问与可屏蔽中断的中断处理程序共享的数据结构，那么它首先应该禁止中断，然后进入临界区，退出临界区之后再重新允许中断。禁止和允许中断的动作就实现了互斥。x86体系结构通过中断指令来禁止和允许中断指令，它们通过标志寄存器EFLAGS的标志位IF设置为0和1来禁止和允许中断。sti允许中断,cli关闭中断.

 

**3)** **长期互斥**

​    如果一个进程执行一个系统调用写一个磁盘文件，那么操作系统会阻止对同一文件的读或写系统调用，直到当前的系统调用完成为止。为了完成系统调用，可能需要一次或者多次的磁盘I/O操作。与处理器相比，磁盘I/O的速度非常慢。为了不让处理器在系统调用完成之前处于无事可做的等待状态，执行系统调用的进程需要让自己被其它进程抢占。这样一来，就需要一种技术能阻止抢占处理器的进程对同一个文件进行读写。Linux内核使用数据结构competion来标志对一个需要长期互斥的对象的访问是否完成:

```C
struct completion{
	unsigned int done;	//初始化为0,若为0表示未完成,大于0则表示已完成
	wait-queue head t wait; 
};
```

done是互斥锁，wait是等待该互斥对象的队列。内核中每个需要长期互斥的对象都附加一个competion实例。

competion机制是一种轻量级的同步机制,用来解决慢设备IO操作的独占.

## 2 SMP的同步机制

​    SMP——对称多处理是目前耦合程度最高的一种多处理器系统。在对称多处理器系统中，资源为系统中的所有处理器共享，每个处理器能平等地访问共享存储器、I/O部件以及操作系统服务，系统负载能有效地分配到所有的处理器上。

SMP系统中增加更多处理器的难点是系统不得不消耗资源来支持处理器抢占内存，以及内存同步两个主要问题。

抢占内存是指当多个处理器共同访问存储器中的数据时，它们并不能同时去读写数据，虽然一个处理器正在读一段数据时，其他处理器可以同时读这段数据，但当一个处理器正在修改某段数据时，该处理器将会锁定这段数据，其他处理器要操作这段数据就必须等待数据的解锁。显然，处理器数目越多，这种问题出现越频繁。此问题可用*高速缓冲区*得到解决.

然而高速缓冲区也会导致内存同步问题. 因此,高速缓冲区的更新机制至关重要.在SMP中为了防止多个处理器访问同一内存地址,引入了*内存屏蔽机制*.如x86体系结构中的锁内存总线指令lock前缀.

此外,为了保护单个CPU的专有数据,2.6内核引入了per-CPU变量.

## 3 内核可抢占时的同步机制

   一个可抢占的Linux内核可以让 Linux 内核如同用户空间一样允许被抢占。当一 个高优先级的进程到达时,不管当前进程处于用户态还是核心态,可抢占内核的Linux都会调度高优先级的进程运行[5]。

有几种情况Linux内核不应该被抢占，除此之外Linux内核在任意一点都可被抢占。这几种情况是：

(1) 内核正进行中断处理。在Linux内核中进程不能抢占中断（中断只能被其他中断中止、抢占，进程不能中止、抢占中断），在中断例程中不允许进行进程调度。进程调度函数schedule()会对此作出判断，如果是在中断中调用，会打印出错信息。

(2) 内核正在进行Bottom Half（中断的底半部）处理。

(3) 内核的代码段正持有spinlock自旋锁、writelock/readlock读写锁等锁，处于这些锁的保护状态中。内核中的这些锁是为了在SMP系统中保证不同CPU上运行的进程并发执行的正确性。当持有这些锁时，内核不应该被抢占，以避免重入或产生数据保护问题。

(4) 内核正在执行调度程序Scheduler。抢占的原因就是为了进行新的调度，没有理由将调度程序抢占掉再运行调度程序。

(5) 内核正在对每个CPU“私有”的数据结构操作(Per-CPU date structures)。

 

为保证Linux内核在以上情况下不会被抢占，使用了一个变量 **preempt_count**，称为内核抢占锁。这一变量被设置在进程的PCB结构task_struct中。每当内核要进入以上几种状态时，变量preempt_count就加１，指示内核不允许抢占。每当内核从以上几种状态退出时，变量preempt_count就减１，同时进行可抢占的判断与调度。如果preempt_count>0，则说明内核现在处于不可抢占状态，不能进行重新调度；如果preempt_count＝0，则说明内核现在是安全的，可以被抢占，能进行重新调度，如果有抢占请求，就进行抢占调度。

 以上三种情况的分析可知，内核态进程是不可抢占的，延续了单CPU下的设计规则。

在SMP的情形下，开始时加入了大内核锁，对多CPU进行抢占时，先要获得内核锁，才可操作；后来为了提升性能，锁粒度进一步缩小，先后引入了新的硬件处理单元内存屏蔽机制。



# 三 常见的同步机制实现分析

## linux内核支持的架构

  各种同步机制的实现是用汇编语句来实现，需要硬件支持。与硬件架构密切相关，下表是linux内核支持的架构列表。

| General architecture   dependent  options（arch) | 描述                                                         |
| ------------------------------------------------ | ------------------------------------------------------------ |
| alpha                                            | DEC公司1992年推出的完全RISC指令集的64位架构                  |
| i386                                             | 属于x86体系，此目录下只有boot的一个压缩文件(基本合并到x86目录下了） |
| ia64(ia:Intel Architecture)                      | Intel公司开发出的新一代64位微处理器体系结构,它的设计思想介于传统的RISC  (精简指令集计算机)和并行处理器之间。<BR>采用清晰并行指令计算(EPIC),在此基础上定义了新的64位指令架构(ISA).基于IA-64架构的是Itanium系列处理器. |
| x86                                              | Intel  CPU的架构，为当前最主流的CPU架构.使用x86指令集，64位处理使用扩展内存方式。（多核实现方式：1CPU 2计算器）。 |
| arm（Advanced  RISC Machine）                    | 进阶精简指令集机器，是一个32位RISC指令集处理器，广泛使用于嵌入式系统中  。Acorn电脑公司（Acorn Computers Ltd）于1983年开始开发的。 |
| 其余：                                           | avr32 blackfin cris frv h8300 m32r m68k m68knommu  microblaze mips mn10300 parisc powerpc s390 sh sparc um xtensa |

**表3 Linux内核支持的架构列表**

 

## 同步机制实现需要的基础知识

**1) 指令集ISC**：(Instruction Set Computing CPU)CPU的一种设计模式，用以加快处理器响应速度，传统上分为CISC和RISC。但64位机目前新增了二种指令集，一是Intel IA架构的EPIC（Explicitly Parallel Instruction Computers）精确并行指令计算机；另一个是AMD支持的x86-64，即支持32位x86指令，也增加了新的64位处理指令。支持RISC的有arm，alpha等。

 

**2）c/c++的关键字volatile**

  用它声明的类型变量表示可以被某些编译器未知的因素更改, 因此编译器将不对其作代码优化, 从而可以提供对本地址的稳定访问。

提供下面保证：

  a). 对声明为 volatile 的变量进行的任何操作都不会被优化器去除，即使它看起来没有意义（例如：连续多次对某个变量赋相同的值），因为它可能被某个在编译时未知的外部设备或线程访问。

  b). 被声明为 volatile 的变量不会被编译器优化到寄存器中，每次读写操作都保证在内存(详见下文)中完成。

  c). 在不同表达式内的多个 volatile 变量间的操作顺序不会被优化器调换（即：编译器保证多个 volatile 变量在 sequence point 之间的访问顺序不会被优化和调整）。

不提供下面保证：

\# volatile 声明不保证读写和运算操作的原子性。

\# volatile 声明不保证对其进行的读写操作直接发生在主内存。相反，CPU 会尽可能让这些读写操作发生在 L1/L2 cache 上。除非：

1. 发生了一个未命中的读请求。

  2. 所有级别的 cache 均已被配置为通过式写（write through）。

  3. 目标地址为 non-cacheable 区（主要是其它设备映射到内存地址空间的通信接口。例如：网卡的板载缓冲区、显卡板载显存、WatchDog 寄存器等等）。

\# 编译器仅保证自己在优化时不会变更多个 volatile 变量间的操作顺序。 但编译器并不保证代码在处理器执行时的顺序。 即：如果处理器支持乱序发射（out-of-order）执行的话，程序员预期的内存访问顺序仍然会被打乱。这时，程序员需要显式使用内存屏障指令来通知处理器期望的内存访问顺序

**3)原子操作**

原子操作可以提供下面保证[7]：

* 对原子量的 '读出-计算-写入' 操作序列是原子的，在以上动作完成之前，任何其它处理器和线程均无法访问该原子量。

* 原子操作必须保证缓存一致性。即：在 SMP 环境中，原子操作不仅要把计算结果同步到主存，还要以原子的语义将他们同步到当前平台上其他 CPU 的 cache 中。在大部分硬件平台上，cache 同步通常由锁总线指令完成。意即：逻辑上，所有原子操作都显式使用或隐含使用了一个锁总线操作。例如：x86 指令 'cmpxchg' 中就隐含了锁总线操作。 

**4) 优化屏障**

编译器编译源代码时，会将源代码进行优化，将源代码的指令进行重排序，以适合于CPU的并行执行。然而，内核同步必须避免指令重新排序，优化屏障 （Optimization barrier）避免编译器的重排序优化操作，保证编译程序时在优化屏障之前的指令不会在优化屏障之后执行。
    Linux用宏barrier实现优化屏障，gcc编译器的优化屏障宏定义列出如下（在include/linux/compiler-gcc.h中） 

`#define barrier() _asm__volatile_("": : :"memory") `

 

**5)** **内存屏障**

内在屏障用于消除 CPU 乱序执行优化对内存访问顺序的影响。可分为

·     全屏障语义： 操作序列为｛向前：OP: 向后双向同步｝

·     Acquire语义: 操作序列为（OP：向后同步），如互斥加锁。

·     Release语义:操作序列为（向前同步：OP），如互斥解锁。

·     无屏障语义： 不作任何处理

适用最广的是全屏障语义，使得所有在设置全屏障之前发起的内存访问，必须先于在设置屏障之后发起的内存访问之前完成，确保内存访问按程序的顺序完成。x86架构中对硬件进行操作的汇编语言指令是“串行的”，也具有内存屏障的作用．如：对I/O端口进行操作的所有指令、带lock前缀的指令以及写控制寄存器、系统寄存器或调试寄存器的所有指令。

linux内核提供的屏蔽函数有: mb, rmb, wmb及对应的smp_mb,smp_rmb,smp_wmb. 这些函数的实现是架构相关的.

 

**6) likely, unlikely** (from: [include/linux/compiler.h](http://lxr.linux.no/linux+*/include/linux/compiler.h#L107))

这是调用gcc的内嵌函数__builtin_expect,用来比较值. likely(x)是指x=1时做某事, unlikely(x)指若x=1时不做某做.常用来与某个互斥变量比较.

 

**7）嵌入汇编(内嵌汇编）**

嵌入汇编的基本格式

```asm
__asm__　__volatile__(“汇编语句“ 
	：输出寄存器output
	：输入寄存器input
	：会被修改的寄存器clobber）；
	__asm__或asm 用来声明一个内联汇编表达式。
	__volatile__或volatile是可选的，用来向GCC 声明不允许对该内联汇编优化。
```

  寄存器修饰符规定了各种*限定符*， 其中"+m"限定指向一个可读写的内存单元即操作数可以输入输出，"Ir"指定必须是一个立即数，或者是一个寄存器变量。

  Clobber/Modify域存在"memory"，那么GCC会保证在此内联汇编之前，如果某个内存的内容被装入了寄存器，那么在这个内联汇编之后，如果需要使用这个内存处的内容，就会直接到这个内存处重新读取，而不是使用被存放在寄存器中的拷贝。

 

​    在主流的Linux内核中包含了几乎所有现代的操作系统具有的同步机制，下面文章只研究其中几种同步机制的实现。

## 1 原子运算符（原子量）的实现

  Linux 中最简单的同步方法就是原子操作。原子运算符的每个函数都是原子操作。

n 原子量的类型是atomic_t。 

n 原子量的函数用来操作整数或位。 

n 原子量常实现为计数器。 

### 1)原子量实现的架构相关性

| 架构名称 | 关键宏或指令(内存屏蔽 | 说明                                                         |      |
| -------- | --------------------- | ------------------------------------------------------------ | ---- |
| x86      | LOCK＿PREFIX          | 此宏指向x86锁内存总线指令lock                                |      |
| alpha    | ldl_l/stl_c           | ldl_:l Load Sign Extended Longword Locked   stl_c: Store Longword Conditional |      |
| arm      | ldrex/strex           | Load and Store Register Exclusive                            |      |

表4 各架构下的原子量实现关键指令

 

示例：x86构架的LOCK_PREFIX实现分析

from: [arch/x86/include/asm/alternative.h, line 30](http://localhost/lxr/http/source/arch/x86/include/asm/alternative.h#L30)

```c
#ifdef CONFIG_SMP
#define LOCK_PREFIX \
                ".section .smp_locks,\"a\"\n"   \
                _ASM_ALIGN "\n"                 \
                _ASM_PTR "661f\n" /* address */ \
                ".previous\n"                   \
                "661:\n\tlock; "

#else /* ! CONFIG_SMP */
#define LOCK_PREFIX ""
#endif
```



展开后变成：

```assembly
.section .smp_locks,"a"
.align 4
.long 661f
.previous
661:
	lock;
```

代码说明：[3]

  这段代码汇编后，在 .text 段生成一条 lock 指令前缀 0xf0，在 .smp_locks 段生成四个字节的 lock 前缀的地址，链接的时候，所有的 .smp_locks 段合并起来，形成一个
 所有 lock 指令地址的数组，这样统计 .smp_locks 段就能知道代码里有多少个加锁的
 指令被生成，猜测是为了调试目的。

​    在IA-32多处理器环境中，声明LOCK，确保了处理器对于共享内存的独占式访问。声明LOCK可能会导致堵塞(locking)。lock后面的指令将会按序进行.

  The LOCK_PREFIX macro defined here replaces the LOCK and

 LOCK_PREFIX macros used everywhere in the source tree.

  The LOCK prefix invokes a locked (atomic) read-modify-write operation when modifying a memory operand. 

 

### 2)原子量类型atomic_t定义

/include/linux/types.h:209 lines

```C
typedef struct {
	volatile int counter;	
} atomic_t;

#ifdef CONFIG_64BIT
typedef struct {
	volatile long counter;
} atomic64_t;
#endif
```

说明：64位使用的类型是long,32位使用的类型是int. 



### 3)原子量操作函数

/arch/x86/include/asm/atomic_32.h

/arch/x86/include/asm/atomic_64.h

| 宏或函数名                                                   | 说明             |
| ------------------------------------------------------------ | ---------------- |
| ATOMIC_INIT(i)                                               | 初始化原子量宏   |
| atomic_read(v)                                               | 读取一个原子量宏 |
| atomic_set(v, i)                                             | 设置一个原子量宏 |
| atomic_add(int i, atomic_t *v)                               | 加法操作         |
| atomic_sub                                                   | 减法操作         |
| atomic_sub_and_test                                          | 相减并测试       |
| atomic_inc                                                   | 计数加1          |
| atomic_dec                                                   | 计数减1          |
| atomic_dec_and_test                                          | 计数减1并测试    |
| atomic_inc_and_test                                          | 计数加1并测试    |
| atomic_add_negative                                          |                  |
| atomic_add_return                                            | 加法操作并返回   |
| atomic_sub_return                                            | 减法操作并返回   |
| #define atomic_cmpxchg(v, old,  new)  <BR>(cmpxchg(&((v)->counter), (old), (new))) | 宏               |
| #define atomic_xchg(v, new)  (xchg(&((v)->counter), (new)))  | 宏               |
| atomic_add_unless                                            |                  |
| #define atomic_inc_not_zero(v)  atomic_add_unless((v), 1, 0) | 宏               |
| #define  atomic_inc_return(v)   (atomic_add_return(1, v))    | 宏               |
| #define  atomic_dec_return(v) (atomic_sub_return(1,  v))     | 宏               |
| `#define  atomic_clear_mask(mask, addr)\    asm volatile(LOCK_PREFIX  "andl %0,%1"      \ : :  "r" (~(mask)), "m" (*(addr)) : "memory")  ` | 宏               |
| `#define atomic_set_mask(mask,  addr)  \    asm volatile(LOCK_PREFIX  "orl %0,%1"       \  : : "r" (mask), "m" (*(addr)) :  "memory")  ` | 宏               |
| ...                                                          |                  |

 

### 4)原子量加法操作函数实现分析

**示例：原子量加法函数atomic_add实现分析**

```c
/**
 * atomic_add - add integer to atomic variable 传入一个整数给原子量用来相加
 * @i: integer value to add	用来相加的整数
 * @v: pointer of type atomic_t 原子量的指针
 *
 * Atomically adds @i to @v.
 */
//x86架构上32位机的实现
static inline void atomic_add(int i, atomic_t *v)
{	
	asm volatile(LOCK_PREFIX "addl %1,%0"
		     : "+m" (v->counter)
		     : "ir" (i));
}
//x86架构上64位机的实现
static inline void atomic_add(int i, atomic_t *v)
{
	asm volatile(LOCK_PREFIX "addl %1,%0"
		     : "=m" (v->counter)	//输出为v->counter
		     : "ir" (i), "m" (v->counter));	//2个输入来自于传入参数i,v
}
```

代码分析:

上面原子操作加法的实现略有不同，32机的输出寄存器标识"+m",输入只有一个参数,含义是参数i先从内存中读取到寄存器,+m说明v即是输入操作数也是输出操作数; 而64机的输出寄存器标识"=m",输入用了二个寄存器; 这两种实现比较起来只是64位多使用了一个输入寄存器用来保存v,可能计算会快些,但整体上来说并没多大区别,可以认为两种机器下可以互换.

 

## 2自旋锁spinlock

一个自旋锁就是一个互斥设备，它只能有两个值："锁定"和"解锁"。如果锁可用，则"锁定"位被设置，而代码继续进入临界区；相反，如果锁被其他进程争 用，则代码进入忙循环并重复检查这个锁，直到锁可用为止。这个循环就是自旋锁的"自旋"。自旋锁最多只能被一个可执行的线程持有。如果一个执行线程试图获 得一个被争用的自旋锁，那么该线程就会一直进行忙循环-旋转-等待锁重新可用。注意，同一个锁可以用在多个位置。缺点：一个被争用的自旋锁使得请求它的线 程在等待锁重新可用时自旋(特别浪费处理器时间)。所以，自旋锁不应该被长时间持有。当然，可以采用另外的方式处理对锁的争用：让请求线程睡眠，直到锁重 新可用时在唤醒它。但是，这里有两次明显的上下文切换，被阻塞的线程要换入或换出。因此，持有自旋锁的时间最好小于完成两次上下文切换的耗时。

### 1)自旋锁spinlock_t类型定义

from: /include/linux/spinlock_types.h

**定义链**: spinlock_t--> raw_spinlock_t--> unsigned int slock;

```c
typedef struct {
	raw_spinlock_t raw_lock;
#ifdef CONFIG_GENERIC_LOCKBREAK
	unsigned int break_lock;
#endif
#ifdef CONFIG_DEBUG_SPINLOCK
	unsigned int magic, owner_CPU;
	void *owner;
#endif
#ifdef CONFIG_DEBUG_LOCK_ALLOC
	struct lockdep_map dep_map;
#endif
} spinlock_t;
```



声明于 /arch/x86/include/asm/spinlock_types.h

```c
typedef struct raw_spinlock {
	unsigned int slock;	//初始化时为0
} raw_spinlock_t;
```



### 2)自旋锁操作函数

/include/linux/spinlock.h - generic spinlock/rwlock declarations

| 函数声明function  prototype | 用途description                                              |
| --------------------------- | ------------------------------------------------------------ |
| `DEFINE_SPINLOCK`           | 声明一个自旋锁                                               |
| `spin_lock_init(lock) `     | 将锁置为初始未使用状态(值为 0)  实现流程：*(lock) = SPIN_LOCK_UNLOCKED; |
| spin_lock(lock)             | 加锁  实现流程：  x86实现ticket_spin_lock排队自旋锁  1)preempt_disable.  内核抢占处理   2)spin_acquire  禁止中断请求irq  3) [LOCK_CONTENDED ](http://localhost/lxr/http/ident?i=LOCK_CONTENDED) 自旋加锁操作 |
| spin_lock_irq               | 加锁  实现流程：  1)关闭中断;2)执行类似spin_lock             |
| spin_lock_irqsave           | 加锁  实现流程：  1)关闭中断并保存中断上下文;2)执行类似spin_lock |
| spin_lock_bh                | 加锁  实现流程：  1)关闭软件中断;2)执行类似spin_lock         |
| spin_unlock(lock)           | 解锁                                                         |
| spin_unlock_irq             | 解锁                                                         |
| spin_unlock_irqsave         | 解锁                                                         |
| spin_unlock_bh              | 解锁                                                         |

说明: 提供了四个加锁函数lock, 分别适用于一般情况, 中断请求irq, 中断请求并保存irqsave, 底部下半部buttom half—bh.

 

**自旋锁算法实现原理:**

```c
do{
	b=1;		
	while(b){
		lock(bus);	//锁内存总线
		b = test_and_set(&lock);	//测试变量lock,此句不断执行,直至b可用
		unlock(bus);	//解锁
	}
	临界区处理 
}while(1)
```



### 3)函数实现

**3.1)** **初始化锁**

**流程**： spin_lock_init（lock)－＞ SPIN_LOCK_UNLOCKED－＞__SPIN_LOCK_UNLOCKED =0**伪码**： 依个初始化lock的成员变量。

源码:

```c
# define spin_lock_init(lock)					\
	do { *(lock) = SPIN_LOCK_UNLOCKED; } while (0)
#define SPIN_LOCK_UNLOCKED	__SPIN_LOCK_UNLOCKED(old_style_spin_init)
# define __SPIN_LOCK_UNLOCKED(lockname) \
	(spinlock_t)	{	.raw_lock = __RAW_SPIN_LOCK_UNLOCKED,	\
				SPIN_DEP_MAP_INIT(lockname) }
#define __RAW_SPIN_LOCK_UNLOCKED	{ 0 }
```



**3.2)** **加锁**

说明: 只用在SMP,UP系统中此函数不起作用.

流程： spin_lock－＞ ＿spin_lock

伪码：

  preempt_disable：内核可抢占处理；

  spin_acquire：锁请求。  

  [LOCK_CONTENDED：](http://localhost/lxr/http/ident?i=LOCK_CONTENDED)

​       检查内存中lock数据是否为真，是，则资源被占用，不能获取，CPU不断自旋检查该数据直至可用为止；否，获得资源。

源码: kernel/spinlock.c

```c
#define spin_lock(lock)			_spin_lock(lock)
179 void __lockfunc _spin_lock(spinlock_t *lock)
180 {
181         preempt_disable();
182         spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
183         LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
184 }
186 EXPORT_SYMBOL(_spin_lock);

```



a) preempt_disable()

说明: 内核可抢占,则抢占锁计数+1,然后优化屏蔽; 内核不可抢占,则为空函数.

```C
#ifdef CONFIG_PREEMPT
  30#define preempt_disable() \
  31do { \
  32        inc_preempt_count(); \
  33        barrier(); \
  34} while (0)

  83#else
  85#define preempt_disable()               do { } while (0)
```

 

b) [spin_acquire](http://localhost/lxr/http/ident?i=spin_acquire)

form: /include/linux/lockdep.h

说明: 在不可调试且试探锁状态时, 此函数为空

```
 420#ifdef CONFIG_DEBUG_LOCK_ALLOC    //是否可调试
 421# ifdef CONFIG_PROVE_LOCKING
422#  define spin_acquire(l, s, t, i)    lock_acquire(l, s, t, 0, 2, NULL, i)
 424# else
 425#  define spin_acquire(l, s, t, i)    lock_acquire(l, s, t, 0, 1, NULL, i)
 427# endif
 429#else
 430# define spin_acquire(l, s, t, i)               do { } while (0)
 432#endif
```

 

c) LOCK_CONTENDED

说明: 定义了锁统计为尝试检查锁状态,进行锁连接, 否则此宏执行真正的加锁函数lock(_lock)

```
 343#ifdef CONFIG_LOCK_STAT
 348#define LOCK_CONTENDED(_lock, try, lock)                        \
 349do {                                                            \
 350        if (!try(_lock)) {                                      \
 351                lock_contended(&(_lock)->dep_map, _RET_IP_);    \
 352                lock(_lock);                                    \
 353        }                                                       \
 354        lock_acquired(&(_lock)->dep_map, _RET_IP_);                     \
 355} while (0)
 356
 357#else
 362#define LOCK_CONTENDED(_lock, try, lock) \
 363        lock(_lock)
```

 

d)真正的加锁函数 (属于原子操作)

实现链:

raw_spin_trylock -->[_raw_spin_trylock -->](http://localhost/lxr/http/ident?i=_raw_spin_trylock)__raw_spin_trylock  

raw_spin_lock -->_raw_spin_lock -->__raw_spin_lock

示例1: x86架构下的加锁[__ticket_spin_lock](http://localhost/lxr/http/ident?i=__ticket_spin_trylock)    /arch/x86/include/asm/spinlock.h

原理:  [6]
lock->slock初始为0,未上锁状态. x86中spinlock用排队自旋锁实现,保存申请顺序来解决不公平问题. slock由next和owner组成, 其中next表示申请序号,owner表示申请已否标记. 当cpu不超过255时,slock(16bit)=高8位 next + 低8位owner; 否则next和owner都是16bit. 当next和owner均为0时,锁无人使用. 内核执行线程申请自旋锁时，原子地将 Next 域加 1，并将原值返回作为自己的票据序号。如果返回的票据序号等于申请时的 Owner 值，说明自旋锁处于未使用状态，则直接获得锁；否则，该线程忙等待检查 Owner 域是否等于自己持有的票据序号，一旦相等，则表明锁轮到自己获取。线程释放锁时，原子地将 Owner 域加 1 即可，下一个线程将会发现这一变化，从忙等待状态中退出。

```
  58#if (NR_CPUS < 256)        
  59#define TICKET_SHIFT 8
  60
   61static __always_inline void __ticket_spin_lock(raw_spinlock_t *lock)
  62{
  63        short inc = 0x0100;
  64
  65        asm volatile (
  66                LOCK_PREFIX "xaddw %w0, %1\n"
  67                "1:\t"
  68                "cmpb %h0, %b0\n\t"
  69                "je 2f\n\t"
  70                "rep ; nop\n\t"
  71                "movb %1, %b0\n\t"
  72                /* don't need lfence here, because loads are in-order */
  73                "jmp 1b\n"
  74                "2:"
  75                : "+Q" (inc), "+m" (lock->slock)
  76                :
  77                : "memory", "cc");
  78}
 106#else
 107#define TICKET_SHIFT 16
 108
 109static __always_inline void __ticket_spin_lock(raw_spinlock_t *lock)
 110{
 111        int inc = 0x00010000;
 112        int tmp;
 113
 114        asm volatile(LOCK_PREFIX "xaddl %0, %1\n"
 115                     "movzwl %w0, %2\n\t"
 116                     "shrl $16, %0\n\t"
 117                     "1:\t"
 118                     "cmpl %0, %2\n\t"
 119                     "je 2f\n\t"
 120                     "rep ; nop\n\t"
 121                     "movzwl %1, %2\n\t"
 122                     /* don't need lfence here, because loads are in-order */
 123                     "jmp 1b\n"
 124                     "2:"
 125                     : "+r" (inc), "+m" (lock->slock), "=&r" (tmp)
 126                     :
 127                     : "memory", "cc");
 128}
```

代码分析: ([NR_CPUS](http://lxr.linux.no/linux+*/+code=NR_CPUS) < 256)

​    xaddw 汇编指令将 slock 和 inc 的值[交换](http://cisco.chinaitlab.com/List_7.html)，然后把这两个值相加后的和存到 slock 中。也就是说，该指令执行完毕后，inc 存有原来的 slock 值作为票据序号，而 slock 的 Next 域被加 1。

   comb 比较 inc 变量的高位和低位字节是否相等，如果相等，表明锁处于未使用状态，直接跳转到标签 2 的位置退出函数。

   如果锁处于使用状态，则不停地将当前的 slock 的 Owner 域复制到 inc 的低字节处(movb 指令)，然后重复1步骤。不过此时 inc 变量的高位和低位字节相等表明轮到自己获取了自旋锁。

 

示例2: arm架构下加锁的实现[__raw_spin_lock](http://lxr.linux.no/linux+*/+code=__raw_spin_lock) /arch/arm/include/asm/spinlock.h

```
  26static inline void __raw_spin_lock(raw_spinlock_t *lock)
  27{
  28        unsigned long tmp;
  29
  30        __asm__ __volatile__(
  31"1:     ldrex   %0, [%1]\n"
  32"       teq     %0, #0\n"
  33#ifdef CONFIG_CPU_32v6K
  34"       wfene\n"
  35#endif
  36"       strexeq %0, %2, [%1]\n"
  37"       teqeq   %0, #0\n"
  38"       bne     1b"
  39        : "=&r" (tmp)
  40        : "r" (&lock->lock), "r" (1)
  41        : "cc");
  42
  43        smp_mb();
  44}
```

代码分析:

加锁过程中判断lock->slock是否为0,不是,则自旋等待,直至锁状态为0,则加锁,并将锁状态+1.



## 3 读/写锁

### 1)读写锁rwlock_t类型定义

from: /include/linux/spinlock_types.h

**定义链**: rwlock_t--> raw_rwlock_t--> unsigned int lock;

```c
typedef struct {
	raw_rwlock_t raw_lock;
#ifdef CONFIG_GENERIC_LOCKBREAK
	unsigned int break_lock;
#endif
#ifdef CONFIG_DEBUG_SPINLOCK
	unsigned int magic, owner_CPU;
	void *owner;
#endif
#ifdef CONFIG_DEBUG_LOCK_ALLOC
	struct lockdep_map dep_map;
#endif
} rwlock_t;
```



声明于 /arch/x86/include/asm/spinlock_types.h

```c
typedef struct {
  unsigned int lock;
} raw_rwlock_t;
```



### 2)读写锁操作函数 

| 函数声明function  prototype | 用途description                          |      |
| --------------------------- | ---------------------------------------- | ---- |
| `rwlock_init(lock)   `      | init                                     |      |
| `write_lock   `             | `critical section -- can read and write` |      |
| read_lock                   | `critical section -- can read only`      |      |
| write_unlock                | unlock                                   |      |
| read_unlock                 | unlock                                   |      |

 

## 4 内核信号量

Linux中信号量是一种睡眠锁。

n 可以同时允许任意数量的锁持有者

n 信号量支持两个原子操作P() 和V()

### 1)信号量semaphore类型定义

from: /include/linux/semaphore.h

```c
//linux old version
struct semaphore {
	atomic_t count;
	int sleepers;
	wait_queue_head_t wait;
}

//linux 2.6.30
struct semaphore {
        spinlock_t              lock;	//初始时为__SPIN_LOCK_UNLOCKED
        unsigned int            count; //有多少个资源
        struct list_head        wait_list;
};
```





### 2)信号量操作函数

from: [kernel/semaphore.c](http://lxr.linux.no/linux+*/kernel/semaphore.c)

| 函数声明function  prototype | 用途description             |      |
| --------------------------- | --------------------------- | ---- |
| `sema_init`                 | 信号量初始化                |      |
| `down`                      | `acquire the semaphore, -1` |      |
| `up`                        | `release the semaphore, +1` |      |

 

### 3)信号量函数实现

**a) 信号量获取函数down**

伪码：

原理:

保存中断上下文iresave，看信号量是否可用，是，则获取；否，则保存上下文，循环睡眠等待，直至被焕醒。

```
实现链: down-->__down-->__down_common
  53void down(struct semaphore *sem)
  54{
  55        unsigned long flags;
  56
  57        spin_lock_irqsave(&sem->lock, flags);
  58        if (likely(sem->count > 0))
  59                sem->count--;
  60        else
  61                __down(sem);
  62        spin_unlock_irqrestore(&sem->lock, flags);
  63}
  64EXPORT_SYMBOL(down);
```

```
 236static noinline void __sched __down(struct semaphore *sem)
 237{
 238        __down_common(sem, TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
 239}
 
 204static inline int __sched __down_common(struct semaphore *sem, long state,
 205                                                                long timeout)
 206{
 207        struct task_struct *task = current;
 208        struct semaphore_waiter waiter;
 209
 210        list_add_tail(&waiter.list, &sem->wait_list);
 211        waiter.task = task;
 212        waiter.up = 0;
 213
 214        for (;;) {
 215                if (signal_pending_state(state, task))
 216                        goto interrupted;
 217                if (timeout <= 0)
 218                        goto timed_out;
 219                __set_task_state(task, state);
 220                spin_unlock_irq(&sem->lock);
 221                timeout = schedule_timeout(timeout);
 222                spin_lock_irq(&sem->lock);
 223                if (waiter.up)
 224                        return 0;
 225        }
 226
 227 timed_out:
 228        list_del(&waiter.list);
 229        return -ETIME;
 230
 231 interrupted:
 232        list_del(&waiter.list);
 233        return -EINTR;
 234}
 
```

 

**b)** **信号量释放函数up**

//up 释放信号量

```
 171/**
 172 * up - release the semaphore
 173 * @sem: the semaphore to release
 174 *
 175 * Release the semaphore.  Unlike mutexes, up() may be called from any
 176 * context and even by tasks which have never called down().
 177 */
 178void up(struct semaphore *sem)
 179{
 180        unsigned long flags;
 181
 182        spin_lock_irqsave(&sem->lock, flags);
 183        if (likely(list_empty(&sem->wait_list)))
 184                sem->count++;
 185        else
 186                __up(sem);
 187        spin_unlock_irqrestore(&sem->lock, flags);
 188}
 189EXPORT_SYMBOL(up);
```

 

# 四 各种同步机制比较分析

## 1 同步机制列表

| 同步机制名称           | 为什么出现                        | 实现原理                        | 锁粒度与可否嵌套 | 适用场景     | 内核文件定位(v2.6.30)                                        |
| ---------------------- | --------------------------------- | ------------------------------- | ---------------- | ------------ | ------------------------------------------------------------ |
| 中断位标志             | 为了屏蔽中断                      | 如x86中修改标志寄存器EF中IF标记 | 低粒度           | 屏蔽中断     | 无, 各架构提供相应指令,如x86中cli/sti                        |
| atomic                 | 对整数进行原子操作                | 锁内存总线,如x86中lock前缀指令  | 低粒度           | 操作整数和位 | [include/linux/types.h](http://lxr.linux.no/linux+*/include/linux/types.h#L192) |
| spinlock               | 用来SMP互斥操作                   |                                 | 不可嵌套         |              | [include/linux/spinlock_types.h](http://lxr.linux.no/linux+*/include/linux/spinlock_types.h#L32)  [include/linux/spinlock.h](http://lxr.linux.no/linux+*/include/linux/spinlock.h#L100)  [kernel/spinlock.c,](http://lxr.linux.no/linux+*/kernel/spinlock.c#L103) |
| rwlock                 | 为了减少等待,增加读操作机会       | 现在版本是读者优先              |                  | 频繁读数据   | [kernel/spinlock.c,](http://lxr.linux.no/linux+*/kernel/spinlock.c#L103) |
| semaphore              | 为了进程间同步等待                | 原子量+等待队列                 |                  |              | [include/linux/semaphore.h](http://lxr.linux.no/linux+*/include/linux/semaphore.h#L16)  [kernel/semaphore.c](http://lxr.linux.no/linux+*/kernel/semaphore.c) |
| rw_semaphore           | 读写信号量                        |                                 |                  |              | [include/linux/rwsem-spinlock.h](http://lxr.linux.no/linux+*/include/linux/rwsem-spinlock.h#L31)  [include/linux/rwsem.h](http://lxr.linux.no/linux+*/include/linux/rwsem.h#L17) |
| completion             | 类似semaphore                     |                                 |                  |              | [include/linux/completion.h](http://lxr.linux.no/linux+*/include/linux/completion.h#L25)  [kernel/sched.c](http://lxr.linux.no/linux+*/kernel/sched.c#L5336) |
| seqlock                | 类似排队自旋锁, v2.6加入          | 在spinlock基础上加入了排列顺序  |                  |              | [include/linux/seqlock.h](http://lxr.linux.no/linux+*/include/linux/seqlock.h) |
| mutex                  | 内核互斥锁                        |                                 |                  |              | [include/linux/mutex.h](http://lxr.linux.no/linux+*/include/linux/mutex.h#L48) |
| perCPU                 | CPU私有变量, 为了SMP同步支持      |                                 |                  |              | [include/linux/perCPU-defs.h](http://lxr.linux.no/linux+*/include/linux/percpu-defs.h#L36)  [include/linux/perCPU.h](http://lxr.linux.no/linux+*/include/linux/percpu.h)  [arch/???/include/asm/perCPU.h](http://lxr.linux.no/linux+*/arch/alpha/include/asm/percpu.h) |
| RCU: Read-Copy  Update | 类似读写锁,保护的是指针, v2.6加入 |                                 |                  | 读多写少     | [include/linux/rcupreempt.h](http://lxr.linux.no/linux+*/include/linux/rcupreempt.h#L67) |
| BKL                    | 大内核锁,锁代码                   | lock_kernel()  unlock_kernel()  | 粗粒度           |              | [include/linux/smp_lock.h](http://lxr.linux.no/linux+*/include/linux/smp_lock.h#L44)  lib/kernel_lock.c |

表 内核同步机制列表(全)



## 2 spinlock与semaphore比较

spinlock使用时若发现资源暂不可用，CPU要不断检测资源是否可用，操作效率较高，但CPU浪费可能严重。

semaphore使用时若发现资源暂不可用，则保存上下文irqsave,睡眠等待schedule_timeout.操作效率低了些，但资源可以多个使用，不花费太多CPU.

因此，得出两者的使用场景：

1）不允许睡眠的上下文要使用spinlock,允许睡眠的上下文可用semaphore,在中断上下文的竞争资源要使用spinlock;

2)临界区使用较长的建议使用semaphore，临界区使用较短的则可使用spinlock;

3)需要关中断的场合需要调用spinlock_irq或者spinlock_irqsave，不明确当前中断状态的地方需要调用spinlock_irqsave，否则调用spinlock_irq。一个资源既在中断上下文中访问，又在用户上下文中访问，那么需要关中断，如果仅仅在用户上下文中被访问，那么无需关中断。

 

## 3 其它 

**Semaphore与mutex**

这两者的结构体很相似，都有一个spinlock,一个等待队列。获取锁时的实现也类同。

 

**Spinlock与rwlock**

这两者的结构定义一样。

 

**内核态的同步机制与用户态的同步机制**

信号量,互斥锁,读写锁等即有内核态的函数,也有用户态的函数.这些函数的实现机制差不多的,只是内核态的函数要考虑到SMP和内核抢占时的处理.

# 五 结尾

本文通过从同步机制引入原因, 发展变化及典型实现的研究, 进一步加强了对内核的理解,为下一步的深入学习打下了良好基础. 由于时间和能力的限制, 本次没有对锁的粒度, 内存屏蔽（如何实现锁若干字节或某段地址范围的内存区域）进一步扩展, 希望下次能够理解得更充分。

 

# 参考文献

[1]   linux kernel source code v2.6.30

[2]   [M. Tim Jones](http://www.ibm.com/developerworks/cn/linux/l-linux-synchronization.html#author) linux同步方法培析 http://www.ibm.com/developerworks/cn/linux/l-linux-synchronization.html    2007年11月19日

[3]   LOCK_PREFIX http://blog.chinaunix.net/u/12325/showart_1999057.html

[4]   潘华 《Linux内核支持SMP并行机制的分析》 四川大学硕士学位论文 2005.5.1

[5]   徐晓磊 Linux可抢占内核的分析 计算机工程 2003.9

[6]   [林 昊翔](http://www.ibm.com/developerworks/cn/linux/l-cn-spinlock/index.html#author) Linux 内核的排队自旋锁 http://www.ibm.com/developerworks/cn/linux/l-cn-spinlock/index.html 2008年6月05日

[7]   白杨 多处理器环境和线程同步的高级话题 http://baiy.cn/

[8]   Jonathan Corbet <<linux device drivers 3rd edition>> Oreilly Press  2005.2