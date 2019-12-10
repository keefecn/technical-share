| 序号 | 修改时间  | 修改内容                                   | 修改人 | 审稿人 |      |
| ---- | --------- | ------------------------------------------ | ------ | ------ | ---- |
| 1    | 2019-5-11 | 创建。从《网站架构设计》抽取相关章节成文。 | 吴启福 |        |      |

 

 

 

 

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

 

 



 

 

# 1    简介

nginx支持以下功能
* 反向代理
* 负载均衡
* 灰度更新版本

# 2   入门篇

```sh
nginx -s reload  # 重新加载配置文件
nginx -s stop  # 关闭服务
nginx 		# 启动服务
nginx -t  	# 检测配置文件
```



# 3    配置篇nginx.conf

## 3.1   配置文件结构

区域：全局块 events http server location upstream

* 全局块：配置影响nginx全局的指令。一般有运行nginx服务器的用户组，nginx进程pid存放路径，日志存放路径，配置文件引入，允许生成worker process数等。
* events块：配置影响nginx服务器或与用户的网络连接。有每个进程的最大连接数，选取哪种事件驱动模型处理连接请求，是否允许同时接受多个网路连接，开启多个网络连接序列化等。
* http块：可以嵌套多个server，配置代理，缓存，日志定义等绝大多数功能和第三方模块的配置。如文件引入，mime-type定义，日志自定义，是否使用sendfile传输文件，连接超时时间，单连接请求数等。
* server块：配置虚拟主机的相关参数，一个http中可以有多个server。
* location块：配置请求的路由，以及各种页面的处理情况。
* upstream块：反向代理配置，指向后台应用服务器。

 

配置文件结构示例如下：
```nginx...  #全局块
 
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


**配置示例**
```nginx  include    mime.types;  #文件扩展名与文件类型映射表
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
```


## 3.2   Nginx内部变量

表格 1 Nginx内部变量列表

| 变量名称              | 变量用途                                                     |
| --------------------- | ------------------------------------------------------------ |
| $atg_PARAMETER        | 客户端GET请求中  PARAMETER字段的值                           |
| $args                 | 客户端请求中的参数                                           |
| $binary_remote_addr   | 远程地址的二进制表示                                         |
| $body_bytes_sent      | 已发送的消息体字节数                                         |
| $content_length       | HTTP请求信息里的Content-Length字段                           |
| $content_type         | 请求信息里的Content-Type字段                                 |
| $cookie_COOKIE        | 客户端请求中COOKIE头域的值                                   |
| $document_root        | 针对当前请求的根路径设置值                                   |
| $host                 | 请求信息中的Host头域值，如果请求中没有Host行，则等于设置的服务器名 |
| $http_HEADER          | http请求信息中的HEADER字段                                   |
| $http_host            | 与$host相同，但如果请求信息中没有host行，则可能不同          |
| $http_cookie          | 客户端的cookie信息                                           |
| $http_referer         | 引用地址                                                     |
| $http_user_agent      | 客户端代理信息                                               |
| $http_via             | 最后一个访问服务器的ip地址                                   |
| $http_x_forwarded_for | 相当于网络访问路径                                           |
| $is_args              | 如果$args有值，则等于"?";否则等于空                          |
| $limit_rate           | 对连接速率的限制                                             |
| $nginx_version        | 当前nginx服务器的版本                                        |
| $pid                  | 当前nginx服务器主进程的进程ID                                |
| $query_string         | 与$args相同                                                  |
| $remote_addr          | 客户端ip地址                                                 |
| $remote_port          | 客户端端口号                                                 |
| $remote_user          | 客户端用户 名 用于AUth Basic Module验证                      |
| $request              | 客户端请求                                                   |
| $request_body         | 客户端请求的报文体                                           |
| $request_body_file    | 发往后端服务器的本地临时缓存文件的名称                       |
| $request_filename     | 当前请求的文件路径名，由root或alias指令与URL请求生成         |
| $request_method       | 请求的方法 比如 GET POST等                                   |
| $scheme               | 所用的协议 比如 http或者HTTPS 比如 rewrite ^(.+)$ $scheme://mysite.name$1 redirect |
| $server_addr          | 服务器地址，如果没有用listen指明服务器地址。使用这个变量将发起一次系统调用以取得地址 |
| $server_port          | 请求到达的服务器端口号                                       |
| $server_protocol      | 请求的协议版本，HTTP/1.0   或http/1.1                        |
| $uri                  | 请求的不带请求参数的URL，可能和最初的值有不同，比如经过重定向之类的 |

 

## 3.3   Nginx配置语法 

### 3.3.1 location和匹配优先级

**location URL匹配规则**

语法: locaton [=|~|~*|^~] /uri/ { }

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



**location和alias的差别**

root与alias主要区别在于nginx如何解释location后面的uri，这会使两者分别以不同的方式将请求映射到服务器文件上。
* root的处理结果是：root路径＋location路径
* alias的处理结果是：使用alias路径替换location路径

alias是一个目录别名的定义，root则是最上层目录的定义。alias必须以 / 结尾。

 

### 3.3.2 rwrite语法 

nginx rewrite指令执行顺序：
1.执行server块的rewrite指令
2.执行location匹配
3.执行选定的location中的rewrite指令

如果其中某步URI被重写，则重新循环执行1-3，直到找到真实存在的文件.

如果循环超过10次，则返回500 Internal Server Error错误

 

### 3.3.3 网页重定向

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

   

## 3.4   Nginx反向代理配置

### 3.4.1 wsgi配置

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

Nginx按请求速率限速模块使用的是漏桶算法，即能够强行保证请求的实时处理速度不会超过设置的阈值。

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

## FAQ

**1. ProxyPass尾的/的区别**

示例如下： 
```nginx
proxyPass http://ip:port/; # 表明是绝对路径，转发URL会去除location匹配部分。
proxyPass http://ip:port; # 表明是相对路径，转发URL和原始URL一致。
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
