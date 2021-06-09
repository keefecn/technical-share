







| 序号 | 修改时间  | 修改内容 | 修改人 | 审稿人 |
| ---- | --------- | -------- | ------ | ------ |
| 1    | 2010-3-17 | 创建     | Keefe  | 同上   |
| 2    | 2016-5-10 | 规范文档 | 同上   |        |

 

 

 

----

# 1 文档结构

apr – apache portable runtime liberary

因此支持各种平台。

os/2: IBM的一种个人电脑，06年已停止销售和技术支持

netware: novell公司的网络操作系统，主要用于异种网络之间的互联。

macintosh(MAC): 苹果公司的个人电脑。

unix:     大型机，包括各个unix/linux分支。最重要的平台之一。

windows: 占垄断地位的个人电脑OS，最重要的平台之一。

other: include beos....

 

# 2 代码分析

**常用函数，宏**

APR_DECLARE     //APACHE 对外调用的API接口声明

函数变量宏命名规则：常以APR＿或apr_t作为函数，宏，变量的前缀。

_t表示是typedef的结构；

 

## 1）内存管理

所有的内存内存分配都使用了apr_pool, 高性能高扩展。

这种是不定长内存池结构，可对各种类型大小分配内存，基于malloc/free的调用。

代码位置：srclib/apr/include/, srclib/apr/memory

代码文件：apr_pools.*,  apr_allocator.*

基本结构：apr_pool_t, apr_allocator_t

 

apr_pool中主要有3个对象，allocator、pool、block。

pool从allocator申请内存，pool销毁的时候把内存归还 allocator，allocator销毁的时候把内存归还给系统，allocator有一个owner成员，是一个pool对象，allocator 的owner销毁的时候，allocator被销毁。在apr_pool中并无block这个单词出现，这里大家可以把从pool从申请的内存称为 block，使用apr_palloc申请block，block只能被申请，没有释放函数，只能等pool销毁的时候才能把内存归还给 allocator，用于allocator以后的pool再次申请。

示例：

```c
#include "apr_pools.h"
#include <stdio.h>
#include <new>  // new
 
int main()
  {
     apr_pool_t *root;
     apr_pool_initialize();//初始化全局分配子（allocator），并为它设置mutext，以用于多线程环境，初始化全局池，指定全局分配子的owner是全局池
     apr_pool_create(&root,NULL);//创建根池(默认父池是全局池)，根池生命期为进程生存期。分配子默认为全局分配子
       {
         apr_pool_t *child;
         apr_pool_create(&child,root);//创建子池，指定父池为root。分配子默认为父池分配子
         void *pBuff=apr_palloc(child,sizeof(int));//从子池分配内存
         int *pInt=new (pBuff)  int(5);//随便举例下基于已分配内存后，面向对象构造函数的调用。
         printf("pInt=%d\n",*pInt);
           {
             apr_pool_t *grandson;
             apr_pool_create(&grandson,root);
             void *pBuff2=apr_palloc(grandson,sizeof(int));
             int *pInt2=new (pBuff2)  int(15);
             printf("pInt2=%d\n",*pInt2);    
 
             apr_pool_destroy(grandson);
         }
         apr_pool_destroy(child);//释放子池，将内存归还给分配子
     }
     apr_pool_destroy(root);//释放父池，
     apr_pool_terminate();//释放全局池，释放全局allocator，将内存归还给系统
     return 1;
 }
```



## 2) 模块管理

开源世界最经典的模块加载方式。

 

 

## 3）高性能的网络服务器

 