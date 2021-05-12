| 序号 | 修改时间   | 修改内容                                                     | 修改人 | 审稿人 |
| ---- | ---------- | ------------------------------------------------------------ | ------ | ------ |
| 1    | 2011-01-17 | 创建                                                         | 吴启福 | 吴启福 |
| 2    | 2011-1-18  | 更新协同开发章节                                             | 同上   |        |
| 3    | 2011-01-21 | 增加其它章节~各种场景碰到的问题                              | 同上   |        |
| 4    | 2011-1-26  | 增加git原理章节                                              | 同上   |        |
| 5    | 2011-2-14  | 增加git日常使用中的恢复操作                                  | 同上   |        |
| 6    | 2011-3-4   | 调整文章结构                                                 | 同上   |        |
| 7    | 2012-4-23  | 更新中文乱码问题                                             | 同上   |        |
| 8    | 2016-10-14 | 增加git仓库托管章节                                          | 同上   |        |
| 9    | 2017-2-12  | 更新补充git分支管理章节。按照[《中文技术文档的写作规范》](https://github.com/ruanyf/document-style-guide)重新组织文章结构。 | 同上   |        |
| 10   | 2017-7-9   | 增加合并分支章节                                             | 同上   |        |
| 11   | 2017-9-3   | 增加gitbook章节                                              | 同上   |        |
| 12   | 2018-10-22 | 增加克隆指定分支、创建空分支                                 | 同上   |        |
| 13   | 2019-3-23  | 增加语义化的版本模式章节                                     | 同上   |        |
|      |            |                                                              |        |        |

 

 

 

 

# 目录

[目录... 1](#_Toc4226974)

[1    简介... 3](#_Toc4226975)

[2    安装配置篇... 3](#_Toc4226976)

[2.1    安装... 3](#_Toc4226977)

[2.2    开发者配置... 3](#_Toc4226978)

[2.2.1     SSHKEY验证... 3](#_Toc4226979)

[2.2.2     开发用户签名... 4](#_Toc4226980)

[2.3    中文环境配置... 4](#_Toc4226981)

[2.4    参数配置.git. 5](#_Toc4226982)

[3    入门篇... 7](#_Toc4226983)

[3.1    常用命令使用说明... 7](#_Toc4226984)

[3.2    正常的工作流程... 8](#_Toc4226985)

[3.3    分布式的工作流程... 9](#_Toc4226986)

[3.3.1     创建公共仓库/主干树... 9](#_Toc4226987)

[3.3.2     拷贝一个仓库... 9](#_Toc4226988)

[3.3.3     本地同步远程仓库流程... 10](#_Toc4226989)

[3.3.4     克隆指定分支... 10](#_Toc4226990)

[3.3.5     创建空分支... 10](#_Toc4226991)

[3.4    commit修改与合并... 11](#_Toc4226992)

[3.4.1     git reset：撤销commit修改... 11](#_Toc4226993)

[3.4.2     git rebase: 合并多个commit. 12](#_Toc4226994)

[3.4.3     git merge：合并分支... 13](#_Toc4226995)

[4    进阶篇... 14](#_Toc4226996)

[4.1    团队协同开发... 14](#_Toc4226997)

[4.1.1     账号权限管理... 14](#_Toc4226998)

[4.2    分支branch和tag管理... 15](#_Toc4226999)

[4.2.1     分支管理策略... 15](#_Toc4227000)

[4.2.2     分支管理实例... 17](#_Toc4227001)

[4.3    子模块... 17](#_Toc4227002)

[5    原理篇... 18](#_Toc4227003)

[5.1    CONFIGURATION MECHANISM配置信息git-config. 18](#_Toc4227004)

[5.2    IDENTIFIER TERMINOLOGY存储对象类型... 18](#_Toc4227005)

[5.3    SYMBOLIC IDENTIFIERS符号标签... 19](#_Toc4227006)

[5.4    本章参考... 19](#_Toc4227007)

[6    git仓库托管... 20](#_Toc4227008)

[6.1    仓库托管简介... 20](#_Toc4227009)

[6.1.1     filter-branch：全局修改分支历史纪录... 20](#_Toc4227010)

[6.2    git.oschina.net. 21](#_Toc4227011)

[6.2.1     项目用户权限... 21](#_Toc4227012)

[6.2.2     开源协同开发... 21](#_Toc4227013)

[7    FAQ.. 22](#_Toc4227014)

[7.1    git与svn集成... 22](#_Toc4227015)

[7.1.1     svn转化为git. 22](#_Toc4227016)

[7.1.2     git VS svn. 23](#_Toc4227017)

[7.2    中文乱码问题... 23](#_Toc4227018)

[7.3    远程git命令找不到... 23](#_Toc4227019)

[7.4    git svn Can't locate SVN/Core.pm.. 23](#_Toc4227020)

[8    gitbook. 24](#_Toc4227021)

[8.1    Getting started. 24](#_Toc4227022)

[参考资料... 24](#_Toc4227023)

[附录... 24](#_Toc4227024)

[语义化的版本模式... 24](#_Toc4227025)




# 1   简介

git 分布式版本管理软件。

gitk是git安装包中缺省的图形界面包。可以方便地用来查看历史日志，修改信息等。

# 2   安装配置篇

## 2.1   安装

Linux: 只要用yum，apt-get等安装即可，或是下载之后编译安装。
 Mac OS X: 从[这里](http://code.google.com/p/git-osx-installer/)下载并安装。
 Windows:先安装putty，然后从[这里](http://code.google.com/p/msysgit)下载并安装。

## 2.2   开发者配置

### 2.2.1 SSHKEY验证

git支持使用ssh路径。

git使用ssh tunnel来提交源码，这个加密通道可以避免源码的封包被拦截而截取。因此要先产生并上传ssh key到github，方便之後与服务器之间的通迅。


Mac OS X与Linux，只要输入ssh-keygen -t rsa并根据指示操作即可： 
```sh
[~/.ssh]$ ssh-keygen -t rsa
```
一路按缺省键盘，即可得到以下文件。其中id_rsa.pub是公钥，而id_rsa则是私钥，请妥善保存以免遺失，它们都存放于~/.ssh目录中。将公钥粘贴到你github帐号中的SSH Public Keys的位置。注意小心不要复制到空格。

Windows，执行git-bash并输入：
```sh
ssh-keygen -C “username@email.com” -t rsa
```

// 参考脚本
```sh
$ ssh-keygen -t rsa
$ cat .ssh/id_rsa.pub | ssh $user@$host -p [port] "cat - >>.ssh/authorized_keys"
```


**特别说明**：windows环境使用git bash需要.ssh目录权限755。

 

### 2.2.2 开发用户签名
```sh
$ git config –-list
qfwu@is13084905-0273:~/git$ git config --list
denny.wuqifu@3g.net.cn=qfwu
user.email=wuqifu@3g.net.cn
user.name=denny
 
//设置用户名与邮箱
$ git config --global user.name "Scott Chacon"
$ git config --global user.email "schacon@gmail.com"
```


执行了上面的命令后,会在你的主目录(home directory)建立一个叫 *~/.gitconfig* 的文件. 内容一般像下面这样:
```ini
[user]
    name = Scott Chacon
    email = schacon@gmail.com
```


## 2.3   中文环境配置

1) Git Bash窗口ls正常显示中文

在$GitHome\etc\git-completion.bash文件中添加：
`alias ls='ls --show-control-chars --color=auto'`


2) Git Bash窗口正常输入中文

修改在$GitHome\etc\inputrc文件中的两项配置：
```sh
set output-meta on
set convert-meta off
```

3 ) Git-log正常显示中文

在$GitHome\etc\profile文件中添加：
```sh
export LESSCHARSET=utf-8
```


4) Git-gui正常显示中文

在$GitHome \etc\gitconfig文件中修改或添加如下配置：
```ini
[gui]
encoding = utf-8
[i18n]
commitencoding = GB2312
;如果没有这一条，虽然我们在本地用$ git log看自己的中文修订没问题，但a)我们的log推到服务器后会变成乱码；b)别人在Linux下推的中文log我们pull过来之后看起来也是乱 码。这是因为，我们的commit log会被先存放在项目的.git/COMMIT_EDITMSG文件中；在中文Windows里，新建文件用的是GB2312的编码；但是Git不知 道，当成默认的utf-8的送出去了，所以就乱码了。有了这条之后，Git会先将其转换成utf-8，再发出去，于是就没问题了。
[core]
quotepath = false
```
作用：没有这一条，$git status输出中文会显示为UNICODE编码。


**特别说明**：如果要上传文件名为中文的文件，最好下载git2.0以上的版本，采用utf-8编码路径，传输到远程也不会乱码，也不用设置.gitconfig文件里的gui/ pathnameencoding/commit的编码。


## 2.4   参数配置.git

**配置文件优先级**：.git/config > .gitconfig > /etc/gitconfig

**忽略文件的优先级**：.git/info/exclude > .git/.gitignore > 全局~/.gitignore


```shE:\SOURCE\GIT\165\YYUSMODEL\.GIT
│ COMMIT_EDITMSG
│ config    //全局配置文件
│ description
│ HEAD    //当前仓库的分支路径
│ index
│ packed-refs
├─hooks
│   applypatch-msg.sample
│   commit-msg.sample
│   post-commit.sample
│   post-receive.sample
│   post-update.sample
│   pre-applypatch.sample
│   pre-commit.sample
│   pre-rebase.sample
│    prepare-commit-msg.sample
│   update.sample
├─info
│   exclude
│   
├─logs
│ │ HEAD
│ └─refs
│   └─heads
│       master
├─objects
│ ├─0e
│ │   7ae0a10b0c2be6a664b20e38ec0a332e3e7ae7
│ ├─info
│ └─pack
│     pack-31c5c96a4af178beb7b50c1b3fc99677f3d76840.idx
│     pack-31c5c96a4af178beb7b50c1b3fc99677f3d76840.pack
└─refs
  ├─heads
  │   master
  ├─remotes
  │ └─origin
  │     HEAD
  └─tags
```
*说明：上图为.git的目录结构。HEAD文件为当前目录树的分支路径，如果删除HEAD所指向的链接（一般缺省为：refs/heads/master），那么会放弃本次编辑，**git pull**不会导致合并，会全部更新远程服务器的版本。*

 

| 文件目录名  | 用途                                                         |
| ----------- | ------------------------------------------------------------ |
| branches/   | 不同平台不一定存在。功能类似objects。                        |
| hooks/      | 自定义的git命令触发的勾子函数                                |
| info/       | 包含文件info/exclude~本仓库需要忽略的文件，优先级最高。      |
| logs/       | 文件refs/HEAD,存储本地git操作日志                            |
| objects/    | 按标签名的二级地址存放本次标签更改过的数据。                 |
| refs/       | 包括三个子目录heads、remotes和tags。heads路径下存储branch文件。一个branch一个文件，文件内容存储标签数据。 |
| config      | 配置信息，如远程仓库地址、分支信息。git clone时会自动配置，也可手动修改。 |
| description | 描述信息，暂没用。                                           |
| FETCH_HEAD  | 当前获取到的远程仓库标签                                     |
| ORIG_HEAD   | 本地仓库标签。                                               |
| index       | 二进制索引数据。                                             |
| HEAD        | 当前的标签路径                                               |
| packed-refs | 所有tags/branch的标签信息。                                  |

说明：1. 标签是40位长度的SHA-1值。用来唯一定位commit（提交）的序列，也可称为commit对象的KEY值。
2. FETCH_HEAD与ORIG_HEAD的标签数据不一致，即可说明有修改。

 

远程端remote名称缺省为origin，即本地clone的源端。

本地分支的名字缺省为master.

所以从本地更新到远程使用: $git pull origin master

使用git remote add添加远程服务器端。

usage: git remote add [<options>] <name> <url>

 denny@denny-ubuntu:~/data/bak-7z$ cat ~/.gitconfig 

```ini
[user]
  name = Denny Wu
  email = wuqifu@gmail.com
[denny]
  wu = denny@lenovo.desktop
[core]
  quotepath = false
  excludesfile = ~/.gitignore_global
[gui]
  encoding = utf-8
[i18n]
  commitEncoding = utf-8
[svn]
  pathnameencoding = utf-8
[credential]
  #helper = cache --timeout 3600
  #helper = store
[push]
    default = simple
```



# 3   入门篇

## 3.1   常用命令使用说明
```sh
usage: git [--version] [--exec-path[=GIT_EXEC_PATH]] [-p|--paginate|--no-pager] [--bare] [--git-dir=GIT_DIR] [--work-tree=GIT_WORK_TREE] [--help] COMMAND [ARGS]
 
The most commonly used git commands are:
  add    Add file contents to the index
  bisect   Find the change that introduced a bug by binary search
  branch   List, create, or delete branches
  checkout  Checkout and switch to a branch
  clone   Clone a repository into a new directory
  commit   Record changes to the repository
  diff    Show changes between commits, commit and working tree, etc
  fetch   Download objects and refs from another repository
  grep    Print lines matching a pattern
  init    Create an empty git repository or reinitialize an existing one
  log    Show commit logs
  merge   Join two or more development histories together
  mv     Move or rename a file, a directory, or a symlink
  pull    Fetch from and merge with another repository or a local branch
  push    Update remote refs along with associated objects
  rebase   Forward-port local commits to the updated upstream head
  reset   Reset current HEAD to the specified state
  rm     Remove files from the working tree and from the index
  show    Show various types of objects
  status   Show the working tree status
  tag    Create, list, delete or verify a tag object signed with GPG
```

 1)    撤消操作

```sh
# 撤消当前所有操作，恢复上次状态
$git reset --hard HEAD

# 恢复某个文件hello.rb
$git checkout hello.rb

# 撤消上次版本
$git revert HEAD
```


2)    与远程同步
```sh
# 将本地的git档案与github(远程)上的同步
git push

# 将github(远程)的git档案与本地的同步(即更新本地端的repo)
git pull

# 例如,pull指令其实包含了fetch(將变更复制回來)以及merge(合并)操作
git pull git:**//**github.com**/**tom**/**test.git
```


3)    分支使用 

版本控制系統的branch功能也很有意思，若同时修改bug，又要加入新功能，可以fork出一个branch：一个专门修bug，一个专门加入新功能，等到稳定后再merge合并
```sh
git branch bug_fix  # 建立branch，名为bug_fix
git checkout bug_fix  # 切换到bug_fix
git checkout master #切换到主要的repo
git merge bug_fix  #把bug_fix这个branch和现在的branch合并
 
# 若有remote的branch，想要查看并checkout
git branch -r  # 查看远程branch
git checkout -b bug_fix_local bug_fix_remote  # 把本地端切换为远程的bug_fix_remote branch并命名为bug_fix_local
```

## 3.2   正常的工作流程

常用命令：git  init/diff/add/rm/status/show/log/commit

1)  创建一个版本库
`git init`

2)  增加/删除文件

```sh
git add <modified files>
git rm <modified files>
```

3)  提交

```sh
# 使用commit将快照/索引中的内容提交到版本库中
git commit -m "msg"
# 也可以将git add与git commit用一个指令完成
git commit -a -m "msg"
```

4)   状态查看

```sh
git log  #可以查看每次commit的改变
git diff  #可以查看最近一次改变的內容，加上参数可以看其它的改变并互相比较
git show  #可以看某次的变更
# 若想知道目前工作树的状态，可以輸入
git status
```



## 3.3   [分布式的工作流程 ](http://gitbook.liuhui998.com/3_6.html)

### 3.3.1 创建公共仓库/主干树

创建一个空仓库，裸放的，不作开发，可为原始主干库，公共仓库
`$git --bare init --shared`

1)    创建一个开发仓库，文件信息放入.git目录，如示例仓库名proj.
```sh
$ cd {proj}
$ git init
```


2）使用克隆方式建立一个公共的裸仓库dst_proj
```sh
$ git clone --bare [src_proj] [dst_proj]
$ touch proj.git/git-daemon-export-ok //非必需，告诉系统这是个裸仓库
$ scp [dst_pro] user@host://xxx
```

### 3.3.2 拷贝一个仓库

可以使用SSH, HTTPS, GIT等各种网络协议连接到远程仓库。

仓库地址：[Protocol:]$user@$IP$workpath //若无协议头，则缺省SSH:
```sh
$git clone [user@ubuntu.unix-center.net/home/p/d/xxxxx](mailto:user@ubuntu.unix-center.net/home/p/d/xxxxx)
$git clone [user@ubuntu.unix-center.net/~/xxxxx](mailto:user@ubuntu.unix-center.net/~/xxxxx)
$git clone ssh://qfwu@61.145.124.165:37856/home/qfwu/yyusmodel --upload-pack=~/app/bin/git-upload-pac
$git clone [git@github.com:dennycn/script.git](mailto:git@github.com:dennycn/script.git)
$git clone https://github.com/dennycn/script.git 
```


1)    git协议导出仓库

需启动git-daemon. 命令如下：

`$ git-daemon --reuseaddr –port=9418 --base-path=/home/git `

 

2)    http协议导出仓库

你需要把新建的"裸仓库"放到Web服务器的可访问目录里, 同时做一些调整,以便让web客户端获得它们所需的额外信息.
```sh
$ mv proj.git /home/you/public_html/proj.git
$ cd proj.git
$ git --bare update-server-info
$ chmod a+x hooks/post-update
```

### 3.3.3 本地同步远程仓库流程

1)    本地修改并提交到本地

// git add增加文件，git status查看是否更改

$git commit –m “add localhost”

 

2)    本地修改后提交到远程

//origin 为源端名name，master为本地分支名branch

\#git push origin master

$git push xxxx@xxxx:

 

3)    更新远程仓库

$git pull

$git pull xxx@xxxx [origin_master]

注：git pull = git fetch + git merge

### 3.3.4 克隆指定分支

`git clone -b [branch_name] [repo_url]`

### 3.3.5 创建空分支

有时候我们需要在GIT里面创建一个空分支，该分支不继承任何提交，没有父节点，完全是一个干净的分支，例如我们需要在某个分支里存放项目文档。

使用传统的git checkout命令创建的分支是有父节点的，意味着新branch包含了历史提交，所以我们无法直接使用该命令。

\# 查看远程所有分支，-a 

`git branch -a`

\# 创建一个名为docs的分支，并且该分支下有前一个分支下的所有文件。但无历史纪录

**法1：使用git checkout--orphan**
```sh
git checkout --orphan docs
git rm -rf .
```


**法2：使用 git symbolic-ref**
```sh
git symbolic-ref HEAD refs/heads/newbranch 
rm .git/index 
git clean -fdx 
 
# 此时空日志，需要 git add xxx; git commit -m 'xxx'; git push origin [branch]才有第一条commit日志
<do work> 
git add your files 
git commit -m 'Initial commit'
```

## 3.4   commit修改与合并

### 3.4.1 git reset：撤销commit修改
```sh
git-reset - Reset current HEAD to the specified state
usage: git reset [--mixed | --soft | --hard | --merge | --keep] [-q] [<commit>]
  or: git reset [-q] <tree-ish> [--] <paths>...
  or: git reset --patch [<tree-ish>] [--] [<paths>...]
 
  -q, --quiet      be quiet, only report errors
  --mixed        reset HEAD and index
  --soft        reset only HEAD
  --hard        reset HEAD, index and working tree
  --merge        reset HEAD, index and working tree
  --keep        reset HEAD but keep local changes
  -p, --patch      select hunks interactively
  -N, --intent-to-add  record only the fact that removed paths will be added later
 
//本地仓库撤销, 可以将本地的仓库回滚到上一次提交时的状态，`HEAD^`指的是上一次提交。`HEAD` ^[num]表示可撤销前num次提交。
$ git reset --hard HEAD^

// 完成撤销,同时将代码恢复到前一commit_id 对应的版本。
$ git reset --hard commit_id
// 完成Commit命令的撤销，但是不对代码修改进行撤销，可以直接通过git commit 重新提交对本地代码的修改。
$ git reset commit_id 
 
//远程仓库跟随本地仓库撤销，保持本地与远程的状态一致，即回滚。
$ git push origin [branch] -f
```


### 3.4.2 git rebase: 合并多个commit

**注意事项**：需要合并的commit只能是本地仓库的，不能已经push到服务器。

Your branch is ahead of 'origin/master' by 2 commits.

说明：一般git status上面提示的commit要大于等于2，-i指向的commit是不需要修改的，可以是最后一次push的commit，或者还未提交commit中的某个，合并只会影响到-i指向的commit之后的提交。-i指向的commit不能超过最后一次push之前的commit，否则会产生很多重复的commit log，而且仓库混乱（另外，合并项列单的第一个commit不能squash，会提示不是一个single reversion）。

 ![image-20191208223043376](E:\project\technical-share\media\sf_reuse\tools\tools_git_001.png)
```sh
git-rebase - Reapply commits on top of another base tip
git rebase [-i | --interactive] [options] [--exec <cmd>] [--onto <newbase>]
        [<upstream> [<branch>]]
git rebase [-i | --interactive] [options] [--exec <cmd>] [--onto <newbase>]
        --root [<branch>]
git rebase --continue | --skip | --abort | --edit-todo
```

示例：

`$ git rebase -i [branch|********]`

你可以直接进入某个分支的 rebase 也可以进入某次 commit 的 rebase，如果你是项将某些 commit 合并，那么建议使用 `$ git rebase -i `。

此外 rebase 还提供三个操作命令，分别是 `--continue`、`--absort` 和 `--skip`，这三个命令的意思分别是“继续”、“退出”和“跳过”。

 

合并执行顺序：

1). 设定不需要合并的commit起始值, `-i` 的参数是不需要合并的 commit 的 hash 值

git -i [hash_valus]

2). 得到一个指令文件，指令cmd可用全名，也可只用首字母。

[cmd] [hash] [commitlog]
* pick 的意思是要会保留这个 commit，缺省值，若无修改，最终会列出所有合并的commit作为新的commit
* squash 的意思是这个 commit 会被合并到前一个commit, 这说明保证至少有两个以上的commit（不包括-i指向的commit）才能进行这操作，否则会出现合并错误，可通过rebase --absort放弃本次合并操作。
* fixup 提交，类似squash，但放弃commit log.
* edit：
* drop: 不提交，放弃本次编辑。

​                               

3). 提交修改

```sh
$git rebase --continue
$git push origin [branch] -f
```

4). 撤销修改 git rebase

`git rebase --abort`来撤销修改，回到没有开始操作合并之前的状态。

 

### 3.4.3 git merge：合并分支

有时我们并不需要分支太多的commit，只需保留最新一条。

**1. 直接合并(straight merge)：**

首先先到master分支，然后直接合并：

```sh
git checkout master　
git merge dev
```

 说明：注意没参数的情况下merge是快进式(Fast-forward)的，即Git将master分支的指针直接移到dev的最前方。

 

**2. 压合合并(squashed commits)：**

将一条分支上的若干个提交条目压合成一个提交条目，提交到另一条分支的末梢。

把dev分支上的所有提交压合成主分支上的一个提交，即压合提交：

```sh
git checkout master
git merge --squash dev
```

此时，dev上的所有提交已经合并到当前工作区并暂存，但还没有作为一个提交，可以像其他提交一样，把这个改动提交到版本库中：

`git commit –m “something from dev”`

说明：使用--squash参数，这样提交的commit只有一个parent，即原来的分支。

 

# 4    进阶篇

## 4.1   团队协同开发

### 4.1.1 账号权限管理

要求：团队里的每个人都对仓库有写权限，又不能给每个人在服务器上建立账户. 那么提供 SSH 连接就是唯一的选择了。

方法1： 是给每个人建立一个账户，直截了当但过于繁琐。反复的运行 adduser 并且给所有人设定临时密码可不是好玩的。  

方法2: 是在主机上建立一个 git 账户，让每个需要写权限的人发送一个 SSH 公钥，然后将其加入 git 账户的 ~/.ssh /authorized_keys 文件。这样一来，所有人都将通过 git 账户访问主机。这丝毫不会影响提交的数据——访问主机用的身份不会影响 commit的记录。  

方法3: 是让 SSH 服务器通过某个LDAP 服务，或者其他已经设定好的集中授权机制，来进行授权。只要每个人都能获得主机的 shell 访问权，任何可用的 SSH 授权机制都能达到相同效果。 

 

**方法2的详细步骤**

1)    产生公钥

`ssh-keygen -C "你的email地址" -t rsa `
该命令将生成一对非对称的公\私密钥，默认它们被存储在： 
 XP/2003用户：c:\Documents and Settings\登陆名\.ssh 
 Vista用户： c:\Users\登陆名\.ssh 

linux     :~/.ssh

 

2)    在linux服务器上将公钥加到git用户的authorized_keys文件中。

**类似工具：**使用Gitosis的多用户访问

在gitosis中, 有一个叫 authorized_keys 的文件，里面包括了所有授权可以访问仓库的用户的公钥(public key), 这样每个用户就可以直接使用'git'用户来推送(push)和拉(pull)代码.

[安装与配置Gitosis(英文)](http://www.urbanpuddle.com/articles/2008/07/11/installing-git-on-a-server-ubuntu-or-debian)

译者注1: [github.com](http://help.github.com/linux-key-setup/)就是采用这种方式来配置私有(仓库)访问.

译者注2: [Gitosis配置(中文)](http://progit.chunzi.me/zh/ch4-7.html)

 

## 4.2   分支branch和tag管理

版本号：x.x.x=主版本号.次版本号.发布序列。主版本号只用在重要架构级或功能大升级。

表格 1 branch和tag比较表

|              | 说明                                                         | 主要命令                                                     |
| ------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| tag  标签    | 组成为vx.x.x，完整的版本号，用来标识阶段性的发布版本（不再编辑的分支），相当于release-x.x.x | $ git tag  # 查看  $ git tag  -a [xxx]  # 打tag              |
| branch  分支 | 组成为x.x，其中含义两个固定分支master和devel，如果项目不是太复杂，devel分支将取代所有版本分支。  # 查看远程分支，查看本地不用-a  $ git branch -a  $ git push  origit [xxx]  # 推送分支到远程   $ git push origin :[xxx]  # 删除远程分支 | # 创建/删除分支  `$git checkout --orphan [空分支]`  $ git checkout -b [to] [from]  $ git branch -d [xxx]  # 切换/合并分支  $ git checkout [xxx]  $ git merge [to]  # 重命名分支  $ git branch -m [old] [new] |

备注：命令参数如-d/-D大小写不敏感。

 ![image-20191208223108973](E:\project\technical-share\media\sf_reuse\tools\tools_git_002.png)

图 2 git客户端里的revision graph

**说明**：最下面e35a6b9是仓库第一个commit的SHA-1值，黄色字体v1.0.0/v1.1.0是tag，蓝色字体master/develop是远程分支，红色字体distributed是本地当前分支。带有origin前缀的都是远程分支。理论上tag要一直保持在master分支里。

 

### 4.2.1 分支管理策略

| 分支名称          | 使用场合                                                     | 注意事项                                                     |
| ----------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 主分支  master    | 所有提供给用户使用的正式版本，都在这个主分支上发布。用来分布重大版本。 |                                                              |
| 开发分支  develop | 日常开发。  包括创建分支、切换分支和合并分支。               | $ git checkout -b develop master  $ git checkout master  $ git merge --no-ff develop |
| 临时性分支        | 用于应对一些特定目的的版本开发。如  * 功能（feature）分支~ feature-*  * 预发布（release）分支~ release-*  * 修补bug（fixbug）分支~ fixbug-* | feature/release从develop分支分出，fixbug从master分支分出。  临时性分支合并到develop分支后可删除。  release和fixbug分支合并到master后可打tag。 |

备注：tag需从master打，标识为vx.x.x，如v1.2.0

 

**1. 主分支Master**

首先，代码库应该有一个、且仅有一个主分支。所有提供给用户使用的正式版本，都在这个主分支上发布。

 

**2. 开发分支Develop**

主分支只用来分布重大版本，日常开发应该在另一条分支上完成。我们把开发用的分支，叫做Develop。这个分支可以用来生成代码的最新隔夜版本（nightly）。如果想正式对外发布，就在Master分支上，对Develop分支进行"合并"（merge）。（备注：被master合并分布后，也可以反向合并master或从其它分支获取修改，进行下一步的修改）
```sh
# 创建分支：Git创建Develop分支的命令
$ git checkout -b develop master
 
# 切换分支：将Develop分支发布到Master分支的命令
$ git checkout master
# 对Develop分支进行合并，缺省合并是快进式合并~即将master直接指向develop
# -no-ff参数会执行正常合并，在Master分支上生成一个新节点。推荐使用-no-ff，可以保持演进的清晰（被合并分支develop会多一个指向master某commit的节点）。
# 若develop的修改未提交到远程，就合并到本地master，那么合并后develop远程分支并不会出现修改部分，这样会造成develop与master并不同步，在进行develop开发前建议先同步远程master（会增加很多来自master的commit log）。develop开发前根据需要从不同的远程分支更新内容，develop本身的日志基本无意义。
$ git merge --no-ff develop
```

**3. 临时性分支**

临时性分支，用于应对一些特定目的的版本开发，开发合并后可以删除此分支。临时性分支主要有三种：

　　* 功能（feature）分支，为了开发某种特定功能，从develop分支分出。feature分支开发完需合并到develop。

　　* 预发布（release）分支，develop合并到master之前提供的测试分支，从develop分支分出。

　　* 修补bug（fixbug）分支，从Master分支上面分出来的。relaese/fixub分支开发完需合并进Master和Develop分支，合并到master后可以打tag。

示例1：修补bug分支fixbug-x流程（从master创建，合并到maste打tag，再合并到devel删除分支）。
```sh
# 创建分支fixbug-x
$ git checkout -b fixbug-x master
# 合并到master分支，并tag
$ git checkout master
$ git merge --no-ff master
$ git tag -a v1.2.2
 
# 合并到devel分支，并删除分支
$ git checkout devel
$ git merge --no-ff devel
$ git branch -d bugfix-x
```



### 4.2.2 分支管理实例

**1) 本地管理分支**

```sh
//create branch, branch_name default: local
$ git branch [branch_name]
// switch to branch
$git checkout [branch_name]
//merge branch，将branch_name合并到当前分支
$git merge [branch_name]
// delete branch
$git branch –D [branch_name]
```

**2)  分支协同开发**

a) 首先在本地产生branch, 工作过后，将本地branch合并到本地master.

b) git pull取其它成员的工作树到本地，如果有修改，将自动合并到本地master

c) git push将本地master分支更新到远程服务器。

 

## 4.3   子模块

http://gitbook.liuhui998.com/5_10.html

git submodule

 

# 5    原理篇

* 分布式版本管理。即每个节点即是客户端，也是服务端。也可成为别人的主干树，很适合阶梯式开发管理。
* Git 是一套内容寻址文件系统。从内部来看，Git 是简单的 key-value 数据存储。它允许插入任意类型的内容，并会返回一个键值，通过该键值可以在任何时候再取出该内容。

GIT API documentation

  [file:///usr/share/doc/git-doc/technical/api-index.html]()

$man git

## 5.1   CONFIGURATION MECHANISM配置信息git-config
```sh
    Starting from 0.99.9 (actually mid 0.99.8.GIT), .git/config file is used to hold per-repository configuration options. It
   is a simple text file modeled after .ini format familiar to some people. Here is an example:
     \# A '#' or ';' character indicates a comment.
     ; core variables
     [core]
         ; Don't trust file modes
         filemode = false
     ; user identity
     [user]
         name = "Junio C Hamano"
         email = "junkio@twinsun.com"
   Various commands read from the configuration file and adjust their operation accordingly.
```


## 5.2   IDENTIFIER TERMINOLOGY存储对象类型
```
   <object>            Indicates the object name for any type of object.
   <blob>            Indicates a blob object name.
   <tree>            Indicates a tree object name.        
   <commit>            Indicates a commit object name.        
   <tree-ish>            Indicates a tree, commit or tag object name. A command that takes a argument ultimately wants to operate on a <tree> object but            automatically dereferences <commit> and <tag> objects that point at a <tree>.
   <commit-ish>            Indicates a commit or tag object name. A command that takes a argument ultimately wants to operate on a <commit> object but            automatically dereferences <tag> objects that point at a <commit>.
   <type>
       Indicates that an object type is required. Currently one of: blob, tree, commit, or tag.
   <file>            Indicates a filename - almost always relative to the root of the tree structure GIT_INDEX_FILE describes. 
```


查看命令
```sh
denny@denny-laptop:~/git/unix-center.net/script$ git cat-file -p master^{tree}
040000 tree 39d1ef43324965901826ef8c9e8c0b098487938b    dos
040000 tree 3b47cd6738fdb3fac41b21f678f35b45c14061c7     perl
040000 tree c97f5c664245b841396e49256769f01039fd3ebe    php
040000 tree 5f4276de1d60a512d919a828e5835635414608c5   python_gap
```

## 5.3   SYMBOLIC IDENTIFIERS符号标签
```sh
Any git command accepting any <object> can also use the following symbolic notation:
    HEAD
      indicates the head of the current branch (i.e. the contents of $GIT_DIR/HEAD).
    <tag>
      a valid tag name (i.e. the contents of $GIT_DIR/refs/tags/<tag>).
    <head>
      a valid head name (i.e. the contents of $GIT_DIR/refs/heads/<head>).
    For a more complete list of ways to spell object names, see "SPECIFYING REVISIONS" section in git-rev-parse(1).
```


## 5.4   本章参考

[1].   http://progit.org/book/zh/ch9-2.html

 

# 6  git仓库托管

常见托管仓库：[oschina ](http://git.oschina.net/)[github](http://wwww.github.com) [repo.or.cz](http://repo.or.cz)

## 6.1   仓库托管简介

基本概念
* public: 公共仓库
* private: 私有仓库，github付费使用，oschina暂时提供免费1000个仓库。
* fork：克隆别的仓库到自己仓库
* pull requests: 分支合并请求

 

**支持的克隆路径：SSH/https，示例如下，**
* git clone git@git.oschina.net:dennycn/xxx.git
* git cone https://git.oschina.net/dennycn/xxx.git

 

### 6.1.1 filter-branch：全局修改分支历史纪录

**1)  开源前修改用户信息**

```sh
do_commit_filter()
{       # '=' seems 完全相同，通配符＊不起作用
   git filter-branch -f --commit-filter '
       if [ "${GIT_AUTHOR_NAME}" = denny ];
       then
         GIT_COMMITTER_NAME="Denny Wu";
         GIT_AUTHOR_NAME="Denny Wu";
         GIT_COMMITTER_EMAIL="wuqifu@gmail.com";
         GIT_AUTHOR_EMAIL="wuqifu@gmail.com";
          git commit-tree "$@";
       else
         git commit-tree "$@";
       fi' HEAD
}
 
do_env_filter()
{
  git filter-branch -f --env-filter '
   case "${GIT_AUTHOR_NAME} ${GIT_AUTHOR_EMAIL}" in
   *enny*)
   export GIT_AUTHOR_NAME="Denny Wu"
   export GIT_AUTHOR_EMAIL="wuqifu@gmail.com"
   ;;
   esac
   case "${GIT_COMMITTER_NAME}　${GIT_COMMITTER_EMAIL}" in
   *enny*)
   export GIT_COMMITTER_NAME="Denny Wu"
   export GIT_COMMITTER_EMAIL="wuqifu@gmail.com"
   ;;
   esac
   ' 
}
```


**2）删除历史纪录中某个文件**

```sh
# remove unnecessay file or directory， 如passwords.txt
git filter-branch --tree-filter 'rm -f passwords.txt' HEAD
```



## 6.2 gitlab本地搭建

gitlab是开源仓库，可以在本地搭建私有仓库。

```sh
[root@server1 ~]# yum install -y git
[root@server1 ~]# yum install gitlab-ce-11.2.0-ce.0.el7.x86_64.rpm -y   #安装gitlab
[root@server1 ~]# cd /etc/gitlab/
[root@server1 gitlab]# ls
gitlab.rb
[root@server1 gitlab]# vim gitlab.rb  #更新本地IP
  13 external_url 'http://172.25.76.1'

[root@server1 gitlab]# gitlab-ctl reconfigure 
```

在浏览器输入172.25.76.1，即可修改ROOT密码。



## 6.3 git.oschina.net

相对于github，oschina支持免费私有仓库。

### 项目用户权限

用户权限：管理者、开发者、报告者和观察者

* 管理者：所有权限
* 开发者：报告者权限 + 代码读写 
* 报告者：观察者权限 + 可提交问题issue
* 观察者：仅可查看issue.

 

### 开源协同开发

示例：git@github.com:looly/elasticsearch-definitive-guide-cn.git

开始我对Pull Request流程不熟悉，后来参考了[@numbbbbb](https://github.com/numbbbbb)的《The Swift Programming Language》协作流程，在此感谢。
1.     首先fork我的项目
2.     把fork过去的项目也就是你的项目clone到你的本地
3.     运行 git remote add looly git@github.com:looly/elasticsearch-definitive-guide-cn.git 把我的库添加为远端库
4.     运行 git pull looly master 拉取并合并到本地
5.     翻译内容
6.     commit后push到自己的库（git push origin master）
7.     登录Github在你首页可以看到一个 pull request 按钮，点击它，填写一些说明信息，然后提交即可。

1~3是初始化操作，执行一次即可。在翻译前必须执行第4步同步我的库（这样避免冲突），然后执行5~7既可。

 

## 本章参考

[1]: https://blog.csdn.net/zcx1203/article/details/90734055 "gitlab本地仓库搭建|Jenkins关联gitlab"



# 7    FAQ

## 7.1   git与svn集成

要先装软件git-svn

### 7.1.1 svn转化为git

http://rongjih.blog.163.com/blog/static/335744612010620105546475/

1)    本地svn先转化到本地git 

$ git svn clone file:///tmp/test-svn -T trunk -b branches -t tags

或 $ git svn clone file:///tmp/test-svn -s 

 

2)    获取SVN服务器的最新更新到转换后的Git仓库（这步通常在连续的转换过程中就没必要了）
 `$ git svn rebase`

 

3)    转换SVN仓库的svn:ignore属性到Git仓库的.gitignore文件
 `$ git svn create-ignore`

 

4)   转换SVN的标签为Git标签
```sh
   $ cp -Rf .git/refs/remotes/tags/* .git/refs/tags/
   $ rm -Rf .git/refs/remotes/tags
```

5)    转换SVN的分支为Git分支
```sh
 $ cp -Rf .git/refs/remotes/* .git/refs/heads/
 $ rm -Rf .git/refs/remotes
```

6)   最后把转换后的本地Git仓库推到公共的Git服务器
```sh
 $ git remote add origin [远程Git服务器地址]
 $ git push origin master --tags
```


### 7.1.2 git VS svn

**1)支持的传输协议**

svn:  http/https, svn(缺省端口9418)

git:  http/https, git(缺省端口9418), ssh, rsync 

$man git-clone  //可查看支持的URL格式

 

**2)缺省服务启动**

svn: $svnserver –d --listen-port /home/denny/svnrepos

git: $git-daemon --reuseaddr –port=9418 --base-path=/home/git 

 

**3)对比**

* 仓库管理：svn集中式管理, git分布式管理，可以多个中心。
* 权限管理：svn可设置目录级的权限，git都可读，只能设写限制。
* 应用范围：svn公司多项目开发一仓库，git单一开源软件仓库。
* 签出：svn允许部分签出，Git只能全部签出.

 

## 7.2   中文乱码问题

//TODO: 效果不明显
```sh
alias ls=’ls –show-control-chars –color=auto’
git config core.quotepath false
```


## 7.3   远程git命令找不到

//add to .git/config
```ini
[remote "origin"]
     fetch = +refs/heads/*:refs/remotes/origin/*
     url = ssh://qfwu@61.145.124.165:37856/~/git/yyusmodel
     uploadpack = ~/app/bin/git-upload-pack
     receivepack = ~/app/bin/git-receive-pack
```

## 7.4   git svn Can't locate SVN/Core.pm
```sh
$ cd ${SVN_SRC_PATH}
$ make swig-pl
$ make check-swig-pl
$ sudo make install-swig-pl
```


用PERL安装所需模块：
```perl
$ perl -MCPAN -e shell
cpan> install XXX:XXX
```


# 8    gitbook

项目地址：https://github.com/GitbookIO/gitbook 

GitBook is a command line tool (and Node.js library) for building beautiful books using **GitHub**/Git and Markdown (or AsciiDoc). Here is an example: [Learn Javascript](https://www.gitbook.com/book/GitBookIO/javascript).

 GitBook 分布式协作写书。



## 8.1   Getting started

GitBook can be used either on your computer for building local books or on GitBook.com for hosting them. To get started, check out [the installation instructions in the documentation](https://github.com/GitbookIO/gitbook/blob/master/docs/setup.md).

 

# 参考资料

[1].   Git中文手册http://gitbook.liuhui998.com/index.html

[2].   中文技术文档的写作规范 https://github.com/ruanyf/document-style-guide 

[3].   知乎--如何使用 GitHub？ https://www.zhihu.com/question/20070065 

[4].   码云平台帮助文档 V1.2 http://git.mydoc.io/?t=83146 

[5].   合并多个commit http://www.jianshu.com/p/964de879904a

[6].   Git分支管理策略 http://www.ruanyifeng.com/blog/2012/07/git.html 

[7].   Git配置管理 http://www.uml.org.cn/pzgl/201203084.asp 

[8].   github http://gooss.org/the-use-of-git-and-github-management-development/

 

 

# 附录

## 语义化的版本模式

可将工程分为项目project 和 产品 product。
* 项目级版本号：日期，如$project-2019.11.12
* 产品级版本号：major-minjor-patchlevel，其中偶数minjor表示稳定版本，奇数minjor表示不稳定分支。如$product-0.2.1

