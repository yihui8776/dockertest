
#MySQL容器镜像

FROMM centos:centos6
#编写者
MAINTAINER yihui "wangyaohui8776@sina.com"
#安装mysql
RUN yum install -y mysql-server mysql
#配置初始化
RUN /etc/init.d/mysqld start &&\
    mysql -e "grant all privileges on *.* to 'root'@'%' identified by 'letmein';"&&\
    mysql -e "grant all privileges on *.* to 'root'@'localhost' identified by 'letmein';"&&\
    mysql -u root -pletmein -e "show databases;"
#打开端口
EXPOSE 3306
#运行启动
CMD ["/usr/bin/mysqld_safe"]

