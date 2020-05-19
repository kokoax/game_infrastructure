FROM amazonlinux:2

RUN yum localinstall http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm -y \
    && yum update -y \
    && yum install systemd-sysv -y \
    && yum install make -y \
    && yum install python3-pip -y \
    && yum install git -y \
    && pip3 install --upgrade pip \
    && pip3 install ansible \ 
    && pip3 install awscli \ 
    && echo 'alias python=python3' >> /root/.bashrc \
    && yum clean all


CMD ["/sbin/init"]
