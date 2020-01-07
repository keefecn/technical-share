| 序号 | 修改时间  | 修改内容                                   | 修改人 | 审稿人 |      |
| ---- | --------- | ------------------------------------------ | ------ | ------ | ---- |
| 1    | 2019-5-11 | 创建。从《网站架构设计》抽取相关章节成文。 | 吴启福 |        |      |
| 2    | 2019-12-12 | 更新nginx优化配置 | 同上 |        |      |
---







# 目录

[目录... 1](#_Toc25402125)

[1    简介... 2](#_Toc25402126)

[2    入门篇... 2](#_Toc25402127)

[3    配置篇nginx.conf 2](#_Toc25402128)

[3.1    配置文件结构... 2](#_Toc25402129)

[3.2    Nginx内部变量... 4](#_Toc25402130)

[3.3    Nginx配置语法... 5](#_Toc25402131)

[3.3.1     location和匹配优先级... 5](#_Toc25402132)

[3.3.2     rwrite语法... 6](#_Toc25402133)

[3.4    Nginx反向代理配置... 6](#_Toc25402134)

[3.4.1     wsgi配置... 6](#_Toc25402135)

[3.4.2     代理参数配置... 7](#_Toc25402136)

[3.5    Nginx负载均衡... 8](#_Toc25402137)

[3.6    Nginx限流... 9](#_Toc25402138)

[3.7    本章参考... 10](#_Toc25402139)

[4    原理篇... 10](#_Toc25402140)

[5    模块开发篇... 10](#_Toc25402141)

[参考资料... 10](#_Toc25402142)

 

 



 

---
# 1    简介

官网：http://nginx.org/

中文站： http://www.nginx.cn/doc/

nginx支持以下功能

* 反向代理
* 负载均衡
* 灰度更新版本

# 2   入门篇

## 常用命令

```sh
$ nginx -v  # 查看nginx版本
$ nginx -s reload  # 重新加载配置文件
$ nginx -s stop  # 关闭服务
$ nginx 		# 启动服务
$ nginx -t  	# 检测配置文件
```

**nginx控制信号**

可以使用信号系统来控制主进程。默认，nginx 将其主进程的 pid 写入到 /usr/local/nginx/nginx.pid 文件中。通过传递参数给 ./configure 或使用 **pid** 指令，来改变该文件的位置。

主进程可以处理以下的信号：

| TERM, INT | 快速关闭                                                   |
| --------- | ---------------------------------------------------------- |
| QUIT      | 从容关闭                                                   |
| HUP       | 重载配置  用新的配置开始新的工作进程  从容关闭旧的工作进程 |
| USR1      | 重新打开日志文件                                           |
| USR2      | 平滑升级可执行程序。                                       |
| WINCH     | 从容关闭工作进程                                           |

工作进程支持下面信号：

| TERM, INT | 快速关闭         |
| --------- | ---------------- |
| QUIT      | 从容关闭         |
| USR1      | 重新打开日志文件 |

**nginx重启命令**

nginx重启可以分成几种类型

1. 简单型，先关闭进程，修改你的配置后，重启进程。
```sh
    kill -QUIT `cat /usr/local/nginx/nginx.pid`
    sudo /usr/local/nginx/nginx
```
2. [重新加载配置文件，不重启进程，不会停止处理请求](http://www.nginx.cn/nginxchscommandline#reload config)
3. [平滑更新nginx二进制，不会停止处理请求](http://www.nginx.cn/nginxchscommandline#reload bin)



**nginx日志切割**

按指定格式重命名文件，然后执行下面命令重新生成日志

`kill -USR1 $(cat /usr/local/nginx/logs/nginx.pid) `



# 3    配置篇nginx.conf

## 3.1  配置基础

###  配置文件结构

区域：全局块 events http server location upstream

* 全局块：配置影响nginx全局的指令。一般有运行nginx服务器的用户组，nginx进程pid存放路径，日志存放路径，配置文件引入，允许生成worker process数等。
* events块：配置影响nginx服务器或与用户的网络连接。有每个进程的最大连接数，选取哪种事件驱动模型处理连接请求，是否允许同时接受多个网路连接，开启多个网络连接序列化等。
* http块：可以嵌套多个server，配置代理，缓存，日志定义等绝大多数功能和第三方模块的配置。如文件引入，mime-type定义，日志自定义，是否使用sendfile传输文件，连接超时时间，单连接请求数等。
* server块：配置虚拟主机的相关参数，一个http中可以有多个server。
* location块：配置请求的路由，以及各种页面的处理情况。
* upstream块：反向代理配置，指向后台应用服务器。

 

配置文件结构示例如下：
```nginx

...  #全局块
 
events {     # events块
  ...
} # END EVENT
 
http   #http块
{
  ...  #http全局块
  server    #server块
  { 
   ...    #server全局块
    location [PATTERN]  #location块
    {
     ...
    }
    location [PATTERN] 
    {
     ...
    }
  } # END SESRVER
  server
  {
   ...
  }
  ...   # http全局块
} # END HTTP
```

###　Nginx内部变量

表格 1 Nginx内部变量列表 （示例请求：curl -I http://test.wanglei.com/192.168.1.200?a=10  )

| 变量名称              | 变量用途                                                     | 示例值                                  |
| --------------------- | ------------------------------------------------------------ | --------------------------------------- |
| $atg_PARAMETER        | 客户端GET请求中  PARAMETER字段的值                           |                                         |
| $args                 | 客户端请求中的参数                                           | a=10                                    |
| $binary_remote_addr   | 远程地址的二进制表示                                         |                                         |
| $body_bytes_sent      | 已发送的消息体字节数                                         | 264                                     |
| $content_length       | HTTP请求信息里的Content-Length字段                           | 264                                     |
| $content_type         | 请求信息里的Content-Type字段                                 | text/html                               |
| $cookie_COOKIE        | 客户端请求中COOKIE头域的值                                   |                                         |
| $document_root        | 针对当前请求的根路径设置值                                   | /usr/local/nginx/html                   |
| $document_url         | 同$uri                                                       |                                         |
| $host                 | 请求信息中的Host头域值，如果请求中没有Host行，则等于设置的服务器名 |                                         |
| $hostname             | 表示Nginx所在的机器的名称,与gethostbyname调用返回的值相同    | centos7-201                             |
| $http_HEADER          | http请求信息中的HEADER字段                                   |                                         |
| $http_host            | 与$host相同，但如果请求信息中没有host行，则可能不同          |                                         |
| $http_cookie          | 客户端的cookie信息                                           |                                         |
| $http_referer         | 引用地址                                                     |                                         |
| $http_user_agent      | 客户端代理信息                                               | curl/7.29.0                             |
| $http_via             | 最后一个访问服务器的ip地址                                   |                                         |
| $http_x_forwarded_for | 相当于网络访问路径                                           |                                         |
| $is_args              | 如果$args有值，则等于"?";否则等于空                          | ?                                       |
| $limit_rate           | 对连接速率的限制。如配置: limit_rate 50k;                    | 51200                                   |
| $nginx_version        | 当前nginx服务器的版本                                        | 1.8.1                                   |
| $pid                  | 当前nginx服务器主进程的进程ID                                |                                         |
| $query_string         | 与$args相同                                                  | a=10                                    |
| $remote_addr          | 客户端ip地址                                                 | 192.168.1.200                           |
| $remote_port          | 表示客户端连接使用的端口,这个是随机的                        |                                         |
| $remote_user          | 客户端用户 名 用于AUth Basic Module验证                      |                                         |
| $request              | 客户端请求的头部信息                                         | HEAD /192.168.1.200?a=10 HTTP/1.1       |
| $request_time         | 返回从接受用户请求的第一个字节到发送完响应数据的时间，即包括接收请求数据时间、程序响应时间、输出响应数据时间。 | 0.012                                   |
| $request_body         | 客户端请求的报文体                                           | postman                                 |
| $request_body_file    | 发往后端服务器的本地临时缓存文件的名称                       |                                         |
| $request_filename     | 当前请求的文件路径名，由root或alias指令与URL请求生成         | /usr/local/nginx/html/<br>192.168.1.200 |
| $request_method       | 请求的方法 比如 GET POST等                                   | HEAD                                    |
| $response_time        | 返回从Nginx向后端(upstream)建立连接开始到接受完数据然后关闭连接为止的时间。 | 0.011                                   |
| $scheme               | 所用的协议 比如 http或者HTTPS 比如 rewrite ^(.+)$ $scheme://mysite.name$1 redirect | http、https                             |
| $server_addr          | 服务器地址，如果没有用listen指明服务器地址。使用这个变量将发起一次系统调用以取得地址 | 192.168.1.200                           |
| $server_name          | 服务器名称                                                   | test.wanglei.com                        |
| $server_port          | 请求到达的服务器端口号                                       | 80                                      |
| $server_protocol      | 请求的协议版本，HTTP/1.0   或http/1.1                        | HTTP/1.1                                |
| $status               | 客户端请求服务器的HTTP返回码                                 | 200                                     |
| $time_local           | 服务器当前的本地时间                                         | 25/Mar/2017:22:10:51 +0800              |
|                       |                                                              |                                         |
| $uri                  | 请求的不带请求参数的URL，可能和最初的值有不同，比如经过重定向之类的 | /192.168.1.200                          |
| $request_uri          | 表示客户端发来的原始URL,带完整的参数,$request_uri永远不会变,始终是用户的原始URL | /192.168.1.200?a=10                     |

 备注：1. $scheme://$host$uri



表格 nginx upstream变量

| 变量名称                 | 变量用途                                              | 示例值          |
| ------------------------ | ----------------------------------------------------- | --------------- |
| upstream_addr            | 上游服务器的IP地址                                    | 127.0.0.1：8012 |
| upstream_connect_time    | 与上游服务器建立连接花费的时间                        | 0.240           |
| upstream_header_time     | 接收上游服务发回响应中HTTP头部花费的时间              | 0.002           |
| upstream_response_time   | 接收完整上游服务响应花费时间                          | 0.242           |
| upstream_http            | 从上游服务返回响应头部的值                            |                 |
| upstream_bytes_received  | 从上游服务接收到的响应长度，单位为字节                |                 |
| upstream_response_length | 从上游服务返回响应包体长度                            |                 |
| upstream_status          | 从上游服务返回HTTP响应状态码。如果未连接上，则是502。 | 502             |
| upstream_cookie          | 从上游服务响应头set-cookie中取到的值                  |                 |
| upstream_trailer         | 从上游服务响应尾部取到的值                            |                 |

备注：request_time=upstream_connect_time + upstream_response_time （其中upstream_response_time > upstream_header_time）



###  Nginx配置语法 

#### location和匹配优先级

**location URL匹配规则**

语法:  locaton [=|~|~*|^~] /uri/ { }

说明：[]为可选符号，而且只能选择其中一个。如果不选，则缺省为 ^*的字符串匹配方式。
* = 精确匹配
* ^* 只匹配URL前半部分，不区分大小写。
* ~ 正则匹配，区分大小写。
* ~* 正则匹配，不区分大小写。
* * !~ 区分大小写不匹配
* !~* 不区分大小写不匹配
* location /uri  不带任何修饰符，表示前缀匹配，在正则匹配之后； 
* location /  通用匹配，任何未匹配到其他location的请求都会匹配到，相当于default； 



**匹配优先级**

匹配顺序： (location =) > (location 全部路径) > (location ^~ 前缀路径) > (location ~* 正则路径) > (location 前缀路径) > (location /)
* = 精确匹配
* 字符串匹配（位置无序）：按字符串从长到短匹配（最长匹配优先）。
* 正则匹配（位置有序）：正则匹配到一个，就不往下搜索。



**root和alias的差别**

root与alias主要区别在于nginx如何解释location后面的uri，这会使两者分别以不同的方式将请求映射到服务器文件上。
* root的处理结果是：root路径＋location路径
* alias的处理结果是：使用alias路径替换location路径

alias是一个目录别名的定义，root则是最上层目录的定义。alias必须以 / 结尾。

示例：客户端请求  /request_path/image/cat.png 

 ```nginx
location /request_path/image/ {
    root /local_path/;	  #实际访问路径:/local_path/request_path/image/cat.png
    alias /local_path/;   #实际访问路径:/local_path/cat.png
}
 ```



#### rwrite语法 

Rewrite主要的功能就是实现URL的重写，Nginx的Rewrite规则采用Pcre，perl兼容正则表达式的语法规则匹配，如果需要Nginx的Rewrite功能，在编译Nginx之前，需要编译安装PCRE库。

通过Rewrite规则，可以实现规范的URL、根据变量来做URL转向及选择配置。

**语法:** *rewrite <regex> <replacement> flag*

**默认:** *none*

**作用域:** *server, location, if*

Flags有下面四种:

-  last - 停止处理后续rewrite指令集，跳出location作用域，并开始搜索与更改后的URI相匹配的location
-  break - 停止处理后续rewrite指令集，不会跳出location作用域，不再进行重新查找，终止匹配
-  redirect - 302临时重定向，以http://开头
-  permanent - 301永久重定向

nginx rewrite指令执行顺序：
1.执行server块的rewrite指令
2.执行location匹配
3.执行选定的location中的rewrite指令

如果其中某步URI被重写，则重新循环执行1-3，直到找到真实存在的文件.

如果循环超过10次，则返回500 Internal Server Error错误

表格 rewrite相关指令

| 指令                                 | 默认值 | 使用范围                | 作用                                                         |
| ------------------------------------ | ------ | ----------------------- | ------------------------------------------------------------ |
| if ( condition ) 			{ ... } | none   | server，location        | 用于检测一个条件是否符合，符合则执行大括号内的语句。不支持嵌套，不支持多个条件&&或\|\|处理 |
| return                               | none   | server，if，location    | 用于结束规则的执行和返回状态码给客户端。状态码的值可以是：204,400,402~406,408,410,411,413,416以及500~504，另外非标准状态码444，表示以不发送任何的Header头来结束连接。 |
| uninitialized_variable_warn on\|off  | on     | http,server,location,if | 该指令用于开启和关闭未初始化变量的警告信息，默认值为开启。   |
| set variable value                   | none   |                         | 该指令用于定义一个变量，并且给变量进行赋值。变量的值可以是文本、一个变量或者变量和文本的联合，文本需要用引号引起来。 |

#### proxy_pass

语法： proxy_pass URL;

`URL=[协议]://[ip:port|domain][uri]`

**1. ProxyPass尾的 / 的区别**

* uri带/：表明是绝对路径，转发URL会去除location匹配部分。

* uri不带/：表明是相对路径，转发URL和原始URL一致

示例： 客户端请求  /api/example/get-result

```nginx
location ^~ /api/example {
	proxyPass http://ip1:port/new; #实际访问路径 http://ip1:port/new/get-result
	proxyPass http://ip2:port; 	#实际访问路径 http://ip2:port/api/example/get-result
}
```



## 3.2 配置示例

```nginx  
user  nobody;           #全局块
worker_processes  1;

events {    #events块
    worker_connections  1024;  
    use epoll;
}

http {  #http块
    include    mime.types;  #文件扩展名与文件类型映射表
    default_type application/octet-stream;  #默认文件类型，默认为text/plain
    #access_log off;  #取消服务日志  
    log_format myFormat ' $remote_addr–$remote_user [$time_local] $request $status $body_bytes_sent $http_referer $http_user_agent $http_x_forwarded_for'; #自定义格式
    access_log log/access.log myFormat; #combined为日志格式的默认值
    sendfile on;  #允许sendfile方式传输文件，默认为off，可以在http块，server块，location块。
    sendfile_max_chunk 100k; #每个进程每次调用传输数量不能大于设定的值，默认为0，即不设上限。
    keepalive_timeout 65; #连接超时时间，默认为75s，可以在http，server，location块。

    client_max_body_size 50m; #缓冲区代理缓冲用户端请求的最大字节数,可以理解为保存到本地再传给用户
    client_body_buffer_size 256k;
    client_header_timeout 3m;
    client_body_timeout 3m;
    proxy_ignore_headers "Expires" "Set-Cookie"; #Nginx服务器不处理设置的http相应投中的头域，这里空格隔开可以设置多个。
    proxy_intercept_errors on;  #如果被代理服务器返回的状态码为400或者大于400，设置的error_page配置起作用。默认为off。
    proxy_headers_hash_max_size 1024; #存放http报文头的哈希表容量上限，默认为512个字符。
    proxy_headers_hash_bucket_size 128; #nginx服务器申请存放http报文头的哈希表容量大小。默认为64个字符。
    proxy_next_upstream timeout; #反向代理upstream中设置的服务器组，出现故障时，被代理服务器返回的状态值。error|timeout|invalid_header|http_500|http_502|http_503|http_504|http_404|off
    #proxy_ssl_session_reuse on; 默认为on，如果我们在错误日志中发现“SSL3_GET_FINSHED:digest check failed”的情况时，可以将该指令设置为off。
    proxy_buffer_size 64k; #设置代理服务器（nginx）保存用户头信息的缓冲区大小
    proxy_buffers 4 32k; # proxy_buffers缓冲区，网页平均在32k以下的话，这样设置
    proxy_busy_buffers_size 64k; #高负荷下缓冲大小（proxy_buffers*2）
    proxy_temp_file_write_size 64k; #设定缓存文件夹大小，大于这个值，将从upstream服务器传递请求，而不缓冲到磁盘

    server {    #server块
        listen       80;
        server_name  localhost;

        location / {
            root   html;
            index  index.html index.htm;
        }

        location /tomcat/ { 
            proxy_pass http://127.0.0.1:8080;
        }
    }
}
```



### 网页重定向

1. http重定向到https：需要添加证书

2. www.xxx.com/bbs  -->  bbs.xxx.com

   ```nginx
   server {
       server_name www.xxx.com;
       rewrite ^/bbs$ http://www.xxx.com permanent;  #permanent永久重定向，返回301
       location / { ... }
   }
   ```

3. bbs.xxx.com  --> www.xxx.com/bbs

   ```nginx
   server {
       server_name www.xxx.com bbs.xxx.com;
       if ( $host == 'bbs.xxx.com'){
       		rewrite ^/(.*)$ http://www.xxx.com/bbs/$1 permanent;
           }
       location / { ... }
   }
   ```

   

### 防盗链

```nginx
location ~* \.(gif|jpg|png|swf|flv)$ {
    root html; #root如果在server{}中有设置可以不需要设定	
    valid_referers none blocked *.nginxcn.com;
    if ($invalid_referer) {
    rewrite ^/ www.nginx.cn
    #return 404;
    }
}
```

###  长连接配置

长连接分二种：

* 客户端连接nginx：默认开启，缺省超时为65s
* nginx连接后端服务器：使用连接池

```nginx
# nginx
keepalive_timeout 65;  # 缺省长连接
location /api/ {
    proxy_pass http://ip:port;
    keepalive 300;  #连接池的空闲连接数
}
```

### 事件模型

use指令指定事件模型，例如 `use epoll`

| 模型      | 功能                                                         |
| --------- | ------------------------------------------------------------ |
| select    | 标准方法。 如果当前平台没有更有效的方法，它是编译时默认的方法。 |
| poll      | 标准方法。 如果当前平台没有更有效的方法，它是编译时默认的方法。你可以使用配置参数--with-poll_module  和 --without-poll_module 来启用或禁用这个模块。 |
| kqueue    | 高效的方法，使用于 FreeBSD 4.1+, OpenBSD 2.9+, NetBSD 2.0 和 MacOS X. 使用双处理器的MacOS X系统使用kqueue可能会造成内核崩溃。 |
| epoll     | 高效的方法，使用于Linux内核2.6版本及以后的系统。在某些发行版本中，如SuSE 8.2, 有让2.4版本的内核支持epoll的补丁。 |
| rtsig     | 可执行的实时信号，使用于Linux内核版本2.2.19以后的系统。默认情况下整个系统中不能出现大于1024个POSIX实时(排队)信号。 |
| /dev/null | 高效的方法，使用于 Solaris 7 11/99+, HP/UX 11.22+ (eventport), IRIX 6.5.15+ 和 Tru64 UNIX 5.1A+. |
| eventport | 高效的方法，使用于 Solaris 10. 为了防止出现内核崩溃的问题， 有必要安装 [这个](http://sunsolve.sun.com/search/document.do?assetkey=1-26-102485-1)  安全补丁。 |



###  启用nginx状态

配置开关 --with-http_stub_status_module

```nginx
        location /ngx_status
        {
            stub_status on;
            access_log off;
            #allow 127.0.0.1;
            #deny all;
        }
```

```sh
$ curl http://127.0.0.1/ngx_status
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    97  100    97    0     0     97      0  0:00:01 --:--:--  0:00:01 97000Active connections: 1
server accepts handled requests
 3 3 3
Reading: 0 Writing: 1 Waiting: 0
```





## 3.4   Nginx反向代理配置

### 3.4.2 wsgi配置

**1. 使用uwsgi**

`$ sudo apt-get install uwsgi-plugin-python`

**示例：通过域名xx.com访问flask应用abc**

**代码目录**

```sh        
├── env
│  ├── bin
│  ├── include
│  ├── lib
│  └── local
├── runserver.py
└── abc
  ├── __init__.py
  ├── models.py
  ├── static
  ├── templates
  └── views.py
```

**/etc/nginx/nginx.conf**
```nginx
http {
  ...
  #include /etc/nginx/conf.d/*.conf;
  include /etc/nginx/sites-enabled/*.conf;
}
```

**/etc/nginx/sites-enabled/www.xxx.com.conf**
```nginx
server {
  listen 80;
  server_name www.xxx.com xxx.com;
  access_log /var/log/nginx/www.xxx.com.access.log;
  error_log /var/log/nginx/www.xxx.com.error.log;
  location /
  {
    include uwsgi_params;
    uwsgi_pass unix:///tmp/uwsgi_www.xxx.com.sock;
  }
}
```


**/etc/uwsgi/apps-enabled/www.xxx.com.ini**
```ini
[uwsgi]
plugins = python
vhost = true
chmod-socket = 666
socket = /tmp/uwsgi_www.xxx.com.sock
venv = /var/www/www.xxx.com/env
chdir = /var/www/www.xxx.com
module = runserver
callable = app
```


**2. gunicorn**

说明：$开头是nginx的内置变量。
```nginx
location /random {
  proxy_pass http://127.0.0.1:8080;  # 反向代理
  proxy_set_header  X-Real-IP      $remote_addr;
  proxy_set_header  X-Forwarded-For   $proxy_add_x_forwarded_for;
  proxy_set_header  Host        $http_host;
  proxy_set_header  X-NginX-Proxy    true;
  proxy_set_header  Connection      "";
  proxy_http_version 1.1;
}
```


### 3.4.2 代理参数配置

upstream后端服务器代理参数设置
```nginx
  proxy_pass http://127.0.0.1:8080;  # 反向代理
     include proxy_params
}
 
  # proxy_params 文件
  proxy_set_header  X-Real-IP      $remote_addr; # 获取请求端真实IP
  proxy_set_header  X-Forwarded-For   $proxy_add_x_forwarded_for;
  proxy_set_header  Host        $http_host;
  proxy_set_header  Connection      "";
  proxy_connect_timeout 1;  # nginx服务器与被代理的服务器建立连接的超时时间，默认60秒。
  proxy_read_timeout 1;  # nginx服务器想被代理服务器组发出read请求后，等待响应的超时间，默认为60秒。
  proxy_send_timeout 1;  # nginx服务器想被代理服务器组发出write请求后，等待响应的超时间，默认为60秒。
  proxy_ignore_client_abort on; # 客户端断网时，nginx服务器是否终断对被代理服务器的请求。默认为off。
```



## 3.5   Nginx负载均衡

**Nginx的upstream目前支持3种方式的分配**

* 轮询（默认）： 每个请求按时间顺序逐一分配到不同的后端服务器，如果后端服务器down掉，能自动剔除。
* weight：指定轮询几率，weight和访问比率成正比，用于后端服务器性能不均的情况。
* ip_hash： 每个请求按访问ip的hash结果分配，这样每个访客固定访问一个后端服务器，可以解决session的问题。
* fair（第三方） ：按后端服务器的响应时间来分配请求，响应时间短的优先分配。 
* url_hash（第三方）

**示例1：权重**

```nginx
upstream bbs.linuxtone.org {  # 定义负载均衡设备的Ip及设备状态 
    server 127.0.0.1:9090 down;  # 表示单前的server暂时不参与负载
    server 127.0.0.1:8080 weight=2;  # 默认为1.weight越大，负载的权重就越大
    server 127.0.0.1:6060; 
    server 127.0.0.1:7070 backup;  # 热备
}
```

每个设备的状态设置为:

* down 表示单前的server暂时不参与负载
* weight 默认为1.weight越大，负载的权重就越大。
* max_fails ：允许请求失败的次数默认为1.当超过最大次数时，返回proxy_next_upstream 模块定义的错误
* fail_timeout: max_fails次失败后，暂停的时间。
* backup： 其它所有的非backup

 

**示例2：ip_hash**
```nginx
upstream backend {
  ip_hash;
  server backend1.example.com;
  server backend2.example.com;
  server backend3.example.com down;
}
```


## 3.6   Nginx限流

限流算法：令牌桶算法、漏洞算法

Nginx按请求速率限速模块使用的是漏桶算法，即能够强行保证请求的实时处理速度不会超过设置的阈值， 超量请求会被丢弃。

Nginx官方版本限制IP的连接和并发分别有两个模块：
* limit_req_zone 用来限制单位时间内的请求数，即速率限制,采用的漏桶算法 "leaky bucket"。
* limit_req_conn 用来限制同一时间连接数，即并发限制。

 

$binary_remote_addr 每个独立IP

**示例1：限制访问速率**
```nginx
limit_req_zone $binary_remote_addr zone=mylimit:10m rate=2r/s; #10m区域，2次/秒
server { 
  location / { 
    limit_req zone=mylimit;
  }
}
```


**实例2： burst缓存处理**
```nginx
limit_req_zone $binary_remote_addr zone=mylimit:10m rate=2r/s;
server { 
  location / { 
    limit_req zone=mylimit burst=4 nodelay; # burst缓存请求4个，不延迟
    limit_req_status 598;   # 自定义错误返回状态码
  }
}
```


**实例3：限制并发连接**
```NGINX
limit_conn_zone $binary_remote_addr zone=addr:10m;
server {
  location /download/ {
    limit_conn addr 1;  # 限制一个并发
  }
}
```

## 3.7  Nginx灰度发布

灰度发布是指在黑与白之间，能够平滑过渡的一种发布方式。AB test就是一种灰度发布方式，让一部分用户继续用A，一部分用户开始用B，如果用户对B没有什么反对意见，那么逐步扩大范围，把所有用户都迁移到B上面来。

灰度发布可以保证整体系统的稳定，在初始灰度的时候就可以发现、调整问题，以保证其影响度。

Nginx的灰度发布的常用方式如下：

* 基于IP
* 基于 gip的地理位置限制
* 根据cookie、headers，需要依赖nginx_lua模块



### 基于IP
如果是内部IP，则反向代理到serv_grav(预发布环境)；如果不是则反向代理到serv_prod(生产环境)。
```nginx
upstream serv_prod {
    server 192.168.1.100:8080 max_fails=1 fail_timeout=60;
}
upstream serv_grav {
    server 192.168.1.200:8080 max_fails=1 fail_timeout=60;
}


server {
  listen 80;
  server_name  www.xxx.com;
  access_log  logs/www.xxx.com.log  main;

  set $group serv_prod;
  if ($remote_addr ~ "211.118.119.11") {    # 对于测试IP，指向预发布环境
      set $group serv_grav;
  }

location / {                       
    proxy_pass http://$group;
    proxy_set_header   Host             $host;
    proxy_set_header   X-Real-IP        $remote_addr;
    proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
    index  index.html index.htm;
  }
}
```

如果你只有单台服务器，可以根据不同的IP设置不同的网站根目录来达到相同的目的。
```nginx
server {
  listen 80;
  server_name  www.xxx.com;
  access_log  logs/www.xxx.com.log  main;

  set $rootdir "/var/www/html";
    if ($remote_addr ~ "211.118.119.11") {  # 对于测试IP，指向不同目录
       set $rootdir "/var/www/test";
    }

    location / {
      root $rootdir;
    }
}
```



## 本章参考

[1]: https://blog.csdn.net/weixin_43328213/article/details/87913328  "nginx几种网页重定向（rewirte）的配置"
[2]: https://www.cnblogs.com/biglittleant/p/8979915.html  "死磕nginx系列--nginx 限流配置 "
[3]:  https://www.cnblogs.com/weifeng1463/p/7353710.html  "使用nginx实现灰度"




# 4  原理篇

 

# 5  模块开发篇

 

# 参考资料

[1].   nginx基本配置与参数说明 [www.nginx.cn/76.html](http://www.nginx.cn/76.html) 

[2].   nginx的rewrite开发实例解析 https://www.2cto.com/kf/201711/548951.html 
