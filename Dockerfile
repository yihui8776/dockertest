###########################################
# version : yihui/dockertest:v1
# desc : 当前版本安装的ssh，wget，curl，supervisor ，vim ，python等环境依赖
#############################################
# 设置继承自centos7官方镜像
FROM       daocloud.io/centos:7
# Dockerfile维护者
MAINTAINER yihui <wangyaohui8776@sina.com>

ENV TZ "Asia/Shanghai"
ENV TERM xterm

#拷贝本地文件到docker里
#ADD aliyun-mirror.repo /etc/yum.repos.d/CentOS-Base.repo
#ADD aliyun-epel.repo /etc/yum.repos.d/epel.repo


#安装软件和依赖
RUN yum update -y
RUN yum install -y curl wget tar bzip2 unzip vim-enhanced passwd sudo yum-utils hostname net-tools rsync man
RUN yum install -y gcc gcc-c++ git make automake cmake patch libpng-devel libjpeg-devel

#安装python3

#RUN wget https://www.python.org/ftp/python/3.4.1/Python-3.4.1.tgz
#RUN tar zxvf Python-3.4.1.tgz
#RUN cd Python-3.4.1

#RUN ./configure
#RUN make && make install
#RUN mv /usr/bin/python  /usr/bin/python_old
#RUN ln -s Python-3.4.1/bin/python /usr/bin/python

#安装pip
#RUN wget https://pypi.python.org/packages/41/27/9a8d24e1b55bd8c85e4d022da2922cb206f183e2d18fee4e320c9547e751/pip-8.1.1.tar.gz#md5=6b86f11841e89c8241d689956ba99ed7
#RUN tar vxf pip-8.1.1.tar.gz 
#RUN python ./pip-8.1.1/setup.py install
#RUN yum install -y --enablerepo=epel pwgen python-pip
RUN yum install -y epel-release 
RUN yum install -y python-pip
RUN yum clean all

RUN  yum install -y  openssh-server
RUN  mkdir -p /var/run/sshd

# 将sshd的UsePAM参数设置成no
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

# 添加测试用户admin，密码admin，并且将此用户添加到sudoers里
RUN useradd admin
RUN echo "admin:admin" | chpasswd
RUN echo "admin   ALL=(ALL)       ALL" >> /etc/sudoers
#安装supervisor进程管理
RUN pip install supervisor
ADD supervisord.conf /etc/supervisord.conf

#创建存放启动其他服务”supervisor.conf”的目录，此目录下的所有以.conf结尾的文件，在启动#docker容器的时候会被加载
RUN mkdir -p /etc/supervisor.conf.d && \
    mkdir -p /var/log/supervisor

EXPOSE 22

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]

