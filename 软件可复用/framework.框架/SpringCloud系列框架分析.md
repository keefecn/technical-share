| 序号 | 修改时间   | 修改内容                         | 修改人 | 审稿人 |
| ---- | ---------- | -------------------------------- | ------ | ------ |
| 1    | 2019-11-22 | 创建。从《分布式框架分析》拆分。 | 吴启福 |        |
|      |            |                                  |        |        |
---

 

 

 

 

# 目录

[目录... 1](#_Toc25396736)

[1       Spring框架概述... 2](#_Toc25396737)

[2       Spring Boot. 2](#_Toc25396738)

[3       Spring Cloud. 3](#_Toc25396739)

[3.1        Spring Cloud架构... 3](#_Toc25396740)

[3.2        Spring Cloud 工具框架... 5](#_Toc25396741)

[3.3        Spring cloud配置... 5](#_Toc25396742)

[参考资料... 6](#_Toc25396743)

 


 

 

 

 

# 1       Spring框架概述

微服务是一种架构的理念，提出了微服务的设计原则，从理论为具体的技术落地提供了指导思想。

*  Spring **Boot** 是一套快速配置脚手架，可以基于 Spring Boot 快速开发单个微服务。

*  Spring **Cloud** 是一个基于 Spring Boot 实现的服务治理工具包;Spring Boot 专注于快速、方便集成的单个微服务个体;Spring Cloud 关注全局的服务治理框架。

Spring Boot / Cloud 是微服务实践的最佳落地方案。

# 2       Spring Boot

Spring Boot 是一套快速配置脚手架，可以基于 Spring Boot 快速开发单个微服务。

Spring Boot基于Spring platform对Spring框架和第三方库进行处理，提供默认配置以降低使用复杂度，可轻松创建单独运行的、基于生产级的Spring应用程序。

Spring Boot基于Maven构建。

 

**Eclipse****集成****Spring Intializer**

安装方式：Eclipse Marketplace -> 搜索 STS

新建Spring项目：New -> Spring Starter Project

 

![Srping Boot 2.0.png](../../media/sf_reuse/framework/frame_springboot_001.png)

图 1 Sprint Boot 2.0框架

 

# 3       Spring Cloud

Spring Cloud 是一系列框架的有序集合，它利用 Spring Boot 的开发便利性巧妙地简化了分布式系统基础设施的开发，如服务发现注册、配置中心、消息总线、负载均衡、断路器、数据监控等，都可以用 Spring Boot 的开发风格做到一键启动和部署。

## 3.1     Spring Cloud架构

**Spring Cloud** **的核心功能：**

*  分布式/版本化配置。
*  服务注册和发现。
*  路由。
*  服务和服务之间的调用。
*  负载均衡。
*  断路器。
*  分布式消息传递。

 

![Spring Cloud.png](../../media/sf_reuse/framework/frame_springcloud_002.png)

 

![Spring Cloud组件架构.jpg](../../media/sf_reuse/framework/frame_springcloud_001.png)

图 2 Spring Cloud组件架构

 

各组件的运行流程：

*  所有请求都统一通过 API 网关(Zuul)来访问内部服务。

*  网关接收到请求后，从注册中心(Eureka)获取可用服务。
*  由 Ribbon 进行均衡负载后，分发到后端的具体实例。
*  微服务之间通过 Feign 进行通信处理业务。
*  Hystrix 负责处理服务超时熔断。
*  Turbine 监控服务间的调用和熔断相关指标。

 

## 3.2     Spring Cloud 工具框架

Spring Cloud 共集成了 19 个子项目，里面都包含一个或者多个第三方的组件或者框架!

- Spring Cloud Config，配置中心，利用 git 集中管理程序的配置。
- Spring Cloud Netflix，集成众多 Netflix 的开源软件。
- Spring Cloud Bus，消息总线，利用分布式消息将服务和服务实例连接在一起，用于在一个集群中传播状态的变化      。
- Spring Cloud for Cloud Foundry，利用 Pivotal Cloudfoundry 集成你的应用程序。
- Spring Cloud Foundry Service Broker，为建立管理云托管服务的服务代理提供了一个起点。
- Spring Cloud Cluster，基于 Zookeeper、Redis、Hazelcast、Consul 实现的领导选举和平民状态模式的抽象和实现。
- Spring Cloud Consul，基于 Hashicorp Consul 实现的服务发现和配置管理。
- Spring Cloud Security，在 Zuul 代理中为 OAuth2 rest 客户端和认证头转发提供负载均衡。
- Spring Cloud Sleuth Spring Cloud，应用的分布式追踪系统和 Zipkin、HTrace、ELK      兼容。
- Spring Cloud Data Flow，一个云本地程序和操作模型，组成数据微服务在一个结构化的平台上。
- Spring Cloud Stream，基于 Redis、Rabbit、Kafka      实现的消息微服务，简单声明模型用以在 Spring Cloud 应用中收发消息。
- Spring Cloud Stream App Starters，基于      Spring Boot 为外部系统提供 Spring 的集成。
- Spring Cloud Task，短生命周期的微服务，为 Spring Boot 应用简单声明添加功能和非功能特性。
- Spring Cloud Task App Starters。
- Spring Cloud Zookeeper，服务发现和配置管理基于 Apache Zookeeper。
- Spring Cloud for Amazon Web Services，快速和亚马逊网络服务集成。
- Spring Cloud Connectors，便于 PaaS 应用在各种平台上连接到后端像数据库和消息经纪服务。
- Spring Cloud Starters，项目已经终止并且在 Angel.SR2 后的版本和其他项目合并。
- Spring Cloud CLI，插件用 Groovy 快速的创建 Spring Cloud 组件应用。

## 3.3     Spring cloud配置

Spring cloud包含两个基本模块，spring cloud context和spring cloud commons。
*  spring cloud context即spring cloud应用上下文，包含引导上下文(加载bootstrap配置)、配置加密、配置刷新范围(RefreshScope)、控制端点(/env/reset，/refresh，/restart等)功能。
*  Spring cloud commons 提供服务注册发现，负载均衡，断路器等模式的一个共用抽象层，为具体现实提供统一抽象。
 

实际应用过程中，我们使用了

*  spring cloud consul 作为服务注册和发现组件
*  spring cloud config 作为分布式/版本化配置管理
*  spring cloud bus 作为消息总线用于刷新分布式应用配置
*  spring boot admin 作为统一的应用监控后台
*  spring cloud Netflix feign  作为rest服务调用client
*  spring cloud Netflix zuu*  作为路由、过滤网关
*  spring cloud consul

 

# 4       实例



## 4.1     Docker-Compose编排微服务实例

来源： https://github.com/itmuch/spring-cloud-docker-microservice-book-code-docker/blob/Edgware/docker-3-complex/pom.xml 

 

表格 1 实例中微服务列表

| 微服务项目名称                             | 项目微服务中的角色 |
| ------------------------------------------ | ------------------ |
| microservice-discovery-eureka-ha           | 服务发现组件       |
| microservice-provider-user                 | 服务提供者         |
| microservice-consumer-movie-ribbon-hystrix | 服务消费者         |
| microservice-gateway-zuu*                  | API Gateway        |
| microservice-hystrix-turbine               | Hystrix聚合工具    |

 

### 4.1.1  执行步骤

1)         编辑pom.xml

2)         每个项目的根目录执行以下命令，构建docker镜像

mvn clean package docker:build

3)         编辑docker-compose.yml

4)         启动

docker-compose up

 

测试

*  高可用测试

*  动态扩缩容

docker-compose scale [proj=num]

如 docker-compose scale microservice-provider-user=3

### 4.1.2  pom.xml 

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.itmuch.cloud</groupId>
  <artifactId>parent</artifactId>
  <version>0.0.1-SNAPSHOT</version>
  <packaging>pom</packaging>

  <modules>
    <module>microservice-consumer-movie-ribbon-hystrix</module>
	<module>microservice-discovery-eureka-ha</module>
	<module>microservice-gateway-zuul</module>
	<module>microservice-hystrix-turbine</module>
	<module>microservice-provider-user</module>
  </modules>
  
  <build>
    <plugins>
      <!-- 添加docker-maven插件 -->
      <plugin>
        <groupId>com.spotify</groupId>
        <artifactId>docker-maven-plugin</artifactId>
        <version>0.4.13</version>
        <configuration>
          <imageName>itmuch/${project.artifactId}:${project.version}</imageName>
          <forceTags>true</forceTags>
          <baseImage>java</baseImage>
          <entryPoint>["java", "-jar", "/${project.build.finalName}.jar"]</entryPoint>
          <resources>
            <resource>
              <targetPath>/</targetPath>
              <directory>${project.build.directory}</directory>
              <include>${project.build.finalName}.jar</include>
            </resource>
          </resources>
        </configuration>
      </plugin>
    </plugins>
  </build>
</project>

```



说明:

<imageName>itmuch/${project.artifactId}:${project.version}</imageName>  # 镜像名称

<entryPoint>["java", "-jar", "/${project.build.finalName}.jar"]</entryPoint>  # 镜像的入口命令

### 4.1.3  docker-compose.yml

```yaml
version: "3"
services:
  peer1:
    image: itmuch/microservice-discovery-eureka-ha:0.0.1-SNAPSHOT
    ports:
      - "8761:8761"
    environment:
      - spring.profiles.active=peer1
  peer2:
    image: itmuch/microservice-discovery-eureka-ha:0.0.1-SNAPSHOT
    hostname: peer2  # 重置此镜像的容器名称，避免循环依赖
    ports:
      - "8762:8762"
    environment:
      - spring.profiles.active=peer2
  microservice-provider-user:
    image: itmuch/microservice-provider-user:0.0.1-SNAPSHOT
  microservice-consumer-movie-ribbon-hystrix:
    image: itmuch/microservice-consumer-movie-ribbon-hystrix:0.0.1-SNAPSHOT
  microservice-gateway-zuul:
    image: itmuch/microservice-gateway-zuul:0.0.1-SNAPSHOT
  microservice-hystrix-turbine:
    image: itmuch/microservice-hystrix-turbine:0.0.1-SNAPSHOT

```



说明：
 双节点的Eureka Server集群。

# 参考资料

**官网**

[1].     https://spring.io/ 

[2].     [Spring Boot Reference Manual](https://docs.spring.io/spring-boot/docs/current-SNAPSHOT/reference/htmlsingle/) 

[3].     [Spring Cloud Reference Manual](https://cloud.spring.io/spring-cloud-static/current/) 

 

参考文献

[1].     《Spring Cloud与Docke微服务架构实战》v2 https://github.com/itmuch/spring-cloud-docker-microservice-book-code-docker/blob/Edgware/docker-3-complex/pom.xml 

[2].     http://docs.docker.com/composq/faq 

 