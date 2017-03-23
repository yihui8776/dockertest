# dockertest
# Dockerfile详细解析，centos7base镜像

FROM daocloud.io/centos:7
  ● 基于父镜像构建其他docker镜像，父镜像：可以通过docker pull 命令获得，也可以自己制作
MAINTAINER yihui <wangyaohui8776@sina.com>
  ● Dockerfile维护者
ENV TZ "Asia/Shanghai"
  ● ENV（environment）设置环境变量，一个Dockerfile中可以写多个。以上例子是：设置docker容器的时区为Shanghai
Dockerfile中有2条指令可以拷贝文件
ADD aliyun-mirror.repo /etc/yum.repos.d/CentOS-Base.repo
  ● 拷贝本地文件到docker容器里，还可以拷贝URL链接地址下的文件，ADD还具有解压软件包的功能(支持gzip, bzip2 or xz)
COPY test /mydir
  ● 拷贝本地文件到docker容器
安装linux软件包
RUN yum install -y curl wget....
  ● RUN命令，非常类似linux下的shell命令 (the command is run in a shell – /bin/sh -c – shell form)
在Dockerfile中每执行一条指令（ENV、ADD、RUN等命令），都会生成一个docker image layer
RUN pip install supervisor
  ● 安装supervisor进程管理系统，推荐使用
  ● (Supervisor是一个进程管理工具:有一个进程需要每时每刻不断的跑，但是这个进程又有可能由于各种原因有可能中断。当进程中断的时候我希望能自动重新启动它，此时，我就需要使用到了Supervisor)
ADD supervisord.conf /etc/supervisord.conf
  ● 添加supervisor的主配置文件，到docker容器里
RUN mkdir -p /etc/supervisor.conf.d
  ● 创建存放启动其他服务”supervisor.conf”的目录，此目录下的所有以.conf结尾的文件，在启动docker容器的时候会被加载
端口映射
EXPOSE 22
  ● 端口映射 EXPOSE <host_port>:<container_port>
  ● 推荐使用docker run -p <host_port>:<container_port>来固化端口

容器启动时执行的命令
ENTRYPOINT [“/usr/bin/supervisord”, “-n”, “-c”, “/etc/supervisord.conf”]
  ● 一个Dockerfile中只有最后一条ENTRYPOINT生效，并且每次启动docker容器，都会执行ENTRYPOINT

#或者用CMD,类似的，也是只有最后一条CMD生效
# 执行supervisord来同时执行多个命令，使用 supervisord 的可执行路径启动服务。CMD ["/usr/bin/supervisord"]
